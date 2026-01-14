import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrate_or_die/presentation/screens/onboarding/onboarding_gender_screen.dart';

void main() {
  group('OnboardingGenderScreen', () {
    testWidgets('should display gender selection screen', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const OnboardingGenderScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      
      expect(find.text('Sexe biologique'), findsOneWidget);
      expect(find.text('Homme'), findsOneWidget);
      expect(find.text('Femme'), findsOneWidget);
      expect(find.text('Autre'), findsOneWidget);
    });
  });
}
