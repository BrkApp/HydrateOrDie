# Tech Stack - Hydrate or Die MVP

**Version:** 1.0
**Date:** 2026-01-07
**Owner:** Product Manager John
**Status:** APPROVED - Non modifiable sans validation PM

---

## 🎯 Objectif

Ce document définit la **stack technique complète** pour le MVP de Hydrate or Die. Toutes les décisions sont **justifiées** et alignées avec les contraintes du projet (budget bootstrap, solo dev, apprentissage Flutter).

---

## 📱 Frontend - Mobile Application

### Flutter 3.x (Stable Channel)

**Choix :** Framework cross-platform pour iOS et Android

**Justification :**
- ✅ **Une seule codebase** pour iOS + Android = réduction massive temps de dev
- ✅ **Performance native** via compilation AOT (Ahead-of-Time)
- ✅ **Hot reload** = itération rapide pendant développement
- ✅ **Ecosystem mature** : packages disponibles pour toutes nos features MVP
- ✅ **Courbe apprentissage** acceptable pour premier projet mobile
- ✅ **Gratuit** : pas de coûts de licensing

**Version :** Flutter 3.16+ (stable), Dart 3.2+

**Alternatives considérées :**
- ❌ React Native : Moins performant pour animations (avatar fluide critique)
- ❌ Native iOS/Android séparés : Double le temps de dev (intenable pour solo dev)
- ❌ PWA : Limitations permissions (caméra, notifications), pas d'App Store

---

### Language : Dart

**Choix :** Langage imposé par Flutter

**Avantages :**
- Type-safe (null safety depuis Dart 2.12)
- Syntaxe moderne et claire
- AOT compilation pour performance
- Async/await natif pour opérations asynchrones

---

## 🏗️ Architecture Pattern

### Clean Architecture (Uncle Bob)

**Choix :** Séparation stricte en 3 layers

**Structure :**
```
lib/
├── core/           # Constants, theme, utils, DI
├── data/           # Models, repositories impl, data sources
├── domain/         # Entities, repository interfaces, use cases
└── presentation/   # UI (screens, widgets), state management
```

**Justification :**
- ✅ **Testabilité** : Domain layer 100% indépendant (pure Dart, pas de dépendance Flutter)
- ✅ **Maintenabilité** : Changement DB ou UI n'impacte pas la logique métier
- ✅ **Scalabilité** : Structure claire pour ajout features V2/V3
- ✅ **Best practice Flutter** : Recommandé par la communauté

**Alternatives considérées :**
- ❌ MVC classique : Trop couplé, difficile à tester
- ❌ Architecture flat : Chaos garanti pour projet >10k lignes

---

## 🔄 State Management

### Riverpod 2.x

**Choix :** State management réactif et type-safe

**Justification :**
- ✅ **Compile-time safety** : Erreurs détectées à la compilation
- ✅ **Pas de BuildContext** requis pour accès state (moins verbeux que Provider)
- ✅ **Auto-dispose** : Pas de memory leaks
- ✅ **DevTools integration** : Debug facile
- ✅ **Recommended** : Créé par Remi Rousselet (expert Flutter)

**Alternatives considérées :**
- ✅ Bloc : Valide aussi, mais plus verbeux (boilerplate events/states)
- ❌ Provider : Ancêtre de Riverpod, moins performant
- ❌ GetX : Trop "magique", difficile à debug

**Décision finale :** Riverpod (mais Bloc acceptable si préférence dev)

---

## 🗄️ Backend & Database

### Firebase (Backend-as-a-Service)

**Choix :** Suite complète Google pour backend MVP

**Services utilisés :**

#### 1. Firebase Authentication
- Email/Password auth
- Apple Sign-In (iOS)
- Google Sign-In (Android)
- **Gratuit** jusqu'à 50k utilisateurs actifs/mois

#### 2. Cloud Firestore (NoSQL Database)
- Sync multi-devices temps réel
- Offline persistence automatique
- Queries puissantes avec indexes
- **Gratuit** : 1GB storage, 50k reads/day, 20k writes/day

#### 3. Firebase Storage
- Stockage photos selfies (backup cloud optionnel)
- Compression automatique
- **Gratuit** : 5GB storage, 1GB download/day

#### 4. Cloud Functions
- Serverless backend pour tâches scheduled (résurrection avatar minuit)
- Triggers automatiques
- **Gratuit** : 2M invocations/mois

#### 5. Firebase Analytics
- Tracking events (hydration_validated, notification_sent, etc.)
- Crash reporting via Crashlytics
- **Gratuit** : Unlimited

