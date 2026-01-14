import 'package:flutter_test/flutter_test.dart';
import 'package:hydrate_or_die/domain/entities/activity_level.dart';
import 'package:hydrate_or_die/domain/entities/gender.dart';
import 'package:hydrate_or_die/presentation/providers/onboarding_state.dart';

void main() {
  group('OnboardingState', () {
    test('should initialize with default values', () {
      // Arrange & Act
      const state = OnboardingState();

      // Assert
      expect(state.weight, isNull);
      expect(state.age, isNull);
      expect(state.gender, isNull);
      expect(state.activityLevel, isNull);
      expect(state.location, isNull);
      expect(state.currentStep, 1);
      expect(state.isComplete, false);
      expect(state.isLoading, false);
      expect(state.errorMessage, isNull);
    });

    test('should create state with all fields populated', () {
      // Arrange & Act
      const state = OnboardingState(
        weight: 70.0,
        age: 25,
        gender: Gender.male,
        activityLevel: ActivityLevel.moderate,
        location: 'France',
        currentStep: 3,
        isComplete: false,
        isLoading: false,
        errorMessage: null,
      );

      // Assert
      expect(state.weight, 70.0);
      expect(state.age, 25);
      expect(state.gender, Gender.male);
      expect(state.activityLevel, ActivityLevel.moderate);
      expect(state.location, 'France');
      expect(state.currentStep, 3);
      expect(state.isComplete, false);
    });

    test('should copy state with updated weight', () {
      // Arrange
      const state = OnboardingState(weight: 70.0);

      // Act
      final updatedState = state.copyWith(weight: 75.0);

      // Assert
      expect(updatedState.weight, 75.0);
      expect(updatedState.currentStep, state.currentStep);
      expect(updatedState.isComplete, state.isComplete);
    });

    test('should copy state with updated age', () {
      // Arrange
      const state = OnboardingState(age: 25);

      // Act
      final updatedState = state.copyWith(age: 30);

      // Assert
      expect(updatedState.age, 30);
    });

    test('should copy state with updated gender', () {
      // Arrange
      const state = OnboardingState(gender: Gender.male);

      // Act
      final updatedState = state.copyWith(gender: Gender.female);

      // Assert
      expect(updatedState.gender, Gender.female);
    });

    test('should copy state with updated activity level', () {
      // Arrange
      const state = OnboardingState(activityLevel: ActivityLevel.sedentary);

      // Act
      final updatedState = state.copyWith(activityLevel: ActivityLevel.veryActive);

      // Assert
      expect(updatedState.activityLevel, ActivityLevel.veryActive);
    });

    test('should copy state with updated location', () {
      // Arrange
      const state = OnboardingState(location: 'France');

      // Act
      final updatedState = state.copyWith(location: 'USA');

      // Assert
      expect(updatedState.location, 'USA');
    });

    test('should copy state with updated currentStep', () {
      // Arrange
      const state = OnboardingState(currentStep: 1);

      // Act
      final updatedState = state.copyWith(currentStep: 2);

      // Assert
      expect(updatedState.currentStep, 2);
    });

    test('should copy state with updated isComplete', () {
      // Arrange
      const state = OnboardingState(isComplete: false);

      // Act
      final updatedState = state.copyWith(isComplete: true);

      // Assert
      expect(updatedState.isComplete, true);
    });

    test('should copy state with error message', () {
      // Arrange
      const state = OnboardingState();

      // Act
      final updatedState = state.copyWith(errorMessage: 'Error occurred');

      // Assert
      expect(updatedState.errorMessage, 'Error occurred');
    });

    group('Validation Getters', () {
      test('isWeightValid should return true for valid weight (50kg)', () {
        // Arrange
        const state = OnboardingState(weight: 50.0);

        // Act & Assert
        expect(state.isWeightValid, true);
      });

      test('isWeightValid should return true for min weight (30kg)', () {
        // Arrange
        const state = OnboardingState(weight: 30.0);

        // Act & Assert
        expect(state.isWeightValid, true);
      });

      test('isWeightValid should return true for max weight (300kg)', () {
        // Arrange
        const state = OnboardingState(weight: 300.0);

        // Act & Assert
        expect(state.isWeightValid, true);
      });

      test('isWeightValid should return false for weight below min (29kg)', () {
        // Arrange
        const state = OnboardingState(weight: 29.0);

        // Act & Assert
        expect(state.isWeightValid, false);
      });

      test('isWeightValid should return false for weight above max (301kg)', () {
        // Arrange
        const state = OnboardingState(weight: 301.0);

        // Act & Assert
        expect(state.isWeightValid, false);
      });

      test('isWeightValid should return false when weight is null', () {
        // Arrange
        const state = OnboardingState();

        // Act & Assert
        expect(state.isWeightValid, false);
      });

      test('isAgeValid should return true for valid age (25)', () {
        // Arrange
        const state = OnboardingState(age: 25);

        // Act & Assert
        expect(state.isAgeValid, true);
      });

      test('isAgeValid should return true for min age (13)', () {
        // Arrange
        const state = OnboardingState(age: 13);

        // Act & Assert
        expect(state.isAgeValid, true);
      });

      test('isAgeValid should return true for max age (100)', () {
        // Arrange
        const state = OnboardingState(age: 100);

        // Act & Assert
        expect(state.isAgeValid, true);
      });

      test('isAgeValid should return false for age below min (12)', () {
        // Arrange
        const state = OnboardingState(age: 12);

        // Act & Assert
        expect(state.isAgeValid, false);
      });

      test('isAgeValid should return false for age above max (101)', () {
        // Arrange
        const state = OnboardingState(age: 101);

        // Act & Assert
        expect(state.isAgeValid, false);
      });

      test('isAgeValid should return false when age is null', () {
        // Arrange
        const state = OnboardingState();

        // Act & Assert
        expect(state.isAgeValid, false);
      });

      test('isGenderValid should return true when gender is set', () {
        // Arrange
        const state = OnboardingState(gender: Gender.male);

        // Act & Assert
        expect(state.isGenderValid, true);
      });

      test('isGenderValid should return false when gender is null', () {
        // Arrange
        const state = OnboardingState();

        // Act & Assert
        expect(state.isGenderValid, false);
      });

      test('isActivityLevelValid should return true when activityLevel is set', () {
        // Arrange
        const state = OnboardingState(activityLevel: ActivityLevel.moderate);

        // Act & Assert
        expect(state.isActivityLevelValid, true);
      });

      test('isActivityLevelValid should return false when activityLevel is null', () {
        // Arrange
        const state = OnboardingState();

        // Act & Assert
        expect(state.isActivityLevelValid, false);
      });

      test('canComplete should return true when all required fields are valid', () {
        // Arrange
        const state = OnboardingState(
          weight: 70.0,
          age: 25,
          gender: Gender.male,
          activityLevel: ActivityLevel.moderate,
        );

        // Act & Assert
        expect(state.canComplete, true);
      });

      test('canComplete should return false when weight is missing', () {
        // Arrange
        const state = OnboardingState(
          age: 25,
          gender: Gender.male,
          activityLevel: ActivityLevel.moderate,
        );

        // Act & Assert
        expect(state.canComplete, false);
      });

      test('canComplete should return false when age is missing', () {
        // Arrange
        const state = OnboardingState(
          weight: 70.0,
          gender: Gender.male,
          activityLevel: ActivityLevel.moderate,
        );

        // Act & Assert
        expect(state.canComplete, false);
      });

      test('canComplete should return false when gender is missing', () {
        // Arrange
        const state = OnboardingState(
          weight: 70.0,
          age: 25,
          activityLevel: ActivityLevel.moderate,
        );

        // Act & Assert
        expect(state.canComplete, false);
      });

      test('canComplete should return false when activityLevel is missing', () {
        // Arrange
        const state = OnboardingState(
          weight: 70.0,
          age: 25,
          gender: Gender.male,
        );

        // Act & Assert
        expect(state.canComplete, false);
      });

      test('canComplete should return true even when location is missing (optional)', () {
        // Arrange
        const state = OnboardingState(
          weight: 70.0,
          age: 25,
          gender: Gender.male,
          activityLevel: ActivityLevel.moderate,
          location: null,
        );

        // Act & Assert
        expect(state.canComplete, true);
      });
    });

    group('Equality', () {
      test('should be equal for same values', () {
        // Arrange
        const state1 = OnboardingState(
          weight: 70.0,
          age: 25,
          gender: Gender.male,
          activityLevel: ActivityLevel.moderate,
          currentStep: 1,
        );

        const state2 = OnboardingState(
          weight: 70.0,
          age: 25,
          gender: Gender.male,
          activityLevel: ActivityLevel.moderate,
          currentStep: 1,
        );

        // Act & Assert
        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });

      test('should not be equal for different weight', () {
        // Arrange
        const state1 = OnboardingState(weight: 70.0);
        const state2 = OnboardingState(weight: 75.0);

        // Act & Assert
        expect(state1, isNot(equals(state2)));
      });

      test('should not be equal for different age', () {
        // Arrange
        const state1 = OnboardingState(age: 25);
        const state2 = OnboardingState(age: 30);

        // Act & Assert
        expect(state1, isNot(equals(state2)));
      });

      test('should not be equal for different gender', () {
        // Arrange
        const state1 = OnboardingState(gender: Gender.male);
        const state2 = OnboardingState(gender: Gender.female);

        // Act & Assert
        expect(state1, isNot(equals(state2)));
      });
    });

    group('toString', () {
      test('should return string representation', () {
        // Arrange
        const state = OnboardingState(
          weight: 70.0,
          age: 25,
          gender: Gender.male,
          activityLevel: ActivityLevel.moderate,
          location: 'France',
          currentStep: 2,
          isComplete: false,
        );

        // Act
        final string = state.toString();

        // Assert
        expect(string, contains('OnboardingState'));
        expect(string, contains('weight: 70.0'));
        expect(string, contains('age: 25'));
        expect(string, contains('gender: Gender.male'));
        expect(string, contains('activityLevel: ActivityLevel.moderate'));
        expect(string, contains('location: France'));
        expect(string, contains('currentStep: 2'));
        expect(string, contains('isComplete: false'));
      });
    });
  });
}
