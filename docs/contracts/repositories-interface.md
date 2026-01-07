# Repository Interfaces - Hydrate or Die MVP

**Version:** 1.0
**Date:** 2026-01-07
**Owner:** Winston (Architect)
**Status:** DRAFT - Awaiting PM Validation
**Reference:** data-models.md, database-schema.md, Clean Architecture

---

## 📋 Overview

Ce document définit TOUTES les interfaces de repositories (contrats) pour la couche Domain. Les implémentations concrètes seront dans la couche Data.

**Principe Clean Architecture:**
- ✅ Interfaces définies dans `lib/domain/repositories/`
- ✅ Implémentations dans `lib/data/repositories/`
- ✅ Use Cases dépendent des INTERFACES uniquement (DI)
- ✅ Testable via mocks (mockito/mocktail)

---

## 1. AuthRepository

**Purpose:** Gestion authentification utilisateur (Firebase Auth)

**File:** `lib/domain/repositories/auth_repository.dart`

### Interface

```dart
abstract class AuthRepository {
  /// Sign up new user with email/password
  /// Returns userId (Firebase UID)
  /// Throws [AuthException] if sign up fails
  Future<String> signUp({
    required String email,
    required String password,
  });

  /// Sign in existing user with email/password
  /// Returns userId (Firebase UID)
  /// Throws [AuthException] if sign in fails
  Future<String> signIn({
    required String email,
    required String password,
  });

  /// Sign in with Apple (iOS)
  /// Returns userId
  /// Throws [AuthException] if sign in fails
  Future<String> signInWithApple();

  /// Sign in with Google (Android)
  /// Returns userId
  /// Throws [AuthException] if sign in fails
  Future<String> signInWithGoogle();

  /// Sign out current user
  /// Throws [AuthException] if sign out fails
  Future<void> signOut();

  /// Get current user ID (Firebase UID)
  /// Returns null if not authenticated
  Future<String?> getCurrentUserId();

  /// Check if user is authenticated
  /// Returns true if user signed in
  Future<bool> isAuthenticated();

  /// Delete user account (RGPD - delete account)
  /// Also deletes Firebase Auth user
  /// Throws [AuthException] if delete fails
  Future<void> deleteAccount();
}
```

### Methods Details

#### `signUp({required String email, required String password})`

**Parameters:**
- `email` (String): Email utilisateur (validation format)
- `password` (String): Mot de passe (min 6 caractères)

**Returns:** `Future<String>` - User ID (Firebase UID)

**Throws:** `AuthException` (email-already-in-use, weak-password, invalid-email)

**Usage:** Onboarding summary screen, CreateUserProfileUseCase

---

#### `signIn({required String email, required String password})`

**Returns:** `Future<String>` - User ID

**Throws:** `AuthException` (user-not-found, wrong-password)

**Usage:** Login screen (V2)

---

#### `signInWithApple()`

**Returns:** `Future<String>` - User ID from Apple Sign-In

**Throws:** `AuthException` (sign-in-failed, cancelled)

**Usage:** Onboarding iOS, one-tap sign-in

---

#### `signInWithGoogle()`

**Returns:** `Future<String>` - User ID from Google Sign-In

**Usage:** Onboarding Android, one-tap sign-in

---

#### `getCurrentUserId()`

**Returns:** `Future<String?>` - null si non authentifié

**Usage:** App startup, check authentication state

---

#### `deleteAccount()`

**Usage:** DeleteUserDataUseCase (RGPD), supprime aussi Firebase Auth user

---

## 2. AvatarRepository

**Purpose:** Gestion avatar sélectionné et état déshydratation

**File:** `lib/domain/repositories/avatar_repository.dart`

### Interface

```dart
import 'package:hydrate_or_die/domain/entities/avatar.dart';

abstract class AvatarRepository {
  /// Get currently selected avatar with current state
  /// Returns null if no avatar selected (first launch)
  Future<Avatar?> getAvatar();

  /// Save selected avatar (onboarding or change avatar)
  /// Throws [StorageException] if save fails
  Future<void> saveSelectedAvatar(String avatarId);

  /// Update avatar state (fresh/tired/dehydrated/dead/ghost)
  /// Throws [StorageException] if update fails
  Future<void> updateAvatarState(AvatarState state);

  /// Update last drink time (when user validates hydration)
  /// Also resets avatar state to fresh
  /// Throws [StorageException] if update fails
  Future<void> updateLastDrinkTime(DateTime timestamp);

  /// Get last drink timestamp
  /// Returns null if no hydration recorded yet
  Future<DateTime?> getLastDrinkTime();
}
```

