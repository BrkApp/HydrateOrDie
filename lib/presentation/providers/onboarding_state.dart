import 'package:equatable/equatable.dart';
import 'package:hydrate_or_die/domain/entities/activity_level.dart';
import 'package:hydrate_or_die/domain/entities/gender.dart';

/// State model for the Onboarding flow
///
/// Manages all data collected during the multi-step onboarding process.
/// Steps: 1. Weight → 2. Age → 3. Gender → 4. Activity Level → 5. Location (optional)
class OnboardingState extends Equatable {
  /// User weight in kilograms (nullable - not set initially)
  final double? weight;

  /// User age in years (nullable - not set initially)
  final int? age;

  /// User gender (nullable - not set initially)
  final Gender? gender;

  /// User activity level (nullable - not set initially)
  final ActivityLevel? activityLevel;

  /// User location/country (nullable - optional step)
  final String? location;

  /// Current step in onboarding flow (1-5)
  final int currentStep;

  /// Whether onboarding is complete
  final bool isComplete;

  /// Loading state for async operations
  final bool isLoading;

  /// Error message if any validation or operation fails
  final String? errorMessage;

  const OnboardingState({
    this.weight,
    this.age,
    this.gender,
    this.activityLevel,
    this.location,
    this.currentStep = 1,
    this.isComplete = false,
    this.isLoading = false,
    this.errorMessage,
  });

  /// Create a copy with updated fields
  OnboardingState copyWith({
    double? weight,
    int? age,
    Gender? gender,
    ActivityLevel? activityLevel,
    String? location,
    int? currentStep,
    bool? isComplete,
    bool? isLoading,
    String? errorMessage,
  }) {
    return OnboardingState(
      weight: weight ?? this.weight,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      activityLevel: activityLevel ?? this.activityLevel,
      location: location ?? this.location,
      currentStep: currentStep ?? this.currentStep,
      isComplete: isComplete ?? this.isComplete,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /// Check if weight step is complete
  bool get isWeightValid => weight != null && weight! >= 30 && weight! <= 300;

  /// Check if age step is complete
  bool get isAgeValid => age != null && age! >= 10 && age! <= 120;

  /// Check if gender step is complete
  bool get isGenderValid => gender != null;

  /// Check if activity level step is complete
  bool get isActivityLevelValid => activityLevel != null;

  /// Check if all required fields are filled
  bool get canComplete =>
      isWeightValid && isAgeValid && isGenderValid && isActivityLevelValid;

  @override
  List<Object?> get props => [
        weight,
        age,
        gender,
        activityLevel,
        location,
        currentStep,
        isComplete,
        isLoading,
        errorMessage,
      ];

  @override
  String toString() {
    return 'OnboardingState('
        'weight: $weight, '
        'age: $age, '
        'gender: $gender, '
        'activityLevel: $activityLevel, '
        'location: $location, '
        'currentStep: $currentStep, '
        'isComplete: $isComplete, '
        'isLoading: $isLoading, '
        'errorMessage: $errorMessage)';
  }
}
