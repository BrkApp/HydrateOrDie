# System Architecture - Hydrate or Die MVP

**Version:** 1.0
**Date:** 2026-01-07
**Owner:** Product Manager John & Architect
**Status:** APPROVED - Architecture figée pour MVP

---

## 🎯 Vue d'Ensemble

Hydrate or Die est une **application mobile cross-platform (iOS/Android)** utilisant Flutter avec une architecture **Clean Architecture** et un backend **Firebase (BaaS)**. L'app fonctionne en **offline-first** avec synchronisation cloud optionnelle.

---

## 📐 Architecture Globale

```
┌─────────────────────────────────────────────────────────────┐
│                      USER DEVICES                           │
│  ┌──────────────────┐         ┌──────────────────┐         │
│  │   iOS Device     │         │  Android Device  │         │
│  │  (iPhone/iPad)   │         │   (Phone/Tab)    │         │
│  └────────┬─────────┘         └─────────┬────────┘         │
│           │                             │                   │
│           └──────────┬──────────────────┘                   │
│                      │                                      │
│           ┌──────────▼──────────┐                          │
│           │  Flutter App (Dart) │                          │
│           │  ┌────────────────┐ │                          │
│           │  │ Presentation   │ │ ◄─ UI Screens/Widgets    │
│           │  └───────┬────────┘ │                          │
│           │  ┌───────▼────────┐ │                          │
│           │  │ Domain (Logic) │ │ ◄─ Use Cases/Entities    │
│           │  └───────┬────────┘ │                          │
│           │  ┌───────▼────────┐ │                          │
│           │  │ Data (Repos)   │ │ ◄─ Repositories/Models   │
│           │  └───┬────────┬───┘ │                          │
│           └──────┼────────┼─────┘                          │
│                  │        │                                 │
│         ┌────────▼───┐  ┌─▼──────────┐                     │
│         │  SQLite    │  │  Firebase  │                     │
│         │  (Local)   │  │  (Cloud)   │                     │
│         └────────────┘  └─────┬──────┘                     │
└──────────────────────────────┼─────────────────────────────┘
                                │
                    ┌───────────▼────────────┐
                    │   Firebase Services    │
                    │  ┌──────────────────┐  │
                    │  │ Authentication   │  │
                    │  ├──────────────────┤  │
                    │  │ Firestore DB     │  │
                    │  ├──────────────────┤  │
                    │  │ Cloud Storage    │  │
                    │  ├──────────────────┤  │
                    │  │ Cloud Functions  │  │
                    │  ├──────────────────┤  │
                    │  │ Analytics        │  │
                    │  └──────────────────┘  │
                    └────────────────────────┘
```

---

## 🏗️ Architecture Layers (Clean Architecture)

### Layer 1 : Presentation (UI)

**Responsabilité :** Interface utilisateur et gestion d'état

**Composants :**
- **Screens** : Pages principales de l'app
  - `HomeScreen` : Avatar + progression quotidienne
  - `OnboardingScreens` : 5 écrans de setup initial
  - `PhotoValidationScreen` : Capture selfie
  - `CalendarScreen` : Historique mensuel
  - `ProfileScreen` : Stats + paramètres
  - etc.

- **Widgets** : Composants réutilisables
  - `AvatarDisplay` : Affichage avatar avec état
  - `StreakDisplay` : Compteur flame
  - `ProgressBar` : Barre progression hydratation
  - etc.

- **Providers (Riverpod)** : State management
  - `homeProvider` : État HomeScreen
  - `onboardingProvider` : Flow onboarding
  - `avatarStateProvider` : État temps réel avatar
  - `notificationProvider` : État notifications
  - etc.

**Technologies :**
- Flutter Widgets (Material Design 3)
- Riverpod 2.x pour state management
- Navigation 2.0 (GoRouter ou Navigator)

**Emplacement :** `lib/presentation/`

---

### Layer 2 : Domain (Business Logic)

**Responsabilité :** Logique métier pure (indépendante de Flutter et Firebase)

**Composants :**

#### Entities (objets métier)
- `User` : Utilisateur avec profil
- `Avatar` : Avatar avec personnalité
- `HydrationGoal` : Objectif quotidien
- `Streak` : Compteur jours consécutifs

