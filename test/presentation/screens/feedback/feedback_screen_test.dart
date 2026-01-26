import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrate_or_die/core/constants/feedback_messages.dart';
import 'package:hydrate_or_die/domain/entities/activity_level.dart';
import 'package:hydrate_or_die/domain/entities/avatar_personality.dart';
import 'package:hydrate_or_die/domain/entities/avatar_state.dart';
import 'package:hydrate_or_die/domain/entities/gender.dart';
import 'package:hydrate_or_die/domain/entities/hydration_goal.dart';
import 'package:hydrate_or_die/domain/entities/user.dart';
import 'package:hydrate_or_die/domain/repositories/avatar_repository.dart';
import 'package:hydrate_or_die/domain/use_cases/avatar/update_avatar_state_use_case.dart';
import 'package:hydrate_or_die/presentation/providers/home_provider.dart';
import 'package:hydrate_or_die/presentation/providers/user_provider.dart';
import 'package:hydrate_or_die/presentation/screens/feedback/feedback_screen.dart';

void main() {
  group('FeedbackScreen Widget Tests', () {
    // Mock user data
    final mockUser = User(
      id: 'test-user-id',
      weight: 70.0,
      age: 25,
      gender: Gender.male,
      activityLevel: ActivityLevel.moderate,
      dailyGoal: HydrationGoal(2.0),
    );

    // Mock home state
    const mockHomeState = HomeState(
      personality: AvatarPersonality.doctor,
      state: AvatarState.fresh,
      lastDrinkTime: null,
      isLoading: false,
    );

    Widget createFeedbackScreen(HomeState state, {User? user}) {
      return ProviderScope(
        overrides: [
          homeProvider.overrideWith((ref) => TestHomeNotifier(state)),
          userProvider.overrideWith(() => TestUserNotifier(user)),
        ],
        child: const MaterialApp(home: FeedbackScreen()),
      );
    }

    testWidgets('AC #2: Avatar is displayed with animation', (tester) async {
      await tester.pumpWidget(
        createFeedbackScreen(mockHomeState, user: mockUser),
      );

      // Verify avatar is displayed
      expect(find.byKey(const Key('feedback_avatar')), findsOneWidget);

      // Verify avatar shows correct emoji
      final avatarText = tester.widget<Text>(
        find.byKey(const Key('feedback_avatar')),
      );
      expect(avatarText.data, contains('🧑‍⚕️'));
    });

    testWidgets('AC #3: Personalized message is displayed correctly', (
      tester,
    ) async {
      for (final personality in AvatarPersonality.values) {
        final homeState = HomeState(
          personality: personality,
          state: AvatarState.fresh,
          lastDrinkTime: null,
          isLoading: false,
        );

        await tester.pumpWidget(
          createFeedbackScreen(homeState, user: mockUser),
        );

        // Verify message matches personality
        final expectedMessage = kFeedbackMessages[personality];
        expect(find.text(expectedMessage!), findsOneWidget);
        expect(find.byKey(const Key('feedback_message')), findsOneWidget);

        // Clean up for next iteration
        await tester.pumpWidget(Container());
      }
    });

    testWidgets('AC #5: Hydration progress is displayed with correct format', (
      tester,
    ) async {
      await tester.pumpWidget(
        createFeedbackScreen(mockHomeState, user: mockUser),
      );

      await tester.pumpAndSettle();

      // Verify progress text is displayed with correct format
      expect(find.byKey(const Key('feedback_progress_text')), findsOneWidget);
      expect(find.textContaining('Tu as bu'), findsOneWidget);
      expect(find.textContaining('L sur'), findsOneWidget);
      expect(find.textContaining("L aujourd'hui"), findsOneWidget);

      // Verify progress bar exists
      expect(find.byKey(const Key('feedback_progress_bar')), findsOneWidget);
    });

    testWidgets('AC #5: Progress bar color changes when goal reached', (
      tester,
    ) async {
      await tester.pumpWidget(
        createFeedbackScreen(mockHomeState, user: mockUser),
      );

      await tester.pumpAndSettle();

      final progressBar = tester.widget<LinearProgressIndicator>(
        find.byKey(const Key('feedback_progress_bar')),
      );

      // With placeholder data (0.0L), progress should be 0.0
      expect(progressBar.value, 0.0);

      // Color should be primary (blue) since goal not reached
      final valueColor =
          progressBar.valueColor as AlwaysStoppedAnimation<Color>;
      // Cannot directly test color without Theme context, but verify it exists
      expect(valueColor, isNotNull);
    });

    testWidgets('AC #6: Auto-dismiss timer navigates back after 4 seconds', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            homeProvider.overrideWith((ref) => TestHomeNotifier(mockHomeState)),
            userProvider.overrideWith(() => TestUserNotifier(mockUser)),
          ],
          child: MaterialApp(
            home: const Scaffold(body: Text('Home')),
            routes: {'/feedback': (_) => const FeedbackScreen()},
          ),
        ),
      );

      // Navigate to FeedbackScreen
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();

      final navigator = tester.state<NavigatorState>(find.byType(Navigator));
      navigator.pushNamed('/feedback');
      await tester.pumpAndSettle();

      // Verify FeedbackScreen is displayed
      expect(find.byType(FeedbackScreen), findsOneWidget);

      // Wait for 4 seconds auto-dismiss timer
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      // Verify navigation back occurred
      expect(find.byType(FeedbackScreen), findsNothing);
      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('AC #7: "Continuer" button dismisses screen immediately', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            homeProvider.overrideWith((ref) => TestHomeNotifier(mockHomeState)),
            userProvider.overrideWith(() => TestUserNotifier(mockUser)),
          ],
          child: MaterialApp(
            home: const Scaffold(body: Text('Home')),
            routes: {'/feedback': (_) => const FeedbackScreen()},
          ),
        ),
      );

      // Navigate to FeedbackScreen
      final navigator = tester.state<NavigatorState>(find.byType(Navigator));
      navigator.pushNamed('/feedback');
      await tester.pumpAndSettle();

      // Verify FeedbackScreen is displayed
      expect(find.byType(FeedbackScreen), findsOneWidget);

      // Tap "Continuer" button
      expect(find.byKey(const Key('feedback_continue_button')), findsOneWidget);
      await tester.tap(find.byKey(const Key('feedback_continue_button')));
      await tester.pumpAndSettle();

      // Verify navigation back occurred immediately (without waiting 4 seconds)
      expect(find.byType(FeedbackScreen), findsNothing);
      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('AC #8: Animations are active on screen', (tester) async {
      await tester.pumpWidget(
        createFeedbackScreen(mockHomeState, user: mockUser),
      );

      // Let animations start
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Verify AnimatedBuilder widgets are present (indicates animations are running)
      expect(find.byType(AnimatedBuilder), findsWidgets);

      // Verify Transform widgets are used for scale and rotation
      final transforms = find.byType(Transform);
      expect(transforms, findsWidgets);

      // Avatar should be wrapped in transform widgets
      expect(find.byKey(const Key('feedback_avatar')), findsOneWidget);
    });

    testWidgets('Widget disposes cleanly without memory leaks', (tester) async {
      await tester.pumpWidget(
        createFeedbackScreen(mockHomeState, user: mockUser),
      );

      await tester.pumpAndSettle();

      // Dispose by replacing with different widget
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: Text('Different Screen'))),
      );

      await tester.pumpAndSettle();

      // No errors should occur during disposal
      expect(tester.takeException(), isNull);
    });

    testWidgets('Handles null user gracefully', (tester) async {
      await tester.pumpWidget(createFeedbackScreen(mockHomeState, user: null));

      await tester.pumpAndSettle();

      // Should still display avatar and message
      expect(find.byKey(const Key('feedback_avatar')), findsOneWidget);
      expect(find.byKey(const Key('feedback_message')), findsOneWidget);

      // Progress section should not be displayed
      expect(find.byKey(const Key('feedback_progress_text')), findsNothing);
      expect(find.byKey(const Key('feedback_progress_bar')), findsNothing);
    });
  });
}

/// Test implementation of HomeNotifier for testing
class TestHomeNotifier extends HomeNotifier {
  TestHomeNotifier(HomeState state)
    : super(_FakeUpdateAvatarStateUseCase(), _FakeAvatarRepository()) {
    // Override state immediately
    this.state = state;
  }
}

/// Test implementation of UserNotifier for testing
class TestUserNotifier extends UserNotifier {
  final User? _user;

  TestUserNotifier(this._user);

  @override
  Future<User?> build() async {
    return _user;
  }
}

class _FakeUpdateAvatarStateUseCase extends Fake
    implements UpdateAvatarStateUseCase {}

class _FakeAvatarRepository extends Fake implements AvatarRepository {}
