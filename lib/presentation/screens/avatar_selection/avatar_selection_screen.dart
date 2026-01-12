import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydrate_or_die/domain/entities/avatar_personality.dart';
import 'package:hydrate_or_die/domain/entities/avatar_state.dart';
import 'package:hydrate_or_die/domain/repositories/avatar_repository.dart';
import 'package:hydrate_or_die/presentation/widgets/avatar_display.dart';
import 'package:hydrate_or_die/core/di/injection.dart';

/// Écran de sélection d'avatar (premier lancement uniquement).
///
/// Affiche les 4 avatars disponibles en grid 2×2 avec preview (état fresh).
/// L'utilisateur sélectionne son avatar préféré et confirme son choix.
///
/// Navigation:
/// - Condition: Affiché si AvatarRepository.getSelectedAvatar() == null
/// - Après confirmation: Navigator.pushReplacement → HomeScreen
///
/// Usage:
/// ```dart
/// Navigator.of(context).pushReplacement(
///   MaterialPageRoute(builder: (_) => AvatarSelectionScreen()),
/// );
/// ```
class AvatarSelectionScreen extends ConsumerStatefulWidget {
  const AvatarSelectionScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AvatarSelectionScreen> createState() =>
      _AvatarSelectionScreenState();
}

class _AvatarSelectionScreenState
    extends ConsumerState<AvatarSelectionScreen> {
  AvatarPersonality? _selectedPersonality;

  Future<void> _confirmSelection() async {
    if (_selectedPersonality == null) return;

    try {
      final repository = getIt<AvatarRepository>();
      // Convert enum to string ID for repository
      final avatarId = _selectedPersonality!.name;

      // Sauvegarde de l'avatar sélectionné
      await repository.saveSelectedAvatar(avatarId);

      // Vérification que la sauvegarde a réussi
      final savedAvatar = await repository.getAvatar();
      print('DEBUG: Avatar saved: ${savedAvatar?.personality}');

      if (!mounted) return;

      // Navigation vers HomeScreen (AC #6)
      Navigator.of(context).pushReplacementNamed('/home');
    } catch (e) {
      print('ERROR: Failed to save avatar: $e');
      if (!mounted) return;

      // Afficher erreur à l'utilisateur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la sauvegarde: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choisis ton Avatar'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Instructions
            Text(
              'Sélectionne ton compagnon d\'hydratation',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Il te motivera (ou punira) tous les jours',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Grid 2×2 des avatars (AC #2)
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildAvatarCard(AvatarPersonality.doctor),
                  _buildAvatarCard(AvatarPersonality.sportsCoach),
                  _buildAvatarCard(AvatarPersonality.authoritarianMother),
                  _buildAvatarCard(AvatarPersonality.sarcasticFriend),
                ],
              ),
            ),

            // Bouton de confirmation (AC #5)
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed:
                    _selectedPersonality != null ? _confirmSelection : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2196F3),
                  disabledBackgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Confirmer mon choix',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _selectedPersonality != null
                        ? Colors.white
                        : Colors.grey[600],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarCard(AvatarPersonality personality) {
    final isSelected = _selectedPersonality == personality;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPersonality = personality;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? const Color(0xFF2196F3) : Colors.grey[300]!,
            width: isSelected ? 4 : 2, // AC #4 - Highlight
          ),
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Preview avatar état fresh (AC #3)
            AvatarDisplay(
              personality: personality,
              state: AvatarState.fresh,
              size: 70,
            ),
            const SizedBox(height: 6),

            // Nom (AC #3)
            Text(
              _getAvatarName(personality),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),

            // Description (AC #3) - Flexible pour absorber overflow
            Flexible(
              child: Text(
                _getAvatarDescription(personality),
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getAvatarName(AvatarPersonality personality) {
    switch (personality) {
      case AvatarPersonality.doctor:
        return 'Doctor';
      case AvatarPersonality.sportsCoach:
        return 'Coach';
      case AvatarPersonality.authoritarianMother:
        return 'Mother';
      case AvatarPersonality.sarcasticFriend:
        return 'Friend';
    }
  }

  String _getAvatarDescription(AvatarPersonality personality) {
    switch (personality) {
      case AvatarPersonality.doctor:
        return 'Ton médecin personnel, toujours professionnel';
      case AvatarPersonality.sportsCoach:
        return 'Ton coach sportif, ultra motivant';
      case AvatarPersonality.authoritarianMother:
        return 'Ta mère autoritaire, elle veut ton bien';
      case AvatarPersonality.sarcasticFriend:
        return 'Ton pote sarcastique, toujours cool';
    }
  }
}
