import 'package:flutter/material.dart';

/// Context that indicates whether onboarding screens are embedded in OnboardingFlowScreen
///
/// When embedded=true:
/// - Individual screens should NOT show AppBar
/// - Individual screens should NOT show navigation buttons (Next/Back)
/// - Navigation is handled by the parent OnboardingFlowScreen
///
/// When embedded=false (default):
/// - Screens show full UI including AppBar and navigation buttons
/// - Used for direct navigation or testing individual screens
class EmbeddedOnboardingContext extends InheritedWidget {
  /// Whether the screens are embedded in a flow container
  final bool isEmbedded;

  /// Callback to move to next step (provided by parent flow)
  final VoidCallback? onNext;

  /// Callback to move to previous step (provided by parent flow)
  final VoidCallback? onBack;

  const EmbeddedOnboardingContext({
    super.key,
    required super.child,
    this.isEmbedded = false,
    this.onNext,
    this.onBack,
  });

  /// Get the nearest EmbeddedOnboardingContext from the widget tree
  static EmbeddedOnboardingContext? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<EmbeddedOnboardingContext>();
  }

  /// Get the nearest EmbeddedOnboardingContext, or return default (not embedded)
  static EmbeddedOnboardingContext of(BuildContext context) {
    final result = maybeOf(context);
    return result ?? const EmbeddedOnboardingContext(child: SizedBox.shrink());
  }

  @override
  bool updateShouldNotify(EmbeddedOnboardingContext oldWidget) {
    return isEmbedded != oldWidget.isEmbedded ||
        onNext != oldWidget.onNext ||
        onBack != oldWidget.onBack;
  }
}
