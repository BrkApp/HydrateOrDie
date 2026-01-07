# Data Layer (Implémentation Repositories & Models)

**Partie de:** [Architecture Document](index.md)

---

## Responsabilité

Implémentation concrète des repositories, modèles sérialisables, data sources

## Structure

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

## Sync Strategy (Offline-First)

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

## Exemple Repository Implementation

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

[⬅️ Domain Layer](domain-layer.md) | [➡️ Presentation Layer](presentation-layer.md)
