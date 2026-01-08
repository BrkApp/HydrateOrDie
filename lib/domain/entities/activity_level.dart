/// Activity level enum for user profile
///
/// Used in hydration goal calculation with activity-specific multipliers
enum ActivityLevel {
  /// Sédentaire (multiplicateur 1.0)
  sedentary,

  /// Léger 1-3x/semaine (multiplicateur 1.1)
  light,

  /// Modéré 3-5x/semaine (multiplicateur 1.2)
  moderate,

  /// Très actif 6-7x/semaine (multiplicateur 1.3)
  veryActive,

  /// Extrêmement actif - sport intense quotidien (multiplicateur 1.5)
  extremelyActive,
}