**Justification Firebase :**
- ✅ **Spark Plan gratuit** = 0€ jusqu'à traction significative
- ✅ **Setup rapide** via FlutterFire CLI (<30min)
- ✅ **Scalabilité automatique** (pas de gestion serveurs)
- ✅ **SDKs Flutter officiels** bien maintenus
- ✅ **Monitoring intégré** (Analytics, Crashlytics)

**Alternatives considérées :**
- ❌ Supabase : Excellent mais moins mature Flutter SDK, nécessite gestion PostgreSQL
- ❌ Custom backend (Node/Express) : Trop de temps dev pour MVP solo
- ❌ AWS Amplify : Complexité setup excessive pour MVP

---

### SQLite (Local Database)

**Choix :** Base de données locale embarquée via sqflite package

**Usage :**
- Stockage offline des données critiques (profil, avatar state, historique hydratation)
- Fallback si Firebase indisponible
- Performance requêtes locales rapides

**Justification :**
- ✅ **Offline-first** : App fonctionnelle sans réseau
- ✅ **Gratuit** : Inclus dans Flutter
- ✅ **Léger** : Pas d'overhead serveur

**Sync strategy :** SQLite (source de vérité locale) ↔ Firestore (backup + multi-device sync)

---

## 🎨 UI/UX Framework

### Material Design 3 (Flutter Material)

**Choix :** Design system officiel Flutter

**Justification :**
- ✅ Widgets prêts à l'emploi (buttons, cards, dialogs)
- ✅ Thème customisable (couleurs, fonts, spacing)
- ✅ Accessibilité WCAG AA intégrée
- ✅ Support dark mode natif (V2 feature)

**Custom Design System :**
- Palette couleurs custom (bleu hydratation, orange/rouge urgence)
- Typographie lisible (senior-friendly)
- Composants réutilisables dans `lib/presentation/widgets/`

---

## 📦 Key Packages (Dependencies)

### Obligatoires MVP

| Package | Version | Usage |
|---------|---------|-------|
| `camera` | ^0.10.5 | Accès caméra frontale pour selfies |
| `flutter_local_notifications` | ^16.3.0 | Notifications push locales |
| `permission_handler` | ^11.0.1 | Gestion permissions (caméra, notifications, location) |
| `shared_preferences` | ^2.2.2 | Stockage key-value simple (settings) |
| `sqflite` | ^2.3.0 | Base de données SQLite locale |
| `firebase_core` | ^2.24.0 | Firebase initialization |
| `firebase_auth` | ^4.15.0 | Authentication |
| `cloud_firestore` | ^4.13.0 | Firestore database |
| `firebase_storage` | ^11.5.0 | Cloud storage photos |
| `firebase_analytics` | ^10.7.0 | Analytics events |
| `flutter_riverpod` | ^2.4.9 | State management |
| `get_it` | ^7.6.4 | Dependency injection |
| `flutter_secure_storage` | ^9.0.0 | Stockage sécurisé tokens auth |
| `intl` | ^0.18.1 | Internationalization (dates, formats) |

### Utilitaires Dev

| Package | Version | Usage |
|---------|---------|-------|
| `flutter_launcher_icons` | ^0.13.1 | Génération icons app |
| `flutter_lints` | ^3.0.1 | Linting Dart/Flutter |
| `mocktail` | ^1.0.1 | Mocking pour tests unitaires |
| `integration_test` | SDK | Tests d'intégration Flutter |

### Optionnels (V2)

- `health` : Apple HealthKit / Google Fit integration
- `geolocator` : Localisation précise pour météo
- `lottie` : Animations JSON complexes avatars

---

## 🧪 Testing Stack

### Unit Tests
- **Framework :** `flutter_test` (inclus SDK)
- **Mocking :** `mocktail`
- **Coverage minimum :** Domain 80%, Data 70%

### Widget Tests
- **Framework :** `flutter_test`
- **Coverage minimum :** Presentation 50% (focus écrans critiques)

### Integration Tests
- **Framework :** `integration_test` package
- **Scope :** Flows critiques (onboarding, validation photo, streak)

### Test Execution
- **Local :** `flutter test --coverage`
- **CI/CD :** GitHub Actions (run on every commit)

---

## 🚀 CI/CD & DevOps

### Version Control
- **Git** : Repository GitHub
- **Branching :** GitFlow (main, develop, feature branches)
- **Commits :** Format `[EPIC-X.Y] Description` (voir governance.md)

