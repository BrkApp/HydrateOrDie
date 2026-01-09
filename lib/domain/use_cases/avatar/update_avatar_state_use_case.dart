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

  /// Seuils de transition en heures
  static const int kFreshToTired = 2;
  static const int kTiredToDehydrated = 4;
  static const int kDehydratedToDead = 6;

  UpdateAvatarStateUseCase(this._avatarRepository);

  /// Calcule et met à jour l'état de l'avatar basé sur le temps écoulé
  ///
  /// Retourne le nouvel état après calcul et mise à jour.
  /// Si aucun `lastDrinkTime` n'existe, retourne [AvatarState.fresh] par défaut.
  ///
  /// Throws [StorageException] si la mise à jour échoue.
  Future<AvatarState> execute() async {
    try {
      // 1. Récupérer le timestamp du dernier verre
      final lastDrinkTime = await _avatarRepository.getLastDrinkTime();

      // Si pas de lastDrinkTime, considérer l'avatar comme Fresh par défaut
      if (lastDrinkTime == null) {
        print('[UpdateAvatarState] Aucun lastDrinkTime trouvé - État par défaut: fresh');
        return AvatarState.fresh;
      }

      // 2. Calculer le temps écoulé depuis le dernier verre
      final now = DateTime.now();
      final elapsed = now.difference(lastDrinkTime);

      // 3. Calculer le nouvel état basé sur le temps écoulé
      final newState = _calculateState(elapsed);

      // 4. Récupérer l'état actuel pour comparer
      final currentAvatar = await _avatarRepository.getAvatar();
      final currentState = currentAvatar?.currentState ?? AvatarState.fresh;

      // 5. Mettre à jour si l'état a changé
      if (currentState != newState) {
        await _avatarRepository.updateAvatarState(newState);
        print('[UpdateAvatarState] Transition: $currentState → $newState (${elapsed.inHours}h depuis dernier verre)');
      } else {
        print('[UpdateAvatarState] État inchangé: $currentState (${elapsed.inHours}h depuis dernier verre)');
      }

      return newState;
    } catch (e) {
      print('[UpdateAvatarState] Erreur lors de la mise à jour: $e');
      rethrow;
    }
  }

  /// Calcule l'état de l'avatar basé sur le temps écoulé depuis le dernier verre
  ///
  /// Règles de transition:
  /// - 0-2h: Fresh (😊)
  /// - 2-4h: Tired (😐)
  /// - 4-6h: Dehydrated (😟)
  /// - 6h+: Dead (💀)
  ///
  /// [timeSinceLastDrink] Durée écoulée depuis le dernier verre validé
  /// Retourne le nouvel [AvatarState] correspondant
  AvatarState _calculateState(Duration timeSinceLastDrink) {
    final hours = timeSinceLastDrink.inHours;

    if (hours < kFreshToTired) {
      return AvatarState.fresh;
    } else if (hours < kTiredToDehydrated) {
      return AvatarState.tired;
    } else if (hours < kDehydratedToDead) {
      return AvatarState.dehydrated;
    } else {
      return AvatarState.dead;
    }
  }
}
