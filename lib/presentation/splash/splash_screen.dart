import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Écran de chargement initial
/// Vérifie l'état de l'onboarding et redirige vers l'écran approprié
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  /// Initialise l'application et redirige vers l'écran approprié
  Future<void> _initialize() async {
    // Attendre un minimum de temps pour l'animation
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // TODO: Vérifier si l'onboarding est complété
    // final storage = LocalStorage();
    // final settings = storage.getAppSettings();
    //
    // if (settings.onboardingCompleted) {
    //   // Aller au dashboard
    //   Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(builder: (_) => const DashboardScreen()),
    //   );
    // } else {
    //   // Aller à l'onboarding
    //   Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(builder: (_) => const OnboardingScreen()),
    //   );
    // }

    // Pour l'instant, juste afficher un message
    // Les écrans seront créés en Phase 2
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.secondary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo/Icône
            Icon(
              Icons.water_drop,
              size: 120,
              color: Colors.white,
            )
                .animate()
                .scale(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.elasticOut,
                )
                .then()
                .shimmer(
                  duration: const Duration(milliseconds: 1200),
                  color: Colors.white.withOpacity(0.5),
                ),

            const SizedBox(height: 32),

            // Titre
            Text(
              'HydrateOrDie',
              style: theme.textTheme.headlineLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            )
                .animate()
                .fadeIn(
                  delay: const Duration(milliseconds: 300),
                  duration: const Duration(milliseconds: 600),
                )
                .slideY(
                  begin: 0.3,
                  end: 0,
                  curve: Curves.easeOut,
                ),

            const SizedBox(height: 8),

            // Slogan
            Text(
              'Bois ou souffre',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.w500,
              ),
            )
                .animate()
                .fadeIn(
                  delay: const Duration(milliseconds: 600),
                  duration: const Duration(milliseconds: 600),
                ),

            const SizedBox(height: 48),

            // Indicateur de chargement
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white.withOpacity(0.8),
                ),
              ),
            )
                .animate()
                .fadeIn(
                  delay: const Duration(milliseconds: 900),
                  duration: const Duration(milliseconds: 600),
                ),

            const SizedBox(height: 16),

            // Texte de chargement
            Text(
              'Initialisation...',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withOpacity(0.7),
              ),
            )
                .animate()
                .fadeIn(
                  delay: const Duration(milliseconds: 1000),
                  duration: const Duration(milliseconds: 600),
                ),
          ],
        ),
      ),
    );
  }
}
