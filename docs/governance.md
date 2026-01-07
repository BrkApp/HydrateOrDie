# Project Governance - Hydrate or Die

**Version:** 1.0
**Date:** 2026-01-07
**Owner:** Product Manager John
**Status:** MANDATORY - Non-négociable

---

## 🎯 Objectif de ce Document

Ce document définit les **règles de gouvernance strictes** du projet Hydrate or Die. Ces règles sont **NON NÉGOCIABLES** et s'appliquent à tous les agents dev, architectes, et contributeurs.

**Principe fondamental :** Cadre strict pour éviter le chaos, garantir la qualité, et assurer que le projet reste maintenable sur le long terme.

---

## 1. Architecture Figée AVANT Développement

### Règle Obligatoire

**AUCUN code ne peut être écrit avant que l'architecture soit validée et documentée.**

### Process Strict

1. **Phase Architecture** (Architect Agent)
   - L'Architect doit produire un document d'architecture complet AVANT tout développement
   - Document obligatoire : `docs/architecture.md`
   - Contenu minimal requis :
     - Diagramme de l'architecture globale (layers, modules, dépendances)
     - Structure des dossiers détaillée avec justification
     - Flux de données (data flow diagrams)
     - Patterns architecturaux utilisés (Clean Architecture, MVVM, etc.)
     - Décisions techniques justifiées (pourquoi Riverpod vs Bloc, pourquoi Firebase, etc.)

2. **Phase Contrats d'Interface** (Architect Agent)
   - Tous les contrats d'interface doivent être définis AVANT implémentation
   - Document obligatoire : `docs/contracts/` avec sous-fichiers :
     - `data-models.md` : Tous les models/DTOs avec schémas complets
     - `api-contracts.md` : Toutes les APIs (méthodes, params, returns, error cases)
     - `database-schema.md` : Schéma DB complet (tables, colonnes, types, relations, indexes)
     - `repositories-interface.md` : Interfaces de tous les repositories
     - `use-cases-interface.md` : Interfaces de tous les use cases

3. **Validation Architecture**
   - Le PM (moi) doit valider l'architecture AVANT que le dev démarre
   - Checklist de validation obligatoire (voir section 6)

### Conséquence en Cas de Non-Respect

❌ **Si du code est écrit avant validation architecture → REJECT total et recommencement**

---

## 2. Schémas DB/DTO Définis en Amont

### Règle Obligatoire

**Tous les schémas de données doivent être validés AVANT la première ligne de code.**

### Requirements

#### A. Data Models / DTOs

Chaque model doit être documenté dans `docs/contracts/data-models.md` avec :

```markdown
## [ModelName]

**Purpose:** [Description courte du rôle]

**Properties:**
- `property1`: Type - Description - Constraints (nullable? default? validation?)
- `property2`: Type - Description - Constraints
- ...

**Methods:**
- `toJson()`: Serialization to JSON
- `fromJson()`: Deserialization from JSON
- [Other methods with signature]

**Validation Rules:**
- [Rule 1]
- [Rule 2]

**Example:**
```json
{
  "property1": "value",
  "property2": 123
}
```
```

#### B. Database Schema

Chaque table doit être documentée dans `docs/contracts/database-schema.md` avec :

```markdown
## Table: [table_name]

**Purpose:** [Description]

**Columns:**
| Column | Type | Nullable | Default | Constraints | Description |
|--------|------|----------|---------|-------------|-------------|
| id | UUID | NO | gen_uuid() | PRIMARY KEY | Unique identifier |
| ... | ... | ... | ... | ... | ... |

**Indexes:**
- Index on [column] (reason: performance for query X)

**Relations:**
- Foreign Key to [other_table.column]

**Migration Strategy:**
- [How to create/update this table]
```

### Validation Process

