import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// Utilitaire pour le nettoyage automatique des anciennes photos.
///
/// Story 3.4 - Photo Capture Storage
/// AC6: Suppression automatique des photos de plus de 90 jours.

/// Supprime automatiquement les photos de plus de 90 jours.
///
/// Cette fonction:
/// - Lit tous les fichiers dans le répertoire photos
/// - Vérifie la date de création de chaque fichier
/// - Supprime les fichiers créés il y a plus de 90 jours
///
/// Exécution: Foreground uniquement (pas de background task)
/// Appel: Dans main.dart après init GetIt, avant runApp
///
/// Logique: DateTime.now().difference(fileCreationDate).inDays > 90
Future<void> deleteOldPhotos() async {
  try {
    // Étape 1: Obtenir le répertoire des photos
    final appDocDir = await getApplicationDocumentsDirectory();
    final photoDir = Directory(path.join(appDocDir.path, 'photos'));

    // Si le répertoire n'existe pas, rien à faire
    if (!await photoDir.exists()) {
      if (kDebugMode) {
        debugPrint('[PhotoCleanup] Répertoire photos n\'existe pas encore');
      }
      return;
    }

    // Étape 2: Lister tous les fichiers dans le répertoire
    final files = photoDir.listSync();

    if (files.isEmpty) {
      if (kDebugMode) {
        debugPrint('[PhotoCleanup] Aucun fichier à nettoyer');
      }
      return;
    }

    // Étape 3: Filtrer et supprimer les fichiers de plus de 90 jours
    final now = DateTime.now();
    int deletedCount = 0;

    for (final entity in files) {
      if (entity is File) {
        try {
          // Récupérer la date de dernière modification (proxy pour date de création)
          final fileStat = await entity.stat();
          final fileModifiedDate = fileStat.modified;

          // Calculer la différence en jours
          final daysSinceModification = now.difference(fileModifiedDate).inDays;

          // Si plus de 90 jours, supprimer
          if (daysSinceModification > 90) {
            await entity.delete();
            deletedCount++;

            if (kDebugMode) {
              debugPrint(
                '[PhotoCleanup] Supprimé: ${path.basename(entity.path)} '
                '($daysSinceModification jours)',
              );
            }
          }
        } catch (e) {
          // Log l'erreur mais continue le nettoyage des autres fichiers
          if (kDebugMode) {
            debugPrint(
              '[PhotoCleanup] Erreur suppression ${path.basename(entity.path)}: $e',
            );
          }
        }
      }
    }

    if (kDebugMode) {
      debugPrint(
        '[PhotoCleanup] Nettoyage terminé: $deletedCount photo(s) supprimée(s)',
      );
    }
  } catch (e) {
    // Log l'erreur mais ne pas crasher l'app
    if (kDebugMode) {
      debugPrint('[PhotoCleanup] Erreur lors du nettoyage: $e');
    }
  }
}
