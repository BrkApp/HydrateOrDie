# Deployment & CI/CD Architecture

**Partie de:** [Architecture Document](index.md)

---

## Build & Release Pipeline

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

[⬅️ Analytics & Monitoring](analytics.md) | [➡️ V2 Features](v2-features.md)
