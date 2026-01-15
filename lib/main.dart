import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/di/injection.dart';
import 'presentation/screens/avatar_selection/avatar_selection_screen.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/onboarding/onboarding_flow_screen.dart';
import 'domain/repositories/avatar_repository.dart';
import 'domain/repositories/user_repository.dart';
import 'presentation/services/dehydration_timer_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with mock config
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Setup dependency injection
  await setupDependencies();

  // Start dehydration timer service (Epic 1 - Story 1.5)
  final dehydrationTimer = getIt<DehydrationTimerService>();
  dehydrationTimer.start();
  if (kDebugMode) {
    debugPrint('[Main] DehydrationTimerService started');
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

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
        '/onboarding': (_) => const OnboardingFlowScreen(),
      },
    );
  }
}

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

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
    final userRepository = getIt<UserRepository>();
    final avatarRepository = getIt<AvatarRepository>();

    // Check for user profile first (Epic 2 - Onboarding)
    final userProfile = await userRepository.getProfile();

    if (!mounted) return;

    if (userProfile == null) {
      // No profile → Start onboarding flow
      Navigator.of(context).pushReplacementNamed('/onboarding');
    } else {
      // Profile exists → Check avatar (Epic 1)
      final selectedAvatar = await avatarRepository.getAvatar();

      if (!mounted) return;

      if (selectedAvatar == null) {
        // Profile exists but no avatar → Avatar Selection
        Navigator.of(context).pushReplacementNamed('/avatar-selection');
      } else {
        // Profile and avatar exist → Home Screen
        Navigator.of(context).pushReplacementNamed('/home');
      }
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
