import '../entities/hydration_log.dart';

/// Repository interface for hydration log persistence and retrieval
///
/// Manages hydration log history with date-based queries and automatic cleanup.
/// Supports offline-first architecture with SQLite persistence.
abstract class HydrationLogRepository {
  /// Add a new hydration log entry
  ///
  /// Persists the log to SQLite with timestamp indexing.
  /// All fields are validated before storage.
  ///
  /// Throws [StorageException] if save fails.
  Future<void> addLog(HydrationLog log);

  /// Get all logs for a specific date
  ///
  /// Returns logs where timestamp falls within the specified date (00:00 - 23:59 local time).
  /// Results are ordered by timestamp descending (most recent first).
  ///
  /// [date] Target date (time component is ignored)
  ///
  /// Returns empty list if no logs exist for the date.
  Future<List<HydrationLog>> getLogsForDate(DateTime date);

  /// Get all logs for today
  ///
  /// Convenience method that calls getLogsForDate(DateTime.now()).
  /// Returns logs from 00:00 to 23:59 of the current day (local time).
  ///
  /// Returns empty list if no logs exist today.
  Future<List<HydrationLog>> getTodayLogs();

  /// Calculate total volume consumed for a specific date
  ///
  /// Sums the volume_liters field for all logs on the given date.
  /// Only includes validated logs.
  ///
  /// [date] Target date (time component is ignored)
  ///
  /// Returns 0.0 if no logs exist for the date.
  Future<double> getTotalVolumeForDate(DateTime date);

  /// Delete logs older than 90 days
  ///
  /// Implements RGPD compliance and improves database performance.
  /// Deletes all logs where timestamp < (now - 90 days).
  ///
  /// Returns the number of logs deleted.
  ///
  /// Throws [StorageException] if delete fails.
  Future<int> deleteOldLogs();
}

/// Exception thrown when hydration log storage operations fail
class StorageException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  StorageException(this.message, {this.code, this.originalError});

  @override
  String toString() => 'StorageException: $message (code: $code)';
}
