import 'package:permission_handler/permission_handler.dart';

/// Énumération des états de permission caméra possibles.
enum CameraPermissionStatus {
  /// Permission accordée par l'utilisateur.
  granted,

  /// Permission refusée par l'utilisateur mais peut être redemandée.
  denied,

  /// Permission refusée définitivement (Android) ou restricted (iOS).
  /// L'utilisateur doit aller dans les paramètres système.
  permanentlyDenied,

  /// Permission restreinte par le système (iOS parental controls, etc.).
  restricted,
}

/// Service de gestion des permissions caméra.
///
/// Fournit des méthodes pour :
/// - Vérifier le statut actuel de la permission caméra
/// - Demander la permission caméra à l'utilisateur
/// - Ouvrir les paramètres système si permission refusée définitivement
///
/// Utilise le package `permission_handler` pour gérer les permissions
/// de manière uniforme sur Android et iOS.
class CameraPermissionService {
  /// Vérifie le statut actuel de la permission caméra.
  ///
  /// Retourne un [CameraPermissionStatus] indiquant l'état actuel.
  /// Ne demande PAS la permission, seulement vérification.
  ///
  /// Example:
  /// ```dart
  /// final status = await service.checkPermissionStatus();
  /// if (status == CameraPermissionStatus.granted) {
  ///   // Ouvrir la caméra
  /// }
  /// ```
  Future<CameraPermissionStatus> checkPermissionStatus() async {
    final status = await Permission.camera.status;

    if (status.isGranted) {
      return CameraPermissionStatus.granted;
    } else if (status.isPermanentlyDenied) {
      return CameraPermissionStatus.permanentlyDenied;
    } else if (status.isRestricted) {
      return CameraPermissionStatus.restricted;
    } else {
      return CameraPermissionStatus.denied;
    }
  }

  /// Demande la permission caméra à l'utilisateur.
  ///
  /// Affiche le dialogue système de demande de permission.
  /// Retourne le [CameraPermissionStatus] résultant de la demande.
  ///
  /// Si la permission a déjà été accordée, retourne immédiatement [granted].
  /// Si la permission a été refusée définitivement, retourne [permanentlyDenied]
  /// sans afficher de dialogue.
  ///
  /// Example:
  /// ```dart
  /// final status = await service.requestPermission();
  /// if (status == CameraPermissionStatus.granted) {
  ///   // Continuer avec la caméra
  /// } else if (status == CameraPermissionStatus.permanentlyDenied) {
  ///   // Proposer d'ouvrir les paramètres
  /// }
  /// ```
  Future<CameraPermissionStatus> requestPermission() async {
    final status = await Permission.camera.request();

    if (status.isGranted) {
      return CameraPermissionStatus.granted;
    } else if (status.isPermanentlyDenied) {
      return CameraPermissionStatus.permanentlyDenied;
    } else if (status.isRestricted) {
      return CameraPermissionStatus.restricted;
    } else {
      return CameraPermissionStatus.denied;
    }
  }

  /// Ouvre les paramètres système de l'application.
  ///
  /// Permet à l'utilisateur d'accorder manuellement la permission caméra
  /// après un refus définitif.
  ///
  /// Retourne `true` si les paramètres ont été ouverts avec succès,
  /// `false` sinon (rare, mais possible sur certaines versions Android).
  ///
  /// Example:
  /// ```dart
  /// final opened = await service.openAppSettings();
  /// if (!opened) {
  ///   // Afficher message d'erreur
  /// }
  /// ```
  Future<bool> openSettings() async {
    return await openAppSettings();
  }

  /// Vérifie si la permission peut être demandée.
  ///
  /// Retourne `false` si la permission est déjà [permanentlyDenied] ou [restricted],
  /// car dans ces cas il faut rediriger vers les paramètres système.
  ///
  /// Retourne `true` si la permission peut être demandée (états [denied] ou première demande).
  Future<bool> canRequestPermission() async {
    final status = await checkPermissionStatus();
    return status != CameraPermissionStatus.permanentlyDenied &&
        status != CameraPermissionStatus.restricted;
  }
}
