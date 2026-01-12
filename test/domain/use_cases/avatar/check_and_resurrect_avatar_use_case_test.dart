import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:hydrate_or_die/domain/entities/avatar.dart';
import 'package:hydrate_or_die/domain/entities/avatar_personality.dart';
import 'package:hydrate_or_die/domain/entities/avatar_state.dart';
import 'package:hydrate_or_die/domain/repositories/avatar_repository.dart';
import 'package:hydrate_or_die/domain/use_cases/avatar/check_and_resurrect_avatar_use_case.dart';

import 'check_and_resurrect_avatar_use_case_test.mocks.dart';

@GenerateMocks([AvatarRepository])
void main() {
  group('CheckAndResurrectAvatarUseCase', () {
    late CheckAndResurrectAvatarUseCase useCase;
    late MockAvatarRepository mockRepository;

    setUp(() {
      mockRepository = MockAvatarRepository();
      useCase = CheckAndResurrectAvatarUseCase(mockRepository);
    });

    group('execute()', () {
      test('AC #6 - Should resurrect avatar when state is ghost', () async {
        // Arrange
        final ghostAvatar = Avatar(
          id: 'test-id',
          name: 'Test Avatar',
          personality: AvatarPersonality.doctor,
          currentState: AvatarState.ghost,
          lastDrinkTime: DateTime(2024, 1, 1, 12, 0),
          lastUpdated: DateTime(2024, 1, 1, 12, 0),
        );

        when(mockRepository.getAvatar()).thenAnswer((_) async => ghostAvatar);
        when(mockRepository.updateAvatarState(any)).thenAnswer((_) async {});
        when(mockRepository.updateLastDrinkTime(any))
            .thenAnswer((_) async {});
        when(mockRepository.updateDeathTime(any)).thenAnswer((_) async {});

        // Act
        final result = await useCase.execute();

        // Assert
        expect(result, true);
        verify(mockRepository.updateAvatarState(AvatarState.fresh)).called(1);
        verify(mockRepository.updateLastDrinkTime(any)).called(1);
        verify(mockRepository.updateDeathTime(null)).called(1);
      });

      test('Should return false when state is not ghost (fresh)', () async {
        // Arrange
        final freshAvatar = Avatar(
          id: 'test-id',
          name: 'Test Avatar',
          personality: AvatarPersonality.doctor,
          currentState: AvatarState.fresh,
          lastDrinkTime: DateTime(2024, 1, 1, 12, 0),
          lastUpdated: DateTime(2024, 1, 1, 12, 0),
        );

        when(mockRepository.getAvatar()).thenAnswer((_) async => freshAvatar);

        // Act
        final result = await useCase.execute();

        // Assert
        expect(result, false);
        verifyNever(mockRepository.updateAvatarState(any));
        verifyNever(mockRepository.updateLastDrinkTime(any));
        verifyNever(mockRepository.updateDeathTime(any));
      });

      test('Should return false when state is dead', () async {
        // Arrange
        final deadAvatar = Avatar(
          id: 'test-id',
          name: 'Test Avatar',
          personality: AvatarPersonality.doctor,
          currentState: AvatarState.dead,
          lastDrinkTime: DateTime(2024, 1, 1, 12, 0),
          lastUpdated: DateTime(2024, 1, 1, 12, 0),
        );

        when(mockRepository.getAvatar()).thenAnswer((_) async => deadAvatar);

        // Act
        final result = await useCase.execute();

        // Assert
        expect(result, false);
        verifyNever(mockRepository.updateAvatarState(any));
      });

      test('Should return false when avatar is null', () async {
        // Arrange
        when(mockRepository.getAvatar()).thenAnswer((_) async => null);

        // Act
        final result = await useCase.execute();

        // Assert
        expect(result, false);
        verifyNever(mockRepository.updateAvatarState(any));
      });

      test('AC #6 - Should reset lastDrinkTime to current time on resurrection',
          () async {
        // Arrange
        final ghostAvatar = Avatar(
          id: 'test-id',
          name: 'Test Avatar',
          personality: AvatarPersonality.sportsCoach,
          currentState: AvatarState.ghost,
          lastDrinkTime: DateTime(2024, 1, 1, 6, 0), // Old timestamp
          lastUpdated: DateTime(2024, 1, 1, 12, 0),
        );

        when(mockRepository.getAvatar()).thenAnswer((_) async => ghostAvatar);
        when(mockRepository.updateAvatarState(any)).thenAnswer((_) async {});
        when(mockRepository.updateLastDrinkTime(any)).thenAnswer((_) async {});
        when(mockRepository.updateDeathTime(any)).thenAnswer((_) async {});

        final beforeExecution = DateTime.now();

        // Act
        await useCase.execute();

        final afterExecution = DateTime.now();

        // Assert - Verify lastDrinkTime was updated (captured by 'any' matcher)
        final captured = verify(mockRepository.updateLastDrinkTime(captureAny))
            .captured
            .single as DateTime;
        expect(
          captured
              .isAfter(beforeExecution.subtract(const Duration(seconds: 1))),
          true,
        );
        expect(
          captured.isBefore(afterExecution.add(const Duration(seconds: 1))),
          true,
        );
      });

      test('AC #6 - Should clear deathTime (set to null) on resurrection',
          () async {
        // Arrange
        final ghostAvatar = Avatar(
          id: 'test-id',
          name: 'Test Avatar',
          personality: AvatarPersonality.authoritarianMother,
          currentState: AvatarState.ghost,
          lastDrinkTime: DateTime(2024, 1, 1, 12, 0),
          lastUpdated: DateTime(2024, 1, 1, 12, 0),
        );

        when(mockRepository.getAvatar()).thenAnswer((_) async => ghostAvatar);
        when(mockRepository.updateAvatarState(any)).thenAnswer((_) async {});
        when(mockRepository.updateLastDrinkTime(any)).thenAnswer((_) async {});
        when(mockRepository.updateDeathTime(any)).thenAnswer((_) async {});

        // Act
        await useCase.execute();

        // Assert
        verify(mockRepository.updateDeathTime(null)).called(1);
      });

      test('Should throw StorageException when repository fails', () async {
        // Arrange
        final ghostAvatar = Avatar(
          id: 'test-id',
          name: 'Test Avatar',
          personality: AvatarPersonality.doctor,
          currentState: AvatarState.ghost,
          lastDrinkTime: DateTime(2024, 1, 1, 12, 0),
          lastUpdated: DateTime(2024, 1, 1, 12, 0),
        );

        when(mockRepository.getAvatar()).thenAnswer((_) async => ghostAvatar);
        when(mockRepository.updateAvatarState(any)).thenThrow(
          StorageException(
            'Database error',
            code: 'DB_ERROR',
          ),
        );

        // Act & Assert
        expect(
          () => useCase.execute(),
          throwsA(isA<StorageException>()),
        );
      });
    });
  });
}
