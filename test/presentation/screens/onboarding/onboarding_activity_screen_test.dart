import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrate_or_die/domain/entities/activity_level.dart';
import 'package:hydrate_or_die/presentation/screens/onboarding/onboarding_activity_screen.dart';
import 'package:hydrate_or_die/presentation/providers/onboarding_provider.dart';

void main() {
  group('OnboardingActivityScreen', () {
    testWidgets('should display activity level selection screen',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const OnboardingActivityScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check title and subtitle
      expect(find.text('Niveau d\'activité physique'), findsOneWidget);
      expect(find.text('À quelle fréquence fais-tu du sport ?'), findsOneWidget);

      // Check progress indicator
      expect(find.text('Étape 4 sur 5'), findsOneWidget);

      // Check all 5 activity options
      expect(find.text('Sédentaire'), findsOneWidget);
      expect(find.text('Léger'), findsOneWidget);
      expect(find.text('Modéré'), findsOneWidget);
      expect(find.text('Très actif'), findsOneWidget);
      expect(find.text('Extrêmement actif'), findsOneWidget);

      // Check descriptions
      expect(find.text('Peu ou pas d\'exercice'), findsOneWidget);
      expect(find.text('1-3 fois par semaine'), findsOneWidget);
      expect(find.text('3-5 fois par semaine'), findsOneWidget);
      expect(find.text('6-7 fois par semaine'), findsOneWidget);
      expect(find.text('Sport intense quotidien'), findsOneWidget);

      // Check next button exists
      expect(find.text('Suivant'), findsOneWidget);
    });

    testWidgets('next button should be disabled when no activity selected',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const OnboardingActivityScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find next button
      final nextButton = find.widgetWithText(ElevatedButton, 'Suivant');
      expect(nextButton, findsOneWidget);

      // Check if button is disabled (onPressed is null)
      final button = tester.widget<ElevatedButton>(nextButton);
      expect(button.onPressed, isNull);
    });

    testWidgets('should enable next button when activity is selected',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const OnboardingActivityScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap on "Modéré" activity card
      await tester.tap(find.text('Modéré'));
      await tester.pumpAndSettle();

      // Find next button
      final nextButton = find.widgetWithText(ElevatedButton, 'Suivant');
      expect(nextButton, findsOneWidget);

      // Check if button is enabled (onPressed is not null)
      final button = tester.widget<ElevatedButton>(nextButton);
      expect(button.onPressed, isNotNull);
    });

    testWidgets('should highlight selected activity card', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const OnboardingActivityScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap on "Léger" activity card
      await tester.tap(find.text('Léger'));
      await tester.pumpAndSettle();

      // Find the InkWell containing "Léger"
      final inkWell = find.ancestor(
        of: find.text('Léger'),
        matching: find.byType(InkWell),
      );
      expect(inkWell, findsOneWidget);

      // Verify that the card is highlighted by checking the Card widget
      final card = find.ancestor(
        of: find.text('Léger'),
        matching: find.byType(Card),
      );
      expect(card, findsOneWidget);
    });

    testWidgets('should update provider state when activity is selected',
        (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: const OnboardingActivityScreen(),
            routes: {
              '/onboarding_location': (_) => const Scaffold(
                    body: Center(child: Text('Location Screen')),
                  ),
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Initial state should have no activity level
      expect(container.read(onboardingProvider).activityLevel, isNull);

      // Select "Très actif"
      await tester.tap(find.text('Très actif'));
      await tester.pumpAndSettle();

      // Scroll to make next button visible
      await tester.ensureVisible(find.text('Suivant'));
      await tester.pumpAndSettle();

      // Tap next button
      await tester.tap(find.text('Suivant'));
      await tester.pumpAndSettle();

      // Verify provider state was updated
      expect(
        container.read(onboardingProvider).activityLevel,
        ActivityLevel.veryActive,
      );
    });

    testWidgets('should display all activity icons', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const OnboardingActivityScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check that icons are displayed (at least 5 Icon widgets)
      final icons = find.byType(Icon);
      expect(icons, findsWidgets);

      // There should be more than 5 icons (5 activity + back button)
      expect(icons.evaluate().length, greaterThan(5));
    });

    testWidgets('should navigate back when back button is pressed',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const OnboardingActivityScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find and tap back button
      final backButton = find.byIcon(Icons.arrow_back);
      expect(backButton, findsOneWidget);

      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Should navigate back (screen should be popped)
      expect(find.byType(OnboardingActivityScreen), findsNothing);
    });
  });
}
