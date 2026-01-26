import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../entities/glass_size.dart';
import '../../entities/hydration_log.dart';
import '../../repositories/avatar_repository.dart' as avatar_repo;
import '../../repositories/hydration_log_repository.dart';
import '../../repositories/user_repository.dart' as user_repo;
import '../avatar/update_avatar_state_use_case.dart';

/// Use case pour enregistrer une validation d'hydratation
///
/// Responsabilités:
/// 1. Créer et sauvegarder un HydrationLog
/// 2. Mettre à jour lastDrinkTime de l'avatar
/// 3. Recalculer l'état de l'avatar (fresh/tired/dehydrated/dead)
/// 4. Calculer le volume total du jour
/// 5. Calculer la progression vers l'objectif quotidien
/// 6. Logger l'événement analytics (si Firebase disponible)
///
/// Story 3.6 - Record Hydration
class RecordHydrationUseCase {
  final HydrationLogRepository _hydrationLogRepository;
  final avatar_repo.AvatarRepository _avatarRepository;
  final user_repo.UserRepository _userRepository;
  final UpdateAvatarStateUseCase _updateAvatarStateUseCase;

  RecordHydrationUseCase(
    this._hydrationLogRepository,
    this._avatarRepository,
    this._userRepository,
    this._updateAvatarStateUseCase,
  );

  /// Enregistre une validation d'hydratation
  ///
  /// [photoPath] Chemin de la photo capturée
  /// [glassSize] Taille du verre sélectionnée
  ///
  /// Returns [RecordHydrationResult] avec les données de progression
  ///
  /// Throws [RecordHydrationException] si l'enregistrement échoue
  Future<RecordHydrationResult> call({
    required String photoPath,
    required GlassSize glassSize,
  }) async {
    try {
      final now = DateTime.now();

      // Étape 1: Créer le HydrationLog
      final log = HydrationLog(
        id: const Uuid().v4(),
        timestamp: now,
        photoPath: photoPath,
        glassSize: glassSize,
        validated: true,
      );

      if (kDebugMode) {
        debugPrint(
          '[RecordHydration] Création log: ${log.id} (${glassSize.displayName})',
        );
      }

      // Étape 2: Sauvegarder le log
      await _hydrationLogRepository.addLog(log);

      if (kDebugMode) {
        debugPrint('[RecordHydration] Log sauvegardé avec succès');
      }

      // Étape 3: Mettre à jour lastDrinkTime de l'avatar
      await _avatarRepository.updateLastDrinkTime(now);

      if (kDebugMode) {
        debugPrint('[RecordHydration] lastDrinkTime mis à jour: $now');
      }

      // Étape 4: Recalculer l'état de l'avatar
      final newAvatarState = await _updateAvatarStateUseCase.execute();

      if (kDebugMode) {
        debugPrint('[RecordHydration] État avatar recalculé: $newAvatarState');
      }

      // Étape 5: Récupérer le volume total du jour
      final totalVolumeToday = await _hydrationLogRepository
          .getTotalVolumeForDate(now);

      if (kDebugMode) {
        debugPrint(
          '[RecordHydration] Volume total aujourd\'hui: ${totalVolumeToday}L',
        );
      }

      // Étape 6: Récupérer l'objectif quotidien de l'utilisateur
      final user = await _userRepository.getProfile();
      if (user == null) {
        throw RecordHydrationException(
          'Profil utilisateur introuvable. L\'onboarding doit être complété.',
        );
      }

      final dailyGoalLiters = user.dailyGoal.targetLiters;

      // Étape 7: Calculer la progression (plafonnée à 100%)
      final progressPercentage = _calculateProgressPercentage(
        totalVolumeToday,
        dailyGoalLiters,
      );

      if (kDebugMode) {
        debugPrint(
          '[RecordHydration] Progression: ${(progressPercentage * 100).toStringAsFixed(1)}%',
        );
      }

      // Étape 8: Logger analytics event (graceful degradation si Firebase indisponible)
      await _logAnalyticsEvent(timestamp: now, glassSize: glassSize);

      // Retourner le résultat avec toutes les données
      return RecordHydrationResult(
        log: log,
        totalVolumeToday: totalVolumeToday,
        dailyGoalLiters: dailyGoalLiters,
        progressPercentage: progressPercentage,
        avatarState: newAvatarState,
      );
    } on StorageException catch (e) {
      // Erreur de persistence (StorageException depuis hydration_log_repository)
      if (kDebugMode) {
        debugPrint('[RecordHydration] Erreur storage: ${e.message}');
      }
      throw RecordHydrationException(
        'Impossible de sauvegarder ton hydratation. Vérifie ton espace de stockage.',
        originalException: e,
      );
    } on avatar_repo.StorageException catch (e) {
      // Erreur de persistence avatar
      if (kDebugMode) {
        debugPrint('[RecordHydration] Erreur storage avatar: ${e.message}');
      }
      throw RecordHydrationException(
        'Impossible de mettre à jour l\'avatar. Vérifie ton espace de stockage.',
        originalException: e,
      );
    } on user_repo.StorageException catch (e) {
      // Erreur de persistence utilisateur
      if (kDebugMode) {
        debugPrint(
          '[RecordHydration] Erreur storage utilisateur: ${e.message}',
        );
      }
      throw RecordHydrationException(
        'Impossible de charger ton profil. Vérifie ton espace de stockage.',
        originalException: e,
      );
    } catch (e) {
      // Autres erreurs
      if (kDebugMode) {
        debugPrint('[RecordHydration] Erreur inattendue: $e');
      }
      throw RecordHydrationException(
        'Erreur lors de l\'enregistrement de l\'hydratation: ${e.toString()}',
        originalException: e,
      );
    }
  }

