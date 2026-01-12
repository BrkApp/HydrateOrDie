import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/di/injection.dart';
import 'presentation/screens/avatar_selection/avatar_selection_screen.dart';
import 'presentation/screens/home/home_screen.dart';
import 'domain/repositories/avatar_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with mock config
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Setup dependency injection
  await setupDependencies();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Hydrate or Die',
      theme: ThemeData(
        primaryColor: const Color(0xFF2196F3),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2196F3),
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(), // Détermine où aller
      routes: {
        '/home': (_) => const HomeScreen(),
        '/avatar-selection': (_) => const AvatarSelectionScreen(),
      },
    );
  }
}

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAvatarAndNavigate();
  }

  Future<void> _checkAvatarAndNavigate() async {
    final repository = getIt<AvatarRepository>();
    final selectedAvatar = await repository.getAvatar();

    if (!mounted) return;

    // AC #1 - Navigation conditionnelle
    if (selectedAvatar == null) {
      // Premier lancement → Avatar Selection
      Navigator.of(context).pushReplacementNamed('/avatar-selection');
    } else {
      // Avatar déjà sauvegardé → Home Screen
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
