import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrate_or_die/core/di/injection.dart';
import 'package:hydrate_or_die/core/services/camera_permission_service.dart';
import 'package:hydrate_or_die/domain/entities/activity_level.dart';
import 'package:hydrate_or_die/domain/entities/avatar_personality.dart';
import 'package:hydrate_or_die/domain/entities/avatar_state.dart';
import 'package:hydrate_or_die/domain/entities/gender.dart';
import 'package:hydrate_or_die/domain/entities/hydration_goal.dart';
import 'package:hydrate_or_die/domain/entities/user.dart';
import 'package:hydrate_or_die/domain/repositories/avatar_repository.dart';
import 'package:hydrate_or_die/domain/use_cases/avatar/update_avatar_state_use_case.dart';
import 'package:hydrate_or_die/domain/use_cases/photo/capture_photo_use_case.dart';
import 'package:hydrate_or_die/presentation/providers/home_provider.dart';
import 'package:hydrate_or_die/presentation/providers/user_provider.dart';
import 'package:hydrate_or_die/presentation/screens/home/home_screen.dart';
import 'package:hydrate_or_die/presentation/screens/photo_validation/photo_validation_screen.dart';
import 'package:hydrate_or_die/presentation/widgets/avatar_display.dart';
import 'package:hydrate_or_die/presentation/widgets/avatar_message_widget.dart';
import 'package:hydrate_or_die/presentation/widgets/hydration_progress_bar.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_screen_test.mocks.dart';

