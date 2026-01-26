import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../domain/use_cases/avatar/check_and_resurrect_avatar_use_case.dart';

/// Service gérant la résurrection automatique de l'avatar à minuit
///
/// Ce service vérifie toutes les minutes si l'heure est 00h00 (minuit).
/// Lorsque minuit est détecté, il appelle [CheckAndResurrectAvatarUseCase]
/// pour ressusciter l'avatar s'il est en état ghost.
///
/// Le timer doit être:
/// - Démarré à l'ouverture de l'application
/// - Annulé proprement lors de la fermeture (dispose())
///
/// Logique de détection minuit:
/// - Vérifie si hour == 0 ET minute == 0
/// - Utilise un flag pour éviter de ressusciter plusieurs fois pendant la même minute
/// - Réinitialise le flag quand l'heure change (hour != 0)
///
/// Usage:
/// ```dart
/// final service = ResurrectionTimerService(checkAndResurrectAvatarUseCase);
/// service.start(); // Démarre le timer
///
/// // Plus tard, lors du dispose de l'app
/// service.dispose(); // Annule le timer
/// ```
class ResurrectionTimerService {
  final CheckAndResurrectAvatarUseCase _checkAndResurrectAvatarUseCase;

  /// Intervalle de vérification (1 minute)
  static const Duration kCheckInterval = Duration(minutes: 1);

  /// Timer periodic interne
  Timer? _timer;

  /// Flag pour éviter de ressusciter plusieurs fois dans la même minute
  bool _hasResurrectedToday = false;

  /// Indique si le service est actuellement actif
  bool get isRunning => _timer != null && _timer!.isActive;

  ResurrectionTimerService(this._checkAndResurrectAvatarUseCase);

  /// Démarre le timer periodic de résurrection
  ///
  /// Vérifie toutes les minutes si c'est minuit (00h00).
  /// Si minuit détecté → appelle use case résurrection.
  ///
  /// Si le timer est déjà démarré, cette méthode ne fait rien (idempotent).
  void start() {
    // Si le timer est déjà actif, ne pas en créer un nouveau
    if (isRunning) {
      if (kDebugMode) {
        debugPrint('[ResurrectionTimer] Timer déjà actif - pas de redémarrage');
      }
      return;
    }

    if (kDebugMode) {
      debugPrint(
        '[ResurrectionTimer] Démarrage du timer (vérification toutes les ${kCheckInterval.inMinutes} minute)',
      );
    }

    // Vérifier immédiatement au démarrage (cas rare: app ouverte à minuit)
    _checkForMidnightResurrection();

    // Créer le timer periodic
    _timer = Timer.periodic(kCheckInterval, (timer) {
      _checkForMidnightResurrection();
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
      if (kDebugMode) {
        debugPrint('[ResurrectionTimer] Arrêt du timer');
      }
      _timer!.cancel();
      _timer = null;
    }
  }

  /// Vérifie si c'est minuit et déclenche la résurrection si nécessaire
  ///
  /// Logique:
  /// - Si hour == 0 ET minute == 0 → minuit détecté
  /// - Si pas encore ressuscité aujourd'hui → appeler use case
  /// - Si hour != 0 → reset flag (nouvelle journée)
  Future<void> _checkForMidnightResurrection() async {
    final now = DateTime.now();
    final currentHour = now.hour;
    final currentMinute = now.minute;

    // Reset du flag si on a quitté la fenêtre minuit (hour != 0)
    if (currentHour != 0 && _hasResurrectedToday) {
      if (kDebugMode) {
        debugPrint(
          '[ResurrectionTimer] Nouvelle journée - Reset flag résurrection',
        );
      }
      _hasResurrectedToday = false;
    }

    // Vérifier si c'est minuit (00h00)
    if (currentHour == 0 && currentMinute == 0) {
      // Éviter de ressusciter plusieurs fois dans la même minute
      if (_hasResurrectedToday) {
        if (kDebugMode) {
          debugPrint(
            '[ResurrectionTimer] Minuit détecté mais déjà ressuscité - Skip',
          );
        }
        return;
      }

      if (kDebugMode) {
        debugPrint(
          '[ResurrectionTimer] 🌙 Minuit détecté! Tentative de résurrection...',
        );
      }

      try {
        final wasResurrected = await _checkAndResurrectAvatarUseCase.execute();
        if (wasResurrected) {
          if (kDebugMode) {
            debugPrint('[ResurrectionTimer] ✨ Avatar ressuscité avec succès!');
          }
          _hasResurrectedToday = true;
        } else {
          if (kDebugMode) {
            debugPrint(
              '[ResurrectionTimer] Avatar pas en état ghost - Pas de résurrection',
            );
          }
        }
      } catch (e) {
        // Log l'erreur mais ne fait pas crasher l'app
        if (kDebugMode) {
          debugPrint('[ResurrectionTimer] Erreur lors de la résurrection: $e');
        }
      }
    }
  }

  /// Force une vérification manuelle de résurrection
  ///
  /// Utile pour tester ou forcer une résurrection en dehors du cycle periodic.
  /// Ignore le flag _hasResurrectedToday (permet de forcer).
  Future<void> forceResurrectionCheck() async {
    if (kDebugMode) {
      debugPrint('[ResurrectionTimer] Vérification forcée demandée');
    }
    _hasResurrectedToday = false; // Reset flag pour autoriser résurrection
    await _checkForMidnightResurrection();
  }
}
