import 'package:equatable/equatable.dart';

/// Value object for daily hydration goal
///
/// Immutable value object representing the target hydration in liters per day.
/// Enforces min/max bounds for safety.
class HydrationGoal extends Equatable {
  /// Minimum allowed goal in liters
  static const double kMinGoal = 1.5;

  /// Maximum allowed goal in liters
  static const double kMaxGoal = 5.0;

  /// Target hydration in liters per day
  final double targetLiters;

  /// Creates a hydration goal with validation
  ///
  /// [targetLiters] must be between [kMinGoal] and [kMaxGoal]
  /// Throws [ArgumentError] if validation fails
  HydrationGoal(this.targetLiters) {
    if (targetLiters < kMinGoal || targetLiters > kMaxGoal) {
      throw ArgumentError(
        'Goal must be between $kMinGoal and $kMaxGoal liters. Got: $targetLiters',
      );
    }
  }

  /// Check if goal is achieved with current volume
  ///
  /// [currentVolume] Total volume drunk today in liters
  /// Returns true if current volume >= target
  bool isAchieved(double currentVolume) {
    return currentVolume >= targetLiters;
  }

  /// Calculate progress percentage
  ///
  /// [currentVolume] Total volume drunk today in liters
  /// Returns progress as percentage (0.0 to 1.0+)
  /// Can exceed 1.0 if user drinks more than goal
  double getProgressPercentage(double currentVolume) {
    if (targetLiters == 0) return 0.0;
    return currentVolume / targetLiters;
  }

  @override
  List<Object?> get props => [targetLiters];

  @override
  String toString() => 'HydrationGoal(targetLiters: $targetLiters)';
}
