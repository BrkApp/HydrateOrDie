import 'package:flutter/foundation.dart';

import '../../entities/avatar_state.dart';
import '../../repositories/avatar_repository.dart';

/// Use case pour mettre à jour l'état de l'avatar basé sur le temps écoulé depuis la dernière hydratation
///
/// Calcule l'état actuel de déshydratation de l'avatar en fonction du temps écoulé
/// depuis le dernier verre validé (`lastDrinkTime`). La progression suit:
/// - Fresh (0-2h depuis last drink)
/// - Tired (2-4h depuis last drink)
/// - Dehydrated (4-6h depuis last drink)
/// - Dead (6h+ depuis last drink)
///
/// Ce use case est appelé:
/// - Automatiquement à l'ouverture de l'application
/// - Périodiquement en background (toutes les 30 minutes via timer)
///
/// Les transitions d'état sont loggées pour faciliter le debug.
///
/// Example:
/// ```dart
/// final useCase = UpdateAvatarStateUseCase(avatarRepository);
/// final newState = await useCase.execute();
/// print('État avatar mis à jour: $newState');
/// ```
class UpdateAvatarStateUseCase {
  final AvatarRepository _avatarRepository;

  /// Seuils de transition (en heures pour prod, en minutes pour tests Epic 1)
  /// TODO Epic 1: Remettre en heures après validation (2h/4h/6h)
  static const int kFreshToTired = 2; // minutes pour tests (sera 2h en prod)
  static const int kTiredToDehydrated = 4; // minutes pour tests (sera 4h en prod)
  static const int kDehydratedToDead = 6; // minutes pour tests (sera 6h en prod)

  /// Durée après laquelle dead → ghost (10 secondes)
  static const Duration kDeadToGhostDelay = Duration(seconds: 10);

  UpdateAvatarStateUseCase(this._avatarRepository);

  /// Calcule et met à jour l'état de l'avatar basé sur le temps écoulé
  ///
  /// Gère les transitions suivantes:
  /// - Fresh → Tired → Dehydrated → Dead (basé sur lastDrinkTime)
  /// - Dead → Ghost après 10 secondes (basé sur deathTime)
  /// - Ghost reste Ghost jusqu'à résurrection à minuit
  ///
  /// Retourne le nouvel état après calcul et mise à jour.
  /// Si aucun `lastDrinkTime` n'existe, retourne [AvatarState.fresh] par défaut.
  ///
  /// Throws [StorageException] si la mise à jour échoue.
  Future<AvatarState> execute() async {
    try {
      // 1. Récupérer l'état actuel
      final currentAvatar = await _avatarRepository.getAvatar();
      final currentState = currentAvatar?.currentState ?? AvatarState.fresh;

      // 2. Si déjà ghost, rester ghost (résurrection gérée par CheckAndResurrectAvatarUseCase)
      if (currentState == AvatarState.ghost) {
        if (kDebugMode) {
          debugPrint('[UpdateAvatarState] État ghost - Aucune mise à jour (résurrection à minuit)');
        }
        return AvatarState.ghost;
      }

      // 3. Vérifier transition dead → ghost (après 10 secondes)
      if (currentState == AvatarState.dead) {
        final deathTime = await _avatarRepository.getDeathTime();
        if (deathTime != null) {
          final now = DateTime.now();
          final timeSinceDeath = now.difference(deathTime);

          if (timeSinceDeath >= kDeadToGhostDelay) {
            // Transition dead → ghost
            await _avatarRepository.updateAvatarState(AvatarState.ghost);
            if (kDebugMode) {
              debugPrint('[UpdateAvatarState] Transition: dead → ghost (${timeSinceDeath.inSeconds}s depuis mort)');
            }
            return AvatarState.ghost;
          } else {
            // Encore en dead, pas assez de temps écoulé
            if (kDebugMode) {
              debugPrint('[UpdateAvatarState] État dead - ${kDeadToGhostDelay.inSeconds - timeSinceDeath.inSeconds}s avant transition ghost');
            }
            return AvatarState.dead;
          }
        }
      }

      // 4. Récupérer le timestamp du dernier verre
      final lastDrinkTime = await _avatarRepository.getLastDrinkTime();

      // Si pas de lastDrinkTime, considérer l'avatar comme Fresh par défaut
      if (lastDrinkTime == null) {
        if (kDebugMode) {
          debugPrint('[UpdateAvatarState] Aucun lastDrinkTime trouvé - État par défaut: fresh');
        }
        return AvatarState.fresh;
      }

      // 5. Calculer le temps écoulé depuis le dernier verre
      final now = DateTime.now();
      final elapsed = now.difference(lastDrinkTime);

      // 6. Calculer le nouvel état basé sur le temps écoulé
      final newState = _calculateState(elapsed);

      // 7. Mettre à jour si l'état a changé
      if (currentState != newState) {
        await _avatarRepository.updateAvatarState(newState);
        if (kDebugMode) {
          debugPrint('[UpdateAvatarState] Transition: $currentState → $newState (${elapsed.inMinutes}min depuis dernier verre)');
        }

        // Si transition vers dead, enregistrer le deathTime
        if (newState == AvatarState.dead) {
          await _avatarRepository.updateDeathTime(now);
          if (kDebugMode) {
            debugPrint('[UpdateAvatarState] Death time enregistré: $now');
          }
        }
      } else {
        if (kDebugMode) {
          debugPrint('[UpdateAvatarState] État inchangé: $currentState (${elapsed.inMinutes}min depuis dernier verre)');
        }
      }

      return newState;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[UpdateAvatarState] Erreur lors de la mise à jour: $e');
      }
      rethrow;
    }
  }

  /// Calcule l'état de l'avatar basé sur le temps écoulé depuis le dernier verre
  ///
  /// Règles de transition (TEMP pour tests Epic 1 - en MINUTES):
  /// - 0-2min: Fresh (😊) [sera 0-2h en prod]
  /// - 2-4min: Tired (😐) [sera 2-4h en prod]
  /// - 4-6min: Dehydrated (😟) [sera 4-6h en prod]
  /// - 6min+: Dead (💀) [sera 6h+ en prod]
  ///
  /// [timeSinceLastDrink] Durée écoulée depuis le dernier verre validé
  /// Retourne le nouvel [AvatarState] correspondant
  AvatarState _calculateState(Duration timeSinceLastDrink) {
    // TEMP: Utiliser minutes au lieu d'heures pour tests Epic 1
    final minutes = timeSinceLastDrink.inMinutes;

    if (minutes < kFreshToTired) {
      return AvatarState.fresh;
    } else if (minutes < kTiredToDehydrated) {
      return AvatarState.tired;
    } else if (minutes < kDehydratedToDead) {
      return AvatarState.dehydrated;
    } else {
      return AvatarState.dead;
    }
  }
}
