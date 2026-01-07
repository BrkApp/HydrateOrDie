# Data Models & Entities - Hydrate or Die MVP

**Version:** 1.0
**Date:** 2026-01-07
**Owner:** Winston (Architect)
**Status:** DRAFT - Awaiting PM Validation
**Reference:** PRD v1.0, Epics 1-5, governance.md

---

## 📋 Table des Matières

1. [User & Profile Models](#1-user--profile-models)
2. [Avatar Models](#2-avatar-models)
3. [Hydration Models](#3-hydration-models)
4. [Streak Models](#4-streak-models)
5. [Notification Models](#5-notification-models)
6. [Calendar & History Models](#6-calendar--history-models)
7. [Achievement Models (V2)](#7-achievement-models-v2)

---

## 1. User & Profile Models

### 1.1 UserProfile (Model/DTO)

**Purpose:** Modèle de données pour le profil utilisateur créé lors de l'onboarding

**Layer:** Data Layer (DTO avec sérialisation)

**Properties:**

| Property | Type | Nullable | Default | Validation | Description |
|----------|------|----------|---------|------------|-------------|
| `userId` | `String` (UUID) | NO | - | UUID format | Identifiant unique utilisateur |
| `weight` | `double` | NO | - | 30.0-300.0 kg | Poids utilisateur en kilogrammes |
| `age` | `int` | NO | - | 10-120 | Âge utilisateur en années |
| `gender` | `Gender` (enum) | NO | - | - | Sexe biologique |
| `activityLevel` | `ActivityLevel` (enum) | NO | - | - | Niveau d'activité physique |
| `locationPermissionGranted` | `bool` | NO | `false` | - | Permission localisation accordée |
| `dailyGoalLiters` | `double` | NO | - | 1.5-5.0 | Objectif hydratation quotidien calculé |
| `createdAt` | `DateTime` | NO | - | ISO 8601 UTC | Date création profil |
| `updatedAt` | `DateTime` | NO | - | ISO 8601 UTC | Date dernière modification |

**Methods:**

```dart
// Serialization
Map<String, dynamic> toJson();
factory UserProfile.fromJson(Map<String, dynamic> json);

// Validation
bool isComplete(); // Vérifie que tous champs obligatoires renseignés

// Conversion vers Entity
User toEntity(); // Convertit vers domain entity
```

**Validation Rules:**

- `weight`: Doit être entre 30.0 et 300.0 kg (ou équivalent lbs)
- `age`: Doit être entre 10 et 120 ans
- `dailyGoalLiters`: Doit être entre 1.5L et 5.0L (safety bounds)
- `createdAt` et `updatedAt`: Format ISO 8601 UTC

**Example JSON:**

```json
{
  "userId": "550e8400-e29b-41d4-a716-446655440000",
  "weight": 75.0,
  "age": 30,
  "gender": "male",
  "activityLevel": "moderate",
  "locationPermissionGranted": false,
  "dailyGoalLiters": 2.5,
  "createdAt": "2026-01-07T10:00:00.000Z",
  "updatedAt": "2026-01-07T10:00:00.000Z"
}
```

---

### 1.2 User (Entity)

**Purpose:** Entité métier pure pour l'utilisateur (Domain Layer)

**Layer:** Domain Layer (Pure Dart, pas de sérialisation)

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `id` | `String` (UUID) | Identifiant unique |
| `weight` | `double` | Poids en kg |
| `age` | `int` | Âge en années |
| `gender` | `Gender` | Sexe biologique |
| `activityLevel` | `ActivityLevel` | Niveau activité |
| `dailyGoal` | `HydrationGoal` | Objectif hydratation (value object) |

**Methods:**

```dart
// Business logic
bool needsGoalRecalculation(UserProfile oldProfile);
```

---

### 1.3 Gender (Enum)

**Purpose:** Énumération sexe biologique

**Values:**

```dart
enum Gender {
  male,    // Homme (multiplicateur 1.0)
  female,  // Femme (multiplicateur 0.95)
  other,   // Autre (multiplicateur 1.0)
}
```

**Usage:**
- Utilisé dans calcul objectif hydratation (CalculateHydrationGoalUseCase)
- Affichage onboarding screen

---

### 1.4 ActivityLevel (Enum)

**Purpose:** Énumération niveau d'activité physique

**Values:**

```dart
enum ActivityLevel {
  sedentary,        // Sédentaire (multiplicateur 1.0)
  light,            // Léger 1-3x/semaine (multiplicateur 1.1)
  moderate,         // Modéré 3-5x/semaine (multiplicateur 1.2)
  veryActive,       // Très actif 6-7x/semaine (multiplicateur 1.3)
  extremelyActive,  // Extrêmement actif (sport intense quotidien) (multiplicateur 1.5)
}
```

**Usage:**
- Utilisé dans calcul objectif hydratation
- Affichage onboarding screen avec descriptions

---

## 2. Avatar Models

### 2.1 Avatar (Entity)

**Purpose:** Entité métier pour l'avatar Tamagotchi

**Layer:** Domain Layer

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `id` | `String` | Identifiant avatar (ex: "authoritarian_mother") |
| `name` | `String` | Nom affichage (ex: "Mère Autoritaire") |
| `personality` | `AvatarPersonality` | Type de personnalité |
| `currentState` | `AvatarState` | État actuel déshydratation |
| `lastDrinkTime` | `DateTime` | Timestamp dernière hydratation |
| `lastUpdated` | `DateTime` | Dernière mise à jour état |

**Methods:**

```dart
// Business logic
AvatarState calculateState(Duration timeSinceLastDrink);
bool shouldBecomeGhost();
bool shouldResurrect();
```

---

### 2.2 AvatarModel (Model/DTO)

**Purpose:** Modèle sérialisable pour persistence

**Layer:** Data Layer

**Properties:**

| Property | Type | Nullable | Description |
|----------|------|----------|-------------|
| `selectedAvatarId` | `String` | NO | ID avatar sélectionné |
| `currentState` | `String` | NO | État actuel (enum serialized) |
| `lastDrinkTime` | `String` | NO | ISO 8601 UTC |
| `lastUpdated` | `String` | NO | ISO 8601 UTC |

**Methods:**

```dart
Map<String, dynamic> toJson();
factory AvatarModel.fromJson(Map<String, dynamic> json);
Avatar toEntity();
```

**Example JSON:**

```json
{
  "selectedAvatarId": "sports_coach",
  "currentState": "tired",
  "lastDrinkTime": "2026-01-07T11:30:00.000Z",
  "lastUpdated": "2026-01-07T14:30:00.000Z"
}
```

---

### 2.3 AvatarPersonality (Enum)

**Purpose:** Types de personnalités avatar MVP

**Values:**

```dart
enum AvatarPersonality {
  authoritarianMother,  // Mère Autoritaire
  sportsCoach,          // Coach Sportif
  doctor,               // Docteur
  sarcasticFriend,      // Ami Sarcastique
}
```

**Display Names:**

```dart
extension AvatarPersonalityExtension on AvatarPersonality {
  String get displayName {
    switch (this) {
      case AvatarPersonality.authoritarianMother:
        return 'Mère Autoritaire';
      case AvatarPersonality.sportsCoach:
        return 'Coach Sportif';
      case AvatarPersonality.doctor:
        return 'Docteur';
      case AvatarPersonality.sarcasticFriend:
        return 'Ami Sarcastique';
    }
  }

  String get description {
    switch (this) {
      case AvatarPersonality.authoritarianMother:
        return 'Elle ne rigole pas avec ta santé. Autoritaire mais bienveillante.';
      case AvatarPersonality.sportsCoach:
        return 'Motivation extrême et énergie débordante. NO PAIN NO GAIN !';
      case AvatarPersonality.doctor:
        return 'Approche scientifique et médicale. Diagnostic sans filtre.';
      case AvatarPersonality.sarcasticFriend:
        return 'Sarcasme et humour noir. Ton meilleur pote qui te taquine.';
    }
  }
}
```

---

### 2.4 AvatarState (Enum)

**Purpose:** États de déshydratation + fantôme

**Values:**

```dart
enum AvatarState {
  fresh,       // 0-2h sans boire - Avatar en pleine forme
  tired,       // 2-4h - Avatar fatigué
  dehydrated,  // 4-6h - Avatar visiblement desséché
  dead,        // 6h+ - Avatar effondré/skull
  ghost,       // État fantôme après mort (temporaire)
}
```

**State Transition Logic:**

```dart
extension AvatarStateExtension on AvatarState {
  AvatarState getNextState() {
    switch (this) {
      case AvatarState.fresh:
        return AvatarState.tired;
      case AvatarState.tired:
        return AvatarState.dehydrated;
      case AvatarState.dehydrated:
        return AvatarState.dead;
      case AvatarState.dead:
        return AvatarState.ghost; // Transition automatique après 10s
      case AvatarState.ghost:
        return AvatarState.fresh; // Résurrection à minuit
    }
  }

  bool shouldDie(Duration timeSinceLastDrink) {
    return timeSinceLastDrink.inHours >= 6;
  }

  bool shouldBecomeGhost() {
    return this == AvatarState.dead; // + elapsed time > 10 seconds
  }
}
```

**Asset Paths:**

```dart
extension AvatarStateAssets on AvatarState {
  String getAssetPath(AvatarPersonality personality) {
    return 'assets/images/avatars/${personality.name}/${this.name}.png';
    // Ex: assets/images/avatars/sports_coach/tired.png
  }
}
```

---

## 3. Hydration Models

### 3.1 HydrationLog (Entity)

**Purpose:** Entité métier pour une validation d'hydratation

**Layer:** Domain Layer

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `id` | `String` (UUID) | Identifiant unique log |
| `timestamp` | `DateTime` | Date/heure validation |
| `photoPath` | `String` | Chemin fichier photo locale |
| `glassSize` | `GlassSize` | Taille verre sélectionnée |
| `validated` | `bool` | Validation confirmée |

**Methods:**

```dart
double get volumeLiters; // Retourne volume en litres basé sur glassSize
bool isToday(); // Vérifie si log du jour actuel
```

---

### 3.2 HydrationLogModel (Model/DTO)

**Purpose:** Modèle sérialisable pour persistence

**Layer:** Data Layer

**Properties:**

| Property | Type | Nullable | Default | Description |
|----------|------|----------|---------|-------------|
| `id` | `String` (UUID) | NO | - | ID unique |
| `timestamp` | `String` | NO | - | ISO 8601 UTC |
| `photoPath` | `String` | YES | `null` | Chemin photo (peut être null si photo fail) |
| `glassSize` | `String` | NO | `'medium'` | Enum serialized |
| `volumeLiters` | `double` | NO | - | Volume calculé |
| `validated` | `bool` | NO | `true` | Toujours true pour logs créés |
| `syncedToCloud` | `bool` | NO | `false` | Flag sync Firestore (SQLite only) |
| `createdAt` | `String` | NO | - | ISO 8601 UTC |

**Methods:**

```dart
Map<String, dynamic> toJson();
factory HydrationLogModel.fromJson(Map<String, dynamic> json);
HydrationLog toEntity();
```

**Example JSON:**

```json
{
  "id": "660e8400-e29b-41d4-a716-446655440001",
  "timestamp": "2026-01-07T14:30:00.000Z",
  "photoPath": "/app_documents/hydration_photos/hydration_20260107_143000.jpg",
  "glassSize": "medium",
  "volumeLiters": 0.25,
  "validated": true,
  "syncedToCloud": false,
  "createdAt": "2026-01-07T14:30:05.000Z"
}
```

---

### 3.3 GlassSize (Enum)

**Purpose:** Tailles de verre avec volumes prédéfinis

**Values:**

```dart
enum GlassSize {
  small,   // Petit verre - 200ml
  medium,  // Verre moyen - 250ml
  large,   // Grand verre - 400ml
}
```

**Volume Mapping:**

```dart
extension GlassSizeExtension on GlassSize {
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
```

---

### 3.4 HydrationGoal (Value Object)

**Purpose:** Value object pour l'objectif quotidien d'hydratation

**Layer:** Domain Layer

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `targetLiters` | `double` | Objectif en litres (1.5-5.0) |

**Methods:**

```dart
bool isAchieved(double currentVolume);
double getProgressPercentage(double currentVolume);
```

**Validation:**

```dart
class HydrationGoal {
  static const double kMinGoal = 1.5; // Litres
  static const double kMaxGoal = 5.0; // Litres

  final double targetLiters;

  HydrationGoal(this.targetLiters) {
    assert(targetLiters >= kMinGoal && targetLiters <= kMaxGoal,
        'Goal must be between $kMinGoal and $kMaxGoal liters');
  }
}
```

---

## 4. Streak Models

### 4.1 StreakData (Entity)

**Purpose:** Entité métier pour les streaks (jours consécutifs)

**Layer:** Domain Layer

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `currentStreak` | `int` | Nombre jours consécutifs actuels |
| `longestStreak` | `int` | Record personnel jours consécutifs |
| `lastStreakDate` | `DateTime` | Dernière date où objectif atteint |
| `streakActive` | `bool` | Objectif atteint aujourd'hui |

**Methods:**

```dart
void incrementStreak(DateTime date);
void breakStreak();
bool isStreakActiveToday();
bool shouldIncrementToday(DateTime today);
```

---

### 4.2 StreakModel (Model/DTO)

**Purpose:** Modèle sérialisable pour persistence

**Layer:** Data Layer

**Properties:**

| Property | Type | Nullable | Default | Description |
|----------|------|----------|---------|-------------|
| `id` | `String` | NO | `'streak_singleton'` | ID fixe (un seul streak par user) |
| `currentStreak` | `int` | NO | `0` | Jours consécutifs actuels |
| `longestStreak` | `int` | NO | `0` | Record |
| `lastStreakDate` | `String` | NO | - | ISO 8601 date (YYYY-MM-DD) |
| `streakActive` | `bool` | NO | `false` | Actif aujourd'hui |
| `updatedAt` | `String` | NO | - | ISO 8601 UTC |

**Methods:**

```dart
Map<String, dynamic> toJson();
factory StreakModel.fromJson(Map<String, dynamic> json);
StreakData toEntity();
```

**Example JSON:**

```json
{
  "id": "streak_singleton",
  "currentStreak": 7,
  "longestStreak": 15,
  "lastStreakDate": "2026-01-06",
  "streakActive": true,
  "updatedAt": "2026-01-07T00:00:00.000Z"
}
```

---

## 5. Notification Models

### 5.1 NotificationState (Entity)

**Purpose:** Entité métier pour l'état système notifications

**Layer:** Domain Layer

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `currentLevel` | `NotificationLevel` | Niveau escalade actuel |
| `lastNotificationTime` | `DateTime` | Timestamp dernière notif envoyée |
| `notificationsSentToday` | `int` | Compteur notifications jour |
| `userLastDrinkTime` | `DateTime` | Référence temps dernière hydratation |

**Methods:**

```dart
bool shouldEscalate(Duration timeSinceLastDrink);
NotificationLevel getNextLevel();
void reset(); // Reset à CALM
bool isInPauseWindow(DateTime now); // Check pause nocturne
```

---

### 5.2 NotificationStateModel (Model/DTO)

**Purpose:** Modèle sérialisable pour persistence

**Layer:** Data Layer

**Properties:**

| Property | Type | Nullable | Default | Description |
|----------|------|----------|---------|-------------|
| `id` | `String` | NO | `'notification_state'` | ID fixe |
| `currentLevel` | `String` | NO | `'calm'` | Enum serialized |
| `lastNotificationTime` | `String` | YES | `null` | ISO 8601 UTC (null si aucune notif) |
| `notificationsSentToday` | `int` | NO | `0` | Compteur |
| `updatedAt` | `String` | NO | - | ISO 8601 UTC |

**Methods:**

```dart
Map<String, dynamic> toJson();
factory NotificationStateModel.fromJson(Map<String, dynamic> json);
NotificationState toEntity();
```

**Example JSON:**

```json
{
  "id": "notification_state",
  "currentLevel": "dramatic",
  "lastNotificationTime": "2026-01-07T15:45:00.000Z",
  "notificationsSentToday": 12,
  "updatedAt": "2026-01-07T15:45:00.000Z"
}
```

---

### 5.3 NotificationLevel (Enum)

**Purpose:** Niveaux d'escalade progressive

**Values:**

```dart
enum NotificationLevel {
  calm,       // 0-2h : 1x/heure
  concerned,  // 2-4h : 1x/30min
  dramatic,   // 4-6h : 1x/15min
  chaos,      // 6h+ : 5-10min random + vibrations
}
```

**Frequency Mapping:**

```dart
extension NotificationLevelExtension on NotificationLevel {
  Duration get frequency {
    switch (this) {
      case NotificationLevel.calm:
        return Duration(hours: 1);
      case NotificationLevel.concerned:
        return Duration(minutes: 30);
      case NotificationLevel.dramatic:
        return Duration(minutes: 15);
      case NotificationLevel.chaos:
        // Random entre 5-10 min (calculé dynamiquement)
        return Duration(minutes: 5); // Base minimum
    }
  }

  bool get hasVibrations {
    return this == NotificationLevel.chaos;
  }
}
```

---

### 5.4 NotificationMessage (Value Object)

**Purpose:** Value object pour un message notification

**Layer:** Domain Layer

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `title` | `String` | Titre notification (nom avatar) |
| `body` | `String` | Message adapté personnalité + niveau |
| `personality` | `AvatarPersonality` | Référence avatar |
| `level` | `NotificationLevel` | Référence niveau |

**Example:**

```dart
NotificationMessage(
  title: 'Coach Mike dit:',
  body: 'BOUUUUGE-TOI !!! 🔥 EAU MAINTENANT !!! 🔥',
  personality: AvatarPersonality.sportsCoach,
  level: NotificationLevel.chaos,
);
```

---

## 6. Calendar & History Models

### 6.1 DayStatus (Value Object)

**Purpose:** Statut hydratation pour un jour donné

**Layer:** Domain Layer

**Properties:**

| Property | Type | Nullable | Description |
|----------|------|----------|-------------|
| `date` | `DateTime` | NO | Date du jour (00:00:00) |
| `goalAchieved` | `bool` | YES | true/false/null (null = futur ou pas de données) |
| `volumeDrank` | `double` | NO | Volume total bu en litres |
| `goalVolume` | `double` | NO | Objectif du jour |

**Methods:**

```dart
double get progressPercentage;
bool get isFuture; // Date > aujourd'hui
bool get isPast;
String get displayStatus; // '✓' ou '✗' ou ''
```

**Example:**

```dart
DayStatus(
  date: DateTime(2026, 1, 7),
  goalAchieved: true,
  volumeDrank: 2.75,
  goalVolume: 2.5,
); // → displayStatus = '✓'
```

---

### 6.2 MonthStatus (Value Object)

**Purpose:** Résumé statut pour un mois complet

**Layer:** Domain Layer

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `year` | `int` | Année |
| `month` | `int` | Mois (1-12) |
| `days` | `List<DayStatus>` | Liste tous jours du mois |

**Methods:**

```dart
int get totalDays; // Nombre jours dans le mois
int get daysAchieved; // Nombre jours objectif atteint
int get daysFailed; // Nombre jours objectif raté
double get successRate; // Pourcentage succès (0.0-1.0)
String get summary; // Ex: "15/30 jours objectif atteint"
```

---

## 7. Achievement Models (V2)

### 7.1 Achievement (Entity)

**Purpose:** Entité métier pour un achievement/badge

**Layer:** Domain Layer

**Properties:**

| Property | Type | Nullable | Description |
|----------|------|----------|-------------|
| `id` | `String` | NO | ID unique achievement |
| `title` | `String` | NO | Titre affiché |
| `description` | `String` | NO | Description condition |
| `icon` | `String` | NO | Asset path icon |
| `unlocked` | `bool` | NO | Débloqué ou non |
| `unlockedDate` | `DateTime` | YES | Date déblocage (null si locked) |

**Predefined Achievements (MVP):**

```dart
static final List<Achievement> mvpAchievements = [
  Achievement(
    id: 'first_glass',
    title: 'Premier Verre',
    description: 'Valider ta première hydratation',
    icon: 'assets/icons/achievements/first_glass.png',
  ),
  Achievement(
    id: 'streak_7',
    title: 'Streak 7 jours',
    description: 'Atteindre 7 jours consécutifs',
    icon: 'assets/icons/achievements/fire_7.png',
  ),
  Achievement(
    id: 'streak_30',
    title: 'Streak 30 jours',
    description: 'Atteindre 30 jours consécutifs',
    icon: 'assets/icons/achievements/trophy.png',
  ),
  Achievement(
    id: 'perfect_goal',
    title: 'Objectif Parfait',
    description: 'Atteindre exactement 100% de ton objectif',
    icon: 'assets/icons/achievements/bullseye.png',
  ),
  Achievement(
    id: 'avatar_savior',
    title: 'Sauveur d\'Avatar',
    description: 'Ressusciter un avatar mort',
    icon: 'assets/icons/achievements/resurrection.png',
  ),
];
```

---

## 📊 Model Dependencies Diagram

```
┌─────────────────────────────────────────────────┐
│              MODEL RELATIONSHIPS                │
├─────────────────────────────────────────────────┤
│                                                 │
│  User (Entity)                                  │
│    ├── has UserProfile (DTO)                    │
│    ├── has Avatar (Entity)                      │
│    │     └── AvatarModel (DTO)                  │
│    ├── has HydrationGoal (Value Object)         │
│    ├── has List<HydrationLog> (Entity)          │
│    │     └── HydrationLogModel (DTO)            │
│    ├── has StreakData (Entity)                  │
│    │     └── StreakModel (DTO)                  │
│    ├── has NotificationState (Entity)           │
│    │     └── NotificationStateModel (DTO)       │
│    └── has List<Achievement> (Entity) [V2]      │
│                                                 │
│  Calendar:                                      │
│    MonthStatus                                  │
│      └── contains List<DayStatus>               │
│                                                 │
└─────────────────────────────────────────────────┘
```

---

## ✅ Validation Rules Summary

### All Models Must:

1. **Have toJson() / fromJson()** (DTOs uniquement)
2. **Have toEntity() / toModel()** (conversion layer)
3. **Validate constraints** (assert ou throw ArgumentError)
4. **Use ISO 8601 UTC** pour tous timestamps
5. **Support null safety** (Dart null-safe)
6. **Be immutable** (final properties, copyWith methods)
7. **Have unit tests** (100% coverage obligatoire)

### Naming Conventions:

- **Entities:** PascalCase, dans `domain/entities/` (ex: `User`, `Avatar`)
- **Models/DTOs:** PascalCase + "Model" suffix, dans `data/models/` (ex: `UserProfileModel`)
- **Enums:** PascalCase, dans `domain/entities/` ou `core/constants/`
- **Value Objects:** PascalCase, dans `domain/entities/`

---

## 📋 Next Steps

Après validation de ce document:

1. ✅ **Créer database-schema.md** : Schémas SQLite + Firestore complets
2. ✅ **Créer repositories-interface.md** : Interfaces tous repositories
3. ✅ **Créer use-cases-interface.md** : Interfaces tous use cases
4. ✅ **Créer api-contracts.md** : Contrats Firebase (Auth, Firestore, Storage)
5. ⏸️ **Validation PM** : Approval avant développement

---

**Document créé le 2026-01-07 par Winston (Architect)**
**Status: DRAFT - Awaiting PM Validation**
**Reference:** Epics 1-5, governance.md checklist Pre-Development
