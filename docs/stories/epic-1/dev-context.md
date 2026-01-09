# Epic 1 - Dev Context (État Actuel du Développement)

> **Objectif:** Ce fichier maintient le contexte de développement pour tous les agents @dev travaillant sur Epic 1. Il est mis à jour après chaque story complétée pour éviter les duplications et assurer la cohérence.

**Dernière mise à jour:** 2026-01-08 (après Story 1.3)

---

## 📊 Vue d'Ensemble Epic 1

**Epic:** Foundation & Avatar Core System
**Progression:** 3/8 stories complétées (37.5%)

```
✅ Story 1.1 - Flutter Setup + CI/CD
✅ Story 1.2 - Domain Models (10 entities)
✅ Story 1.3 - Avatar Repository (SQLite + DTOs)
⏳ Story 1.4 - Avatar Assets (PROCHAINE)
⏳ Story 1.5 - Dehydration Logic
⏳ Story 1.6 - Home Screen
⏳ Story 1.7 - Ghost System
⏳ Story 1.8 - Avatar Selection
```

---

## ✅ Story 1.1 - Flutter Setup + CI/CD

### Fichiers Clés Créés
```
lib/main.dart                          - Entry point avec ProviderScope + Firebase init
lib/firebase_options.dart              - Config Firebase MOCK
.github/workflows/ci.yml               - Pipeline CI/CD (build + test + analyze)
pubspec.yaml                           - 19 dépendances MVP configurées
test/widget_test.dart                  - 3 tests widget de base
```

### Structure Créée
```
lib/
├── core/           - Constants, theme, utils (vide pour l'instant)
├── domain/         - Entities, repositories, use_cases
├── data/           - Models, repositories impl, data_sources
└── presentation/   - Providers, screens, widgets, navigation
```

### Technologies Configurées
- **State Management:** Riverpod (ProviderScope dans main.dart)
- **Database:** sqflite + path_provider
- **Firebase:** firebase_core, firebase_auth, firebase_analytics, cloud_firestore (MODE MOCK)
- **Camera:** camera, image_picker
- **Notifications:** flutter_local_notifications
- **Storage:** shared_preferences
- **Testing:** mockito, build_runner

### À Savoir pour la Suite
- ✅ Firebase en mode MOCK (firebase_options.dart avec config bidon)
- ✅ Riverpod configuré globalement (ProviderScope wrapping MyApp)
- ✅ CI/CD pipeline teste automatiquement chaque commit
- ✅ Canary screen "Hydrate or Die - Coming Soon" s'affiche au lancement
- ⚠️ Ne pas réinitialiser Firebase, c'est déjà fait dans main.dart
- ⚠️ Ne pas recréer pubspec.yaml, toutes les deps MVP sont déjà là

### Commandes Validées
```bash
flutter test           # 3/3 tests passent ✅
flutter analyze        # 0 issues ✅
flutter run            # Lance app avec canary screen ✅
```

---

## ✅ Story 1.2 - Domain Models (10 Entities)

### Fichiers Clés Créés
```
lib/domain/entities/
├── gender.dart                 - Enum Gender (male, female, other)
├── activity_level.dart         - Enum ActivityLevel (sedentary → extreme)
├── avatar_personality.dart     - Enum AvatarPersonality (4 types)
├── avatar_state.dart           - Enum AvatarState (5 états)
├── glass_size.dart             - Enum GlassSize (small, medium, large)
├── hydration_goal.dart         - Value Object HydrationGoal
├── avatar.dart                 - Entity Avatar
├── user.dart                   - Entity User
├── hydration_log.dart          - Entity HydrationLog
└── streak.dart                 - Entity Streak

test/domain/entities/
├── avatar_personality_test.dart
├── avatar_state_test.dart
├── avatar_test.dart
├── glass_size_test.dart
├── hydration_goal_test.dart
├── hydration_log_test.dart
├── streak_test.dart
└── user_test.dart
```

### Concepts Métier Importants

