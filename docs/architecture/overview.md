# Vue d'Ensemble Architecture Globale

**Partie de:** [Architecture Document](index.md)

---

## Executive Summary

Hydrate or Die est une application mobile cross-platform (iOS/Android) construite avec **Flutter** et **Clean Architecture**, utilisant **Firebase** comme Backend-as-a-Service et **SQLite** pour la persistence locale offline-first. L'application combine un système d'avatar Tamagotchi, validation photo par selfie, notifications punitives progressives et mécaniques de rétention (streaks) pour transformer l'hydratation en habitude engageante.

**Principes Architecturaux Fondamentaux:**
- **Offline-First:** SQLite est la source de vérité, Firestore le backup cloud
- **Clean Architecture:** Séparation stricte Presentation/Domain/Data
- **Testabilité:** Domain layer 100% pure Dart, injectable, testable en isolation
- **RGPD Compliance:** Data minimization, consent explicite, droit à l'effacement

---

## Vue d'Ensemble Architecture Globale

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

[⬅️ Retour à l'index](index.md) | [➡️ Domain Layer](domain-layer.md)