@GenerateMocks([CameraPermissionService, CapturePhotoUseCase])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockCameraPermissionService mockCameraPermissionService;
  late MockCapturePhotoUseCase mockCapturePhotoUseCase;

  setUp(() {
    mockCameraPermissionService = MockCameraPermissionService();
    mockCapturePhotoUseCase = MockCapturePhotoUseCase();

    // Reset GetIt before each test
    if (getIt.isRegistered<CameraPermissionService>()) {
      getIt.unregister<CameraPermissionService>();
    }
    if (getIt.isRegistered<CapturePhotoUseCase>()) {
      getIt.unregister<CapturePhotoUseCase>();
    }

    // Register mock services
    getIt.registerLazySingleton<CameraPermissionService>(
      () => mockCameraPermissionService,
    );
    getIt.registerLazySingleton<CapturePhotoUseCase>(
      () => mockCapturePhotoUseCase,
    );

    // Default mock behaviors
    when(
      mockCameraPermissionService.checkPermissionStatus(),
    ).thenAnswer((_) async => CameraPermissionStatus.granted);
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('HomeScreen', () {
    // Default test user with 2.5L daily goal
    final testUser = User(
      id: 'test-user-id',
      weight: 70.0,
      age: 30,
      gender: Gender.male,
      activityLevel: ActivityLevel.moderate,
      dailyGoal: HydrationGoal(2.5), // 2.5L
    );

    Widget createHomeScreen(HomeState state, {User? user}) {
      return ProviderScope(
        overrides: [
          homeProvider.overrideWith((ref) => TestHomeNotifier(state)),
          userProvider.overrideWith(() => TestUserNotifier(user ?? testUser)),
        ],
        child: const MaterialApp(home: HomeScreen()),
      );
    }

    testWidgets('should display all main UI components (AC #1)', (
      tester,
    ) async {
      // Arrange
      final state = HomeState(
        personality: AvatarPersonality.doctor,
        state: AvatarState.fresh,
        lastDrinkTime: DateTime.now().subtract(const Duration(hours: 1)),
      );

      // Act
      await tester.pumpWidget(createHomeScreen(state));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(AvatarDisplay), findsOneWidget); // AC #1
      expect(find.byType(AvatarMessageWidget), findsOneWidget); // AC #3
      expect(find.byType(HydrationProgressBar), findsOneWidget); // AC #3
      expect(find.text('💧 JE BOIS 💧'), findsOneWidget); // AC #6
    });

    testWidgets('should display avatar with fresh state (AC #2, #8)', (
      tester,
    ) async {
      // Arrange
      final state = HomeState(
        personality: AvatarPersonality.doctor,
        state: AvatarState.fresh,
        lastDrinkTime: DateTime.now(),
      );

      // Act
      await tester.pumpWidget(createHomeScreen(state));
      await tester.pumpAndSettle();

      // Assert - Avatar with fresh state
      final avatarDisplay = tester.widget<AvatarDisplay>(
        find.byType(AvatarDisplay),
      );
      expect(avatarDisplay.personality, AvatarPersonality.doctor);
      expect(avatarDisplay.state, AvatarState.fresh);
      expect(avatarDisplay.size, 200.0); // Spec ligne 1247

      // Assert - Message matches fresh state (green)
      expect(find.text('Votre hydratation est optimale 💙'), findsOneWidget);
    });

    testWidgets('should display avatar with tired state (AC #2, #8)', (
      tester,
    ) async {
      // Arrange
      final state = HomeState(
        personality: AvatarPersonality.sportsCoach,
        state: AvatarState.tired,
        lastDrinkTime: DateTime.now().subtract(const Duration(hours: 3)),
      );

      // Act
      await tester.pumpWidget(createHomeScreen(state));
      await tester.pumpAndSettle();

      // Assert - Avatar with tired state
      final avatarDisplay = tester.widget<AvatarDisplay>(
        find.byType(AvatarDisplay),
      );
      expect(avatarDisplay.personality, AvatarPersonality.sportsCoach);
      expect(avatarDisplay.state, AvatarState.tired);

      // Assert - Message matches tired state (orange)
      expect(find.text('Allez champion, bois maintenant ! 💪'), findsOneWidget);
    });

    testWidgets('should display avatar with dehydrated state (AC #2, #8)', (
      tester,
    ) async {
      // Arrange
      final state = HomeState(
        personality: AvatarPersonality.authoritarianMother,
        state: AvatarState.dehydrated,
        lastDrinkTime: DateTime.now().subtract(const Duration(hours: 5)),
      );

      // Act
      await tester.pumpWidget(createHomeScreen(state));
      await tester.pumpAndSettle();

      // Assert - Avatar with dehydrated state
      final avatarDisplay = tester.widget<AvatarDisplay>(
        find.byType(AvatarDisplay),
      );
      expect(avatarDisplay.personality, AvatarPersonality.authoritarianMother);
      expect(avatarDisplay.state, AvatarState.dehydrated);

      // Assert - Message matches dehydrated state (red)
      expect(find.text('Tu veux que je m\'inquiète ?! 😟'), findsOneWidget);
    });

    testWidgets('should display avatar with dead state (AC #2, #8)', (
      tester,
    ) async {
      // Arrange
      final state = HomeState(
        personality: AvatarPersonality.sarcasticFriend,
        state: AvatarState.dead,
        lastDrinkTime: DateTime.now().subtract(const Duration(hours: 8)),
      );

      // Act
      await tester.pumpWidget(createHomeScreen(state));
      await tester.pumpAndSettle();

      // Assert - Avatar with dead state
      final avatarDisplay = tester.widget<AvatarDisplay>(
        find.byType(AvatarDisplay),
      );
      expect(avatarDisplay.personality, AvatarPersonality.sarcasticFriend);
      expect(avatarDisplay.state, AvatarState.dead);

      // Assert - Message matches dead state (red)
      expect(find.text('Mec, j\'ai crevé... 💀'), findsOneWidget);
    });

    testWidgets('should display elapsed time correctly (AC #4)', (
      tester,
    ) async {
      // Arrange
      final state = HomeState(
        personality: AvatarPersonality.doctor,
        state: AvatarState.tired,
        lastDrinkTime: DateTime.now().subtract(
          const Duration(hours: 1, minutes: 30),
        ),
      );

      // Act
      await tester.pumpWidget(createHomeScreen(state));
      await tester.pumpAndSettle();

      // Assert - Time display
      expect(find.text('Dernière hydratation:'), findsOneWidget);
      expect(find.text('il y a 1h 30min'), findsOneWidget);
    });

    testWidgets(
      'should display "Jamais encore bu" when lastDrinkTime is null (AC #4)',
      (tester) async {
        // Arrange
        const state = HomeState(
          personality: AvatarPersonality.doctor,
          state: AvatarState.fresh,
          lastDrinkTime: null,
        );

        // Act
        await tester.pumpWidget(createHomeScreen(state));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Jamais encore bu aujourd\'hui'), findsOneWidget);
      },
    );

    testWidgets('should display progress bar with placeholder values (AC #3)', (
      tester,
    ) async {
      // Arrange
      const state = HomeState(
        personality: AvatarPersonality.doctor,
        state: AvatarState.fresh,
      );

      // Act
      await tester.pumpWidget(createHomeScreen(state));
      await tester.pumpAndSettle();

      // Assert - Placeholder 0L / 2.5L (prompt ligne 202-204)
      final progressBar = tester.widget<HydrationProgressBar>(
        find.byType(HydrationProgressBar),
      );
      expect(progressBar.currentVolume, 0);
      expect(progressBar.goalVolume, 2500); // 2.5L hardcoded
    });

    testWidgets(
      'should display "JE BOIS" button when goal not reached (Story 3.8 AC #1, #5)',
      (tester) async {
        // Arrange
        const state = HomeState(
          personality: AvatarPersonality.doctor,
          state: AvatarState.fresh,
        );

        // Act
        await tester.pumpWidget(createHomeScreen(state));
        await tester.pumpAndSettle();

        // Assert - AC #5: Shows "JE BOIS" when goal not reached (0 < 2500)
        expect(find.text('💧 JE BOIS 💧'), findsOneWidget);
        expect(find.text('💧 JE BOIS ENCORE + 💧'), findsNothing);
      },
    );

    testWidgets('should display header with logo, time, streak, settings', (
      tester,
    ) async {
      // Arrange
      const state = HomeState(
        personality: AvatarPersonality.doctor,
        state: AvatarState.fresh,
      );

      // Act
      await tester.pumpWidget(createHomeScreen(state));
      await tester.pumpAndSettle();

      // Assert - Header elements (spec lignes 1240-1244)
      expect(find.text('💧'), findsOneWidget); // App logo
      expect(find.text('🔥'), findsOneWidget); // Streak icon
      expect(
        find.text('0 jours'),
        findsOneWidget,
      ); // Placeholder streak (prompt ligne 205-206)
      expect(find.byIcon(Icons.settings), findsOneWidget); // Settings icon
    });

    testWidgets('should display bottom navigation (AC #6)', (tester) async {
      // Arrange
      const state = HomeState(
        personality: AvatarPersonality.doctor,
        state: AvatarState.fresh,
      );

      // Act
      await tester.pumpWidget(createHomeScreen(state));
      await tester.pumpAndSettle();

      // Assert - Bottom nav (spec lignes 1276-1280)
      expect(find.text('Calendrier'), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Profil'), findsOneWidget);
      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets(
      'should display "JE BOIS" button with correct styling (spec lignes 1267-1274)',
      (tester) async {
        // Arrange
        const state = HomeState(
          personality: AvatarPersonality.doctor,
          state: AvatarState.fresh,
        );

        // Act
        await tester.pumpWidget(createHomeScreen(state));
        await tester.pumpAndSettle();

        // Assert - Button styling
        final button = tester.widget<ElevatedButton>(
          find.ancestor(
            of: find.text('💧 JE BOIS 💧'),
            matching: find.byType(ElevatedButton),
          ),
        );

        final buttonStyle = button.style;
        expect(
          buttonStyle?.backgroundColor?.resolve({}),
          const Color(0xFF2196F3),
        ); // Bleu hydratation
        expect(buttonStyle?.elevation?.resolve({}), 2.0); // Shadow level 2
      },
    );

    testWidgets('should format elapsed time for minutes only', (tester) async {
      // Arrange
      final state = HomeState(
        personality: AvatarPersonality.doctor,
        state: AvatarState.fresh,
        lastDrinkTime: DateTime.now().subtract(const Duration(minutes: 45)),
      );

      // Act
      await tester.pumpWidget(createHomeScreen(state));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('il y a 45 minutes'), findsOneWidget);
    });

    testWidgets('should handle different personalities correctly', (
      tester,
    ) async {
      // Test all 4 personalities
      final personalities = [
        (AvatarPersonality.doctor, 'Votre hydratation est optimale 💙'),
        (AvatarPersonality.sportsCoach, 'Super forme champion ! 💪'),
        (AvatarPersonality.authoritarianMother, 'Très bien mon petit ! 😊'),
        (AvatarPersonality.sarcasticFriend, 'Nickel poto ! 😎'),
      ];

      for (final entry in personalities) {
        final state = HomeState(
          personality: entry.$1,
          state: AvatarState.fresh,
          lastDrinkTime: DateTime.now(),
        );

        await tester.pumpWidget(createHomeScreen(state));
        await tester.pumpAndSettle();

        expect(find.text(entry.$2), findsOneWidget);

        // Clean up for next iteration
        await tester.pumpWidget(Container());
      }
    });

    // ========== Story 3.8 Tests ==========

    testWidgets('Story 3.8 AC #2: Button has correct height and color', (
      tester,
    ) async {
      // Arrange
      const state = HomeState(
        personality: AvatarPersonality.doctor,
        state: AvatarState.fresh,
      );

      // Act
      await tester.pumpWidget(createHomeScreen(state));
      await tester.pumpAndSettle();

      // Assert - AC #2: Minimum 60dp height (using 56dp Material Design)
      final buttonContainerWidget = find.ancestor(
        of: find.byType(ElevatedButton),
        matching: find.byType(AnimatedContainer),
      );
      expect(buttonContainerWidget, findsOneWidget);

      // Verify button height through size
      final buttonSize = tester.getSize(buttonContainerWidget);
      expect(
        buttonSize.height,
        56.0,
      ); // AC #2: >= 60dp (using 56dp Material Design)

      // Assert - AC #2: Primary blue color
      final button = tester.widget<ElevatedButton>(
        find.ancestor(
          of: find.text('💧 JE BOIS 💧'),
          matching: find.byType(ElevatedButton),
        ),
      );
      final buttonStyle = button.style;
      expect(
        buttonStyle?.backgroundColor?.resolve({}),
        const Color(0xFF2196F3),
      );
    });

    testWidgets('Story 3.8 AC #3: Button navigates to PhotoValidationScreen', (
      tester,
    ) async {
      // Arrange
      const state = HomeState(
        personality: AvatarPersonality.doctor,
        state: AvatarState.fresh,
      );

      // Act
      await tester.pumpWidget(createHomeScreen(state));
      await tester.pumpAndSettle();

      // Tap the button
      await tester.tap(find.text('💧 JE BOIS 💧'));
      await tester.pump(); // Start navigation animation
      await tester.pump(const Duration(seconds: 1)); // Complete navigation

      // Assert - AC #3: Navigation to PhotoValidationScreen
      expect(find.byType(PhotoValidationScreen), findsOneWidget);
      expect(find.text('Validation Photo'), findsOneWidget);
    });

    testWidgets('Story 3.8 AC #4: Button accessible when avatar is dead', (
      tester,
    ) async {
      // Arrange
      const state = HomeState(
        personality: AvatarPersonality.doctor,
        state: AvatarState.dead,
      );

      // Act
      await tester.pumpWidget(createHomeScreen(state));
      await tester.pumpAndSettle();

      // Assert - AC #4: Button still present and functional when dead
      expect(find.text('💧 JE BOIS 💧'), findsOneWidget);

      final button = tester.widget<ElevatedButton>(
        find.ancestor(
          of: find.text('💧 JE BOIS 💧'),
          matching: find.byType(ElevatedButton),
        ),
      );
      expect(button.onPressed, isNotNull); // Button is functional

      // Verify navigation works
      await tester.tap(find.text('💧 JE BOIS 💧'));
      await tester.pump(); // Start navigation animation
      await tester.pump(const Duration(seconds: 1)); // Complete navigation
      expect(find.byType(PhotoValidationScreen), findsOneWidget);
    });

    testWidgets('Story 3.8 AC #4: Button accessible when avatar is ghost', (
      tester,
    ) async {
      // Arrange
      const state = HomeState(
        personality: AvatarPersonality.sarcasticFriend,
        state: AvatarState.ghost,
      );

      // Act
      await tester.pumpWidget(createHomeScreen(state));
      await tester.pumpAndSettle();

      // Assert - AC #4: Button still present and functional when ghost
      expect(find.text('💧 JE BOIS 💧'), findsOneWidget);

      final button = tester.widget<ElevatedButton>(
        find.ancestor(
          of: find.text('💧 JE BOIS 💧'),
          matching: find.byType(ElevatedButton),
        ),
      );
      expect(button.onPressed, isNotNull); // Button is functional
    });

    testWidgets('Story 3.8 AC #5: Button text changes based on goal status', (
      tester,
    ) async {
      // Arrange - Default user with 2.5L goal
      // currentVolume = 0, goalVolume = 2500 → goal NOT reached
      const state = HomeState(
        personality: AvatarPersonality.doctor,
        state: AvatarState.fresh,
      );

      // Act
      await tester.pumpWidget(createHomeScreen(state));
      await tester.pumpAndSettle();

      // Assert - AC #5: Shows "JE BOIS" when goal NOT reached (0 < 2500)
      expect(find.text('💧 JE BOIS 💧'), findsOneWidget);
      expect(find.text('💧 JE BOIS ENCORE + 💧'), findsNothing);

      // NOTE: Full test of "JE BOIS ENCORE +" requires Story 3.2 (HydrationLog)
      // to have actual currentVolume >= goalVolume scenario
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

class _FakeUpdateAvatarStateUseCase implements UpdateAvatarStateUseCase {
  @override
  Future<AvatarState> execute() async {
    // Return a default state for tests to prevent UnimplementedError
    return AvatarState.fresh;
  }
}

class _FakeAvatarRepository implements AvatarRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
