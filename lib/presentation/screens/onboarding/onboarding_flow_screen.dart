import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydrate_or_die/presentation/providers/onboarding_provider.dart';
import 'package:hydrate_or_die/presentation/screens/onboarding/onboarding_weight_screen.dart';
import 'package:hydrate_or_die/presentation/screens/onboarding/onboarding_age_screen.dart';
import 'package:hydrate_or_die/presentation/screens/onboarding/onboarding_gender_screen.dart';
import 'package:hydrate_or_die/presentation/screens/onboarding/onboarding_activity_screen.dart';
import 'package:hydrate_or_die/presentation/screens/onboarding/onboarding_location_screen.dart';
import 'package:hydrate_or_die/presentation/screens/onboarding/onboarding_summary_screen.dart';
import 'package:hydrate_or_die/presentation/widgets/embedded_onboarding_context.dart';

/// Onboarding Flow Screen - Container for multi-step onboarding
///
/// Manages sequential navigation through 6 onboarding steps:
/// 1. Weight
/// 2. Age
/// 3. Gender
/// 4. Activity Level
/// 5. Location (optional)
/// 6. Summary
///
/// Features:
/// - PageView with horizontal swipe (disabled - navigation via buttons only)
/// - Progress bar showing current step (1/6, 2/6, etc.)
/// - Back/Next navigation buttons
/// - State managed by OnboardingProvider
class OnboardingFlowScreen extends ConsumerStatefulWidget {
  const OnboardingFlowScreen({super.key});

  @override
  ConsumerState<OnboardingFlowScreen> createState() =>
      _OnboardingFlowScreenState();
}

class _OnboardingFlowScreenState extends ConsumerState<OnboardingFlowScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  // List of onboarding screens
  final List<Widget> _screens = const [
    OnboardingWeightScreen(),
    OnboardingAgeScreen(),
    OnboardingGenderScreen(),
    OnboardingActivityScreen(),
    OnboardingLocationScreen(),
    OnboardingSummaryScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    // Reset onboarding state when entering flow
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(onboardingProvider.notifier).reset();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Navigate to next page
  void _goToNextPage() {
    if (_currentPage < _screens.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Navigate to previous page
  void _goToPreviousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Check if current step can proceed to next
  bool _canProceed() {
    // Use ref.watch() to rebuild when provider state changes
    final onboardingState = ref.watch(onboardingProvider);

    switch (_currentPage) {
      case 0: // Weight
        return onboardingState.isWeightValid;
      case 1: // Age
        return onboardingState.isAgeValid;
      case 2: // Gender
        return onboardingState.isGenderValid;
      case 3: // Activity Level
        return onboardingState.isActivityLevelValid;
      case 4: // Location (optional - always can proceed)
        return true;
      case 5: // Summary (last step)
        return onboardingState.canComplete;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentPage == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _currentPage > 0) {
          _goToPreviousPage();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: _currentPage > 0
              ? IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black87),
                  onPressed: _goToPreviousPage,
                )
              : null,
          title: _buildProgressIndicator(),
          centerTitle: true,
        ),
        body: EmbeddedOnboardingContext(
          isEmbedded: true,
          onNext: _goToNextPage,
          onBack: _goToPreviousPage,
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(), // Disable swipe - buttons only
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: _screens,
          ),
        ),
        bottomNavigationBar: _buildBottomBar(),
      ),
    );
  }

  /// Build progress indicator showing current step
  Widget _buildProgressIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        _screens.length,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: index == _currentPage ? 32 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: index == _currentPage
                ? Theme.of(context).primaryColor
                : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  /// Build bottom navigation bar with Next button
  Widget _buildBottomBar() {
    final canProceed = _canProceed();
    final isLastPage = _currentPage == _screens.length - 1;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Step counter text
            Text(
              'Étape ${_currentPage + 1}/${_screens.length}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),

            // Next/Finish button
            if (!isLastPage)
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: canProceed ? _goToNextPage : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: canProceed ? 2 : 0,
                  ),
                  child: const Text(
                    'Suivant',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

            // Skip button for location step only
            if (_currentPage == 4)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: TextButton(
                  onPressed: _goToNextPage,
                  child: const Text(
                    'Passer cette étape',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
