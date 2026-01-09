import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:hydrate_or_die/domain/entities/avatar.dart';
import 'package:hydrate_or_die/domain/entities/avatar_personality.dart';
import 'package:hydrate_or_die/domain/entities/avatar_state.dart';
import 'package:hydrate_or_die/domain/repositories/avatar_repository.dart';
import 'package:hydrate_or_die/domain/use_cases/avatar/update_avatar_state_use_case.dart';

import 'update_avatar_state_use_case_test.mocks.dart';

@GenerateMocks([AvatarRepository])
void main() {
  group('UpdateAvatarStateUseCase', () {
    late UpdateAvatarStateUseCase useCase;
    late MockAvatarRepository mockRepository;

    setUp(() {
      mockRepository = MockAvatarRepository();
      useCase = UpdateAvatarStateUseCase(mockRepository);
    });

    group('Calcul d\'état basé sur le temps écoulé', () {
      test('AC #2 - État Fresh (0h depuis dernier verre)', () async {
        // Arrange - Il y a 0 heures depuis le dernier verre
        final now = DateTime.now();
        final lastDrinkTime = now; // Juste maintenant
        final currentAvatar = Avatar(
          id: 'avatar_singleton',
          name: 'Docteur',
          personality: AvatarPersonality.doctor,
          currentState: AvatarState.fresh,
          lastDrinkTime: lastDrinkTime,
          lastUpdated: now,
        );

        when(mockRepository.getLastDrinkTime())
            .thenAnswer((_) async => lastDrinkTime);
        when(mockRepository.getAvatar()).thenAnswer((_) async => currentAvatar);

        // Act
        final result = await useCase.execute();

        // Assert
        expect(result, AvatarState.fresh);
        // L'état n'a pas changé, donc pas de mise à jour appelée
        verifyNever(mockRepository.updateAvatarState(any));
      });

      test('AC #2 - État Fresh (1h depuis dernier verre)', () async {
        // Arrange - Il y a 1 heure depuis le dernier verre
        final now = DateTime.now();
        final lastDrinkTime = now.subtract(const Duration(hours: 1));
        final currentAvatar = Avatar(
          id: 'avatar_singleton',
          name: 'Docteur',
          personality: AvatarPersonality.doctor,
          currentState: AvatarState.fresh,
          lastDrinkTime: lastDrinkTime,
          lastUpdated: now,
        );

        when(mockRepository.getLastDrinkTime())
            .thenAnswer((_) async => lastDrinkTime);
        when(mockRepository.getAvatar()).thenAnswer((_) async => currentAvatar);

        // Act
        final result = await useCase.execute();

        // Assert
        expect(result, AvatarState.fresh);
        verifyNever(mockRepository.updateAvatarState(any));
      });

      test('AC #2 - Transition Fresh → Tired (3h depuis dernier verre)',
          () async {
        // Arrange - Il y a 3 heures depuis le dernier verre
        final now = DateTime.now();
        final lastDrinkTime = now.subtract(const Duration(hours: 3));
        final currentAvatar = Avatar(
          id: 'avatar_singleton',
          name: 'Docteur',
          personality: AvatarPersonality.doctor,
          currentState: AvatarState.fresh,
          lastDrinkTime: lastDrinkTime,
          lastUpdated: now,
        );

        when(mockRepository.getLastDrinkTime())
            .thenAnswer((_) async => lastDrinkTime);
        when(mockRepository.getAvatar()).thenAnswer((_) async => currentAvatar);
        when(mockRepository.updateAvatarState(AvatarState.tired))
            .thenAnswer((_) async => {});

        // Act
        final result = await useCase.execute();

        // Assert
        expect(result, AvatarState.tired);
        verify(mockRepository.updateAvatarState(AvatarState.tired)).called(1);
      });

      test('AC #2 - Transition Tired → Dehydrated (5h depuis dernier verre)',
          () async {
        // Arrange - Il y a 5 heures depuis le dernier verre
        final now = DateTime.now();
        final lastDrinkTime = now.subtract(const Duration(hours: 5));
        final currentAvatar = Avatar(
          id: 'avatar_singleton',
          name: 'Coach',
          personality: AvatarPersonality.sportsCoach,
          currentState: AvatarState.tired,
          lastDrinkTime: lastDrinkTime,
          lastUpdated: now,
        );

        when(mockRepository.getLastDrinkTime())
            .thenAnswer((_) async => lastDrinkTime);
        when(mockRepository.getAvatar()).thenAnswer((_) async => currentAvatar);
        when(mockRepository.updateAvatarState(AvatarState.dehydrated))
            .thenAnswer((_) async => {});

        // Act
        final result = await useCase.execute();

        // Assert
        expect(result, AvatarState.dehydrated);
        verify(mockRepository.updateAvatarState(AvatarState.dehydrated))
            .called(1);
      });

      test('AC #2 - Transition Dehydrated → Dead (7h depuis dernier verre)',
          () async {
        // Arrange - Il y a 7 heures depuis le dernier verre
        final now = DateTime.now();
        final lastDrinkTime = now.subtract(const Duration(hours: 7));
        final currentAvatar = Avatar(
          id: 'avatar_singleton',
          name: 'Maman',
          personality: AvatarPersonality.authoritarianMother,
          currentState: AvatarState.dehydrated,
          lastDrinkTime: lastDrinkTime,
          lastUpdated: now,
        );

        when(mockRepository.getLastDrinkTime())
            .thenAnswer((_) async => lastDrinkTime);
        when(mockRepository.getAvatar()).thenAnswer((_) async => currentAvatar);
        when(mockRepository.updateAvatarState(AvatarState.dead))
            .thenAnswer((_) async => {});

        // Act
        final result = await useCase.execute();

        // Assert
        expect(result, AvatarState.dead);
        verify(mockRepository.updateAvatarState(AvatarState.dead)).called(1);
      });

      test('AC #2 - Seuil exact 2h (Fresh → Tired)', () async {
        // Arrange - Exactement 2 heures depuis le dernier verre
        final now = DateTime.now();
        final lastDrinkTime = now.subtract(const Duration(hours: 2));
        final currentAvatar = Avatar(
          id: 'avatar_singleton',
          name: 'Ami',
          personality: AvatarPersonality.sarcasticFriend,
          currentState: AvatarState.fresh,
          lastDrinkTime: lastDrinkTime,
          lastUpdated: now,
        );

        when(mockRepository.getLastDrinkTime())
            .thenAnswer((_) async => lastDrinkTime);
        when(mockRepository.getAvatar()).thenAnswer((_) async => currentAvatar);
        when(mockRepository.updateAvatarState(AvatarState.tired))
            .thenAnswer((_) async => {});

        // Act
        final result = await useCase.execute();

        // Assert
        expect(result, AvatarState.tired);
        verify(mockRepository.updateAvatarState(AvatarState.tired)).called(1);
      });

      test('AC #2 - Seuil exact 4h (Tired → Dehydrated)', () async {
        // Arrange - Exactement 4 heures depuis le dernier verre
        final now = DateTime.now();
        final lastDrinkTime = now.subtract(const Duration(hours: 4));
        final currentAvatar = Avatar(
          id: 'avatar_singleton',
          name: 'Docteur',
          personality: AvatarPersonality.doctor,
          currentState: AvatarState.tired,
          lastDrinkTime: lastDrinkTime,
          lastUpdated: now,
        );

        when(mockRepository.getLastDrinkTime())
            .thenAnswer((_) async => lastDrinkTime);
        when(mockRepository.getAvatar()).thenAnswer((_) async => currentAvatar);
        when(mockRepository.updateAvatarState(AvatarState.dehydrated))
            .thenAnswer((_) async => {});

        // Act
        final result = await useCase.execute();

        // Assert
        expect(result, AvatarState.dehydrated);
        verify(mockRepository.updateAvatarState(AvatarState.dehydrated))
            .called(1);
      });

      test('AC #2 - Seuil exact 6h (Dehydrated → Dead)', () async {
        // Arrange - Exactement 6 heures depuis le dernier verre
        final now = DateTime.now();
        final lastDrinkTime = now.subtract(const Duration(hours: 6));
        final currentAvatar = Avatar(
          id: 'avatar_singleton',
          name: 'Coach',
          personality: AvatarPersonality.sportsCoach,
          currentState: AvatarState.dehydrated,
          lastDrinkTime: lastDrinkTime,
          lastUpdated: now,
        );

        when(mockRepository.getLastDrinkTime())
            .thenAnswer((_) async => lastDrinkTime);
        when(mockRepository.getAvatar()).thenAnswer((_) async => currentAvatar);
        when(mockRepository.updateAvatarState(AvatarState.dead))
            .thenAnswer((_) async => {});

        // Act
        final result = await useCase.execute();

        // Assert
        expect(result, AvatarState.dead);
        verify(mockRepository.updateAvatarState(AvatarState.dead)).called(1);
      });
    });

    group('AC #1, #3 - Calcul basé sur DateTime.now() et lastDrinkTime', () {
      test('Utilise DateTime.now() pour calculer temps écoulé', () async {
        // Arrange
        final lastDrinkTime = DateTime.now().subtract(const Duration(hours: 5));

        when(mockRepository.getLastDrinkTime())
            .thenAnswer((_) async => lastDrinkTime);
        when(mockRepository.getAvatar()).thenAnswer((_) async => null);
        when(mockRepository.updateAvatarState(any))
            .thenAnswer((_) async => {});

        // Act
        final result = await useCase.execute();

        // Assert - Vérifie que le calcul est correct (5h = Dehydrated)
        expect(result, AvatarState.dehydrated);
      });

      test('Retourne Fresh par défaut si aucun lastDrinkTime', () async {
        // Arrange - Pas de lastDrinkTime (premier lancement)
        when(mockRepository.getLastDrinkTime()).thenAnswer((_) async => null);

        // Act
        final result = await useCase.execute();

        // Assert
        expect(result, AvatarState.fresh);
        verifyNever(mockRepository.updateAvatarState(any));
      });
    });

    group('AC #5 - Mise à jour dans le repository', () {
      test('Met à jour le repository après calcul si état changé', () async {
        // Arrange
        final now = DateTime.now();
        final lastDrinkTime = now.subtract(const Duration(hours: 3));
        final currentAvatar = Avatar(
          id: 'avatar_singleton',
          name: 'Docteur',
          personality: AvatarPersonality.doctor,
          currentState: AvatarState.fresh,
          lastDrinkTime: lastDrinkTime,
          lastUpdated: now,
        );

        when(mockRepository.getLastDrinkTime())
            .thenAnswer((_) async => lastDrinkTime);
        when(mockRepository.getAvatar()).thenAnswer((_) async => currentAvatar);
        when(mockRepository.updateAvatarState(AvatarState.tired))
            .thenAnswer((_) async => {});

        // Act
        await useCase.execute();

        // Assert - Vérifie que updateAvatarState a été appelé
        verify(mockRepository.updateAvatarState(AvatarState.tired)).called(1);
      });

      test('Ne met pas à jour le repository si état inchangé', () async {
        // Arrange
        final now = DateTime.now();
        final lastDrinkTime = now.subtract(const Duration(hours: 1));
        final currentAvatar = Avatar(
          id: 'avatar_singleton',
          name: 'Docteur',
          personality: AvatarPersonality.doctor,
          currentState: AvatarState.fresh,
          lastDrinkTime: lastDrinkTime,
          lastUpdated: now,
        );

        when(mockRepository.getLastDrinkTime())
            .thenAnswer((_) async => lastDrinkTime);
        when(mockRepository.getAvatar()).thenAnswer((_) async => currentAvatar);

        // Act
        await useCase.execute();

        // Assert - Vérifie que updateAvatarState n'a PAS été appelé
        verifyNever(mockRepository.updateAvatarState(any));
      });
    });

    group('Gestion des erreurs', () {
      test('Propage StorageException si getLastDrinkTime échoue', () async {
        // Arrange
        when(mockRepository.getLastDrinkTime())
            .thenThrow(StorageException('Database error'));

        // Act & Assert
        expect(
          () => useCase.execute(),
          throwsA(isA<StorageException>()),
        );
      });

      test('Propage StorageException si updateAvatarState échoue', () async {
        // Arrange
        final now = DateTime.now();
        final lastDrinkTime = now.subtract(const Duration(hours: 3));
        final currentAvatar = Avatar(
          id: 'avatar_singleton',
          name: 'Docteur',
          personality: AvatarPersonality.doctor,
          currentState: AvatarState.fresh,
          lastDrinkTime: lastDrinkTime,
          lastUpdated: now,
        );

        when(mockRepository.getLastDrinkTime())
            .thenAnswer((_) async => lastDrinkTime);
        when(mockRepository.getAvatar()).thenAnswer((_) async => currentAvatar);
        when(mockRepository.updateAvatarState(any))
            .thenThrow(StorageException('Update failed'));

        // Act & Assert
        expect(
          () => useCase.execute(),
          throwsA(isA<StorageException>()),
        );
      });
    });

    group('Constantes de seuil', () {
      test('Constantes définies correctement selon AC #2', () {
        // Assert
        expect(UpdateAvatarStateUseCase.kFreshToTired, 2);
        expect(UpdateAvatarStateUseCase.kTiredToDehydrated, 4);
        expect(UpdateAvatarStateUseCase.kDehydratedToDead, 6);
      });
    });
  });
}
