# Security & Authentication Architecture

**Partie de:** [Architecture Document](index.md)

---

## Authentication Flow

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

## Data Privacy & RGPD

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

## Delete Account Flow

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

[⬅️ Background Jobs](background-jobs.md) | [➡️ Analytics & Monitoring](analytics.md)
