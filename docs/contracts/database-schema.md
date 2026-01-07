# Database Schema - Hydrate or Die MVP

**Version:** 1.0
**Date:** 2026-01-07
**Owner:** Winston (Architect)
**Status:** DRAFT - Awaiting PM Validation
**Reference:** PRD v1.0, data-models.md, system-architecture.md

---

## 📋 Table des Matières

1. [Overview & Strategy](#1-overview--strategy)
2. [SQLite Schema (Local Database)](#2-sqlite-schema-local-database)
3. [Firestore Schema (Cloud Backup)](#3-firestore-schema-cloud-backup)
4. [Sync Strategy & Conflict Resolution](#4-sync-strategy--conflict-resolution)
5. [Migrations & Versioning](#5-migrations--versioning)
6. [Indexes & Performance](#6-indexes--performance)

---

## 1. Overview & Strategy

### 1.1 Database Architecture

**Principle:** Offline-First avec backup cloud

```
┌──────────────────────────────────────────────────┐
│         DATABASE ARCHITECTURE                    │
├──────────────────────────────────────────────────┤
│                                                  │
│  PRIMARY (Source of Truth):                      │
│  ┌────────────────────────────┐                 │
│  │      SQLite (Local)        │                 │
│  │  - Embedded dans app       │                 │
│  │  - Fonctionne offline      │                 │
│  │  - Requêtes rapides        │                 │
│  │  - Source de vérité        │                 │
│  └────────────────────────────┘                 │
│           │                                      │
│           │ Sync Async                           │
│           │ (When online)                        │
│           ▼                                      │
│  SECONDARY (Backup & Multi-Device):              │
│  ┌────────────────────────────┐                 │
│  │  Firestore (Cloud NoSQL)   │                 │
│  │  - Backup données          │                 │
│  │  - Multi-device sync       │                 │
│  │  - Restore si réinstall    │                 │
│  └────────────────────────────┘                 │
│                                                  │
└──────────────────────────────────────────────────┘
```

### 1.2 Data Residency

**Local (SQLite):**
- Profil utilisateur
- État avatar
- Logs hydratation (tous)
- Données streaks
- État notifications
- **Photos selfies** (filesystem, pas DB)

**Cloud (Firestore):**
- Profil utilisateur (backup)
- État avatar (backup)
- Logs hydratation (backup partiel - derniers 90 jours)
- Données streaks (backup)
- **Photos selfies (opt-in)** : Firebase Storage

### 1.3 Sync Policy

**Write:**
1. Écriture immédiate dans SQLite ✅
2. Écriture async dans Firestore (best effort) ⏳
3. Si échec Firestore → Queue retry

**Read:**
1. Toujours lire depuis SQLite (rapide, offline)
2. Firestore utilisé uniquement pour restore/multi-device

**Conflict Resolution:**
- Last-Write-Wins (timestamp-based)
- SQLite `updated_at` vs Firestore `updatedAt`

---

## 2. SQLite Schema (Local Database)

### 2.1 Database Configuration

**File:** `hydrate_or_die.db`
**Location:**
- iOS: `Application Support/databases/`
- Android: `/data/data/com.hydrateordie.app/databases/`

**Version:** 1 (initial)
**Package:** `sqflite` (^2.3.0)

---

### 2.2 Table: user_profile

**Purpose:** Stockage profil utilisateur unique

```sql
CREATE TABLE user_profile (
    id TEXT PRIMARY KEY NOT NULL,
    weight REAL NOT NULL CHECK(weight >= 30.0 AND weight <= 300.0),
    age INTEGER NOT NULL CHECK(age >= 10 AND age <= 120),
    gender TEXT NOT NULL CHECK(gender IN ('male', 'female', 'other')),
    activity_level TEXT NOT NULL CHECK(activity_level IN ('sedentary', 'light', 'moderate', 'veryActive', 'extremelyActive')),
    location_permission_granted INTEGER NOT NULL DEFAULT 0, -- Boolean: 0 = false, 1 = true
    daily_goal_liters REAL NOT NULL CHECK(daily_goal_liters >= 1.5 AND daily_goal_liters <= 5.0),
    created_at TEXT NOT NULL, -- ISO 8601 UTC
    updated_at TEXT NOT NULL  -- ISO 8601 UTC
);
```

**Columns:**

| Column | Type | Nullable | Default | Constraints | Description |
|--------|------|----------|---------|-------------|-------------|
| `id` | TEXT (UUID) | NO | - | PRIMARY KEY | Identifiant unique utilisateur |
| `weight` | REAL | NO | - | 30.0-300.0 | Poids en kg |
| `age` | INTEGER | NO | - | 10-120 | Âge en années |
| `gender` | TEXT | NO | - | ENUM | 'male', 'female', 'other' |
| `activity_level` | TEXT | NO | - | ENUM | 'sedentary', 'light', 'moderate', 'veryActive', 'extremelyActive' |
| `location_permission_granted` | INTEGER (BOOL) | NO | 0 | 0 ou 1 | Permission localisation |
| `daily_goal_liters` | REAL | NO | - | 1.5-5.0 | Objectif quotidien calculé |
| `created_at` | TEXT (ISO 8601) | NO | - | - | Date création |
| `updated_at` | TEXT (ISO 8601) | NO | - | - | Dernière modification |

**Indexes:** Aucun (table singleton, 1 row max)

**Migration Strategy:**
- Version 1: CREATE TABLE initial
- Pas de migration nécessaire pour MVP (table simple)

**Example Row:**

```sql
INSERT INTO user_profile VALUES (
    '550e8400-e29b-41d4-a716-446655440000',
    75.0,
    30,
    'male',
    'moderate',
    0,
    2.5,
    '2026-01-07T10:00:00.000Z',
    '2026-01-07T10:00:00.000Z'
);
```

---

### 2.3 Table: avatar_state

**Purpose:** État actuel de l'avatar Tamagotchi

```sql
CREATE TABLE avatar_state (
    id TEXT PRIMARY KEY NOT NULL DEFAULT 'avatar_singleton',
    selected_avatar_id TEXT NOT NULL CHECK(selected_avatar_id IN ('authoritarian_mother', 'sports_coach', 'doctor', 'sarcasticFriend')),
    current_state TEXT NOT NULL CHECK(current_state IN ('fresh', 'tired', 'dehydrated', 'dead', 'ghost')),
    last_drink_time TEXT NOT NULL, -- ISO 8601 UTC
    last_updated TEXT NOT NULL      -- ISO 8601 UTC
);
```

**Columns:**

| Column | Type | Nullable | Default | Constraints | Description |
|--------|------|----------|---------|-------------|-------------|
| `id` | TEXT | NO | `'avatar_singleton'` | PRIMARY KEY | ID fixe (singleton) |
| `selected_avatar_id` | TEXT | NO | - | ENUM | ID avatar sélectionné |
| `current_state` | TEXT | NO | - | ENUM | État déshydratation actuel |
| `last_drink_time` | TEXT (ISO 8601) | NO | - | - | Timestamp dernière hydratation |
| `last_updated` | TEXT (ISO 8601) | NO | - | - | Dernière mise à jour état |

**Indexes:** Aucun (table singleton)

**Example Row:**

```sql
INSERT INTO avatar_state VALUES (
    'avatar_singleton',
    'sports_coach',
    'fresh',
    '2026-01-07T14:30:00.000Z',
    '2026-01-07T14:30:00.000Z'
);
```

---

### 2.4 Table: hydration_logs

**Purpose:** Historique complet des validations d'hydratation

```sql
CREATE TABLE hydration_logs (
    id TEXT PRIMARY KEY NOT NULL,
    timestamp TEXT NOT NULL,               -- ISO 8601 UTC
    photo_path TEXT,                       -- Nullable (peut être null si photo fail)
    glass_size TEXT NOT NULL DEFAULT 'medium' CHECK(glass_size IN ('small', 'medium', 'large')),
    volume_liters REAL NOT NULL CHECK(volume_liters > 0),
    validated INTEGER NOT NULL DEFAULT 1,  -- Boolean: toujours 1 (true) pour logs créés
    synced_to_cloud INTEGER NOT NULL DEFAULT 0, -- Boolean: 0 = pas encore sync, 1 = synced
    created_at TEXT NOT NULL               -- ISO 8601 UTC
);

-- Index pour requêtes par date (getTodayLogs, getLogsForDate)
CREATE INDEX idx_hydration_logs_timestamp ON hydration_logs(timestamp);

-- Index pour requêtes sync (retry failed syncs)
CREATE INDEX idx_hydration_logs_synced ON hydration_logs(synced_to_cloud);
```

**Columns:**

| Column | Type | Nullable | Default | Constraints | Description |
|--------|------|----------|---------|-------------|-------------|
| `id` | TEXT (UUID) | NO | - | PRIMARY KEY | Identifiant unique log |
| `timestamp` | TEXT (ISO 8601) | NO | - | - | Date/heure validation |
| `photo_path` | TEXT | YES | NULL | - | Chemin fichier photo locale |
| `glass_size` | TEXT | NO | `'medium'` | ENUM | 'small', 'medium', 'large' |
| `volume_liters` | REAL | NO | - | > 0 | Volume en litres |
| `validated` | INTEGER (BOOL) | NO | 1 | 0 ou 1 | Toujours 1 pour logs créés |
| `synced_to_cloud` | INTEGER (BOOL) | NO | 0 | 0 ou 1 | Flag sync Firestore |
| `created_at` | TEXT (ISO 8601) | NO | - | - | Date création log |

**Indexes:**

1. `idx_hydration_logs_timestamp` : Accélère queries par date
2. `idx_hydration_logs_synced` : Accélère retry sync failed

**Example Rows:**

```sql
INSERT INTO hydration_logs VALUES (
    '660e8400-e29b-41d4-a716-446655440001',
    '2026-01-07T09:15:00.000Z',
    '/app_documents/hydration_photos/hydration_20260107_091500.jpg',
    'medium',
    0.25,
    1,
    1,
    '2026-01-07T09:15:05.000Z'
);

INSERT INTO hydration_logs VALUES (
    '660e8400-e29b-41d4-a716-446655440002',
    '2026-01-07T14:30:00.000Z',
    '/app_documents/hydration_photos/hydration_20260107_143000.jpg',
    'large',
    0.4,
    1,
    0, -- Pas encore synced (offline)
    '2026-01-07T14:30:05.000Z'
);
```

---

### 2.5 Table: streak_data

**Purpose:** Données streaks (jours consécutifs)

```sql
CREATE TABLE streak_data (
    id TEXT PRIMARY KEY NOT NULL DEFAULT 'streak_singleton',
    current_streak INTEGER NOT NULL DEFAULT 0 CHECK(current_streak >= 0),
    longest_streak INTEGER NOT NULL DEFAULT 0 CHECK(longest_streak >= 0),
    last_streak_date TEXT NOT NULL, -- ISO 8601 date (YYYY-MM-DD)
    streak_active INTEGER NOT NULL DEFAULT 0, -- Boolean: objectif atteint aujourd'hui
    updated_at TEXT NOT NULL        -- ISO 8601 UTC
);
```

**Columns:**

| Column | Type | Nullable | Default | Constraints | Description |
|--------|------|----------|---------|-------------|-------------|
| `id` | TEXT | NO | `'streak_singleton'` | PRIMARY KEY | ID fixe (singleton) |
| `current_streak` | INTEGER | NO | 0 | >= 0 | Jours consécutifs actuels |
| `longest_streak` | INTEGER | NO | 0 | >= 0 | Record personnel |
| `last_streak_date` | TEXT (DATE) | NO | - | YYYY-MM-DD | Dernière date objectif atteint |
| `streak_active` | INTEGER (BOOL) | NO | 0 | 0 ou 1 | Objectif atteint aujourd'hui |
| `updated_at` | TEXT (ISO 8601) | NO | - | - | Dernière mise à jour |

**Indexes:** Aucun (table singleton)

**Example Row:**

```sql
INSERT INTO streak_data VALUES (
    'streak_singleton',
    7,
    15,
    '2026-01-06',
    1, -- Actif aujourd'hui
    '2026-01-07T00:00:00.000Z'
);
```

---

### 2.6 Table: notification_state

**Purpose:** État système notifications (escalade)

```sql
CREATE TABLE notification_state (
    id TEXT PRIMARY KEY NOT NULL DEFAULT 'notification_singleton',
    current_level TEXT NOT NULL DEFAULT 'calm' CHECK(current_level IN ('calm', 'concerned', 'dramatic', 'chaos')),
    last_notification_time TEXT, -- ISO 8601 UTC, Nullable (null si aucune notif envoyée)
    notifications_sent_today INTEGER NOT NULL DEFAULT 0 CHECK(notifications_sent_today >= 0),
    updated_at TEXT NOT NULL     -- ISO 8601 UTC
);
```

**Columns:**

| Column | Type | Nullable | Default | Constraints | Description |
|--------|------|----------|---------|-------------|-------------|
| `id` | TEXT | NO | `'notification_singleton'` | PRIMARY KEY | ID fixe (singleton) |
| `current_level` | TEXT | NO | `'calm'` | ENUM | Niveau escalade actuel |
| `last_notification_time` | TEXT (ISO 8601) | YES | NULL | - | Timestamp dernière notif |
| `notifications_sent_today` | INTEGER | NO | 0 | >= 0 | Compteur jour |
| `updated_at` | TEXT (ISO 8601) | NO | - | - | Dernière mise à jour |

**Indexes:** Aucun (table singleton)

**Example Row:**

```sql
INSERT INTO notification_state VALUES (
    'notification_singleton',
    'dramatic',
    '2026-01-07T15:45:00.000Z',
    12,
    '2026-01-07T15:45:00.000Z'
);
```

---

### 2.7 SQLite Database Helper (Dart Code)

```dart
// data/data_sources/local/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const String _databaseName = 'hydrate_or_die.db';
  static const int _databaseVersion = 1;

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Table user_profile
    await db.execute('''
      CREATE TABLE user_profile (
        id TEXT PRIMARY KEY NOT NULL,
        weight REAL NOT NULL CHECK(weight >= 30.0 AND weight <= 300.0),
        age INTEGER NOT NULL CHECK(age >= 10 AND age <= 120),
        gender TEXT NOT NULL CHECK(gender IN ('male', 'female', 'other')),
        activity_level TEXT NOT NULL,
        location_permission_granted INTEGER NOT NULL DEFAULT 0,
        daily_goal_liters REAL NOT NULL CHECK(daily_goal_liters >= 1.5 AND daily_goal_liters <= 5.0),
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Table avatar_state
    await db.execute('''
      CREATE TABLE avatar_state (
        id TEXT PRIMARY KEY NOT NULL DEFAULT 'avatar_singleton',
        selected_avatar_id TEXT NOT NULL,
        current_state TEXT NOT NULL,
        last_drink_time TEXT NOT NULL,
        last_updated TEXT NOT NULL
      )
    ''');

    // Table hydration_logs
    await db.execute('''
      CREATE TABLE hydration_logs (
        id TEXT PRIMARY KEY NOT NULL,
        timestamp TEXT NOT NULL,
        photo_path TEXT,
        glass_size TEXT NOT NULL DEFAULT 'medium',
        volume_liters REAL NOT NULL CHECK(volume_liters > 0),
        validated INTEGER NOT NULL DEFAULT 1,
        synced_to_cloud INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL
      )
    ''');
    await db.execute('CREATE INDEX idx_hydration_logs_timestamp ON hydration_logs(timestamp)');
    await db.execute('CREATE INDEX idx_hydration_logs_synced ON hydration_logs(synced_to_cloud)');

    // Table streak_data
    await db.execute('''
      CREATE TABLE streak_data (
        id TEXT PRIMARY KEY NOT NULL DEFAULT 'streak_singleton',
        current_streak INTEGER NOT NULL DEFAULT 0 CHECK(current_streak >= 0),
        longest_streak INTEGER NOT NULL DEFAULT 0 CHECK(longest_streak >= 0),
        last_streak_date TEXT NOT NULL,
        streak_active INTEGER NOT NULL DEFAULT 0,
        updated_at TEXT NOT NULL
      )
    ''');

    // Table notification_state
    await db.execute('''
      CREATE TABLE notification_state (
        id TEXT PRIMARY KEY NOT NULL DEFAULT 'notification_singleton',
        current_level TEXT NOT NULL DEFAULT 'calm',
        last_notification_time TEXT,
        notifications_sent_today INTEGER NOT NULL DEFAULT 0 CHECK(notifications_sent_today >= 0),
        updated_at TEXT NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Migrations futures (V2, V3, etc.)
    // Example:
    // if (oldVersion < 2) {
    //   await db.execute('ALTER TABLE user_profile ADD COLUMN new_field TEXT');
    // }
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }

  Future<void> deleteDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }
}
```

---

## 3. Firestore Schema (Cloud Backup)

### 3.1 Firestore Structure Overview

**Database:** Default Firestore database

**Collections:**
- `/users/{userId}` : Documents utilisateur

**Security Rules:** Rules strictes basées sur Auth UID

```
┌─────────────────────────────────────────┐
│      FIRESTORE STRUCTURE                │
├─────────────────────────────────────────┤
│                                         │
│  users/ (collection)                    │
│    └── {userId}/ (document)             │
│          ├── profile (map)              │
│          ├── avatar (map)               │
│          ├── streak (map)               │
│          └── hydrationLogs/ (subcoll)   │
│                └── {logId} (document)   │
│                                         │
└─────────────────────────────────────────┘
```

---

### 3.2 Collection: /users/{userId}

**Document Fields:**

```typescript
{
  "profile": {
    "weight": number,           // kg
    "age": number,              // years
    "gender": string,           // 'male' | 'female' | 'other'
    "activityLevel": string,    // 'sedentary' | 'light' | 'moderate' | 'veryActive' | 'extremelyActive'
    "dailyGoalLiters": number,  // 1.5-5.0
    "locationPermissionGranted": boolean,
    "createdAt": Timestamp,
    "updatedAt": Timestamp
  },
  "avatar": {
    "selectedAvatarId": string, // 'authoritarian_mother' | 'sports_coach' | 'doctor' | 'sarcasticFriend'
    "currentState": string,     // 'fresh' | 'tired' | 'dehydrated' | 'dead' | 'ghost'
    "lastDrinkTime": Timestamp,
    "lastUpdated": Timestamp
  },
  "streak": {
    "currentStreak": number,    // >= 0
    "longestStreak": number,    // >= 0
    "lastStreakDate": string,   // 'YYYY-MM-DD'
    "streakActive": boolean,
    "updatedAt": Timestamp
  }
}
```

**Example Document:**

```json
{
  "profile": {
    "weight": 75.0,
    "age": 30,
    "gender": "male",
    "activityLevel": "moderate",
    "dailyGoalLiters": 2.5,
    "locationPermissionGranted": false,
    "createdAt": "2026-01-07T10:00:00.000Z",
    "updatedAt": "2026-01-07T10:00:00.000Z"
  },
  "avatar": {
    "selectedAvatarId": "sports_coach",
    "currentState": "fresh",
    "lastDrinkTime": "2026-01-07T14:30:00.000Z",
    "lastUpdated": "2026-01-07T14:30:00.000Z"
  },
  "streak": {
    "currentStreak": 7,
    "longestStreak": 15,
    "lastStreakDate": "2026-01-06",
    "streakActive": true,
    "updatedAt": "2026-01-07T00:00:00.000Z"
  }
}
```

**Indexes:**
- None needed (document queries by UID)

---

### 3.3 SubCollection: /users/{userId}/hydrationLogs

**Purpose:** Backup logs hydratation (derniers 90 jours)

**Document Fields:**

```typescript
{
  "timestamp": Timestamp,
  "photoPath": string | null,     // Path local ou URL Storage
  "glassSize": string,            // 'small' | 'medium' | 'large'
  "volumeLiters": number,
  "validated": boolean,           // Toujours true
  "createdAt": Timestamp
}
```

**Example Documents:**

```json
// Log ID: "660e8400-e29b-41d4-a716-446655440001"
{
  "timestamp": "2026-01-07T09:15:00.000Z",
  "photoPath": "gs://hydrate-or-die-prod.appspot.com/users/550e8400.../photos/hydration_20260107_091500.jpg",
  "glassSize": "medium",
  "volumeLiters": 0.25,
  "validated": true,
  "createdAt": "2026-01-07T09:15:05.000Z"
}

// Log ID: "660e8400-e29b-41d4-a716-446655440002"
{
  "timestamp": "2026-01-07T14:30:00.000Z",
  "photoPath": null,  // Photo non backupée cloud
  "glassSize": "large",
  "volumeLiters": 0.4,
  "validated": true,
  "createdAt": "2026-01-07T14:30:05.000Z"
}
```

**Indexes:**

```
Collection: hydrationLogs
Fields: timestamp (Descending)
Scope: Collection
```

**Cleanup Policy:**
- Cloud Function (V2) : Supprimer logs >90 jours automatiquement

---

### 3.4 Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // User document access
    match /users/{userId} {
      // Allow read/write only if authenticated and UID matches
      allow read, write: if request.auth != null && request.auth.uid == userId;

      // Hydration logs subcollection
      match /hydrationLogs/{logId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }

    // Deny all other access
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
```

---

## 4. Sync Strategy & Conflict Resolution

### 4.1 Sync Flow

```
┌──────────────────────────────────────────────────┐
│            SYNC STRATEGY                         │
├──────────────────────────────────────────────────┤
│                                                  │
│  WRITE (Ex: Update Avatar State)                │
│      │                                           │
│      ├──► SQLite (Local)                         │
│      │    ✅ COMMIT IMMEDIATE                    │
│      │    └── Update `updated_at` = now()        │
│      │                                           │
│      └──► Firestore (Cloud) ASYNC                │
│           ⏳ Try sync                            │
│           ├─ SUCCESS → Mark synced_to_cloud = 1  │
│           └─ FAIL → Queue retry                  │
│                                                  │
│  READ (Ex: Get Avatar State)                     │
│      │                                           │
│      └──► SQLite (Local)                         │
│           ✅ ALWAYS read from local              │
│           (Fast, offline-safe)                   │
│                                                  │
│  APP STARTUP (Online)                            │
│      │                                           │
│      ├──► Pull Firestore → Check timestamps      │
│      │    IF Firestore.updatedAt > SQLite.updated_at│
│      │       THEN Overwrite SQLite with Firestore│
│      │                                           │
│      └──► Push pending local changes             │
│           └── Retry failed syncs (synced = 0)    │
│                                                  │
└──────────────────────────────────────────────────┘
```

### 4.2 Conflict Resolution

**Strategy:** Last-Write-Wins (Timestamp-based)

```dart
// Pseudo-code conflict resolution
Future<void> syncAvatarState() async {
  final localState = await _localDataSource.getAvatarState();
  final remoteState = await _remoteDataSource.getAvatarState(userId);

  final localUpdated = DateTime.parse(localState.lastUpdated);
  final remoteUpdated = remoteState.lastUpdated.toDate();

  if (remoteUpdated.isAfter(localUpdated)) {
    // Remote is newer → Pull
    await _localDataSource.updateAvatarState(remoteState.toModel());
    print('[SYNC] Pulled remote avatar state (newer)');
  } else if (localUpdated.isAfter(remoteUpdated)) {
    // Local is newer → Push
    await _remoteDataSource.updateAvatarState(localState);
    print('[SYNC] Pushed local avatar state (newer)');
  } else {
    // Equal timestamps → Already synced
    print('[SYNC] Avatar state already synced');
  }
}
```

**Edge Cases:**

1. **Both modified offline (rare):** Last-write-wins based on device time
2. **Deleted local but exists remote:** Pull remote (restore)
3. **Deleted account:** Delete both local + remote

---

## 5. Migrations & Versioning

### 5.1 SQLite Migration Strategy

**Current Version:** 1 (MVP)

**Future Migrations Example (V2):**

```dart
Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
  // Migration 1 → 2: Add weather preferences
  if (oldVersion < 2) {
    await db.execute(
      'ALTER TABLE user_profile ADD COLUMN weather_notifications_enabled INTEGER DEFAULT 0'
    );
  }

  // Migration 2 → 3: Add achievements table
  if (oldVersion < 3) {
    await db.execute('''
      CREATE TABLE achievements (
        id TEXT PRIMARY KEY NOT NULL,
        unlocked INTEGER NOT NULL DEFAULT 0,
        unlocked_date TEXT
      )
    ''');
  }
}
```

**Rollback Strategy:**
- Pas de rollback automatique (SQLite limitations)
- Backup local avant migrations majeures
- Tests exhaustifs avant release

---

### 5.2 Firestore Schema Evolution

**Strategy:** Backward-compatible additive changes

**Good Practices:**
- ✅ ADD new fields (avec defaults)
- ✅ DEPRECATE old fields (conserver pour compatibilité)
- ❌ NEVER remove fields sans migration app-side

**Example V2 Migration:**

```dart
// Ajouter field "weatherNotificationsEnabled" au profil
await _firestore
    .collection('users')
    .doc(userId)
    .update({
  'profile.weatherNotificationsEnabled': false, // Default
});
```

---

## 6. Indexes & Performance

### 6.1 SQLite Indexes

**Current Indexes (V1):**

1. `idx_hydration_logs_timestamp` sur `hydration_logs(timestamp)`
   - **Raison:** Accélère `getLogsForDate()`, `getTodayLogs()`
   - **Impact:** Queries date passent de O(n) → O(log n)

2. `idx_hydration_logs_synced` sur `hydration_logs(synced_to_cloud)`
   - **Raison:** Accélère retry sync (find pending syncs)
   - **Impact:** Filter synced=0 rapide

**Performance Targets:**
- Query `getTodayLogs()`: <50ms
- Query `getTotalVolumeForDate()`: <100ms
- Insert `addLog()`: <10ms

---

### 6.2 Firestore Indexes

**Composite Indexes:**

```
Collection: hydrationLogs
Fields:
  - timestamp (Descending)
Query scope: Collection

Purpose: Queries chronologiques rapides
Example: Get last 30 days logs
```

**Exemption Indexes:**
- Pas besoin d'index pour queries simples (single field)
- Firestore auto-index pour queries basiques

---

## 7. Data Cleanup & Retention

### 7.1 Local Cleanup (SQLite)

**Photos Selfies:**
- **Policy:** Supprimer photos >90 jours
- **Job:** Background job nocturne (on app open)
- **Path:** Scan `/hydration_photos/`, check file timestamp

```dart
Future<void> cleanupOldPhotos() async {
  final directory = await getApplicationDocumentsDirectory();
  final photosDir = Directory('${directory.path}/hydration_photos');

  final now = DateTime.now();
  final cutoff = now.subtract(Duration(days: 90));

  await for (final file in photosDir.list()) {
    if (file is File) {
      final stat = await file.stat();
      if (stat.modified.isBefore(cutoff)) {
        await file.delete();
        print('[CLEANUP] Deleted old photo: ${file.path}');
      }
    }
  }
}
```

**Logs Hydratation:**
- **Policy:** Conserver tous logs localement (analytics)
- **Raison:** Calculs streaks historiques, stats mensuelles
- **Size:** ~1KB per log → 365 logs/an = 365KB (négligeable)

---

### 7.2 Cloud Cleanup (Firestore)

**Logs Hydratation:**
- **Policy:** Conserver 90 derniers jours uniquement
- **Job:** Cloud Function scheduled (V2)
- **Raison:** Coûts Firestore, pas besoin historique long cloud

```javascript
// Cloud Function (V2 - future)
exports.cleanupOldLogs = functions.pubsub
  .schedule('every 24 hours')
  .onRun(async (context) => {
    const cutoff = admin.firestore.Timestamp.fromDate(
      new Date(Date.now() - 90 * 24 * 60 * 60 * 1000)
    );

    const logsQuery = admin.firestore()
      .collectionGroup('hydrationLogs')
      .where('timestamp', '<', cutoff);

    const snapshot = await logsQuery.get();
    const batch = admin.firestore().batch();

    snapshot.docs.forEach((doc) => batch.delete(doc.ref));
    await batch.commit();

    console.log(`Deleted ${snapshot.size} old logs`);
  });
```

---

## ✅ Schema Validation Checklist

Selon governance.md:

- [x] Tous schémas SQLite définis avec types/constraints
- [x] Tous schémas Firestore définis avec structure
- [x] Indexes définis pour performance queries
- [x] Sync strategy documentée (offline-first)
- [x] Conflict resolution strategy définie (last-write-wins)
- [x] Migration strategy planifiée (onUpgrade)
- [x] Security rules Firestore définies
- [x] Cleanup policies définies (90 jours)
- [x] Example data provided pour chaque table
- [ ] Validation PM (awaiting)

---

## 📋 Next Steps

1. ✅ **Créer repositories-interface.md**
2. ✅ **Créer use-cases-interface.md**
3. ✅ **Créer api-contracts.md**
4. ⏸️ **Validation PM complète**
5. 🚀 **Implémentation DatabaseHelper + tests**

---

**Document créé le 2026-01-07 par Winston (Architect)**
**Status: DRAFT - Awaiting PM Validation**
**Reference:** data-models.md, system-architecture.md, governance.md
