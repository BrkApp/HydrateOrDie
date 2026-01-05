import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'notification_settings.freezed.dart';
part 'notification_settings.g.dart';

/// Paramètres des notifications
@freezed
@HiveType(typeId: 4)
class NotificationSettings with _$NotificationSettings {
  const factory NotificationSettings({
    @HiveField(0) @Default(true) bool enabled,
    @HiveField(1) @Default(45) int normalIntervalMinutes, // Intervalle normal (45-60min)
    @HiveField(2) @Default(5) int spamIntervalMinutes, // Intervalle spam (5min)
    @HiveField(3) @Default(60) int gracePeriodMinutes, // Période de grâce avant spam
    @HiveField(4) @Default(NotificationIntensity.normal) NotificationIntensity currentIntensity,
    @HiveField(5) @Default(0) int consecutiveMissed, // Nombre de notifications manquées
    @HiveField(6) DateTime? lastNotificationTime,
    @HiveField(7) DateTime? lastDrinkTime,
    @HiveField(8) @Default(true) bool soundEnabled,
    @HiveField(9) @Default(true) bool vibrationEnabled,
    @HiveField(10) @Default(MessageTone.punitive) MessageTone messageTone,
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
@HiveType(typeId: 5)
enum NotificationIntensity {
  @HiveField(0)
  normal, // Notifications normales toutes les 45-60min

  @HiveField(1)
  warning, // Notifications plus fréquentes

  @HiveField(2)
  spam, // Spam mode toutes les 5min

  @HiveField(3)
  aggressive, // Mode ultra agressif
}

/// Ton des messages (premium feature)
@HiveType(typeId: 6)
enum MessageTone {
  @HiveField(0)
  punitive, // Messages punitifs/sarcastiques (défaut)

  @HiveField(1)
  motivational, // Messages motivants

  @HiveField(2)
  friendly, // Messages amicaux

  @HiveField(3)
  professional, // Messages professionnels

  @HiveField(4)
  aggressive, // Messages très agressifs (premium)

  @HiveField(5)
  humorous, // Messages humoristiques (premium)
}
