# Architecture Document - Hydrate or Die MVP

**Version:** 2.0 (Détaillée - Contrats Pre-Development)
**Date:** 2026-01-07
**Owner:** Winston (Architect) & Product Manager John
**Status:** DRAFT - Awaiting PM Validation
**Based On:** PRD v1.0, Tech Stack v1.0, System Architecture v1.0

---

## 🎯 Executive Summary

Hydrate or Die est une application mobile cross-platform (iOS/Android) construite avec **Flutter** et **Clean Architecture**, utilisant **Firebase** comme Backend-as-a-Service et **SQLite** pour la persistence locale offline-first. L'application combine un système d'avatar Tamagotchi, validation photo par selfie, notifications punitives progressives et mécaniques de rétention (streaks) pour transformer l'hydratation en habitude engageante.

**Principes Architecturaux Fondamentaux:**
- **Offline-First:** SQLite est la source de vérité, Firestore le backup cloud
- **Clean Architecture:** Séparation stricte Presentation/Domain/Data
- **Testabilité:** Domain layer 100% pure Dart, injectable, testable en isolation
- **RGPD Compliance:** Data minimization, consent explicite, droit à l'effacement

---

## 📐 Vue d'Ensemble Architecture Globale

```
┌─────────────────────────────────────────────────────────────────┐
│                         USER DEVICES                             │
│   ┌──────────────────────┐       ┌──────────────────────┐       │
│   │   iOS (iPhone/iPad)  │       │  Android (Phone/Tab) │       │
│   │    iOS 15+           │       │   Android 10+ (API29)│       │
│   └──────────┬───────────┘       └───────────┬──────────┘       │
│              │                               │                   │
│              └───────────┬───────────────────┘                   │
│                          │                                       │
│              ┌───────────▼────────────┐                         │
│              │   FLUTTER APP (Dart)   │                         │
│              │   ┌─────────────────┐  │                         │
│              │   │ PRESENTATION    │◄─┼─ Riverpod State Mgmt   │
│              │   │ - Screens       │  │   Material Design 3     │
│              │   │ - Widgets       │  │   Navigation 2.0        │
│              │   │ - Providers     │  │                         │
│              │   └────────┬────────┘  │                         │
│              │   ┌────────▼────────┐  │                         │
│              │   │ DOMAIN          │◄─┼─ Pure Dart Logic       │
│              │   │ - Entities      │  │   Use Cases             │
│              │   │ - Repositories  │  │   (100% Testable)       │
│              │   │ - Use Cases     │  │                         │
│              │   └────────┬────────┘  │                         │
│              │   ┌────────▼────────┐  │                         │
│              │   │ DATA            │◄─┼─ Models/DTOs           │
│              │   │ - Models        │  │   Repository Impl       │
│              │   │ - Repositories  │  │   Data Sources          │
│              │   │ - Data Sources  │  │                         │
│              │   └───┬─────────┬───┘  │                         │
│              └───────┼─────────┼──────┘                         │
│                      │         │                                 │
│          ┌───────────▼───┐  ┌─▼────────────┐                   │
│          │ LOCAL STORAGE │  │ DEVICE APIs  │                   │
│          │ - SQLite DB   │  │ - Camera     │                   │
│          │ - SharedPrefs │  │ - Notifs     │                   │
│          │ - File System │  │ - Permissions│                   │
│          │ (Photos)      │  │              │                   │
│          └───────────────┘  └──────────────┘                   │
│                      │                                          │
└──────────────────────┼──────────────────────────────────────────┘
                       │
                       │ HTTPS Only
                       │ (When Online)
                       │
           ┌───────────▼─────────────┐
           │   FIREBASE SERVICES     │
           │  ┌────────────────────┐ │
           │  │ Authentication     │ │ ← Email/Password
           │  │ (Firebase Auth)    │ │   Apple Sign-In
           │  │                    │ │   Google Sign-In
           │  ├────────────────────┤ │
           │  │ Cloud Firestore    │ │ ← User Backup
           │  │ (NoSQL Database)   │ │   Multi-Device Sync
           │  ├────────────────────┤ │
           │  │ Cloud Storage      │ │ ← Photos Backup
           │  │ (Object Storage)   │ │   (Opt-in)
           │  ├────────────────────┤ │
           │  │ Cloud Functions    │ │ ← Serverless Jobs
           │  │ (Optional V2)      │ │   (Midnight Tasks)
           │  ├────────────────────┤ │
           │  │ Analytics          │ │ ← User Events
           │  │ Crashlytics        │ │   Crash Reports
           │  └────────────────────┘ │
           └─────────────────────────┘
```

