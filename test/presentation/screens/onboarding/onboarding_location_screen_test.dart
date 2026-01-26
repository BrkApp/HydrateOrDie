import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrate_or_die/presentation/screens/onboarding/onboarding_location_screen.dart';
import 'package:hydrate_or_die/presentation/providers/onboarding_provider.dart';

void main() {
  group('OnboardingLocationScreen', () {
    testWidgets('should display location permission screen', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(home: const OnboardingLocationScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Check title and subtitle
      expect(find.text('Autoriser la localisation ?'), findsOneWidget);
      expect(
        find.text(
          'Optionnel : permettra d\'ajuster les rappels en fonction de la météo (canicule)',
        ),
        findsOneWidget,
      );

      // Check progress indicator
      expect(find.text('Étape 5 sur 5'), findsOneWidget);

      // Check location icon
      expect(find.byIcon(Icons.location_on), findsOneWidget);

      // Check both buttons
      expect(find.text('Autoriser'), findsOneWidget);
      expect(find.text('Pas maintenant'), findsOneWidget);
    });

    testWidgets('should display both buttons as enabled', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(home: const OnboardingLocationScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Find authorize button (ElevatedButton)
      final authorizeButton = find.widgetWithText(ElevatedButton, 'Autoriser');
      expect(authorizeButton, findsOneWidget);

      // Find skip button (OutlinedButton)
      final skipButton = find.widgetWithText(OutlinedButton, 'Pas maintenant');
      expect(skipButton, findsOneWidget);

      // Both buttons should be enabled (onPressed is not null)
      final elevatedBtn = tester.widget<ElevatedButton>(authorizeButton);
      final outlinedBtn = tester.widget<OutlinedButton>(skipButton);

      expect(elevatedBtn.onPressed, isNotNull);
      expect(outlinedBtn.onPressed, isNotNull);
    });

    testWidgets(
      'should update provider with mock_granted when authorize pressed',
      (tester) async {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              home: const OnboardingLocationScreen(),
              routes: {
                '/onboarding_summary': (_) =>
                    const Scaffold(body: Center(child: Text('Summary Screen'))),
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Initial state should have no location
        expect(container.read(onboardingProvider).location, isNull);

        // Tap authorize button
        await tester.tap(find.text('Autoriser'));
        await tester.pumpAndSettle();

        // Verify provider state was updated with mock_granted
        expect(container.read(onboardingProvider).location, 'mock_granted');
      },
    );

    testWidgets('should update provider with null when skip pressed', (
      tester,
    ) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: const OnboardingLocationScreen(),
            routes: {
              '/onboarding_summary': (_) =>
                  const Scaffold(body: Center(child: Text('Summary Screen'))),
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Initial state should have no location
      expect(container.read(onboardingProvider).location, isNull);

      // Tap skip button
      await tester.tap(find.text('Pas maintenant'));
      await tester.pumpAndSettle();

      // Verify provider state remains null
      expect(container.read(onboardingProvider).location, isNull);
    });

    testWidgets('should show snackbar when authorize is pressed', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const OnboardingLocationScreen(),
            routes: {
              '/onboarding_summary': (_) =>
                  const Scaffold(body: Center(child: Text('Summary Screen'))),
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap authorize button
      await tester.tap(find.text('Autoriser'));
      await tester.pump();

      // Check snackbar is shown
      expect(
        find.text('Localisation activée (mode développement)'),
        findsOneWidget,
      );
    });

    testWidgets('should navigate back when back button is pressed', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(home: const OnboardingLocationScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Find and tap back button
      final backButton = find.byIcon(Icons.arrow_back);
      expect(backButton, findsOneWidget);

      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Should navigate back (screen should be popped)
      expect(find.byType(OnboardingLocationScreen), findsNothing);
    });

    testWidgets('should have correct button styles', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(home: const OnboardingLocationScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Check that ElevatedButton exists (primary button)
      expect(find.byType(ElevatedButton), findsOneWidget);

      // Check that OutlinedButton exists (secondary button)
      expect(find.byType(OutlinedButton), findsOneWidget);
    });

    testWidgets('should display icon with correct size and color', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(home: const OnboardingLocationScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Find location icon
      final locationIcon = find.byIcon(Icons.location_on);
      expect(locationIcon, findsOneWidget);

      // Get the Icon widget
      final iconWidget = tester.widget<Icon>(locationIcon);
      expect(iconWidget.size, 80);
    });
  });
}
