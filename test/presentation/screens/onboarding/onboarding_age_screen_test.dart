import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrate_or_die/presentation/providers/onboarding_provider.dart';
import 'package:hydrate_or_die/presentation/providers/onboarding_state.dart';
import 'package:hydrate_or_die/presentation/screens/onboarding/onboarding_age_screen.dart';

void main() {
  group('OnboardingAgeScreen', () {
    Widget createAgeScreen() {
      return ProviderScope(
        child: MaterialApp(
          home: const OnboardingAgeScreen(),
          routes: {
            '/onboarding_gender': (_) => const Scaffold(
                  body: Center(child: Text('Gender Screen')),
                ),
          },
        ),
      );
    }

    testWidgets('should display all UI components (AC #2, #7)', (tester) async {
      // Act
      await tester.pumpWidget(createAgeScreen());
      await tester.pumpAndSettle();

      // Assert - Progress indicator
      expect(find.text('Étape 2 sur 5'), findsOneWidget); // AC #7

      // Assert - Title and subtitle
      expect(find.text('Quel âge as-tu ?'), findsOneWidget); // AC #2
      expect(
        find.text('Ton besoin en eau varie selon l\'âge'),
        findsOneWidget,
      ); // AC #2

      // Assert - TextField
      expect(find.byType(TextField), findsOneWidget); // AC #3

      // Assert - Next button
      expect(find.text('Suivant'), findsOneWidget);

      // Assert - Back button
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('should use numeric keyboard (AC #3)', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createAgeScreen());
      await tester.pumpAndSettle();

      // Assert - TextField should have numeric keyboard type (integers only)
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.keyboardType, TextInputType.number); // AC #3
    });

    testWidgets('should show "ans" suffix in TextField', (tester) async {
      // Act
      await tester.pumpWidget(createAgeScreen());
      await tester.pumpAndSettle();

      // Assert - TextField should show "ans" suffix
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.decoration?.suffixText, 'ans');
    });

    testWidgets('should accept valid age (AC #4)', (tester) async {
      // Arrange
      await tester.pumpWidget(createAgeScreen());
      await tester.pumpAndSettle();

      // Act - Enter valid age
      await tester.enterText(find.byType(TextField), '25');
      await tester.pumpAndSettle();

      // Tap Next button
      await tester.tap(find.text('Suivant'));
      await tester.pumpAndSettle();

      // Assert - No error message should be displayed
      expect(find.text('L\'âge doit être entre 10 et 120 ans'), findsNothing);
    });

    testWidgets('should accept minimum valid age (10) (AC #4)', (tester) async {
      // Arrange
      await tester.pumpWidget(createAgeScreen());
      await tester.pumpAndSettle();

      // Act
      await tester.enterText(find.byType(TextField), '10');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Suivant'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('L\'âge doit être entre 10 et 120 ans'), findsNothing);
    });

    testWidgets('should accept maximum valid age (120) (AC #4)', (tester) async {
      // Arrange
      await tester.pumpWidget(createAgeScreen());
      await tester.pumpAndSettle();

      // Act
      await tester.enterText(find.byType(TextField), '120');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Suivant'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('L\'âge doit être entre 10 et 120 ans'), findsNothing);
    });

    testWidgets('should show error for age below minimum (AC #4, #5)', (tester) async {
      // Arrange
      await tester.pumpWidget(createAgeScreen());
      await tester.pumpAndSettle();

      // Act - Enter age below min (9)
      await tester.enterText(find.byType(TextField), '9');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Suivant'));
      await tester.pumpAndSettle();

      // Assert - Error message should appear
      expect(
        find.text('L\'âge doit être entre 10 et 120 ans'),
        findsOneWidget,
      ); // AC #5
    });

    testWidgets('should show error for age above maximum (AC #4, #5)', (tester) async {
      // Arrange
      await tester.pumpWidget(createAgeScreen());
      await tester.pumpAndSettle();

      // Act - Enter age above max (121)
      await tester.enterText(find.byType(TextField), '121');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Suivant'));
      await tester.pumpAndSettle();

      // Assert - Error message should appear
      expect(
        find.text('L\'âge doit être entre 10 et 120 ans'),
        findsOneWidget,
      ); // AC #5
    });

    testWidgets('should show error for empty age (AC #5)', (tester) async {
      // Arrange
      await tester.pumpWidget(createAgeScreen());
      await tester.pumpAndSettle();

      // Act - Don't enter anything, just tap Next
      await tester.tap(find.text('Suivant'));
      await tester.pumpAndSettle();

      // Assert - Error message should appear
      expect(find.text('Veuillez entrer votre âge'), findsOneWidget); // AC #5
    });

    testWidgets('should show error for invalid format (AC #5)', (tester) async {
      // Arrange
      await tester.pumpWidget(createAgeScreen());
      await tester.pumpAndSettle();

      // Note: FilteringTextInputFormatter.digitsOnly prevents non-numeric input,
      // so we can't directly test invalid input. This test verifies empty after
      // attempting invalid input is handled.

      // Act - Try to enter invalid text (will be filtered to empty)
      await tester.enterText(find.byType(TextField), '');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Suivant'));
      await tester.pumpAndSettle();

      // Assert - Error message should appear for empty
      expect(find.text('Veuillez entrer votre âge'), findsOneWidget); // AC #5
    });

    testWidgets('should not proceed when age is invalid on Next button press (AC #6)', (tester) async {
      // Arrange
      await tester.pumpWidget(createAgeScreen());
      await tester.pumpAndSettle();

      // Act - Enter invalid age (below min)
      await tester.enterText(find.byType(TextField), '9');
      await tester.pumpAndSettle();

      // Tap Next button
      await tester.tap(find.text('Suivant'));
      await tester.pumpAndSettle();

      // Assert - Should not navigate (still on age screen)
      expect(find.text('Quel âge as-tu ?'), findsOneWidget);
      expect(find.text('Gender Screen'), findsNothing); // AC #6
    });

    testWidgets('should proceed when age is valid on Next button press (AC #6)', (tester) async {
      // Arrange
      await tester.pumpWidget(createAgeScreen());
      await tester.pumpAndSettle();

      // Act - Enter valid age
      await tester.enterText(find.byType(TextField), '25');
      await tester.pumpAndSettle();

      // Tap Next button
      await tester.tap(find.text('Suivant'));
      await tester.pumpAndSettle();

      // Assert - Should navigate to gender screen
      expect(find.text('Gender Screen'), findsOneWidget); // AC #6
    });

    testWidgets('should clear error when user starts typing', (tester) async {
      // Arrange
      await tester.pumpWidget(createAgeScreen());
      await tester.pumpAndSettle();

      // Trigger error first
      await tester.tap(find.text('Suivant'));
      await tester.pumpAndSettle();
      expect(find.text('Veuillez entrer votre âge'), findsOneWidget);

      // Act - Start typing
      await tester.enterText(find.byType(TextField), '2');
      await tester.pumpAndSettle();

      // Assert - Error should be cleared
      expect(find.text('Veuillez entrer votre âge'), findsNothing);
    });

    testWidgets('should update provider state when valid age entered', (tester) async {
      // Arrange
      late OnboardingState capturedState;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Consumer(
              builder: (context, ref, child) {
                capturedState = ref.watch(onboardingProvider);
                return const OnboardingAgeScreen();
              },
            ),
            routes: {
              '/onboarding_gender': (_) => const Scaffold(
                    body: Center(child: Text('Gender Screen')),
                  ),
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Act - Enter valid age and tap Next
      await tester.enterText(find.byType(TextField), '30');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Suivant'));
      await tester.pumpAndSettle();

      // Assert - Provider state should be updated
      expect(capturedState.age, 30);
    });

    testWidgets('should pre-fill age if already set in state', (tester) async {
      // Arrange - Create a test notifier with pre-filled age
      final testNotifier = OnboardingNotifier();
      testNotifier.updateAge(25);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            onboardingProvider.overrideWith((ref) => testNotifier),
          ],
          child: MaterialApp(
            home: const OnboardingAgeScreen(),
            routes: {
              '/onboarding_gender': (_) => const Scaffold(
                    body: Center(child: Text('Gender Screen')),
                  ),
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Act - Check TextField content
      final textField = tester.widget<TextField>(find.byType(TextField));
      final controller = textField.controller!;

      // Assert - TextField should be pre-filled
      expect(controller.text, '25');
    });

    testWidgets('should navigate to gender screen when Next pressed (AC #1, #8)', (tester) async {
      // Arrange
      await tester.pumpWidget(createAgeScreen());
      await tester.pumpAndSettle();

      // Act - Enter valid age
      await tester.enterText(find.byType(TextField), '25');
      await tester.pumpAndSettle();

      // Tap Next button
      await tester.tap(find.text('Suivant'));
      await tester.pumpAndSettle();

      // Assert - Should navigate to gender screen
      expect(find.text('Gender Screen'), findsOneWidget); // AC #8
    });

    testWidgets('should allow back navigation', (tester) async {
      // Arrange
      await tester.pumpWidget(createAgeScreen());
      await tester.pumpAndSettle();

      // Act - Tap back button
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Assert - Screen should pop (test doesn't crash)
      // In real app, this would navigate back to previous screen
    });
  });
}