---

## 🏗️ Clean Architecture - Layer Détails

### Layer 1: Presentation (UI & State Management)

**Responsabilité:** Interface utilisateur, gestion d'état réactif, navigation

**Structure:**
```
lib/presentation/
├── providers/              # Riverpod StateNotifiers
│   ├── home_provider.dart
│   ├── onboarding_provider.dart
│   ├── avatar_state_provider.dart
│   ├── photo_validation_provider.dart
│   ├── notification_provider.dart
│   ├── streak_provider.dart
│   └── calendar_provider.dart
├── screens/
│   ├── splash/
│   │   └── splash_screen.dart
│   ├── onboarding/
│   │   ├── avatar_selection_screen.dart
│   │   ├── weight_screen.dart
│   │   ├── age_screen.dart
│   │   ├── gender_screen.dart
│   │   ├── activity_screen.dart
│   │   ├── location_screen.dart
│   │   └── summary_screen.dart
│   ├── home/
│   │   ├── home_screen.dart
│   │   └── widgets/
│   │       ├── avatar_display.dart
│   │       ├── progress_bar.dart
│   │       └── hydration_summary.dart
│   ├── photo/
│   │   ├── photo_validation_screen.dart
│   │   ├── glass_size_selection_screen.dart
│   │   └── feedback_screen.dart
│   ├── calendar/
│   │   ├── calendar_screen.dart
│   │   └── widgets/
│   │       ├── month_view.dart
│   │       └── day_detail_modal.dart
│   ├── profile/
│   │   ├── profile_screen.dart
│   │   ├── edit_profile_screen.dart
│   │   ├── settings_screen.dart
│   │   ├── notification_settings_screen.dart
│   │   └── achievements_screen.dart (V2)
│   └── common/
│       └── widgets/
│           ├── streak_display.dart
│           ├── custom_button.dart
│           └── loading_overlay.dart
└── navigation/
    └── app_router.dart         # GoRouter config
```

**Technologies:**
- Flutter Material Design 3
- Riverpod 2.x (State Management)
- GoRouter (Navigation 2.0)

**Règles:**
- ✅ Les screens ne contiennent AUCUNE logique métier
- ✅ Toute logique passe par les Use Cases via Providers
- ✅ Les widgets sont réutilisables et composables
- ✅ Les providers observent les repositories via Riverpod streams

---

### Layer 2: Domain (Business Logic - Pure Dart)

**Responsabilité:** Logique métier pure, indépendante de Flutter et Firebase

**Structure:**
```
lib/domain/
├── entities/
│   ├── user.dart
│   ├── avatar.dart
│   ├── hydration_goal.dart
│   ├── streak.dart
│   ├── notification_state.dart
│   └── achievement.dart (V2)
├── repositories/               # INTERFACES ONLY
│   ├── avatar_repository.dart
│   ├── user_profile_repository.dart
│   ├── hydration_log_repository.dart
│   ├── streak_repository.dart
│   ├── notification_state_repository.dart
│   └── photo_storage_repository.dart
└── use_cases/
    ├── auth/
    │   ├── sign_up_use_case.dart
    │   ├── sign_in_use_case.dart
    │   └── sign_out_use_case.dart
    ├── avatar/
    │   ├── get_avatar_use_case.dart
    │   ├── update_avatar_state_use_case.dart
    │   └── select_avatar_use_case.dart
    ├── hydration/
    │   ├── record_hydration_use_case.dart
    │   ├── get_todays_logs_use_case.dart
    │   ├── calculate_hydration_goal_use_case.dart
    │   └── get_hydration_progress_use_case.dart
    ├── streak/
    │   ├── update_streak_use_case.dart
    │   ├── get_current_streak_use_case.dart
    │   └── get_monthly_status_use_case.dart
    ├── notifications/
    │   ├── calculate_notification_level_use_case.dart
    │   ├── schedule_notification_use_case.dart
    │   ├── get_notification_message_use_case.dart
    │   └── cancel_notifications_use_case.dart
    └── profile/
        ├── create_user_profile_use_case.dart
        ├── update_user_profile_use_case.dart
        ├── delete_user_data_use_case.dart
        └── get_user_profile_use_case.dart
```

