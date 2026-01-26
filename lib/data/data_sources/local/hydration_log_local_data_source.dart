import 'package:sqflite/sqflite.dart';

import '../../models/hydration_log_dto.dart';
import 'database_helper.dart';

/// Local data source for hydration log persistence
///
/// Uses SQLite for hydration log storage with date-based indexing.
/// Supports offline-first architecture with query optimization.
abstract class HydrationLogLocalDataSource {
  /// Add a new hydration log to SQLite
  ///
  /// Inserts log with timestamp index for fast date queries.
  Future<void> addLog(HydrationLogDto logDto);

  /// Get all logs for a specific date range
  ///
  /// Returns logs where timestamp is between startDate and endDate (UTC).
  /// Results are ordered by timestamp descending.
  Future<List<HydrationLogDto>> getLogsForDateRange(
    DateTime startDate,
    DateTime endDate,
  );

  /// Calculate total volume for a specific date range
  ///
  /// Sums volume_liters for all validated logs in the date range.
  Future<double> getTotalVolumeForDateRange(
    DateTime startDate,
    DateTime endDate,
  );

  /// Delete logs older than a specific date
  ///
  /// Removes all logs where timestamp < cutoffDate.
  /// Returns the number of logs deleted.
  Future<int> deleteLogsOlderThan(DateTime cutoffDate);

  /// Get all logs (for debugging/testing)
  ///
  /// Returns all logs ordered by timestamp descending.
  Future<List<HydrationLogDto>> getAllLogs();
}

/// Implementation of HydrationLogLocalDataSource
class HydrationLogLocalDataSourceImpl implements HydrationLogLocalDataSource {
  static const String _hydrationLogsTable = 'hydration_logs';

  final DatabaseHelper _databaseHelper;

  HydrationLogLocalDataSourceImpl(this._databaseHelper);

  @override
  Future<void> addLog(HydrationLogDto logDto) async {
    try {
      final db = await _databaseHelper.database;
      final dbRow = _mapJsonToDbRow(logDto.toJson());

      await db.insert(
        _hydrationLogsTable,
        dbRow,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw DataSourceException(
        'Failed to add hydration log',
        code: 'ADD_LOG_FAILED',
        originalError: e,
      );
    }
  }

  @override
  Future<List<HydrationLogDto>> getLogsForDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final db = await _databaseHelper.database;

      // Convert dates to ISO 8601 strings for comparison
      final startString = startDate.toUtc().toIso8601String();
      final endString = endDate.toUtc().toIso8601String();

      final results = await db.query(
        _hydrationLogsTable,
        where: 'timestamp >= ? AND timestamp <= ?',
        whereArgs: [startString, endString],
        orderBy: 'timestamp DESC',
      );

      return results.map((row) {
        final json = _mapDbRowToJson(row);
        return HydrationLogDto.fromJson(json);
      }).toList();
    } catch (e) {
      throw DataSourceException(
        'Failed to get logs for date range',
        code: 'GET_LOGS_FOR_DATE_RANGE_FAILED',
        originalError: e,
      );
    }
  }

  @override
  Future<double> getTotalVolumeForDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final db = await _databaseHelper.database;

      // Convert dates to ISO 8601 strings for comparison
      final startString = startDate.toUtc().toIso8601String();
      final endString = endDate.toUtc().toIso8601String();

      final result = await db.rawQuery(
        '''
        SELECT SUM(volume_liters) as total
        FROM $_hydrationLogsTable
        WHERE timestamp >= ? AND timestamp <= ? AND validated = 1
      ''',
        [startString, endString],
      );

      final total = result.first['total'];
      return total != null ? (total as num).toDouble() : 0.0;
    } catch (e) {
      throw DataSourceException(
        'Failed to get total volume for date range',
        code: 'GET_TOTAL_VOLUME_FAILED',
        originalError: e,
      );
    }
  }

  @override
  Future<int> deleteLogsOlderThan(DateTime cutoffDate) async {
    try {
      final db = await _databaseHelper.database;
      final cutoffString = cutoffDate.toUtc().toIso8601String();

      final deletedCount = await db.delete(
        _hydrationLogsTable,
        where: 'timestamp < ?',
        whereArgs: [cutoffString],
      );

      return deletedCount;
    } catch (e) {
      throw DataSourceException(
        'Failed to delete old logs',
        code: 'DELETE_OLD_LOGS_FAILED',
        originalError: e,
      );
    }
  }

  @override
  Future<List<HydrationLogDto>> getAllLogs() async {
    try {
      final db = await _databaseHelper.database;

      final results = await db.query(
        _hydrationLogsTable,
        orderBy: 'timestamp DESC',
      );

      return results.map((row) {
        final json = _mapDbRowToJson(row);
        return HydrationLogDto.fromJson(json);
      }).toList();
    } catch (e) {
      throw DataSourceException(
        'Failed to get all logs',
        code: 'GET_ALL_LOGS_FAILED',
        originalError: e,
      );
    }
  }

  /// Map database row (snake_case) to JSON (camelCase)
  Map<String, dynamic> _mapDbRowToJson(Map<String, dynamic> dbRow) {
    return {
      'id': dbRow['id'],
      'timestamp': dbRow['timestamp'],
      'photoPath': dbRow['photo_path'],
      'glassSize': dbRow['glass_size'],
      'volumeLiters': dbRow['volume_liters'],
      'validated': dbRow['validated'] == 1,
      'syncedToCloud': dbRow['synced_to_cloud'] == 1,
      'createdAt': dbRow['created_at'],
    };
  }

  /// Map JSON (camelCase) to database row (snake_case)
  Map<String, dynamic> _mapJsonToDbRow(Map<String, dynamic> json) {
    return {
      'id': json['id'],
      'timestamp': json['timestamp'],
      'photo_path': json['photoPath'],
      'glass_size': json['glassSize'],
      'volume_liters': json['volumeLiters'],
      'validated': json['validated'] == true ? 1 : 0,
      'synced_to_cloud': json['syncedToCloud'] == true ? 1 : 0,
      'created_at': json['createdAt'],
    };
  }
}

/// Exception thrown when data source operations fail
class DataSourceException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  DataSourceException(this.message, {this.code, this.originalError});

  @override
  String toString() => 'DataSourceException: $message (code: $code)';
}
