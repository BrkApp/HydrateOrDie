import 'package:flutter/material.dart';

import '../../../core/di/injection.dart';
import '../../../domain/entities/glass_size.dart';
import '../../../domain/use_cases/hydration/record_hydration_use_case.dart';

/// Écran de sélection de la taille de verre après capture photo.
///
/// Affiche 3 options de taille de verre (small, medium, large) avec :
/// - Icons proportionnels à la taille
/// - Labels français avec volumes en ml
/// - Pré-sélection medium par défaut (border + checkmark)
/// - Tap pour sélectionner ET enregistrer immédiatement
///
/// Après sélection, appelle [RecordHydrationUseCase] puis navigue vers HomeScreen.
///
/// Story 3.9 - Glass Size Selection
class GlassSizeSelectionScreen extends StatefulWidget {
  /// Chemin de la photo capturée (fourni par Story 3.4)
  final String photoPath;

  const GlassSizeSelectionScreen({super.key, required this.photoPath});

  @override
  State<GlassSizeSelectionScreen> createState() =>
      _GlassSizeSelectionScreenState();
}

class _GlassSizeSelectionScreenState extends State<GlassSizeSelectionScreen> {
  final RecordHydrationUseCase _recordHydrationUseCase =
      getIt<RecordHydrationUseCase>();

  /// Taille de verre sélectionnée (null par défaut - pas de pré-sélection)
  GlassSize? _selectedSize;

  /// Indicateur de traitement en cours (pendant RecordHydrationUseCase)
  bool _isRecording = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Taille du verre'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _isRecording ? null : () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Instructions en haut
              const Text(
                'Quelle taille de verre as-tu bu ?',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Tape pour sélectionner et enregistrer',
                style: TextStyle(fontSize: 16.0, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // 3 Cards avec options de taille (AC2, AC3)
              Expanded(
                child: ListView(
                  children: [
                    _buildGlassSizeCard(
                      glassSize: GlassSize.small,
                      iconSize: 24.0, // AC3: Small 24dp width
                    ),
                    const SizedBox(height: 16),
                    _buildGlassSizeCard(
                      glassSize: GlassSize.medium,
                      iconSize: 28.0, // AC3: Medium 28dp width
                    ),
                    const SizedBox(height: 16),
                    _buildGlassSizeCard(
                      glassSize: GlassSize.large,
                      iconSize: 32.0, // AC3: Large 32dp width
                    ),
                  ],
                ),
              ),

              // Message de chargement (si enregistrement en cours)
              if (_isRecording)
                Container(
                  margin: const EdgeInsets.only(top: 16.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20.0,
                        height: 20.0,
                        child: CircularProgressIndicator(strokeWidth: 2.0),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Enregistrement en cours...',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Construit une Card pour une taille de verre.
  ///
  /// [glassSize] Taille du verre (small, medium, large)
  /// [iconSize] Taille de l'icon en dp (24, 28, 32)
  Widget _buildGlassSizeCard({
    required GlassSize glassSize,
    required double iconSize,
  }) {
    final isSelected = _selectedSize == glassSize;

    return Card(
      elevation: isSelected ? 8.0 : 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        // AC4: Border bleu primaire si sélectionné
        side: BorderSide(
          color: isSelected ? const Color(0xFF2196F3) : Colors.grey[300]!,
          width: isSelected ? 3.0 : 1.0,
        ),
      ),
      child: InkWell(
        onTap: _isRecording ? null : () => _onGlassSizeSelected(glassSize),
        borderRadius: BorderRadius.circular(16.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Row(
            children: [
              // Icon proportionnel à la taille (AC3)
              Transform.scale(
                scale: _getIconScale(iconSize),
                child: Icon(
                  Icons.local_drink,
                  size: iconSize,
                  color: isSelected
                      ? const Color(0xFF2196F3)
                      : Colors.grey[700],
                ),
              ),
              const SizedBox(width: 20),

              // Label avec volume (AC2)
              Expanded(
                child: Text(
                  glassSize.displayName,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected
                        ? const Color(0xFF2196F3)
                        : Colors.black87,
                  ),
                ),
              ),

              // Checkmark si sélectionné (AC4)
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFF2196F3),
                  size: 28.0,
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Calcule le scale pour l'icon en fonction de la taille.
  ///
  /// Assure que les icons ont des tailles proportionnelles :
  /// - Small: 24dp → scale 1.0
  /// - Medium: 28dp → scale 1.17
  /// - Large: 32dp → scale 1.33
  double _getIconScale(double iconSize) {
    // Base size = 24dp
    return iconSize / 24.0;
  }

  /// Gère la sélection d'une taille de verre.
  ///
  /// AC5: Tap → sélectionne ET appelle RecordHydrationUseCase puis navigue
  /// AC6: glassSize passé au use case
  Future<void> _onGlassSizeSelected(GlassSize glassSize) async {
    setState(() {
      _selectedSize = glassSize;
      _isRecording = true;
    });

    try {
      // AC6: Appeler RecordHydrationUseCase avec photoPath + glassSize
      await _recordHydrationUseCase(
        photoPath: widget.photoPath,
        glassSize: glassSize,
      );

      if (!mounted) return;

      // AC5: Navigation vers FeedbackScreen après enregistrement (Story 3.7)
      // pushReplacementNamed pour éviter retour arrière vers caméra
      Navigator.of(context).pushReplacementNamed('/feedback');
    } on RecordHydrationException catch (e) {
      // Gestion erreur use case (storage plein, etc.)
      if (!mounted) return;

      setState(() {
        _isRecording = false;
      });

      _showErrorSnackBar(e.message);
    } catch (e) {
      // Autres erreurs imprévues
      if (!mounted) return;

      setState(() {
        _isRecording = false;
      });

      _showErrorSnackBar('Erreur lors de l\'enregistrement: ${e.toString()}');
    }
  }

  /// Affiche un message d'erreur.
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
