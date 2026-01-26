import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/feedback_messages.dart';
import '../../providers/avatar_asset_provider.dart';
import '../../providers/home_provider.dart';
import '../../providers/hydration_logs_provider.dart';
import '../../providers/user_provider.dart';

/// Feedback screen shown after successful hydration validation
///
/// Displays avatar with positive animation, personalized message,
/// and hydration progress. Auto-dismisses after 4 seconds.
///
/// AC #1: Navigation from GlassSizeSelectionScreen with no parameters
/// AC #2: Avatar animation (scale 1.0→1.2→1.0, rotation -5°→+5°→0°)
/// AC #3: Personalized positive message based on avatar personality
/// AC #4: Sound effect REMOVED from MVP scope
/// AC #5: Hydration progress display (X.XL/X.XL + LinearProgressIndicator)
/// AC #6: Auto-dismiss after 4 seconds to HomeScreen
/// AC #7: "Continuer" button to skip and return immediately
/// AC #8: Widget tests validate animations, messages, progression
class FeedbackScreen extends ConsumerStatefulWidget {
  const FeedbackScreen({super.key});

  @override
  ConsumerState<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends ConsumerState<FeedbackScreen>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  Timer? _autoDismissTimer;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAutoDismissTimer();
  }

  /// Initialize scale and rotation animations
  ///
  /// AC #2: Scale animation 1.0→1.2→1.0 (800ms duration)
  /// AC #2: Rotation animation -5°→+5°→0° (600ms duration)
  /// Loops 2 times during 4-second display period
  void _initAnimations() {
    // Scale animation: 1.0 → 1.2 → 1.0 (800ms, repeats 2 times)
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 1.2,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.2,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_scaleController);

    // Rotation animation: -5° → +5° → 0° (600ms, repeats 2 times)
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _rotationAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween:
            Tween<double>(begin: -0.087, end: 0.087) // -5° to +5° in radians
                .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween:
            Tween<double>(begin: 0.087, end: 0.0) // +5° to 0° in radians
                .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(_rotationController);

    // Start animations and repeat 2 times (AC #2)
    // Using forward().then to repeat exactly 2 times
    _playAnimations();
  }

  /// Play animations 2 times (AC #2)
  Future<void> _playAnimations() async {
    // Play animations twice
    for (int i = 0; i < 2; i++) {
      await _scaleController.forward();
      _scaleController.reset();
      await _rotationController.forward();
      _rotationController.reset();
    }
  }

  /// Start auto-dismiss timer (AC #6)
  ///
  /// Returns to HomeScreen after 4 seconds automatically
  void _startAutoDismissTimer() {
    _autoDismissTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) {
        // Invalidate logs provider to refresh HomeScreen progress bar
        ref.invalidate(hydrationLogsProvider);
        Navigator.of(context).pop();
      }
    });
  }

  /// Cancel timer and return to HomeScreen immediately (AC #7)
  void _skipAndContinue() {
    _autoDismissTimer?.cancel();
    // Invalidate logs provider to refresh HomeScreen progress bar
    ref.invalidate(hydrationLogsProvider);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    // Cancel timer to prevent memory leak
    _autoDismissTimer?.cancel();
    _scaleController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeProvider);
    final userAsync = ref.watch(userProvider);
    final avatarAssets = ref.watch(avatarAssetProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Animated Avatar (AC #2)
              AnimatedBuilder(
                animation: Listenable.merge([
                  _scaleController,
                  _rotationController,
                ]),
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Transform.rotate(
                      angle: _rotationAnimation.value,
                      child: child,
                    ),
                  );
                },
                child: Text(
                  avatarAssets.getEmojiAsset(
                    homeState.personality,
                    homeState.state,
                  ),
                  style: const TextStyle(fontSize: 120),
                  key: const Key('feedback_avatar'),
                ),
              ),

              const SizedBox(height: 32),

              // Personalized Message (AC #3)
              Text(
                kFeedbackMessages[homeState.personality] ?? '',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
                textAlign: TextAlign.center,
                key: const Key('feedback_message'),
              ),

              const SizedBox(height: 48),

              // Hydration Progress (AC #5)
              userAsync.when(
                data: (user) {
                  if (user == null) {
                    return const SizedBox.shrink();
                  }

                  // TODO: Get actual volume consumed today from HydrationLogRepository
                  // For now using placeholder 0.0 - Story 3.6 will provide this data
                  final volumeToday = 0.0;
                  final dailyGoal = user.dailyGoal.targetLiters;
                  final progress = (volumeToday / dailyGoal).clamp(0.0, 1.0);
                  final isGoalReached = progress >= 1.0;

                  return Column(
                    children: [
                      // Progress text (AC #5)
                      Text(
                        'Tu as bu ${volumeToday.toStringAsFixed(1)}L sur ${dailyGoal.toStringAsFixed(1)}L aujourd\'hui',
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                        key: const Key('feedback_progress_text'),
                      ),
                      const SizedBox(height: 16),

                      // Progress bar (AC #5)
                      LinearProgressIndicator(
                        value: progress,
                        minHeight: 12,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isGoalReached
                              ? Colors.green
                              : Theme.of(context).colorScheme.primary,
                        ),
                        borderRadius: BorderRadius.circular(6),
                        key: const Key('feedback_progress_bar'),
                      ),
                    ],
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (error, _) => const SizedBox.shrink(),
              ),

              const Spacer(),

              // "Continuer" button (AC #7)
              TextButton(
                onPressed: _skipAndContinue,
                key: const Key('feedback_continue_button'),
                child: const Text('Continuer'),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
