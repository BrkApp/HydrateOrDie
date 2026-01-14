import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydrate_or_die/presentation/providers/onboarding_provider.dart';

/// Onboarding Screen - Step 2: Age Input
///
/// Allows user to enter their age in years.
/// Validates input (10-120 years) before allowing progression.
class OnboardingAgeScreen extends ConsumerStatefulWidget {
  const OnboardingAgeScreen({super.key});

  @override
  ConsumerState<OnboardingAgeScreen> createState() =>
      _OnboardingAgeScreenState();
}

class _OnboardingAgeScreenState extends ConsumerState<OnboardingAgeScreen> {
  final TextEditingController _ageController = TextEditingController();
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    // Pre-fill age if already set in state
    final onboardingState = ref.read(onboardingProvider);
    if (onboardingState.age != null) {
      _ageController.text = onboardingState.age!.toString();
    }
  }

  @override
  void dispose() {
    _ageController.dispose();
    super.dispose();
  }

  /// Validate age input
  bool _validateAge() {
    final text = _ageController.text.trim();

    if (text.isEmpty) {
      setState(() {
        _errorMessage = 'Veuillez entrer votre âge';
      });
      return false;
    }

    final age = int.tryParse(text);

    if (age == null) {
      setState(() {
        _errorMessage = 'Veuillez entrer un nombre valide';
      });
      return false;
    }

    // Validate range (10-120 years)
    if (age < 10 || age > 120) {
      setState(() {
        _errorMessage = 'L\'âge doit être entre 10 et 120 ans';
      });
      return false;
    }

    setState(() {
      _errorMessage = null;
    });

    return true;
  }

  /// Handle next button press
  void _handleNext() {
    if (!_validateAge()) return;

    final text = _ageController.text.trim();
    final age = int.parse(text);

    // Update state via provider
    ref.read(onboardingProvider.notifier).updateAge(age);

    // Check for errors from provider validation
    final errorMessage = ref.read(onboardingProvider).errorMessage;
    if (errorMessage != null) {
      setState(() {
        _errorMessage = errorMessage;
      });
      ref.read(onboardingProvider.notifier).clearError();
      return;
    }

    // Navigate to next screen (Gender screen - Story 2.6)
    Navigator.of(context).pushNamed('/onboarding_gender');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Progress indicator
              Text(
                'Étape 2 sur 5',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Title
              Text(
                'Quel âge as-tu ?',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Subtitle
              Text(
                'Ton besoin en eau varie selon l\'âge',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Age input field
              TextField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  labelText: 'Âge',
                  suffixText: 'ans',
                  errorText: _errorMessage,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                ),
                onChanged: (_) {
                  // Clear error when user starts typing
                  if (_errorMessage != null) {
                    setState(() {
                      _errorMessage = null;
                    });
                  }
                },
              ),
              const Spacer(),

              // Next button
              ElevatedButton(
                onPressed: _handleNext,
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
          ),
        ),
      ),
    );
  }
}