#### Use Cases (actions métier)
- `CalculateHydrationGoalUseCase` : Calcul objectif personnalisé
- `UpdateAvatarStateUseCase` : Mise à jour état avatar selon temps
- `RecordHydrationUseCase` : Enregistrer validation verre
- `UpdateStreakUseCase` : Calcul streak quotidien
- `ScheduleNotificationUseCase` : Scheduling notifications
- etc.

#### Repository Interfaces (contrats)
- `AvatarRepository` (interface)
- `UserProfileRepository` (interface)
- `HydrationLogRepository` (interface)
- `StreakRepository` (interface)
- `NotificationStateRepository` (interface)

**Règles :**
- ✅ **Pure Dart** : Aucune dépendance Flutter ou Firebase
- ✅ **Testable** : 100% testable en isolation
- ✅ **Business rules** : Toute la logique métier ici

**Emplacement :** `lib/domain/`

---

### Layer 3 : Data (Implémentation Persistence)

**Responsabilité :** Implémentation concrète des repositories + modèles sérialisables

**Composants :**

#### Models (DTOs - Data Transfer Objects)
- `UserProfileModel` : Modèle avec toJson/fromJson
- `AvatarModel` : Modèle sérialisable
- `HydrationLogModel` : Modèle log hydratation
- etc.

#### Repository Implementations
- `AvatarRepositoryImpl` : Implémente `AvatarRepository`
  - Utilise `AvatarLocalDataSource` (SQLite)
  - Utilise `AvatarRemoteDataSource` (Firestore)
  - Gère sync local ↔ cloud

- `UserProfileRepositoryImpl`
- `HydrationLogRepositoryImpl`
- etc.

#### Data Sources

**Local Data Sources (SQLite) :**
- `AvatarLocalDataSource` : CRUD avatar dans SQLite
- `UserProfileLocalDataSource` : CRUD profil
- `HydrationLogLocalDataSource` : CRUD logs
- `StreakLocalDataSource` : CRUD streaks

**Remote Data Sources (Firebase) :**
- `UserRemoteDataSource` : Auth + Firestore users
- `HydrationLogRemoteDataSource` : Firestore logs (backup)
- `PhotoRemoteDataSource` : Firebase Storage (backup photos)

**Emplacement :** `lib/data/`

---

### Layer 4 : Core (Utilitaires Transverses)

**Responsabilité :** Éléments partagés par toutes les layers

**Composants :**
- **Constants** : `kDefaultGoalLiters`, `kAvatarStateTransitionDuration`, etc.
- **Theme** : Couleurs, fonts, styles Material
- **Utils** : Helpers (date formatting, validation, etc.)
- **DI (Dependency Injection)** : Configuration `get_it`
- **Error Handling** : Exceptions custom, error models

**Emplacement :** `lib/core/`

---

## 💾 Data Flow & Synchronization

### Offline-First Strategy

**Principe :** SQLite est la source de vérité. Firestore est backup + multi-device sync.

```
User Action (ex: Valider hydratation)
    │
    ▼
Presentation Layer (UI)
    │
    ▼
Use Case (RecordHydrationUseCase)
    │
    ▼
Repository (HydrationLogRepository)
    │
    ├──► Local DataSource (SQLite) ──► Sauvegarde IMMEDIATE ✅
    │                                   (App fonctionne offline)
    │
    └──► Remote DataSource (Firestore) ──► Sauvegarde ASYNC 🌐
                                           (Si réseau disponible)
```

**Sync Strategy :**

1. **Write :**
   - Écriture **prioritaire en local** (SQLite)
   - Écriture **async en cloud** (Firestore) en background
   - Si échec cloud → Retry automatique via queue

2. **Read :**
   - Lecture **depuis SQLite** (toujours disponible)
   - Firestore utilisé pour :
     - Multi-device sync (pull changes from cloud on app start)
     - Restore data si réinstallation app

3. **Conflict Resolution :**
   - **Last-write-wins** : Timestamp utilisé pour résoudre conflits
   - SQLite timestamp < Firestore timestamp → Pull cloud data
   - SQLite timestamp > Firestore timestamp → Push local data

---

## 🗄️ Database Schema

### SQLite (Local)

**Tables :**

#### `user_profile`
```sql
CREATE TABLE user_profile (
    id TEXT PRIMARY KEY,
    weight REAL NOT NULL,
    age INTEGER NOT NULL,
    gender TEXT NOT NULL,
    activity_level TEXT NOT NULL,
    location_permission_granted INTEGER NOT NULL,
    daily_goal_liters REAL NOT NULL,
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL
);
```

