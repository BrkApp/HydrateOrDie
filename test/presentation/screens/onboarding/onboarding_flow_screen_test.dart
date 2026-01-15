import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrate_or_die/presentation/providers/onboarding_provider.dart';
import 'package:hydrate_or_die/presentation/screens/onboarding/onboarding_flow_screen.dart';
import 'package:hydrate_or_die/domain/entities/gender.dart';
import 'package:hydrate_or_die/domain/entities/activity_level.dart';

void main() {
  group('OnboardingFlowScreen', () {
    testWidgets('should create OnboardingFlowScreen widget', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: OnboardingFlowScreen(),
          ),
        ),
      );

      // Should create the widget without errors
      expect(find.byType(OnboardingFlowScreen), findsOneWidget);
    });

    testWidgets('should display step counter', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: OnboardingFlowScreen(),
          ),
        ),
      );

      // Wait for initial render
      await tester.pump();

      // Should show step counter
      expect(find.textContaining('Étape'), findsOneWidget);
      expect(find.textContaining('/6'), findsOneWidget);
    });

    testWidgets('should have PageView with 6 screens', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: OnboardingFlowScreen(),
          ),
        ),
      );

      await tester.pump();

      // Should find PageView
      expect(find.byType(PageView), findsOneWidget);
    });

    testWidgets('should have Next button', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: OnboardingFlowScreen(),
          ),
        ),
      );

      await tester.pump();

      // Should find Next button
      expect(find.widgetWithText(ElevatedButton, 'Suivant'), findsWidgets);
    });

    testWidgets('should reset onboarding state on init', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Pre-fill some data
      container.read(onboardingProvider.notifier).updateWeight(70.0);
      container.read(onboardingProvider.notifier).updateAge(30);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: OnboardingFlowScreen(),
          ),
        ),
      );

      // Pump one more frame for postFrameCallback
      await tester.pump();

      // State should be reset after first frame
      final state = container.read(onboardingProvider);
      expect(state.weight, isNull);
      expect(state.age, isNull);
    });

    testWidgets('should show progress indicator', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: OnboardingFlowScreen(),
          ),
        ),
      );

      await tester.pump();

      // Should show progress dots (6 containers in the progress bar)
      final progressContainers = find.descendant(
        of: find.byType(AppBar),
        matching: find.byType(Container),
      );

      // At least some containers should exist for progress indicator
      expect(progressContainers, findsWidgets);
    });

    testWidgets('should not show Back button on first step', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: OnboardingFlowScreen(),
          ),
        ),
      );

      await tester.pump();

      // AppBar should not have a leading widget (back button)
      final appBar = tester.widget<AppBar>(find.byType(AppBar).first);
      expect(appBar.leading, isNull);
    });

    testWidgets('should navigate to next page when data is valid', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Pre-fill weight to make first step valid
      container.read(onboardingProvider.notifier).updateWeight(70.0);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: OnboardingFlowScreen(),
          ),
        ),
      );

      await tester.pump();

      // Should start at step 1
      expect(find.text('Étape 1/6'), findsOneWidget);

      // Find and tap Next button
      final nextButton = find.widgetWithText(ElevatedButton, 'Suivant');
      expect(nextButton, findsOneWidget);

      final button = tester.widget<ElevatedButton>(nextButton);
      expect(button.onPressed, isNotNull, reason: 'Next button should be enabled when weight is set');

      // Tap Next
      await tester.tap(nextButton);
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // Should now be at step 2
      expect(find.text('Étape 2/6'), findsOneWidget);
    });

    testWidgets('Next button should be disabled when step data is invalid', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: OnboardingFlowScreen(),
          ),
        ),
      );

      await tester.pump();

      // Find Next button
      final nextButton = find.widgetWithText(ElevatedButton, 'Suivant');
      expect(nextButton, findsOneWidget);

      // Button should be disabled (no weight entered yet)
      final button = tester.widget<ElevatedButton>(nextButton);
      expect(button.onPressed, isNull, reason: 'Next button should be disabled when no weight is entered');
    });

    testWidgets('should show Back button after navigating forward', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Pre-fill weight
      container.read(onboardingProvider.notifier).updateWeight(70.0);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: OnboardingFlowScreen(),
          ),
        ),
      );

      await tester.pump();

      // Navigate to step 2
      await tester.tap(find.widgetWithText(ElevatedButton, 'Suivant'));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // Should now show Back button
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('should navigate back when Back button is tapped', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Pre-fill weight and age
      container.read(onboardingProvider.notifier).updateWeight(70.0);
      container.read(onboardingProvider.notifier).updateAge(30);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: OnboardingFlowScreen(),
          ),
        ),
      );

      await tester.pump();

      // Navigate to step 2
      await tester.tap(find.widgetWithText(ElevatedButton, 'Suivant'));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      expect(find.text('Étape 2/6'), findsOneWidget);

      // Tap Back button
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // Should be back at step 1
      expect(find.text('Étape 1/6'), findsOneWidget);
    });

    testWidgets('should enable Skip button on Location step', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Pre-fill all required fields up to step 4
      container.read(onboardingProvider.notifier).updateWeight(70.0);
      container.read(onboardingProvider.notifier).updateAge(30);
      container.read(onboardingProvider.notifier).updateGender(Gender.male);
      container.read(onboardingProvider.notifier).updateActivityLevel(ActivityLevel.moderate);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: OnboardingFlowScreen(),
          ),
        ),
      );

      await tester.pump();

      // Navigate through 4 steps to reach Location (step 5)
      for (int i = 0; i < 4; i++) {
        await tester.tap(find.widgetWithText(ElevatedButton, 'Suivant'));
        await tester.pumpAndSettle(const Duration(milliseconds: 500));
      }

      // Should be at step 5 (Location)
      expect(find.text('Étape 5/6'), findsOneWidget);

      // Should show Skip button
      expect(find.text('Passer cette étape'), findsOneWidget);
    });
  });
}
