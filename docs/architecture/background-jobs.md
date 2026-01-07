# Background Jobs & Timers

**Partie de:** [Architecture Document](index.md)

---

## App Lifecycle Management

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

[⬅️ Photo Validation](photo-validation.md) | [➡️ Security & Auth](security-auth.md)