  /// Calcule la progression vers l'objectif quotidien
  ///
  /// [volumeToday] Volume total consommé aujourd'hui en litres
  /// [dailyGoal] Objectif quotidien en litres
  ///
  /// Returns progression en pourcentage (0.0 à 1.0), plafonnée à 1.0 max
  double _calculateProgressPercentage(double volumeToday, double dailyGoal) {
    if (dailyGoal == 0) return 0.0;

    final rawProgress = volumeToday / dailyGoal;

    // Plafonner à 100% (1.0)
    return rawProgress > 1.0 ? 1.0 : rawProgress;
  }

  /// Log un événement analytics (graceful degradation)
  ///
  /// Tente de logger l'événement Firebase Analytics.
  /// Si Firebase n'est pas disponible ou configuré (mock),
  /// l'erreur est ignorée silencieusement.
  ///
  /// [timestamp] Timestamp de la validation
  /// [glassSize] Taille du verre sélectionnée
  Future<void> _logAnalyticsEvent({
    required DateTime timestamp,
    required GlassSize glassSize,
  }) async {
    try {
      // TODO: Implémenter Firebase Analytics quand disponible
      // await FirebaseAnalytics.instance.logEvent(
      //   name: 'hydration_validated',
      //   parameters: {
      //     'timestamp': timestamp.toIso8601String(),
      //     'glass_size': glassSize.name,
      //     'volume_ml': (glassSize.volumeLiters * 1000).toInt(),
      //   },
      // );

      if (kDebugMode) {
        debugPrint(
          '[RecordHydration] Analytics event loggé: hydration_validated (${glassSize.name})',
        );
      }
    } catch (e) {
      // Graceful degradation: Firebase non disponible ou mock
      if (kDebugMode) {
        debugPrint(
          '[RecordHydration] Analytics skipped - Firebase not available: $e',
        );
      }
      // Ne pas rethrow - l'analytics est optionnel
    }
  }
}

/// Résultat de l'enregistrement d'hydratation
///
/// Contient toutes les données calculées après l'enregistrement
class RecordHydrationResult {
  /// Le log créé
  final HydrationLog log;

  /// Volume total consommé aujourd'hui (en litres)
  final double totalVolumeToday;

  /// Objectif quotidien (en litres)
  final double dailyGoalLiters;

  /// Progression vers l'objectif (0.0 à 1.0)
  final double progressPercentage;

  /// Nouvel état de l'avatar après recalcul
  final dynamic avatarState; // AvatarState enum

  const RecordHydrationResult({
    required this.log,
    required this.totalVolumeToday,
    required this.dailyGoalLiters,
    required this.progressPercentage,
    required this.avatarState,
  });

  /// Vérifie si l'objectif quotidien est atteint
  bool get isGoalAchieved => progressPercentage >= 1.0;

  @override
  String toString() {
    return 'RecordHydrationResult('
        'log: ${log.id}, '
        'totalVolumeToday: ${totalVolumeToday}L, '
        'dailyGoal: ${dailyGoalLiters}L, '
        'progress: ${(progressPercentage * 100).toStringAsFixed(1)}%, '
        'avatarState: $avatarState'
        ')';
  }
}

/// Exception personnalisée pour les erreurs d'enregistrement d'hydratation
class RecordHydrationException implements Exception {
  /// Message d'erreur user-friendly
  final String message;

  /// Exception originale (optionnelle pour debug)
  final Object? originalException;

  RecordHydrationException(this.message, {this.originalException});

  @override
  String toString() => message;
}
