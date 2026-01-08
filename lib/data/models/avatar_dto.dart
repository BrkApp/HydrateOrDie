import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/avatar.dart';
import '../../domain/entities/avatar_personality.dart';
import '../../domain/entities/avatar_state.dart';

part 'avatar_dto.g.dart';

/// Data Transfer Object for Avatar entity
///
/// Provides JSON serialization for Firebase and SQLite persistence.
/// Converts between domain entities and JSON representations.
@JsonSerializable()
class AvatarDto {
  /// Avatar unique identifier (e.g., "sports_coach")
  final String id;

  /// Display name (e.g., "Coach Sportif")
  final String name;

  /// Personality type (serialized as string)
  @JsonKey(name: 'personality')
  final String personalityString;

  /// Current dehydration state (serialized as string)
  @JsonKey(name: 'currentState')
  final String currentStateString;

  /// Timestamp of last drink validation (ISO 8601 UTC)
  final String lastDrinkTime;

  /// Timestamp of last state update (ISO 8601 UTC)
  final String lastUpdated;

  /// Creates an avatar DTO
  ///
  /// All timestamps must be in ISO 8601 UTC format.
  /// Personality and state are stored as string enums.
  const AvatarDto({
    required this.id,
    required this.name,
    required this.personalityString,
    required this.currentStateString,
    required this.lastDrinkTime,
    required this.lastUpdated,
  });

  /// Creates DTO from JSON map
  ///
  /// Used for deserializing from Firestore and SQLite.
  factory AvatarDto.fromJson(Map<String, dynamic> json) =>
      _$AvatarDtoFromJson(json);

  /// Converts DTO to JSON map
  ///
  /// Used for serializing to Firestore and SQLite.
  Map<String, dynamic> toJson() => _$AvatarDtoToJson(this);

  /// Creates DTO from domain entity
  ///
  /// Converts [Avatar] entity to serializable DTO.
  /// Timestamps are converted to ISO 8601 UTC strings.
  factory AvatarDto.fromEntity(Avatar avatar) {
    return AvatarDto(
      id: avatar.id,
      name: avatar.name,
      personalityString: avatar.personality.name,
      currentStateString: avatar.currentState.name,
      lastDrinkTime: avatar.lastDrinkTime.toUtc().toIso8601String(),
      lastUpdated: avatar.lastUpdated.toUtc().toIso8601String(),
    );
  }

  /// Converts DTO to domain entity
  ///
  /// Parses string enums back to enum types and ISO 8601 strings to DateTime.
  ///
  /// Throws [ArgumentError] if personality or state string is invalid.
  Avatar toEntity() {
    final personality = AvatarPersonality.values.firstWhere(
      (e) => e.name == personalityString,
      orElse: () => throw ArgumentError(
          'Invalid personality: $personalityString'),
    );

    final currentState = AvatarState.values.firstWhere(
      (e) => e.name == currentStateString,
      orElse: () =>
          throw ArgumentError('Invalid state: $currentStateString'),
    );

    return Avatar(
      id: id,
      name: name,
      personality: personality,
      currentState: currentState,
      lastDrinkTime: DateTime.parse(lastDrinkTime),
      lastUpdated: DateTime.parse(lastUpdated),
    );
  }

  /// Creates a copy with updated fields
  AvatarDto copyWith({
    String? id,
    String? name,
    String? personalityString,
    String? currentStateString,
    String? lastDrinkTime,
    String? lastUpdated,
  }) {
    return AvatarDto(
      id: id ?? this.id,
      name: name ?? this.name,
      personalityString: personalityString ?? this.personalityString,
      currentStateString: currentStateString ?? this.currentStateString,
      lastDrinkTime: lastDrinkTime ?? this.lastDrinkTime,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
