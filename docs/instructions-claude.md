# Instructions pour Claude Code - Guide de Développement

**Version:** 1.0
**Date:** 2026-01-07
**Audience:** Agents Claude Code (Dev)
**Status:** MANDATORY - Instructions obligatoires pour tous agents dev

---

## 🎯 Objectif de ce Document

Ce document fournit les **règles de style, comportement et workflow** que TOUS les agents Claude Code DOIVENT suivre lors du développement de Hydrate or Die.

**Ces instructions complètent et renforcent :**
- `docs/governance.md` (règles projet)
- `docs/definition-of-done.md` (checklist validation)
- `docs/tech-stack.md` (technologies)
- `docs/system-architecture.md` (architecture)

---

## 📚 Documents Obligatoires à Lire AVANT Tout Développement

Avant de commencer UNE story, l'agent dev DOIT lire :

1. **`docs/governance.md`** → Règles NON NÉGOCIABLES du projet
2. **`docs/definition-of-done.md`** → Checklist validation story
3. **`docs/tech-stack.md`** → Stack technique figée
4. **`docs/system-architecture.md`** → Architecture globale
5. **`docs/stories/epic-X/story-X.Y-name.md`** → Story assignée
6. **`docs/contracts/`** → Contrats d'interface (créés par Architect)

**Si un de ces documents n'existe pas → BLOQUER et demander au PM.**

---

## 🚦 Workflow de Développement

### Phase 1 : Lecture & Compréhension

1. **Lire la story assignée** dans `docs/stories/epic-X/story-X.Y-name.md`
2. **Vérifier les dépendances** : Les stories dont je dépends sont-elles "Done" ?
   - Si NON → BLOQUER et signaler au PM
3. **Lire les contrats d'interface** dans `docs/contracts/` pour les composants à créer
4. **Poser des questions** au PM si :
   - Acceptance criteria ambigus
   - Contrats d'interface manquants ou incomplets
   - Dépendances bloquantes

**Ne JAMAIS deviner ou improviser. Toujours clarifier avec PM.**

---

### Phase 2 : Planification Technique

1. **Lister les fichiers à créer/modifier** :
   - Préciser chemin exact (ex: `lib/domain/use_cases/calculate_hydration_goal_use_case.dart`)
   - Vérifier conformité avec structure dans `system-architecture.md`

2. **Identifier les tests requis** :
   - Unit tests : Quels fichiers ? (ex: `test/domain/use_cases/calculate_hydration_goal_use_case_test.dart`)
   - Widget tests : Si story UI (ex: `test/presentation/screens/home_screen_test.dart`)
   - Integration tests : Si story flow critique

3. **Vérifier les packages nécessaires** :
   - Tous listés dans `tech-stack.md` ?
   - Si nouveau package requis → **STOP et demander validation PM**

4. **Créer un plan d'exécution** :
   - Ordre de création fichiers (models → repos → use cases → UI)
   - Checkpoints de validation intermédiaires

---

### Phase 3 : Implémentation

**Suivre STRICTEMENT cet ordre :**

1. **Data Models** (si nécessaire)
   - Créer dans `lib/data/models/`
   - Implémenter `toJson()` / `fromJson()`
   - Écrire tests unitaires IMMÉDIATEMENT

2. **Repository Interfaces** (si nécessaire)
   - Créer dans `lib/domain/repositories/`
   - Définir signature méthodes (params, return types)

3. **Repository Implementations**
   - Créer dans `lib/data/repositories/`
   - Implémenter local + remote data sources si applicable
   - Écrire tests unitaires + integration tests

4. **Use Cases**
   - Créer dans `lib/domain/use_cases/`
   - Pure business logic, pas de dépendances Flutter
   - Écrire tests unitaires avec coverage 80%+

5. **UI (Screens/Widgets)**
   - Créer dans `lib/presentation/screens/` ou `/widgets/`
   - Utiliser Riverpod pour state management
   - Écrire widget tests

6. **Providers (State Management)**
   - Créer dans `lib/presentation/providers/`
   - Connecter UI avec use cases
   - Tester réactivité

**À CHAQUE étape :**
- Exécuter `flutter analyze` → 0 errors/warnings
- Exécuter `flutter test` → Tous tests passent
- Commiter si étape complète (commit atomique)

---

### Phase 4 : Testing & Validation

