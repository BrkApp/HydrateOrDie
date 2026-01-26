import '../../domain/entities/hydration_log.dart';
import '../../domain/repositories/hydration_log_repository.dart';
import '../data_sources/local/hydration_log_local_data_source.dart';
import '../models/hydration_log_dto.dart';

/// Implementation of HydrationLogRepository using local data source
///
/// Manages hydration log persistence with offline-first strategy.
/// Uses SQLite for local storage with date-based queries and automatic cleanup.
class HydrationLogRepositoryImpl implements HydrationLogRepository {
  final HydrationLogLocalDataSource _localDataSource;

  HydrationLogRepositoryImpl(this._localDataSource);

  @override
  Future<void> addLog(HydrationLog log) async {
    try {
      // Convert entity to DTO
      final logDto = HydrationLogDto.fromEntity(log);

      // Save to local storage
      await _localDataSource.addLog(logDto);
    } catch (e) {
      throw StorageException(
        'Failed to add hydration log',
        code: 'ADD_LOG_FAILED',
        originalError: e,
      );
    }
  }

  @override
  Future<List<HydrationLog>> getLogsForDate(DateTime date) async {
    try {
      // Calculate start and end of the day (local time)
      final startOfDay = DateTime(date.year, date.month, date.day, 0, 0, 0);
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      // Get logs from local storage
      final logDtos = await _localDataSource.getLogsForDateRange(
        startOfDay,
        endOfDay,
      );

      // Convert DTOs to entities
      return logDtos.map((dto) => dto.toEntity()).toList();
    } catch (e) {
      throw StorageException(
        'Failed to get logs for date',
        code: 'GET_LOGS_FOR_DATE_FAILED',
        originalError: e,
      );
    }
  }

  @override
  Future<List<HydrationLog>> getTodayLogs() async {
    try {
      // Get logs for current date
      return await getLogsForDate(DateTime.now());
    } catch (e) {
      throw StorageException(
        'Failed to get today logs',
        code: 'GET_TODAY_LOGS_FAILED',
        originalError: e,
      );
    }
  }

  @override
  Future<double> getTotalVolumeForDate(DateTime date) async {
    try {
      // Calculate start and end of the day (local time)
      final startOfDay = DateTime(date.year, date.month, date.day, 0, 0, 0);
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      // Get total volume from local storage
      return await _localDataSource.getTotalVolumeForDateRange(
        startOfDay,
        endOfDay,
      );
    } catch (e) {
      throw StorageException(
        'Failed to get total volume for date',
        code: 'GET_TOTAL_VOLUME_FAILED',
        originalError: e,
      );
    }
  }

  @override
  Future<int> deleteOldLogs() async {
    try {
      // Calculate cutoff date (90 days ago)
      final cutoffDate = DateTime.now().subtract(const Duration(days: 90));

      // Delete old logs from local storage
      return await _localDataSource.deleteLogsOlderThan(cutoffDate);
    } catch (e) {
      throw StorageException(
        'Failed to delete old logs',
        code: 'DELETE_OLD_LOGS_FAILED',
        originalError: e,
      );
    }
  }
}
