import 'dart:async';

import '../../domain/use_cases/avatar/update_avatar_state_use_case.dart';

/// Service gérant le timer de déshydratation en background
///
/// Ce service exécute périodiquement (toutes les 30 minutes) le use case
/// [UpdateAvatarStateUseCase] pour mettre à jour l'état de l'avatar basé
/// sur le temps écoulé depuis la dernière hydratation.
///
/// Le timer doit être:
/// - Démarré à l'ouverture de l'application
/// - Annulé proprement lors de la fermeture (dispose())
///
/// Usage:
/// ```dart
/// final service = DehydrationTimerService(updateAvatarStateUseCase);
/// service.start(); // Démarre le timer periodic
///
/// // Plus tard, lors du dispose de l'app
/// service.dispose(); // Annule le timer et libère les ressources
/// ```
class DehydrationTimerService {
  final UpdateAvatarStateUseCase _updateAvatarStateUseCase;

  /// Intervalle de mise à jour (30 minutes)
  static const Duration kUpdateInterval = Duration(minutes: 30);

  /// Timer periodic interne
  Timer? _timer;

  /// Indique si le service est actuellement actif
  bool get isRunning => _timer != null && _timer!.isActive;

  DehydrationTimerService(this._updateAvatarStateUseCase);

  /// Démarre le timer periodic de déshydratation
  ///
  /// Exécute immédiatement une première mise à jour, puis périodiquement
  /// toutes les 30 minutes.
  ///
  /// Si le timer est déjà démarré, cette méthode ne fait rien (idempotent).
  void start() {
    // Si le timer est déjà actif, ne pas en créer un nouveau
    if (isRunning) {
      print('[DehydrationTimer] Timer déjà actif - pas de redémarrage');
      return;
    }

    print('[DehydrationTimer] Démarrage du timer (intervalle: ${kUpdateInterval.inMinutes}min)');

    // Exécuter une première mise à jour immédiatement
    _updateAvatarState();

    // Créer le timer periodic
    _timer = Timer.periodic(kUpdateInterval, (timer) {
      _updateAvatarState();
    });
  }

  /// Arrête le timer periodic et libère les ressources
  ///
  /// Cette méthode doit être appelée lors du dispose de l'application
  /// pour éviter les memory leaks.
  ///
  /// Après dispose(), le service peut être redémarré avec start().
  void dispose() {
    if (_timer != null) {
      print('[DehydrationTimer] Arrêt du timer');
      _timer!.cancel();
      _timer = null;
    }
  }

  /// Exécute une mise à jour de l'état de l'avatar
  ///
  /// Appelle le use case et log les erreurs éventuelles.
  /// Les erreurs ne font pas crasher l'app - elles sont simplement loggées.
  Future<void> _updateAvatarState() async {
    try {
      print('[DehydrationTimer] Exécution de la mise à jour de l\'état avatar');
      final newState = await _updateAvatarStateUseCase.execute();
      print('[DehydrationTimer] État avatar mis à jour: $newState');
    } catch (e) {
      // Log l'erreur mais ne fait pas crasher l'app
      print('[DehydrationTimer] Erreur lors de la mise à jour: $e');
    }
  }

  /// Force une mise à jour manuelle de l'état
  ///
  /// Utile pour forcer une mise à jour en dehors du cycle periodic
  /// (par exemple, à l'ouverture de l'application).
  Future<void> forceUpdate() async {
    print('[DehydrationTimer] Mise à jour forcée demandée');
    await _updateAvatarState();
  }
}
