import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/activity_level.dart';
import '../../domain/entities/gender.dart';
import '../../domain/entities/hydration_goal.dart';
import '../../domain/entities/user.dart';

part 'user_dto.g.dart';

/// Data Transfer Object for User profile
///
/// Provides JSON serialization for Firebase and SQLite persistence.
/// Contains all user profile data including calculated hydration goal.
@JsonSerializable()
class UserDto {
  /// Unique user identifier (UUID)
  final String userId;

  /// User weight in kilograms
  final double weight;

  /// User age in years
  final int age;

  /// Biological gender (serialized as string)
  @JsonKey(name: 'gender')
  final String genderString;

  /// Physical activity level (serialized as string)
  @JsonKey(name: 'activityLevel')
  final String activityLevelString;

  /// Location permission granted
  final bool locationPermissionGranted;

  /// Daily hydration goal in liters
  final double dailyGoalLiters;

  /// Profile creation timestamp (ISO 8601 UTC)
  final String createdAt;

  /// Profile last update timestamp (ISO 8601 UTC)
  final String updatedAt;

  /// Creates a user DTO
  ///
  /// All timestamps must be in ISO 8601 UTC format.
  /// Gender and activity level are stored as string enums.
  const UserDto({
    required this.userId,
    required this.weight,
    required this.age,
    required this.genderString,
    required this.activityLevelString,
    required this.locationPermissionGranted,
    required this.dailyGoalLiters,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates DTO from JSON map
  ///
  /// Used for deserializing from Firestore and SQLite.
  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  /// Converts DTO to JSON map
  ///
  /// Used for serializing to Firestore and SQLite.
  Map<String, dynamic> toJson() => _$UserDtoToJson(this);

  /// Creates DTO from domain entity
  ///
  /// Converts [User] entity to serializable DTO.
  /// Timestamps are converted to ISO 8601 UTC strings.
  factory UserDto.fromEntity(User user) {
    return UserDto(
      userId: user.id,
      weight: user.weight,
      age: user.age,
      genderString: user.gender.name,
      activityLevelString: user.activityLevel.name,
      locationPermissionGranted: false, // Default - not in domain entity
      dailyGoalLiters: user.dailyGoal.targetLiters,
      createdAt: DateTime.now().toUtc().toIso8601String(),
      updatedAt: DateTime.now().toUtc().toIso8601String(),
    );
  }

  /// Converts DTO to domain entity
  ///
  /// Parses string enums back to enum types.
  ///
  /// Throws [ArgumentError] if gender or activity level string is invalid.
  User toEntity() {
    final gender = Gender.values.firstWhere(
      (e) => e.name == genderString,
      orElse: () => throw ArgumentError('Invalid gender: $genderString'),
    );

    final activityLevel = ActivityLevel.values.firstWhere(
      (e) => e.name == activityLevelString,
      orElse: () =>
          throw ArgumentError('Invalid activity level: $activityLevelString'),
    );

    return User(
      id: userId,
      weight: weight,
      age: age,
      gender: gender,
      activityLevel: activityLevel,
      dailyGoal: HydrationGoal(dailyGoalLiters),
    );
  }

  /// Check if profile is complete
  ///
  /// Validates that all required fields are populated with valid values.
  bool isComplete() {
    return userId.isNotEmpty &&
        weight >= 30.0 &&
        weight <= 300.0 &&
        age >= 10 &&
        age <= 120 &&
        dailyGoalLiters >= 1.5 &&
        dailyGoalLiters <= 5.0;
  }

  /// Creates a copy with updated fields
  UserDto copyWith({
    String? userId,
    double? weight,
    int? age,
    String? genderString,
    String? activityLevelString,
    bool? locationPermissionGranted,
    double? dailyGoalLiters,
    String? createdAt,
    String? updatedAt,
  }) {
    return UserDto(
      userId: userId ?? this.userId,
      weight: weight ?? this.weight,
      age: age ?? this.age,
      genderString: genderString ?? this.genderString,
      activityLevelString: activityLevelString ?? this.activityLevelString,
      locationPermissionGranted:
          locationPermissionGranted ?? this.locationPermissionGranted,
      dailyGoalLiters: dailyGoalLiters ?? this.dailyGoalLiters,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