**Règles Strictes:**
- ✅ **Zero dépendance Flutter** : Pure Dart uniquement
- ✅ **Zero dépendance Firebase** : Abstraction via interfaces
- ✅ **100% Testable** : Tous les use cases mockables via DI
- ✅ **Single Responsibility** : 1 use case = 1 action métier

**Exemple Use Case Pattern:**
```dart
// Interface Repository (dans domain/)
abstract class AvatarRepository {
  Future<Avatar> getAvatar();
  Future<void> updateAvatarState(AvatarState state);
}

// Use Case (dans domain/)
class UpdateAvatarStateUseCase {
  final AvatarRepository _repository;

  UpdateAvatarStateUseCase(this._repository);

  Future<void> execute(Duration timeSinceLastDrink) async {
    final newState = _calculateState(timeSinceLastDrink);
    await _repository.updateAvatarState(newState);
  }

  AvatarState _calculateState(Duration time) {
    // Pure business logic
    if (time.inHours < 2) return AvatarState.fresh;
    if (time.inHours < 4) return AvatarState.tired;
    if (time.inHours < 6) return AvatarState.dehydrated;
    return AvatarState.dead;
  }
}
```

---

### Layer 3: Data (Implémentation Repositories & Models)

**Responsabilité:** Implémentation concrète des repositories, modèles sérialisables, data sources

**Structure:**
```
lib/data/
├── models/                     # DTOs (Data Transfer Objects)
│   ├── user_profile_model.dart
│   ├── avatar_model.dart
│   ├── hydration_log_model.dart
│   ├── streak_model.dart
│   ├── notification_state_model.dart
│   └── achievement_model.dart (V2)
├── repositories/               # IMPLEMENTATIONS
│   ├── avatar_repository_impl.dart
│   ├── user_profile_repository_impl.dart
│   ├── hydration_log_repository_impl.dart
│   ├── streak_repository_impl.dart
│   ├── notification_state_repository_impl.dart
│   └── photo_storage_repository_impl.dart
└── data_sources/
    ├── local/
    │   ├── database_helper.dart        # SQLite setup
    │   ├── avatar_local_data_source.dart
    │   ├── user_profile_local_data_source.dart
    │   ├── hydration_log_local_data_source.dart
    │   ├── streak_local_data_source.dart
    │   ├── notification_local_data_source.dart
    │   └── photo_file_storage.dart
    └── remote/
        ├── firebase_auth_data_source.dart
        ├── user_remote_data_source.dart
        ├── hydration_remote_data_source.dart
        └── photo_remote_storage.dart
```

**Sync Strategy (Offline-First):**

```
┌──────────────────────────────────────────────────┐
│         Repository Pattern (Example)             │
├──────────────────────────────────────────────────┤
│                                                  │
│  User Action → Use Case → Repository             │
│                              │                   │
│                              ├──► LocalDataSource│
│                              │    (SQLite)       │
│                              │    ✅ IMMEDIATE   │
│                              │    (Offline OK)   │
│                              │                   │
│                              └──► RemoteDataSource│
│                                   (Firestore)    │
│                                   ⏳ ASYNC       │
│                                   (If online)    │
│                                                  │
│  Sync Logic:                                     │
│  - Write: Local first, Remote async              │
│  - Read: Local always (fast)                     │
│  - Conflict: Last-write-wins (timestamp)         │
│  - Retry: Queue failed remote writes             │
└──────────────────────────────────────────────────┘
```

**Exemple Repository Implementation:**
```dart
class HydrationLogRepositoryImpl implements HydrationLogRepository {
  final HydrationLogLocalDataSource _localDataSource;
  final HydrationLogRemoteDataSource _remoteDataSource;

  // Constructor avec DI
  HydrationLogRepositoryImpl(this._localDataSource, this._remoteDataSource);

  @override
  Future<void> addLog(HydrationLog log) async {
    // 1. Sauvegarde IMMEDIATE locale (offline-first)
    await _localDataSource.insert(log.toModel());

    // 2. Sauvegarde ASYNC cloud (best effort)
    try {
      await _remoteDataSource.insert(log.toModel());
    } catch (e) {
      // Queue for retry (handled by sync service)
      _queueForRetry(log);
    }
  }

  @override
  Future<List<HydrationLog>> getTodayLogs() async {
    // Toujours lire depuis local (offline-first)
    final models = await _localDataSource.getLogsForDate(DateTime.now());
    return models.map((m) => m.toEntity()).toList();
  }
}
```