1. **Exécuter suite de tests complète** :
   ```bash
   flutter test --coverage
   ```
   - Vérifier coverage minimum (Domain 80%, Data 70%, Presentation 50%)
   - Si <minimum → Ajouter tests jusqu'à atteinte

2. **Build iOS + Android** :
   ```bash
   flutter build ios --debug --no-codesign
   flutter build apk --debug
   ```
   - Les deux DOIVENT passer sans erreurs

3. **Test manuel** :
   - Lancer app sur simulateur iOS
   - Lancer app sur émulateur Android
   - Tester happy path + edge cases de la story

4. **Prendre screenshots** (si story UI) :
   - Screenshots avant/après
   - Inclure dans PR description

---

### Phase 5 : Review & Soumission

1. **Auto-review avec Definition of Done** :
   - Parcourir `docs/definition-of-done.md`
   - Remplir TOUS les items de la checklist
   - Produire un report (voir template dans DoD)

2. **Créer PR** :
   - Branch : `feature/epic-X-story-Y-description`
   - Titre : `[EPIC-X.Y] Story title`
   - Description : AC complétés, screenshots, notes
   - Lien vers story : `docs/stories/epic-X/story-X.Y-name.md`

3. **Soumettre au PM** :
   - Report DoD complet
   - PR créée et prête à review
   - Attendre validation PM avant merge

---

## 🎨 Règles de Style & Conventions de Code

### Naming Conventions (STRICT)

#### Classes
```dart
// PascalCase
class UserProfile { }
class HydrationLogRepository { }
class CalculateHydrationGoalUseCase { }
```

#### Variables & Functions
```dart
// camelCase
final userName = 'John';
void calculateGoal() { }
Future<void> fetchData() async { }
```

#### Constants
```dart
// lowerCamelCase with 'k' prefix
const kDefaultGoalLiters = 2.5;
const kMaxNotificationsPerDay = 50;
const kAvatarStateTransitionDuration = Duration(seconds: 10);
```

#### Private Members
```dart
// Underscore prefix
String _privateVariable = 'value';
void _privateMethod() { }
```

#### Files
```dart
// snake_case
// user_profile.dart
// hydration_log_repository.dart
// calculate_hydration_goal_use_case.dart
```

---

### Code Organization

#### Imports Order
```dart
// 1. Dart SDK
import 'dart:async';
import 'dart:io';

// 2. Flutter
import 'package:flutter/material.dart';

// 3. External packages (alphabétique)
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

// 4. Internal (relative imports)
import '../../domain/entities/user.dart';
import '../models/user_profile_model.dart';
```

#### Class Structure
```dart
class MyClass {
  // 1. Constants
  static const kConstant = 'value';

  // 2. Fields (public)
  final String publicField;

  // 3. Fields (private)
  final String _privateField;

  // 4. Constructor
  MyClass({required this.publicField, required String privateField})
      : _privateField = privateField;

  // 5. Named constructors
  MyClass.empty() : publicField = '', _privateField = '';

  // 6. Factory constructors
  factory MyClass.fromJson(Map<String, dynamic> json) { }

  // 7. Getters/Setters
  String get privateField => _privateField;

  // 8. Public methods
  void publicMethod() { }

  // 9. Private methods
  void _privateMethod() { }

  // 10. Overrides
  @override
  String toString() => 'MyClass(publicField: $publicField)';
}
```

---

### Documentation (Dartdoc)

**OBLIGATOIRE pour toutes classes/méthodes publiques.**

