import '../../domain/entities/avatar.dart';
import '../../domain/entities/avatar_state.dart';
import '../../domain/repositories/avatar_repository.dart';
import '../data_sources/local/avatar_local_data_source.dart';
import '../models/avatar_dto.dart';

/// Implementation of AvatarRepository using local data sources
///
/// Manages avatar persistence with offline-first strategy.
/// Uses SharedPreferences for avatar ID and SQLite for avatar state.
class AvatarRepositoryImpl implements AvatarRepository {
  final AvatarLocalDataSource _localDataSource;

  /// Avatar ID to name mapping
  static const Map<String, String> _avatarNames = {
    'authoritarianMother': 'Maman Autoritaire',
    'sportsCoach': 'Coach Sportif',
    'doctor': 'Docteur',
    'sarcasticFriend': 'Ami Sarcastique',
  };

  AvatarRepositoryImpl(this._localDataSource);

  @override
  Future<Avatar?> getAvatar() async {
    try {
      // Get selected avatar ID from SharedPreferences
      final avatarId = await _localDataSource.getSelectedAvatarId();
      if (avatarId == null) {
        return null; // No avatar selected yet
      }

      // Get avatar state from SQLite
      final avatarDto = await _localDataSource.getAvatarState();
      if (avatarDto == null) {
        // Avatar ID exists but no state - create default fresh state
        final now = DateTime.now();
        final defaultDto = AvatarDto(
          id: 'avatar_singleton',
          name: _getAvatarName(avatarId),
          personalityString: avatarId,
          currentStateString: 'fresh',
          lastDrinkTime: now.toUtc().toIso8601String(),
          lastUpdated: now.toUtc().toIso8601String(),
        );
        await _localDataSource.saveAvatarState(defaultDto);
        return defaultDto.toEntity();
      }

      // Convert DTO to entity
      return avatarDto.toEntity();
    } catch (e) {
      throw StorageException(
        'Failed to get avatar',
        code: 'GET_AVATAR_FAILED',
        originalError: e,
      );
    }
  }

  @override
  Future<void> saveSelectedAvatar(String avatarId) async {
    try {
      // Validate avatar ID
      if (!_avatarNames.containsKey(avatarId)) {
        throw StorageException(
          'Invalid avatar ID: $avatarId',
          code: 'INVALID_AVATAR_ID',
        );
      }

      // Save avatar ID to SharedPreferences
      await _localDataSource.saveSelectedAvatarId(avatarId);

      // Initialize avatar state in SQLite with fresh state
      final now = DateTime.now();
      final avatarDto = AvatarDto(
        id: 'avatar_singleton',
        name: _getAvatarName(avatarId),
        personalityString: avatarId,
        currentStateString: 'fresh',
        lastDrinkTime: now.toUtc().toIso8601String(),
        lastUpdated: now.toUtc().toIso8601String(),
      );

      await _localDataSource.saveAvatarState(avatarDto);
    } catch (e) {
      if (e is StorageException) rethrow;
      throw StorageException(
        'Failed to save selected avatar',
        code: 'SAVE_SELECTED_AVATAR_FAILED',
        originalError: e,
      );
    }
  }

  @override
  Future<void> updateAvatarState(AvatarState state) async {
    try {
      await _localDataSource.updateAvatarStateField(state.name);
    } catch (e) {
      throw StorageException(
        'Failed to update avatar state',
        code: 'UPDATE_AVATAR_STATE_FAILED',
        originalError: e,
      );
    }
  }

  @override
  Future<void> updateLastDrinkTime(DateTime timestamp) async {
    try {
      await _localDataSource.updateLastDrinkTime(timestamp);
    } catch (e) {
      throw StorageException(
        'Failed to update last drink time',
        code: 'UPDATE_LAST_DRINK_TIME_FAILED',
        originalError: e,
      );
    }
  }

  @override
  Future<DateTime?> getLastDrinkTime() async {
    try {
      final avatarDto = await _localDataSource.getAvatarState();
      if (avatarDto == null) {
        return null;
      }
      return DateTime.parse(avatarDto.lastDrinkTime);
    } catch (e) {
      throw StorageException(
        'Failed to get last drink time',
        code: 'GET_LAST_DRINK_TIME_FAILED',
        originalError: e,
      );
    }
  }

  @override
  Future<DateTime?> getDeathTime() async {
    try {
      final deathTimeString = await _localDataSource.getDeathTime();
      if (deathTimeString == null) {
        return null;
      }
      return DateTime.parse(deathTimeString);
    } catch (e) {
      throw StorageException(
        'Failed to get death time',
        code: 'GET_DEATH_TIME_FAILED',
        originalError: e,
      );
    }
  }

  @override
  Future<void> updateDeathTime(DateTime? timestamp) async {
    try {
      await _localDataSource.updateDeathTime(timestamp);
    } catch (e) {
      throw StorageException(
        'Failed to update death time',
        code: 'UPDATE_DEATH_TIME_FAILED',
        originalError: e,
      );
    }
  }

  /// Get avatar display name from ID
  String _getAvatarName(String avatarId) {
    return _avatarNames[avatarId] ?? 'Avatar';
  }
}
