import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_settings.freezed.dart';
part 'notification_settings.g.dart';

/// Paramètres des notifications
@freezed
class NotificationSettings with _$NotificationSettings {
  const factory NotificationSettings({
    @Default(true) bool enabled,
    @Default(45) int normalIntervalMinutes, // Intervalle normal (45-60min)
    @Default(5) int spamIntervalMinutes, // Intervalle spam (5min)
    @Default(60) int gracePeriodMinutes, // Période de grâce avant spam
    @Default(NotificationIntensity.normal) NotificationIntensity currentIntensity,
    @Default(0) int consecutiveMissed, // Nombre de notifications manquées
    DateTime? lastNotificationTime,
    DateTime? lastDrinkTime,
    @Default(true) bool soundEnabled,
    @Default(true) bool vibrationEnabled,
    @Default(MessageTone.punitive) MessageTone messageTone,
  }) = _NotificationSettings;

  factory NotificationSettings.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsFromJson(json);

  static NotificationSettings createDefault() {
    return const NotificationSettings();
  }
}

const NotificationSettings _$NotificationSettingsConst = NotificationSettings;

extension NotificationSettingsX on NotificationSettings {
  /// Calcule le prochain intervalle de notification
  int getNextInterval() {
    switch (currentIntensity) {
      case NotificationIntensity.normal:
        return normalIntervalMinutes;
      case NotificationIntensity.warning:
        return (normalIntervalMinutes * 0.7).round(); // 70% de l'intervalle normal
      case NotificationIntensity.spam:
        return spamIntervalMinutes;
      case NotificationIntensity.aggressive:
        return (spamIntervalMinutes * 0.5).round(); // 50% de l'intervalle spam
    }
  }

  /// Met à jour l'intensité selon le nombre de notifications manquées
  NotificationSettings updateIntensity() {
    NotificationIntensity newIntensity;

    if (consecutiveMissed == 0) {
      newIntensity = NotificationIntensity.normal;
    } else if (consecutiveMissed < 3) {
      newIntensity = NotificationIntensity.warning;
    } else if (consecutiveMissed < 6) {
      newIntensity = NotificationIntensity.spam;
    } else {
      newIntensity = NotificationIntensity.aggressive;
    }

    return copyWith(currentIntensity: newIntensity);
  }

  /// Incrémente le compteur de notifications manquées
  NotificationSettings incrementMissed() {
    return copyWith(consecutiveMissed: consecutiveMissed + 1).updateIntensity();
  }

  /// Réinitialise après avoir bu
  NotificationSettings resetAfterDrink() {
    return copyWith(
      consecutiveMissed: 0,
      currentIntensity: NotificationIntensity.normal,
      lastDrinkTime: DateTime.now(),
    );
  }

  /// Enregistre qu'une notification a été envoyée
  NotificationSettings markNotificationSent() {
    return copyWith(lastNotificationTime: DateTime.now());
  }
}

/// Intensité des notifications
enum NotificationIntensity {
  normal, // Notifications normales toutes les 45-60min
  warning, // Notifications plus fréquentes
  spam, // Spam mode toutes les 5min
  aggressive, // Mode ultra agressif
}

/// Ton des messages (premium feature)
enum MessageTone {
  punitive, // Messages punitifs/sarcastiques (défaut)
  motivational, // Messages motivants
  friendly, // Messages amicaux
  professional, // Messages professionnels
  aggressive, // Messages très agressifs (premium)
  humorous, // Messages humoristiques (premium)
}