```dart
/// Calculates the daily hydration goal based on user profile.
///
/// The algorithm uses weight, age, gender, and activity level to compute
/// a personalized hydration target in liters per day.
///
/// Formula:
/// - Base = weight (kg) × 0.033 liters
/// - Activity multiplier: Sedentary (1.0) to ExtremelyActive (1.5)
/// - Gender adjustment: Female (0.95), Male (1.0)
/// - Age adjustment: <30 (1.0), 30-55 (0.95), >55 (0.9)
///
/// Returns a [double] representing liters per day, bounded between 1.5L and 5.0L.
///
/// Throws [ArgumentError] if [userProfile] is incomplete (missing required fields).
///
/// Example:
/// ```dart
/// final useCase = CalculateHydrationGoalUseCase();
/// final goal = useCase.execute(userProfile); // Returns 2.5
/// ```
class CalculateHydrationGoalUseCase {
  /// Executes the hydration goal calculation.
  ///
  /// [userProfile] must have all required fields populated.
  double execute(UserProfile userProfile) {
    // Implementation
  }
}
```

**Format obligatoire :**
- Description courte (1 phrase)
- Détails algorithme/comportement si complexe
- Params documentés avec `[paramName]`
- Return value documenté
- Exceptions documentées avec `Throws`
- Exemple d'usage si pertinent

---

### Error Handling

#### Try-Catch Obligatoires

**Toutes opérations async DOIVENT être wrappées en try-catch.**

```dart
Future<void> saveProfile(UserProfile profile) async {
  try {
    await _localDataSource.saveProfile(profile);
    await _remoteDataSource.saveProfile(profile);
  } on DatabaseException catch (e, stackTrace) {
    print('Error saving profile to DB: $e');
    print('StackTrace: $stackTrace');
    // Rethrow ou gérer selon logique métier
    rethrow;
  } on FirebaseException catch (e, stackTrace) {
    print('Error syncing profile to Firestore: $e');
    // Continue - offline OK
  } catch (e, stackTrace) {
    print('Unexpected error saving profile: $e');
    print('StackTrace: $stackTrace');
    rethrow;
  }
}
```

**Règles :**
- ✅ Catch exceptions spécifiques en premier (DatabaseException, FirebaseException)
- ✅ Catch générique en dernier (catch-all)
- ✅ Log erreur avec contexte (print ou logger)
- ✅ Include stack trace pour debug
- ✅ Décider : rethrow ou handle (selon logique métier)

---

#### User-Facing Errors

**Jamais afficher erreurs techniques brutes à l'user.**

❌ **BAD :**
```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text('DatabaseException: UNIQUE constraint failed')),
);
```

✅ **GOOD :**
```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('Impossible de sauvegarder. Vérifie ton stockage.'),
    action: SnackBarAction(label: 'Réessayer', onPressed: () => retry()),
  ),
);
```

**Messages user-friendly :**
- Clair et actionnable
- Pas de jargon technique
- Bouton action si possible (Réessayer, Ouvrir Paramètres)

---

### Null Safety

**Dart 3+ est null-safe. Utiliser correctement.**

```dart
// Variables non-nullable (défaut)
String name = 'John';          // DOIT être initialisé
final int age;                 // DOIT être assigné avant usage

// Variables nullable (?)
String? optionalName;          // Peut être null
final int? optionalAge = null; // OK

// Accès sécurisé
print(optionalName?.length);   // Safe navigation
print(optionalName ?? 'Guest'); // Null-aware operator

