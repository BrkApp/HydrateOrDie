import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydrate_or_die/domain/entities/activity_level.dart';
import 'package:hydrate_or_die/domain/entities/gender.dart';
import 'package:hydrate_or_die/presentation/providers/onboarding_state.dart';

/// Provider for Onboarding flow state management
///
/// Manages the multi-step onboarding process where users input:
/// - Step 1: Weight (30-300kg)
/// - Step 2: Age (13-100 years)
/// - Step 3: Gender (male/female/other)
/// - Step 4: Activity Level (sedentary/light/moderate/veryActive/extremelyActive)
/// - Step 5: Location (optional)
///
/// State persists across steps and is saved at the end of the flow.
class OnboardingNotifier extends StateNotifier<OnboardingState> {
  OnboardingNotifier() : super(const OnboardingState());

  /// Update weight (Step 1)
  ///
  /// [weightInKg] must be between 30 and 300 kg
  void updateWeight(double weightInKg) {
    if (weightInKg < 30 || weightInKg > 300) {
      state = state.copyWith(
        errorMessage: 'Le poids doit être entre 30 et 300 kg',
      );
      return;
    }

    state = state.copyWith(
      weight: weightInKg,
      errorMessage: null,
    );
  }

  /// Update age (Step 2)
  ///
  /// [age] must be between 10 and 120 years
  void updateAge(int age) {
    if (age < 10 || age > 120) {
      state = state.copyWith(
        errorMessage: 'L\'âge doit être entre 10 et 120 ans',
      );
      return;
    }

    state = state.copyWith(
      age: age,
      errorMessage: null,
    );
  }

  /// Update gender (Step 3)
  void updateGender(Gender gender) {
    state = state.copyWith(
      gender: gender,
      errorMessage: null,
    );
  }

  /// Update activity level (Step 4)
  void updateActivityLevel(ActivityLevel activityLevel) {
    state = state.copyWith(
      activityLevel: activityLevel,
      errorMessage: null,
    );
  }

  /// Update location (Step 5 - optional)
  void updateLocation(String? location) {
    state = OnboardingState(
      weight: state.weight,
      age: state.age,
      gender: state.gender,
      activityLevel: state.activityLevel,
      location: location,
      currentStep: state.currentStep,
      isComplete: state.isComplete,
      isLoading: state.isLoading,
      errorMessage: null,
    );
  }

  /// Move to next step
  void nextStep() {
    if (state.currentStep < 5) {
      state = state.copyWith(
        currentStep: state.currentStep + 1,
      );
    }
  }

  /// Move to previous step
  void previousStep() {
    if (state.currentStep > 1) {
      state = state.copyWith(
        currentStep: state.currentStep - 1,
      );
    }
  }

  /// Skip current step (only for optional steps like location)
  void skipStep() {
    if (state.currentStep == 5) {
      // Location is optional, can be skipped
      nextStep();
    }
  }

  /// Complete onboarding
  ///
  /// Validates that all required fields are filled before marking as complete.
  /// Returns true if onboarding can be completed, false otherwise.
  bool complete() {
    if (!state.canComplete) {
      state = state.copyWith(
        errorMessage: 'Veuillez remplir tous les champs requis',
      );
      return false;
    }

    state = state.copyWith(
      isComplete: true,
      errorMessage: null,
    );

    return true;
  }

  /// Reset onboarding to initial state
  void reset() {
    state = const OnboardingState();
  }

  /// Clear error message
  void clearError() {
    state = OnboardingState(
      weight: state.weight,
      age: state.age,
      gender: state.gender,
      activityLevel: state.activityLevel,
      location: state.location,
      currentStep: state.currentStep,
      isComplete: state.isComplete,
      isLoading: state.isLoading,
      errorMessage: null,
    );
  }
}

/// Riverpod provider for OnboardingNotifier
final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  return OnboardingNotifier();
});