---

### Layer 4: Core (Utilitaires Transverses)

**Structure:**
```
lib/core/
├── constants/
│   ├── app_constants.dart      # Business constants
│   ├── asset_paths.dart        # Asset file paths
│   └── notification_constants.dart
├── theme/
│   ├── app_theme.dart          # Material theme
│   ├── app_colors.dart
│   └── app_text_styles.dart
├── utils/
│   ├── date_utils.dart
│   ├── validators.dart
│   ├── formatters.dart
│   └── permission_utils.dart
├── di/
│   └── injection.dart          # get_it setup
├── errors/
│   ├── failures.dart
│   └── exceptions.dart
└── services/
    ├── notification_service.dart
    ├── analytics_service.dart
    └── background_job_service.dart
```

**Dependency Injection Setup (get_it):**
```dart
// core/di/injection.dart
final getIt = GetIt.instance;

void setupDependencies() {
  // Data Sources
  getIt.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
  getIt.registerLazySingleton<AvatarLocalDataSource>(
    () => AvatarLocalDataSourceImpl(getIt()),
  );
  // ... autres data sources

  // Repositories
  getIt.registerLazySingleton<AvatarRepository>(
    () => AvatarRepositoryImpl(getIt(), getIt()),
  );
  // ... autres repositories

  // Use Cases
  getIt.registerLazySingleton(() => UpdateAvatarStateUseCase(getIt()));
  getIt.registerLazySingleton(() => RecordHydrationUseCase(getIt()));
  // ... autres use cases

  // Services
  getIt.registerLazySingleton(() => NotificationService());
  getIt.registerLazySingleton(() => AnalyticsService());
}
```

---

## 💾 Data Architecture

### Offline-First Data Flow

```
USER ACTION (Ex: Valider hydratation)
    │
    ▼
[PRESENTATION] PhotoValidationProvider
    │
    ▼
[DOMAIN] RecordHydrationUseCase.execute()
    │
    ├──► [DOMAIN] UpdateAvatarStateUseCase.execute()
    │         │
    │         └──► [DATA] AvatarRepository.updateState()
    │                  │
    │                  ├──► LOCAL (SQLite) ✅ IMMEDIATE
    │                  └──► REMOTE (Firestore) ⏳ ASYNC
    │
    └──► [DATA] HydrationLogRepository.addLog()
           │
           ├──► LOCAL (SQLite) ✅ IMMEDIATE
           └──► REMOTE (Firestore) ⏳ ASYNC

RESULT: UI mise à jour immédiatement (depuis local)
        Cloud sync en background (transparent)
```

### Database Schema (Détails dans contracts/database-schema.md)

**SQLite (Local - Source de Vérité):**
- `user_profile` : Profil utilisateur unique
- `avatar_state` : État avatar actuel
- `hydration_logs` : Historique validations
- `streak_data` : Données streaks
- `notification_state` : État notifications

**Firestore (Cloud - Backup & Sync):**
- Collection `/users/{userId}`
  - Document `profile`
  - Document `avatar`
  - Document `streak`
  - SubCollection `hydrationLogs/{logId}`

---

## 🔔 Notification Architecture

### Local Notifications System

```
┌────────────────────────────────────────────────────┐
│         NOTIFICATION ESCALATION SYSTEM             │
├────────────────────────────────────────────────────┤
│                                                    │
│  Timer (Background) - Every 15min                  │
│       │                                            │
│       ▼                                            │
│  CalculateNotificationLevelUseCase                 │
│       │                                            │
│       ├──► Niveau CALM (0-2h)                     │
│       │    Fréquence: 1x/heure                    │
│       │    Ton: Calme, doux                        │
│       │                                            │
│       ├──► Niveau CONCERNED (2-4h)                │
│       │    Fréquence: 1x/30min                    │
│       │    Ton: Préoccupé                         │
│       │                                            │
│       ├──► Niveau DRAMATIC (4-6h)                 │
│       │    Fréquence: 1x/15min                    │
│       │    Ton: Mélodramatique, caps lock         │
│       │                                            │
│       └──► Niveau CHAOS (6h+)                     │
│            Fréquence: 5-10min RANDOM              │
│            Ton: SPAM, vulgarité censurée          │
│            Vibrations: Pattern agaçant             │
│                                                    │
│  ScheduleNotificationUseCase                       │
│       │                                            │
│       ▼                                            │
│  flutter_local_notifications                       │
│       │                                            │
│       ▼                                            │
│  OS Native Notification (iOS/Android)              │
└────────────────────────────────────────────────────┘

PAUSE NOCTURNE: 22h00 - 7h00 (configurable)
```

