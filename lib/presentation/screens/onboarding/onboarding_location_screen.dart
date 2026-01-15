import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydrate_or_die/presentation/providers/onboarding_provider.dart';
import 'package:hydrate_or_die/presentation/widgets/embedded_onboarding_context.dart';

/// Onboarding Screen - Step 5: Location Permission (Optional)
///
/// Allows user to grant location permission for future weather-based
/// hydration adjustments (V2 feature). Both "Allow" and "Skip" options
/// allow progression to the next screen.
///
/// Implementation: Simplified MVP version (Option B) without permission_handler.
/// Permission handling will be implemented in V2.
class OnboardingLocationScreen extends ConsumerWidget {
  const OnboardingLocationScreen({super.key});

  /// Handle authorize button press
  ///
  /// In MVP (Option B), this simulates permission grant without actually
  /// requesting system permission. Shows a snackbar to indicate development mode.
  /// Will be replaced with real permission_handler in V2.
  void _handleAuthorize(BuildContext context, WidgetRef ref) {
    // Mock permission grant (no real system permission request)
    ref.read(onboardingProvider.notifier).updateLocation('mock_granted');

    // Show feedback to user
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Localisation activée (mode développement)'),
        duration: Duration(seconds: 2),
      ),
    );

    // Navigate to Summary Screen (Story 2.9 - not yet implemented)
    // This will fail silently until Story 2.9 is completed
    Navigator.of(context).pushNamed('/onboarding_summary');
  }

  /// Handle skip button press
  ///
  /// User chooses not to grant location permission.
  /// Updates provider with null location and proceeds to next screen.
  void _handleSkip(BuildContext context, WidgetRef ref) {
    // No location permission
    ref.read(onboardingProvider.notifier).updateLocation(null);

    // Navigate to Summary Screen (Story 2.9 - not yet implemented)
    Navigator.of(context).pushNamed('/onboarding_summary');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final embeddedContext = EmbeddedOnboardingContext.of(context);
    final isEmbedded = embeddedContext.isEmbedded;

    // Build the main content
    final content = Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Progress indicator
          Text(
            'Étape 5 sur 5',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Icon
          Icon(
            Icons.location_on,
            size: 80,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 24),

          // Title
          Text(
            'Autoriser la localisation ?',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),

          // Subtitle
          Text(
            'Optionnel : permettra d\'ajuster les rappels en fonction de la météo (canicule)',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),

          // Authorize button (primary) - only show if NOT embedded in flow
          if (!isEmbedded) ...[
            ElevatedButton(
              onPressed: () => _handleAuthorize(context, ref),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Autoriser',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),

            // Skip button (secondary)
            OutlinedButton(
              onPressed: () => _handleSkip(context, ref),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Pas maintenant',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ),
          ],

          const Spacer(),
        ],
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