#### `avatar_state`
```sql
CREATE TABLE avatar_state (
    id TEXT PRIMARY KEY,
    selected_avatar_id TEXT NOT NULL,
    current_state TEXT NOT NULL,
    last_drink_time TEXT NOT NULL,
    last_updated TEXT NOT NULL
);
```

#### `hydration_logs`
```sql
CREATE TABLE hydration_logs (
    id TEXT PRIMARY KEY,
    timestamp TEXT NOT NULL,
    photo_path TEXT,
    glass_size TEXT NOT NULL,
    volume_liters REAL NOT NULL,
    validated INTEGER NOT NULL,
    synced_to_cloud INTEGER DEFAULT 0,
    created_at TEXT NOT NULL
);
CREATE INDEX idx_hydration_logs_timestamp ON hydration_logs(timestamp);
```

#### `streak_data`
```sql
CREATE TABLE streak_data (
    id TEXT PRIMARY KEY,
    current_streak INTEGER NOT NULL,
    longest_streak INTEGER NOT NULL,
    last_streak_date TEXT NOT NULL,
    streak_active INTEGER NOT NULL,
    updated_at TEXT NOT NULL
);
```

#### `notification_state`
```sql
CREATE TABLE notification_state (
    id TEXT PRIMARY KEY,
    current_level TEXT NOT NULL,
    last_notification_time TEXT,
    notifications_sent_today INTEGER NOT NULL,
    updated_at TEXT NOT NULL
);
```

---

### Firestore (Cloud Backup)

**Collections :**

#### `/users/{userId}`
```json
{
  "profile": {
    "weight": 75.0,
    "age": 30,
    "gender": "male",
    "activityLevel": "moderate",
    "dailyGoalLiters": 2.5,
    "createdAt": "2026-01-07T10:00:00Z",
    "updatedAt": "2026-01-07T10:00:00Z"
  },
  "avatar": {
    "selectedAvatarId": "sports_coach",
    "currentState": "fresh",
    "lastDrinkTime": "2026-01-07T14:30:00Z",
    "lastUpdated": "2026-01-07T14:30:00Z"
  },
  "streak": {
    "currentStreak": 7,
    "longestStreak": 15,
    "lastStreakDate": "2026-01-06",
    "streakActive": true,
    "updatedAt": "2026-01-07T00:00:00Z"
  }
}
```

#### `/users/{userId}/hydrationLogs/{logId}`
```json
{
  "timestamp": "2026-01-07T14:30:00Z",
  "photoPath": "local_path_or_storage_url",
  "glassSize": "medium",
  "volumeLiters": 0.25,
  "validated": true,
  "createdAt": "2026-01-07T14:30:00Z"
}
```

**Indexes :** `timestamp` DESC pour requêtes historiques

---

## 🔐 Authentication Flow

```
┌──────────────┐
│ App Launch   │
└──────┬───────┘
       │
       ▼
┌──────────────────────┐
│ Check SQLite         │
│ user_profile exists? │
└──────┬───────────────┘
       │
       ├─ NO ──► Onboarding Flow ──► Create Account (Firebase Auth)
       │                              ──► Save Profile (SQLite + Firestore)
       │
       └─ YES ─► Check Firebase Auth Token
                  │
                  ├─ Valid ──► Home Screen ✅
                  │
                  └─ Invalid/Expired ──► Re-authenticate
                                         (Email/Password, Apple, Google)
```

**Auth Methods :**
- Email/Password (Firebase Auth)
- Apple Sign-In (iOS obligatoire)
- Google Sign-In (Android)

**Token Storage :**
- `flutter_secure_storage` : Tokens auth chiffrés

---

## 📸 Photo Storage

### Local Storage (Primary)

**Emplacement :**
- iOS : `Application Documents/hydration_photos/`
- Android : `Internal Storage/hydration_photos/`

**Naming :** `hydration_YYYYMMDD_HHmmss.jpg`

**Cleanup :** Photos >90 jours supprimées automatiquement (job nocturne)

---

### Cloud Storage (Optional Backup)

**Firebase Storage :**
- Path : `/users/{userId}/photos/{photoId}.jpg`
- Compression : Quality 80%
- Max size : 500KB par photo
- **Opt-in** : User doit activer backup cloud dans settings

---

## 🔔 Notification System

### Local Notifications (Primary)

**Package :** `flutter_local_notifications`

