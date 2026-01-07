# API Contracts - Hydrate or Die MVP

**Version:** 1.0
**Date:** 2026-01-07
**Owner:** Winston (Architect)
**Status:** DRAFT - Awaiting PM Validation
**Reference:** tech-stack.md, database-schema.md

---

## 📋 Overview

Ce document définit tous les contrats d'API externes utilisés par Hydrate or Die MVP. L'application utilise **Firebase** (Backend-as-a-Service) et n'a **pas de backend custom** pour le MVP.

**Services Firebase Utilisés:**
1. Firebase Authentication
2. Cloud Firestore
3. Firebase Storage
4. Firebase Analytics
5. Firebase Crashlytics

---

## 1. Firebase Authentication

### 1.1 Sign Up (Email/Password)

**Package:** `firebase_auth: ^4.15.0`

**Method:** `createUserWithEmailAndPassword()`

**Input:**
```dart
Future<UserCredential> createUserWithEmailAndPassword({
  required String email,
  required String password,
});
```

**Parameters:**
- `email` (String): Email utilisateur (validation format email)
- `password` (String): Mot de passe (min 6 caractères)

**Output:**
```dart
class UserCredential {
  User? user;          // User object avec UID
  AdditionalUserInfo? additionalUserInfo;
}

class User {
  String uid;          // Unique identifier
  String? email;
  bool emailVerified;
  DateTime? metadata.creationTime;
}
```

**Error Cases:**
- `email-already-in-use`: Email déjà enregistré
- `invalid-email`: Format email invalide
- `weak-password`: Mot de passe trop faible
- `operation-not-allowed`: Email/password auth désactivé

**Example Usage:**
```dart
try {
  final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: 'user@example.com',
    password: 'SecurePass123',
  );
  final userId = credential.user!.uid;
  print('User created: $userId');
} on FirebaseAuthException catch (e) {
  if (e.code == 'email-already-in-use') {
    print('Email already exists');
  }
}
```

---

### 1.2 Sign In (Email/Password)

**Method:** `signInWithEmailAndPassword()`

**Input:**
```dart
Future<UserCredential> signInWithEmailAndPassword({
  required String email,
  required String password,
});
```

**Output:** Same as Sign Up

**Error Cases:**
- `user-not-found`: Aucun utilisateur avec cet email
- `wrong-password`: Mot de passe incorrect
- `invalid-email`: Format email invalide

---

### 1.3 Apple Sign-In (iOS)

**Method:** `signInWithCredential()` + Apple Provider

**Input:**
```dart
final appleProvider = AppleAuthProvider();
final credential = await FirebaseAuth.instance.signInWithProvider(appleProvider);
```

**Output:** `UserCredential` avec Apple UID

**Required:** Configured Apple Sign-In in Firebase Console + Xcode

---

### 1.4 Google Sign-In (Android)

**Method:** `signInWithCredential()` + Google Provider

**Input:**
```dart
final googleProvider = GoogleAuthProvider();
final credential = await FirebaseAuth.instance.signInWithProvider(googleProvider);
```

**Output:** `UserCredential` avec Google UID

---

### 1.5 Sign Out

**Method:** `signOut()`

**Input:** None

**Output:** `Future<void>`

**Example:**
```dart
await FirebaseAuth.instance.signOut();
```

---

### 1.6 Get Current User

**Method:** `currentUser` (getter)

**Output:**
```dart
User? currentUser = FirebaseAuth.instance.currentUser;
```

**Returns:** `null` si non authentifié

---

## 2. Cloud Firestore

### 2.1 Create/Update User Document

**Method:** `set()` ou `update()`

**Path:** `/users/{userId}`

**Input:**
```dart
await FirebaseFirestore.instance
    .collection('users')
    .doc(userId)
    .set({
  'profile': {
    'weight': 75.0,
    'age': 30,
    'gender': 'male',
    'activityLevel': 'moderate',
    'dailyGoalLiters': 2.5,
    'locationPermissionGranted': false,
    'createdAt': FieldValue.serverTimestamp(),
    'updatedAt': FieldValue.serverTimestamp(),
  },
  'avatar': {
    'selectedAvatarId': 'sports_coach',
    'currentState': 'fresh',
    'lastDrinkTime': FieldValue.serverTimestamp(),
    'lastUpdated': FieldValue.serverTimestamp(),
  },
  'streak': {
    'currentStreak': 0,
    'longestStreak': 0,
    'lastStreakDate': '2026-01-07',
    'streakActive': false,
    'updatedAt': FieldValue.serverTimestamp(),
  },
}, SetOptions(merge: true)); // Merge pour updates partiels
```

**Output:** `Future<void>`

**Error Cases:**
- `permission-denied`: Security rules violation
- `unavailable`: Firestore service down (offline)

---

### 2.2 Get User Document

**Method:** `get()`

**Path:** `/users/{userId}`

**Input:**
```dart
final docSnapshot = await FirebaseFirestore.instance
    .collection('users')
    .doc(userId)
    .get();
```

