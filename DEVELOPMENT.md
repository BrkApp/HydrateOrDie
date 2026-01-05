# Guide de Développement - HydrateOrDie

## 📝 Génération de Code

L'application utilise plusieurs générateurs de code. Voici comment les utiliser :

### Première fois (après clone)

```bash
# 1. Installer les dépendances
flutter pub get

# 2. Générer tout le code
flutter pub run build_runner build --delete-conflicting-outputs
```

### Pendant le développement

```bash
# Mode watch (auto-génération à chaque changement)
flutter pub run build_runner watch --delete-conflicting-outputs
```

### Fichiers générés

Les générateurs créent automatiquement :

- `*.freezed.dart` - Classes immuables (Freezed)
- `*.g.dart` - Serialization JSON (json_serializable) + Adapters Hive
- `*.gr.dart` - Routes (si on utilise auto_route)

**Important** : Ces fichiers sont dans `.gitignore` et doivent être regénérés après chaque `git clone`.

## 🏗️ Architecture Clean

### Règles

1. **Domain** ne dépend de rien
2. **Data** dépend de Domain
3. **Presentation** dépend de Domain (et peut utiliser Data via DI)

### Flow de données

```
Presentation (UI)
    ↓ (appelle)
Provider/Notifier
    ↓ (utilise)
UseCase (Domain)
    ↓ (appelle)
Repository Interface (Domain)
    ↑ (implémente)
Repository Impl (Data)
    ↓ (utilise)
DataSource (Data)
```

## 📦 Ajout d'un nouveau modèle

1. Créer le fichier dans `lib/data/models/`
2. Ajouter les annotations Freezed + Hive
3. Générer le code
4. Enregistrer l'adapter dans `LocalStorage.init()`

### Exemple

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'my_model.freezed.dart';
part 'my_model.g.dart';

@freezed
@HiveType(typeId: 10) // Choisir un ID unique
class MyModel with _$MyModel {
  const factory MyModel({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
  }) = _MyModel;

  factory MyModel.fromJson(Map<String, dynamic> json) =>
      _$MyModelFromJson(json);
}
```

Puis dans `local_storage.dart` :

```dart
Hive.registerAdapter(MyModelAdapter());
```

## 🎨 Ajout d'un nouvel écran

1. Créer le dossier dans `lib/presentation/`
2. Créer le fichier `*_screen.dart`
3. Créer le provider Riverpod si nécessaire
4. Ajouter la route dans le routing

### Structure d'un écran

```dart
class MyScreen extends ConsumerWidget {
  const MyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Accéder au state via ref.watch()
    // Appeler des actions via ref.read()

    return Scaffold(
      appBar: AppBar(title: const Text('My Screen')),
      body: // ...
    );
  }
}
```

## 🔔 Notifications

### Structure

- `NotificationService` : Gère l'envoi des notifications
- `NotificationScheduler` : Gère la planification
- `NotificationMessages` : Contient tous les messages

### Tester les notifications

```dart
// Envoyer une notification immédiate
await NotificationService().sendNotification(
  title: 'Test',
  body: 'Message de test',
);
```

## 📸 Validation ML Kit

### Labels acceptés

Voir `AppConstants.acceptedLabels` :
- bottle, water bottle
- glass, cup, mug
- drink, beverage
- water

### Seuil de confiance

- Minimum : 0.7 (70%)
- Haute confiance : 0.85 (85%)

Configurable dans `AppSettings.mlConfidenceThreshold`

## 💾 Storage

### Hive Boxes

- `user_profile` : Profil utilisateur (singleton)
- `daily_progress` : Historique quotidien (key = 'YYYY-M-D')
- `notification_settings` : Paramètres notifs (singleton)
- `app_settings` : Paramètres app (singleton)

### Accès

```dart
final storage = LocalStorage();

// Lire
final profile = storage.getUserProfile();

// Écrire
await storage.saveUserProfile(profile);

// Stream (Riverpod)
final profileStream = storage.watchUserProfile();
```

## 🧪 Tests

### Structure

```
test/
├── unit/           # Tests unitaires
├── widget/         # Tests de widgets
└── integration/    # Tests d'intégration
```

### Commandes

```bash
# Tous les tests
flutter test

# Avec coverage
flutter test --coverage

# Un fichier spécifique
flutter test test/unit/models/user_profile_test.dart
```

## 🎨 Thèmes & UI

### Couleurs

Définies dans `AppTheme` :
- `primaryBlue` : #2196F3
- `waterBlue` : #4FC3F7
- `accentCyan` : #00BCD4

### Typographie

- **Titres** : Poppins (600-700)
- **Corps** : Inter (400-500)

### Animations

Utiliser `flutter_animate` :

```dart
Text('Hello')
  .animate()
  .fadeIn(duration: 300.ms)
  .slideY(begin: 0.3, end: 0);
```

## 🐛 Debug

### Logger

```dart
import 'package:logger/logger.dart';

final logger = Logger();

logger.d('Debug');
logger.i('Info');
logger.w('Warning');
logger.e('Error');
```

### Hive Browser

Pour voir le contenu de Hive en dev :

```dart
// Dans un bouton de debug
final data = await LocalStorage().exportData();
print(data);
```

## 📱 Build

### Android

```bash
# Debug
flutter build apk --debug

# Release
flutter build apk --release --split-per-abi
```

### iOS

```bash
# Ouvrir Xcode
open ios/Runner.xcworkspace

# Ou via CLI
flutter build ios --release
```

## 🔑 Variables d'environnement

À créer : `.env` (non versionné)

```env
REVENUECAT_API_KEY=your_key_here
```

## 🚀 Checklist avant commit

- [ ] `flutter analyze` sans erreurs
- [ ] `dart format lib/ -l 100`
- [ ] Code généré à jour
- [ ] Tests passent
- [ ] Pas de `print()` oubliés (utiliser `logger`)
- [ ] Documentation à jour

## 📚 Ressources

- [Flutter Docs](https://flutter.dev/docs)
- [Riverpod Docs](https://riverpod.dev)
- [Freezed Package](https://pub.dev/packages/freezed)
- [Hive Docs](https://docs.hivedb.dev)
- [ML Kit Docs](https://developers.google.com/ml-kit)
- [RevenueCat Docs](https://www.revenuecat.com/docs)

---

**Happy coding!** 💧
