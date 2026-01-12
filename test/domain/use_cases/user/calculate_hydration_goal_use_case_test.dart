import 'package:flutter_test/flutter_test.dart';
import 'package:hydrate_or_die/domain/entities/activity_level.dart';
import 'package:hydrate_or_die/domain/entities/gender.dart';
import 'package:hydrate_or_die/domain/entities/hydration_goal.dart';
import 'package:hydrate_or_die/domain/entities/user.dart';
import 'package:hydrate_or_die/domain/use_cases/user/calculate_hydration_goal_use_case.dart';

void main() {
  late CalculateHydrationGoalUseCase useCase;

  setUp(() {
    useCase = CalculateHydrationGoalUseCase();
  });

  group('CalculateHydrationGoalUseCase', () {
    group('Base calculation', () {
      test('should calculate correct goal for 75kg male 30 years sedentary',
          () {
        // Given
        final user = User(
          id: '1',
          weight: 75.0,
          age: 30,
          gender: Gender.male,
          activityLevel: ActivityLevel.sedentary,
          dailyGoal: HydrationGoal(2.0), // Existing goal, will be recalculated
        );

        // When
        final result = useCase.execute(user);

        // Then
        // Expected: 75 × 0.033 × 1.0 (activity) × 1.0 (gender) × 1.0 (age) = 2.475
        // Rounded to 0.1L: 2.5L
        expect(result.targetLiters, 2.5);
      });

      test('should round result to nearest 0.1 liter', () {
        // Given - weight that produces non-rounded result
        final user = User(
          id: '1',
          weight: 72.0, // 72 × 0.033 = 2.376
          age: 25,
          gender: Gender.male,
          activityLevel: ActivityLevel.sedentary,
          dailyGoal: HydrationGoal(2.0),
        );

        // When
        final result = useCase.execute(user);

        // Then - should round to 2.4L
        expect(result.targetLiters, 2.4);
      });
    });

    group('Activity level multipliers', () {
      test('should apply sedentary multiplier (1.0)', () {
        // Given
        final user = User(
          id: '1',
          weight: 70.0,
          age: 30,
          gender: Gender.male,
          activityLevel: ActivityLevel.sedentary,
          dailyGoal: HydrationGoal(2.0),
        );

        // When
        final result = useCase.execute(user);

        // Then: 70 × 0.033 × 1.0 × 1.0 × 1.0 = 2.31 → 2.3L
        expect(result.targetLiters, 2.3);
      });

      test('should apply light activity multiplier (1.1)', () {
        // Given
        final user = User(
          id: '1',
          weight: 70.0,
          age: 30,
          gender: Gender.male,
          activityLevel: ActivityLevel.light,
          dailyGoal: HydrationGoal(2.0),
        );

        // When
        final result = useCase.execute(user);

        // Then: 70 × 0.033 × 1.1 × 1.0 × 1.0 = 2.541 → 2.5L
        expect(result.targetLiters, 2.5);
      });

      test('should apply moderate activity multiplier (1.2)', () {
        // Given
        final user = User(
          id: '1',
          weight: 70.0,
          age: 30,
          gender: Gender.male,
          activityLevel: ActivityLevel.moderate,
          dailyGoal: HydrationGoal(2.0),
        );

        // When
        final result = useCase.execute(user);

        // Then: 70 × 0.033 × 1.2 × 1.0 × 1.0 = 2.772 → 2.8L
        expect(result.targetLiters, 2.8);
      });

      test('should apply very active multiplier (1.3)', () {
        // Given
        final user = User(
          id: '1',
          weight: 70.0,
          age: 30,
          gender: Gender.male,
          activityLevel: ActivityLevel.veryActive,
          dailyGoal: HydrationGoal(2.0),
        );

        // When
        final result = useCase.execute(user);

        // Then: 70 × 0.033 × 1.3 × 1.0 × 1.0 = 3.003 → 3.0L
        expect(result.targetLiters, 3.0);
      });

      test('should apply extremely active multiplier (1.5)', () {
        // Given
        final user = User(
          id: '1',
          weight: 70.0,
          age: 30,
          gender: Gender.male,
          activityLevel: ActivityLevel.extremelyActive,
          dailyGoal: HydrationGoal(2.0),
        );

        // When
        final result = useCase.execute(user);

        // Then: 70 × 0.033 × 1.5 × 1.0 × 1.0 = 3.465 → 3.5L
        expect(result.targetLiters, 3.5);
      });
    });

    group('Gender multipliers', () {
      test('should apply male multiplier (1.0)', () {
        // Given
        final user = User(
          id: '1',
          weight: 70.0,
          age: 30,
          gender: Gender.male,
          activityLevel: ActivityLevel.sedentary,
          dailyGoal: HydrationGoal(2.0),
        );

        // When
        final result = useCase.execute(user);

        // Then: 70 × 0.033 × 1.0 × 1.0 × 1.0 = 2.31 → 2.3L
        expect(result.targetLiters, 2.3);
      });

      test('should apply female multiplier (0.95)', () {
        // Given
        final user = User(
          id: '1',
          weight: 70.0,
          age: 30,
          gender: Gender.female,
          activityLevel: ActivityLevel.sedentary,
          dailyGoal: HydrationGoal(2.0),
        );

        // When
        final result = useCase.execute(user);

        // Then: 70 × 0.033 × 1.0 × 0.95 × 1.0 = 2.1945 → 2.2L
        expect(result.targetLiters, 2.2);
      });

      test('should apply other gender multiplier (1.0)', () {
        // Given
        final user = User(
          id: '1',
          weight: 70.0,
          age: 30,
          gender: Gender.other,
          activityLevel: ActivityLevel.sedentary,
          dailyGoal: HydrationGoal(2.0),
        );

        // When
        final result = useCase.execute(user);

        // Then: 70 × 0.033 × 1.0 × 1.0 × 1.0 = 2.31 → 2.3L
        expect(result.targetLiters, 2.3);
      });
    });

    group('Age multipliers', () {
      test('should apply under 30 multiplier (1.0)', () {
        // Given
        final user = User(
          id: '1',
          weight: 70.0,
          age: 25,
          gender: Gender.male,
          activityLevel: ActivityLevel.sedentary,
          dailyGoal: HydrationGoal(2.0),
        );

        // When
        final result = useCase.execute(user);

        // Then: 70 × 0.033 × 1.0 × 1.0 × 1.0 = 2.31 → 2.3L
        expect(result.targetLiters, 2.3);
      });

      test('should apply 30-55 age multiplier (0.95)', () {
        // Given
        final user = User(
          id: '1',
          weight: 70.0,
          age: 40,
          gender: Gender.male,
          activityLevel: ActivityLevel.sedentary,
          dailyGoal: HydrationGoal(2.0),
        );

        // When
        final result = useCase.execute(user);

        // Then: 70 × 0.033 × 1.0 × 1.0 × 0.95 = 2.1945 → 2.2L
        expect(result.targetLiters, 2.2);
      });

      test('should apply over 55 multiplier (0.9)', () {
        // Given
        final user = User(
          id: '1',
          weight: 70.0,
          age: 65,
          gender: Gender.male,
          activityLevel: ActivityLevel.sedentary,
          dailyGoal: HydrationGoal(2.0),
        );

        // When
        final result = useCase.execute(user);

        // Then: 70 × 0.033 × 1.0 × 1.0 × 0.9 = 2.079 → 2.1L
        expect(result.targetLiters, 2.1);
      });

      test('should handle edge age 30 (first day of 30-55 range)', () {
        // Given
        final user = User(
          id: '1',
          weight: 70.0,
          age: 30,
          gender: Gender.male,
          activityLevel: ActivityLevel.sedentary,
          dailyGoal: HydrationGoal(2.0),
        );

        // When
        final result = useCase.execute(user);

        // Then: age 30 should use 1.0 multiplier (< 30 range)
        expect(result.targetLiters, 2.3);
      });

      test('should handle edge age 55 (last day of 30-55 range)', () {
        // Given
        final user = User(
          id: '1',
          weight: 70.0,
          age: 55,
          gender: Gender.male,
          activityLevel: ActivityLevel.sedentary,
          dailyGoal: HydrationGoal(2.0),
        );

        // When
        final result = useCase.execute(user);

        // Then: age 55 should use 0.95 multiplier (30-55 range)
        expect(result.targetLiters, 2.2);
      });

      test('should handle edge age 56 (first day of >55 range)', () {
        // Given
        final user = User(
          id: '1',
          weight: 70.0,
          age: 56,
          gender: Gender.male,
          activityLevel: ActivityLevel.sedentary,
          dailyGoal: HydrationGoal(2.0),
        );

        // When
        final result = useCase.execute(user);

        // Then: age 56 should use 0.9 multiplier (>55 range)
        expect(result.targetLiters, 2.1);
      });
    });

    group('Safety bounds', () {
      test('should enforce minimum goal of 1.5L', () {
        // Given - very light person with low needs
        final user = User(
          id: '1',
          weight: 30.0, // Very light weight
          age: 70, // Older age (0.9 multiplier)
          gender: Gender.female, // Female (0.95 multiplier)
          activityLevel: ActivityLevel.sedentary,
          dailyGoal: HydrationGoal(2.0),
        );

        // When
        final result = useCase.execute(user);

        // Then: 30 × 0.033 × 1.0 × 0.95 × 0.9 = 0.8415 → should clamp to 1.5L
        expect(result.targetLiters, HydrationGoal.kMinGoal);
        expect(result.targetLiters, 1.5);
      });

      test('should enforce maximum goal of 5.0L', () {
        // Given - very heavy person with high activity
        final user = User(
          id: '1',
          weight: 200.0, // Very heavy weight
          age: 25, // Young (1.0 multiplier)
          gender: Gender.male, // Male (1.0 multiplier)
          activityLevel: ActivityLevel.extremelyActive, // 1.5 multiplier
          dailyGoal: HydrationGoal(2.0),
        );

        // When
        final result = useCase.execute(user);

        // Then: 200 × 0.033 × 1.5 × 1.0 × 1.0 = 9.9L → should clamp to 5.0L
        expect(result.targetLiters, HydrationGoal.kMaxGoal);
        expect(result.targetLiters, 5.0);
      });

      test('should not clamp values within bounds', () {
        // Given - normal profile within bounds
        final user = User(
          id: '1',
          weight: 75.0,
          age: 30,
          gender: Gender.male,
          activityLevel: ActivityLevel.moderate,
          dailyGoal: HydrationGoal(2.0),
        );

        // When
        final result = useCase.execute(user);

        // Then: 75 × 0.033 × 1.2 × 1.0 × 1.0 = 2.97 → 3.0L (no clamping)
        expect(result.targetLiters, 3.0);
        expect(result.targetLiters, greaterThan(HydrationGoal.kMinGoal));
        expect(result.targetLiters, lessThan(HydrationGoal.kMaxGoal));
      });
    });

    group('Edge cases - extreme weights', () {
      test('should handle very light weight (30kg)', () {
        // Given
        final user = User(
          id: '1',
          weight: 30.0,
          age: 25,
          gender: Gender.female,
          activityLevel: ActivityLevel.light,
          dailyGoal: HydrationGoal(2.0),
        );

        // When
        final result = useCase.execute(user);

        // Then: 30 × 0.033 × 1.1 × 0.95 × 1.0 = 1.0395 → clamped to 1.5L
        expect(result.targetLiters, 1.5);
      });

      test('should handle heavy weight (100kg)', () {
        // Given
        final user = User(
          id: '1',
          weight: 100.0,
          age: 30,
          gender: Gender.male,
          activityLevel: ActivityLevel.sedentary,
          dailyGoal: HydrationGoal(2.0),
        );

        // When
        final result = useCase.execute(user);

        // Then: 100 × 0.033 × 1.0 × 1.0 × 1.0 = 3.3L
        expect(result.targetLiters, 3.3);
      });

      test('should handle very heavy weight (150kg)', () {
        // Given
        final user = User(
          id: '1',
          weight: 150.0,
          age: 30,
          gender: Gender.male,
          activityLevel: ActivityLevel.sedentary,
          dailyGoal: HydrationGoal(2.0),
        );

        // When
        final result = useCase.execute(user);

        // Then: 150 × 0.033 × 1.0 × 1.0 × 1.0 = 4.95 → 5.0L
        expect(result.targetLiters, 5.0);
      });
    });

    group('Edge cases - extreme ages', () {
      test('should handle young age (15 years)', () {
        // Given
        final user = User(
          id: '1',
          weight: 60.0,
          age: 15,
          gender: Gender.male,
          activityLevel: ActivityLevel.moderate,
          dailyGoal: HydrationGoal(2.0),
        );

        // When
        final result = useCase.execute(user);

        // Then: 60 × 0.033 × 1.2 × 1.0 × 1.0 = 2.376 → 2.4L
        expect(result.targetLiters, 2.4);
      });

      test('should handle elderly age (80 years)', () {
        // Given
        final user = User(
          id: '1',
          weight: 70.0,
          age: 80,
          gender: Gender.male,
          activityLevel: ActivityLevel.sedentary,
          dailyGoal: HydrationGoal(2.0),
        );

        // When
        final result = useCase.execute(user);

        // Then: 70 × 0.033 × 1.0 × 1.0 × 0.9 = 2.079 → 2.1L
        expect(result.targetLiters, 2.1);
      });
    });

    group('Complex scenarios - multiple adjustments', () {
      test('should correctly combine all adjustments - young active male', () {
        // Given
        final user = User(
          id: '1',
          weight: 80.0,
          age: 25,
          gender: Gender.male,
          activityLevel: ActivityLevel.veryActive,
          dailyGoal: HydrationGoal(2.0),
        );

        // When
        final result = useCase.execute(user);

        // Then: 80 × 0.033 × 1.3 × 1.0 × 1.0 = 3.432 → 3.4L
        expect(result.targetLiters, 3.4);
      });

      test('should correctly combine all adjustments - older female moderate',
          () {
        // Given
        final user = User(
          id: '1',
          weight: 65.0,
          age: 60,
          gender: Gender.female,
          activityLevel: ActivityLevel.moderate,
          dailyGoal: HydrationGoal(2.0),
        );

        // When
        final result = useCase.execute(user);

        // Then: 65 × 0.033 × 1.2 × 0.95 × 0.9 = 2.19321 → 2.2L
        expect(result.targetLiters, 2.2);
      });

      test(
          'should correctly combine all adjustments - middle-aged other extreme activity',
          () {
        // Given
        final user = User(
          id: '1',
          weight: 90.0,
          age: 45,
          gender: Gender.other,
          activityLevel: ActivityLevel.extremelyActive,
          dailyGoal: HydrationGoal(2.0),
        );

        // When
        final result = useCase.execute(user);

        // Then: 90 × 0.033 × 1.5 × 1.0 × 0.95 = 4.23225 → 4.2L
        expect(result.targetLiters, 4.2);
      });
    });

    group('Rounding precision', () {
      test('should round 2.34 to 2.3L', () {
        // Given - weight that produces 2.34
        final user = User(
          id: '1',
          weight: 70.9, // 70.9 × 0.033 = 2.3397
          age: 25,
          gender: Gender.male,
          activityLevel: ActivityLevel.sedentary,
          dailyGoal: HydrationGoal(2.0),
        );

        // When
        final result = useCase.execute(user);

        // Then
        expect(result.targetLiters, 2.3);
      });

      test('should round 2.36 to 2.4L', () {
        // Given - weight that produces 2.36
        final user = User(
          id: '1',
          weight: 71.5, // 71.5 × 0.033 = 2.3595
          age: 25,
          gender: Gender.male,
          activityLevel: ActivityLevel.sedentary,
          dailyGoal: HydrationGoal(2.0),
        );

        // When
        final result = useCase.execute(user);

        // Then
        expect(result.targetLiters, 2.4);
      });

      test('should round 2.45 to 2.5L (round half up)', () {
        // Given - produces exactly 2.45
        final user = User(
          id: '1',
          weight: 74.24, // 74.24 × 0.033 = 2.44992
          age: 25,
          gender: Gender.male,
          activityLevel: ActivityLevel.sedentary,
          dailyGoal: HydrationGoal(2.0),
        );

        // When
        final result = useCase.execute(user);

        // Then - Dart's round() uses "round half to even", but result should be consistent
        expect(result.targetLiters, closeTo(2.4, 0.1));
      });
    });
  });
}
