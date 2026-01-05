# HydrateOrDie 💧

**Bois ou souffre** - Application de rappel d'hydratation punitif avec validation par ML Kit.

## 📱 Concept

HydrateOrDie est une application Flutter qui vous force à boire de l'eau régulièrement en utilisant un système de notifications progressivement agressif. La seule façon de stopper le spam de notifications ? Prouver que vous avez bu en prenant une photo validée par ML Kit !

### Features Principales

- ✅ **Onboarding personnalisé** : Objectif quotidien calculé selon poids/âge, horaires actives
- 📊 **Dashboard** : Progression circulaire, bouton caméra central, streak, messages punitifs/motivants
- 🔔 **Notifications intelligentes** :
  - Normales toutes les 45-60min
  - Mode spam toutes les 5min si pas bu
  - Intensité croissante jusqu'au mode agressif
  - Messages punitifs personnalisés
- 📸 **Validation photo (CORE)** :
  - Caméra → ML Kit détecte verre/bouteille
  - +250ml et stop du spam si validé
  - Message "Triche!" si non valide
- 💾 **Storage local** : Progression, streak, settings avec Hive
- 💎 **Premium** : RevenueCat paywall, thèmes et messages custom
- 🎨 **UI moderne** : Material 3, animations fluides, i18n FR/EN

## 🏗️ Architecture

```
lib/
├── core/
│   ├── config/           # Configuration app
│   ├── constants/        # Constantes et messages
│   ├── theme/           # Thèmes Material 3
│   └── utils/           # Utilities
├── data/
│   ├── models/          # Modèles Freezed + Hive
│   ├── repositories/    # Repositories
│   └── datasources/     # Local storage
├── domain/
│   ├── entities/        # Entities du domaine
│   ├── repositories/    # Interfaces repositories
│   └── usecases/        # Use cases
└── presentation/
    ├── onboarding/      # Écran onboarding
    ├── dashboard/       # Écran principal
    ├── camera/          # Caméra + validation ML
    ├── settings/        # Paramètres
    ├── paywall/         # RevenueCat paywall
    └── widgets/         # Widgets réutilisables
```

### Stack Technique

- **Flutter** : 3.27+
- **Dart** : 3.5+
- **State Management** : Riverpod
- **Storage** : Hive + SharedPreferences
- **ML** : Google ML Kit (Object Detection + Image Labeling)
- **Camera** : flutter camera
- **Notifications** : flutter_local_notifications + timezone
- **Premium** : RevenueCat (purchases_flutter)
- **UI** : Material 3, Google Fonts, flutter_animate
- **Code Gen** : Freezed, json_serializable, riverpod_generator

## 🚀 Getting Started

### Prérequis

- Flutter 3.27.0 ou supérieur
- Dart 3.5.0 ou supérieur
- Android SDK (API 26+)
- Xcode (pour iOS, version 13.0+)

### Installation

1. **Installer les dépendances**
```bash
flutter pub get
```

2. **Générer le code**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

3. **Lancer l'app**
```bash
flutter run
```

## 📋 Phases de Développement

### ✅ Phase 1 : Setup (TERMINÉ)
- [x] Architecture clean + structure
- [x] Configuration pubspec.yaml
- [x] Modèles de données (Freezed + Hive)
- [x] Système de storage local
- [x] Configuration et constantes
- [x] Thème Material 3
- [x] Main.dart avec routing basique
- [x] Configuration Android/iOS

### 📅 Phase 2 : UI Mockée (PROCHAINE)
- [ ] Écrans onboarding complets
- [ ] Dashboard avec progression
- [ ] Écran paramètres
- [ ] Navigation et routing
- [ ] Widgets réutilisables

### 📅 Phase 3 : Logique Business
- [ ] Calculs hydratation
- [ ] Système de notifications
- [ ] Scheduler intelligent
- [ ] Gestion du streak
- [ ] Intensité progressive

### 📅 Phase 4 : Caméra + ML Kit
- [ ] Intégration caméra
- [ ] ML Kit Object Detection
- [ ] ML Kit Image Labeling
- [ ] Validation des photos
- [ ] Messages de feedback

### 📅 Phase 5 : Premium + Polish
- [ ] Intégration RevenueCat
- [ ] Paywall design
- [ ] Tests finaux

## 🛠️ Commandes Utiles

```bash
# Générer le code
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode
flutter pub run build_runner watch --delete-conflicting-outputs

# Clean
flutter clean && flutter pub get
```

---

**Rappel** : Bois ou meurs. 💀💧