import '../entities/avatar.dart';
import '../entities/avatar_state.dart';

/// Repository interface for avatar persistence and retrieval
///
/// Manages selected avatar ID and avatar state between sessions.
/// Uses SharedPreferences for avatar ID and SQLite for state data.
abstract class AvatarRepository {
  /// Get currently selected avatar with current state
  ///
  /// Returns null if no avatar selected (first launch).
  /// Loads both avatar ID (SharedPreferences) and state (SQLite).
  Future<Avatar?> getAvatar();

  /// Save selected avatar during onboarding or avatar change
  ///
  /// Stores avatar ID in SharedPreferences and initializes state in SQLite.
  /// [avatarId] must be one of: 'authoritarianMother', 'sportsCoach', 'doctor', 'sarcasticFriend'
  ///
  /// Throws [StorageException] if save fails.
  Future<void> saveSelectedAvatar(String avatarId);

  /// Update avatar state (fresh/tired/dehydrated/dead/ghost)
  ///
  /// Updates the dehydration state in SQLite with current timestamp.
  /// Called by background timer or manual state transition.
  ///
  /// Throws [StorageException] if update fails.
  Future<void> updateAvatarState(AvatarState state);

  /// Update last drink time when user validates hydration
  ///
  /// Resets avatar state to fresh and updates last_drink_time.
  /// Called after successful hydration photo validation.
  ///
  /// Throws [StorageException] if update fails.
  Future<void> updateLastDrinkTime(DateTime timestamp);

  /// Get last drink timestamp
  ///
  /// Returns null if no hydration recorded yet (first launch).
  /// Used for calculating time-based state transitions.
  Future<DateTime?> getLastDrinkTime();

  /// Get death time timestamp (when avatar entered dead state)
  ///
  /// Returns null if avatar never died or has been resurrected.
  /// Used for calculating dead → ghost transition (10 seconds delay).
  Future<DateTime?> getDeathTime();

  /// Update death time when avatar transitions to dead state
  ///
  /// Stores timestamp when avatar entered dead state.
  /// Set to null when avatar is resurrected or drinks water.
  ///
  /// Throws [StorageException] if update fails.
  Future<void> updateDeathTime(DateTime? timestamp);
}

/// Exception thrown when avatar storage operations fail
class StorageException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  StorageException(this.message, {this.code, this.originalError});

  @override
  String toString() => 'StorageException: $message (code: $code)';
}