### Methods Details

#### `getAvatar()`

**Returns:** `Future<Avatar?>` - null si aucun avatar sélectionné

**Usage:** Charger avatar au lancement app, afficher HomeScreen

**Example:**
```dart
final avatar = await _avatarRepository.getAvatar();
if (avatar == null) {
  // Navigate to AvatarSelectionScreen
} else {
  // Display avatar on HomeScreen
}
```

---

#### `saveSelectedAvatar(String avatarId)`

**Parameters:**
- `avatarId`: ID avatar ('authoritarian_mother', 'sports_coach', 'doctor', 'sarcasticFriend')

**Throws:** `StorageException` si échec sauvegarde

**Usage:** Onboarding avatar selection, change avatar

---

#### `updateAvatarState(AvatarState state)`

**Parameters:**
- `state`: Nouvel état (fresh/tired/dehydrated/dead/ghost)

**Usage:** UpdateAvatarStateUseCase (timer background)

---

#### `updateLastDrinkTime(DateTime timestamp)`

**Parameters:**
- `timestamp`: DateTime de validation hydratation

**Side Effect:** Reset avatar state à `fresh`

**Usage:** RecordHydrationUseCase après validation photo

---

## 3. UserProfileRepository

**Purpose:** Gestion profil utilisateur (onboarding data)

**File:** `lib/domain/repositories/user_profile_repository.dart`

### Interface

```dart
import 'package:hydrate_or_die/domain/entities/user.dart';

abstract class UserProfileRepository {
  /// Get user profile
  /// Returns null if no profile exists (first launch)
  Future<User?> getProfile();

  /// Save user profile (onboarding)
  /// Throws [StorageException] if save fails
  Future<void> saveProfile(User user);

  /// Update user profile (edit profile screen)
  /// Throws [StorageException] if update fails
  Future<void> updateProfile(User user);

  /// Delete user profile (RGPD - delete account)
  /// Throws [StorageException] if delete fails
  Future<void> deleteProfile();

  /// Check if profile exists (fast check for onboarding skip)
  Future<bool> profileExists();
}
```

### Methods Details

#### `getProfile()`

**Returns:** `Future<User?>` - null si profil n'existe pas

**Usage:** Check onboarding completion, load profile for calculations

---

#### `saveProfile(User user)`

**Parameters:**
- `user`: User entity avec toutes infos (weight, age, gender, activityLevel, dailyGoal)

**Usage:** Onboarding summary screen, CreateUserProfileUseCase

---

#### `updateProfile(User user)`

**Parameters:**
- `user`: User entity modifié

**Usage:** Edit profile screen, recalcul objectif hydratation

---

#### `deleteProfile()`

**Usage:** Delete account (RGPD), supprime aussi données locales

---

## 4. HydrationLogRepository

**Purpose:** Gestion historique validations hydratation

**File:** `lib/domain/repositories/hydration_log_repository.dart`

### Interface

```dart
import 'package:hydrate_or_die/domain/entities/hydration_log.dart';

abstract class HydrationLogRepository {
  /// Add new hydration log
  /// Throws [StorageException] if save fails
  Future<void> addLog(HydrationLog log);

  /// Get all logs for a specific date (00:00 - 23:59 local)
  /// Returns empty list if no logs for date
  Future<List<HydrationLog>> getLogsForDate(DateTime date);

  /// Get all logs for today (shortcut for getLogsForDate(DateTime.now()))
  Future<List<HydrationLog>> getTodayLogs();

  /// Get total volume drank for a specific date (sum of all logs)
  /// Returns 0.0 if no logs
  Future<double> getTotalVolumeForDate(DateTime date);

  /// Get total volume drank today (shortcut)
  Future<double> getTodayVolume();

  /// Delete old logs (cleanup job - >90 days)
  /// Returns number of logs deleted
  Future<int> deleteOldLogs({int daysToKeep = 90});

  /// Get logs pending cloud sync (synced_to_cloud = false)
  /// Used by sync service to retry failed syncs
  Future<List<HydrationLog>> getPendingSyncLogs();

  /// Mark log as synced to cloud
  /// Throws [StorageException] if update fails
  Future<void> markLogAsSynced(String logId);
}
```

### Methods Details

#### `addLog(HydrationLog log)`

**Parameters:**
- `log`: HydrationLog avec timestamp, photoPath, glassSize, volumeLiters

