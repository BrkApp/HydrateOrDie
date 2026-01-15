import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrate_or_die/core/di/injection.dart';
import 'package:hydrate_or_die/domain/entities/activity_level.dart';
import 'package:hydrate_or_die/domain/entities/gender.dart';
import 'package:hydrate_or_die/domain/entities/hydration_goal.dart';
import 'package:hydrate_or_die/domain/entities/user.dart';
import 'package:hydrate_or_die/domain/repositories/user_repository.dart';
import 'package:hydrate_or_die/main.dart' as app;

void main() {
  group('Onboarding Flow Integration Tests', () {
    setUp(() async {
      // Setup DI if not already done
      if (!getIt.isRegistered<UserRepository>()) {
        await setupDependencies();
      }

      // Clear existing user profile
      final userRepo = getIt<UserRepository>();
      await userRepo.deleteProfile();
    });

    testWidgets('Complete onboarding flow: new user → finish onboarding → home', (tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Should detect no user profile and navigate to onboarding
      expect(find.text('Quel est ton poids ?'), findsOneWidget);
      expect(find.text('Étape 1/6'), findsOneWidget);

      // Step 1: Enter weight
      final weightField = find.byType(TextField);
      expect(weightField, findsOneWidget);

      await tester.enterText(weightField, '70');
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Suivant'));
      await tester.pumpAndSettle();

      // Step 2: Enter age
      expect(find.text('Quel âge as-tu ?'), findsOneWidget);
      expect(find.text('Étape 2/6'), findsOneWidget);

      final ageField = find.byType(TextField);
      await tester.enterText(ageField, '30');
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Suivant'));
      await tester.pumpAndSettle();

      // Step 3: Select gender
      expect(find.text('Étape 3/6'), findsOneWidget);

      // Tap Male button
      final maleButton = find.widgetWithText(ElevatedButton, 'Homme');
      await tester.tap(maleButton);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Suivant'));
      await tester.pumpAndSettle();

      // Step 4: Select activity level
      expect(find.text('Étape 4/6'), findsOneWidget);

      // Tap Moderate activity
      final moderateButton = find.text('Modérément actif');
      await tester.tap(moderateButton);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Suivant'));
      await tester.pumpAndSettle();

      // Step 5: Location (skip it)
      expect(find.text('Étape 5/6'), findsOneWidget);

      await tester.tap(find.text('Passer cette étape'));
      await tester.pumpAndSettle();

      // Step 6: Summary screen
      expect(find.text('Ton objectif quotidien'), findsOneWidget);
      expect(find.text('Étape 6/6'), findsOneWidget);

      // Should show calculated goal
      expect(find.textContaining('L'), findsWidgets);

      // Tap "C'est parti!" button
      final startButton = find.widgetWithText(ElevatedButton, 'C\'est parti !');
      await tester.tap(startButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Should navigate to Home screen
      expect(find.text('Hydrate or Die'), findsOneWidget);
      expect(find.byIcon(Icons.water_drop), findsWidgets);

      // Verify profile was saved
      final userRepo = getIt<UserRepository>();
      final savedProfile = await userRepo.getProfile();
      expect(savedProfile, isNotNull);
      expect(savedProfile!.weight, 70.0);
      expect(savedProfile.age, 30);
      expect(savedProfile.gender, Gender.male);
      expect(savedProfile.activityLevel, ActivityLevel.moderate);
    });

    testWidgets('Existing user should skip onboarding and go to home', (tester) async {
      // Create user profile first
      final userRepo = getIt<UserRepository>();
      await userRepo.saveProfile(
        User(
          id: '1',
          weight: 70.0,
          age: 30,
          gender: Gender.male,
          activityLevel: ActivityLevel.moderate,
          dailyGoal: HydrationGoal(2.8),
        ),
      );

      // Start app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Should skip onboarding and go to Home
      // (Note: Might go to avatar selection if no avatar selected - Epic 1)
      // For this test, we assume either Home or Avatar Selection is shown
      final onboardingNotFound = find.text('Quel est ton poids ?').evaluate().isEmpty;
      expect(onboardingNotFound, isTrue);
    });

    testWidgets('Navigation back/forward through onboarding works correctly', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Step 1: Weight
      expect(find.text('Étape 1/6'), findsOneWidget);

      final weightField = find.byType(TextField);
      await tester.enterText(weightField, '70');
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Suivant'));
      await tester.pumpAndSettle();

      // Step 2: Age
      expect(find.text('Étape 2/6'), findsOneWidget);

      // Go back
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Should be back on Weight screen
      expect(find.text('Étape 1/6'), findsOneWidget);
      expect(find.text('Quel est ton poids ?'), findsOneWidget);

      // Go forward again
      await tester.tap(find.widgetWithText(ElevatedButton, 'Suivant'));
      await tester.pumpAndSettle();

      // Should be on Age screen again
      expect(find.text('Étape 2/6'), findsOneWidget);
    });

    testWidgets('Skip location should work and proceed to summary', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Fill in all steps quickly to reach location
      final weightField = find.byType(TextField);
      await tester.enterText(weightField, '70');
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ElevatedButton, 'Suivant'));
      await tester.pumpAndSettle();

      // Age
      final ageField = find.byType(TextField);
      await tester.enterText(ageField, '30');
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ElevatedButton, 'Suivant'));
      await tester.pumpAndSettle();

      // Gender
      await tester.tap(find.widgetWithText(ElevatedButton, 'Homme'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ElevatedButton, 'Suivant'));
      await tester.pumpAndSettle();

      // Activity
      await tester.tap(find.text('Modérément actif'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ElevatedButton, 'Suivant'));
      await tester.pumpAndSettle();

      // Location screen - skip it
      expect(find.text('Étape 5/6'), findsOneWidget);
      expect(find.text('Passer cette étape'), findsOneWidget);

      await tester.tap(find.text('Passer cette étape'));
      await tester.pumpAndSettle();

      // Should go to summary
      expect(find.text('Ton objectif quotidien'), findsOneWidget);
      expect(find.text('Étape 6/6'), findsOneWidget);
    });
  });
}