// Null assertion (! - ÉVITER si possible)
print(optionalName!.length);   // Crash si null - utiliser avec prudence
```

**Préférer :**
- `?.` pour safe navigation
- `??` pour valeur par défaut
- Éviter `!` sauf certitude absolue (après check if != null)

---

### Async/Await

**Style async/await préféré vs .then() callbacks.**

✅ **GOOD :**
```dart
Future<void> loadData() async {
  try {
    final profile = await repository.getProfile();
    final goal = await calculateGoal(profile);
    setState(() => _goal = goal);
  } catch (e) {
    handleError(e);
  }
}
```

❌ **BAD :**
```dart
Future<void> loadData() {
  return repository.getProfile().then((profile) {
    return calculateGoal(profile);
  }).then((goal) {
    setState(() => _goal = goal);
  }).catchError((e) {
    handleError(e);
  });
}
```

---

## 🧪 Testing Guidelines

### Unit Tests

**Obligatoires pour :**
- Use cases (100% coverage requis)
- Models (toJson, fromJson, validation)
- Repositories (mock dependencies)
- Logique calcul (goals, streaks, etc.)

**Structure :**
```dart
// test/domain/use_cases/calculate_hydration_goal_use_case_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  group('CalculateHydrationGoalUseCase', () {
    late CalculateHydrationGoalUseCase useCase;

    setUp(() {
      useCase = CalculateHydrationGoalUseCase();
    });

    test('should calculate correct goal for 75kg male sedentary 30yo', () {
      // Arrange
      final profile = UserProfile(
        weight: 75.0,
        age: 30,
        gender: Gender.male,
        activityLevel: ActivityLevel.sedentary,
      );

      // Act
      final result = useCase.execute(profile);

      // Assert
      expect(result, closeTo(2.5, 0.1)); // ±0.1L tolerance
    });

    test('should apply activity multiplier correctly', () {
      // ...
    });

    test('should enforce minimum goal of 1.5L', () {
      // ...
    });

    test('should enforce maximum goal of 5.0L', () {
      // ...
    });

    test('should throw ArgumentError if profile incomplete', () {
      // ...
    });
  });
}
```

**Conventions :**
- `group()` pour grouper tests liés
- `test()` pour chaque cas
- Structure Arrange-Act-Assert (AAA)
- Noms de tests descriptifs (comportement attendu)

---

### Widget Tests

**Obligatoires pour :**
- Screens principaux (HomeScreen, OnboardingScreens, etc.)
- Widgets réutilisables (AvatarDisplay, StreakDisplay, etc.)

**Structure :**
```dart
// test/presentation/screens/home_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('HomeScreen displays avatar and drink button', (tester) async {
    // Arrange
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: HomeScreen()),
      ),
    );

    // Act
    await tester.pumpAndSettle(); // Wait animations

    // Assert
    expect(find.byType(AvatarDisplay), findsOneWidget);
    expect(find.text('Je bois'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('Tapping drink button navigates to PhotoValidationScreen', (tester) async {
    // ...
  });
}
```

---

### Integration Tests

**Obligatoires pour :**
- Flows critiques (onboarding complet, validation photo → update avatar)

**Structure :**
```dart
// integration_test/onboarding_flow_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Complete onboarding flow saves profile', (tester) async {
    // Launch app
    // Navigate through 5 onboarding screens
    // Fill forms
    // Submit
    // Verify profile saved in SQLite
    // Verify navigation to HomeScreen
  });
}
```

---

## 📝 Git Commit Guidelines

### Branch Naming

**Format :** `feature/epic-X-story-Y-short-description`

**Exemples :**
```
feature/epic-1-story-1-project-setup
feature/epic-1-story-2-avatar-models
feature/epic-3-story-4-photo-capture
```

---

### Commit Messages

**Format :** `[EPIC-X.Y] Clear description of change`

**Exemples :**
```
[EPIC-1.1] Initialize Flutter project with Clean Architecture
[EPIC-1.2] Add Avatar and AvatarState models with serialization
[EPIC-1.3] Implement AvatarRepository with SQLite persistence
[EPIC-3.4] Add photo capture with camera package
```

**Règles :**
- Préfixe obligatoire `[EPIC-X.Y]`
- Description claire (verbe action : Add, Implement, Fix, Update, Refactor)
- Ligne <72 caractères si possible
- Pas de point final

---

### Commit Frequency

**Commits atomiques :** 1 changement logique = 1 commit

✅ **GOOD :**
```
[EPIC-2.1] Add UserProfile model with validation
[EPIC-2.1] Add UserProfile toJson/fromJson methods
[EPIC-2.1] Add UserProfile unit tests
```

❌ **BAD :**
```
[EPIC-2.1] Add UserProfile model, tests, repo, and UI
(Trop de changements en 1 commit)
```

---

## 🚫 Anti-Patterns à Éviter ABSOLUMENT

### ❌ Code Commenté Laissé

```dart
// BAD
void calculateGoal() {
  // Old implementation:
  // return weight * 0.035;

  return weight * 0.033; // New formula
}
```

**Supprimer le code mort. Git garde l'historique.**

---

### ❌ TODO/FIXME Non Résolus

```dart
// BAD
void saveData() {
  // TODO: Add error handling
  database.save(data);
}
```

**Si TODO nécessaire → Créer une story pour le tracking. Pas de TODO inline dans code livré.**

---

### ❌ Magic Numbers

```dart
// BAD
if (duration > 7200) { // 7200 quoi ?
  escalate();
}

// GOOD
const kTwoHoursInSeconds = 7200;
if (duration > kTwoHoursInSeconds) {
  escalate();
}
```

---

### ❌ God Classes

```dart
// BAD - Une classe qui fait TOUT
class HydrationManager {
  void calculateGoal() { }
  void saveProfile() { }
  void takePhoto() { }
  void scheduleNotifications() { }
  void updateAvatar() { }
  // ... 50 méthodes
}
```

**Respecter Single Responsibility Principle (SRP) - 1 classe = 1 responsabilité.**

---

### ❌ Nested Callbacks (Callback Hell)

```dart
// BAD
getProfile().then((profile) {
  calculateGoal(profile).then((goal) {
    saveGoal(goal).then((result) {
      updateUI(result);
    });
  });
});