**Usage:** RecordHydrationUseCase après validation photo

---

#### `getLogsForDate(DateTime date)`

**Parameters:**
- `date`: Date quelconque (jour complet 00:00-23:59)

**Returns:** `Future<List<HydrationLog>>` - liste logs (vide si aucun)

**Usage:** Calendrier historique, calcul streak

---

#### `getTodayLogs()`

**Usage:** HomeScreen affichage progression quotidienne

---

#### `getTotalVolumeForDate(DateTime date)`

**Returns:** `Future<double>` - Volume total en litres (0.0 si aucun log)

**Usage:** Calcul streak (objectif atteint ou non)

---

## 5. StreakRepository

**Purpose:** Gestion streaks (jours consécutifs)

**File:** `lib/domain/repositories/streak_repository.dart`

### Interface

```dart
import 'package:hydrate_or_die/domain/entities/streak.dart';

abstract class StreakRepository {
  /// Get current streak data
  /// Returns default StreakData (0 days) if none exists
  Future<StreakData> getStreak();

  /// Save/update streak data
  /// Throws [StorageException] if save fails
  Future<void> saveStreak(StreakData streak);

  /// Reset streak to 0 (called when streak broken)
  Future<void> resetStreak();

  /// Increment streak by 1 day
  /// Updates longestStreak if needed
  /// Returns updated StreakData
  Future<StreakData> incrementStreak();
}
```

### Methods Details

#### `getStreak()`

**Returns:** `Future<StreakData>` - streak actuel (0 si nouveau user)

**Usage:** HomeScreen affichage streak, UpdateStreakUseCase

---

#### `incrementStreak()`

**Returns:** `Future<StreakData>` - streak mis à jour

**Side Effect:** Incrémente currentStreak, met à jour longestStreak si record battu

**Usage:** UpdateStreakUseCase à minuit si objectif atteint

---

## 6. NotificationStateRepository

**Purpose:** Gestion état système notifications (escalade)

**File:** `lib/domain/repositories/notification_state_repository.dart`

### Interface

```dart
import 'package:hydrate_or_die/domain/entities/notification_state.dart';

abstract class NotificationStateRepository {
  /// Get current notification state
  /// Returns default state (calm, 0 notifications) if none exists
  Future<NotificationState> getState();

  /// Save/update notification state
  /// Throws [StorageException] if save fails
  Future<void> saveState(NotificationState state);

  /// Reset state to calm (called after hydration or at midnight)
  Future<void> resetState();

  /// Increment notification count for today
  /// Returns updated count
  Future<int> incrementNotificationCount();

  /// Check if we're in a new day (reset if yes)
  /// Returns true if reset happened
  Future<bool> checkAndResetForNewDay();
}
```

### Methods Details

#### `getState()`

**Returns:** `Future<NotificationState>` - état actuel (calm par défaut)

**Usage:** CalculateNotificationLevelUseCase, ScheduleNotificationUseCase

---

#### `incrementNotificationCount()`

**Returns:** `Future<int>` - nouveau compteur

**Usage:** Après envoi notification, tracking quota

---

#### `checkAndResetForNewDay()`

**Returns:** `Future<bool>` - true si reset effectué

**Usage:** App startup, background timer (detect midnight)

---

## 7. PhotoStorageRepository

**Purpose:** Gestion stockage photos selfies (local + cloud opt-in)

**File:** `lib/domain/repositories/photo_storage_repository.dart`

### Interface

```dart
import 'dart:io';

abstract class PhotoStorageRepository {
  /// Save photo locally
  /// Returns local file path
  /// Throws [StorageException] if save fails
  Future<String> savePhotoLocally(File photo, DateTime timestamp);

  /// Get local photo file
  /// Returns null if not found
  Future<File?> getLocalPhoto(String photoPath);

  /// Delete local photo
  /// Throws [StorageException] if delete fails
  Future<void> deleteLocalPhoto(String photoPath);

  /// Upload photo to cloud (Firebase Storage) - opt-in feature
  /// Returns cloud storage URL
  /// Throws [StorageException] if upload fails
  Future<String> uploadPhotoToCloud(String localPath, String userId);

  /// Delete photo from cloud
  /// Throws [StorageException] if delete fails
  Future<void> deleteCloudPhoto(String photoUrl);

  /// Cleanup old photos (>90 days)
  /// Returns number of photos deleted
  Future<int> cleanupOldPhotos({int daysToKeep = 90});
}
```

### Methods Details

#### `savePhotoLocally(File photo, DateTime timestamp)`