### Notification Message Generation

```dart
// Pattern Provider
class NotificationMessageProvider {
  String getMessage(AvatarPersonality personality, NotificationLevel level) {
    final messages = _messagesMap[personality]![level]!;
    return messages[Random().nextInt(messages.length)];
  }

  // 4 avatars × 4 niveaux = 16 pools de messages
  // Chaque pool contient 5-10 messages variés
}
```

---

## 📸 Photo Validation Architecture

### Photo Capture & Storage Flow

```
USER: Tap "Je bois"
    │
    ▼
[SCREEN] PhotoValidationScreen
    │
    ├──► Demande Permission Caméra
    │    (si pas accordée)
    │
    ├──► Affiche Preview Caméra Frontale
    │    avec cadre guidé
    │
    └──► USER: Tap Capture
         │
         ▼
    [Use Case] CapturePhotoUseCase
         │
         ├──► Capture Image (camera package)
         ├──► Compression (quality 80%)
         ├──► Save to Local Storage
         │    └──► Path: /app_documents/hydration_photos/
         │          Filename: hydration_YYYYMMDD_HHmmss.jpg
         │
         └──► (Optionnel) Validation Photo
              └──► ValidatePhotoUseCase
                   ├──► Détection verre basique
                   └──► Warning si pas de verre détecté
                        (non bloquant)

    ▼
[SCREEN] GlassSizeSelectionScreen
    │
    └──► USER: Sélectionne taille (200ml/250ml/400ml)
         │
         ▼
    [Use Case] RecordHydrationUseCase
         │
         ├──► Crée HydrationLog
         │    (timestamp, photoPath, glassSize)
         ├──► Save to Repository
         └──► Update Avatar State (fresh)

    ▼
[SCREEN] FeedbackScreen
    └──► Animation Avatar Positif
         Message encourageant
         Affichage progression
```

**Storage:**
- Local: iOS `Application Documents/`, Android `Internal Storage/`
- Cleanup: Photos >90 jours supprimées automatiquement
- Cloud (Opt-in): Firebase Storage backup

---

## 🔄 Background Jobs & Timers

### App Lifecycle Management

```
┌──────────────────────────────────────────────┐
│          APP LIFECYCLE & JOBS                │
├──────────────────────────────────────────────┤
│                                              │
│  APP LAUNCH (Cold Start)                     │
│       │                                      │
│       ├──► Check User Profile Exists         │
│       │    NO → OnboardingFlow               │
│       │    YES → HomeScreen                  │
│       │                                      │
│       ├──► Initialize Background Jobs:       │
│       │    • AvatarStateUpdateTimer (30min)  │
│       │    • NotificationLevelTimer (15min)  │
│       │    • StreakCheckJob (on open)        │
│       │                                      │
│       └──► Sync Remote Data (if online)      │
│            • Pull Firestore updates          │
│            • Push queued local changes       │
│                                              │
│  APP PAUSED (Background)                     │
│       │                                      │
│       └──► Timers continue (iOS/Android BG)  │
│            Notifications schedulées          │
│                                              │
│  APP RESUMED (Foreground)                    │
│       │                                      │
│       ├──► Recalculate Avatar State          │
│       ├──► Check Streak (if day changed)     │
│       └──► Refresh UI                        │
│                                              │
│  MIDNIGHT (00h00 Local)                      │
│       │                                      │
│       ├──► UpdateStreakUseCase               │
│       │    • Check yesterday goal            │
│       │    • Increment or break streak       │
│       │                                      │
│       ├──► Reset NotificationLevel to CALM   │
│       │                                      │
│       └──► Resurrect Avatar (if ghost)       │
│                                              │
└──────────────────────────────────────────────┘

IMPLEMENTATION:
- Option A (MVP): Jobs exécutés "on next app open"
- Option B (V2): Firebase Cloud Functions scheduled
```

