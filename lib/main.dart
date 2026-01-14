import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/di/injection.dart';
import 'presentation/screens/avatar_selection/avatar_selection_screen.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/onboarding/onboarding_weight_screen.dart';
import 'presentation/screens/onboarding/onboarding_age_screen.dart';
import 'domain/repositories/avatar_repository.dart';
import 'domain/repositories/user_repository.dart'; // Import User Repo
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
  print('[Main] DehydrationTimerService started');

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
        '/onboarding_weight': (_) => const OnboardingWeightScreen(),
        '/onboarding_age': (_) => const OnboardingAgeScreen(),
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
    _initializeAppAndNavigate();
  }

  Future<void> _initializeAppAndNavigate() async {
    // Get both repositories
    final userProfileRepository = getIt<UserRepository>();
    final avatarRepository = getIt<AvatarRepository>();

    // Check for user profile first (Epic 2 logic)
    final userProfile = await userProfileRepository.getUser();

    if (!mounted) return;

    if (userProfile == null) {
      // If no profile, user is new -> start onboarding
      Navigator.of(context).pushReplacementNamed('/onboarding_weight');
    } else {
      // If profile exists, check for avatar (Epic 1 logic)
      final selectedAvatar = await avatarRepository.getAvatar();
      if (!mounted) return;

      if (selectedAvatar == null) {
        // Profile exists but no avatar -> Avatar Selection
        Navigator.of(context).pushReplacementNamed('/avatar-selection');
      } else {
        // Profile and avatar exist -> Home Screen
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