**Parameters:**
- `photo`: File object (image from camera)
- `timestamp`: DateTime pour naming (hydration_YYYYMMDD_HHmmss.jpg)

**Returns:** `Future<String>` - chemin fichier local

**Usage:** CapturePhotoUseCase après capture caméra

**Naming Convention:** `hydration_20260107_143000.jpg`

---

#### `cleanupOldPhotos({int daysToKeep = 90})`

**Returns:** `Future<int>` - nombre photos supprimées

**Usage:** Background job nocturne, DeleteUserDataUseCase

---

## 8. Repository Pattern Best Practices

### Error Handling

**All repositories should throw:**
```dart
class StorageException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  StorageException(this.message, {this.code, this.originalError});

  @override
  String toString() => 'StorageException: $message (code: $code)';
}
```

**Example Implementation:**
```dart
@override
Future<void> saveProfile(User user) async {
  try {
    final db = await _databaseHelper.database;
    final model = user.toModel();
    await db.insert('user_profile', model.toJson());
  } catch (e) {
    throw StorageException(
      'Failed to save user profile',
      code: 'SAVE_PROFILE_FAILED',
      originalError: e,
    );
  }
}
```

---

### Dependency Injection

**All repositories injected via get_it:**

```dart
// core/di/injection.dart
void setupRepositories() {
  // Data Sources
  getIt.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
  getIt.registerLazySingleton<AvatarLocalDataSource>(
    () => AvatarLocalDataSourceImpl(getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<AvatarRepository>(
    () => AvatarRepositoryImpl(getIt(), getIt()), // local + remote data sources
  );

  getIt.registerLazySingleton<UserProfileRepository>(
    () => UserProfileRepositoryImpl(getIt(), getIt()),
  );

  getIt.registerLazySingleton<HydrationLogRepository>(
    () => HydrationLogRepositoryImpl(getIt(), getIt()),
  );

  getIt.registerLazySingleton<StreakRepository>(
    () => StreakRepositoryImpl(getIt()),
  );

  getIt.registerLazySingleton<NotificationStateRepository>(
    () => NotificationStateRepositoryImpl(getIt()),
  );

  getIt.registerLazySingleton<PhotoStorageRepository>(
    () => PhotoStorageRepositoryImpl(getIt(), getIt()),
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt()),
  );
}
```

---

### Testing with Mocks

**Example Mock (mocktail):**

```dart
import 'package:mocktail/mocktail.dart';

class MockAvatarRepository extends Mock implements AvatarRepository {}

void main() {
  late MockAvatarRepository mockRepository;
  late UpdateAvatarStateUseCase useCase;

  setUp(() {
    mockRepository = MockAvatarRepository();
    useCase = UpdateAvatarStateUseCase(mockRepository);
  });

  test('should update avatar state to tired after 3 hours', () async {
    // Arrange
    when(() => mockRepository.updateAvatarState(any()))
        .thenAnswer((_) async => {});

    // Act
    await useCase.execute(Duration(hours: 3));

    // Assert
    verify(() => mockRepository.updateAvatarState(AvatarState.tired)).called(1);
  });
}
```

---

## ✅ Repository Interfaces Validation Checklist

Selon governance.md:

- [x] Toutes interfaces repositories définies (7 repositories: Auth, Avatar, UserProfile, HydrationLog, Streak, NotificationState, PhotoStorage)
- [x] Toutes méthodes documentées avec params/returns
- [x] Error handling strategy définie (StorageException)
- [x] Dependency injection pattern défini (get_it)
- [x] Testing strategy avec mocks expliquée
- [x] Naming conventions respectées (PascalCase, async Future)
- [x] Clean Architecture respectée (interfaces in domain/)
- [ ] Validation PM (awaiting)

---

## 📋 Repository Implementation Checklist (Pour Phase Dev)

Après validation PM, chaque repository implementation doit:

1. ✅ Implémenter l'interface du domain
2. ✅ Utiliser data sources (local + remote si applicable)
3. ✅ Gérer offline-first (local prioritaire)
4. ✅ Async sync cloud (best effort)
5. ✅ Throw StorageException en cas d'erreur
6. ✅ Logger opérations (debug level)
7. ✅ Tests unitaires 100% coverage
8. ✅ Tests d'intégration avec SQLite réel

---

**Document créé le 2026-01-07 par Winston (Architect)**
**Status: DRAFT - Awaiting PM Validation**
**Next: use-cases-interface.md (dernier document contrats)**