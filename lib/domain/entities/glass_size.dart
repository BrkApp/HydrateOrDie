/// Glass size enum for drink entry
///
/// Predefined glass sizes with associated volume in liters
enum GlassSize {
  /// Petit verre - 200ml
  small,

  /// Verre moyen - 250ml
  medium,

  /// Grand verre - 400ml
  large,
}

extension GlassSizeExtension on GlassSize {
  /// Get volume in liters for this glass size
  double get volumeLiters {
    switch (this) {
      case GlassSize.small:
        return 0.2; // 200ml
      case GlassSize.medium:
        return 0.25; // 250ml
      case GlassSize.large:
        return 0.4; // 400ml
    }
  }

  /// Get display name for UI
  String get displayName {
    switch (this) {
      case GlassSize.small:
        return 'Petit verre (200ml)';
      case GlassSize.medium:
        return 'Verre moyen (250ml)';
      case GlassSize.large:
        return 'Grand verre (400ml)';
    }
  }
}
