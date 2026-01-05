import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

/// Paramètres généraux de l'application
@freezed
@HiveType(typeId: 7)
class AppSettings with _$AppSettings {
  const factory AppSettings({
    @HiveField(0) @Default('fr') String language,
    @HiveField(1) @Default('default') String theme,
    @HiveField(2) @Default(true) bool darkMode,
    @HiveField(3) @Default(250.0) double defaultIntakeAmount, // ml par prise
    @HiveField(4) @Default(true) bool hapticFeedback,
    @HiveField(5) @Default(true) bool soundEffects,
    @HiveField(6) @Default(false) bool onboardingCompleted,
    @HiveField(7) @Default(false) bool isPremium,
    @HiveField(8) String? premiumExpiryDate,
    @HiveField(9) @Default(0.7) double mlConfidenceThreshold, // Seuil ML pour accepter photo
    @HiveField(10) @Default(true) bool strictMode, // Mode strict: rejette photos suspectes
    @HiveField(11) DateTime? lastBackupDate,
    @HiveField(12) @Default(false) bool analyticsEnabled,
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
