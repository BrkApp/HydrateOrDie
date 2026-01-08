/// Avatar personality types for MVP
///
/// Each personality has a unique communication style for notifications
enum AvatarPersonality {
  /// Mère Autoritaire - Authoritarian but caring
  authoritarianMother,

  /// Coach Sportif - Extreme motivation and energy
  sportsCoach,

  /// Docteur - Scientific and medical approach
  doctor,

  /// Ami Sarcastique - Sarcasm and dark humor
  sarcasticFriend,
}

extension AvatarPersonalityExtension on AvatarPersonality {
  /// Display name for UI
  String get displayName {
    switch (this) {
      case AvatarPersonality.authoritarianMother:
        return 'Mère Autoritaire';
      case AvatarPersonality.sportsCoach:
        return 'Coach Sportif';
      case AvatarPersonality.doctor:
        return 'Docteur';
      case AvatarPersonality.sarcasticFriend:
        return 'Ami Sarcastique';
    }
  }

  /// Description for personality selection screen
  String get description {
    switch (this) {
      case AvatarPersonality.authoritarianMother:
        return 'Elle ne rigole pas avec ta santé. Autoritaire mais bienveillante.';
      case AvatarPersonality.sportsCoach:
        return 'Motivation extrême et énergie débordante. NO PAIN NO GAIN !';
      case AvatarPersonality.doctor:
        return 'Approche scientifique et médicale. Diagnostic sans filtre.';
      case AvatarPersonality.sarcasticFriend:
        return 'Sarcasme et humour noir. Ton meilleur pote qui te taquine.';
    }
  }
}