**Flow :**
```
1. User ne boit pas pendant X heures
     ↓
2. UpdateAvatarStateUseCase calcule nouvel état
     ↓
3. CalculateNotificationLevelUseCase détermine escalade
     ↓
4. ScheduleNotificationUseCase schedule notification locale
     ↓
5. OS affiche notification (iOS/Android natif)
     ↓
6. User tape notification → Open app HomeScreen
```

**Levels :**
- Calm : 1 notification/heure
- Concerned : 1 notification/30min
- Dramatic : 1 notification/15min
- Chaos : Random 5-10min intervals

**Persistence :** État notification sauvegardé dans SQLite `notification_state`

---

### Push Notifications (V2 - Future)

**Firebase Cloud Messaging (FCM) :**
- Pour notifications triggered server-side (canicule alerts, etc.)
- Pas dans MVP

---

## ⏰ Background Jobs & Scheduled Tasks

### Timer-Based (In-App)

Quand l'app est **foreground** :

1. **Avatar State Update** : Timer.periodic(30 minutes)
   - Appelle `UpdateAvatarStateUseCase`
   - Met à jour UI si changement état

2. **Notification Scheduling** : Dynamic intervals selon level
   - Re-schedule après chaque validation hydratation

---

### Midnight Jobs (Resurrection Avatar, Streak Calc)

**Challenge :** Flutter apps ne garantissent pas exécution background à heure précise

**Solutions MVP :**

**Option A (Simplifiée - Recommandée MVP) :**
- Calcul **à la prochaine ouverture app**
- Vérifier : "Est-ce qu'on a changé de jour depuis last update ?"
- Si oui → Exécuter `UpdateStreakUseCase` et résurrection avatar
- **Avantage :** Simple, fiable, pas de background complexe

**Option B (Firebase Cloud Functions - V2) :**
- Cloud Function scheduled quotidiennement à 00h00
- Calcule streak pour tous users
- Push notification si besoin
- **Inconvénient :** Complexité + coût Firebase Blaze

**MVP → Option A**

---

## 🔄 App Lifecycle & State Persistence

### App States

```
App Launch (Cold Start)
    ↓
┌───────────────────┐
│ SplashScreen      │ ← Logo + loading
└────────┬──────────┘
         │
         ▼
┌──────────────────────────┐
│ Check User Profile       │
│ (SQLite user_profile)    │
└────────┬─────────────────┘
         │
         ├─ NO ──► OnboardingFlow (5 screens)
         │             ↓
         │         Save Profile
         │             ↓
         │         HomeScreen
         │
         └─ YES ──► HomeScreen

HomeScreen (Running)
    ↓
User minimizes app → App paused (iOS/Android background)
    ↓
Timers stopped, state sauvegardé
    ↓
User reopens app → App resumed
    ↓
Re-check avatar state, refresh UI
```

---

## 📊 Analytics & Monitoring

### Events Tracked (Firebase Analytics)

**User Events :**
- `app_open` : App launched
- `onboarding_completed` : Onboarding terminé
- `avatar_selected` : Choix avatar
- `hydration_validated` : Verre validé (props: glassSize, photoTaken)
- `notification_sent` : Notification envoyée (props: level, personality)
- `notification_opened` : User tape notification
- `streak_milestone` : Streak atteint (props: days)
- `avatar_died` : Avatar mort
- `avatar_resurrected` : Avatar ressuscité

**Technical Events :**
- `photo_validation_failed` : Échec capture photo
- `sync_failed` : Échec sync Firestore
- `crash` : Crash app (via Crashlytics)

---

## 🛡️ Security Architecture

### Authentication Security

- Firebase Auth tokens (JWT)
- Auto-refresh tokens avant expiration
- Secure storage via `flutter_secure_storage`

### Data Security

- **In Transit :** HTTPS only (Firebase enforce SSL)
- **At Rest :** SQLite non chiffré (MVP), photos locales non chiffrées
  - V2 : `sqflite_sqlcipher` pour chiffrement DB

### Permissions

Demandées **juste-in-time** (quand nécessaire) :

1. **Caméra** : Demandée lors du premier tap "Je bois"
2. **Notifications** : Demandée post-onboarding
3. **Localisation** : Demandée (optionnelle) en onboarding

---

## 🚀 Deployment Architecture

### Build Process

