import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/avatar_personality.dart';
import '../../domain/entities/avatar_state.dart';
import '../providers/avatar_asset_provider.dart';

/// Widget to display avatar based on personality and state
///
/// Shows emoji placeholder for the avatar. In future versions,
/// this will load and display actual PNG images.
///
/// Example:
/// ```dart
/// AvatarDisplay(
///   personality: AvatarPersonality.doctor,
///   state: AvatarState.fresh,
///   size: 200.0,
/// )
/// ```
class AvatarDisplay extends ConsumerWidget {
  /// Avatar personality type
  final AvatarPersonality personality;

  /// Current avatar state
  final AvatarState state;

  /// Display size (width and height)
  final double size;

  /// Optional background color
  final Color? backgroundColor;

  /// Creates an avatar display widget
  ///
  /// [personality] Avatar personality (doctor, coach, mother, friend)
  /// [state] Avatar state (fresh, tired, dehydrated, dead, ghost)
  /// [size] Display size in logical pixels (default: 150.0)
  /// [backgroundColor] Optional background color (default: transparent)
  const AvatarDisplay({
    required this.personality,
    required this.state,
    this.size = 150.0,
    this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assetProvider = ref.watch(avatarAssetProvider);
    final emoji = assetProvider.getEmojiAsset(personality, state);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? _getStateBackgroundColor(state),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          emoji,
          style: TextStyle(
            fontSize: size * 0.5, // Emoji takes 50% of container size
            height: 1.0,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  /// Get background color based on avatar state
  ///
  /// Returns color matching the state:
  /// - fresh: Light green
  /// - tired: Light yellow
  /// - dehydrated: Light orange
  /// - dead: Light red
  /// - ghost: Light gray
  Color _getStateBackgroundColor(AvatarState state) {
    switch (state) {
      case AvatarState.fresh:
        return const Color(0xFFE8F5E9); // Light green
      case AvatarState.tired:
        return const Color(0xFFFFF9C4); // Light yellow
      case AvatarState.dehydrated:
        return const Color(0xFFFFE0B2); // Light orange
      case AvatarState.dead:
        return const Color(0xFFFFCDD2); // Light red
      case AvatarState.ghost:
        return const Color(0xFFEEEEEE); // Light gray
    }
  }
}
