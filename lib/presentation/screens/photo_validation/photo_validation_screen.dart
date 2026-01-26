import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../../core/di/injection.dart';
import '../../../core/services/camera_permission_service.dart';
import '../../../domain/use_cases/photo/capture_photo_use_case.dart';

/// Photo Validation Screen avec interface caméra complète.
///
/// Ce screen gère :
/// - Demande de permission caméra (Story 3.10)
/// - Affichage preview caméra frontale plein écran
/// - Overlay guide visuel pour positionnement (zone visage + verre)
/// - Instructions texte
/// - Bouton capture + bouton annuler
/// - Gestion erreurs caméra (device unavailable, initialization failed)
///
/// Story 3.3 - Camera Interface
class PhotoValidationScreen extends StatefulWidget {
  const PhotoValidationScreen({super.key});

  @override
  State<PhotoValidationScreen> createState() => _PhotoValidationScreenState();
}

class _PhotoValidationScreenState extends State<PhotoValidationScreen> {
  final CameraPermissionService _permissionService =
      getIt<CameraPermissionService>();
  final CapturePhotoUseCase _capturePhotoUseCase = getIt<CapturePhotoUseCase>();

  CameraPermissionStatus? _permissionStatus;
  bool _isLoading = true;
  bool _isRequestingPermission = false;
  bool _isCapturing = false;
  CameraController? _cameraController;
  String? _cameraErrorMessage;

  @override
  void initState() {
    super.initState();
    _checkAndRequestPermission();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  /// Vérifie et demande la permission caméra au lancement.
  Future<void> _checkAndRequestPermission() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Vérifier le statut actuel
      final status = await _permissionService.checkPermissionStatus();

      if (status == CameraPermissionStatus.granted) {
        // Permission déjà accordée - initialiser la caméra
        setState(() {
          _permissionStatus = status;
        });
        await _initializeCamera();
      } else if (await _permissionService.canRequestPermission()) {
        // Peut demander la permission
        setState(() {
          _isRequestingPermission = true;
        });

        final requestedStatus = await _permissionService.requestPermission();

        setState(() {
          _permissionStatus = requestedStatus;
          _isRequestingPermission = false;
        });

        if (requestedStatus == CameraPermissionStatus.granted) {
          // Permission accordée - initialiser la caméra
          await _initializeCamera();
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        // Permission refusée définitivement ou restreinte
        setState(() {
          _permissionStatus = status;
          _isLoading = false;
        });
      }
    } catch (e) {
      // Gestion d'erreur
      setState(() {
        _permissionStatus = CameraPermissionStatus.denied;
        _isLoading = false;
        _isRequestingPermission = false;
      });
    }
  }

  /// Initialise le controller caméra frontale.
  Future<void> _initializeCamera() async {
    try {
      // Récupérer les caméras disponibles
      final cameras = await availableCameras();

      if (cameras.isEmpty) {
        setState(() {
          _cameraErrorMessage = 'Aucune caméra disponible sur cet appareil';
          _isLoading = false;
        });
        return;
      }

      // Chercher la caméra frontale
      CameraDescription? frontCamera;
      try {
        frontCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
        );
      } catch (e) {
        // Si pas de caméra frontale, utiliser la première disponible
        frontCamera = cameras.first;
      }

      // Créer le controller avec résolution medium (bon compromis qualité/performance)
      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false, // Pas besoin d'audio pour une photo
      );