---

## 🔐 Security & Authentication Architecture

### Authentication Flow

```
┌─────────────────────────────────────────────┐
│         AUTHENTICATION FLOW                 │
├─────────────────────────────────────────────┤
│                                             │
│  Onboarding Complete                        │
│       │                                     │
│       ▼                                     │
│  SignUpUseCase                              │
│       │                                     │
│       ├──► Email/Password                   │
│       │    (Firebase Auth)                  │
│       │                                     │
│       ├──► Apple Sign-In (iOS)              │
│       │    (Firebase Auth)                  │
│       │                                     │
│       └──► Google Sign-In (Android)         │
│            (Firebase Auth)                  │
│                                             │
│       ▼                                     │
│  Token Received (JWT)                       │
│       │                                     │
│       └──► Store in flutter_secure_storage  │
│            (iOS Keychain, Android Encrypted)│
│                                             │
│  APP LAUNCH (Next Time)                     │
│       │                                     │
│       ├──► Load Token                       │
│       ├──► Verify Token Valid               │
│       │    • YES → Auto Login               │
│       │    • NO → Re-authenticate           │
│       │                                     │
│       └──► Initialize Firestore with UID    │
│                                             │
└─────────────────────────────────────────────┘

SECURITY:
- HTTPS only (Firebase enforce SSL)
- Token auto-refresh avant expiration
- Certificate pinning (Production)
```

### Data Privacy & RGPD

**Données Collectées (Minimum):**
- Poids, Âge, Sexe, Niveau activité (pour calcul objectif)
- Localisation optionnelle (pour météo V2)
- Photos selfies (stockage local par défaut)
- Timestamps hydratation (historique)

**RGPD Compliance:**
- ✅ Consent explicite (checkbox onboarding)
- ✅ Data minimization (seulement nécessaire)
- ✅ Droit à l'effacement (bouton "Supprimer compte")
- ✅ Portabilité (export JSON possible V2)
- ✅ Privacy Policy & Terms of Service

**Delete Account Flow:**
```
User: Tap "Supprimer mon compte"
    │
    ▼
Confirmation Dialog
    │
    └──► Confirmed
         │
         ▼
    DeleteUserDataUseCase
         │
         ├──► Delete SQLite tables
         ├──► Delete local photos
         ├──► Delete shared_preferences
         ├──► Delete Firestore user document
         ├──► Delete Firebase Storage photos
         └──► Sign Out Firebase Auth

    ▼
Navigate to OnboardingFlow (clean slate)
```

---

## 📊 Analytics & Monitoring

### Events Tracked (Firebase Analytics)

**User Events:**
- `app_open`
- `onboarding_completed`
- `avatar_selected` (props: avatarId, personality)
- `hydration_validated` (props: glassSize, photoTaken)
- `notification_sent` (props: level, personality, timeSinceLastDrink)
- `notification_opened`
- `streak_milestone` (props: days)
- `avatar_died`
- `avatar_resurrected`
- `goal_achieved` (props: volumeTotal, percentOver)

**Technical Events:**
- `photo_validation_failed` (props: reason)
- `sync_failed` (props: operation, error)
- `permission_denied` (props: permissionType)

**Crashlytics:**
- Automatic crash reports
- Custom logs pour debug

---

## 🚀 Deployment & CI/CD Architecture

### Build & Release Pipeline

