import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../data_sources/local/user_local_data_source.dart';
import '../models/user_dto.dart';

/// Implementation of UserRepository using local data source
///
/// Manages user profile persistence with offline-first strategy.
/// Uses SQLite for local storage (singleton pattern).
class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource _localDataSource;

  UserRepositoryImpl(this._localDataSource);

  @override
  Future<User?> getProfile() async {
    try {
      final userDto = await _localDataSource.getUserProfile();
      if (userDto == null) {
        return null; // No profile exists yet
      }

      // Convert DTO to entity
      return userDto.toEntity();
    } catch (e) {
      throw StorageException(
        'Failed to get user profile',
        code: 'GET_PROFILE_FAILED',
        originalError: e,
      );
    }
  }

  @override
  Future<void> saveProfile(User user) async {
    try {
      // Convert entity to DTO
      final userDto = UserDto.fromEntity(user);

      // Save to local storage
      await _localDataSource.saveUserProfile(userDto);
    } catch (e) {
      throw StorageException(
        'Failed to save user profile',
        code: 'SAVE_PROFILE_FAILED',
        originalError: e,
      );
    }
  }

  @override
  Future<void> updateProfile(User user) async {
    try {
      // Check if profile exists
      final exists = await _localDataSource.hasUserProfile();
      if (!exists) {
        throw ProfileNotFoundException(
          'Cannot update profile: no profile exists. Use saveProfile instead.',
        );
      }

      // Convert entity to DTO
      final userDto = UserDto.fromEntity(user);

      // Update in local storage
      await _localDataSource.updateUserProfile(userDto);
    } catch (e) {
      if (e is ProfileNotFoundException) rethrow;
      throw StorageException(
        'Failed to update user profile',
        code: 'UPDATE_PROFILE_FAILED',
        originalError: e,
      );
    }
  }

  @override
  Future<void> deleteProfile() async {
    try {
      await _localDataSource.deleteUserProfile();
    } catch (e) {
      throw StorageException(
        'Failed to delete user profile',
        code: 'DELETE_PROFILE_FAILED',
        originalError: e,
      );
    }
  }

  @override
  Future<bool> hasProfile() async {
    try {
      return await _localDataSource.hasUserProfile();
    } catch (e) {
      throw StorageException(
        'Failed to check profile existence',
        code: 'HAS_PROFILE_FAILED',
        originalError: e,
      );
    }
  }
}
