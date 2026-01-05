import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

/// Profil utilisateur avec informations personnelles
/// Utilisé pour calculer l'objectif d'hydratation personnalisé
@freezed
@HiveType(typeId: 0)
class UserProfile with _$UserProfile {
  const factory UserProfile({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) required double weight, // en kg
    @HiveField(3) required int age,
    @HiveField(4) required double dailyGoal, // en ml
    @HiveField(5) required DateTime activeStart, // Heure de début (ex: 7h)
    @HiveField(6) required DateTime activeEnd, // Heure de fin (ex: 22h)
    @HiveField(7) required DateTime createdAt,
    @HiveField(8) @Default(false) bool isPremium,
    @HiveField(9) @Default('default') String theme,
    @HiveField(10) @Default('fr') String language,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  /// Calcule l'objectif quotidien basé sur le poids (30-35ml par kg)
  static double calculateDailyGoal(double weight, int age) {
    // Base: 30ml par kg pour adultes
    double base = weight * 30;

    // Ajustement selon l'âge
    if (age < 30) {
      base *= 1.1; // +10% pour les jeunes
    } else if (age > 55) {
      base *= 0.95; // -5% pour les seniors
    }

    // Arrondir à 250ml près
    return (base / 250).round() * 250;
  }

  /// Crée un profil par défaut
  static UserProfile createDefault() {
    final now = DateTime.now();
    return UserProfile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'User',
      weight: 70.0,
      age: 30,
      dailyGoal: 2000.0,
      activeStart: DateTime(now.year, now.month, now.day, 7, 0),
      activeEnd: DateTime(now.year, now.month, now.day, 22, 0),
      createdAt: now,
    );
  }
}
