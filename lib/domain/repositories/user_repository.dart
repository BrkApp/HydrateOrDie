import '../entities/user.dart';

/// Repository interface for user profile persistence and retrieval
///
/// Manages user profile data between sessions using SQLite.
/// Implements singleton pattern (one profile per app installation).
abstract class UserRepository {
  /// Get current user profile
  ///
  /// Returns null if no profile exists (first launch or onboarding not completed).
  /// Loads profile from SQLite local storage.
  Future<User?> getProfile();

  /// Save user profile after onboarding
  ///
  /// Creates or replaces existing profile (singleton pattern).
  /// All profile fields are required.
  ///
  /// Throws [StorageException] if save fails.
  Future<void> saveProfile(User user);

  /// Update existing user profile
  ///
  /// Updates profile fields and recalculates hydration goal if needed.
  /// Used when user modifies their profile settings.
  ///
  /// Throws [StorageException] if update fails.
  /// Throws [ProfileNotFoundException] if no profile exists.
  Future<void> updateProfile(User user);

  /// Delete user profile
  ///
  /// Removes profile from local storage.
  /// Used for account deletion or app reset.
  ///
  /// Throws [StorageException] if delete fails.
  Future<void> deleteProfile();

  /// Check if user profile exists
  ///
  /// Returns true if profile is saved and complete.
  /// Used for conditional routing (onboarding vs home).
  Future<bool> hasProfile();
}

/// Exception thrown when user storage operations fail
class StorageException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  StorageException(this.message, {this.code, this.originalError});

  @override
  String toString() => 'StorageException: $message (code: $code)';
}

/// Exception thrown when profile is not found for update/delete operations
class ProfileNotFoundException implements Exception {
  final String message;

  ProfileNotFoundException([this.message = 'User profile not found']);

  @override
  String toString() => 'ProfileNotFoundException: $message';
}
