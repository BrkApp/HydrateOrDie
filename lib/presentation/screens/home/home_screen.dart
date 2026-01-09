import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydrate_or_die/presentation/providers/home_provider.dart';
import 'package:hydrate_or_die/presentation/widgets/avatar_display.dart';
import 'package:hydrate_or_die/presentation/widgets/avatar_message_widget.dart';
import 'package:hydrate_or_die/presentation/widgets/hydration_progress_bar.dart';

/// Home Screen - Main application screen with reactive avatar (AC #1-#8)
///
/// Displays:
/// - Header with logo, time, streak, and settings
/// - Avatar display (centered, 200x200px)
/// - Personalized message based on personality + state
/// - Hydration progress bar (placeholder for Story 1.6)
/// - Time since last drink
/// - "JE BOIS" button (UI only, non-functional)
/// - Bottom navigation (UI only)
///
/// Auto-refreshes every 60 seconds to reflect avatar state changes.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  /// Format elapsed time since last drink (AC #4)
  ///
  /// Examples:
  /// - "il y a 5 minutes"
  /// - "il y a 1h 30min"
  /// - "Jamais encore bu aujourd'hui" (if null)
  String _formatElapsedTime(DateTime? lastDrinkTime) {
    if (lastDrinkTime == null) {
      return 'Jamais encore bu aujourd\'hui';
    }

    final now = DateTime.now();
    final elapsed = now.difference(lastDrinkTime);

    if (elapsed.inHours > 0) {
      final hours = elapsed.inHours;
      final minutes = elapsed.inMinutes.remainder(60);
      return 'il y a ${hours}h ${minutes}min';
    } else if (elapsed.inMinutes > 0) {
      return 'il y a ${elapsed.inMinutes} minutes';
    } else {
      return 'À l\'instant';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header (spec lignes 1240-1244)
            _buildHeader(context),

            // Main content - scrollable
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 32),

                    // Avatar Display (AC #1, #2) - 200x200px centered
                    Center(
                      child: AvatarDisplay(
                        personality: homeState.personality,
                        state: homeState.state,
                        size: 200.0,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Avatar Message (AC #3)
                    AvatarMessageWidget(
                      personality: homeState.personality,
                      state: homeState.state,
                    ),

                    const SizedBox(height: 32),

                    // Progress Bar (AC #3) - Placeholder for Story 1.6
                    // Using hardcoded values: 0L / 2.5L (prompt ligne 202-204)
                    const HydrationProgressBar(
                      currentVolume: 0, // Placeholder
                      goalVolume: 2500, // Hardcoded 2.5L
                    ),

                    const SizedBox(height: 16),

                    // Last drink time (AC #4)
                    Text(
                      'Dernière hydratation:',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 18.0,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatElapsedTime(homeState.lastDrinkTime),
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // "JE BOIS" Button (AC #6) - UI only, non-functional
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
              child: _buildDrinkButton(),
            ),

            // Bottom Navigation (spec lignes 1276-1280) - UI only
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  /// Build header with logo, time, streak, settings (spec lignes 1240-1244)
  Widget _buildHeader(BuildContext context) {
    final now = DateTime.now();
    final timeStr = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // App logo + time
          const Text(
            '💧',
            style: TextStyle(fontSize: 24.0),
          ),
          const SizedBox(width: 8),
          Text(
            timeStr,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),

          const Spacer(),

          // Streak counter (placeholder "0 jours" - prompt ligne 205-206)
          const Text(
            '🔥',
            style: TextStyle(fontSize: 20.0),
          ),
          const SizedBox(width: 4),
          const Text(
            '0 jours',
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),

          const SizedBox(width: 16),

          // Settings icon
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black54),
            onPressed: () {
              // TODO: Navigate to settings (Story 1.6 - non-functional)
            },
          ),
        ],
      ),
    );
  }

  /// Build "JE BOIS" button (AC #6, spec lignes 1267-1274)
  Widget _buildDrinkButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      height: 56.0, // Spec ligne 1268
      child: ElevatedButton(
        onPressed: null, // Non-functional for Story 1.6 (prompt ligne 130)
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2196F3), // Bleu hydratation (spec ligne 1269)
          disabledBackgroundColor: const Color(0xFF2196F3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 2.0, // Shadow level 2 (spec ligne 1272)
        ),
        child: const Text(
          '💧 JE BOIS 💧',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// Build bottom navigation (spec lignes 1276-1280) - UI only
  Widget _buildBottomNavigation() {
    return Container(
      height: 56.0,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey[300]!,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.calendar_today, 'Calendrier', false),
          _buildNavItem(Icons.home, 'Home', true), // Active
          _buildNavItem(Icons.person, 'Profil', false),
        ],
      ),
    );
  }

  /// Build navigation item
  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    final color = isActive ? const Color(0xFF2196F3) : const Color(0xFF757575);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 24.0),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.0,
            color: color,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        if (isActive)
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 40.0,
            height: 3.0,
            decoration: const BoxDecoration(
              color: Color(0xFF2196F3),
              borderRadius: BorderRadius.all(Radius.circular(2.0)),
            ),
          ),
      ],
    );
  }
}
