import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

/// Paramètres généraux de l'application
@freezed
class AppSettings with _$AppSettings {
  const factory AppSettings({
    @Default('fr') String language,
    @Default('default') String theme,
    @Default(true) bool darkMode,
    @Default(250.0) double defaultIntakeAmount, // ml par prise
    @Default(true) bool hapticFeedback,
    @Default(true) bool soundEffects,
    @Default(false) bool onboardingCompleted,
    @Default(false) bool isPremium,
    String? premiumExpiryDate,
    @Default(0.7) double mlConfidenceThreshold, // Seuil ML pour accepter photo
    @Default(true) bool strictMode, // Mode strict: rejette photos suspectes
    DateTime? lastBackupDate,
    @Default(false) bool analyticsEnabled,
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);

  static AppSettings createDefault() {
    return const AppSettings();
  }
}

const AppSettings _$AppSettingsConst = AppSettings;

extension AppSettingsX on AppSettings {
  /// Vérifie si le premium est actif
  bool get isPremiumActive {
    if (!isPremium) return false;
    if (premiumExpiryDate == null) return true; // Premium à vie

    final expiry = DateTime.tryParse(premiumExpiryDate!);
    if (expiry == null) return false;

    return DateTime.now().isBefore(expiry);
  }

  /// Active le premium
  AppSettings activatePremium({DateTime? expiryDate}) {
    return copyWith(
      isPremium: true,
      premiumExpiryDate: expiryDate?.toIso8601String(),
    );
  }

  /// Complète l'onboarding
  AppSettings completeOnboarding() {
    return copyWith(onboardingCompleted: true);
  }

  /// Change la langue
  AppSettings changeLanguage(String newLanguage) {
    return copyWith(language: newLanguage);
  }

  /// Change le thème
  AppSettings changeTheme(String newTheme) {
    return copyWith(theme: newTheme);
  }

  /// Toggle dark mode
  AppSettings toggleDarkMode() {
    return copyWith(darkMode: !darkMode);
  }
}