**Output:**
```dart
class DocumentSnapshot {
  String id;                    // Document ID
  bool exists;                  // true si existe
  Map<String, dynamic>? data(); // Document data
  Timestamp? get('fieldName');  // Get specific field
}
```

**Example:**
```dart
if (docSnapshot.exists) {
  final data = docSnapshot.data()!;
  final profile = data['profile'];
  print('Weight: ${profile['weight']}');
}
```

---

### 2.3 Add Hydration Log

**Method:** `add()` ou `set()` avec ID custom

**Path:** `/users/{userId}/hydrationLogs/{logId}`

**Input:**
```dart
await FirebaseFirestore.instance
    .collection('users')
    .doc(userId)
    .collection('hydrationLogs')
    .doc(logId) // UUID généré côté client
    .set({
  'timestamp': Timestamp.fromDate(DateTime.now()),
  'photoPath': 'gs://bucket/path/photo.jpg', // ou null
  'glassSize': 'medium',
  'volumeLiters': 0.25,
  'validated': true,
  'createdAt': FieldValue.serverTimestamp(),
});
```

**Output:** `Future<void>`

---

### 2.4 Query Hydration Logs (Date Range)

**Method:** `where()` + `orderBy()`

**Path:** `/users/{userId}/hydrationLogs`

**Input:**
```dart
final startOfDay = Timestamp.fromDate(DateTime(2026, 1, 7, 0, 0, 0));
final endOfDay = Timestamp.fromDate(DateTime(2026, 1, 7, 23, 59, 59));

final querySnapshot = await FirebaseFirestore.instance
    .collection('users')
    .doc(userId)
    .collection('hydrationLogs')
    .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
    .where('timestamp', isLessThanOrEqualTo: endOfDay)
    .orderBy('timestamp', descending: true)
    .get();
```

**Output:**
```dart
class QuerySnapshot {
  List<QueryDocumentSnapshot> docs;
  int size;                       // Number of documents
}
```

**Example:**
```dart
for (final doc in querySnapshot.docs) {
  final data = doc.data();
  print('Log: ${data['volumeLiters']}L at ${data['timestamp']}');
}
```

---

### 2.5 Delete User Data (RGPD)

**Method:** `delete()`

**Path:** `/users/{userId}` + subcollections

**Input:**
```dart
// Delete main document
await FirebaseFirestore.instance
    .collection('users')
    .doc(userId)
    .delete();

// Delete subcollection (hydrationLogs) - requires batch or recursive delete
final logsSnapshot = await FirebaseFirestore.instance
    .collection('users')
    .doc(userId)
    .collection('hydrationLogs')
    .get();

final batch = FirebaseFirestore.instance.batch();
for (final doc in logsSnapshot.docs) {
  batch.delete(doc.reference);
}
await batch.commit();
```

**Output:** `Future<void>`

---

## 3. Firebase Storage

### 3.1 Upload Photo

**Method:** `putFile()`

**Path:** `/users/{userId}/photos/{photoId}.jpg`

**Input:**
```dart
import 'dart:io';

final file = File('/local/path/hydration_20260107_143000.jpg');
final ref = FirebaseStorage.instance
    .ref()
    .child('users/$userId/photos/${photoId}.jpg');

final uploadTask = ref.putFile(
  file,
  SettableMetadata(contentType: 'image/jpeg'),
);

final snapshot = await uploadTask;
```

**Output:**
```dart
class TaskSnapshot {
  int bytesTransferred;
  int totalBytes;
  TaskState state;  // TaskState.success | error | paused
  Reference ref;    // Storage reference
}
```

**Get Download URL:**
```dart
final downloadUrl = await snapshot.ref.getDownloadURL();
// Returns: https://firebasestorage.googleapis.com/v0/b/.../o/...?alt=media&token=...
```

**Error Cases:**
- `storage/unauthorized`: Security rules violation
- `storage/quota-exceeded`: Storage quota dépassé
- `storage/retry-limit-exceeded`: Trop de retries

---

### 3.2 Download Photo

**Method:** `getDownloadURL()` puis HTTP download

**Input:**
```dart
final ref = FirebaseStorage.instance
    .ref()
    .child('users/$userId/photos/${photoId}.jpg');

final downloadUrl = await ref.getDownloadURL();
// Use HTTP client to download
```

**Output:** `String` (download URL)

---

### 3.3 Delete Photo

**Method:** `delete()`

**Input:**
```dart
final ref = FirebaseStorage.instance
    .ref()
    .child('users/$userId/photos/${photoId}.jpg');

await ref.delete();
```

**Output:** `Future<void>`

---

## 4. Firebase Analytics

### 4.1 Log Event

**Method:** `logEvent()`

**Input:**
```dart
await FirebaseAnalytics.instance.logEvent(
  name: 'hydration_validated',
  parameters: {
    'glass_size': 'medium',
    'photo_taken': true,
    'volume_liters': 0.25,
    'timestamp': DateTime.now().toIso8601String(),
  },
);
```

**Parameters:**
- `name` (String): Event name (max 40 chars, alphanumeric + underscore)
- `parameters` (Map<String, Object>): Event properties (max 25 params)

**Output:** `Future<void>`