// GOOD - async/await
final profile = await getProfile();
final goal = await calculateGoal(profile);
final result = await saveGoal(goal);
updateUI(result);
```

---

## 🔧 Dependency Injection

**Utiliser `get_it` pour DI.**

### Setup (lib/core/di/injection.dart)

```dart
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Data Sources
  getIt.registerLazySingleton<AvatarLocalDataSource>(
    () => AvatarLocalDataSourceImpl(),
  );

  // Repositories
  getIt.registerLazySingleton<AvatarRepository>(
    () => AvatarRepositoryImpl(
      localDataSource: getIt<AvatarLocalDataSource>(),
    ),
  );

  // Use Cases
  getIt.registerFactory<UpdateAvatarStateUseCase>(
    () => UpdateAvatarStateUseCase(
      repository: getIt<AvatarRepository>(),
    ),
  );
}
```

### Usage

```dart
// Dans un widget ou provider
final useCase = getIt<UpdateAvatarStateUseCase>();
final result = await useCase.execute();
```

---

## 📱 Platform-Specific Code

**Minimiser le code spécifique plateforme.**

Si vraiment nécessaire :

```dart
import 'dart:io' show Platform;

void platformSpecificLogic() {
  if (Platform.isIOS) {
    // iOS-specific
  } else if (Platform.isAndroid) {
    // Android-specific
  }
}
```

**Préférer packages qui abstraient les différences (ex: `permission_handler`).**

---

## 🎭 State Management avec Riverpod

### Provider Definition

```dart
// lib/presentation/providers/avatar_state_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

final avatarStateProvider = StateNotifierProvider<AvatarStateNotifier, AvatarState>((ref) {
  final useCase = ref.watch(updateAvatarStateUseCaseProvider);
  return AvatarStateNotifier(useCase);
});

class AvatarStateNotifier extends StateNotifier<AvatarState> {
  final UpdateAvatarStateUseCase _useCase;

  AvatarStateNotifier(this._useCase) : super(AvatarState.fresh()) {
    _init();
  }

  Future<void> _init() async {
    final newState = await _useCase.execute();
    state = newState;
  }

  Future<void> refresh() async {
    final newState = await _useCase.execute();
    state = newState;
  }
}
```

### Usage in Widget

```dart
class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatarState = ref.watch(avatarStateProvider);

    return Scaffold(
      body: AvatarDisplay(state: avatarState),
    );
  }
}
```

---

## 🔍 Code Review Self-Checklist

Avant de soumettre PR, vérifier :

- [ ] `flutter analyze` : 0 errors/warnings
- [ ] `flutter test` : Tous tests passent
- [ ] Coverage minimum atteint (voir governance.md)
- [ ] Dartdoc présent pour classes/méthodes publiques
- [ ] Pas de code commenté
- [ ] Pas de TODO/FIXME non résolus
- [ ] Constants utilisées (pas de magic numbers)
- [ ] Error handling complet (try-catch)
- [ ] Commits atomiques avec bons messages
- [ ] Branch nommée correctement
- [ ] Definition of Done complète (voir docs/definition-of-done.md)

---

## 💡 Conseils Pro

### Performance

- Utiliser `const` constructors pour widgets immutables
- Éviter rebuild inutiles (const, memo, keys)
- Async ops en background (isolates si calculs lourds)

### Debugging

- Utiliser Flutter DevTools
- `print()` pour logs debug (remplacer par logger package en prod)
- Breakpoints dans IDE

### Learning Resources

- Flutter Docs : https://docs.flutter.dev/
- Riverpod Docs : https://riverpod.dev/
- Effective Dart : https://dart.dev/guides/language/effective-dart

---

## 📞 Support & Questions

**Si bloqué :**
1. Relire la story et les contrats d'interface
2. Relire governance.md et architecture.md
3. Poser question au PM (ne jamais deviner)

**PM Contact :** Product Manager John (via chat)

---

*Document créé le 2026-01-07 par PM John*
*Instructions MANDATORY pour tous agents Claude Code développant Hydrate or Die*