```
┌──────────────────────────────────────────────────┐
│            CI/CD PIPELINE (GitHub Actions)       │
├──────────────────────────────────────────────────┤
│                                                  │
│  TRIGGER: git push, Pull Request                 │
│      │                                           │
│      ▼                                           │
│  ┌────────────────────────────────┐             │
│  │  CI - Continuous Integration   │             │
│  ├────────────────────────────────┤             │
│  │                                │             │
│  │  1. Checkout Code              │             │
│  │  2. Setup Flutter (stable)     │             │
│  │  3. flutter pub get            │             │
│  │  4. dart format --set-exit-if-changed .│     │
│  │  5. flutter analyze (0 errors) │             │
│  │  6. flutter test --coverage    │             │
│  │     (coverage >70% domain)     │             │
│  │  7. Upload coverage (Codecov)  │             │
│  │                                │             │
│  └───────────┬────────────────────┘             │
│              │                                   │
│              ▼ PASS                              │
│  ┌────────────────────────────────┐             │
│  │  CD - Continuous Deployment    │             │
│  ├────────────────────────────────┤             │
│  │                                │             │
│  │  ANDROID:                      │             │
│  │  • flutter build apk --release │             │
│  │  • flutter build appbundle     │             │
│  │  • Deploy to Play Store        │             │
│  │    (Internal → Beta → Prod)    │             │
│  │                                │             │
│  │  iOS:                          │             │
│  │  • flutter build ipa           │             │
│  │  • Deploy to TestFlight        │             │
│  │  • Submit to App Review        │             │
│  │                                │             │
│  └────────────────────────────────┘             │
│                                                  │
└──────────────────────────────────────────────────┘

ENVIRONMENTS:
- dev: Firebase Project "hydrate-or-die-dev"
- prod: Firebase Project "hydrate-or-die-prod"

VERSIONING: Semantic (MAJOR.MINOR.PATCH)
- 1.0.0 → MVP Initial Release
- 1.1.0 → Minor Features/Improvements
- 2.0.0 → Major Changes (V2)
```

---

## ✅ Architecture Validation Checklist

Selon governance.md - Section "Checklist Pre-Development":

- [x] Architecture globale documentée avec diagrammes
- [x] Flux de données (data flow) définis
- [x] Patterns architecturaux justifiés (Clean Architecture)
- [x] Décisions techniques justifiées (Firebase, Riverpod, SQLite)
- [x] Structure dossiers détaillée avec conventions
- [x] Offline-first strategy définie
- [x] Security & RGPD compliance adressés
- [x] CI/CD pipeline décrit
- [x] Background jobs & timers planifiés
- [ ] Contrats d'interface créés (prochaine étape)
- [ ] Validation PM (awaiting)

---

## 🚀 V2 Features & Future Enhancements

### Weather API Integration (V2)

**Purpose:** Ajuster rappels hydratation selon conditions météo

**Architecture:**

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

**API Options:**

1. **OpenWeatherMap API** (Recommended)
   - Free tier: 1000 calls/day
   - Current weather + forecasts
   - Cost: 0€ pour MVP, ~$40/mo pour 100k users

2. **WeatherAPI.com**
   - Free tier: 1M calls/month
   - Alternative viable

**New Components (V2):**

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

**Notification Integration:**

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

**Privacy & Permissions:**

- Localisation déjà collectée en onboarding (optionnelle)
- Si permission refusée → Pas de weather adjustment (fallback objectif standard)
- Weather data NON stockée (ephemeral, fetched on demand)

**Cost Analysis:**

- Free tier OpenWeatherMap: 1000 calls/day = 30k/month
- Estimation calls: 1 call/user/day = 10k users OK dans free tier
- Au-delà 10k users: $40/mo (100k calls/jour)

**Implementation Timeline:**

- V2 (Post-MVP, après traction validée)
- Estimation: 1-2 sprints (Epic 6)

---

### Other V2 Features Planned

**Apple Watch / Wear OS Integration:**
- Quick validation depuis montre
- Notifications haptiques
- Water tracking widget

**Advanced Analytics Dashboard:**
- Tendances hebdomadaires/mensuelles
- Comparaison objectifs atteints
- Insights personnalisés

**Social Features:**
- Challenges entre amis
- Leaderboards streaks
- Partage achievements

**Premium Avatar Packs:**
- Avatars additionnels payants
- Animations custom
- Monétisation freemium

---

## 📋 Prochaines Étapes

### Documents de Contrats à Créer

1. **docs/contracts/data-models.md** - Tous les models/DTOs/entities
2. **docs/contracts/database-schema.md** - SQLite + Firestore schémas complets
3. **docs/contracts/api-contracts.md** - Firebase Auth/Firestore/Storage APIs
4. **docs/contracts/repositories-interface.md** - Interfaces repositories
5. **docs/contracts/use-cases-interface.md** - Interfaces use cases

### Après Validation PM

6. Créer structure `lib/` selon conventions
7. Setup `pubspec.yaml` avec dépendances MVP
8. Configurer Firebase (iOS + Android)
9. Setup GitHub Actions CI/CD
10. Créer tests dummy pour valider CI

---

**Document créé le 2026-01-07 par Winston (Architect)**
**Status: DRAFT - Awaiting PM Validation**
**Next: Créer contracts/ directory avec tous les contrats d'interface**