### CI/CD Pipeline
- **Platform :** GitHub Actions
- **Workflow file :** `.github/workflows/ci.yml`
- **Triggers :** Push sur toutes branches, PR vers develop

**CI Steps :**
1. Checkout code
2. Setup Flutter (stable channel)
3. `flutter pub get`
4. `flutter analyze` (0 errors/warnings requis)
5. `flutter test --coverage`
6. Upload coverage report (Codecov optionnel)
7. `flutter build apk --debug` (Android)
8. `flutter build ios --debug --no-codesign` (iOS)

### Deployment
- **Android :** Google Play Store (Internal/Beta/Production tracks)
- **iOS :** App Store Connect (TestFlight → Production)
- **Versioning :** Semantic versioning (MAJOR.MINOR.PATCH)

---

## 🔐 Security & Compliance

### Authentication
- **Firebase Auth** : Email/password + OAuth (Apple, Google)
- **Token storage :** `flutter_secure_storage` (encrypted keychain iOS, EncryptedSharedPreferences Android)

### Data Security
- **HTTPS only** : Toutes communications API
- **Certificate pinning** : Production (via Firebase)
- **Local encryption :** SQLite with `sqflite_sqlcipher` (V2 si nécessaire)

### RGPD Compliance
- **Privacy Policy** : Document séparé (templates disponibles)
- **Consent management** : Checkbox explicite onboarding
- **Data deletion** : Feature "Supprimer mon compte" (supprime SQLite local + Firestore cloud)
- **Data minimization** : Collecte uniquement données nécessaires (poids, âge, sexe, activité)

---

## 📊 Monitoring & Analytics

### Crash Reporting
- **Firebase Crashlytics** : Automatic crash reports
- **Stack traces** : Symbolicated pour debug

### Analytics Events
- **Firebase Analytics** : Custom events
  - `hydration_validated`
  - `notification_sent`
  - `streak_milestone`
  - `avatar_selected`
  - etc.

### Performance Monitoring
- **Firebase Performance Monitoring** : App startup time, screen render time

---

## 💰 Cost Analysis (MVP)

| Service | Plan | Cost |
|---------|------|------|
| Flutter | Open Source | **0€** |
| Firebase Spark | Free tier | **0€** (jusqu'à 10k MAU) |
| GitHub | Free | **0€** |
| GitHub Actions | Free tier | **0€** (2000 min/mois) |
| Apple Developer | Yearly | **99€/an** (obligatoire iOS) |
| Google Play | One-time | **25€** (obligatoire Android) |
| **TOTAL YEAR 1** | | **~124€** |

**Scaling costs (si succès) :**
- Firebase Blaze (pay-as-you-go) : ~50-200€/mois pour 50k-100k MAU
- CI/CD : Peut nécessiter plan payant si builds fréquents

---

## 🔄 Migration Path (Post-MVP)

### Si croissance forte (100k+ users) :
- **Option 1 :** Rester Firebase Blaze (scale automatique, coût ~500-1000€/mois)
- **Option 2 :** Migrer vers backend custom (Node.js + PostgreSQL) pour réduire coûts

### Si pivot nécessaire :
- Clean Architecture facilite changement DB (Firestore → Supabase → PostgreSQL)
- Repository pattern = abstraction complète

---

## ✅ Validation Checklist Tech Stack

- [x] Cross-platform mobile (iOS + Android) : **Flutter ✅**
- [x] Budget bootstrap (<200€ year 1) : **124€ ✅**
- [x] Offline-first : **SQLite + Firestore ✅**
- [x] Scalable : **Firebase auto-scale ✅**
- [x] Testable : **Clean Architecture ✅**
- [x] RGPD compliant : **Data deletion + consent ✅**
- [x] Apprentissage faisable solo : **Flutter docs + FlutterFire ✅**
- [x] CI/CD gratuit : **GitHub Actions ✅**

---

## 📚 Learning Resources

### Flutter
- Official Docs : https://docs.flutter.dev/
- Codelabs : https://docs.flutter.dev/codelabs
- Widget Catalog : https://docs.flutter.dev/ui/widgets

### Firebase
- FlutterFire : https://firebase.flutter.dev/
- Firebase Docs : https://firebase.google.com/docs

### Clean Architecture
- Blog Reso Coder : https://resocoder.com/flutter-clean-architecture-tdd/

---

*Document créé le 2026-01-07 par PM John*
*Stack validée et figée pour MVP - Modifications nécessitent validation PM*
