import 'package:sqflite/sqflite.dart';

import '../../models/user_dto.dart';
import 'database_helper.dart';

/// Local data source for user profile persistence
///
/// Uses SQLite for user profile storage.
/// Implements singleton pattern (one profile per app installation).
abstract class UserLocalDataSource {
  /// Get user profile from SQLite
  ///
  /// Returns null if no profile exists (first launch).
  Future<UserDto?> getUserProfile();

  /// Save or update user profile in SQLite
  ///
  /// Uses INSERT OR REPLACE (upsert) for singleton pattern.
  Future<void> saveUserProfile(UserDto userDto);

  /// Update existing user profile
  ///
  /// Updates only non-null fields.
  /// Automatically updates the updatedAt timestamp.
  Future<void> updateUserProfile(UserDto userDto);

  /// Delete user profile from SQLite
  ///
  /// Used for account deletion or app reset.
  Future<void> deleteUserProfile();

  /// Check if user profile exists
  Future<bool> hasUserProfile();
}

/// Implementation of UserLocalDataSource
class UserLocalDataSourceImpl implements UserLocalDataSource {
  static const String _userProfileTable = 'user_profile';
  static const String _userProfileSingletonId = 'user_singleton';

  final DatabaseHelper _databaseHelper;

  UserLocalDataSourceImpl(this._databaseHelper);

  @override
  Future<UserDto?> getUserProfile() async {
    try {
      final db = await _databaseHelper.database;
      final results = await db.query(
        _userProfileTable,
        where: 'id = ?',
        whereArgs: [_userProfileSingletonId],
        limit: 1,
      );

      if (results.isEmpty) {
        return null;
      }

      // Map snake_case DB columns to camelCase JSON keys
      final json = _mapDbRowToJson(results.first);
      return UserDto.fromJson(json);
    } catch (e) {
      throw DataSourceException(
        'Failed to get user profile',
        code: 'GET_USER_PROFILE_FAILED',
        originalError: e,
      );
    }
  }

  @override
  Future<void> saveUserProfile(UserDto userDto) async {
    try {
      final db = await _databaseHelper.database;
      final dbRow = _mapJsonToDbRow(userDto.toJson());

      // Use INSERT OR REPLACE for upsert (singleton pattern)
      await db.insert(
        _userProfileTable,
        dbRow,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw DataSourceException(
        'Failed to save user profile',
        code: 'SAVE_USER_PROFILE_FAILED',
        originalError: e,
      );
    }
  }

  @override
  Future<void> updateUserProfile(UserDto userDto) async {
    try {
      final db = await _databaseHelper.database;
      final dbRow = _mapJsonToDbRow(userDto.toJson());

      // Update with new updatedAt timestamp
      dbRow['updated_at'] = DateTime.now().toUtc().toIso8601String();

      final rowsAffected = await db.update(
        _userProfileTable,
        dbRow,
        where: 'id = ?',
        whereArgs: [_userProfileSingletonId],
      );

      if (rowsAffected == 0) {
        throw DataSourceException(
          'User profile not found for update',
          code: 'USER_PROFILE_NOT_FOUND',
        );
      }
    } catch (e) {
      if (e is DataSourceException) rethrow;
      throw DataSourceException(
        'Failed to update user profile',
        code: 'UPDATE_USER_PROFILE_FAILED',
        originalError: e,
      );
    }
  }

  @override
  Future<void> deleteUserProfile() async {
    try {
      final db = await _databaseHelper.database;
      await db.delete(
        _userProfileTable,
        where: 'id = ?',
        whereArgs: [_userProfileSingletonId],
      );
    } catch (e) {
      throw DataSourceException(
        'Failed to delete user profile',
        code: 'DELETE_USER_PROFILE_FAILED',
        originalError: e,
      );
    }
  }

  @override
  Future<bool> hasUserProfile() async {
    try {
      final db = await _databaseHelper.database;
      final results = await db.query(
        _userProfileTable,
        columns: ['id'],
        where: 'id = ?',
        whereArgs: [_userProfileSingletonId],
        limit: 1,
      );

      return results.isNotEmpty;
    } catch (e) {
      throw DataSourceException(
        'Failed to check user profile existence',
        code: 'CHECK_USER_PROFILE_FAILED',
        originalError: e,
      );
    }
  }

  /// Map database row (snake_case) to JSON (camelCase)
  Map<String, dynamic> _mapDbRowToJson(Map<String, dynamic> dbRow) {
    return {
      'userId': dbRow['user_id'], // Note: Use user_id column, not id (which is singleton key)
      'weight': dbRow['weight'],
      'age': dbRow['age'],
      'gender': dbRow['gender'],
      'activityLevel': dbRow['activity_level'],
      'locationPermissionGranted':
          dbRow['location_permission_granted'] == 1 ? true : false,
      'dailyGoalLiters': dbRow['daily_goal_liters'],
      'createdAt': dbRow['created_at'],
      'updatedAt': dbRow['updated_at'],
    };
  }

  /// Map JSON (camelCase) to database row (snake_case)
  Map<String, dynamic> _mapJsonToDbRow(Map<String, dynamic> json) {
    return {
      'id': _userProfileSingletonId, // Force singleton ID (primary key)
      'user_id': json['userId'], // Store actual user UUID
      'weight': json['weight'],
      'age': json['age'],
      'gender': json['gender'], // Note: JSON key is 'gender', not 'genderString'
      'activity_level': json['activityLevel'], // Note: JSON key is 'activityLevel', not 'activityLevelString'
      'location_permission_granted':
          json['locationPermissionGranted'] == true ? 1 : 0,
      'daily_goal_liters': json['dailyGoalLiters'],
      'created_at': json['createdAt'],
      'updated_at': json['updatedAt'],
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
