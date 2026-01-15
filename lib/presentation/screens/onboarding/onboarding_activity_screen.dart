import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydrate_or_die/domain/entities/activity_level.dart';
import 'package:hydrate_or_die/presentation/providers/onboarding_provider.dart';
import 'package:hydrate_or_die/presentation/widgets/embedded_onboarding_context.dart';

/// Onboarding Screen - Step 4: Activity Level Selection
///
/// Allows user to select their physical activity level.
/// Options: Sedentary, Light, Moderate, Very Active, Extremely Active
class OnboardingActivityScreen extends ConsumerStatefulWidget {
  const OnboardingActivityScreen({super.key});

  @override
  ConsumerState<OnboardingActivityScreen> createState() =>
      _OnboardingActivityScreenState();
}

class _OnboardingActivityScreenState
    extends ConsumerState<OnboardingActivityScreen> {
  ActivityLevel? _selectedActivity;

  @override
  void initState() {
    super.initState();

    // Pre-fill activity level if already set in state
    final onboardingState = ref.read(onboardingProvider);
    if (onboardingState.activityLevel != null) {
      _selectedActivity = onboardingState.activityLevel;
    }
  }

  /// Handle activity level card selection
  void _selectActivity(ActivityLevel activity) {
    setState(() {
      _selectedActivity = activity;
    });

    // Update provider in real-time for embedded flow validation
    ref.read(onboardingProvider.notifier).updateActivityLevel(activity);
  }

  /// Handle next button press
  void _handleNext() {
    if (_selectedActivity == null) return;

    // Provider already updated in _selectActivity() for real-time validation
    // Navigate to next screen (Location screen - Story 2.8)
    Navigator.of(context).pushNamed('/onboarding_location');
  }

  /// Build activity level selection card
  Widget _buildActivityCard({
    required ActivityLevel activity,
    required String label,
    required String description,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    final isSelected = _selectedActivity == activity;

    return InkWell(
      onTap: () => _selectActivity(activity),
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
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: isSelected
                ? theme.colorScheme.primary.withValues(alpha: 0.1)
                : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 32,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
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
              'Étape 4 sur 5',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Title
            Text(
              'Niveau d\'activité physique',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Subtitle
            Text(
              'À quelle fréquence fais-tu du sport ?',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),

            // Activity level selection cards
            _buildActivityCard(
              activity: ActivityLevel.sedentary,
              label: 'Sédentaire',
              description: 'Peu ou pas d\'exercice',
              icon: Icons.weekend,
            ),
            const SizedBox(height: 16),
            _buildActivityCard(
              activity: ActivityLevel.light,
              label: 'Léger',
              description: '1-3 fois par semaine',
              icon: Icons.directions_walk,
            ),
            const SizedBox(height: 16),
            _buildActivityCard(
              activity: ActivityLevel.moderate,
              label: 'Modéré',
              description: '3-5 fois par semaine',
              icon: Icons.directions_run,
            ),
            const SizedBox(height: 16),
            _buildActivityCard(
              activity: ActivityLevel.veryActive,
              label: 'Très actif',
              description: '6-7 fois par semaine',
              icon: Icons.fitness_center,
            ),
            const SizedBox(height: 16),
            _buildActivityCard(
              activity: ActivityLevel.extremelyActive,
              label: 'Extrêmement actif',
              description: 'Sport intense quotidien',
              icon: Icons.local_fire_department,
            ),
            const SizedBox(height: 48),

            // Next button (only show if NOT embedded in flow)
            if (!isEmbedded) ...[
              ElevatedButton(
                onPressed: _selectedActivity != null ? _handleNext : null,
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
