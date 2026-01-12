import '../../entities/activity_level.dart';
import '../../entities/gender.dart';
import '../../entities/hydration_goal.dart';
import '../../entities/user.dart';

/// Use case for calculating personalized daily hydration goal
///
/// Implements evidence-based hydration calculation algorithm using:
/// - Base formula: weight × 0.033 L/kg (EFSA recommendations)
/// - Activity level adjustments (sedentary to extreme)
/// - Gender-specific adjustments (male/female/other)
/// - Age-related adjustments (<30, 30-55, >55)
///
/// The algorithm ensures safety bounds (1.5L min, 5.0L max) and rounds
/// results to 0.1L precision for user-friendly display.
///
/// Scientific References:
/// - EFSA Panel on Dietetic Products, Nutrition, and Allergies (2010).
///   "Scientific Opinion on Dietary Reference Values for water"
/// - Institute of Medicine (IOM). "Dietary Reference Intakes for Water,
///   Potassium, Sodium, Chloride, and Sulfate" (2005)
/// - Armstrong LE, Johnson EC. "Water Intake, Water Balance, and the
///   Elusive Daily Water Requirement" (2018)
class CalculateHydrationGoalUseCase {
  /// Base hydration factor in liters per kilogram
  ///
  /// Based on EFSA recommendations for adequate water intake
  static const double _kBaseHydrationFactor = 0.033;

  /// Calculate personalized hydration goal for a user
  ///
  /// Takes a [User] entity and returns a calculated [HydrationGoal]
  /// with all physiological and lifestyle adjustments applied.
  ///
  /// Algorithm steps:
  /// 1. Calculate base hydration (weight × 0.033L)
  /// 2. Apply activity level multiplier (1.0 to 1.5)
  /// 3. Apply gender multiplier (0.95 to 1.0)
  /// 4. Apply age multiplier (0.9 to 1.0)
  /// 5. Round to 0.1L precision
  /// 6. Enforce safety bounds (1.5L to 5.0L)
  ///
  /// Returns a [HydrationGoal] value object with validated target
  ///
  /// Example:
  /// ```dart
  /// final user = User(
  ///   weight: 75.0,
  ///   age: 30,
  ///   gender: Gender.male,
  ///   activityLevel: ActivityLevel.sedentary,
  /// );
  /// final goal = CalculateHydrationGoalUseCase().execute(user);
  /// // Returns HydrationGoal(2.5L) for 75kg male, 30 years, sedentary
  /// ```
  HydrationGoal execute(User user) {
    // Step 1: Calculate base hydration need
    double goal = user.weight * _kBaseHydrationFactor;

    // Step 2: Apply activity level multiplier
    goal *= _getActivityMultiplier(user.activityLevel);

    // Step 3: Apply gender-specific multiplier
    goal *= _getGenderMultiplier(user.gender);

    // Step 4: Apply age-related multiplier
    goal *= _getAgeMultiplier(user.age);

    // Step 5: Round to 0.1L precision for readability
    goal = _roundToNearestTenth(goal);

    // Step 6: Enforce safety bounds (HydrationGoal constructor handles this)
    goal = goal.clamp(HydrationGoal.kMinGoal, HydrationGoal.kMaxGoal);

    return HydrationGoal(goal);
  }

  /// Get activity level multiplier
  ///
  /// Returns adjustment factor based on physical activity frequency/intensity:
  /// - Sedentary: 1.0 (no adjustment)
  /// - Light (1-3x/week): 1.1 (+10%)
  /// - Moderate (3-5x/week): 1.2 (+20%)
  /// - Very Active (6-7x/week): 1.3 (+30%)
  /// - Extremely Active (intense daily): 1.5 (+50%)
  ///
  /// Based on increased fluid loss through perspiration during exercise
  double _getActivityMultiplier(ActivityLevel level) {
    switch (level) {
      case ActivityLevel.sedentary:
        return 1.0;
      case ActivityLevel.light:
        return 1.1;
      case ActivityLevel.moderate:
        return 1.2;
      case ActivityLevel.veryActive:
        return 1.3;
      case ActivityLevel.extremelyActive:
        return 1.5;
    }
  }

  /// Get gender-specific multiplier
  ///
  /// Returns adjustment factor based on biological differences:
  /// - Male: 1.0 (baseline)
  /// - Female: 0.95 (-5%, lower body water percentage)
  /// - Other: 1.0 (baseline, no assumption)
  ///
  /// Based on differences in average body composition and water retention
  double _getGenderMultiplier(Gender gender) {
    switch (gender) {
      case Gender.male:
        return 1.0;
      case Gender.female:
        return 0.95;
      case Gender.other:
        return 1.0;
    }
  }

  /// Get age-related multiplier
  ///
  /// Returns adjustment factor based on age-related metabolic changes:
  /// - 30 years or younger: 1.0 (optimal hydration needs)
  /// - 31-55 years: 0.95 (-5%, slightly reduced metabolic rate)
  /// - Over 55: 0.9 (-10%, reduced metabolic rate, lower muscle mass)
  ///
  /// Based on age-related changes in body composition and basal metabolic rate
  double _getAgeMultiplier(int age) {
    if (age <= 30) {
      return 1.0;
    } else if (age <= 55) {
      return 0.95;
    } else {
      return 0.9;
    }
  }

  /// Round value to nearest 0.1 liter
  ///
  /// Provides user-friendly precision (e.g., 2.3L instead of 2.347L)
  /// Uses integer arithmetic to avoid floating-point precision issues
  double _roundToNearestTenth(double value) {
    // Multiply by 10, round to integer, divide by 10 for clean decimal
    return (value * 10).round() / 10.0;
  }
}