#### **4 Avatars (AvatarPersonality)**
```dart
enum AvatarPersonality {
  doctor,      // 🧑‍⚕️ Docteur (ton professionnel)
  coach,       // 💪 Coach sportif (ton motivant)
  mother,      // 👩 Mère autoritaire (ton maternel/strict)
  friend       // 🤝 Pote (ton décontracté)
}
```

#### **5 États Avatar (AvatarState)**
```dart
enum AvatarState {
  fresh,                    // 😊 75-100% hydratation (vert)
  slightlyDehydrated,       // 😐 50-74% hydratation (jaune)
  dehydrated,               // 😟 25-49% hydratation (orange)
  dead,                     // 💀 0-24% hydratation (rouge)
  ghost                     // 👻 État fantôme après mort
}
```

**Transitions d'état:**
- `getNextState(currentHydration)` - Calcule le prochain état selon %
- `shouldDie(currentHydration)` - Retourne true si < 25%

#### **Calcul Objectif Hydratation (HydrationGoal)**
```dart
// Formule: baseAmount (selon poids) + ajustements (âge, activité, température, altitude)
// Exemple: Homme 75kg, 30 ans, actif → ~2500ml/jour
```

### À Savoir pour la Suite
- ✅ Toutes les entities utilisent **Equatable** (comparaison par valeur)
- ✅ Toutes les entities sont **immutables** (final properties, copyWith())
- ✅ Dartdoc complet sur toutes les classes
- ✅ Null-safety total (pas de null! sauf où explicite)
- ✅ 100% coverage tests Domain Layer (109 tests)
- ⚠️ **NE PAS MODIFIER ces entities** - Elles sont le contrat métier
- ⚠️ Avatar entity N'A PAS de méthodes toJson/fromJson (c'est le rôle des DTOs)

### Tests Validés
```bash
flutter test test/domain/    # 109/109 tests passent ✅
# Coverage: 100% (164/164 lignes)
```

---

## ✅ Story 1.3 - Avatar Repository (Data Layer)

### Fichiers Clés Créés

#### **Domain Layer (Interfaces)**
```
lib/domain/repositories/
└── avatar_repository.dart      - Interface AvatarRepository (5 méthodes)
```

#### **Data Layer (Implémentations)**
```
lib/data/
├── data_sources/local/
│   ├── database_helper.dart              - SQLite helper (5 tables)
│   └── avatar_local_data_source.dart     - Data source local
├── models/
│   ├── avatar_dto.dart + .g.dart         - DTO Avatar avec json_serializable
│   ├── user_dto.dart + .g.dart           - DTO User
│   ├── hydration_log_dto.dart + .g.dart  - DTO HydrationLog
│   └── streak_dto.dart + .g.dart         - DTO Streak
└── repositories/
    └── avatar_repository_impl.dart       - Implémentation AvatarRepository
```

#### **Core Layer (DI)**
```
lib/core/di/
└── injection.dart                        - Dependency Injection avec get_it
```

#### **Tests**
```
test/data/
├── models/
│   ├── avatar_dto_test.dart
│   └── user_dto_test.dart
└── repositories/
    ├── avatar_repository_impl_test.dart          - 16 unit tests
    ├── avatar_repository_impl_test.mocks.dart    - Mocks générés
    └── avatar_repository_integration_test.dart   - Integration tests SQLite
```

### Architecture Data Layer

#### **Base de Données SQLite (5 tables)**
```sql
-- Table: avatar_state
CREATE TABLE avatar_state (
  id TEXT PRIMARY KEY,
  personality TEXT NOT NULL,
  state TEXT NOT NULL,
  last_updated TEXT NOT NULL
);

-- Table: users
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  weight REAL NOT NULL,
  age INTEGER NOT NULL,
  gender TEXT NOT NULL,
  activity_level TEXT NOT NULL,
  daily_goal INTEGER NOT NULL,
  created_at TEXT NOT NULL
);

-- Table: hydration_logs
CREATE TABLE hydration_logs (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  amount INTEGER NOT NULL,
  timestamp TEXT NOT NULL,
  photo_path TEXT,
  glass_size TEXT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Table: streaks
CREATE TABLE streaks (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  current_streak INTEGER NOT NULL,
  longest_streak INTEGER NOT NULL,
  last_drink_date TEXT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Table: settings
CREATE TABLE settings (
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL
);
```

