# V2 Features & Future Enhancements

**Partie de:** [Architecture Document](index.md)

---

## Weather API Integration (V2)

**Purpose:** Ajuster rappels hydratation selon conditions météo

### Architecture

```
┌────────────────────────────────────────────────┐
│       WEATHER API INTEGRATION (V2)             │
├────────────────────────────────────────────────┤
│                                                │
│  Weather Service (External API)                │
│       ↓                                        │
│  WeatherRepository (new)                       │
│       ↓                                        │
│  GetWeatherConditionsUseCase (new)             │
│       ↓                                        │
│  AdjustHydrationGoalByWeatherUseCase (new)     │
│       │                                        │
│       ├──► Canicule (>30°C)                    │
│       │    → +20% objectif hydratation         │
│       │    → Escalade notifications plus rapide│
│       │                                        │
│       ├──► Chaleur (25-30°C)                   │
│       │    → +10% objectif                     │
│       │                                        │
│       └──► Normal (<25°C)                      │
│            → Objectif standard                 │
│                                                │
└────────────────────────────────────────────────┘
```

### API Options

**1. OpenWeatherMap API (Recommended)**
- Free tier: 1000 calls/day
- Current weather + forecasts
- Cost: 0€ pour MVP, ~$40/mo pour 100k users

**2. WeatherAPI.com**
- Free tier: 1M calls/month
- Alternative viable

### New Components (V2)

```dart
// New Repository
abstract class WeatherRepository {
  Future<WeatherConditions> getCurrentWeather(LatLng location);
  Future<bool> isHeatwave(); // >30°C
}

// New Use Case
class AdjustHydrationGoalByWeatherUseCase {
  final WeatherRepository _weatherRepository;
  final UserProfileRepository _profileRepository;

  Future<HydrationGoal> execute() async {
    final weather = await _weatherRepository.getCurrentWeather(userLocation);
    final baseGoal = await _profileRepository.getProfile().dailyGoal;

    if (weather.temperatureCelsius > 30) {
      return HydrationGoal(baseGoal.targetLiters * 1.2); // +20%
    } else if (weather.temperatureCelsius > 25) {
      return HydrationGoal(baseGoal.targetLiters * 1.1); // +10%
    }

    return baseGoal;
  }
}
```

### Notification Integration

```dart
// Enhanced CalculateNotificationLevelUseCase (V2)
Future<NotificationLevel> execute() async {
  final weather = await _weatherRepository.getCurrentWeather();

  // Escalade plus rapide si canicule
  if (weather.isHeatwave()) {
    // Thresholds réduits: Calm 1h, Concerned 2h, Dramatic 3h, Chaos 4h
    // (au lieu de 2h, 4h, 6h)
  }

  // Logic existante...
}
```

### Privacy & Permissions

- Localisation déjà collectée en onboarding (optionnelle)
- Si permission refusée → Pas de weather adjustment (fallback objectif standard)
- Weather data NON stockée (ephemeral, fetched on demand)

### Cost Analysis

- Free tier OpenWeatherMap: 1000 calls/day = 30k/month
- Estimation calls: 1 call/user/day = 10k users OK dans free tier
- Au-delà 10k users: $40/mo (100k calls/jour)

### Implementation Timeline

- V2 (Post-MVP, après traction validée)
- Estimation: 1-2 sprints (Epic 6)

---

## Other V2 Features Planned

### Apple Watch / Wear OS Integration

- Quick validation depuis montre
- Notifications haptiques
- Water tracking widget

### Advanced Analytics Dashboard

- Tendances hebdomadaires/mensuelles
- Comparaison objectifs atteints
- Insights personnalisés

### Social Features

- Challenges entre amis
- Leaderboards streaks
- Partage achievements

### Premium Avatar Packs

- Avatars additionnels payants
- Animations custom
- Monétisation freemium

---

[⬅️ Deployment & CI/CD](deployment.md) | [🏠 Retour à l'index](index.md)
