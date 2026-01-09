import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/avatar_personality.dart';
import '../../domain/entities/avatar_state.dart';

/// Provider for avatar asset management
///
/// Provides emoji placeholder assets for avatar personalities and states.
/// Currently uses emoji placeholders. Will support real images (PNG) in future.
///
/// Total combinations: 4 personalities × 5 states = 20 assets
final avatarAssetProvider = Provider<AvatarAssetProvider>((ref) {
  return AvatarAssetProvider();
});

/// Service for loading avatar assets based on personality and state
///
/// Phase 1 (MVP): Returns emoji placeholders
/// Phase 2 (Future): Will load actual PNG images from assets/avatars/
class AvatarAssetProvider {
  /// Emoji placeholders mapping
  ///
  /// Structure: [personality][state] = emoji
  final Map<AvatarPersonality, Map<AvatarState, String>> _emojiAssets = {
    AvatarPersonality.authoritarianMother: {
      AvatarState.fresh: '👩😊',
      AvatarState.tired: '👩😐',
      AvatarState.dehydrated: '👩😟',
      AvatarState.dead: '👩💀',
      AvatarState.ghost: '👻',
    },
    AvatarPersonality.sportsCoach: {
      AvatarState.fresh: '💪😊',
      AvatarState.tired: '💪😐',
      AvatarState.dehydrated: '💪😟',
      AvatarState.dead: '💪💀',
      AvatarState.ghost: '👻',
    },
    AvatarPersonality.doctor: {
      AvatarState.fresh: '🧑‍⚕️😊',
      AvatarState.tired: '🧑‍⚕️😐',
      AvatarState.dehydrated: '🧑‍⚕️😟',
      AvatarState.dead: '🧑‍⚕️💀',
      AvatarState.ghost: '👻',
    },
    AvatarPersonality.sarcasticFriend: {
      AvatarState.fresh: '🤝😊',
      AvatarState.tired: '🤝😐',
      AvatarState.dehydrated: '🤝😟',
      AvatarState.dead: '🤝💀',
      AvatarState.ghost: '👻',
    },
  };

  /// Get emoji asset for given personality and state combination
  ///
  /// [personality] Avatar personality (4 types)
  /// [state] Avatar state (5 types)
  ///
  /// Returns emoji string representing the avatar.
  ///
  /// Throws [ArgumentError] if combination not found (should never happen).
  ///
  /// Example:
  /// ```dart
  /// final provider = AvatarAssetProvider();
  /// final emoji = provider.getEmojiAsset(
  ///   AvatarPersonality.doctor,
  ///   AvatarState.fresh,
  /// ); // Returns '🧑‍⚕️😊'
  /// ```
  String getEmojiAsset(AvatarPersonality personality, AvatarState state) {
    final personalityAssets = _emojiAssets[personality];
    if (personalityAssets == null) {
      throw ArgumentError(
        'No assets found for personality: ${personality.name}',
      );
    }

    final emoji = personalityAssets[state];
    if (emoji == null) {
      throw ArgumentError(
        'No asset found for personality: ${personality.name}, state: ${state.name}',
      );
    }

    return emoji;
  }

  /// Get asset file path for given personality and state
  ///
  /// [personality] Avatar personality
  /// [state] Avatar state
  ///
  /// Returns path like: assets/avatars/doctor/fresh.txt
  ///
  /// Note: Currently returns .txt files with emoji content.
  /// Future: Will return .png paths when real images are added.
  ///
  /// Example:
  /// ```dart
  /// final path = provider.getAssetPath(
  ///   AvatarPersonality.sportsCoach,
  ///   AvatarState.tired,
  /// ); // Returns 'assets/avatars/sportsCoach/tired.txt'
  /// ```
  String getAssetPath(AvatarPersonality personality, AvatarState state) {
    return 'assets/avatars/${personality.name}/${state.name}.txt';
  }

  /// Validate that all 20 asset combinations exist
  ///
  /// Returns true if all 4 personalities × 5 states are mapped.
  ///
  /// This is used in tests to ensure no assets are missing.
  bool validateAllAssetsExist() {
    // Check all personalities present
    for (final personality in AvatarPersonality.values) {
      if (!_emojiAssets.containsKey(personality)) {
        return false;
      }

      // Check all states present for this personality
      final states = _emojiAssets[personality]!;
      for (final state in AvatarState.values) {
        if (!states.containsKey(state)) {
          return false;
        }
      }
    }

    return true;
  }

  /// Get total number of asset combinations
  ///
  /// Should always return 20 (4 personalities × 5 states)
  int get totalAssetCount {
    int count = 0;
    for (final personalityAssets in _emojiAssets.values) {
      count += personalityAssets.length;
    }
    return count;
  }
}
