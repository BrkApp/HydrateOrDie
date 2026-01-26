import 'package:flutter/foundation.dart';

import '../../entities/avatar_state.dart';
import '../../repositories/avatar_repository.dart';

/// Use case pour vérifier et ressusciter l'avatar à minuit
///
/// Gère la résurrection automatique de l'avatar lorsqu'il est en état ghost:
/// - Vérifie si l'état actuel est ghost
/// - Si ghost → transition vers fresh
/// - Réinitialise lastDrinkTime à DateTime.now()
/// - Efface deathTime
///
/// Ce use case est appelé:
/// - Automatiquement à minuit (00h00) par ResurrectionTimerService
/// - Peut être appelé manuellement pour tester la résurrection
///
/// Example:
/// ```dart
/// final useCase = CheckAndResurrectAvatarUseCase(avatarRepository);
/// final wasResurrected = await useCase.execute();
/// if (wasResurrected) {
///   print('Avatar ressuscité! 🎉');
/// }
/// ```
class CheckAndResurrectAvatarUseCase {
  final AvatarRepository _avatarRepository;

  CheckAndResurrectAvatarUseCase(this._avatarRepository);

  /// Vérifie l'état de l'avatar et le ressuscite si ghost
  ///
  /// Retourne `true` si l'avatar a été ressuscité (ghost → fresh).
  /// Retourne `false` si l'avatar n'était pas ghost (aucune action).
  ///
  /// En cas de résurrection:
  /// - État passe à fresh
  /// - lastDrinkTime réinitialisé à maintenant
  /// - deathTime effacé (set à null)
  ///
  /// Throws [StorageException] si la mise à jour échoue.
  Future<bool> execute() async {
    try {
      // 1. Récupérer l'état actuel de l'avatar
      final currentAvatar = await _avatarRepository.getAvatar();
      final currentState = currentAvatar?.currentState;

      // 2. Vérifier si l'avatar est en état ghost
      if (currentState != AvatarState.ghost) {
        if (kDebugMode) {
          debugPrint(
            '[CheckAndResurrect] Avatar not ghost (état: $currentState) - Aucune résurrection',
          );
        }
        return false;
      }

      // 3. Ressusciter l'avatar: ghost → fresh
      final now = DateTime.now();

      // 3a. Mettre à jour l'état vers fresh
      await _avatarRepository.updateAvatarState(AvatarState.fresh);

      // 3b. Réinitialiser lastDrinkTime à maintenant
      await _avatarRepository.updateLastDrinkTime(now);

      // 3c. Effacer deathTime
      await _avatarRepository.updateDeathTime(null);

      if (kDebugMode) {
        debugPrint(
          '[CheckAndResurrect] ✨ Résurrection réussie! ghost → fresh (lastDrinkTime: $now)',
        );
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[CheckAndResurrect] Erreur lors de la résurrection: $e');
      }
      rethrow;
    }
  }
}