      // Initialiser le controller
      await _cameraController!.initialize();

      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _cameraErrorMessage = null;
      });
    } catch (e) {
      setState(() {
        _cameraErrorMessage =
            'Erreur d\'initialisation de la caméra: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  /// Ouvre les paramètres système de l'application.
  Future<void> _openSettings() async {
    final opened = await _permissionService.openSettings();
    if (!opened && mounted) {
      _showErrorSnackBar(
        'Impossible d\'ouvrir les paramètres. Ouvre-les manuellement.',
      );
    }
  }

  /// Affiche un message d'erreur.
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Retourne au HomeScreen.
  void _goBack() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Validation Photo'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
        leading: IconButton(icon: const Icon(Icons.close), onPressed: _goBack),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading || _isRequestingPermission) {
      return _buildLoadingState();
    }

    // Afficher l'erreur caméra si présente
    if (_cameraErrorMessage != null) {
      return _buildCameraErrorState();
    }

    switch (_permissionStatus) {
      case CameraPermissionStatus.granted:
        // Vérifier que le controller est initialisé
        if (_cameraController != null &&
            _cameraController!.value.isInitialized) {
          return _buildCameraInterface();
        } else {
          return _buildLoadingState();
        }
      case CameraPermissionStatus.denied:
        return _buildPermissionDeniedState();
      case CameraPermissionStatus.permanentlyDenied:
      case CameraPermissionStatus.restricted:
        return _buildPermanentlyDeniedState();
      case null:
        return _buildLoadingState();
    }
  }

  /// État de chargement lors de la vérification des permissions.
  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2196F3)),
          ),
          SizedBox(height: 24),
          Text(
            'Vérification des permissions...',
            style: TextStyle(fontSize: 16.0, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  /// Interface caméra complète avec preview, overlay et boutons.
  Widget _buildCameraInterface() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Preview caméra plein écran
        CameraPreview(_cameraController!),

        // Overlay guide visuel semi-transparent
        CustomPaint(painter: _GuidanceOverlayPainter(), child: Container()),

        // Instructions et boutons en overlay
        SafeArea(
          child: Column(
            children: [
              // Instructions en haut
              Container(
                margin: const EdgeInsets.only(top: 24.0),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const Text(
                  'Prends un selfie avec ton verre d\'eau 💧',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const Spacer(),

              // Bouton capture (centre bas, 72x72)
              Container(
                margin: const EdgeInsets.only(bottom: 40.0),
                child: FloatingActionButton(
                  onPressed: _isCapturing ? null : _capturePhoto,
                  backgroundColor: _isCapturing
                      ? Colors.grey
                      : const Color(0xFF2196F3),
                  heroTag: 'capture_button',
                  child: _isCapturing
                      ? const SizedBox(
                          width: 24.0,
                          height: 24.0,
                          child: CircularProgressIndicator(
                            strokeWidth: 3.0,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Icon(
                          Icons.camera_alt,
                          size: 36.0,
                          color: Colors.white,
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// État d'erreur caméra (device unavailable, init failed).
  Widget _buildCameraErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 100.0, color: Colors.red),
            const SizedBox(height: 24),
            const Text(
              'Erreur Caméra',
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              _cameraErrorMessage ?? 'Une erreur est survenue',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0, color: Colors.grey[700]),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _goBack,
              icon: const Icon(Icons.arrow_back),
              label: const Text('Retour'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32.0,
                  vertical: 16.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Capture et sauvegarde une photo (Story 3.4).
  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      _showErrorSnackBar('Caméra non initialisée');
      return;
    }

    if (_isCapturing) {
      // Éviter les doubles captures
      return;
    }

    setState(() {
      _isCapturing = true;
    });

    try {
      // Capturer et sauvegarder la photo via le use case
      final photoPath = await _capturePhotoUseCase(_cameraController!);

      if (!mounted) return;

      // Naviguer vers GlassSizeSelectionScreen (Story 3.9)
      Navigator.of(
        context,
      ).pushReplacementNamed('/glass_size_selection', arguments: photoPath);
    } on CapturePhotoException catch (e) {
      // Gestion erreur use case (storage plein, compression failed, etc.)
      if (!mounted) return;
      _showErrorSnackBar(e.message);
      setState(() {
        _isCapturing = false;
      });
    } catch (e) {
      // Autres erreurs imprévues
      if (!mounted) return;
      _showErrorSnackBar('Erreur lors de la capture: ${e.toString()}');
      setState(() {
        _isCapturing = false;
      });
    }
  }

  /// État permission refusée (peut être redemandée).
  Widget _buildPermissionDeniedState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.camera_alt_outlined,
              size: 100.0,
              color: Colors.orange,
            ),
            const SizedBox(height: 24),
            const Text(
              'Caméra nécessaire',
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Pour valider ton hydratation, nous avons besoin '
              'd\'accéder à ta caméra pour prendre une photo de ton verre.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0, color: Colors.grey[700]),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _checkAndRequestPermission,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Autoriser la caméra'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32.0,
                  vertical: 16.0,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _goBack,
              child: const Text(
                'Annuler',
                style: TextStyle(color: Colors.grey, fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// État permission refusée définitivement (redirection vers paramètres).
  Widget _buildPermanentlyDeniedState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.settings, size: 100.0, color: Colors.red),
            const SizedBox(height: 24),
            const Text(
              'Permission requise',
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Tu as refusé l\'accès à la caméra. '
              'Pour utiliser la validation photo, tu dois activer '
              'la permission caméra dans les paramètres de ton appareil.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0, color: Colors.grey[700]),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _openSettings,
              icon: const Icon(Icons.settings),
              label: const Text('Ouvrir Paramètres'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32.0,
                  vertical: 16.0,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _goBack,
              child: const Text(
                'Annuler',
                style: TextStyle(color: Colors.grey, fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// CustomPainter pour l'overlay guide visuel.
///
/// Affiche un overlay semi-transparent avec deux zones claires :
/// - Zone supérieure pour le visage (ovale)
/// - Zone inférieure pour le verre (rectangle arrondi)
///
/// Le reste de l'écran est assombri pour guider le positionnement.
class _GuidanceOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Paint pour l'overlay sombre semi-transparent
    final overlayPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    // Paint pour les contours des zones guides
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    // Créer le chemin de l'overlay avec découpes pour les zones guides
    final path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Zone visage (ovale, partie supérieure de l'écran)
    final faceZoneCenter = Offset(size.width / 2, size.height * 0.3);
    final faceZoneWidth = size.width * 0.55;
    final faceZoneHeight = size.height * 0.25;
    final faceZoneRect = Rect.fromCenter(
      center: faceZoneCenter,
      width: faceZoneWidth,
      height: faceZoneHeight,
    );
    path.addOval(faceZoneRect);

    // Zone verre (rectangle arrondi, partie inférieure)
    final glassZoneCenter = Offset(size.width / 2, size.height * 0.65);
    final glassZoneWidth = size.width * 0.4;
    final glassZoneHeight = size.height * 0.2;
    final glassZoneRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: glassZoneCenter,
        width: glassZoneWidth,
        height: glassZoneHeight,
      ),
      const Radius.circular(16.0),
    );
    path.addRRect(glassZoneRect);

    // Remplir avec règle even-odd pour créer les découpes
    path.fillType = PathFillType.evenOdd;
    canvas.drawPath(path, overlayPaint);

    // Dessiner les contours des zones guides
    canvas.drawOval(faceZoneRect, borderPaint);
    canvas.drawRRect(glassZoneRect, borderPaint);

    // Ajouter des labels texte pour les zones
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    // Label "Visage"
    textPainter.text = const TextSpan(
      text: 'Visage',
      style: TextStyle(
        color: Colors.white,
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(faceZoneCenter.dx - textPainter.width / 2, faceZoneRect.top - 30),
    );

    // Label "Verre"
    textPainter.text = const TextSpan(
      text: 'Verre',
      style: TextStyle(
        color: Colors.white,
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        glassZoneCenter.dx - textPainter.width / 2,
        glassZoneRect.top - 30,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // Overlay statique, pas besoin de repeindre
  }
}
