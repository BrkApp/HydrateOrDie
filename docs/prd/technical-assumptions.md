# Technical Assumptions

**Partie du:** [Product Requirements Document](index.md)

---

## Repository Structure

**Monorepo**

Le projet utilisera une structure monorepo avec une seule application Flutter contenant tous les composants (mobile iOS + Android). Cette approche simplifie le développement initial pour un MVP et permet une itération rapide. La structure suivra Clean Architecture :

```
hydrate-or-die/
├── lib/
│   ├── core/           # Constants, themes, utils
│   ├── data/           # Models, repositories, data sources
│   ├── domain/         # Business logic, use cases
│   ├── presentation/   # UI (screens, widgets, state management)
│   └── main.dart
├── assets/
│   ├── images/         # Avatars, icons
│   ├── animations/     # Lottie files
│   └── fonts/
├── test/
└── docs/
```

## Service Architecture

**Monolith mobile app avec Backend-as-a-Service (Firebase)**

Pour le MVP, l'application sera monolithique côté mobile (pas de microservices) avec Firebase comme BaaS :

- **Frontend** : Flutter (Dart) - Application mobile unique
- **Backend** : Firebase (Authentication, Firestore, Cloud Storage, Cloud Functions, Analytics, Crashlytics)
- **Database locale** : SQLite via sqflite pour données critiques offline
- **Database cloud** : Firestore pour sync multi-devices et backup
- **Architecture pattern** : Clean Architecture avec séparation presentation/domain/data
- **State Management** : Riverpod (choix préféré) ou Bloc
- **Dependency Injection** : get_it package

**Rationale** : Firebase réduit drastiquement le temps de développement backend pour un MVP, offre un plan gratuit généreux (Spark), et scale automatiquement. Monolith mobile simplifie la maintenance initiale.

## Testing Requirements

**Unit + Integration Testing (Testing Pyramid complet)**

- **Unit Tests obligatoires** : Toute logique business (domain layer, use cases, calculs hydratation)
- **Widget Tests obligatoires** : Composants UI critiques (avatar states, photo validation, onboarding)
- **Integration Tests** : Flows critiques end-to-end (onboarding complet, validation photo → update avatar)
- **Pas de tests E2E automatisés** dans MVP (coût/temps), mais **tests manuels systématiques** avant chaque release
- **Coverage minimum** : 70% pour domain layer, 50% pour presentation layer
- **CI/CD** : Tests automatiques exécutés sur chaque commit (GitHub Actions)

**Rationale** : Tests obligatoires pour garantir qualité et éviter régressions, surtout pour logique core (streaks, avatar states, notifications). Testing pyramid équilibré adapté aux ressources limitées du MVP.

## Additional Technical Assumptions and Requests

- **Flutter packages requis** :
  - `camera` : Accès caméra frontale pour selfies
  - `flutter_local_notifications` : Notifications push locales
  - `permission_handler` : Gestion permissions (caméra, notifications, localisation optionnelle)
  - `shared_preferences` : Stockage settings simples
  - `sqflite` : Base de données locale SQLite
  - `firebase_core`, `firebase_auth`, `cloud_firestore` : Intégration Firebase
  - `flutter_secure_storage` : Stockage sécurisé tokens authentification
  - `riverpod` ou `flutter_bloc` : State management
  - `get_it` : Dependency injection

- **Permissions iOS/Android** :
  - Caméra frontale (obligatoire pour validation selfie)
  - Notifications push (obligatoire pour rappels)
  - Localisation (optionnelle pour météo V2, demandée en onboarding)

- **Notifications** :
  - Utilisation de notifications locales (pas de serveur push pour MVP)
  - Scheduling intelligent avec intervalles variables
  - Gestion du Do Not Disturb / Focus Mode iOS/Android
  - Pause automatique notifications nocturnes (22h-7h par défaut, personnalisable)

- **Sécurité et conformité** :
  - Authentification email/password + Apple Sign-In (iOS) + Google Sign-In (Android)
  - Stockage sécurisé des credentials avec `flutter_secure_storage`
  - HTTPS uniquement pour toutes communications API
  - Certificate pinning pour production
  - Privacy Policy et Terms of Service conformes RGPD
  - Analytics anonymisées (Firebase Analytics)

- **Déploiement** :
  - CI/CD via GitHub Actions (build, test, deploy)
  - Déploiement Apple App Store (TestFlight pour beta)
  - Déploiement Google Play Store (Internal/Beta tracks pour tests)
  - Versioning sémantique (MAJOR.MINOR.PATCH)

- **Contraintes techniques identifiées** :
  - Impossible de forcer plein écran non-dismissable pour notifications (limitations OS)
  - Impossible de bloquer autres apps ou changer fond d'écran automatiquement
  - Détection AI avancée photo (eau vs jus) reportée en V2 (coût/complexité)
  - Notifications fréquentes risquent désactivation par user → Équilibrage critique

---

[⬅️ UI/UX Design](ui-design.md) | [➡️ Epic List](epic-list.md)
