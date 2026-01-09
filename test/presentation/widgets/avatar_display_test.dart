import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrate_or_die/domain/entities/avatar_personality.dart';
import 'package:hydrate_or_die/domain/entities/avatar_state.dart';
import 'package:hydrate_or_die/presentation/widgets/avatar_display.dart';

void main() {
  group('AvatarDisplay Widget', () {
    /// Helper to build widget with ProviderScope
    Widget buildWidget(AvatarPersonality personality, AvatarState state) {
      return ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: AvatarDisplay(
              personality: personality,
              state: state,
            ),
          ),
        ),
      );
    }

    testWidgets('should display widget with default size', (tester) async {
      await tester.pumpWidget(
        buildWidget(AvatarPersonality.doctor, AvatarState.fresh),
      );

      // Find container with default size
      final container = tester.widget<Container>(
        find.byType(Container).first,
      );

      expect(container.constraints?.maxWidth, 150.0);
      expect(container.constraints?.maxHeight, 150.0);
    });

    testWidgets('should display widget with custom size', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: AvatarDisplay(
                personality: AvatarPersonality.doctor,
                state: AvatarState.fresh,
                size: 200.0,
              ),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.byType(Container).first,
      );

      expect(container.constraints?.maxWidth, 200.0);
      expect(container.constraints?.maxHeight, 200.0);
    });

    group('Doctor Avatar', () {
      testWidgets('should display doctor fresh emoji', (tester) async {
        await tester.pumpWidget(
          buildWidget(AvatarPersonality.doctor, AvatarState.fresh),
        );

        expect(find.text('🧑‍⚕️😊'), findsOneWidget);
      });

      testWidgets('should display doctor tired emoji', (tester) async {
        await tester.pumpWidget(
          buildWidget(AvatarPersonality.doctor, AvatarState.tired),
        );

        expect(find.text('🧑‍⚕️😐'), findsOneWidget);
      });

      testWidgets('should display doctor dehydrated emoji', (tester) async {
        await tester.pumpWidget(
          buildWidget(AvatarPersonality.doctor, AvatarState.dehydrated),
        );

        expect(find.text('🧑‍⚕️😟'), findsOneWidget);
      });

      testWidgets('should display doctor dead emoji', (tester) async {
        await tester.pumpWidget(
          buildWidget(AvatarPersonality.doctor, AvatarState.dead),
        );

        expect(find.text('🧑‍⚕️💀'), findsOneWidget);
      });

      testWidgets('should display doctor ghost emoji', (tester) async {
        await tester.pumpWidget(
          buildWidget(AvatarPersonality.doctor, AvatarState.ghost),
        );

        expect(find.text('👻'), findsOneWidget);
      });
    });

    group('Sports Coach Avatar', () {
      testWidgets('should display coach fresh emoji', (tester) async {
        await tester.pumpWidget(
          buildWidget(AvatarPersonality.sportsCoach, AvatarState.fresh),
        );

        expect(find.text('💪😊'), findsOneWidget);
      });

      testWidgets('should display coach tired emoji', (tester) async {
        await tester.pumpWidget(
          buildWidget(AvatarPersonality.sportsCoach, AvatarState.tired),
        );

        expect(find.text('💪😐'), findsOneWidget);
      });

      testWidgets('should display coach dehydrated emoji', (tester) async {
        await tester.pumpWidget(
          buildWidget(AvatarPersonality.sportsCoach, AvatarState.dehydrated),
        );

        expect(find.text('💪😟'), findsOneWidget);
      });

      testWidgets('should display coach dead emoji', (tester) async {
        await tester.pumpWidget(
          buildWidget(AvatarPersonality.sportsCoach, AvatarState.dead),
        );

        expect(find.text('💪💀'), findsOneWidget);
      });

      testWidgets('should display coach ghost emoji', (tester) async {
        await tester.pumpWidget(
          buildWidget(AvatarPersonality.sportsCoach, AvatarState.ghost),
        );

        expect(find.text('👻'), findsOneWidget);
      });
    });

    group('Authoritarian Mother Avatar', () {
      testWidgets('should display mother fresh emoji', (tester) async {
        await tester.pumpWidget(
          buildWidget(AvatarPersonality.authoritarianMother, AvatarState.fresh),
        );

        expect(find.text('👩😊'), findsOneWidget);
      });

      testWidgets('should display mother tired emoji', (tester) async {
        await tester.pumpWidget(
          buildWidget(AvatarPersonality.authoritarianMother, AvatarState.tired),
        );

        expect(find.text('👩😐'), findsOneWidget);
      });

      testWidgets(
        'should display mother dehydrated emoji',
        (tester) async {
          await tester.pumpWidget(
            buildWidget(
              AvatarPersonality.authoritarianMother,
              AvatarState.dehydrated,
            ),
          );

          expect(find.text('👩😟'), findsOneWidget);
        },
      );

      testWidgets('should display mother dead emoji', (tester) async {
        await tester.pumpWidget(
          buildWidget(AvatarPersonality.authoritarianMother, AvatarState.dead),
        );

        expect(find.text('👩💀'), findsOneWidget);
      });

      testWidgets('should display mother ghost emoji', (tester) async {
        await tester.pumpWidget(
          buildWidget(AvatarPersonality.authoritarianMother, AvatarState.ghost),
        );

        expect(find.text('👻'), findsOneWidget);
      });
    });

    group('Sarcastic Friend Avatar', () {
      testWidgets('should display friend fresh emoji', (tester) async {
        await tester.pumpWidget(
          buildWidget(AvatarPersonality.sarcasticFriend, AvatarState.fresh),
        );

        expect(find.text('🤝😊'), findsOneWidget);
      });

      testWidgets('should display friend tired emoji', (tester) async {
        await tester.pumpWidget(
          buildWidget(AvatarPersonality.sarcasticFriend, AvatarState.tired),
        );

        expect(find.text('🤝😐'), findsOneWidget);
      });

      testWidgets('should display friend dehydrated emoji', (tester) async {
        await tester.pumpWidget(
          buildWidget(
            AvatarPersonality.sarcasticFriend,
            AvatarState.dehydrated,
          ),
        );

        expect(find.text('🤝😟'), findsOneWidget);
      });

      testWidgets('should display friend dead emoji', (tester) async {
        await tester.pumpWidget(
          buildWidget(AvatarPersonality.sarcasticFriend, AvatarState.dead),
        );

        expect(find.text('🤝💀'), findsOneWidget);
      });

      testWidgets('should display friend ghost emoji', (tester) async {
        await tester.pumpWidget(
          buildWidget(AvatarPersonality.sarcasticFriend, AvatarState.ghost),
        );

        expect(find.text('👻'), findsOneWidget);
      });
    });

    group('Background Colors', () {
      testWidgets('should have green background for fresh state',
          (tester) async {
        await tester.pumpWidget(
          buildWidget(AvatarPersonality.doctor, AvatarState.fresh),
        );

        final container = tester.widget<Container>(
          find.byType(Container).first,
        );
        final decoration = container.decoration as BoxDecoration;

        expect(decoration.color, const Color(0xFFE8F5E9)); // Light green
      });

      testWidgets('should have yellow background for tired state',
          (tester) async {
        await tester.pumpWidget(
          buildWidget(AvatarPersonality.doctor, AvatarState.tired),
        );

        final container = tester.widget<Container>(
          find.byType(Container).first,
        );
        final decoration = container.decoration as BoxDecoration;

        expect(decoration.color, const Color(0xFFFFF9C4)); // Light yellow
      });

      testWidgets('should have orange background for dehydrated state',
          (tester) async {
        await tester.pumpWidget(
          buildWidget(AvatarPersonality.doctor, AvatarState.dehydrated),
        );

        final container = tester.widget<Container>(
          find.byType(Container).first,
        );
        final decoration = container.decoration as BoxDecoration;

        expect(decoration.color, const Color(0xFFFFE0B2)); // Light orange
      });

      testWidgets('should have red background for dead state', (tester) async {
        await tester.pumpWidget(
          buildWidget(AvatarPersonality.doctor, AvatarState.dead),
        );

        final container = tester.widget<Container>(
          find.byType(Container).first,
        );
        final decoration = container.decoration as BoxDecoration;

        expect(decoration.color, const Color(0xFFFFCDD2)); // Light red
      });

      testWidgets('should have gray background for ghost state',
          (tester) async {
        await tester.pumpWidget(
          buildWidget(AvatarPersonality.doctor, AvatarState.ghost),
        );

        final container = tester.widget<Container>(
          find.byType(Container).first,
        );
        final decoration = container.decoration as BoxDecoration;

        expect(decoration.color, const Color(0xFFEEEEEE)); // Light gray
      });

      testWidgets('should use custom background color when provided',
          (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: AvatarDisplay(
                  personality: AvatarPersonality.doctor,
                  state: AvatarState.fresh,
                  backgroundColor: Colors.blue,
                ),
              ),
            ),
          ),
        );

        final container = tester.widget<Container>(
          find.byType(Container).first,
        );
        final decoration = container.decoration as BoxDecoration;

        expect(decoration.color, Colors.blue);
      });
    });

    group('Visual Properties', () {
      testWidgets('should have circular shape', (tester) async {
        await tester.pumpWidget(
          buildWidget(AvatarPersonality.doctor, AvatarState.fresh),
        );

        final container = tester.widget<Container>(
          find.byType(Container).first,
        );
        final decoration = container.decoration as BoxDecoration;

        expect(decoration.shape, BoxShape.circle);
      });

      testWidgets('should have shadow', (tester) async {
        await tester.pumpWidget(
          buildWidget(AvatarPersonality.doctor, AvatarState.fresh),
        );

        final container = tester.widget<Container>(
          find.byType(Container).first,
        );
        final decoration = container.decoration as BoxDecoration;

        expect(decoration.boxShadow, isNotNull);
        expect(decoration.boxShadow!.length, 1);
        expect(decoration.boxShadow![0].blurRadius, 10);
      });

      testWidgets('should center emoji text', (tester) async {
        await tester.pumpWidget(
          buildWidget(AvatarPersonality.doctor, AvatarState.fresh),
        );

        final text = tester.widget<Text>(find.byType(Text));

        expect(text.textAlign, TextAlign.center);
      });

      testWidgets('emoji font size should be 50% of container size',
          (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: AvatarDisplay(
                  personality: AvatarPersonality.doctor,
                  state: AvatarState.fresh,
                  size: 200.0,
                ),
              ),
            ),
          ),
        );

        final text = tester.widget<Text>(find.byType(Text));

        expect(text.style?.fontSize, 100.0); // 50% of 200
      });
    });

    group('All 20 Combinations', () {
      testWidgets('should render all 4 personalities × 5 states',
          (tester) async {
        // Test all 20 combinations systematically
        final combinations = <String, dynamic>{};

        for (final personality in AvatarPersonality.values) {
          for (final state in AvatarState.values) {
            await tester.pumpWidget(buildWidget(personality, state));

            // Verify widget renders without errors
            expect(find.byType(AvatarDisplay), findsOneWidget);
            expect(find.byType(Container), findsWidgets);
            expect(find.byType(Text), findsOneWidget);

            combinations['${personality.name}/${state.name}'] = true;
          }
        }

        // Verify we tested all 20 combinations
        expect(combinations.length, 20);
      });
    });
  });
}