#### **Méthodes AvatarRepository**
```dart
Future<void> saveSelectedAvatar(AvatarPersonality personality);
Future<AvatarPersonality?> getSelectedAvatar();
Future<void> updateAvatarState(AvatarState state);
Future<AvatarState> getAvatarState();
Future<void> clearAvatarData();
```

#### **DTOs (Data Transfer Objects)**
Tous les DTOs utilisent `json_serializable` pour générer `toJson()` / `fromJson()`:
```dart
// Exemple AvatarDto
@JsonSerializable()
class AvatarDto {
  final String id;
  final String personality;
  final String state;

  // fromEntity() - Convertit Avatar (domain) → AvatarDto (data)
  // toEntity() - Convertit AvatarDto (data) → Avatar (domain)
  // toJson() - Sérialise vers Map<String, dynamic>
  // fromJson() - Désérialise depuis Map<String, dynamic>
}
```

#### **Dependency Injection (get_it)**
```dart
// Configuration dans lib/core/di/injection.dart
final getIt = GetIt.instance;

void setupDependencies() {
  // Data Sources
  getIt.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
  getIt.registerLazySingleton<AvatarLocalDataSource>(
    () => AvatarLocalDataSource(getIt<DatabaseHelper>())
  );

  // Repositories
  getIt.registerLazySingleton<AvatarRepository>(
    () => AvatarRepositoryImpl(getIt<AvatarLocalDataSource>())
  );
}
```

### À Savoir pour la Suite
- ✅ **DatabaseHelper est SINGLETON** - Ne pas recréer, utiliser `getIt<DatabaseHelper>()`
- ✅ **AvatarRepository déjà injectable** - `getIt<AvatarRepository>()`
- ✅ **5 tables SQLite créées** - Schéma complet prêt (avatar_state, users, hydration_logs, streaks, settings)
- ✅ **DTOs pour 4 entities** - Avatar, User, HydrationLog, Streak (avec json_serializable)
- ✅ **SharedPreferences pour avatar ID** - getSelectedAvatar() / saveSelectedAvatar()
- ✅ **SQLite pour état avatar** - getAvatarState() / updateAvatarState()
- ✅ **Timestamps en UTC ISO 8601** - Format standardisé
- ⚠️ **NE PAS recréer DatabaseHelper** - Il existe déjà et gère 5 tables
- ⚠️ **NE PAS redéfinir les DTOs** - Ils sont dans lib/data/models/ avec .g.dart générés
- ⚠️ **Appeler setupDependencies() dans main.dart** - Si pas déjà fait

### Tests Validés
```bash
flutter test test/data/      # 16/16 unit tests passent ✅
flutter test                 # 128/128 total tests passent ✅
# Coverage Data Layer: ≥80%
```

### Génération Code (json_serializable)
```bash
# Si modifications DTOs, regénérer les .g.dart:
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## ⏳ PROCHAINE STORY: 1.4 - Avatar Assets

### Ce qui EXISTE déjà (NE PAS RECRÉER)
- ✅ Avatar entity avec `AvatarPersonality` enum (4 avatars)
- ✅ `AvatarState` enum avec 5 états (fresh → dead → ghost)
- ✅ AvatarRepository pour sauvegarder/charger avatar sélectionné
- ✅ DTOs pour sérialisation

### Ce qu'il FAUT créer
- [ ] `AvatarAssetProvider` - Service pour charger les assets avatar
- [ ] Placeholders **EMOJIS** pour 4 avatars × 5 états = **20 combinaisons**
- [ ] Structure `assets/avatars/` prête pour vraies images plus tard
- [ ] **Widget `AvatarDisplay`** - Affiche l'avatar selon état et personnalité (AC #6)
- [ ] Tests de validation assets (tous les assets existent)
- [ ] Widget tests pour `AvatarDisplay` (AC #7)

### Décisions Importantes
- **Utiliser EMOJIS comme placeholders** (pas d'images pour l'instant)
  - Docteur: 🧑‍⚕️ (fresh: 😊, slightly: 😐, dehydrated: 😟, dead: 💀, ghost: 👻)
  - Coach: 💪 (idem 5 états)
  - Mère: 👩 (idem 5 états)
  - Pote: 🤝 (idem 5 états)
- **Préparer structure pour vraies images** - `assets/avatars/{personality}/{state}.png`
- **Asset provider injectable via get_it**

### Fichiers à Créer
```
lib/presentation/providers/
└── avatar_asset_provider.dart

