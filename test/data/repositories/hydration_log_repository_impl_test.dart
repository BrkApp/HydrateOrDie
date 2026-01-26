import 'package:flutter_test/flutter_test.dart';
import 'package:hydrate_or_die/data/data_sources/local/hydration_log_local_data_source.dart';
import 'package:hydrate_or_die/data/models/hydration_log_dto.dart';
import 'package:hydrate_or_die/data/repositories/hydration_log_repository_impl.dart';
import 'package:hydrate_or_die/domain/entities/glass_size.dart';
import 'package:hydrate_or_die/domain/entities/hydration_log.dart';
import 'package:hydrate_or_die/domain/repositories/hydration_log_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'hydration_log_repository_impl_test.mocks.dart';

@GenerateMocks([HydrationLogLocalDataSource])
void main() {
  late MockHydrationLogLocalDataSource mockLocalDataSource;
  late HydrationLogRepositoryImpl repository;

  setUp(() {
    mockLocalDataSource = MockHydrationLogLocalDataSource();
    repository = HydrationLogRepositoryImpl(mockLocalDataSource);
  });

  group('HydrationLogRepositoryImpl - addLog', () {
    final testLog = HydrationLog(
      id: 'log-123',
      timestamp: DateTime.utc(2026, 1, 15, 10, 30, 0),
      photoPath: '/path/to/photo.jpg',
      glassSize: GlassSize.medium,
      validated: true,
    );

    test('should add log successfully', () async {
      // Arrange
      when(mockLocalDataSource.addLog(any)).thenAnswer((_) async => {});

      // Act
      await repository.addLog(testLog);

      // Assert
      verify(mockLocalDataSource.addLog(any)).called(1);
    });

    test('should convert entity to DTO correctly', () async {
      // Arrange
      HydrationLogDto? capturedDto;
      when(mockLocalDataSource.addLog(any)).thenAnswer((invocation) {
        capturedDto = invocation.positionalArguments[0] as HydrationLogDto;
        return Future.value();
      });

      // Act
      await repository.addLog(testLog);

      // Assert
      expect(capturedDto, isNotNull);
      expect(capturedDto!.id, equals('log-123'));
      expect(capturedDto!.glassSizeString, equals('medium'));
      expect(capturedDto!.volumeLiters, equals(0.25));
      expect(capturedDto!.validated, isTrue);
    });

    test('should throw StorageException when add fails', () async {
      // Arrange
      when(
        mockLocalDataSource.addLog(any),
      ).thenThrow(DataSourceException('Add failed'));

      // Act & Assert
      expect(
        () => repository.addLog(testLog),
        throwsA(isA<StorageException>()),
      );
    });

    test('should throw StorageException with correct error code', () async {
      // Arrange
      when(
        mockLocalDataSource.addLog(any),
      ).thenThrow(DataSourceException('Add failed'));

      // Act & Assert
      try {
        await repository.addLog(testLog);
        fail('Should have thrown StorageException');
      } catch (e) {
        expect(e, isA<StorageException>());
        final exception = e as StorageException;
        expect(exception.code, equals('ADD_LOG_FAILED'));
        expect(exception.message, contains('Failed to add hydration log'));
      }
    });
  });

  group('HydrationLogRepositoryImpl - getLogsForDate', () {
    final testDate = DateTime(2026, 1, 15);
    final testDtos = [
      HydrationLogDto(
        id: 'log-1',
        timestamp: DateTime.utc(2026, 1, 15, 8, 0, 0).toIso8601String(),
        photoPath: null,
        glassSizeString: 'small',
        volumeLiters: 0.15,
        validated: true,
        syncedToCloud: false,
        createdAt: DateTime.utc(2026, 1, 15, 8, 0, 0).toIso8601String(),
      ),
      HydrationLogDto(
        id: 'log-2',
        timestamp: DateTime.utc(2026, 1, 15, 14, 0, 0).toIso8601String(),
        photoPath: '/path/photo2.jpg',
        glassSizeString: 'large',
        volumeLiters: 0.5,
        validated: true,
        syncedToCloud: false,
        createdAt: DateTime.utc(2026, 1, 15, 14, 0, 0).toIso8601String(),
      ),
    ];

    test('should get logs for specific date', () async {
      // Arrange
      when(
        mockLocalDataSource.getLogsForDateRange(any, any),
      ).thenAnswer((_) async => testDtos);

      // Act
      final result = await repository.getLogsForDate(testDate);

      // Assert
      expect(result.length, equals(2));
      expect(result[0].id, equals('log-1'));
      expect(result[0].glassSize, equals(GlassSize.small));
      expect(result[1].id, equals('log-2'));
      expect(result[1].glassSize, equals(GlassSize.large));
      verify(mockLocalDataSource.getLogsForDateRange(any, any)).called(1);
    });

    test('should call data source with correct date range', () async {
      // Arrange
      DateTime? capturedStart;
      DateTime? capturedEnd;
      when(mockLocalDataSource.getLogsForDateRange(any, any)).thenAnswer((
        invocation,
      ) {
        capturedStart = invocation.positionalArguments[0] as DateTime;
        capturedEnd = invocation.positionalArguments[1] as DateTime;
        return Future.value(testDtos);
      });

      // Act
      await repository.getLogsForDate(testDate);

      // Assert - Should query for entire day (00:00:00 to 23:59:59)
      expect(capturedStart, isNotNull);
      expect(capturedEnd, isNotNull);
      expect(capturedStart!.year, equals(2026));
      expect(capturedStart!.month, equals(1));
      expect(capturedStart!.day, equals(15));
      expect(capturedStart!.hour, equals(0));
      expect(capturedStart!.minute, equals(0));
      expect(capturedStart!.second, equals(0));
      expect(capturedEnd!.hour, equals(23));
      expect(capturedEnd!.minute, equals(59));
      expect(capturedEnd!.second, equals(59));
    });

    test('should return empty list when no logs for date', () async {
      // Arrange
      when(
        mockLocalDataSource.getLogsForDateRange(any, any),
      ).thenAnswer((_) async => []);

      // Act
      final result = await repository.getLogsForDate(testDate);

      // Assert
      expect(result, isEmpty);
    });

    test('should throw StorageException when get fails', () async {
      // Arrange
      when(
        mockLocalDataSource.getLogsForDateRange(any, any),
      ).thenThrow(DataSourceException('Get failed'));

      // Act & Assert
      expect(
        () => repository.getLogsForDate(testDate),
        throwsA(isA<StorageException>()),
      );
    });
  });

  group('HydrationLogRepositoryImpl - getTodayLogs', () {
    test('should get today logs successfully', () async {
      // Arrange
      final todayDtos = [
        HydrationLogDto(
          id: 'log-today',
          timestamp: DateTime.now().toUtc().toIso8601String(),
          glassSizeString: 'medium',
          volumeLiters: 0.25,
          validated: true,
          syncedToCloud: false,
          createdAt: DateTime.now().toUtc().toIso8601String(),
        ),
      ];

      when(
        mockLocalDataSource.getLogsForDateRange(any, any),
      ).thenAnswer((_) async => todayDtos);

      // Act
      final result = await repository.getTodayLogs();

      // Assert
      expect(result.length, equals(1));
      expect(result[0].id, equals('log-today'));
      verify(mockLocalDataSource.getLogsForDateRange(any, any)).called(1);
    });

    test('should call getLogsForDate with current date', () async {
      // Arrange
      when(
        mockLocalDataSource.getLogsForDateRange(any, any),
      ).thenAnswer((_) async => []);

      // Act
      await repository.getTodayLogs();

      // Assert - Verify called with date range for today
      verify(mockLocalDataSource.getLogsForDateRange(any, any)).called(1);
    });

    test('should throw StorageException when get fails', () async {
      // Arrange
      when(
        mockLocalDataSource.getLogsForDateRange(any, any),
      ).thenThrow(DataSourceException('Get failed'));

      // Act & Assert
      expect(() => repository.getTodayLogs(), throwsA(isA<StorageException>()));
    });
  });

  group('HydrationLogRepositoryImpl - getTotalVolumeForDate', () {
    final testDate = DateTime(2026, 1, 15);

    test('should get total volume for date', () async {
      // Arrange
      when(
        mockLocalDataSource.getTotalVolumeForDateRange(any, any),
      ).thenAnswer((_) async => 1.5);

      // Act
      final result = await repository.getTotalVolumeForDate(testDate);

      // Assert
      expect(result, equals(1.5));
      verify(
        mockLocalDataSource.getTotalVolumeForDateRange(any, any),
      ).called(1);
    });

    test('should call data source with correct date range', () async {
      // Arrange
      DateTime? capturedStart;
      DateTime? capturedEnd;
      when(mockLocalDataSource.getTotalVolumeForDateRange(any, any)).thenAnswer(
        (invocation) {
          capturedStart = invocation.positionalArguments[0] as DateTime;
          capturedEnd = invocation.positionalArguments[1] as DateTime;
          return Future.value(1.5);
        },
      );

      // Act
      await repository.getTotalVolumeForDate(testDate);

      // Assert - Should query for entire day
      expect(capturedStart, isNotNull);
      expect(capturedEnd, isNotNull);
      expect(capturedStart!.year, equals(2026));
      expect(capturedStart!.month, equals(1));
      expect(capturedStart!.day, equals(15));
      expect(capturedStart!.hour, equals(0));
      expect(capturedEnd!.hour, equals(23));
      expect(capturedEnd!.minute, equals(59));
      expect(capturedEnd!.second, equals(59));
    });

    test('should return 0.0 when no logs for date', () async {
      // Arrange
      when(
        mockLocalDataSource.getTotalVolumeForDateRange(any, any),
      ).thenAnswer((_) async => 0.0);

      // Act
      final result = await repository.getTotalVolumeForDate(testDate);

      // Assert
      expect(result, equals(0.0));
    });

    test('should throw StorageException when get fails', () async {
      // Arrange
      when(
        mockLocalDataSource.getTotalVolumeForDateRange(any, any),
      ).thenThrow(DataSourceException('Get failed'));

      // Act & Assert
      expect(
        () => repository.getTotalVolumeForDate(testDate),
        throwsA(isA<StorageException>()),
      );
    });
  });

  group('HydrationLogRepositoryImpl - deleteOldLogs', () {
    test('should delete old logs successfully', () async {
      // Arrange
      when(
        mockLocalDataSource.deleteLogsOlderThan(any),
      ).thenAnswer((_) async => 42);

      // Act
      final result = await repository.deleteOldLogs();

      // Assert
      expect(result, equals(42));
      verify(mockLocalDataSource.deleteLogsOlderThan(any)).called(1);
    });

    test('should call data source with cutoff date 90 days ago', () async {
      // Arrange
      DateTime? capturedCutoff;
      when(mockLocalDataSource.deleteLogsOlderThan(any)).thenAnswer((
        invocation,
      ) {
        capturedCutoff = invocation.positionalArguments[0] as DateTime;
        return Future.value(10);
      });

      final now = DateTime.now();

      // Act
      await repository.deleteOldLogs();

      // Assert - Verify cutoff is approximately 90 days ago
      expect(capturedCutoff, isNotNull);
      final expectedCutoff = now.subtract(const Duration(days: 90));
      final difference = capturedCutoff!.difference(expectedCutoff).abs();
      expect(difference.inSeconds, lessThan(5)); // Allow 5 seconds tolerance
    });

    test('should return 0 when no logs to delete', () async {
      // Arrange
      when(
        mockLocalDataSource.deleteLogsOlderThan(any),
      ).thenAnswer((_) async => 0);

      // Act
      final result = await repository.deleteOldLogs();

      // Assert
      expect(result, equals(0));
    });

    test('should throw StorageException when delete fails', () async {
      // Arrange
      when(
        mockLocalDataSource.deleteLogsOlderThan(any),
      ).thenThrow(DataSourceException('Delete failed'));

      // Act & Assert
      expect(
        () => repository.deleteOldLogs(),
        throwsA(isA<StorageException>()),
      );
    });

    test('should throw StorageException with correct error code', () async {
      // Arrange
      when(
        mockLocalDataSource.deleteLogsOlderThan(any),
      ).thenThrow(DataSourceException('Delete failed'));

      // Act & Assert
      try {
        await repository.deleteOldLogs();
        fail('Should have thrown StorageException');
      } catch (e) {
        expect(e, isA<StorageException>());
        final exception = e as StorageException;
        expect(exception.code, equals('DELETE_OLD_LOGS_FAILED'));
        expect(exception.message, contains('Failed to delete old logs'));
      }
    });
  });
}