1. Architect crée les schémas
2. PM valide les schémas (moi)
3. Dev implémente EXACTEMENT selon les schémas (pas d'impro)

### Conséquence en Cas de Non-Respect

❌ **Si un model/table est créé sans documentation préalable → REJECT et documentation obligatoire**

---

## 3. Tests Obligatoires

### Règle Obligatoire

**Aucune story ne peut être considérée "Done" sans tests passant.**

### Coverage Minimum Requis

- **Domain Layer (Use Cases, Business Logic)** : 80% minimum
- **Data Layer (Repositories, Models)** : 70% minimum
- **Presentation Layer (Widgets, Screens)** : 50% minimum (focus sur widgets critiques)

### Types de Tests Obligatoires

#### A. Unit Tests

**Obligatoires pour :**
- Tous les use cases
- Tous les models (toJson, fromJson, validation)
- Toute logique de calcul (hydratation goal, streak, etc.)
- Tous les repositories (mock dependencies)

**Format requis :**
```dart
// test/domain/use_cases/calculate_hydration_goal_use_case_test.dart
void main() {
  group('CalculateHydrationGoalUseCase', () {
    test('should calculate correct goal for 75kg male sedentary', () {
      // Given
      // When
      // Then
    });

    test('should apply activity multiplier correctly', () { ... });
    test('should enforce minimum goal of 1.5L', () { ... });
    test('should enforce maximum goal of 5.0L', () { ... });
  });
}
```

#### B. Widget Tests

**Obligatoires pour :**
- Tous les écrans principaux (HomeScreen, OnboardingScreens, etc.)
- Tous les widgets réutilisables (AvatarDisplay, StreakDisplay, etc.)
- Tous les flows critiques (navigation onboarding, validation photo)

#### C. Integration Tests

**Obligatoires pour :**
- Flow onboarding complet (5 écrans → sauvegarde profil)
- Flow validation photo (photo → sauvegarde → update avatar)
- Flow streak (validation → calcul streak → affichage)

### CI/CD Enforcement

- GitHub Actions DOIT exécuter `flutter test` sur chaque commit
- Si tests fail → BLOCK merge
- Coverage report généré automatiquement

### Conséquence en Cas de Non-Respect

❌ **Si story marquée "Done" sans tests → REJECT et retour en "In Progress"**
❌ **Si coverage < minimum requis → BLOCK jusqu'à correction**

---

## 4. Scope Verrouillé par Itération

### Règle Obligatoire

**Le scope d'une story/epic est FIGÉ une fois validé. Pas d'improvisation pendant le dev.**

### Process de Verrouillage

1. **Définition Scope** (PM)
   - Story définie avec acceptance criteria précis dans l'epic
   - Scope validé avant assignment à un agent dev

2. **Freeze Scope** (Avant Dev)
   - Une fois le dev démarré sur une story, le scope ne peut PAS changer
   - Si besoin de modification → STOP dev, créer nouvelle story pour changement

3. **Gestion Changements**
   - Si changement nécessaire découvert pendant dev :
     - STOP travail sur la story actuelle
     - Documenter le besoin de changement
     - PM décide : nouvelle story OU modification acceptance criteria
     - Si modification acceptance criteria → Re-validation avant reprise dev

### Exceptions Autorisées

**Seuls changements autorisés sans re-validation :**
- Bug fixes critiques découverts pendant dev
- Ajustements techniques mineurs (renommage variable, refacto interne) qui n'affectent PAS le comportement

### Conséquence en Cas de Non-Respect

❌ **Si scope drift détecté → REJECT du code et retour strict au scope initial**
❌ **Si features "bonus" ajoutées sans validation → SUPPRESSION et stick to scope**

---

## 5. Conventions de Code Strictes

### Règle Obligatoire

**Tout le code doit respecter les conventions définies. Pas d'exceptions.**

### Conventions Flutter/Dart

#### A. Naming Conventions

```dart
// Classes: PascalCase
class UserProfile { }
class HydrationLogRepository { }

// Variables/Functions: camelCase
final userName = 'John';
void calculateGoal() { }

// Constants: lowerCamelCase with 'k' prefix
const kDefaultGoalLiters = 2.5;
const kMaxNotificationsPerDay = 50;

// Private: underscore prefix
String _privateMethod() { }
final _privateVariable = 'value';

// Files: snake_case
// user_profile.dart
// hydration_log_repository.dart
```

#### B. Structure de Fichiers STRICTE

```
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart
│   ├── theme/
│   │   └── app_theme.dart
│   └── utils/
│       └── date_utils.dart
├── data/
│   ├── models/
│   │   └── user_profile.dart
│   ├── repositories/
│   │   └── user_profile_repository.dart
│   └── data_sources/
│       └── local/
│           └── user_profile_local_data_source.dart
├── domain/
│   ├── entities/
│   │   └── user.dart
│   ├── repositories/
│   │   └── user_repository.dart (interface)
│   └── use_cases/
│       └── calculate_hydration_goal_use_case.dart
├── presentation/
│   ├── screens/
│   │   └── home/
│   │       ├── home_screen.dart
│   │       └── widgets/
│   │           └── avatar_display.dart
│   └── providers/ (ou blocs/)
│       └── home_provider.dart
└── main.dart
```

**INTERDIT de dévier de cette structure.**

#### C. Documentation Obligatoire

Chaque classe/méthode publique DOIT avoir un dartdoc :

```dart
/// Calculates the daily hydration goal based on user profile.
///
/// The algorithm uses weight, age, gender, and activity level to compute
/// a personalized hydration target in liters.
///
/// Returns a [double] representing liters per day, bounded between 1.5L and 5.0L.
///
/// Throws [ArgumentError] if [userProfile] is incomplete.
class CalculateHydrationGoalUseCase {
  /// Executes the hydration goal calculation.
  ///
  /// [userProfile] must have all required fields (weight, age, gender, activity).
  double execute(UserProfile userProfile) { ... }
}
```

#### D. Formatting

- **Obligatoire :** Exécuter `dart format .` avant chaque commit
- **Ligne max :** 80 caractères (Flutter convention)
- **Imports :** Organisés (dart: → package: → relative) avec `dart format`

### Conséquence en Cas de Non-Respect

❌ **Si conventions non respectées → REJECT code et reformatage obligatoire**
❌ **Si `dart analyze` rapporte des warnings → BLOCK merge jusqu'à fix**

---

## 6. Revue Humaine Systématique

### Règle Obligatoire

**Chaque story complétée doit passer une revue checklist AVANT d'être marquée "Done".**

### Process de Revue

1. **Auto-Review par Agent Dev**
   - L'agent dev doit exécuter la checklist `definition-of-done.md` (voir fichier séparé)
   - L'agent doit reporter TOUS les items de la checklist avec statut ✅/❌

2. **Review PM (moi)**
   - Je vérifie le report de l'agent
   - Je teste manuellement les acceptance criteria
   - Je valide ou REJECT avec feedback

3. **Corrections si Nécessaire**
   - Si REJECT → Agent fixe et re-soumet
   - Loop jusqu'à validation complète

### Checklist de Revue Story (Résumé)

Voir `docs/definition-of-done.md` pour la checklist complète, mais résumé :

- [ ] Tous les acceptance criteria sont remplis
- [ ] Tests unitaires écrits et passent (coverage OK)
- [ ] Widget tests écrits et passent (si UI)
- [ ] Code respecte conventions (dart format + analyze)
- [ ] Documentation dartdoc présente
- [ ] Aucun TODO/FIXME laissé dans le code
- [ ] Aucune régression détectée (tests existants passent toujours)
- [ ] Build réussit iOS + Android
- [ ] Manuel testing effectué (screenshots si UI)

### Conséquence en Cas de Non-Respect

❌ **Si story marquée Done sans review → REJECT automatique**
❌ **Si checklist incomplète → BLOCK jusqu'à complétion**

---

## 7. Gestion des Dépendances

### Règle Obligatoire

**Aucune nouvelle dépendance ne peut être ajoutée sans validation PM.**

### Process d'Ajout de Dépendance

1. **Agent dev identifie besoin** : "J'ai besoin du package X pour feature Y"
2. **Agent dev justifie** :
   - Pourquoi cette dépendance ?
   - Alternatives considérées ?
   - Impact taille app / performance ?
   - Maintenance / popularité du package ?
3. **PM valide** : Oui/Non avec justification
4. **Si validé** : Agent ajoute dans `pubspec.yaml` + documente dans `docs/dependencies.md`

### Dépendances Pré-Approuvées (MVP)

Les dépendances suivantes sont déjà validées (listées dans PRD) :
- `camera`
- `flutter_local_notifications`
- `permission_handler`
- `shared_preferences`
- `sqflite`
- `firebase_core`, `firebase_auth`, `cloud_firestore`
- `flutter_secure_storage`
- `riverpod` (ou `flutter_bloc` si choisi)
- `get_it`

**Toute autre dépendance → Validation obligatoire.**

### Conséquence en Cas de Non-Respect

❌ **Si dépendance ajoutée sans validation → SUPPRESSION immédiate**

---

## 8. Gestion des Erreurs et Edge Cases

### Règle Obligatoire

**Tous les edge cases et erreurs doivent être gérés. Pas de crashs acceptés.**

### Requirements

1. **Try-Catch Obligatoires**
   - Toutes les opérations async (API calls, DB queries, file I/O) DOIVENT être wrappées en try-catch
   - Toutes les erreurs DOIVENT être loggées (avec stack trace si possible)

2. **User-Facing Errors**
   - Aucune erreur technique brute ne doit être affichée à l'utilisateur
   - Messages d'erreur clairs et actionnables (ex: "Impossible de sauvegarder. Vérifie ton stockage.")

3. **Fallbacks Obligatoires**
   - Si Firebase down → Fonctionnement offline garanti (données locales)
   - Si permission refusée → Message clair + bouton "Ouvrir Paramètres"
   - Si photo validation fail → Fallback vers validation manuelle

4. **Edge Cases Documentés**
   - Chaque use case doit documenter ses edge cases et comment ils sont gérés
   - Exemples : utilisateur sans profil, streak vide, historique vide, etc.

### Conséquence en Cas de Non-Respect

❌ **Si crash en production → PRIORITÉ 0 fix obligatoire**
❌ **Si edge case non géré découvert → BLOCK release jusqu'à fix**

---

## 9. Git Workflow Strict

### Règle Obligatoire

**Workflow Git standardisé. Pas de commits directs sur main.**

### Branches

```
main (production)
  └── develop (intégration)
       ├── feature/epic-1-story-1-project-setup
       ├── feature/epic-1-story-2-avatar-models
       └── feature/epic-2-story-1-onboarding
```

### Naming Branches

Format : `feature/epic-X-story-Y-short-description`

Exemples :
- `feature/epic-1-story-1-project-setup`
- `feature/epic-3-story-4-photo-capture`

### Commit Messages

Format : `[EPIC-X.Y] Short description`

Exemples :
- `[EPIC-1.1] Initialize Flutter project with Clean Architecture`
- `[EPIC-3.4] Implement photo capture with camera package`

### Pull Requests

- **Obligatoire** : Toute feature branch → PR vers develop
- **Review** : PM review avant merge
- **CI** : Tests DOIVENT passer avant merge autorisé
- **Squash** : Squash commits avant merge (1 feature = 1 commit sur develop)

### Conséquence en Cas de Non-Respect

❌ **Si commit direct sur main → REVERT immédiat**
❌ **Si naming non respecté → Rename obligatoire avant review**

---

## 10. Documentation Vivante

### Règle Obligatoire

**La documentation DOIT être mise à jour en même temps que le code.**

### Documents à Maintenir

1. **`README.md`** : Setup instructions, commandes essentielles
2. **`docs/architecture.md`** : Architecture à jour (si changements)
3. **`docs/contracts/`** : Contrats d'interface à jour
4. **`CHANGELOG.md`** : Historique des versions et changements majeurs
5. **Dartdoc inline** : Documentation code à jour

### Process

- **Chaque PR** : Vérifier si documentation impactée
- **Si oui** : Mise à jour documentation DANS LA MÊME PR
- **Si non** : Indiquer "No doc change needed" dans PR description

### Conséquence en Cas de Non-Respect

❌ **Si code changé sans doc mise à jour → BLOCK PR jusqu'à update doc**

---

## 🚨 Résumé des Règles NON NÉGOCIABLES

1. ✅ Architecture figée AVANT code
2. ✅ Schémas DB/DTO définis en amont
3. ✅ Tests obligatoires (coverage minimum)
4. ✅ Scope verrouillé par itération
5. ✅ Conventions de code strictes
6. ✅ Revue humaine systématique
7. ✅ Validation dépendances
8. ✅ Gestion erreurs/edge cases
9. ✅ Git workflow strict
10. ✅ Documentation vivante

**Ces règles s'appliquent à TOUS les agents et contributeurs. Aucune exception.**

---

## 📋 Checklist Pre-Development (Architect)

Avant que le premier agent dev démarre, l'Architect DOIT avoir complété :

- [ ] `docs/architecture.md` créé et validé par PM
- [ ] `docs/contracts/data-models.md` créé et validé
- [ ] `docs/contracts/api-contracts.md` créé et validé
- [ ] `docs/contracts/database-schema.md` créé et validé
- [ ] `docs/contracts/repositories-interface.md` créé
- [ ] `docs/contracts/use-cases-interface.md` créé
- [ ] Structure de dossiers `lib/` créée selon conventions
- [ ] `pubspec.yaml` avec toutes dépendances MVP
- [ ] GitHub Actions CI/CD configuré
- [ ] Tests dummy passent (validation CI)

**Si cette checklist n'est pas complète → AUCUN dev ne peut démarrer.**

---

## 📞 Contact & Escalation

**PM (Product Manager John)** : Point de contact pour toutes questions/validations

**Process d'escalation :**
1. Agent dev bloqué → Question au PM
2. Ambiguïté dans acceptance criteria → Clarification PM
3. Besoin changement scope → Discussion PM → Décision

**Pas de décisions unilatérales des agents dev. Toujours confirmer avec PM.**

---

*Document créé le 2026-01-07 par PM John*
*Ces règles sont MANDATORY et NON NÉGOCIABLES pour le succès du projet.*