lib/presentation/widgets/
└── avatar_display.dart                  - Widget affichage avatar (AC #6)

assets/avatars/
├── doctor/
│   ├── fresh.png (placeholder emoji pour l'instant)
│   ├── slightly_dehydrated.png
│   ├── dehydrated.png
│   ├── dead.png
│   └── ghost.png
├── coach/ (idem 5 états)
├── mother/ (idem 5 états)
└── friend/ (idem 5 états)

test/presentation/providers/
└── avatar_asset_provider_test.dart

test/presentation/widgets/
└── avatar_display_test.dart             - Widget tests (AC #7)
```

---

## 📚 Références Importantes

### Documentation à Consulter
- `docs/contracts/database-schema.md` - Schéma complet SQLite
- `docs/contracts/data-models.md` - Specs entities et DTOs
- `docs/architecture/data-layer.md` - Architecture Data Layer
- `docs/front-end-spec.md` - Specs UI/UX (section avatars)
- `docs/instructions-claude.md` - **Instructions MANDATORY pour tous les devs**

### Commandes Utiles
```bash
# Tests
flutter test                    # Tous les tests
flutter test test/domain/       # Tests Domain Layer uniquement
flutter test test/data/         # Tests Data Layer uniquement
flutter test --coverage         # Avec coverage

# Analyse
flutter analyze                 # Analyse statique (0 issues attendu)

# Build Runner (DTOs)
flutter pub run build_runner build --delete-conflicting-outputs

# Run
flutter run                     # Lance app (Chrome ou Android)
flutter devices                 # Liste devices disponibles
```

### Standards de Code
- **Entities (Domain):** Immutables, Equatable, pas de sérialisation JSON
- **DTOs (Data):** json_serializable, méthodes fromEntity/toEntity
- **Repositories:** Interface dans domain/, implémentation dans data/
- **Tests:** Coverage minimum 80% (Domain 90%+)
- **Naming:** snake_case fichiers, camelCase variables, PascalCase classes
- **Imports:** Toujours `package:hydrate_or_die/...` (pas de relative paths)

---

## ⚠️ POINTS D'ATTENTION CRITIQUES

### NE PAS FAIRE (Éviter Duplications)
- ❌ Ne pas recréer `DatabaseHelper` - Il existe déjà avec 5 tables
- ❌ Ne pas redéfinir les DTOs - Ils sont dans `lib/data/models/` avec `.g.dart`
- ❌ Ne pas réinitialiser Firebase dans main.dart - C'est déjà fait
- ❌ Ne pas modifier les entities Domain sans raison critique
- ❌ Ne pas ajouter de dépendances dans pubspec.yaml sans consulter

### TOUJOURS FAIRE
- ✅ Lire `docs/instructions-claude.md` avant de commencer
- ✅ Lire ce fichier `dev-context.md` pour comprendre l'existant
- ✅ Consulter la story markdown dans `docs/stories/epic-1/story-X.Y-*.md`
- ✅ Vérifier les contracts dans `docs/contracts/`
- ✅ Tester avec `flutter test` avant de terminer
- ✅ Créer les rapports dans `docs/stories/epic-1/reports/`
- ✅ Respecter Clean Architecture (Domain ← Data ← Presentation)

---

**Dernière mise à jour:** 2026-01-08 après Story 1.3
**Prochaine mise à jour:** Après Story 1.4 (Avatar Assets)

---

*Ce fichier est maintenu par @bmad-master pour assurer continuité entre agents @dev.*
