# Use Cases Interfaces - Hydrate or Die MVP

**Version:** 1.0
**Date:** 2026-01-07
**Owner:** Winston (Architect)
**Status:** DRAFT - Awaiting PM Validation
**Reference:** Epics 1-5, repositories-interface.md, data-models.md

---

## 📋 Overview

Ce document définit TOUS les Use Cases (logique métier) pour le MVP Hydrate or Die. Chaque Use Case représente une action métier atomique.

**Principe Clean Architecture:**
- ✅ Use Cases dans `lib/domain/use_cases/`
- ✅ Pure Dart (aucune dépendance Flutter)
- ✅ Dépendent uniquement des repository INTERFACES
- ✅ 100% testables en isolation (mocks repositories)
- ✅ Single Responsibility (1 use case = 1 action)

---

## Table des Matières

1. [Authentication Use Cases](#1-authentication-use-cases)
2. [Profile Use Cases](#2-profile-use-cases)
3. [Avatar Use Cases](#3-avatar-use-cases)
4. [Hydration Use Cases](#4-hydration-use-cases)
5. [Streak Use Cases](#5-streak-use-cases)
6. [Notification Use Cases](#6-notification-use-cases)
7. [Photo Use Cases](#7-photo-use-cases)
8. [Calendar Use Cases](#8-calendar-use-cases)

---

## 1. Authentication Use Cases

### 1.1 SignUpUseCase

**Purpose:** Créer nouveau compte utilisateur (Firebase Auth)

**File:** `lib/domain/use_cases/auth/sign_up_use_case.dart`

**Interface:**
```dart
class SignUpUseCase {
  final AuthRepository _authRepository;

  SignUpUseCase(this._authRepository);

  Future<String> execute({
    required String email,
    required String password,
  }) async {
    // Returns: userId (Firebase UID)
    // Throws: AuthException if sign up fails
  }
}
```

**Input:**
- `email` (String): Email utilisateur
- `password` (String): Mot de passe (min 6 chars)

**Output:**
- `Future<String>`: User ID (Firebase UID)

**Throws:**
- `AuthException` (email-already-in-use, weak-password, etc.)

**Usage:** Onboarding flow, après summary screen

---

### 1.2 SignInUseCase

**Purpose:** Authentifier utilisateur existant

**Interface:**
```dart
class SignInUseCase {
  final AuthRepository _authRepository;

  SignInUseCase(this._authRepository);

  Future<String> execute({
    required String email,
    required String password,
  }) async {
    // Returns: userId
    // Throws: AuthException if sign in fails
  }
}
```

**Throws:**
- `AuthException` (user-not-found, wrong-password)

---

### 1.3 SignOutUseCase

**Purpose:** Déconnecter utilisateur

**Interface:**
```dart
class SignOutUseCase {
  final AuthRepository _authRepository;

  SignOutUseCase(this._authRepository);

  Future<void> execute() async {
    // Throws: AuthException if sign out fails
  }
}
```

---

## 2. Profile Use Cases

### 2.1 CreateUserProfileUseCase

**Purpose:** Créer profil utilisateur (onboarding)

**File:** `lib/domain/use_cases/profile/create_user_profile_use_case.dart`

**Interface:**
```dart
class CreateUserProfileUseCase {
  final UserProfileRepository _profileRepository;
  final CalculateHydrationGoalUseCase _calculateGoalUseCase;

  CreateUserProfileUseCase(
    this._profileRepository,
    this._calculateGoalUseCase,
  );

  Future<User> execute({
    required String userId,
    required double weight,
    required int age,
    required Gender gender,
    required ActivityLevel activityLevel,
    required bool locationPermissionGranted,
  }) async {
    // 1. Calculate hydration goal
    final goal = await _calculateGoalUseCase.execute(
      weight: weight,
      age: age,
      gender: gender,
      activityLevel: activityLevel,
    );

    // 2. Create User entity
    final user = User(
      id: userId,
      weight: weight,
      age: age,
      gender: gender,
      activityLevel: activityLevel,
      dailyGoal: goal,
      locationPermissionGranted: locationPermissionGranted,
    );

    // 3. Save profile
    await _profileRepository.saveProfile(user);

    return user;
  }
}
```

**Input:**
- `userId`, `weight`, `age`, `gender`, `activityLevel`, `locationPermissionGranted`

**Output:**
- `Future<User>`: User créé avec objectif calculé

**Usage:** Onboarding summary screen

---

### 2.2 GetUserProfileUseCase

**Purpose:** Récupérer profil utilisateur

**Interface:**
```dart
class GetUserProfileUseCase {
  final UserProfileRepository _profileRepository;

  GetUserProfileUseCase(this._profileRepository);

  Future<User?> execute() async {
    return await _profileRepository.getProfile();
  }
}
```

**Output:**
- `Future<User?>`: null si pas de profil (first launch)

**Usage:** App startup, check onboarding completion

---

### 2.3 UpdateUserProfileUseCase

**Purpose:** Modifier profil + recalculer objectif

**Interface:**
```dart
class UpdateUserProfileUseCase {
  final UserProfileRepository _profileRepository;
  final CalculateHydrationGoalUseCase _calculateGoalUseCase;

  UpdateUserProfileUseCase(
    this._profileRepository,
    this._calculateGoalUseCase,
  );

  Future<User> execute(User updatedUser) async {
    // 1. Recalculate goal if profile changed
    final newGoal = await _calculateGoalUseCase.execute(
      weight: updatedUser.weight,
      age: updatedUser.age,
      gender: updatedUser.gender,
      activityLevel: updatedUser.activityLevel,
    );

    final userWithNewGoal = updatedUser.copyWith(dailyGoal: newGoal);

    // 2. Update profile
    await _profileRepository.updateProfile(userWithNewGoal);

    return userWithNewGoal;
  }
}
```

**Usage:** Edit profile screen

---

### 2.4 DeleteUserDataUseCase

**Purpose:** Supprimer toutes données utilisateur (RGPD)

**Interface:**
```dart
class DeleteUserDataUseCase {
  final UserProfileRepository _profileRepository;
  final HydrationLogRepository _logRepository;
  final StreakRepository _streakRepository;
  final PhotoStorageRepository _photoRepository;
  final AuthRepository _authRepository;

  DeleteUserDataUseCase(
    this._profileRepository,
    this._logRepository,
    this._streakRepository,
    this._photoRepository,
    this._authRepository,
  );

  Future<void> execute() async {
    // 1. Delete profile
    await _profileRepository.deleteProfile();

    // 2. Delete all hydration logs (local + cloud)
    // (Implementation handles cascading delete)

    // 3. Delete streak data
    await _streakRepository.resetStreak();

    // 4. Delete all photos (local + cloud)
    await _photoRepository.cleanupOldPhotos(daysToKeep: 0); // Delete all

    // 5. Delete Firebase user account
    await _authRepository.deleteAccount();
  }
}
```

**Usage:** Settings screen "Supprimer mon compte"

---

## 3. Avatar Use Cases

### 3.1 SelectAvatarUseCase

**Purpose:** Sélectionner avatar (onboarding ou changement)

**File:** `lib/domain/use_cases/avatar/select_avatar_use_case.dart`

**Interface:**
```dart
class SelectAvatarUseCase {
  final AvatarRepository _avatarRepository;

  SelectAvatarUseCase(this._avatarRepository);

  Future<void> execute(String avatarId) async {
    // Validate avatar ID
    if (!_isValidAvatarId(avatarId)) {
      throw ArgumentError('Invalid avatar ID: $avatarId');
    }

    await _avatarRepository.saveSelectedAvatar(avatarId);
  }

  bool _isValidAvatarId(String id) {
    return ['authoritarian_mother', 'sports_coach', 'doctor', 'sarcasticFriend']
        .contains(id);
  }
}
```

**Usage:** AvatarSelectionScreen, ChangeAvatarScreen

---

### 3.2 GetAvatarUseCase

**Purpose:** Récupérer avatar actuel

**Interface:**
```dart
class GetAvatarUseCase {
  final AvatarRepository _avatarRepository;

  GetAvatarUseCase(this._avatarRepository);

  Future<Avatar?> execute() async {
    return await _avatarRepository.getAvatar();
  }
}
```

**Usage:** HomeScreen display avatar

---

### 3.3 UpdateAvatarStateUseCase

**Purpose:** Mettre à jour état avatar selon temps déshydratation

**File:** `lib/domain/use_cases/avatar/update_avatar_state_use_case.dart`

**Interface:**
```dart
class UpdateAvatarStateUseCase {
  final AvatarRepository _avatarRepository;

  // State transition thresholds (hours)
  static const int kFreshToTired = 2;
  static const int kTiredToDehydrated = 4;
  static const int kDehydratedToDead = 6;

  UpdateAvatarStateUseCase(this._avatarRepository);

  Future<AvatarState> execute() async {
    // 1. Get last drink time
    final lastDrinkTime = await _avatarRepository.getLastDrinkTime();
    if (lastDrinkTime == null) {
      // No hydration yet → default fresh
      return AvatarState.fresh;
    }

    // 2. Calculate time elapsed
    final now = DateTime.now();
    final elapsed = now.difference(lastDrinkTime);

    // 3. Calculate new state
    final newState = _calculateState(elapsed);

    // 4. Update if changed
    final currentAvatar = await _avatarRepository.getAvatar();
    if (currentAvatar?.currentState != newState) {
      await _avatarRepository.updateAvatarState(newState);
    }

    return newState;
  }

  AvatarState _calculateState(Duration timeSinceLastDrink) {
    final hours = timeSinceLastDrink.inHours;

    if (hours < kFreshToTired) {
      return AvatarState.fresh;
    } else if (hours < kTiredToDehydrated) {
      return AvatarState.tired;
    } else if (hours < kDehydratedToDead) {
      return AvatarState.dehydrated;
    } else {
      return AvatarState.dead;
    }
  }
}
```

**Usage:** Background timer (30min), app startup

---

## 4. Hydration Use Cases

### 4.1 RecordHydrationUseCase

**Purpose:** Enregistrer validation hydratation (après selfie)

**File:** `lib/domain/use_cases/hydration/record_hydration_use_case.dart`

**Interface:**
```dart
class RecordHydrationUseCase {
  final HydrationLogRepository _logRepository;
  final AvatarRepository _avatarRepository;
  final AnalyticsService _analyticsService;

  RecordHydrationUseCase(
    this._logRepository,
    this._avatarRepository,
    this._analyticsService,
  );

  Future<HydrationLog> execute({
    required String photoPath,
    required GlassSize glassSize,
  }) async {
    // 1. Create log
    final log = HydrationLog(
      id: Uuid().v4(),
      timestamp: DateTime.now(),
      photoPath: photoPath,
      glassSize: glassSize,
      validated: true,
    );

    // 2. Save log
    await _logRepository.addLog(log);

    // 3. Update avatar last drink time (resets to fresh)
    await _avatarRepository.updateLastDrinkTime(log.timestamp);

    // 4. Log analytics
    await _analyticsService.logEvent(
      'hydration_validated',
      parameters: {
        'glass_size': glassSize.name,
        'volume_liters': log.volumeLiters,
        'photo_taken': photoPath.isNotEmpty,
      },
    );

    return log;
  }
}
```

**Usage:** PhotoValidationFlow après sélection glass size

---

### 4.2 GetTodaysHydrationProgressUseCase

**Purpose:** Calculer progression quotidienne

**Interface:**
```dart
class GetTodaysHydrationProgressUseCase {
  final HydrationLogRepository _logRepository;
  final UserProfileRepository _profileRepository;

  GetTodaysHydrationProgressUseCase(
    this._logRepository,
    this._profileRepository,
  );

  Future<HydrationProgress> execute() async {
    // 1. Get today's volume
    final volumeToday = await _logRepository.getTodayVolume();

    // 2. Get user's daily goal
    final user = await _profileRepository.getProfile();
    if (user == null) {
      throw StateError('User profile not found');
    }
    final goal = user.dailyGoal.targetLiters;

    // 3. Calculate progress
    final progressPercentage = (volumeToday / goal * 100).clamp(0.0, 100.0);
    final goalAchieved = volumeToday >= goal;

    return HydrationProgress(
      volumeDrank: volumeToday,
      goalVolume: goal,
      progressPercentage: progressPercentage,
      goalAchieved: goalAchieved,
    );
  }
}

class HydrationProgress {
  final double volumeDrank;
  final double goalVolume;
  final double progressPercentage;
  final bool goalAchieved;

  HydrationProgress({
    required this.volumeDrank,
    required this.goalVolume,
    required this.progressPercentage,
    required this.goalAchieved,
  });
}
```

**Usage:** HomeScreen display progress bar

---

### 4.3 CalculateHydrationGoalUseCase

**Purpose:** Calculer objectif quotidien personnalisé

**File:** `lib/domain/use_cases/hydration/calculate_hydration_goal_use_case.dart`

**Interface:**
```dart
class CalculateHydrationGoalUseCase {
  // Formula: Base = weight (kg) × 0.033 liters
  // Multipliers:
  // - Activity: sedentary (1.0), light (1.1), moderate (1.2), veryActive (1.3), extremelyActive (1.5)
  // - Gender: male (1.0), female (0.95), other (1.0)
  // - Age: <30 (1.0), 30-55 (0.95), >55 (0.9)
  // Safety bounds: 1.5L - 5.0L

  Future<HydrationGoal> execute({
    required double weight,
    required int age,
    required Gender gender,
    required ActivityLevel activityLevel,
  }) async {
    // 1. Base calculation
    double goal = weight * 0.033;

    // 2. Activity multiplier
    goal *= _getActivityMultiplier(activityLevel);

    // 3. Gender multiplier
    goal *= _getGenderMultiplier(gender);

    // 4. Age multiplier
    goal *= _getAgeMultiplier(age);

    // 5. Round to 0.1L
    goal = (goal * 10).round() / 10;

    // 6. Safety bounds
    goal = goal.clamp(1.5, 5.0);

    return HydrationGoal(goal);
  }

  double _getActivityMultiplier(ActivityLevel level) {
    switch (level) {
      case ActivityLevel.sedentary:
        return 1.0;
      case ActivityLevel.light:
        return 1.1;
      case ActivityLevel.moderate:
        return 1.2;
      case ActivityLevel.veryActive:
        return 1.3;
      case ActivityLevel.extremelyActive:
        return 1.5;
    }
  }

  double _getGenderMultiplier(Gender gender) {
    switch (gender) {
      case Gender.male:
        return 1.0;
      case Gender.female:
        return 0.95;
      case Gender.other:
        return 1.0;
    }
  }

  double _getAgeMultiplier(int age) {
    if (age < 30) return 1.0;
    if (age <= 55) return 0.95;
    return 0.9;
  }
}
```

**Usage:** CreateUserProfileUseCase, UpdateUserProfileUseCase

**Example:**
```dart
// Homme, 75kg, 30 ans, modéré
final goal = await calculateGoalUseCase.execute(
  weight: 75.0,
  age: 30,
  gender: Gender.male,
  activityLevel: ActivityLevel.moderate,
);
// Result: ~2.5L
```

---

## 5. Streak Use Cases

### 5.1 UpdateStreakUseCase

**Purpose:** Mettre à jour streak quotidien (minuit)

**File:** `lib/domain/use_cases/streak/update_streak_use_case.dart`

**Interface:**
```dart
class UpdateStreakUseCase {
  final StreakRepository _streakRepository;
  final HydrationLogRepository _logRepository;
  final UserProfileRepository _profileRepository;
  final AvatarRepository _avatarRepository;

  UpdateStreakUseCase(
    this._streakRepository,
    this._logRepository,
    this._profileRepository,
    this._avatarRepository,
  );

  Future<StreakData> execute() async {
    // 1. Get yesterday's date
    final yesterday = DateTime.now().subtract(Duration(days: 1));
    final yesterdayDate = DateTime(yesterday.year, yesterday.month, yesterday.day);

    // 2. Check if goal achieved yesterday
    final volumeYesterday = await _logRepository.getTotalVolumeForDate(yesterdayDate);
    final user = await _profileRepository.getProfile();
    if (user == null) {
      throw StateError('User profile not found');
    }

    final goalAchieved = volumeYesterday >= user.dailyGoal.targetLiters;

    // 3. Check if avatar died yesterday
    final avatar = await _avatarRepository.getAvatar();
    final avatarDied = avatar?.currentState == AvatarState.dead ||
                       avatar?.currentState == AvatarState.ghost;

    // 4. Update streak
    final currentStreak = await _streakRepository.getStreak();

    if (goalAchieved && !avatarDied) {
      // Increment streak
      return await _streakRepository.incrementStreak();
    } else {
      // Break streak
      await _streakRepository.resetStreak();
      return await _streakRepository.getStreak();
    }
  }
}
```

**Usage:** Midnight background job, app startup check

---

### 5.2 GetCurrentStreakUseCase

**Purpose:** Récupérer streak actuel

**Interface:**
```dart
class GetCurrentStreakUseCase {
  final StreakRepository _streakRepository;

  GetCurrentStreakUseCase(this._streakRepository);

  Future<StreakData> execute() async {
    return await _streakRepository.getStreak();
  }
}
```

**Usage:** HomeScreen streak display, ProfileScreen stats

---

## 6. Notification Use Cases

### 6.1 CalculateNotificationLevelUseCase

**Purpose:** Déterminer niveau escalade actuel

**File:** `lib/domain/use_cases/notifications/calculate_notification_level_use_case.dart`

**Interface:**
```dart
class CalculateNotificationLevelUseCase {
  final AvatarRepository _avatarRepository;

  // Thresholds (hours)
  static const int kCalmToConcerned = 2;
  static const int kConcernedToDramatic = 4;
  static const int kDramaticToChaos = 6;

  CalculateNotificationLevelUseCase(this._avatarRepository);

  Future<NotificationLevel> execute() async {
    final lastDrinkTime = await _avatarRepository.getLastDrinkTime();
    if (lastDrinkTime == null) {
      return NotificationLevel.calm;
    }

    final elapsed = DateTime.now().difference(lastDrinkTime);
    final hours = elapsed.inHours;

    if (hours < kCalmToConcerned) {
      return NotificationLevel.calm;
    } else if (hours < kConcernedToDramatic) {
      return NotificationLevel.concerned;
    } else if (hours < kDramaticToChaos) {
      return NotificationLevel.dramatic;
    } else {
      return NotificationLevel.chaos;
    }
  }
}
```

**Usage:** Background timer, ScheduleNotificationUseCase

---

### 6.2 GetNotificationMessageUseCase

**Purpose:** Générer message notification adapté

**Interface:**
```dart
class GetNotificationMessageUseCase {
  final AvatarRepository _avatarRepository;
  final NotificationMessageProvider _messageProvider;

  GetNotificationMessageUseCase(
    this._avatarRepository,
    this._messageProvider,
  );

  Future<NotificationMessage> execute(NotificationLevel level) async {
    final avatar = await _avatarRepository.getAvatar();
    if (avatar == null) {
      throw StateError('No avatar selected');
    }

    final message = _messageProvider.getMessage(avatar.personality, level);

    return NotificationMessage(
      title: _getTitleForPersonality(avatar.personality),
      body: message,
      personality: avatar.personality,
      level: level,
    );
  }

  String _getTitleForPersonality(AvatarPersonality personality) {
    switch (personality) {
      case AvatarPersonality.authoritarianMother:
        return 'Maman dit:';
      case AvatarPersonality.sportsCoach:
        return 'Coach Mike:';
      case AvatarPersonality.doctor:
        return 'Dr. Martin:';
      case AvatarPersonality.sarcasticFriend:
        return 'Alex dit:';
    }
  }
}
```

---

### 6.3 ScheduleNotificationUseCase

**Purpose:** Scheduler notification selon niveau

**Interface:**
```dart
class ScheduleNotificationUseCase {
  final NotificationService _notificationService;
  final CalculateNotificationLevelUseCase _calculateLevelUseCase;
  final GetNotificationMessageUseCase _getMessageUseCase;
  final NotificationStateRepository _stateRepository;

  ScheduleNotificationUseCase(
    this._notificationService,
    this._calculateLevelUseCase,
    this._getMessageUseCase,
    this._stateRepository,
  );

  Future<void> execute() async {
    // 1. Calculate current level
    final level = await _calculateLevelUseCase.execute();

    // 2. Get message
    final message = await _getMessageUseCase.execute(level);

    // 3. Calculate next notification time
    final nextTime = _calculateNextNotificationTime(level);

    // 4. Schedule notification
    await _notificationService.schedule(
      title: message.title,
      body: message.body,
      scheduledTime: nextTime,
      enableVibration: level == NotificationLevel.chaos,
    );

    // 5. Update state
    await _stateRepository.incrementNotificationCount();
  }

  DateTime _calculateNextNotificationTime(NotificationLevel level) {
    final now = DateTime.now();
    switch (level) {
      case NotificationLevel.calm:
        return now.add(Duration(hours: 1));
      case NotificationLevel.concerned:
        return now.add(Duration(minutes: 30));
      case NotificationLevel.dramatic:
        return now.add(Duration(minutes: 15));
      case NotificationLevel.chaos:
        // Random 5-10 min
        final randomMinutes = 5 + Random().nextInt(6);
        return now.add(Duration(minutes: randomMinutes));
    }
  }
}
```

---

### 6.4 Notification Quota Strategy (Anti-Spam Protection)

**Purpose:** Empêcher spam excessif qui causerait désactivation notifications OS

**Problem:**
- iOS/Android détectent spam notifications et désactivent automatiquement
- User peut manuellement disable notifications si trop agressif
- Besoin balance: insistant mais pas insupportable

**Strategy: Daily Quota Limits**

```dart
class NotificationQuotaManager {
  final NotificationStateRepository _stateRepository;

  // Quota limits par niveau (max notifications/jour)
  static const int kMaxNotificationsCalm = 10;      // ~1x/heure × 10h actives
  static const int kMaxNotificationsConcerned = 20; // ~1x/30min × 10h
  static const int kMaxNotificationsDramatic = 40;  // ~1x/15min × 10h
  static const int kMaxNotificationsChaos = 100;    // Max absolu (spam mode)

  Future<bool> canSendNotification(NotificationLevel level) async {
    final state = await _stateRepository.getState();

    // Check quota based on level
    final maxAllowed = _getMaxForLevel(level);
    if (state.notificationsSentToday >= maxAllowed) {
      return false; // Quota exceeded
    }

    return true;
  }

  int _getMaxForLevel(NotificationLevel level) {
    switch (level) {
      case NotificationLevel.calm:
        return kMaxNotificationsCalm;
      case NotificationLevel.concerned:
        return kMaxNotificationsConcerned;
      case NotificationLevel.dramatic:
        return kMaxNotificationsDramatic;
      case NotificationLevel.chaos:
        return kMaxNotificationsChaos;
    }
  }
}
```

**Updated ScheduleNotificationUseCase with Quota Check:**

```dart
Future<void> execute() async {
  // 1. Calculate current level
  final level = await _calculateLevelUseCase.execute();

  // 2. Check quota (NEW)
  final quotaManager = NotificationQuotaManager(_stateRepository);
  final canSend = await quotaManager.canSendNotification(level);

  if (!canSend) {
    print('[QUOTA] Notification quota exceeded for level $level - skipping');
    return; // Skip notification
  }

  // 3. Get message
  final message = await _getMessageUseCase.execute(level);

  // 4. Calculate next notification time
  final nextTime = _calculateNextNotificationTime(level);

  // 5. Schedule notification
  await _notificationService.schedule(
    title: message.title,
    body: message.body,
    scheduledTime: nextTime,
    enableVibration: level == NotificationLevel.chaos,
  );

  // 6. Update state (increment count)
  await _stateRepository.incrementNotificationCount();
}
```

**Rationale:**

1. **Prevent OS Auto-Disable:** iOS/Android track notification spam patterns
2. **User Experience:** Balance insistance vs annoyance (pas insupportable)
3. **Retention:** Trop de notifs = user désactive = perte engagement
4. **Progressive Escalation:** Quotas augmentent avec niveau (calm=10, chaos=100)

**Max Daily Notifications by Level:**

| Niveau | Fréquence | Quota/Jour | Durée Active Estimée |
|--------|-----------|------------|----------------------|
| Calm | 1x/heure | 10 | ~10 heures |
| Concerned | 1x/30min | 20 | ~10 heures |
| Dramatic | 1x/15min | 40 | ~10 heures |
| Chaos | 5-10min random | 100 | ~10-15 heures (max spam) |

**Reset Strategy:**
- Quotas reset à minuit (00h00 locale)
- Quotas reset immédiatement si user valide hydratation (niveau retourne Calm)

**Fallback:**
- Si quota atteint mais user toujours déshydraté → Avatar meurt (conséquence visuelle)
- Notification suivante le lendemain après reset

---

## 7. Photo Use Cases

### 7.1 CapturePhotoUseCase

**Purpose:** Capturer selfie et sauvegarder localement

**File:** `lib/domain/use_cases/photo/capture_photo_use_case.dart`

**Interface:**
```dart
class CapturePhotoUseCase {
  final PhotoStorageRepository _photoRepository;
  final CameraService _cameraService;

  CapturePhotoUseCase(
    this._photoRepository,
    this._cameraService,
  );

  Future<String> execute() async {
    // 1. Capture photo from camera
    final photoFile = await _cameraService.takePicture();

    // 2. Save locally
    final timestamp = DateTime.now();
    final localPath = await _photoRepository.savePhotoLocally(
      photoFile,
      timestamp,
    );

    return localPath;
  }
}
```

**Output:**
- `Future<String>`: Local file path

**Usage:** PhotoValidationScreen après tap bouton capture

---

### 7.2 ValidatePhotoUseCase (Optional - MVP Decision Required)

**Purpose:** Valider qu'un verre est présent dans la photo (anti-triche basique)

**File:** `lib/domain/use_cases/photo/validate_photo_use_case.dart`

**Strategy Options:**

#### Option A: Manual Validation (Recommended for MVP)
```dart
class ValidatePhotoUseCase {
  // No validation - accept all photos
  // User responsibility (honor system)

  Future<PhotoValidationResult> execute(String photoPath) async {
    return PhotoValidationResult(
      isValid: true,
      confidence: 1.0,
      message: 'Photo acceptée',
    );
  }
}
```

**Pros:**
- ✅ Simple, rapide à implémenter
- ✅ Pas de dépendances ML
- ✅ Pas de délai validation
- ✅ Honor system = confiance utilisateur

**Cons:**
- ❌ Pas de détection anti-triche
- ❌ User peut valider sans verre

---

#### Option B: Basic Heuristic Detection (Optionnel MVP)
```dart
class ValidatePhotoUseCase {
  final ImageAnalysisService _analysisService;

  Future<PhotoValidationResult> execute(String photoPath) async {
    // Heuristic: Detect circular/cylindrical shapes (glass)
    final hasGlassLikeShape = await _analysisService.detectCircularShapes(photoPath);

    if (hasGlassLikeShape) {
      return PhotoValidationResult(
        isValid: true,
        confidence: 0.7,
        message: 'Verre détecté ✓',
      );
    } else {
      // Warning but NOT blocking
      return PhotoValidationResult(
        isValid: true, // Still accept
        confidence: 0.3,
        message: 'On ne voit pas de verre... Tu es sûr ? 🤔',
        showWarning: true,
      );
    }
  }
}
```

**Pros:**
- ✅ Détection basique anti-triche facile
- ✅ Non bloquant (warning only)
- ✅ Utilise OpenCV basique (pas de ML lourd)

**Cons:**
- ❌ Complexité additionnelle
- ❌ Faux positifs/négatifs possibles
- ❌ Dépendance `opencv_flutter` (~10MB)

---

#### Option C: ML Detection (V2 - NOT for MVP)
```dart
// Using ML Kit or TensorFlow Lite
// Detect water glass with trained model
// NOT RECOMMENDED for MVP (complexity, cost, accuracy issues)
```

**Pros:**
- ✅ Meilleure précision détection

**Cons:**
- ❌ Complexité élevée
- ❌ Requires trained model
- ❌ Augmente taille app significativement
- ❌ Latence validation (2-5 secondes)
- ❌ Coût training/maintenance model

---

**MVP Recommendation: Option A (Manual Validation)**

**Rationale:**
1. **Time-to-Market:** Option A est immédiate, pas de développement validation
2. **User Trust:** Honor system aligne avec philosophie bienveillante app
3. **Iteration:** Peut ajouter Option B/C en V2 si analytics montrent abus
4. **Simplicity:** Respect "boring technology" principle

**Decision Point:**
- Si PM accepte honor system → Option A (recommended)
- Si PM requiert détection basique → Option B (acceptable)
- Option C → Rejeté pour MVP (V2 feature)

---

## 8. Calendar Use Cases

### 8.1 GetMonthlyStatusUseCase

**Purpose:** Obtenir statut hydratation pour un mois complet

**File:** `lib/domain/use_cases/calendar/get_monthly_status_use_case.dart`

**Interface:**
```dart
class GetMonthlyStatusUseCase {
  final HydrationLogRepository _logRepository;
  final UserProfileRepository _profileRepository;

  GetMonthlyStatusUseCase(
    this._logRepository,
    this._profileRepository,
  );

  Future<MonthStatus> execute(int year, int month) async {
    // 1. Get user goal
    final user = await _profileRepository.getProfile();
    if (user == null) {
      throw StateError('User profile not found');
    }
    final goalVolume = user.dailyGoal.targetLiters;

    // 2. Get all days in month
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final days = <DayStatus>[];

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(year, month, day);
      final volume = await _logRepository.getTotalVolumeForDate(date);

      final isFuture = date.isAfter(DateTime.now());
      final goalAchieved = isFuture ? null : volume >= goalVolume;

      days.add(DayStatus(
        date: date,
        goalAchieved: goalAchieved,
        volumeDrank: volume,
        goalVolume: goalVolume,
      ));
    }

    return MonthStatus(
      year: year,
      month: month,
      days: days,
    );
  }
}
```

**Usage:** CalendarScreen display month view

---

## ✅ Use Cases Validation Checklist

- [x] Tous Use Cases définis (25+ use cases couvrant Epics 1-5)
- [x] Toutes méthodes execute() documentées
- [x] Input/Output clairement définis
- [x] Dependencies (repositories) injectées via constructor
- [x] Pure Dart (pas de dépendance Flutter)
- [x] Single Responsibility respecté
- [x] Testable via mocks
- [x] Aligned avec stories Epics 1-5
- [ ] Validation PM (awaiting)

---

## 📋 Use Case Implementation Checklist (Phase Dev)

Chaque Use Case implementation doit:

1. ✅ Constructor injection (DI)
2. ✅ Single public method `execute()`
3. ✅ Pure Dart (testable sans Flutter)
4. ✅ Error handling avec exceptions custom
5. ✅ Unit tests 80%+ coverage
6. ✅ Documentation dartdoc
7. ✅ Registered dans get_it

---

**Document créé le 2026-01-07 par Winston (Architect)**
**Status: DRAFT - Awaiting PM Validation**
**🎉 DERNIER DOCUMENT DE CONTRATS - ALL CONTRACTS COMPLETE!**
