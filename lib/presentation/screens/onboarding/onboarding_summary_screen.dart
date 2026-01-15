import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/injection.dart';
import '../../../domain/entities/activity_level.dart';
import '../../../domain/entities/gender.dart';
import '../../../domain/entities/hydration_goal.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/repositories/user_repository.dart';
import '../../../domain/use_cases/user/calculate_hydration_goal_use_case.dart';
import '../../providers/onboarding_provider.dart';
import '../../widgets/embedded_onboarding_context.dart';

/// Onboarding Summary Screen - Displays calculated hydration goal and profile recap
///
/// Final step of the onboarding flow (Story 2.9).
/// - Shows personalized hydration goal based on user profile
/// - Displays profile recap (gender, age, weight, activity level, location)
/// - Motivational message with avatar icon
/// - "C'est parti!" button to save profile and navigate to Home
class OnboardingSummaryScreen extends ConsumerStatefulWidget {
  const OnboardingSummaryScreen({super.key});

  @override
  ConsumerState<OnboardingSummaryScreen> createState() =>
      _OnboardingSummaryScreenState();
}

class _OnboardingSummaryScreenState
    extends ConsumerState<OnboardingSummaryScreen> {
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingProvider);
    final theme = Theme.of(context);
    final embeddedContext = EmbeddedOnboardingContext.of(context);
    final isEmbedded = embeddedContext.isEmbedded;

    // Validate that all required data is present
    if (!state.canComplete) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/onboarding_weight');
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Calculate hydration goal first (we need it to create the User)
    final calculateUseCase = getIt<CalculateHydrationGoalUseCase>();

    // Create a temporary user for calculation (with placeholder goal)
    final tempUser = User(
      id: '1', // Singleton user ID
      weight: state.weight!,
      age: state.age!,
      gender: state.gender!,
      activityLevel: state.activityLevel!,
      dailyGoal: HydrationGoal(2.0), // Temporary placeholder
    );

    // Calculate the actual hydration goal
    final hydrationGoal = calculateUseCase.execute(tempUser);
    final goalInLiters = hydrationGoal.targetLiters;

    // Create the final user with calculated goal
    final user = tempUser.copyWith(dailyGoal: hydrationGoal);

    // Build the main content
    final content = SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // Title
            Text(
              'Ton objectif quotidien',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            // Goal Display (Large)
            Text(
              '${goalInLiters.toStringAsFixed(1)} L',
              style: theme.textTheme.displayLarge?.copyWith(
                color: theme.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 64,
              ),
            ),

            const SizedBox(height: 10),

            // Subtitle
            Text(
              'Basé sur ton profil personnel',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            // Profile Recap Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue[100]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Récapitulatif:',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildRecapItem('Genre', _getGenderLabel(state.gender!)),
                  _buildRecapItem('Âge', '${state.age} ans'),
                  _buildRecapItem('Poids', '${state.weight} kg'),
                  _buildRecapItem(
                      'Activité', _getActivityLabel(state.activityLevel!)),
                  if (state.location != null && state.location!.isNotEmpty)
                    _buildRecapItem('Localisation', state.location!),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Avatar Icon & Motivational Message
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '💧',
                  style: const TextStyle(fontSize: 48),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    'Prêt à commencer ton challenge hydratation ?',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // "C'est parti!" Button (only show if NOT embedded in flow)
            if (!isEmbedded) ...[
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : () => _saveProfileAndNavigate(user, goalInLiters),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'C\'est parti !',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              '🚀',
                              style: TextStyle(fontSize: 24),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 20),
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(child: content),
    );
  }

  /// Build a recap item row
  Widget _buildRecapItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text(
            '• ',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            '$label: ',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  /// Get gender label in French
  String _getGenderLabel(Gender gender) {
    switch (gender) {
      case Gender.male:
        return 'Homme';
      case Gender.female:
        return 'Femme';
      case Gender.other:
        return 'Autre';
    }
  }

  /// Get activity level label in French
  String _getActivityLabel(ActivityLevel level) {
    switch (level) {
      case ActivityLevel.sedentary:
        return 'Sédentaire';
      case ActivityLevel.light:
        return 'Activité légère';
      case ActivityLevel.moderate:
        return 'Activité modérée';
      case ActivityLevel.veryActive:
        return 'Très actif';
      case ActivityLevel.extremelyActive:
        return 'Extrêmement actif';
    }
  }

  /// Save user profile and navigate to Home
  Future<void> _saveProfileAndNavigate(User user, double goalInLiters) async {
    setState(() {
      _isSaving = true;
    });

    try {
      final userRepository = getIt<UserRepository>();

      // User already has the calculated goal, just save it
      // Save profile to database
      await userRepository.saveProfile(user);

      // Mark onboarding as complete
      ref.read(onboardingProvider.notifier).complete();

      if (!mounted) return;

      // Navigate to Home (replace to prevent going back to onboarding)
      Navigator.of(context).pushReplacementNamed('/home');
    } catch (e) {
      setState(() {
        _isSaving = false;
      });

      if (!mounted) return;

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erreur lors de la sauvegarde du profil: ${e.toString()}',
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
