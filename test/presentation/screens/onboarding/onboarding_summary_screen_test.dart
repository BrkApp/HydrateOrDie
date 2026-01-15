import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:hydrate_or_die/core/di/injection.dart';
import 'package:hydrate_or_die/domain/entities/activity_level.dart';
import 'package:hydrate_or_die/domain/entities/gender.dart';
import 'package:hydrate_or_die/domain/repositories/user_repository.dart';
import 'package:hydrate_or_die/domain/use_cases/user/calculate_hydration_goal_use_case.dart';
import 'package:hydrate_or_die/presentation/providers/onboarding_provider.dart';
import 'package:hydrate_or_die/presentation/providers/onboarding_state.dart';
import 'package:hydrate_or_die/presentation/screens/onboarding/onboarding_summary_screen.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'onboarding_summary_screen_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();

    // Setup GetIt for testing
    if (GetIt.instance.isRegistered<UserRepository>()) {
      GetIt.instance.unregister<UserRepository>();
    }
    if (GetIt.instance.isRegistered<CalculateHydrationGoalUseCase>()) {
      GetIt.instance.unregister<CalculateHydrationGoalUseCase>();
    }

    getIt.registerFactory<UserRepository>(() => mockUserRepository);
    getIt.registerFactory<CalculateHydrationGoalUseCase>(
      () => CalculateHydrationGoalUseCase(),
    );
  });

  tearDown(() {
    GetIt.instance.reset();
  });

  Widget createSummaryScreen({OnboardingState? initialState}) {
    return ProviderScope(
      overrides: [
        if (initialState != null)
          onboardingProvider.overrideWith(
            (ref) => OnboardingNotifier()
              ..state = initialState,
          ),
      ],
      child: const MaterialApp(
        home: OnboardingSummaryScreen(),
      ),
    );
  }

  OnboardingState createValidState({
    double weight = 75.0,
    int age = 30,
    Gender gender = Gender.male,
    ActivityLevel activityLevel = ActivityLevel.sedentary,
    String? location,
  }) {
    return OnboardingState(
      weight: weight,
      age: age,
      gender: gender,
      activityLevel: activityLevel,
      location: location,
      currentStep: 5,
      isComplete: false,
    );
  }

  group('OnboardingSummaryScreen', () {
    testWidgets('should display title "Ton objectif quotidien" (AC #2)',
        (tester) async {
      // Arrange
      final state = createValidState();

      // Act
      await tester.pumpWidget(createSummaryScreen(initialState: state));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Ton objectif quotidien'), findsOneWidget);
    });

    testWidgets('should display calculated hydration goal in liters (AC #2)',
        (tester) async {
      // Arrange - 75kg male, 30 years, sedentary
      // Expected: 75 * 0.033 * 1.0 (activity) * 1.0 (gender) * 1.0 (age) = 2.5L
      final state = createValidState();

      // Act
      await tester.pumpWidget(createSummaryScreen(initialState: state));
      await tester.pumpAndSettle();

      // Assert - Goal displayed with 1 decimal
      expect(find.textContaining('2.5 L'), findsOneWidget);
    });

    testWidgets('should display subtitle "Basé sur ton profil personnel" (AC #2)',
        (tester) async {
      // Arrange
      final state = createValidState();

      // Act
      await tester.pumpWidget(createSummaryScreen(initialState: state));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Basé sur ton profil personnel'), findsOneWidget);
    });

    testWidgets('should display profile recap with all fields (AC #3)',
        (tester) async {
      // Arrange
      final state = createValidState(
        weight: 75.0,
        age: 30,
        gender: Gender.male,
        activityLevel: ActivityLevel.moderate,
        location: 'France',
      );

      // Act
      await tester.pumpWidget(createSummaryScreen(initialState: state));
      await tester.pumpAndSettle();

      // Assert - Recap section exists
      expect(find.text('Récapitulatif:'), findsOneWidget);

      // Assert - Gender displayed in French
      expect(find.textContaining('Homme'), findsOneWidget);

      // Assert - Age displayed
      expect(find.textContaining('30 ans'), findsOneWidget);

      // Assert - Weight displayed
      expect(find.textContaining('75.0 kg'), findsOneWidget);

      // Assert - Activity level displayed in French
      expect(find.textContaining('Activité modérée'), findsOneWidget);

      // Assert - Location displayed (when provided)
      expect(find.textContaining('France'), findsOneWidget);
    });

    testWidgets('should display motivational message with avatar icon (AC #4)',
        (tester) async {
      // Arrange
      final state = createValidState();

      // Act
      await tester.pumpWidget(createSummaryScreen(initialState: state));
      await tester.pumpAndSettle();

      // Assert - Motivational message
      expect(
        find.textContaining('Prêt à commencer ton challenge hydratation'),
        findsOneWidget,
      );

      // Assert - Avatar icon (💧 emoji)
      expect(find.text('💧'), findsOneWidget);
    });

    testWidgets('should display "C\'est parti!" button (AC #5)', (tester) async {
      // Arrange
      final state = createValidState();

      // Act
      await tester.pumpWidget(createSummaryScreen(initialState: state));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('C\'est parti !'), findsOneWidget);
      expect(find.text('🚀'), findsOneWidget);
    });

    testWidgets(
        'should save profile and navigate to home when button is tapped (AC #5, #6)',
        (tester) async {
      // Arrange
      final state = createValidState();
      when(mockUserRepository.saveProfile(any))
          .thenAnswer((_) async => {});

      // Act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            onboardingProvider.overrideWith(
              (ref) => OnboardingNotifier()
                ..state = state,
            ),
          ],
          child: MaterialApp(
            home: const OnboardingSummaryScreen(),
            routes: {
              '/home': (_) => const Scaffold(body: Text('Home Screen')),
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Act - Scroll to button and tap
      await tester.ensureVisible(find.text('C\'est parti !'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('C\'est parti !'));
      await tester.pumpAndSettle();

      // Assert - saveProfile was called
      verify(mockUserRepository.saveProfile(any)).called(1);

      // Assert - Navigation to /home occurred
      expect(find.text('Home Screen'), findsOneWidget);
    });

    testWidgets('should show error SnackBar when save fails', (tester) async {
      // Arrange
      final state = createValidState();
      when(mockUserRepository.saveProfile(any))
          .thenThrow(Exception('Database error'));

      // Act
      await tester.pumpWidget(createSummaryScreen(initialState: state));
      await tester.pumpAndSettle();

      // Act - Scroll to button and tap
      await tester.ensureVisible(find.text('C\'est parti !'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('C\'est parti !'));
      await tester.pump(); // Start the async operation
      await tester.pump(const Duration(milliseconds: 100)); // Let it fail
      await tester.pumpAndSettle(); // Settle after showing SnackBar

      // Assert - Error SnackBar is shown
      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.textContaining('Erreur lors de la sauvegarde du profil'),
        findsOneWidget,
      );
    });

    testWidgets('should redirect to weight screen if state is incomplete',
        (tester) async {
      // Arrange - Incomplete state (missing weight)
      final state = const OnboardingState(
        weight: null,
        age: 30,
        gender: Gender.male,
        activityLevel: ActivityLevel.sedentary,
      );

      // Act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            onboardingProvider.overrideWith(
              (ref) => OnboardingNotifier()
                ..state = state,
            ),
          ],
          child: MaterialApp(
            home: const OnboardingSummaryScreen(),
            routes: {
              '/onboarding_weight': (_) =>
                  const Scaffold(body: Text('Weight Screen')),
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Redirected to weight screen
      expect(find.text('Weight Screen'), findsOneWidget);
    });

    testWidgets('should display correct goal for female user', (tester) async {
      // Arrange - 70kg female, 25 years, light activity
      // Expected: 70 * 0.033 * 1.1 (activity) * 0.95 (gender) * 1.0 (age) = 2.4L
      final state = createValidState(
        weight: 70.0,
        age: 25,
        gender: Gender.female,
        activityLevel: ActivityLevel.light,
      );

      // Act
      await tester.pumpWidget(createSummaryScreen(initialState: state));
      await tester.pumpAndSettle();

      // Assert - Goal calculated correctly for female
      expect(find.textContaining('2.4 L'), findsOneWidget);

      // Assert - Gender displayed as "Femme"
      expect(find.textContaining('Femme'), findsOneWidget);
    });

    testWidgets('should not display location if not provided', (tester) async {
      // Arrange - No location
      final state = createValidState(location: null);

      // Act
      await tester.pumpWidget(createSummaryScreen(initialState: state));
      await tester.pumpAndSettle();

      // Assert - Location field not displayed
      expect(find.textContaining('Localisation'), findsNothing);
    });

    testWidgets('should translate all activity levels correctly', (tester) async {
      // Test each activity level translation
      final activityTests = {
        ActivityLevel.sedentary: 'Sédentaire',
        ActivityLevel.light: 'Activité légère',
        ActivityLevel.moderate: 'Activité modérée',
        ActivityLevel.veryActive: 'Très actif',
        ActivityLevel.extremelyActive: 'Extrêmement actif',
      };

      for (final entry in activityTests.entries) {
        final state = createValidState(activityLevel: entry.key);

        await tester.pumpWidget(createSummaryScreen(initialState: state));
        await tester.pumpAndSettle();

        expect(find.textContaining(entry.value), findsOneWidget);

        // Clean up for next iteration
        await tester.pumpWidget(Container());
      }
    });

    testWidgets('should show loading indicator while saving', (tester) async {
      // Arrange
      final state = createValidState();
      when(mockUserRepository.saveProfile(any))
          .thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 500));
      });

      // Act
      await tester.pumpWidget(createSummaryScreen(initialState: state));
      await tester.pumpAndSettle();

      // Scroll to button and tap
      await tester.ensureVisible(find.text('C\'est parti !'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('C\'est parti !'));
      await tester.pump();

      // Assert - Loading indicator is shown
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for completion
      await tester.pumpAndSettle();
    });
  });
}
