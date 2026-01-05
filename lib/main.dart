import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import 'core/theme/app_theme.dart';
import 'data/datasources/local_storage.dart';
import 'presentation/splash/splash_screen.dart';

/// Point d'entrée de l'application HydrateOrDie
void main() async {
  // Assurer l'initialisation de Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Logger global
  final logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: true,
    ),
  );

  logger.i('🚀 Starting HydrateOrDie...');

  try {
    // Initialiser le storage local
    await LocalStorage().init();
    logger.i('✅ Local storage initialized');

    // Configuration de l'orientation (portrait uniquement)
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    logger.i('✅ Orientation locked to portrait');

    // Configuration de la barre de statut
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    logger.i('✅ System UI configured');

    // Lancer l'application
    runApp(
      ProviderScope(
        child: const HydrateOrDieApp(),
      ),
    );

    logger.i('✅ App launched successfully');
  } catch (e, stackTrace) {
    logger.e('❌ Error during initialization', error: e, stackTrace: stackTrace);
    // En production, on pourrait afficher un écran d'erreur
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Erreur d\'initialisation',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Veuillez redémarrer l\'application',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget racine de l'application
class HydrateOrDieApp extends ConsumerWidget {
  const HydrateOrDieApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Récupérer les paramètres (pour l'instant en dur, sera géré par Riverpod)
    final isDarkMode = false; // TODO: Lire depuis AppSettings
    final locale = const Locale('fr', 'FR'); // TODO: Lire depuis AppSettings

    return MaterialApp(
      title: 'HydrateOrDie',
      debugShowCheckedModeBanner: false,

      // Thème
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

      // Localisation
      locale: locale,
      supportedLocales: const [
        Locale('fr', 'FR'),
        Locale('en', 'US'),
      ],

      // Routes
      home: const SplashScreen(),

      // Configuration
      builder: (context, child) {
        // Configuration globale de l'UI
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(1.0), // Pas de scaling du texte
          ),
          child: child!,
        );
      },
    );
  }
}
