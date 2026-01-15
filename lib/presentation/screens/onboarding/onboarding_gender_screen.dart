import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydrate_or_die/domain/entities/gender.dart';
import 'package:hydrate_or_die/presentation/providers/onboarding_provider.dart';
import 'package:hydrate_or_die/presentation/widgets/embedded_onboarding_context.dart';

/// Onboarding Screen - Step 3: Gender Selection
///
/// Allows user to select their biological gender.
/// Options: Male, Female, Other
class OnboardingGenderScreen extends ConsumerStatefulWidget {
  const OnboardingGenderScreen({super.key});

  @override
  ConsumerState<OnboardingGenderScreen> createState() =>
      _OnboardingGenderScreenState();
}

class _OnboardingGenderScreenState
    extends ConsumerState<OnboardingGenderScreen> {
  Gender? _selectedGender;

  @override
  void initState() {
    super.initState();

    // Pre-fill gender if already set in state
    final onboardingState = ref.read(onboardingProvider);
    if (onboardingState.gender != null) {
      _selectedGender = onboardingState.gender;
    }
  }

  /// Handle gender card selection
  void _selectGender(Gender gender) {
    setState(() {
      _selectedGender = gender;
    });

    // Update provider in real-time for embedded flow validation
    ref.read(onboardingProvider.notifier).updateGender(gender);
  }

  /// Handle next button press
  void _handleNext() {
    if (_selectedGender == null) return;

    // Provider already updated in _selectGender() for real-time validation
    // Navigate to next screen (Activity level screen - Story 2.7)
    Navigator.of(context).pushNamed('/onboarding_activity');
  }

  /// Build gender selection card
  Widget _buildGenderCard({
    required Gender gender,
    required String label,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    final isSelected = _selectedGender == gender;

    return InkWell(
      onTap: () => _selectGender(gender),
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: isSelected ? 4 : 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: isSelected
                ? theme.colorScheme.primary.withValues(alpha: 0.1)
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 48,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final embeddedContext = EmbeddedOnboardingContext.of(context);
    final isEmbedded = embeddedContext.isEmbedded;

    // Build the main content
    final content = SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Progress indicator
            Text(
              'Étape 3 sur 5',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Title
            Text(
              'Sexe biologique',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Subtitle
            Text(
              'Utilisé uniquement pour calcul scientifique',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),

            // Gender selection cards
            _buildGenderCard(
              gender: Gender.male,
              label: 'Homme',
              icon: Icons.male,
            ),
            const SizedBox(height: 16),
            _buildGenderCard(
              gender: Gender.female,
              label: 'Femme',
              icon: Icons.female,
            ),
            const SizedBox(height: 16),
            _buildGenderCard(
              gender: Gender.other,
              label: 'Autre',
              icon: Icons.person,
            ),
            const SizedBox(height: 48),

            // Next button (only show if NOT embedded in flow)
            if (!isEmbedded) ...[
              ElevatedButton(
                onPressed: _selectedGender != null ? _handleNext : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Suivant',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );

    // If embedded in flow, return content without Scaffold
    if (isEmbedded) {
      return SafeArea(child: content);
    }

    // If standalone, wrap in Scaffold with AppBar
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(child: content),
    );
  }
}
