import 'package:equatable/equatable.dart';

import 'activity_level.dart';
import 'gender.dart';
import 'hydration_goal.dart';

/// User entity representing the user profile
///
/// Pure domain entity for user data.
/// Contains profile information needed for hydration goal calculation.
class User extends Equatable {
  /// Unique user identifier (UUID)
  final String id;

  /// User weight in kilograms
  final double weight;

  /// User age in years
  final int age;

  /// Biological gender for calculation purposes
  final Gender gender;

  /// Physical activity level
  final ActivityLevel activityLevel;

  /// Daily hydration goal (value object)
  final HydrationGoal dailyGoal;

  /// Creates a user entity
  ///
  /// All fields are required and immutable.
  /// [weight] must be between 30.0 and 300.0 kg
  /// [age] must be between 10 and 120 years
  const User({
    required this.id,
    required this.weight,
    required this.age,
    required this.gender,
    required this.activityLevel,
    required this.dailyGoal,
  });

  /// Check if user needs goal recalculation
  ///
  /// Compares current user data with previous profile to determine
  /// if hydration goal should be recalculated.
  ///
  /// Returns true if weight, age, gender, or activity level changed.
  bool needsGoalRecalculation(User oldUser) {
    return weight != oldUser.weight ||
        age != oldUser.age ||
        gender != oldUser.gender ||
        activityLevel != oldUser.activityLevel;
  }

  /// Create a copy with updated fields
  User copyWith({
    String? id,
    double? weight,
    int? age,
    Gender? gender,
    ActivityLevel? activityLevel,
    HydrationGoal? dailyGoal,
  }) {
    return User(
      id: id ?? this.id,
      weight: weight ?? this.weight,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      activityLevel: activityLevel ?? this.activityLevel,
      dailyGoal: dailyGoal ?? this.dailyGoal,
    );
  }

  @override
  List<Object?> get props => [
        id,
        weight,
        age,
        gender,
        activityLevel,
        dailyGoal,
      ];

  @override
  String toString() {
    return 'User(id: $id, weight: $weight, age: $age, '
        'gender: $gender, activityLevel: $activityLevel, '
        'dailyGoal: $dailyGoal)';
  }
}
