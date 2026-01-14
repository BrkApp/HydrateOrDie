import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydrate_or_die/presentation/providers/onboarding_provider.dart';

/// Onboarding Screen - Step 1: Weight Input
///
/// Allows user to enter their weight in kg or lbs.
/// Validates input (30-300kg or 66-661lbs) before allowing progression.
class OnboardingWeightScreen extends ConsumerStatefulWidget {
  const OnboardingWeightScreen({super.key});

  @override
  ConsumerState<OnboardingWeightScreen> createState() =>
      _OnboardingWeightScreenState();
}

class _OnboardingWeightScreenState
    extends ConsumerState<OnboardingWeightScreen> {
  final TextEditingController _weightController = TextEditingController();
  bool _isKg = true; // Default unit: kg
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    // Pre-fill weight if already set in state
    final onboardingState = ref.read(onboardingProvider);
    if (onboardingState.weight != null) {
      _weightController.text = onboardingState.weight!.toStringAsFixed(1);
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  /// Convert lbs to kg
  double _lbsToKg(double lbs) => lbs * 0.453592;

  /// Convert kg to lbs
  double _kgToLbs(double kg) => kg * 2.20462;

  /// Validate weight input
  bool _validateWeight() {
    final text = _weightController.text.trim();

    if (text.isEmpty) {
      setState(() {
        _errorMessage = 'Veuillez entrer votre poids';
      });
      return false;
    }

    final weight = double.tryParse(text);

    if (weight == null) {
      setState(() {
        _errorMessage = 'Veuillez entrer un nombre valide';
      });
      return false;
    }

    // Validate range based on unit
    if (_isKg) {
      if (weight < 30 || weight > 300) {
        setState(() {
          _errorMessage = 'Le poids doit être entre 30 et 300 kg';
        });
        return false;
      }
    } else {
      // lbs: 30kg ≈ 66lbs, 300kg ≈ 661lbs
      if (weight < 66 || weight > 661) {
        setState(() {
          _errorMessage = 'Le poids doit être entre 66 et 661 lbs';
        });
        return false;
      }
    }

    setState(() {
      _errorMessage = null;
    });

    return true;
  }

  /// Handle unit toggle (kg/lbs)
  void _toggleUnit(bool isKg) {
    final text = _weightController.text.trim();

    // Convert existing value when switching units
    if (text.isNotEmpty) {
      final currentWeight = double.tryParse(text);
      if (currentWeight != null) {
        if (isKg && !_isKg) {
          // Switching from lbs to kg
          final kg = _lbsToKg(currentWeight);
          _weightController.text = kg.toStringAsFixed(1);
        } else if (!isKg && _isKg) {
          // Switching from kg to lbs
          final lbs = _kgToLbs(currentWeight);
          _weightController.text = lbs.toStringAsFixed(1);
        }
      }
    }

    setState(() {
      _isKg = isKg;
      _errorMessage = null;
    });
  }

  /// Handle next button press
  void _handleNext() {
    if (!_validateWeight()) return;

    final text = _weightController.text.trim();
    final weight = double.parse(text);

    // Convert to kg if in lbs
    final weightInKg = _isKg ? weight : _lbsToKg(weight);

    // Update state via provider
    ref.read(onboardingProvider.notifier).updateWeight(weightInKg);

    // Check for errors from provider validation
    final errorMessage = ref.read(onboardingProvider).errorMessage;
    if (errorMessage != null) {
      setState(() {
        _errorMessage = errorMessage;
      });
      ref.read(onboardingProvider.notifier).clearError();
      return;
    }

    // Navigate to next screen (Age screen - Story 2.5)
    Navigator.of(context).pushNamed('/onboarding_age');
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
                'Étape 1 sur 5',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Title
              Text(
                'Quel est ton poids ?',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Subtitle
              Text(
                'Nécessaire pour calculer ton objectif d\'hydratation',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Unit toggle (kg/lbs)
              ToggleButtons(
                isSelected: [_isKg, !_isKg],
                onPressed: (index) {
                  _toggleUnit(index == 0);
                },
                borderRadius: BorderRadius.circular(8),
                constraints: const BoxConstraints(
                  minWidth: 100,
                  minHeight: 48,
                ),
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text('kg'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text('lbs'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Weight input field
              TextField(
                controller: _weightController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                decoration: InputDecoration(
                  labelText: 'Poids',
                  suffixText: _isKg ? 'kg' : 'lbs',
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
