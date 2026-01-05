/// Constantes globales de l'application HydrateOrDie
class AppConstants {
  AppConstants._(); // Private constructor

  // ==================== APP INFO ====================
  static const String appName = 'HydrateOrDie';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  // ==================== HYDRATATION ====================
  static const double defaultDailyGoal = 2000.0; // ml
  static const double defaultIntakeAmount = 250.0; // ml par prise
  static const double minDailyGoal = 1000.0; // ml
  static const double maxDailyGoal = 5000.0; // ml
  static const double waterPerKg = 30.0; // ml d'eau par kg de poids corporel

  // Quantités prédéfinies
  static const List<double> quickIntakeAmounts = [
    150.0, // Petit verre
    250.0, // Verre standard
    330.0, // Canette
    500.0, // Petite bouteille
    750.0, // Grande bouteille
    1000.0, // Litre
  ];

  // ==================== NOTIFICATIONS ====================
  static const int normalIntervalMin = 45; // minutes
  static const int normalIntervalMax = 60; // minutes
  static const int spamInterval = 5; // minutes
  static const int aggressiveInterval = 2; // minutes
  static const int gracePeriod = 60; // minutes avant de passer en mode spam

  // Seuils d'intensité
  static const int warningThreshold = 3; // notifications manquées
  static const int spamThreshold = 6; // notifications manquées
  static const int aggressiveThreshold = 10; // notifications manquées

  // ==================== ML KIT ====================
  static const double mlConfidenceThreshold = 0.7; // Seuil de confiance minimum
  static const double mlHighConfidence = 0.85; // Haute confiance

  // Labels acceptés pour la détection
  static const List<String> acceptedLabels = [
    'bottle',
    'water bottle',
    'glass',
    'cup',
    'mug',
    'drink',
    'beverage',
    'water',
    'drinking glass',
  ];

  // ==================== STREAK ====================
  static const int maxStreakToShow = 999; // Affichage maximum
  static const List<int> streakMilestones = [
    3,
    7,
    14,
    30,
    60,
    90,
    180,
    365,
  ]; // Jalons pour badges

  // ==================== PREMIUM ====================
  static const String revenueCatApiKey = 'YOUR_REVENUECAT_API_KEY'; // À remplacer
  static const String premiumEntitlementId = 'premium';

  // IDs des produits (à configurer dans RevenueCat)
  static const String monthlySubscriptionId = 'hydrate_premium_monthly';
  static const String yearlySubscriptionId = 'hydrate_premium_yearly';
  static const String lifetimeSubscriptionId = 'hydrate_premium_lifetime';

  // Prix indicatifs (seront overridden par RevenueCat)
  static const double monthlyPrice = 2.99;
  static const double yearlyPrice = 19.99;
  static const double lifetimePrice = 49.99;

  // ==================== ACTIVE HOURS ====================
  static const int defaultActiveStartHour = 7; // 7h
  static const int defaultActiveEndHour = 22; // 22h

  // ==================== VALIDATION ====================
  static const int minAge = 13;
  static const int maxAge = 120;
  static const double minWeight = 30.0; // kg
  static const double maxWeight = 200.0; // kg

  // ==================== ANIMATIONS ====================
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // ==================== DATABASE ====================
  static const int maxHistoryDays = 365; // Garder 1 an d'historique
  static const int backupFrequencyDays = 7; // Backup tous les 7 jours

  // ==================== CAMERA ====================
  static const int maxPhotoSize = 2048; // pixels
  static const int jpegQuality = 85; // qualité JPEG (0-100)
  static const Duration photoTimeout = Duration(seconds: 30);
}
