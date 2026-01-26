import 'package:flutter_test/flutter_test.dart';
import 'package:hydrate_or_die/data/data_sources/local/database_helper.dart';
import 'package:hydrate_or_die/data/data_sources/local/hydration_log_local_data_source.dart';
import 'package:hydrate_or_die/data/models/hydration_log_dto.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Integration tests for HydrationLogLocalDataSource with real SQLite
///
/// These tests verify the full persistence stack works correctly.
void main() {
  late DatabaseHelper databaseHelper;
  late HydrationLogLocalDataSource dataSource;

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

    dataSource = HydrationLogLocalDataSourceImpl(databaseHelper);
  });

  tearDown(() async {
    // Clean up after each test
    await databaseHelper.close();
    await databaseHelper.deleteDatabase();
  });

  group('HydrationLogLocalDataSource Integration Tests - Add', () {
    test('should add hydration log to SQLite successfully', () async {
      // Arrange
      final timestamp = DateTime.utc(2026, 1, 15, 10, 30, 0);
      final logDto = HydrationLogDto(
        id: 'log-123',
        timestamp: timestamp.toIso8601String(),
        photoPath: '/path/to/photo.jpg',
        glassSizeString: 'medium',
        volumeLiters: 0.25,
        validated: true,
        syncedToCloud: false,
        createdAt: timestamp.toIso8601String(),
      );

      // Act
      await dataSource.addLog(logDto);

      // Assert - Verify log was saved
      final allLogs = await dataSource.getAllLogs();
      expect(allLogs.length, equals(1));
      expect(allLogs.first.id, equals('log-123'));
      expect(allLogs.first.volumeLiters, equals(0.25));
      expect(allLogs.first.glassSizeString, equals('medium'));
    });

    test('should add multiple logs successfully', () async {
      // Arrange
      final log1 = HydrationLogDto(
        id: 'log-1',
        timestamp: DateTime.utc(2026, 1, 15, 8, 0, 0).toIso8601String(),
        photoPath: null,
        glassSizeString: 'small',
        volumeLiters: 0.15,
        validated: true,
        syncedToCloud: false,
        createdAt: DateTime.utc(2026, 1, 15, 8, 0, 0).toIso8601String(),
      );

      final log2 = HydrationLogDto(
        id: 'log-2',
        timestamp: DateTime.utc(2026, 1, 15, 12, 0, 0).toIso8601String(),
        photoPath: '/path/photo2.jpg',
        glassSizeString: 'large',
        volumeLiters: 0.5,
        validated: true,
        syncedToCloud: false,
        createdAt: DateTime.utc(2026, 1, 15, 12, 0, 0).toIso8601String(),
      );

      // Act
      await dataSource.addLog(log1);
      await dataSource.addLog(log2);

      // Assert
      final allLogs = await dataSource.getAllLogs();
      expect(allLogs.length, equals(2));
      // Should be ordered by timestamp DESC (most recent first)
      expect(allLogs[0].id, equals('log-2'));
      expect(allLogs[1].id, equals('log-1'));
    });
  });

  group(
    'HydrationLogLocalDataSource Integration Tests - Get by Date Range',
    () {
      test('should get logs for specific date range', () async {
        // Arrange - Add logs on different dates
        final jan15Morning = DateTime.utc(2026, 1, 15, 8, 0, 0);
        final jan15Afternoon = DateTime.utc(2026, 1, 15, 14, 0, 0);
        final jan16Morning = DateTime.utc(2026, 1, 16, 9, 0, 0);

        await dataSource.addLog(
          HydrationLogDto(
            id: 'log-jan15-1',
            timestamp: jan15Morning.toIso8601String(),
            glassSizeString: 'medium',
            volumeLiters: 0.25,
            validated: true,
            syncedToCloud: false,
            createdAt: jan15Morning.toIso8601String(),
          ),
        );

        await dataSource.addLog(
          HydrationLogDto(
            id: 'log-jan15-2',
            timestamp: jan15Afternoon.toIso8601String(),
            glassSizeString: 'large',
            volumeLiters: 0.5,
            validated: true,
            syncedToCloud: false,
            createdAt: jan15Afternoon.toIso8601String(),
          ),
        );

        await dataSource.addLog(
          HydrationLogDto(
            id: 'log-jan16-1',
            timestamp: jan16Morning.toIso8601String(),
            glassSizeString: 'small',
            volumeLiters: 0.15,
            validated: true,
            syncedToCloud: false,
            createdAt: jan16Morning.toIso8601String(),
          ),
        );

        // Act - Get logs for Jan 15 only
        final jan15Start = DateTime.utc(2026, 1, 15, 0, 0, 0);
        final jan15End = DateTime.utc(2026, 1, 15, 23, 59, 59);
        final jan15Logs = await dataSource.getLogsForDateRange(
          jan15Start,
          jan15End,
        );

        // Assert
        expect(jan15Logs.length, equals(2));
        expect(jan15Logs[0].id, equals('log-jan15-2')); // Ordered DESC
        expect(jan15Logs[1].id, equals('log-jan15-1'));
      });

      test('should return empty list when no logs in date range', () async {
        // Arrange - Add log on Jan 15
        await dataSource.addLog(
          HydrationLogDto(
            id: 'log-jan15',
            timestamp: DateTime.utc(2026, 1, 15, 10, 0, 0).toIso8601String(),
            glassSizeString: 'medium',
            volumeLiters: 0.25,
            validated: true,
            syncedToCloud: false,
            createdAt: DateTime.utc(2026, 1, 15, 10, 0, 0).toIso8601String(),
          ),
        );

        // Act - Query for Jan 16
        final jan16Start = DateTime.utc(2026, 1, 16, 0, 0, 0);
        final jan16End = DateTime.utc(2026, 1, 16, 23, 59, 59);
        final jan16Logs = await dataSource.getLogsForDateRange(
          jan16Start,
          jan16End,
        );

        // Assert
        expect(jan16Logs, isEmpty);
      });
    },
  );

  group(
    'HydrationLogLocalDataSource Integration Tests - Volume Calculation',
    () {
      test('should calculate total volume for date range correctly', () async {
        // Arrange - Add logs with different volumes
        final jan15 = DateTime.utc(2026, 1, 15);

        await dataSource.addLog(
          HydrationLogDto(
            id: 'log-1',
            timestamp: jan15.add(const Duration(hours: 8)).toIso8601String(),
            glassSizeString: 'small',
            volumeLiters: 0.15,
            validated: true,
            syncedToCloud: false,
            createdAt: jan15.toIso8601String(),
          ),
        );

        await dataSource.addLog(
          HydrationLogDto(
            id: 'log-2',
            timestamp: jan15.add(const Duration(hours: 12)).toIso8601String(),
            glassSizeString: 'medium',
            volumeLiters: 0.25,
            validated: true,
            syncedToCloud: false,
            createdAt: jan15.toIso8601String(),
          ),
        );

        await dataSource.addLog(
          HydrationLogDto(
            id: 'log-3',
            timestamp: jan15.add(const Duration(hours: 16)).toIso8601String(),
            glassSizeString: 'large',
            volumeLiters: 0.5,
            validated: true,
            syncedToCloud: false,
            createdAt: jan15.toIso8601String(),
          ),
        );

        // Act
        final jan15Start = DateTime.utc(2026, 1, 15, 0, 0, 0);
        final jan15End = DateTime.utc(2026, 1, 15, 23, 59, 59);
        final totalVolume = await dataSource.getTotalVolumeForDateRange(
          jan15Start,
          jan15End,
        );

        // Assert - 0.15 + 0.25 + 0.5 = 0.9
        expect(totalVolume, equals(0.9));
      });

      test('should return 0 when no logs in date range', () async {
        // Arrange - No logs added

        // Act
        final jan15Start = DateTime.utc(2026, 1, 15, 0, 0, 0);
        final jan15End = DateTime.utc(2026, 1, 15, 23, 59, 59);
        final totalVolume = await dataSource.getTotalVolumeForDateRange(
          jan15Start,
          jan15End,
        );

        // Assert
        expect(totalVolume, equals(0.0));
      });

      test(
        'should exclude non-validated logs from volume calculation',
        () async {
          // Arrange
          final jan15 = DateTime.utc(2026, 1, 15, 10, 0, 0);

          await dataSource.addLog(
            HydrationLogDto(
              id: 'log-validated',
              timestamp: jan15.toIso8601String(),
              glassSizeString: 'medium',
              volumeLiters: 0.25,
              validated: true,
              syncedToCloud: false,
              createdAt: jan15.toIso8601String(),
            ),
          );

          await dataSource.addLog(
            HydrationLogDto(
              id: 'log-not-validated',
              timestamp: jan15.toIso8601String(),
              glassSizeString: 'large',
              volumeLiters: 0.5,
              validated: false, // Should be excluded
              syncedToCloud: false,
              createdAt: jan15.toIso8601String(),
            ),
          );

          // Act
          final jan15Start = DateTime.utc(2026, 1, 15, 0, 0, 0);
          final jan15End = DateTime.utc(2026, 1, 15, 23, 59, 59);
          final totalVolume = await dataSource.getTotalVolumeForDateRange(
            jan15Start,
            jan15End,
          );

          // Assert - Only validated log counted
          expect(totalVolume, equals(0.25));
        },
      );
    },
  );

  group('HydrationLogLocalDataSource Integration Tests - Delete Old Logs', () {
    test('should delete logs older than cutoff date', () async {
      // Arrange - Add logs with different dates
      final oldDate = DateTime.utc(2025, 10, 1, 10, 0, 0); // ~3 months ago
      final recentDate = DateTime.utc(2026, 1, 10, 10, 0, 0);

      await dataSource.addLog(
        HydrationLogDto(
          id: 'log-old',
          timestamp: oldDate.toIso8601String(),
          glassSizeString: 'medium',
          volumeLiters: 0.25,
          validated: true,
          syncedToCloud: false,
          createdAt: oldDate.toIso8601String(),
        ),
      );

      await dataSource.addLog(
        HydrationLogDto(
          id: 'log-recent',
          timestamp: recentDate.toIso8601String(),
          glassSizeString: 'large',
          volumeLiters: 0.5,
          validated: true,
          syncedToCloud: false,
          createdAt: recentDate.toIso8601String(),
        ),
      );

      // Act - Delete logs older than Nov 1, 2025
      final cutoffDate = DateTime.utc(2025, 11, 1);
      final deletedCount = await dataSource.deleteLogsOlderThan(cutoffDate);

      // Assert
      expect(deletedCount, equals(1));

      final remainingLogs = await dataSource.getAllLogs();
      expect(remainingLogs.length, equals(1));
      expect(remainingLogs.first.id, equals('log-recent'));
    });

    test('should return 0 when no logs to delete', () async {
      // Arrange - Add recent log only
      final recentDate = DateTime.utc(2026, 1, 15, 10, 0, 0);

      await dataSource.addLog(
        HydrationLogDto(
          id: 'log-recent',
          timestamp: recentDate.toIso8601String(),
          glassSizeString: 'medium',
          volumeLiters: 0.25,
          validated: true,
          syncedToCloud: false,
          createdAt: recentDate.toIso8601String(),
        ),
      );

      // Act - Delete logs older than Jan 1, 2026
      final cutoffDate = DateTime.utc(2026, 1, 1);
      final deletedCount = await dataSource.deleteLogsOlderThan(cutoffDate);

      // Assert
      expect(deletedCount, equals(0));

      final remainingLogs = await dataSource.getAllLogs();
      expect(remainingLogs.length, equals(1));
    });
  });

  group('HydrationLogLocalDataSource Integration Tests - Edge Cases', () {
    test('should handle log with null photoPath', () async {
      // Arrange
      final logDto = HydrationLogDto(
        id: 'log-no-photo',
        timestamp: DateTime.utc(2026, 1, 15, 10, 0, 0).toIso8601String(),
        photoPath: null, // No photo
        glassSizeString: 'medium',
        volumeLiters: 0.25,
        validated: true,
        syncedToCloud: false,
        createdAt: DateTime.utc(2026, 1, 15, 10, 0, 0).toIso8601String(),
      );

      // Act
      await dataSource.addLog(logDto);

      // Assert
      final allLogs = await dataSource.getAllLogs();
      expect(allLogs.first.photoPath, isNull);
    });

    test('should handle syncedToCloud flag correctly', () async {
      // Arrange
      final logDto = HydrationLogDto(
        id: 'log-synced',
        timestamp: DateTime.utc(2026, 1, 15, 10, 0, 0).toIso8601String(),
        glassSizeString: 'medium',
        volumeLiters: 0.25,
        validated: true,
        syncedToCloud: true, // Synced
        createdAt: DateTime.utc(2026, 1, 15, 10, 0, 0).toIso8601String(),
      );

      // Act
      await dataSource.addLog(logDto);

      // Assert
      final allLogs = await dataSource.getAllLogs();
      expect(allLogs.first.syncedToCloud, isTrue);
    });

    test('should preserve log order by timestamp descending', () async {
      // Arrange - Add logs in non-chronological order
      final timestamps = [
        DateTime.utc(2026, 1, 15, 14, 0, 0), // 2nd chronologically
        DateTime.utc(2026, 1, 15, 8, 0, 0), // 1st chronologically
        DateTime.utc(2026, 1, 15, 20, 0, 0), // 3rd chronologically
      ];

      for (var i = 0; i < timestamps.length; i++) {
        await dataSource.addLog(
          HydrationLogDto(
            id: 'log-$i',
            timestamp: timestamps[i].toIso8601String(),
            glassSizeString: 'medium',
            volumeLiters: 0.25,
            validated: true,
            syncedToCloud: false,
            createdAt: timestamps[i].toIso8601String(),
          ),
        );
      }

      // Act
      final allLogs = await dataSource.getAllLogs();

      // Assert - Should be ordered by timestamp DESC
      expect(allLogs[0].id, equals('log-2')); // 20:00
      expect(allLogs[1].id, equals('log-0')); // 14:00
      expect(allLogs[2].id, equals('log-1')); // 08:00
    });
  });
}
