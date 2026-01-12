import 'package:flutter/material.dart';
import 'package:hydrate_or_die/domain/entities/avatar_personality.dart';
import 'package:hydrate_or_die/domain/entities/avatar_state.dart';

/// Avatar message widget (AC #3)
///
/// Displays personalized message based on:
/// - Avatar personality (doctor/coach/mother/friend)
/// - Current state (fresh/tired/dehydrated/dead)
/// - Color-coded text according to state
class AvatarMessageWidget extends StatelessWidget {
  /// Avatar personality determining message tone
  final AvatarPersonality personality;

  /// Current avatar state determining message and color
  final AvatarState state;

  /// Font size (default: 16px per spec ligne 1253)
  final double fontSize;

  const AvatarMessageWidget({
    super.key,
    required this.personality,
    required this.state,
    this.fontSize = 16.0,
  });

  /// Get personalized message based on personality and state (AC #3)
  ///
  /// Messages examples from prompt (lignes 101-105):
  /// - Doctor Fresh: "Votre hydratation est optimale 💙"
  /// - Coach Tired: "Allez champion, bois maintenant ! 💪"
  /// - Mother Dehydrated: "Tu veux que je m'inquiète ?! 😟"
  /// - Friend Dead: "Mec, j'ai crevé... 💀"
  String _getMessage() {
    switch (personality) {
      case AvatarPersonality.doctor:
        switch (state) {
          case AvatarState.fresh:
            return 'Votre hydratation est optimale 💙';
          case AvatarState.tired:
            return 'Votre niveau hydrique baisse... 💧';
          case AvatarState.dehydrated:
            return 'Déshydratation critique détectée ! ⚠️';
          case AvatarState.dead:
            return 'Décès par déshydratation... 💀';
          case AvatarState.ghost:
            return 'Le patient est décédé... Résurrection prévue demain. 👻';
        }
      case AvatarPersonality.sportsCoach:
        switch (state) {
          case AvatarState.fresh:
            return 'Super forme champion ! 💪';
          case AvatarState.tired:
            return 'Allez champion, bois maintenant ! 💪';
          case AvatarState.dehydrated:
            return 'On lâche rien ! BOIS ! 🔥';
          case AvatarState.dead:
            return 'K.O. technique... 💀';
          case AvatarState.ghost:
            return 'Repos forcé... On reprend l\'entraînement demain! 👻';
        }
      case AvatarPersonality.authoritarianMother:
        switch (state) {
          case AvatarState.fresh:
            return 'Très bien mon petit ! 😊';
          case AvatarState.tired:
            return 'N\'oublie pas de boire chéri... 💙';
          case AvatarState.dehydrated:
            return 'Tu veux que je m\'inquiète ?! 😟';
          case AvatarState.dead:
            return 'Je te l\'avais dit... 💀';
          case AvatarState.ghost:
            return 'Tu vois ce que tu as fait ?! Demain, tu fais mieux. 👻';
        }
      case AvatarPersonality.sarcasticFriend:
        switch (state) {
          case AvatarState.fresh:
            return 'Nickel poto ! 😎';
          case AvatarState.tired:
            return 'T\'as l\'air fatigué mec... 😐';
          case AvatarState.dehydrated:
            return 'Bois quelque chose bordel ! 😱';
          case AvatarState.dead:
            return 'Mec, j\'ai crevé... 💀';
          case AvatarState.ghost:
            return 'GG, t\'es mort... Respawn demain mec. 👻';
        }
    }
  }

  /// Get text color based on state (spec lignes 1253-1258)
  Color _getTextColor() {
    switch (state) {
      case AvatarState.fresh:
        return const Color(0xFF4CAF50); // Green
      case AvatarState.tired:
        return const Color(0xFFFF9800); // Orange
      case AvatarState.dehydrated:
        return const Color(0xFFF44336); // Red
      case AvatarState.dead:
        return const Color(0xFFF44336); // Red
      case AvatarState.ghost:
        return const Color(0xFF9E9E9E); // Gray
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _getMessage(),
      style: TextStyle(
        fontSize: fontSize,
        color: _getTextColor(),
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.center,
    );
  }
}
