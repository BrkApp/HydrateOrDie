import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/avatar_dto.dart';
import 'database_helper.dart';

/// Local data source for avatar persistence
///
/// Uses SharedPreferences for avatar ID and SQLite for avatar state.
/// Implements offline-first persistence strategy.
abstract class AvatarLocalDataSource {
  /// Get selected avatar ID from SharedPreferences
  ///
  /// Returns null if no avatar selected yet.
  Future<String?> getSelectedAvatarId();

  /// Save selected avatar ID to SharedPreferences
  Future<void> saveSelectedAvatarId(String avatarId);

  /// Get avatar state from SQLite
  ///
  /// Returns null if no state exists (first launch).
  Future<AvatarDto?> getAvatarState();

  /// Save or update avatar state in SQLite
  ///
  /// Uses INSERT OR REPLACE (upsert) for singleton pattern.
  Future<void> saveAvatarState(AvatarDto avatarDto);

  /// Update only the state field (optimization)
  Future<void> updateAvatarStateField(String state);

  /// Update only the last_drink_time field
  Future<void> updateLastDrinkTime(DateTime timestamp);

  /// Get death time from SQLite
  ///
  /// Returns null if avatar never died or has been resurrected.
  Future<String?> getDeathTime();

  /// Update death time field in SQLite
  ///
  /// Set to null to clear death time (on resurrection or drink).
  Future<void> updateDeathTime(DateTime? timestamp);

  /// Delete avatar data (for account deletion)
  Future<void> deleteAvatarData();
}

/// Implementation of AvatarLocalDataSource
class AvatarLocalDataSourceImpl implements AvatarLocalDataSource {
  static const String _avatarIdKey = 'selected_avatar_id';
  static const String _avatarStateTable = 'avatar_state';
  static const String _avatarStateSingletonId = 'avatar_singleton';

  final DatabaseHelper _databaseHelper;

  AvatarLocalDataSourceImpl(this._databaseHelper);

  @override
  Future<String?> getSelectedAvatarId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_avatarIdKey);
    } catch (e) {
      throw DataSourceException(
        'Failed to get selected avatar ID',
        code: 'GET_AVATAR_ID_FAILED',
        originalError: e,
      );
    }
  }

  @override
  Future<void> saveSelectedAvatarId(String avatarId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_avatarIdKey, avatarId);
    } catch (e) {
      throw DataSourceException(
        'Failed to save selected avatar ID',
        code: 'SAVE_AVATAR_ID_FAILED',
        originalError: e,
      );
    }
  }

  @override
  Future<AvatarDto?> getAvatarState() async {
    try {
      final db = await _databaseHelper.database;
      final results = await db.query(
        _avatarStateTable,
        where: 'id = ?',
        whereArgs: [_avatarStateSingletonId],
        limit: 1,
      );

      if (results.isEmpty) {
        return null;
      }

      return AvatarDto.fromJson(results.first);
    } catch (e) {
      throw DataSourceException(
        'Failed to get avatar state',
        code: 'GET_AVATAR_STATE_FAILED',
        originalError: e,
      );
    }
  }

  @override
  Future<void> saveAvatarState(AvatarDto avatarDto) async {
    try {
      final db = await _databaseHelper.database;
      final json = avatarDto.toJson();

      // Use INSERT OR REPLACE for upsert (singleton pattern)
      await db.insert(
        _avatarStateTable,
        json,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw DataSourceException(
        'Failed to save avatar state',
        code: 'SAVE_AVATAR_STATE_FAILED',
        originalError: e,
      );
    }
  }

  @override
  Future<void> updateAvatarStateField(String state) async {
    try {
      final db = await _databaseHelper.database;
      final now = DateTime.now().toUtc().toIso8601String();

      await db.update(
        _avatarStateTable,
        {
          'currentState': state,
          'lastUpdated': now,
        },
        where: 'id = ?',
        whereArgs: [_avatarStateSingletonId],
      );
    } catch (e) {
      throw DataSourceException(
        'Failed to update avatar state field',
        code: 'UPDATE_STATE_FIELD_FAILED',
        originalError: e,
      );
    }
  }

  @override
  Future<void> updateLastDrinkTime(DateTime timestamp) async {
    try {
      final db = await _databaseHelper.database;
      final timestampStr = timestamp.toUtc().toIso8601String();
      final now = DateTime.now().toUtc().toIso8601String();

      await db.update(
        _avatarStateTable,
        {
          'lastDrinkTime': timestampStr,
          'currentState': 'fresh', // Reset to fresh after drink
          'death_time': null, // Clear death time on drink
          'lastUpdated': now,
        },
        where: 'id = ?',
        whereArgs: [_avatarStateSingletonId],
      );
    } catch (e) {
      throw DataSourceException(
        'Failed to update last drink time',
        code: 'UPDATE_LAST_DRINK_TIME_FAILED',
        originalError: e,
      );
    }
  }

  @override
  Future<String?> getDeathTime() async {
    try {
      final db = await _databaseHelper.database;
      final results = await db.query(
        _avatarStateTable,
        columns: ['death_time'],
        where: 'id = ?',
        whereArgs: [_avatarStateSingletonId],
        limit: 1,
      );

      if (results.isEmpty) {
        return null;
      }

      return results.first['death_time'] as String?;
    } catch (e) {
      throw DataSourceException(
        'Failed to get death time',
        code: 'GET_DEATH_TIME_FAILED',
        originalError: e,
      );
    }
  }

  @override
  Future<void> updateDeathTime(DateTime? timestamp) async {
    try {
      final db = await _databaseHelper.database;
      final now = DateTime.now().toUtc().toIso8601String();
      final timestampStr = timestamp?.toUtc().toIso8601String();

      await db.update(
        _avatarStateTable,
        {
          'death_time': timestampStr,
          'lastUpdated': now,
        },
        where: 'id = ?',
        whereArgs: [_avatarStateSingletonId],
      );
    } catch (e) {
      throw DataSourceException(
        'Failed to update death time',
        code: 'UPDATE_DEATH_TIME_FAILED',
        originalError: e,
      );
    }
  }

  @override
  Future<void> deleteAvatarData() async {
    try {
      // Delete from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_avatarIdKey);

      // Delete from SQLite
      final db = await _databaseHelper.database;
      await db.delete(
        _avatarStateTable,
        where: 'id = ?',
        whereArgs: [_avatarStateSingletonId],
      );
    } catch (e) {
      throw DataSourceException(
        'Failed to delete avatar data',
        code: 'DELETE_AVATAR_DATA_FAILED',
        originalError: e,
      );
    }
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
