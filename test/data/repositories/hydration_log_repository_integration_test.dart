import 'package:flutter_test/flutter_test.dart';
import 'package:hydrate_or_die/data/data_sources/local/database_helper.dart';
import 'package:hydrate_or_die/data/data_sources/local/hydration_log_local_data_source.dart';
import 'package:hydrate_or_die/data/repositories/hydration_log_repository_impl.dart';
import 'package:hydrate_or_die/domain/entities/glass_size.dart';
import 'package:hydrate_or_die/domain/entities/hydration_log.dart';
import 'package:hydrate_or_die/domain/repositories/hydration_log_repository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Integration tests for HydrationLogRepository with real SQLite
///
/// These tests verify the full repository stack works correctly.
void main() {
  late DatabaseHelper databaseHelper;
  late HydrationLogRepository repository;

  setUpAll(() {
    // Initialize FFI for desktop/unit testing
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    // Initialize in-memory database for testing
    TestWidgetsFlutterBinding.ensureInitialized();

    // Create fresh database for each test
    databaseHelper = DatabaseHelper();
    await databaseHelper.deleteDatabase(); // Clean slate

    // Create repository with real data source
    final dataSource = HydrationLogLocalDataSourceImpl(databaseHelper);
    repository = HydrationLogRepositoryImpl(dataSource);
  });

  tearDown(() async {
    // Clean up after each test
    await databaseHelper.close();
    await databaseHelper.deleteDatabase();
  });

  group('HydrationLogRepository Integration Tests - Full Flow', () {
    test('should add and retrieve log successfully', () async {
      // Arrange
      final log = HydrationLog(
        id: 'log-123',
        timestamp: DateTime.utc(2026, 1, 15, 10, 30, 0),
        photoPath: '/path/to/photo.jpg',
        glassSize: GlassSize.medium,
        validated: true,
      );

      // Act
      await repository.addLog(log);

      // Assert - Retrieve and verify
      final logs = await repository.getLogsForDate(DateTime(2026, 1, 15));
      expect(logs.length, equals(1));
      expect(logs.first.id, equals('log-123'));
      expect(logs.first.glassSize, equals(GlassSize.medium));
      expect(logs.first.volumeLiters, equals(0.25));
      expect(logs.first.photoPath, equals('/path/to/photo.jpg'));
    });

    test('should handle multiple logs for same day', () async {
      // Arrange
      final log1 = HydrationLog(
        id: 'log-1',
        timestamp: DateTime.utc(2026, 1, 15, 8, 0, 0),
        photoPath: null,
        glassSize: GlassSize.small,
        validated: true,
      );

      final log2 = HydrationLog(
        id: 'log-2',
        timestamp: DateTime.utc(2026, 1, 15, 12, 0, 0),
        photoPath: '/photo2.jpg',
        glassSize: GlassSize.large,
        validated: true,
      );

      final log3 = HydrationLog(
        id: 'log-3',
        timestamp: DateTime.utc(2026, 1, 15, 18, 0, 0),
        photoPath: null,
        glassSize: GlassSize.medium,
        validated: true,
      );

      // Act
      await repository.addLog(log1);
      await repository.addLog(log2);
      await repository.addLog(log3);

      // Assert
      final logs = await repository.getLogsForDate(DateTime(2026, 1, 15));
      expect(logs.length, equals(3));
      // Should be ordered by timestamp descending
      expect(logs[0].id, equals('log-3'));
      expect(logs[1].id, equals('log-2'));
      expect(logs[2].id, equals('log-1'));
    });

    test('should separate logs by date', () async {
      // Arrange - Add logs on different dates
      final log1 = HydrationLog(
        id: 'log-jan15',
        timestamp: DateTime.utc(2026, 1, 15, 10, 0, 0),
        glassSize: GlassSize.medium,
        validated: true,
      );

      final log2 = HydrationLog(
        id: 'log-jan16',
        timestamp: DateTime.utc(2026, 1, 16, 10, 0, 0),
        glassSize: GlassSize.large,
        validated: true,
      );

      // Act
      await repository.addLog(log1);
      await repository.addLog(log2);

      // Assert - Each date should have only its own logs
      final jan15Logs = await repository.getLogsForDate(DateTime(2026, 1, 15));
      final jan16Logs = await repository.getLogsForDate(DateTime(2026, 1, 16));

      expect(jan15Logs.length, equals(1));
      expect(jan15Logs.first.id, equals('log-jan15'));

      expect(jan16Logs.length, equals(1));
      expect(jan16Logs.first.id, equals('log-jan16'));
    });
  });

  group('HydrationLogRepository Integration Tests - getTodayLogs', () {
    test('should get today logs correctly', () async {
      // Arrange
      final now = DateTime.now();
      final todayLog = HydrationLog(
        id: 'log-today',
        timestamp: now,
        glassSize: GlassSize.medium,
        validated: true,
      );

      final yesterdayLog = HydrationLog(
        id: 'log-yesterday',
        timestamp: now.subtract(const Duration(days: 1)),
        glassSize: GlassSize.small,
        validated: true,
      );

      // Act
      await repository.addLog(todayLog);
      await repository.addLog(yesterdayLog);

      // Assert
      final todayLogs = await repository.getTodayLogs();
      expect(todayLogs.length, equals(1));
      expect(todayLogs.first.id, equals('log-today'));
    });

    test('should return empty list when no logs today', () async {
      // Arrange - Add log from yesterday only
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final yesterdayLog = HydrationLog(
        id: 'log-yesterday',
        timestamp: yesterday,
        glassSize: GlassSize.medium,
        validated: true,
      );

      // Act
      await repository.addLog(yesterdayLog);

      // Assert
      final todayLogs = await repository.getTodayLogs();
      expect(todayLogs, isEmpty);
    });
  });

  group('HydrationLogRepository Integration Tests - getTotalVolumeForDate', () {
    test('should calculate total volume correctly', () async {
      // Arrange
      final date = DateTime(2026, 1, 15);

      await repository.addLog(
        HydrationLog(
          id: 'log-1',
          timestamp: DateTime.utc(2026, 1, 15, 8, 0, 0),
          glassSize: GlassSize.small, // 0.2L
          validated: true,
        ),
      );

      await repository.addLog(
        HydrationLog(
          id: 'log-2',
          timestamp: DateTime.utc(2026, 1, 15, 12, 0, 0),
          glassSize: GlassSize.medium, // 0.25L
          validated: true,
        ),
      );

      await repository.addLog(
        HydrationLog(
          id: 'log-3',
          timestamp: DateTime.utc(2026, 1, 15, 18, 0, 0),
          glassSize: GlassSize.large, // 0.4L
          validated: true,
        ),
      );

      // Act
      final totalVolume = await repository.getTotalVolumeForDate(date);

      // Assert - 0.2 + 0.25 + 0.4 = 0.85
      expect(totalVolume, closeTo(0.85, 0.001));
    });

    test('should return 0 when no logs for date', () async {
      // Arrange - Add log on different date
      await repository.addLog(
        HydrationLog(
          id: 'log-jan16',
          timestamp: DateTime.utc(2026, 1, 16, 10, 0, 0),
          glassSize: GlassSize.medium,
          validated: true,
        ),
      );

      // Act - Query for Jan 15
      final totalVolume = await repository.getTotalVolumeForDate(
        DateTime(2026, 1, 15),
      );

      // Assert
      expect(totalVolume, equals(0.0));
    });

    test('should only count validated logs', () async {
      // Arrange
      final date = DateTime(2026, 1, 15);

      await repository.addLog(
        HydrationLog(
          id: 'log-validated',
          timestamp: DateTime.utc(2026, 1, 15, 10, 0, 0),
          glassSize: GlassSize.medium, // 0.25L
          validated: true,
        ),
      );

      await repository.addLog(
        HydrationLog(
          id: 'log-not-validated',
          timestamp: DateTime.utc(2026, 1, 15, 14, 0, 0),
          glassSize: GlassSize.large, // 0.5L (should be excluded)
          validated: false,
        ),
      );

      // Act
      final totalVolume = await repository.getTotalVolumeForDate(date);

      // Assert - Only validated log counted
      expect(totalVolume, equals(0.25));
    });

    test('should not include logs from other dates', () async {
      // Arrange
      await repository.addLog(
        HydrationLog(
          id: 'log-jan15',
          timestamp: DateTime.utc(2026, 1, 15, 10, 0, 0),
          glassSize: GlassSize.medium, // 0.25L
          validated: true,
        ),
      );

      await repository.addLog(
        HydrationLog(
          id: 'log-jan16',
          timestamp: DateTime.utc(2026, 1, 16, 10, 0, 0),
          glassSize: GlassSize.large, // 0.5L (should be excluded)
          validated: true,
        ),
      );

      // Act - Query for Jan 15
      final totalVolume = await repository.getTotalVolumeForDate(
        DateTime(2026, 1, 15),
      );

      // Assert - Only Jan 15 log counted
      expect(totalVolume, equals(0.25));
    });
  });

  group('HydrationLogRepository Integration Tests - deleteOldLogs', () {
    test('should delete logs older than 90 days', () async {
      // Arrange
      final now = DateTime.now();
      final old = now.subtract(const Duration(days: 95));
      final recent = now.subtract(const Duration(days: 30));

      await repository.addLog(
        HydrationLog(
          id: 'log-old',
          timestamp: old,
          glassSize: GlassSize.medium,
          validated: true,
        ),
      );

      await repository.addLog(
        HydrationLog(
          id: 'log-recent',
          timestamp: recent,
          glassSize: GlassSize.large,
          validated: true,
        ),
      );

      // Act
      final deletedCount = await repository.deleteOldLogs();

      // Assert
      expect(deletedCount, equals(1));

      // Verify old log is deleted
      final oldDateLogs = await repository.getLogsForDate(old);
      expect(oldDateLogs, isEmpty);

      // Verify recent log still exists
      final recentDateLogs = await repository.getLogsForDate(recent);
      expect(recentDateLogs.length, equals(1));
      expect(recentDateLogs.first.id, equals('log-recent'));
    });

    test('should return 0 when no old logs to delete', () async {
      // Arrange - Add recent log only
      final recent = DateTime.now().subtract(const Duration(days: 30));

      await repository.addLog(
        HydrationLog(
          id: 'log-recent',
          timestamp: recent,
          glassSize: GlassSize.medium,
          validated: true,
        ),
      );

      // Act
      final deletedCount = await repository.deleteOldLogs();

      // Assert
      expect(deletedCount, equals(0));

      // Verify log still exists
      final logs = await repository.getLogsForDate(recent);
      expect(logs.length, equals(1));
    });

    test('should handle edge case at 90 day boundary', () async {
      // Arrange
      final now = DateTime.now();
      final exactly90Days = now.subtract(const Duration(days: 90));
      final moreThan90Days = now.subtract(const Duration(days: 91));

      await repository.addLog(
        HydrationLog(
          id: 'log-exactly-90',
          timestamp: exactly90Days,
          glassSize: GlassSize.medium,
          validated: true,
        ),
      );

      await repository.addLog(
        HydrationLog(
          id: 'log-91-days',
          timestamp: moreThan90Days,
          glassSize: GlassSize.small,
          validated: true,
        ),
      );

      // Act
      final deletedCount = await repository.deleteOldLogs();

      // Assert - Both logs older than 90 days should be deleted
      expect(deletedCount, greaterThanOrEqualTo(1));

      // Verify 91-day log is deleted
      final logs91 = await repository.getLogsForDate(moreThan90Days);
      expect(logs91, isEmpty);
    });
  });

  group('HydrationLogRepository Integration Tests - Edge Cases', () {
    test('should handle log with null photoPath', () async {
      // Arrange
      final log = HydrationLog(
        id: 'log-no-photo',
        timestamp: DateTime.utc(2026, 1, 15, 10, 0, 0),
        photoPath: null, // No photo
        glassSize: GlassSize.medium,
        validated: true,
      );

      // Act
      await repository.addLog(log);

      // Assert
      final logs = await repository.getLogsForDate(DateTime(2026, 1, 15));
      expect(logs.first.photoPath, isNull);
    });

    test('should handle all glass sizes correctly', () async {
      // Arrange - Add log for each glass size
      final date = DateTime(2026, 1, 15);

      await repository.addLog(
        HydrationLog(
          id: 'log-small',
          timestamp: DateTime.utc(2026, 1, 15, 8, 0, 0),
          glassSize: GlassSize.small,
          validated: true,
        ),
      );

      await repository.addLog(
        HydrationLog(
          id: 'log-medium',
          timestamp: DateTime.utc(2026, 1, 15, 12, 0, 0),
          glassSize: GlassSize.medium,
          validated: true,
        ),
      );

      await repository.addLog(
        HydrationLog(
          id: 'log-large',
          timestamp: DateTime.utc(2026, 1, 15, 16, 0, 0),
          glassSize: GlassSize.large,
          validated: true,
        ),
      );

      // Act
      final logs = await repository.getLogsForDate(date);
      final totalVolume = await repository.getTotalVolumeForDate(date);

      // Assert
      expect(logs.length, equals(3));
      expect(logs[2].glassSize, equals(GlassSize.small));
      expect(logs[1].glassSize, equals(GlassSize.medium));
      expect(logs[0].glassSize, equals(GlassSize.large));
      // Total: 0.2 + 0.25 + 0.4 = 0.85
      expect(totalVolume, closeTo(0.85, 0.001));
    });

    test('should handle empty database', () async {
      // Act
      final logs = await repository.getLogsForDate(DateTime(2026, 1, 15));
      final todayLogs = await repository.getTodayLogs();
      final totalVolume = await repository.getTotalVolumeForDate(
        DateTime(2026, 1, 15),
      );
      final deletedCount = await repository.deleteOldLogs();

      // Assert
      expect(logs, isEmpty);
      expect(todayLogs, isEmpty);
      expect(totalVolume, equals(0.0));
      expect(deletedCount, equals(0));
    });
  });
}