**Predefined Events (MVP):**
```dart
// User events
logEvent(name: 'app_open');
logEvent(name: 'onboarding_completed', parameters: {'avatar_id': 'sports_coach'});
logEvent(name: 'avatar_selected', parameters: {'personality': 'sportsCoach'});
logEvent(name: 'hydration_validated', parameters: {'glass_size': 'medium'});
logEvent(name: 'notification_sent', parameters: {'level': 'dramatic'});
logEvent(name: 'notification_opened');
logEvent(name: 'streak_milestone', parameters: {'days': 7});
logEvent(name: 'avatar_died');
logEvent(name: 'avatar_resurrected');

// Technical events
logEvent(name: 'photo_validation_failed', parameters: {'reason': 'permission_denied'});
logEvent(name: 'sync_failed', parameters: {'operation': 'upload_log'});
```

---

### 4.2 Set User Property

**Method:** `setUserProperty()`

**Input:**
```dart
await FirebaseAnalytics.instance.setUserProperty(
  name: 'avatar_personality',
  value: 'sports_coach',
);
```

**Output:** `Future<void>`

**User Properties (MVP):**
- `avatar_personality`: String
- `activity_level`: String
- `daily_goal_liters`: String (as string, ex: "2.5")

---

## 5. Firebase Crashlytics

### 5.1 Log Non-Fatal Error

**Method:** `recordError()`

**Input:**
```dart
try {
  // Some operation
} catch (error, stackTrace) {
  await FirebaseCrashlytics.instance.recordError(
    error,
    stackTrace,
    reason: 'Failed to sync hydration log',
    fatal: false,
  );
}
```

**Output:** `Future<void>`

---

### 5.2 Set Custom Key

**Method:** `setCustomKey()`

**Input:**
```dart
await FirebaseCrashlytics.instance.setCustomKey('user_id', userId);
await FirebaseCrashlytics.instance.setCustomKey('avatar_state', 'tired');
```

**Output:** `Future<void>`

**Usage:** Contextual info pour debugging crashes

---

### 5.3 Log Message

**Method:** `log()`

**Input:**
```dart
FirebaseCrashlytics.instance.log('User validated hydration with photo');
```

**Output:** `void`

---

## 6. API Rate Limits & Quotas

### 6.1 Firestore (Spark Plan - Free)

**Quotas:**
- **Reads:** 50,000 documents/day
- **Writes:** 20,000 documents/day
- **Deletes:** 20,000 documents/day
- **Storage:** 1 GB total

**Estimated MVP Usage (10k users):**
- Reads: ~30k/day (profile reads, logs queries)
- Writes: ~15k/day (hydration logs, avatar updates)
- Storage: ~50 MB (user profiles + recent logs)

**Conclusion:** Spark Plan suffisant pour MVP jusqu'à 10-15k users

---

### 6.2 Firebase Storage (Spark Plan - Free)

**Quotas:**
- **Storage:** 5 GB total
- **Download:** 1 GB/day
- **Upload:** 1 GB/day

**Estimated MVP Usage (10k users, opt-in photos):**
- Storage: ~2 GB (assume 20% opt-in, 500KB/photo, 90 days retention)
- Upload: ~200 MB/day
- Download: ~50 MB/day (restore photos)

**Conclusion:** Spark Plan suffisant pour MVP

---

### 6.3 Firebase Authentication (Free)

**Quotas:** Unlimited pour email/password, Apple, Google Sign-In

---

## 7. Error Handling Strategy

### 7.1 Network Errors

**Firebase Offline Persistence:**
```dart
// Enable offline persistence (défaut sur mobile)
await FirebaseFirestore.instance.enablePersistence();
```

**Retry Logic:**
```dart
Future<void> syncWithRetry(Function operation, {int maxRetries = 3}) async {
  for (int attempt = 0; attempt < maxRetries; attempt++) {
    try {
      await operation();
      return; // Success
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable' && attempt < maxRetries - 1) {
        await Future.delayed(Duration(seconds: 2 * (attempt + 1)));
        continue; // Retry
      } else {
        rethrow; // Give up
      }
    }
  }
}
```

---

### 7.2 Permission Errors

**Catch Security Rules Violations:**
```dart
try {
  await FirebaseFirestore.instance.collection('users').doc(userId).get();
} on FirebaseException catch (e) {
  if (e.code == 'permission-denied') {
    print('User not authenticated or wrong UID');
    // Redirect to login
  }
}
```

---

## ✅ API Contracts Validation Checklist

- [x] Tous services Firebase documentés (Auth, Firestore, Storage, Analytics, Crashlytics)
- [x] Toutes méthodes critiques définies avec inputs/outputs
- [x] Error cases documentés pour chaque API
- [x] Quotas & rate limits identifiés
- [x] Retry strategy définie pour network errors
- [x] Security rules violations handling
- [x] Example code fourni pour chaque opération
- [ ] Validation PM (awaiting)

---

**Document créé le 2026-01-07 par Winston (Architect)**
**Status: DRAFT - Awaiting PM Validation**
**Next: repositories-interface.md, use-cases-interface.md**
