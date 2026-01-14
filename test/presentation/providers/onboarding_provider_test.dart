import 'package:flutter_test/flutter_test.dart';
import 'package:hydrate_or_die/domain/entities/activity_level.dart';
import 'package:hydrate_or_die/domain/entities/gender.dart';
import 'package:hydrate_or_die/presentation/providers/onboarding_provider.dart';
import 'package:hydrate_or_die/presentation/providers/onboarding_state.dart';

void main() {
  group('OnboardingNotifier', () {
    late OnboardingNotifier notifier;

    setUp(() {
      notifier = OnboardingNotifier();
    });

    test('should initialize with default state', () {
      // Assert
      expect(notifier.state, const OnboardingState());
      expect(notifier.state.currentStep, 1);
      expect(notifier.state.isComplete, false);
    });

    group('updateWeight', () {
      test('should update weight with valid value (50kg)', () {
        // Act
        notifier.updateWeight(50.0);

        // Assert
        expect(notifier.state.weight, 50.0);
        expect(notifier.state.errorMessage, isNull);
      });

      test('should update weight with min valid value (30kg)', () {
        // Act
        notifier.updateWeight(30.0);

        // Assert
        expect(notifier.state.weight, 30.0);
        expect(notifier.state.errorMessage, isNull);
      });

      test('should update weight with max valid value (300kg)', () {
        // Act
        notifier.updateWeight(300.0);

        // Assert
        expect(notifier.state.weight, 300.0);
        expect(notifier.state.errorMessage, isNull);
      });

      test('should set error when weight is below min (29kg)', () {
        // Act
        notifier.updateWeight(29.0);

        // Assert
        expect(notifier.state.weight, isNull);
        expect(notifier.state.errorMessage, 'Le poids doit être entre 30 et 300 kg');
      });

      test('should set error when weight is above max (301kg)', () {
        // Act
        notifier.updateWeight(301.0);

        // Assert
        expect(notifier.state.weight, isNull);
        expect(notifier.state.errorMessage, 'Le poids doit être entre 30 et 300 kg');
      });
    });

    group('updateAge', () {
      test('should update age with valid value (25)', () {
        // Act
        notifier.updateAge(25);

        // Assert
        expect(notifier.state.age, 25);
        expect(notifier.state.errorMessage, isNull);
      });

      test('should update age with min valid value (13)', () {
        // Act
        notifier.updateAge(13);

        // Assert
        expect(notifier.state.age, 13);
        expect(notifier.state.errorMessage, isNull);
      });

      test('should update age with max valid value (100)', () {
        // Act
        notifier.updateAge(100);

        // Assert
        expect(notifier.state.age, 100);
        expect(notifier.state.errorMessage, isNull);
      });

      test('should set error when age is below min (12)', () {
        // Act
        notifier.updateAge(12);

        // Assert
        expect(notifier.state.age, isNull);
        expect(notifier.state.errorMessage, 'L\'âge doit être entre 13 et 100 ans');
      });

      test('should set error when age is above max (101)', () {
        // Act
        notifier.updateAge(101);

        // Assert
        expect(notifier.state.age, isNull);
        expect(notifier.state.errorMessage, 'L\'âge doit être entre 13 et 100 ans');
      });
    });

    group('updateGender', () {
      test('should update gender to male', () {
        // Act
        notifier.updateGender(Gender.male);

        // Assert
        expect(notifier.state.gender, Gender.male);
        expect(notifier.state.errorMessage, isNull);
      });

      test('should update gender to female', () {
        // Act
        notifier.updateGender(Gender.female);

        // Assert
        expect(notifier.state.gender, Gender.female);
        expect(notifier.state.errorMessage, isNull);
      });

      test('should update gender to other', () {
        // Act
        notifier.updateGender(Gender.other);

        // Assert
        expect(notifier.state.gender, Gender.other);
        expect(notifier.state.errorMessage, isNull);
      });
    });

    group('updateActivityLevel', () {
      test('should update activity level to sedentary', () {
        // Act
        notifier.updateActivityLevel(ActivityLevel.sedentary);

        // Assert
        expect(notifier.state.activityLevel, ActivityLevel.sedentary);
        expect(notifier.state.errorMessage, isNull);
      });

      test('should update activity level to light', () {
        // Act
        notifier.updateActivityLevel(ActivityLevel.light);

        // Assert
        expect(notifier.state.activityLevel, ActivityLevel.light);
        expect(notifier.state.errorMessage, isNull);
      });

      test('should update activity level to moderate', () {
        // Act
        notifier.updateActivityLevel(ActivityLevel.moderate);

        // Assert
        expect(notifier.state.activityLevel, ActivityLevel.moderate);
        expect(notifier.state.errorMessage, isNull);
      });

      test('should update activity level to veryActive', () {
        // Act
        notifier.updateActivityLevel(ActivityLevel.veryActive);

        // Assert
        expect(notifier.state.activityLevel, ActivityLevel.veryActive);
        expect(notifier.state.errorMessage, isNull);
      });

      test('should update activity level to extremelyActive', () {
        // Act
        notifier.updateActivityLevel(ActivityLevel.extremelyActive);

        // Assert
        expect(notifier.state.activityLevel, ActivityLevel.extremelyActive);
        expect(notifier.state.errorMessage, isNull);
      });
    });

    group('updateLocation', () {
      test('should update location', () {
        // Act
        notifier.updateLocation('France');

        // Assert
        expect(notifier.state.location, 'France');
        expect(notifier.state.errorMessage, isNull);
      });

      test('should allow null location (optional field)', () {
        // Arrange
        notifier.updateLocation('France');

        // Act
        notifier.updateLocation(null);

        // Assert
        expect(notifier.state.location, isNull);
        expect(notifier.state.errorMessage, isNull);
      });
    });

    group('Step Navigation', () {
      test('nextStep should increment currentStep', () {
        // Arrange
        expect(notifier.state.currentStep, 1);

        // Act
        notifier.nextStep();

        // Assert
        expect(notifier.state.currentStep, 2);
      });

      test('nextStep should not exceed step 5', () {
        // Arrange
        notifier.nextStep(); // 2
        notifier.nextStep(); // 3
        notifier.nextStep(); // 4
        notifier.nextStep(); // 5

        // Act
        notifier.nextStep(); // Should stay at 5

        // Assert
        expect(notifier.state.currentStep, 5);
      });

      test('previousStep should decrement currentStep', () {
        // Arrange
        notifier.nextStep(); // Move to step 2

        // Act
        notifier.previousStep();

        // Assert
        expect(notifier.state.currentStep, 1);
      });

      test('previousStep should not go below step 1', () {
        // Arrange
        expect(notifier.state.currentStep, 1);

        // Act
        notifier.previousStep();

        // Assert
        expect(notifier.state.currentStep, 1);
      });

      test('skipStep should call nextStep for step 5 (location)', () {
        // Arrange
        notifier.nextStep(); // 2
        notifier.nextStep(); // 3
        notifier.nextStep(); // 4
        notifier.nextStep(); // 5

        // Act
        notifier.skipStep();

        // Assert
        expect(notifier.state.currentStep, 5); // Stays at 5 as max
      });
    });

    group('complete', () {
      test('should complete onboarding when all required fields are filled', () {
        // Arrange
        notifier.updateWeight(70.0);
        notifier.updateAge(25);
        notifier.updateGender(Gender.male);
        notifier.updateActivityLevel(ActivityLevel.moderate);

        // Act
        final result = notifier.complete();

        // Assert
        expect(result, true);
        expect(notifier.state.isComplete, true);
        expect(notifier.state.errorMessage, isNull);
      });

      test('should not complete when weight is missing', () {
        // Arrange
        notifier.updateAge(25);
        notifier.updateGender(Gender.male);
        notifier.updateActivityLevel(ActivityLevel.moderate);

        // Act
        final result = notifier.complete();

        // Assert
        expect(result, false);
        expect(notifier.state.isComplete, false);
        expect(notifier.state.errorMessage, 'Veuillez remplir tous les champs requis');
      });

      test('should not complete when age is missing', () {
        // Arrange
        notifier.updateWeight(70.0);
        notifier.updateGender(Gender.male);
        notifier.updateActivityLevel(ActivityLevel.moderate);

        // Act
        final result = notifier.complete();

        // Assert
        expect(result, false);
        expect(notifier.state.isComplete, false);
        expect(notifier.state.errorMessage, 'Veuillez remplir tous les champs requis');
      });

      test('should not complete when gender is missing', () {
        // Arrange
        notifier.updateWeight(70.0);
        notifier.updateAge(25);
        notifier.updateActivityLevel(ActivityLevel.moderate);

        // Act
        final result = notifier.complete();

        // Assert
        expect(result, false);
        expect(notifier.state.isComplete, false);
        expect(notifier.state.errorMessage, 'Veuillez remplir tous les champs requis');
      });

      test('should not complete when activity level is missing', () {
        // Arrange
        notifier.updateWeight(70.0);
        notifier.updateAge(25);
        notifier.updateGender(Gender.male);

        // Act
        final result = notifier.complete();

        // Assert
        expect(result, false);
        expect(notifier.state.isComplete, false);
        expect(notifier.state.errorMessage, 'Veuillez remplir tous les champs requis');
      });

      test('should complete even when location is missing (optional)', () {
        // Arrange
        notifier.updateWeight(70.0);
        notifier.updateAge(25);
        notifier.updateGender(Gender.male);
        notifier.updateActivityLevel(ActivityLevel.moderate);
        // Location is not set

        // Act
        final result = notifier.complete();

        // Assert
        expect(result, true);
        expect(notifier.state.isComplete, true);
      });
    });

    group('reset', () {
      test('should reset state to initial values', () {
        // Arrange
        notifier.updateWeight(70.0);
        notifier.updateAge(25);
        notifier.updateGender(Gender.male);
        notifier.updateActivityLevel(ActivityLevel.moderate);
        notifier.updateLocation('France');
        notifier.nextStep();

        // Act
        notifier.reset();

        // Assert
        expect(notifier.state, const OnboardingState());
        expect(notifier.state.weight, isNull);
        expect(notifier.state.age, isNull);
        expect(notifier.state.gender, isNull);
        expect(notifier.state.activityLevel, isNull);
        expect(notifier.state.location, isNull);
        expect(notifier.state.currentStep, 1);
        expect(notifier.state.isComplete, false);
      });
    });

    group('clearError', () {
      test('should clear error message', () {
        // Arrange
        notifier.updateWeight(29.0); // Invalid weight, sets error
        expect(notifier.state.errorMessage, isNotNull);

        // Act
        notifier.clearError();

        // Assert
        expect(notifier.state.errorMessage, isNull);
      });
    });

    group('Multi-step Flow', () {
      test('should handle complete onboarding flow', () {
        // Step 1: Weight
        expect(notifier.state.currentStep, 1);
        notifier.updateWeight(70.0);
        expect(notifier.state.weight, 70.0);
        notifier.nextStep();

        // Step 2: Age
        expect(notifier.state.currentStep, 2);
        notifier.updateAge(25);
        expect(notifier.state.age, 25);
        notifier.nextStep();

        // Step 3: Gender
        expect(notifier.state.currentStep, 3);
        notifier.updateGender(Gender.male);
        expect(notifier.state.gender, Gender.male);
        notifier.nextStep();

        // Step 4: Activity Level
        expect(notifier.state.currentStep, 4);
        notifier.updateActivityLevel(ActivityLevel.moderate);
        expect(notifier.state.activityLevel, ActivityLevel.moderate);
        notifier.nextStep();

        // Step 5: Location (optional)
        expect(notifier.state.currentStep, 5);
        notifier.updateLocation('France');
        expect(notifier.state.location, 'France');

        // Complete
        final result = notifier.complete();
        expect(result, true);
        expect(notifier.state.isComplete, true);
        expect(notifier.state.canComplete, true);
      });

      test('should allow going back and changing values', () {
        // Arrange
        notifier.updateWeight(70.0);
        notifier.nextStep();
        notifier.updateAge(25);
        notifier.nextStep();

        // Act - Go back to weight step
        notifier.previousStep();
        notifier.previousStep();
        expect(notifier.state.currentStep, 1);

        // Change weight
        notifier.updateWeight(75.0);

        // Assert
        expect(notifier.state.weight, 75.0);
        expect(notifier.state.age, 25); // Age should still be set
      });
    });
  });
}
