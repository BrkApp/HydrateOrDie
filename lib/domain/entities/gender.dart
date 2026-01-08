/// Gender enum for user profile
///
/// Used in hydration goal calculation with gender-specific multipliers
enum Gender {
  /// Male (multiplicateur 1.0)
  male,

  /// Female (multiplicateur 0.95)
  female,

  /// Other (multiplicateur 1.0)
  other,
}
