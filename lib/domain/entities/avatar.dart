import 'package:equatable/equatable.dart';

import 'avatar_personality.dart';
import 'avatar_state.dart';

/// Avatar entity representing the Tamagotchi-style companion
///
/// Pure business logic entity for the avatar system.
/// Tracks personality, state, and last drink time.
class Avatar extends Equatable {
  /// Unique identifier for this avatar (e.g., "sports_coach")
  final String id;

  /// Display name (e.g., "Coach Sportif")
  final String name;

  /// Personality type determining communication style
  final AvatarPersonality personality;

  /// Current dehydration state
  final AvatarState currentState;

  /// Timestamp of last drink validation
  final DateTime lastDrinkTime;

  /// Timestamp of last state update
  final DateTime lastUpdated;

  /// Creates an avatar entity
  ///
  /// All fields are required and immutable.
  const Avatar({
    required this.id,
    required this.name,
    required this.personality,
    required this.currentState,
    required this.lastDrinkTime,
    required this.lastUpdated,
  });

  /// Calculate current state based on time since last drink
  ///
  /// [timeSinceLastDrink] Duration since last hydration
  /// Returns appropriate [AvatarState] based on time thresholds:
  /// - 0-2h: fresh
  /// - 2-4h: tired
  /// - 4-6h: dehydrated
  /// - 6h+: dead
  AvatarState calculateState(Duration timeSinceLastDrink) {
    final hours = timeSinceLastDrink.inHours;

    if (hours < 2) return AvatarState.fresh;
    if (hours < 4) return AvatarState.tired;
    if (hours < 6) return AvatarState.dehydrated;
    return AvatarState.dead;
  }

  /// Check if avatar should transition to ghost state
  ///
  /// Returns true if current state is dead
  bool shouldBecomeGhost() {
    return currentState == AvatarState.dead;
  }

  /// Check if avatar should be resurrected
  ///
  /// Returns true if current state is ghost (resurrection happens at midnight)
  bool shouldResurrect() {
    return currentState == AvatarState.ghost;
  }

  /// Create a copy with updated fields
  Avatar copyWith({
    String? id,
    String? name,
    AvatarPersonality? personality,
    AvatarState? currentState,
    DateTime? lastDrinkTime,
    DateTime? lastUpdated,
  }) {
    return Avatar(
      id: id ?? this.id,
      name: name ?? this.name,
      personality: personality ?? this.personality,
      currentState: currentState ?? this.currentState,
      lastDrinkTime: lastDrinkTime ?? this.lastDrinkTime,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        personality,
        currentState,
        lastDrinkTime,
        lastUpdated,
      ];

  @override
  String toString() {
    return 'Avatar(id: $id, name: $name, personality: $personality, '
        'currentState: $currentState, lastDrinkTime: $lastDrinkTime, '
        'lastUpdated: $lastUpdated)';
  }
}
