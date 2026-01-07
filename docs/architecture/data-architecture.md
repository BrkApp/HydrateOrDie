# Data Architecture

**Partie de:** [Architecture Document](index.md)

---

## Offline-First Data Flow

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

## Database Schema

Détails complets disponibles dans **docs/contracts/database-schema.md** (à créer)

### SQLite (Local - Source de Vérité)

- `user_profile` : Profil utilisateur unique
- `avatar_state` : État avatar actuel
- `hydration_logs` : Historique validations
- `streak_data` : Données streaks
- `notification_state` : État notifications

### Firestore (Cloud - Backup & Sync)

- Collection `/users/{userId}`
  - Document `profile`
  - Document `avatar`
  - Document `streak`
  - SubCollection `hydrationLogs/{logId}`

---

[⬅️ Core Layer](core-layer.md) | [➡️ Notification System](notification-system.md)
