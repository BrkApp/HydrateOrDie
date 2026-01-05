import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

/// Profil utilisateur avec informations personnelles
/// Utilisé pour calculer l'objectif d'hydratation personnalisé
@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String name,
    required double weight, // en kg
    required int age,
    required double dailyGoal, // en ml
    required DateTime activeStart, // Heure de début (ex: 7h)
    required DateTime activeEnd, // Heure de fin (ex: 22h)
    required DateTime createdAt,
    @Default(false) bool isPremium,
    @Default('default') String theme,
    @Default('fr') String language,
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
