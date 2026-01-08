import 'avatar_personality.dart';

/// Avatar dehydration states
///
/// Represents the visual state of the avatar based on time since last drink
enum AvatarState {
  /// 0-2h sans boire - Avatar en pleine forme
  fresh,

  /// 2-4h - Avatar fatigué
  tired,

  /// 4-6h - Avatar visiblement desséché
  dehydrated,

  /// 6h+ - Avatar effondré/skull
  dead,

  /// État fantôme après mort (temporaire)
  ghost,
}

extension AvatarStateExtension on AvatarState {
  /// Get next state in dehydration progression
  ///
  /// Returns the next state in the progression:
  /// fresh → tired → dehydrated → dead → ghost → fresh (resurrection)
  AvatarState getNextState() {
    switch (this) {
      case AvatarState.fresh:
        return AvatarState.tired;
      case AvatarState.tired:
        return AvatarState.dehydrated;
      case AvatarState.dehydrated:
        return AvatarState.dead;
      case AvatarState.dead:
        return AvatarState.ghost; // Transition automatique après 10s
      case AvatarState.ghost:
        return AvatarState.fresh; // Résurrection à minuit
    }
  }

  /// Check if avatar should die based on time since last drink
  ///
  /// [timeSinceLastDrink] Duration since last hydration validation
  /// Returns true if time >= 6 hours
  bool shouldDie(Duration timeSinceLastDrink) {
    return timeSinceLastDrink.inHours >= 6;
  }

  /// Check if avatar should transition to ghost state
  ///
  /// Returns true if current state is dead (will transition after 10s delay)
  bool shouldBecomeGhost() {
    return this == AvatarState.dead;
  }

  /// Get asset path for this state and personality combination
  ///
  /// [personality] The avatar personality
  /// Returns path like: assets/images/avatars/sports_coach/tired.png
  String getAssetPath(AvatarPersonality personality) {
    return 'assets/images/avatars/${personality.name}/$name.png';
  }
}
