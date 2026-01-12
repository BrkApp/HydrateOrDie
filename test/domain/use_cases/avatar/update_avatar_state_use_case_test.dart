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
        when(mockRepository.getAvatar()).thenAnswer((_) async => null);
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
        when(mockRepository.getAvatar()).thenAnswer((_) async => null);
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

    group('Story 1.7 - Transition Dead → Ghost (AC #2)', () {
      test('AC #2 - Dead reste dead si < 10 secondes écoulées', () async {
        // Arrange - Avatar dead depuis seulement 5 secondes
        final now = DateTime.now();
        final lastDrinkTime = now.subtract(const Duration(hours: 7));
        final deathTime = now.subtract(const Duration(seconds: 5));

        final currentAvatar = Avatar(
          id: 'avatar_singleton',
          name: 'Docteur',
          personality: AvatarPersonality.doctor,
          currentState: AvatarState.dead,
          lastDrinkTime: lastDrinkTime,
          lastUpdated: now,
        );

        when(mockRepository.getAvatar()).thenAnswer((_) async => currentAvatar);
        when(mockRepository.getDeathTime()).thenAnswer((_) async => deathTime);

        // Act
        final result = await useCase.execute();

        // Assert
        expect(result, AvatarState.dead);
        verifyNever(mockRepository.updateAvatarState(any));
      });

      test('AC #2 - Dead → Ghost après exactement 10 secondes', () async {
        // Arrange - Avatar dead depuis exactement 10 secondes
        final now = DateTime.now();
        final lastDrinkTime = now.subtract(const Duration(hours: 7));
        final deathTime = now.subtract(const Duration(seconds: 10));

        final currentAvatar = Avatar(
          id: 'avatar_singleton',
          name: 'Coach',
          personality: AvatarPersonality.sportsCoach,
          currentState: AvatarState.dead,
          lastDrinkTime: lastDrinkTime,
          lastUpdated: now,
        );

        when(mockRepository.getAvatar()).thenAnswer((_) async => currentAvatar);
        when(mockRepository.getDeathTime()).thenAnswer((_) async => deathTime);
        when(mockRepository.updateAvatarState(AvatarState.ghost))
            .thenAnswer((_) async => {});

        // Act
        final result = await useCase.execute();

        // Assert
        expect(result, AvatarState.ghost);
        verify(mockRepository.updateAvatarState(AvatarState.ghost)).called(1);
      });

      test('AC #2 - Dead → Ghost après 15 secondes', () async {
        // Arrange - Avatar dead depuis 15 secondes
        final now = DateTime.now();
        final lastDrinkTime = now.subtract(const Duration(hours: 7));
        final deathTime = now.subtract(const Duration(seconds: 15));

        final currentAvatar = Avatar(
          id: 'avatar_singleton',
          name: 'Maman',
          personality: AvatarPersonality.authoritarianMother,
          currentState: AvatarState.dead,
          lastDrinkTime: lastDrinkTime,
          lastUpdated: now,
        );

        when(mockRepository.getAvatar()).thenAnswer((_) async => currentAvatar);
        when(mockRepository.getDeathTime()).thenAnswer((_) async => deathTime);
        when(mockRepository.updateAvatarState(AvatarState.ghost))
            .thenAnswer((_) async => {});

        // Act
        final result = await useCase.execute();

        // Assert
        expect(result, AvatarState.ghost);
        verify(mockRepository.updateAvatarState(AvatarState.ghost)).called(1);
      });

      test('AC #2 - Ghost reste ghost (pas de régression)', () async {
        // Arrange - Avatar déjà en état ghost
        final now = DateTime.now();
        final lastDrinkTime = now.subtract(const Duration(hours: 8));

        final currentAvatar = Avatar(
          id: 'avatar_singleton',
          name: 'Ami',
          personality: AvatarPersonality.sarcasticFriend,
          currentState: AvatarState.ghost,
          lastDrinkTime: lastDrinkTime,
          lastUpdated: now,
        );

        when(mockRepository.getAvatar()).thenAnswer((_) async => currentAvatar);

        // Act
        final result = await useCase.execute();

        // Assert
        expect(result, AvatarState.ghost);
        // Ghost doit rester ghost jusqu'à résurrection à minuit
        verifyNever(mockRepository.updateAvatarState(any));
      });

      test('AC #2 - Transition vers dead enregistre deathTime', () async {
        // Arrange - Transition fresh → dead (7h+ sans boire)
        final now = DateTime.now();
        final lastDrinkTime = now.subtract(const Duration(hours: 7));

        final currentAvatar = Avatar(
          id: 'avatar_singleton',
          name: 'Docteur',
          personality: AvatarPersonality.doctor,
          currentState: AvatarState.dehydrated,
          lastDrinkTime: lastDrinkTime,
          lastUpdated: now,
        );

        when(mockRepository.getAvatar()).thenAnswer((_) async => currentAvatar);
        when(mockRepository.getLastDrinkTime())
            .thenAnswer((_) async => lastDrinkTime);
        when(mockRepository.updateAvatarState(AvatarState.dead))
            .thenAnswer((_) async => {});
        when(mockRepository.updateDeathTime(any)).thenAnswer((_) async => {});

        // Act
        final result = await useCase.execute();

        // Assert
        expect(result, AvatarState.dead);
        verify(mockRepository.updateAvatarState(AvatarState.dead)).called(1);
        verify(mockRepository.updateDeathTime(any)).called(1);
      });

      test('AC #2 - Dead sans deathTime reste dead (edge case)', () async {
        // Arrange - Avatar dead mais deathTime null (données corrompues?)
        final now = DateTime.now();
        final lastDrinkTime = now.subtract(const Duration(hours: 7));

        final currentAvatar = Avatar(
          id: 'avatar_singleton',
          name: 'Coach',
          personality: AvatarPersonality.sportsCoach,
          currentState: AvatarState.dead,
          lastDrinkTime: lastDrinkTime,
          lastUpdated: now,
        );

        when(mockRepository.getAvatar()).thenAnswer((_) async => currentAvatar);
        when(mockRepository.getDeathTime())
            .thenAnswer((_) async => null); // Pas de deathTime
        when(mockRepository.getLastDrinkTime())
            .thenAnswer((_) async => lastDrinkTime);

        // Act
        final result = await useCase.execute();

        // Assert
        expect(result, AvatarState.dead);
        // Pas de transition vers ghost si deathTime manquant
        verifyNever(mockRepository.updateAvatarState(any));
      });
    });

    group('Constantes de seuil', () {
      test('Constantes définies correctement selon AC #2', () {
        // Assert
        expect(UpdateAvatarStateUseCase.kFreshToTired, 2);
        expect(UpdateAvatarStateUseCase.kTiredToDehydrated, 4);
        expect(UpdateAvatarStateUseCase.kDehydratedToDead, 6);
      });

      test('Story 1.7 - Constante kDeadToGhostDelay définie', () {
        // Assert
        expect(
            UpdateAvatarStateUseCase.kDeadToGhostDelay, const Duration(seconds: 10));
      });
    });
  });
}
