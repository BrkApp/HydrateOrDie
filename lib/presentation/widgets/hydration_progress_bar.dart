import 'package:flutter/material.dart';

/// Hydration progress bar widget (AC #3)
///
/// Displays current hydration progress with:
/// - Animated fill bar with gradient
/// - Percentage and volume display
/// - Smooth animation (500ms) on updates
class HydrationProgressBar extends StatelessWidget {
  /// Current hydration volume in milliliters
  final int currentVolume;

  /// Daily hydration goal in milliliters
  final int goalVolume;

  /// Height of the progress bar (default: 40px per spec)
  final double height;

  const HydrationProgressBar({
    super.key,
    required this.currentVolume,
    required this.goalVolume,
    this.height = 40.0,
  });

  /// Calculate progress percentage (0.0 to 1.0) for bar width (clamped)
  double get _progressClamped {
    if (goalVolume <= 0) return 0.0;
    final progress = currentVolume / goalVolume;
    return progress.clamp(0.0, 1.0);
  }

  /// Calculate actual percentage for display (can be > 100%)
  int get _percentageDisplay {
    if (goalVolume <= 0) return 0;
    return ((currentVolume / goalVolume) * 100).round();
  }

  /// Format volume in liters (e.g., "1.5L")
  String _formatVolume(int volumeMl) {
    final liters = volumeMl / 1000.0;
    return '${liters.toStringAsFixed(1)}L';
  }

  @override
  Widget build(BuildContext context) {
    final percentage = _percentageDisplay;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFE0E0E0), // Background gray (spec ligne 1262)
        borderRadius: BorderRadius.circular(8.0), // Radius 8px (spec ligne 1261)
      ),
      child: Stack(
        children: [
          // Animated fill bar with gradient (spec lignes 1263-1265)
          AnimatedContainer(
            duration: const Duration(milliseconds: 500), // Smooth fill 500ms
            curve: Curves.easeInOut,
            width: MediaQuery.of(context).size.width * _progressClamped,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF64B5F6), // Light blue
                  Color(0xFF2196F3), // Hydration blue
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),

          // Progress text overlay (spec ligne 1264)
          Center(
            child: Text(
              '$percentage% • ${_formatVolume(currentVolume)} / ${_formatVolume(goalVolume)}',
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14.0,
                fontWeight: FontWeight.w600, // semi-bold
              ),
            ),
          ),
        ],
      ),
    );
  }
}