```
Code Repository (GitHub)
    ↓
GitHub Actions CI/CD
    ↓
    ├──► Build Android APK/AAB
    │       ↓
    │   Google Play Console
    │       ↓
    │   Internal Track → Beta → Production
    │
    └──► Build iOS IPA
            ↓
        App Store Connect
            ↓
        TestFlight → App Review → Production
```

### Environments

**Development :**
- Firebase Project : `hydrate-or-die-dev`
- App ID : `com.hydrateordie.app.dev`

**Production :**
- Firebase Project : `hydrate-or-die-prod`
- App ID : `com.hydrateordie.app`

---

## 📐 Folder Structure (Détaillée)

```
lib/
├── main.dart                    # Entry point
├── core/
│   ├── constants/
│   │   ├── app_constants.dart   # kDefaultGoalLiters, etc.
│   │   └── asset_paths.dart     # Chemins assets
│   ├── theme/
│   │   └── app_theme.dart       # Material theme
│   ├── utils/
│   │   ├── date_utils.dart      # Helpers dates
│   │   └── validators.dart      # Validation inputs
│   ├── di/
│   │   └── injection.dart       # get_it setup
│   └── errors/
│       └── exceptions.dart      # Custom exceptions
│
├── data/
│   ├── models/
│   │   ├── user_profile_model.dart
│   │   ├── avatar_model.dart
│   │   ├── hydration_log_model.dart
│   │   └── streak_model.dart
│   ├── data_sources/
│   │   ├── local/
│   │   │   ├── avatar_local_data_source.dart
│   │   │   ├── user_profile_local_data_source.dart
│   │   │   ├── hydration_log_local_data_source.dart
│   │   │   └── database_helper.dart  # SQLite setup
│   │   └── remote/
│   │       ├── user_remote_data_source.dart
│   │       ├── hydration_log_remote_data_source.dart
│   │       └── photo_remote_data_source.dart
│   └── repositories/
│       ├── avatar_repository_impl.dart
│       ├── user_profile_repository_impl.dart
│       ├── hydration_log_repository_impl.dart
│       └── streak_repository_impl.dart
│
├── domain/
│   ├── entities/
│   │   ├── user.dart
│   │   ├── avatar.dart
│   │   ├── hydration_goal.dart
│   │   └── streak.dart
│   ├── repositories/
│   │   ├── avatar_repository.dart        # Interface
│   │   ├── user_profile_repository.dart  # Interface
│   │   ├── hydration_log_repository.dart # Interface
│   │   └── streak_repository.dart        # Interface
│   └── use_cases/
│       ├── calculate_hydration_goal_use_case.dart
│       ├── update_avatar_state_use_case.dart
│       ├── record_hydration_use_case.dart
│       ├── update_streak_use_case.dart
│       └── schedule_notification_use_case.dart
│
└── presentation/
    ├── providers/
    │   ├── home_provider.dart
    │   ├── onboarding_provider.dart
    │   ├── avatar_state_provider.dart
    │   └── notification_provider.dart
    ├── screens/
    │   ├── home/
    │   │   ├── home_screen.dart
    │   │   └── widgets/
    │   │       └── avatar_display.dart
    │   ├── onboarding/
    │   │   ├── avatar_selection_screen.dart
    │   │   ├── weight_screen.dart
    │   │   ├── age_screen.dart
    │   │   └── ...
    │   ├── photo/
    │   │   ├── photo_validation_screen.dart
    │   │   ├── glass_size_selection_screen.dart
    │   │   └── feedback_screen.dart
    │   ├── calendar/
    │   │   └── calendar_screen.dart
    │   └── profile/
    │       ├── profile_screen.dart
    │       └── settings_screen.dart
    └── widgets/
        ├── avatar_display.dart
        ├── streak_display.dart
        └── progress_bar.dart
```

---

## ✅ Architecture Validation Checklist

- [x] **Offline-first** : SQLite source de vérité ✅
- [x] **Testabilité** : Domain layer 100% pure Dart ✅
- [x] **Scalabilité** : Clean Architecture modulaire ✅
- [x] **Performance** : Queries SQL indexées, async ops ✅
- [x] **Security** : HTTPS, secure storage, RGPD ✅
- [x] **Multi-platform** : iOS + Android avec Flutter ✅
- [x] **Cost-effective** : Firebase Spark gratuit MVP ✅

---

*Document créé le 2026-01-07 par PM John & Architect*
*Architecture validée et figée pour MVP - Modifications nécessitent validation PM + Architect*
