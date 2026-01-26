import 'dart:io';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// Use case pour capturer une photo selfie et la sauvegarder localement.
///
/// Responsabilités:
/// - Capturer la photo via CameraController
/// - Générer nom de fichier avec format: hydration_YYYYMMDD_HHmmss.jpg
/// - Compresser l'image avec quality parameter 80
/// - Sauvegarder dans le répertoire app local
/// - Retourner le chemin complet du fichier sauvegardé
///
/// Story 3.4 - Photo Capture Storage
class CapturePhotoUseCase {
  /// Compression quality pour les photos (80%).
  static const int kCompressionQuality = 80;

  /// Capture et sauvegarde une photo.
  ///
  /// [cameraController] Le controller caméra initialisé.
  ///
  /// Returns le chemin complet du fichier sauvegardé.
  ///
  /// Throws [CapturePhotoException] si la capture ou la sauvegarde échoue.
  Future<String> call(CameraController cameraController) async {
    try {
      // Étape 1: Capturer la photo
      final XFile photoFile = await cameraController.takePicture();

      // Étape 2: Lire les bytes de la photo
      final bytes = await photoFile.readAsBytes();

      // Étape 3: Décoder l'image
      final image = img.decodeImage(bytes);
      if (image == null) {
        throw CapturePhotoException('Impossible de décoder l\'image capturée');
      }

      // Étape 4: Compresser l'image avec quality parameter 80
      final compressedBytes = img.encodeJpg(
        image,
        quality: kCompressionQuality,
      );

      // Étape 5: Générer le nom de fichier avec format timestamp
      final fileName = _generateFileName();

      // Étape 6: Obtenir le répertoire de sauvegarde
      final directory = await _getStorageDirectory();

      // Étape 7: Créer le chemin complet du fichier
      final filePath = path.join(directory.path, fileName);

      // Étape 8: Sauvegarder le fichier compressé
      final file = File(filePath);
      await file.writeAsBytes(compressedBytes);

      // Étape 9: Retourner le chemin complet
      return filePath;
    } on FileSystemException catch (e) {
      // Gestion erreur: storage plein ou permissions manquantes
      throw CapturePhotoException(
        'Impossible de sauvegarder la photo. Vérifie ton espace de stockage.',
        originalException: e,
      );
    } catch (e) {
      // Autres erreurs (caméra, compression, etc.)
      throw CapturePhotoException(
        'Erreur lors de la capture de la photo: ${e.toString()}',
        originalException: e,
      );
    }
  }

  /// Génère le nom de fichier avec format: hydration_YYYYMMDD_HHmmss.jpg
  ///
  /// Format exact:
  /// - Préfixe: "hydration_"
  /// - Date: YYYYMMDD (année 4 chiffres + mois 2 chiffres + jour 2 chiffres)
  /// - Underscore: "_"
  /// - Heure: HHmmss (heure 2 chiffres + minute 2 chiffres + seconde 2 chiffres)
  /// - Extension: ".jpg"
  ///
  /// Exemple: hydration_20260116_093045.jpg
  String _generateFileName() {
    final now = DateTime.now();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(now);
    return 'hydration_$timestamp.jpg';
  }

  /// Obtient le répertoire de sauvegarde des photos.
  ///
  /// - iOS: Application Documents Directory
  /// - Android: Internal Storage (getApplicationDocumentsDirectory)
  ///
  /// Returns le répertoire où sauvegarder les photos.
  Future<Directory> _getStorageDirectory() async {
    // Utiliser getApplicationDocumentsDirectory pour iOS et Android
    // iOS: /var/mobile/Containers/Data/Application/[UUID]/Documents
    // Android: /data/data/com.example.hydrate_or_die/app_flutter
    final appDocDir = await getApplicationDocumentsDirectory();

    // Créer un sous-répertoire pour les photos si nécessaire
    final photoDir = Directory(path.join(appDocDir.path, 'photos'));
    if (!await photoDir.exists()) {
      await photoDir.create(recursive: true);
    }

    return photoDir;
  }
}

/// Exception personnalisée pour les erreurs de capture photo.
class CapturePhotoException implements Exception {
  /// Message d'erreur user-friendly.
  final String message;

  /// Exception originale (optionnelle pour debug).
  final Object? originalException;

  CapturePhotoException(this.message, {this.originalException});

  @override
  String toString() => message;
}
