import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrate_or_die/presentation/providers/onboarding_provider.dart';
import 'package:hydrate_or_die/presentation/providers/onboarding_state.dart';
import 'package:hydrate_or_die/presentation/screens/onboarding/onboarding_weight_screen.dart';

void main() {
  group('OnboardingWeightScreen', () {
    Widget createWeightScreen() {
      return const ProviderScope(
        child: MaterialApp(
          home: OnboardingWeightScreen(),
        ),
      );
    }

    testWidgets('should display all UI components (AC #2, #8)', (tester) async {
      // Act
      await tester.pumpWidget(createWeightScreen());
      await tester.pumpAndSettle();

      // Assert - Progress indicator
      expect(find.text('Étape 1 sur 5'), findsOneWidget); // AC #8

      // Assert - Title and subtitle
      expect(find.text('Quel est ton poids ?'), findsOneWidget); // AC #2
      expect(
        find.text('Nécessaire pour calculer ton objectif d\'hydratation'),
        findsOneWidget,
      ); // AC #2

      // Assert - Unit toggle
      expect(find.text('kg'), findsWidgets); // AC #4 (appears in toggle and suffix)
      expect(find.text('lbs'), findsOneWidget); // AC #4

      // Assert - TextField
      expect(find.byType(TextField), findsOneWidget); // AC #3

      // Assert - Next button
      expect(find.text('Suivant'), findsOneWidget); // AC #7

      // Assert - Back button
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('should default to kg unit (AC #4)', (tester) async {
      // Act
      await tester.pumpWidget(createWeightScreen());
      await tester.pumpAndSettle();

      // Assert - TextField should show kg suffix
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.decoration?.suffixText, 'kg');
    });

    testWidgets('should allow switching to lbs unit (AC #4)', (tester) async {
      // Arrange
      await tester.pumpWidget(createWeightScreen());
      await tester.pumpAndSettle();

      // Act - Tap on lbs toggle
      await tester.tap(find.text('lbs'));
      await tester.pumpAndSettle();

      // Assert - TextField should show lbs suffix
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.decoration?.suffixText, 'lbs');
    });

    testWidgets('should convert weight when switching units', (tester) async {
      // Arrange
      await tester.pumpWidget(createWeightScreen());
      await tester.pumpAndSettle();

      // Enter 70 kg
      await tester.enterText(find.byType(TextField), '70');
      await tester.pumpAndSettle();

      // Act - Switch to lbs
      await tester.tap(find.text('lbs'));
      await tester.pumpAndSettle();

      // Assert - Should convert to ~154.3 lbs
      final textField = tester.widget<TextField>(find.byType(TextField));
      final controller = textField.controller!;
      final lbsValue = double.parse(controller.text);
      expect(lbsValue, closeTo(154.3, 0.5)); // 70kg ≈ 154.3lbs
    });

    testWidgets('should accept valid weight in kg (AC #5)', (tester) async {
      // Arrange
      await tester.pumpWidget(createWeightScreen());
      await tester.pumpAndSettle();

      // Act - Enter valid weight
      await tester.enterText(find.byType(TextField), '70');
      await tester.pumpAndSettle();

      // Tap Next button
      await tester.tap(find.text('Suivant'));
      await tester.pumpAndSettle();

      // Assert - No error message should be displayed
      expect(find.text('Le poids doit être entre 30 et 300 kg'), findsNothing);
    });

    testWidgets('should accept minimum valid weight (30kg) (AC #5)', (tester) async {
      // Arrange
      await tester.pumpWidget(createWeightScreen());
      await tester.pumpAndSettle();

      // Act
      await tester.enterText(find.byType(TextField), '30');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Suivant'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Le poids doit être entre 30 et 300 kg'), findsNothing);
    });

    testWidgets('should accept maximum valid weight (300kg) (AC #5)', (tester) async {
      // Arrange
      await tester.pumpWidget(createWeightScreen());
      await tester.pumpAndSettle();

      // Act
      await tester.enterText(find.byType(TextField), '300');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Suivant'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Le poids doit être entre 30 et 300 kg'), findsNothing);
    });

    testWidgets('should show error for weight below minimum (AC #5, #6)', (tester) async {
      // Arrange
      await tester.pumpWidget(createWeightScreen());
      await tester.pumpAndSettle();

      // Act - Enter weight below min (29kg)
      await tester.enterText(find.byType(TextField), '29');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Suivant'));
      await tester.pumpAndSettle();

      // Assert - Error message should appear
      expect(
        find.text('Le poids doit être entre 30 et 300 kg'),
        findsOneWidget,
      ); // AC #6
    });

    testWidgets('should show error for weight above maximum (AC #5, #6)', (tester) async {
      // Arrange
      await tester.pumpWidget(createWeightScreen());
      await tester.pumpAndSettle();

      // Act - Enter weight above max (301kg)
      await tester.enterText(find.byType(TextField), '301');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Suivant'));
      await tester.pumpAndSettle();

      // Assert - Error message should appear
      expect(
        find.text('Le poids doit être entre 30 et 300 kg'),
        findsOneWidget,
      ); // AC #6
    });

    testWidgets('should show error for empty weight (AC #5, #6)', (tester) async {
      // Arrange
      await tester.pumpWidget(createWeightScreen());
      await tester.pumpAndSettle();

      // Act - Don't enter anything, just tap Next
      await tester.tap(find.text('Suivant'));
      await tester.pumpAndSettle();

      // Assert - Error message should appear
      expect(find.text('Veuillez entrer votre poids'), findsOneWidget); // AC #6
    });

    testWidgets('should show error for invalid format (AC #5, #6)', (tester) async {
      // Arrange
      await tester.pumpWidget(createWeightScreen());
      await tester.pumpAndSettle();

      // Act - Enter invalid format (just a dot)
      await tester.enterText(find.byType(TextField), '.');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Suivant'));
      await tester.pumpAndSettle();

      // Assert - Error message should appear
      expect(find.text('Veuillez entrer un nombre valide'), findsOneWidget); // AC #6
    });

    testWidgets('should validate lbs range (66-661) (AC #5)', (tester) async {
      // Arrange
      await tester.pumpWidget(createWeightScreen());
      await tester.pumpAndSettle();

      // Switch to lbs
      await tester.tap(find.text('lbs'));
      await tester.pumpAndSettle();

      // Act - Enter weight below min lbs (65)
      await tester.enterText(find.byType(TextField), '65');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Suivant'));
      await tester.pumpAndSettle();

      // Assert - Error message for lbs range
      expect(
        find.text('Le poids doit être entre 66 et 661 lbs'),
        findsOneWidget,
      );
    });

    testWidgets('should clear error when user starts typing', (tester) async {
      // Arrange
      await tester.pumpWidget(createWeightScreen());
      await tester.pumpAndSettle();

      // Trigger error first
      await tester.tap(find.text('Suivant'));
      await tester.pumpAndSettle();
      expect(find.text('Veuillez entrer votre poids'), findsOneWidget);

      // Act - Start typing
      await tester.enterText(find.byType(TextField), '7');
      await tester.pumpAndSettle();

      // Assert - Error should be cleared
      expect(find.text('Veuillez entrer votre poids'), findsNothing);
    });

    testWidgets('should use numeric keyboard (AC #3)', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createWeightScreen());
      await tester.pumpAndSettle();

      // Assert - TextField should have numeric keyboard type
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(
        textField.keyboardType,
        const TextInputType.numberWithOptions(decimal: true),
      ); // AC #3
    });

    testWidgets('should update provider state when valid weight entered', (tester) async {
      // Arrange
      late OnboardingState capturedState;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Consumer(
              builder: (context, ref, child) {
                capturedState = ref.watch(onboardingProvider);
                return const OnboardingWeightScreen();
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Act - Enter valid weight and tap Next
      await tester.enterText(find.byType(TextField), '70');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Suivant'));
      await tester.pumpAndSettle();

      // Assert - Provider state should be updated
      expect(capturedState.weight, 70.0);
    });

    testWidgets('should convert lbs to kg when updating provider', (tester) async {
      // Arrange
      late OnboardingState capturedState;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Consumer(
              builder: (context, ref, child) {
                capturedState = ref.watch(onboardingProvider);
                return const OnboardingWeightScreen();
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Switch to lbs
      await tester.tap(find.text('lbs'));
      await tester.pumpAndSettle();

      // Act - Enter weight in lbs
      await tester.enterText(find.byType(TextField), '154'); // ~70kg
      await tester.pumpAndSettle();

      await tester.tap(find.text('Suivant'));
      await tester.pumpAndSettle();

      // Assert - Should be converted to kg
      expect(capturedState.weight, closeTo(70.0, 1.0)); // ~70kg
    });

    testWidgets('should pre-fill weight if already set in state', (tester) async {
      // Arrange - Create a test notifier with pre-filled weight
      final testNotifier = OnboardingNotifier();
      testNotifier.updateWeight(75.0);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            onboardingProvider.overrideWith((ref) => testNotifier),
          ],
          child: const MaterialApp(
            home: OnboardingWeightScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Act - Check TextField content
      final textField = tester.widget<TextField>(find.byType(TextField));
      final controller = textField.controller!;

      // Assert - TextField should be pre-filled
      expect(controller.text, '75.0');
    });

    testWidgets('should allow back navigation', (tester) async {
      // Arrange
      await tester.pumpWidget(createWeightScreen());
      await tester.pumpAndSettle();

      // Act - Tap back button
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Assert - Screen should pop (test doesn't crash)
      // In real app, this would navigate back to previous screen
    });
  });
}
