import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrate_or_die/domain/entities/avatar_personality.dart';
import 'package:hydrate_or_die/domain/entities/avatar_state.dart';
import 'package:hydrate_or_die/presentation/widgets/avatar_message_widget.dart';

void main() {
  group('AvatarMessageWidget', () {
    group('Doctor Personality', () {
      testWidgets('should display fresh message for doctor', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AvatarMessageWidget(
                personality: AvatarPersonality.doctor,
                state: AvatarState.fresh,
              ),
            ),
          ),
        );

        expect(find.text('Votre hydratation est optimale 💙'), findsOneWidget);

        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.style?.color, const Color(0xFF4CAF50)); // Green
      });

      testWidgets('should display tired message for doctor', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AvatarMessageWidget(
                personality: AvatarPersonality.doctor,
                state: AvatarState.tired,
              ),
            ),
          ),
        );

        expect(find.text('Votre niveau hydrique baisse... 💧'), findsOneWidget);

        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.style?.color, const Color(0xFFFF9800)); // Orange
      });

      testWidgets('should display dehydrated message for doctor', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AvatarMessageWidget(
                personality: AvatarPersonality.doctor,
                state: AvatarState.dehydrated,
              ),
            ),
          ),
        );

        expect(find.text('Déshydratation critique détectée ! ⚠️'), findsOneWidget);

        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.style?.color, const Color(0xFFF44336)); // Red
      });

      testWidgets('should display dead message for doctor', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AvatarMessageWidget(
                personality: AvatarPersonality.doctor,
                state: AvatarState.dead,
              ),
            ),
          ),
        );

        expect(find.text('Décès par déshydratation... 💀'), findsOneWidget);

        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.style?.color, const Color(0xFFF44336)); // Red
      });

      testWidgets('should display ghost message for doctor', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AvatarMessageWidget(
                personality: AvatarPersonality.doctor,
                state: AvatarState.ghost,
              ),
            ),
          ),
        );

        expect(find.text('État fantomatique... 👻'), findsOneWidget);

        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.style?.color, const Color(0xFF9E9E9E)); // Gray
      });
    });

    group('Sports Coach Personality', () {
      testWidgets('should display fresh message for coach', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AvatarMessageWidget(
                personality: AvatarPersonality.sportsCoach,
                state: AvatarState.fresh,
              ),
            ),
          ),
        );

        expect(find.text('Super forme champion ! 💪'), findsOneWidget);
      });

      testWidgets('should display tired message for coach (AC #3 example)', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AvatarMessageWidget(
                personality: AvatarPersonality.sportsCoach,
                state: AvatarState.tired,
              ),
            ),
          ),
        );

        expect(find.text('Allez champion, bois maintenant ! 💪'), findsOneWidget);
      });

      testWidgets('should display dehydrated message for coach', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AvatarMessageWidget(
                personality: AvatarPersonality.sportsCoach,
                state: AvatarState.dehydrated,
              ),
            ),
          ),
        );

        expect(find.text('On lâche rien ! BOIS ! 🔥'), findsOneWidget);
      });
    });

    group('Authoritarian Mother Personality', () {
      testWidgets('should display fresh message for mother', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AvatarMessageWidget(
                personality: AvatarPersonality.authoritarianMother,
                state: AvatarState.fresh,
              ),
            ),
          ),
        );

        expect(find.text('Très bien mon petit ! 😊'), findsOneWidget);
      });

      testWidgets('should display dehydrated message for mother (AC #3 example)', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AvatarMessageWidget(
                personality: AvatarPersonality.authoritarianMother,
                state: AvatarState.dehydrated,
              ),
            ),
          ),
        );

        expect(find.text('Tu veux que je m\'inquiète ?! 😟'), findsOneWidget);
      });
    });

    group('Sarcastic Friend Personality', () {
      testWidgets('should display fresh message for friend', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AvatarMessageWidget(
                personality: AvatarPersonality.sarcasticFriend,
                state: AvatarState.fresh,
              ),
            ),
          ),
        );

        expect(find.text('Nickel poto ! 😎'), findsOneWidget);
      });

      testWidgets('should display dead message for friend (AC #3 example)', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AvatarMessageWidget(
                personality: AvatarPersonality.sarcasticFriend,
                state: AvatarState.dead,
              ),
            ),
          ),
        );

        expect(find.text('Mec, j\'ai crevé... 💀'), findsOneWidget);
      });
    });

    group('Text Styling', () {
      testWidgets('should use correct font size (16px default)', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AvatarMessageWidget(
                personality: AvatarPersonality.doctor,
                state: AvatarState.fresh,
              ),
            ),
          ),
        );

        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.style?.fontSize, 16.0);
      });

      testWidgets('should use custom font size', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AvatarMessageWidget(
                personality: AvatarPersonality.doctor,
                state: AvatarState.fresh,
                fontSize: 20.0,
              ),
            ),
          ),
        );

        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.style?.fontSize, 20.0);
      });

      testWidgets('should center text', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AvatarMessageWidget(
                personality: AvatarPersonality.doctor,
                state: AvatarState.fresh,
              ),
            ),
          ),
        );

        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.textAlign, TextAlign.center);
      });

      testWidgets('should use medium font weight', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AvatarMessageWidget(
                personality: AvatarPersonality.doctor,
                state: AvatarState.fresh,
              ),
            ),
          ),
        );

        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.style?.fontWeight, FontWeight.w500);
      });
    });

    group('Color Coding (AC #3, spec lignes 1253-1258)', () {
      testWidgets('should use green for fresh state', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AvatarMessageWidget(
                personality: AvatarPersonality.doctor,
                state: AvatarState.fresh,
              ),
            ),
          ),
        );

        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.style?.color, const Color(0xFF4CAF50)); // Green
      });

      testWidgets('should use orange for tired state', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AvatarMessageWidget(
                personality: AvatarPersonality.doctor,
                state: AvatarState.tired,
              ),
            ),
          ),
        );

        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.style?.color, const Color(0xFFFF9800)); // Orange
      });

      testWidgets('should use red for dehydrated state', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AvatarMessageWidget(
                personality: AvatarPersonality.doctor,
                state: AvatarState.dehydrated,
              ),
            ),
          ),
        );

        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.style?.color, const Color(0xFFF44336)); // Red
      });

      testWidgets('should use red for dead state', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AvatarMessageWidget(
                personality: AvatarPersonality.doctor,
                state: AvatarState.dead,
              ),
            ),
          ),
        );

        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.style?.color, const Color(0xFFF44336)); // Red
      });

      testWidgets('should use gray for ghost state', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AvatarMessageWidget(
                personality: AvatarPersonality.doctor,
                state: AvatarState.ghost,
              ),
            ),
          ),
        );

        final textWidget = tester.widget<Text>(find.byType(Text));
        expect(textWidget.style?.color, const Color(0xFF9E9E9E)); // Gray
      });
    });
  });
}
