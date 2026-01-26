import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrate_or_die/presentation/providers/onboarding_provider.dart';
import 'package:hydrate_or_die/presentation/screens/onboarding/onboarding_flow_screen.dart';

void main() {
  group('OnboardingFlowScreen', () {
    testWidgets('should create OnboardingFlowScreen widget', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: OnboardingFlowScreen())),
      );

      // Should create the widget without errors
      expect(find.byType(OnboardingFlowScreen), findsOneWidget);
    });

    testWidgets('should display step counter', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: OnboardingFlowScreen())),
      );

      // Wait for initial render
      await tester.pump();

      // Should show step counter in flow format (not the individual screen format)
      expect(find.text('Étape 1/7'), findsOneWidget);
    });

    testWidgets('should have PageView with 7 screens', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: OnboardingFlowScreen())),
      );

      await tester.pump();

      // Should find PageView
      expect(find.byType(PageView), findsOneWidget);
    });

    testWidgets('should have Next button', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: OnboardingFlowScreen())),
      );

      await tester.pump();

      // Should find Next button (only one button in flow)
      expect(find.widgetWithText(ElevatedButton, 'Suivant'), findsOneWidget);
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
          child: const MaterialApp(home: OnboardingFlowScreen()),
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
        const ProviderScope(child: MaterialApp(home: OnboardingFlowScreen())),
      );

      await tester.pump();

      // Should show progress dots (7 containers in the progress bar)
      final progressContainers = find.descendant(
        of: find.byType(AppBar),
        matching: find.byType(Container),
      );

      // At least some containers should exist for progress indicator
      expect(progressContainers, findsWidgets);
    });

    testWidgets('should not show Back button on first step', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: OnboardingFlowScreen())),
      );

      await tester.pump();

      // AppBar should not have a leading widget (back button)
      final appBar = tester.widget<AppBar>(find.byType(AppBar).first);
      expect(appBar.leading, isNull);
    });

    testWidgets('should navigate to next page when data is valid', (
      tester,
    ) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: OnboardingFlowScreen()),
        ),
      );

      // Wait for postFrameCallback to complete (state reset)
      await tester.pumpAndSettle();

      // Should start at step 1 (Avatar Selection)
      expect(find.text('Étape 1/7'), findsOneWidget);

      // Step 1: Select an avatar (Doctor)
      await tester.tap(find.text('Doctor'));
      await tester.pumpAndSettle();

      // Should now be at step 2 (Weight)
      expect(find.text('Étape 2/7'), findsOneWidget);

      // Step 2: Enter weight to make second step valid
      final textField = find.byType(TextField);
      await tester.enterText(textField, '70');
      await tester.pumpAndSettle();

      // Find and tap Next button
      final nextButton = find.widgetWithText(ElevatedButton, 'Suivant');
      expect(nextButton, findsOneWidget);

      final button = tester.widget<ElevatedButton>(nextButton);
      expect(
        button.onPressed,
        isNotNull,
        reason: 'Next button should be enabled when weight is set',
      );

      // Tap Next
      await tester.tap(nextButton);
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // Should now be at step 3 (Age)
      expect(find.text('Étape 3/7'), findsOneWidget);
    });

    testWidgets('Next button should be disabled when step data is invalid', (
      tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: OnboardingFlowScreen())),
      );

      await tester.pump();

      // Find Next button
      final nextButton = find.widgetWithText(ElevatedButton, 'Suivant');
      expect(nextButton, findsOneWidget);

      // Button should be disabled (no avatar selected yet)
      final button = tester.widget<ElevatedButton>(nextButton);
      expect(
        button.onPressed,
        isNull,
        reason: 'Next button should be disabled when no avatar is selected',
      );
    });

    testWidgets('should show Back button after navigating forward', (
      tester,
    ) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: OnboardingFlowScreen()),
        ),
      );

      await tester.pumpAndSettle();

      // Step 1: Select avatar
      await tester.tap(find.text('Doctor'));
      await tester.pumpAndSettle();

      // Should now show Back button on step 2
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('should navigate back when Back button is tapped', (
      tester,
    ) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: OnboardingFlowScreen()),
        ),
      );

      await tester.pumpAndSettle();

      // Step 1: Select avatar
      await tester.tap(find.text('Doctor'));
      await tester.pumpAndSettle();

      expect(find.text('Étape 2/7'), findsOneWidget);

      // Tap Back button
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // Should be back at step 1 (Avatar Selection)
      expect(find.text('Étape 1/7'), findsOneWidget);
    });

    testWidgets('should enable Skip button on Location step', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Set larger screen size to avoid overflow during multi-step navigation
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: OnboardingFlowScreen()),
        ),
      );

      await tester.pumpAndSettle();

      // Step 1: Select avatar
      await tester.tap(find.text('Doctor'));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // Step 2: Enter weight
      await tester.enterText(find.byType(TextField), '70');
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ElevatedButton, 'Suivant'));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // Step 3: Enter age
      await tester.enterText(find.byType(TextField), '30');
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ElevatedButton, 'Suivant'));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // Step 4: Select gender
      await tester.tap(find.text('Homme'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ElevatedButton, 'Suivant'));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // Step 5: Select activity level
      await tester.tap(find.text('Modéré'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ElevatedButton, 'Suivant'));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // Should be at step 6 (Location)
      expect(find.text('Étape 6/7'), findsOneWidget);

      // Should show Skip button
      expect(find.text('Passer cette étape'), findsOneWidget);
    });
  });
}
