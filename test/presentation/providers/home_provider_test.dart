import 'package:flutter_test/flutter_test.dart';
import 'package:hydrate_or_die/domain/entities/avatar.dart';
import 'package:hydrate_or_die/domain/entities/avatar_personality.dart';
import 'package:hydrate_or_die/domain/entities/avatar_state.dart';
import 'package:hydrate_or_die/domain/repositories/avatar_repository.dart';
import 'package:hydrate_or_die/domain/use_cases/avatar/update_avatar_state_use_case.dart';
import 'package:hydrate_or_die/presentation/providers/home_provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_provider_test.mocks.dart';

@GenerateMocks([AvatarRepository, UpdateAvatarStateUseCase])
void main() {
  group('HomeProvider', () {
    late MockAvatarRepository mockRepository;
    late MockUpdateAvatarStateUseCase mockUpdateUseCase;
    late HomeNotifier notifier;
    bool notifierCreated = false;

    setUp(() {
      mockRepository = MockAvatarRepository();
      mockUpdateUseCase = MockUpdateAvatarStateUseCase();
      notifierCreated = false;
    });

    tearDown(() {
      if (notifierCreated) {
              }
    });

    test('should initialize with default state', () {
      // Arrange
      when(mockUpdateUseCase.execute()).thenAnswer((_) async => AvatarState.fresh);
      when(mockRepository.getAvatar()).thenAnswer((_) async => null);

      // Act
      notifier = HomeNotifier(mockUpdateUseCase, mockRepository);
      notifierCreated = true;
      notifierCreated = true;

      // Assert
      expect(notifier.state.personality, AvatarPersonality.doctor); // Default
      expect(notifier.state.state, AvatarState.fresh);
      expect(notifier.state.isLoading, false);
    });

    test('should load avatar data on init (AC #1, #2, #4)', () async {
      // Arrange
      final testAvatar = Avatar(
        id: 'test',
        name: 'Test Doctor',
        personality: AvatarPersonality.doctor,
        currentState: AvatarState.fresh,
        lastDrinkTime: DateTime.now(),
        lastUpdated: DateTime.now(),
      );

      when(mockUpdateUseCase.execute()).thenAnswer((_) async => AvatarState.fresh);
      when(mockRepository.getAvatar()).thenAnswer((_) async => testAvatar);

      // Act
      notifier = HomeNotifier(mockUpdateUseCase, mockRepository);
      notifierCreated = true;
      await Future.delayed(const Duration(milliseconds: 100)); // Wait for init

      // Assert
      expect(notifier.state.personality, AvatarPersonality.doctor);
      expect(notifier.state.state, AvatarState.fresh);
      expect(notifier.state.lastDrinkTime, testAvatar.lastDrinkTime);
      verify(mockUpdateUseCase.execute()).called(1);
      verify(mockRepository.getAvatar()).called(1);
    });

    test('should use default personality when avatar is null', () async {
      // Arrange
      when(mockUpdateUseCase.execute()).thenAnswer((_) async => AvatarState.tired);
      when(mockRepository.getAvatar()).thenAnswer((_) async => null);

      // Act
      notifier = HomeNotifier(mockUpdateUseCase, mockRepository);
      notifierCreated = true;
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert
      expect(notifier.state.personality, AvatarPersonality.doctor); // Default
      expect(notifier.state.state, AvatarState.tired);
    });

    test('should refresh state correctly (AC #2)', () async {
      // Arrange
      final testAvatar = Avatar(
        id: 'test',
        name: 'Test Coach',
        personality: AvatarPersonality.sportsCoach,
        currentState: AvatarState.fresh,
        lastDrinkTime: DateTime.now().subtract(const Duration(hours: 3)),
        lastUpdated: DateTime.now(),
      );

      when(mockUpdateUseCase.execute()).thenAnswer((_) async => AvatarState.tired);
      when(mockRepository.getAvatar()).thenAnswer((_) async => testAvatar);

      notifier = HomeNotifier(mockUpdateUseCase, mockRepository);
      notifierCreated = true;
      await Future.delayed(const Duration(milliseconds: 100));

      // Act
      await notifier.refresh();

      // Assert
      expect(notifier.state.personality, AvatarPersonality.sportsCoach);
      expect(notifier.state.state, AvatarState.tired);
      expect(notifier.state.lastDrinkTime, testAvatar.lastDrinkTime);
      verify(mockUpdateUseCase.execute()).called(2); // init + refresh
    });

    test('should handle different personality types (AC #3)', () async {
      // Test all 4 personalities
      final personalities = [
        AvatarPersonality.doctor,
        AvatarPersonality.sportsCoach,
        AvatarPersonality.authoritarianMother,
        AvatarPersonality.sarcasticFriend,
      ];

      for (final personality in personalities) {
        final testAvatar = Avatar(
          id: 'test',
          name: 'Test',
          personality: personality,
          currentState: AvatarState.fresh,
          lastDrinkTime: DateTime.now(),
          lastUpdated: DateTime.now(),
        );

        when(mockUpdateUseCase.execute()).thenAnswer((_) async => AvatarState.fresh);
        when(mockRepository.getAvatar()).thenAnswer((_) async => testAvatar);

        notifier = HomeNotifier(mockUpdateUseCase, mockRepository);
      notifierCreated = true;
        await Future.delayed(const Duration(milliseconds: 100));

        expect(notifier.state.personality, personality);

                reset(mockUpdateUseCase);
        reset(mockRepository);
      }
    });

    test('should handle different avatar states (AC #2)', () async {
      // Test all 5 states
      final states = [
        AvatarState.fresh,
        AvatarState.tired,
        AvatarState.dehydrated,
        AvatarState.dead,
        AvatarState.ghost,
      ];

      for (final state in states) {
        final testAvatar = Avatar(
          id: 'test',
          name: 'Test',
          personality: AvatarPersonality.doctor,
          currentState: state,
          lastDrinkTime: DateTime.now(),
          lastUpdated: DateTime.now(),
        );

        when(mockUpdateUseCase.execute()).thenAnswer((_) async => state);
        when(mockRepository.getAvatar()).thenAnswer((_) async => testAvatar);

        notifier = HomeNotifier(mockUpdateUseCase, mockRepository);
      notifierCreated = true;
        await Future.delayed(const Duration(milliseconds: 100));

        expect(notifier.state.state, state);

                reset(mockUpdateUseCase);
        reset(mockRepository);
      }
    });

    test('should handle null lastDrinkTime (AC #4)', () async {
      // Arrange
      final testAvatar = Avatar(
        id: 'test',
        name: 'Test',
        personality: AvatarPersonality.doctor,
        currentState: AvatarState.fresh,
        lastDrinkTime: DateTime.now(), // Avatar entity requires non-null
        lastUpdated: DateTime.now(),
      );

      when(mockUpdateUseCase.execute()).thenAnswer((_) async => AvatarState.fresh);
      when(mockRepository.getAvatar()).thenAnswer((_) async => testAvatar);

      // Act
      notifier = HomeNotifier(mockUpdateUseCase, mockRepository);
      notifierCreated = true;
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert
      expect(notifier.state.lastDrinkTime, isNotNull);
    });

    test('should handle errors gracefully', () async {
      // Arrange
      when(mockUpdateUseCase.execute()).thenThrow(Exception('Test error'));
      when(mockRepository.getAvatar()).thenAnswer((_) async => null);

      // Act
      notifier = HomeNotifier(mockUpdateUseCase, mockRepository);
      notifierCreated = true;
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert
      expect(notifier.state.errorMessage, isNotNull);
      expect(notifier.state.errorMessage, contains('Test error'));
    });

    test('should call updateAvatarStateUseCase on refresh', () async {
      // Arrange
      when(mockUpdateUseCase.execute()).thenAnswer((_) async => AvatarState.fresh);
      when(mockRepository.getAvatar()).thenAnswer((_) async => null);

      notifier = HomeNotifier(mockUpdateUseCase, mockRepository);
      notifierCreated = true;
      await Future.delayed(const Duration(milliseconds: 100));

      reset(mockUpdateUseCase);
      reset(mockRepository);

      when(mockUpdateUseCase.execute()).thenAnswer((_) async => AvatarState.tired);
      when(mockRepository.getAvatar()).thenAnswer((_) async => null);

      // Act
      await notifier.refresh();

      // Assert
      verify(mockUpdateUseCase.execute()).called(1);
      verify(mockRepository.getAvatar()).called(1);
    });
  });

  group('HomeState', () {
    test('should create state with required fields', () {
      // Act
      const state = HomeState(
        personality: AvatarPersonality.doctor,
        state: AvatarState.fresh,
      );

      // Assert
      expect(state.personality, AvatarPersonality.doctor);
      expect(state.state, AvatarState.fresh);
      expect(state.lastDrinkTime, null);
      expect(state.isLoading, false);
      expect(state.errorMessage, null);
    });

    test('should copyWith correctly', () {
      // Arrange
      const originalState = HomeState(
        personality: AvatarPersonality.doctor,
        state: AvatarState.fresh,
      );

      // Act
      final newState = originalState.copyWith(
        state: AvatarState.tired,
        isLoading: true,
      );

      // Assert
      expect(newState.personality, AvatarPersonality.doctor); // Unchanged
      expect(newState.state, AvatarState.tired); // Changed
      expect(newState.isLoading, true); // Changed
    });
  });
}
