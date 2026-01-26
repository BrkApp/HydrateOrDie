# Dev Context - Epic 2: User Onboarding & Personnalisation

**Epic:** 2 - User Onboarding & Personnalisation
**Status:** ✅ COMPLETE
**Date Début:** 2026-01-12
**Date Fin:** 2026-01-15
**Stories:** 2.1 à 2.10 (10 stories)
**Branche actuelle:** `feature/epic-2-story-10-onboarding-flow-integration`

---

## 📋 Vue d'Ensemble Epic 2

**Objectif:** Implémenter le flow d'onboarding utilisateur pour calculer les besoins hydriques personnalisés basés sur poids, âge, genre, niveau d'activité et localisation.

**Prérequis:** Epic 1 validé ✅ (QA Gate PASSED WITH WARNINGS)

**Stories Scope:**
- 2.1: User Profile Model (Entity User + enums)
- 2.2: Hydration Calculation Logic (Use Case calcul besoins)
- 2.3: User Profile Repository (Persistence SQLite)
- 2.4-2.8: Onboarding Screens (Weight/Age/Gender/Activity/Location)
- 2.9: Onboarding Summary Screen (Récap + goal affiché)
- 2.10: Onboarding Flow Integration (Navigation + conditional routing)

---

## 📊 Progression Stories Epic 2

| Story | Titre | Status | Date | Notes |
|-------|-------|--------|------|-------|
| 2.1 | User Profile Model | ✅ COMPLETE | 2026-01-12 | 43/43 tests passing, 100% coverage |
| 2.2 | Hydration Calculation | ✅ COMPLETE | 2026-01-12 | Use Case + tests edge cases complets |
| 2.3 | User Profile Repository | ✅ COMPLETE | 2026-01-12 | CRUD User dans SQLite |
| 2.4 | Onboarding Weight Screen | ✅ COMPLETE | 2026-01-13 | Slider 30-200kg avec unités kg/lbs |
| 2.5 | Onboarding Age Screen | ✅ COMPLETE | 2026-01-13 | Slider 13-100 ans |
| 2.6 | Onboarding Gender Screen | ✅ COMPLETE | 2026-01-13 | 3 boutons (Male/Female/Other) |
| 2.7 | Onboarding Activity Screen | ✅ COMPLETE | 2026-01-14 | 5 niveaux activité (Sedentary/Light/Moderate/VeryActive/ExtremelyActive) |
| 2.8 | Onboarding Location Screen | ✅ COMPLETE | 2026-01-15 | Mock permission (MVP), pas de géoloc réelle |
| 2.9 | Onboarding Summary Screen | ✅ COMPLETE | 2026-01-15 | Récap profil + goal calculé affiché |
| 2.10 | Onboarding Flow Integration | ✅ COMPLETE | 2026-01-15 | OnboardingFlowScreen avec PageView, stepper, routing conditionnel |

**Progression:** 10/10 stories complètes (100%) - Epic 2 TERMINÉ ✅

---

## 🏗️ Architecture Epic 2

### Nouveaux fichiers attendus

**Domain Layer:**
```
lib/domain/
  entities/
    user.dart                          # Entity User (id, weight, age, gender, activityLevel, location, goal, createdAt, updatedAt)
    gender.dart                        # Enum Gender (male, female, other)
    activity_level.dart                # Enum ActivityLevel (sedentary, light, moderate, active)
  repositories/
    user_repository.dart               # Interface UserRepository (CRUD User)
  use_cases/
    user/
      calculate_hydration_goal_use_case.dart  # Calcul goal basé profil
      save_user_profile_use_case.dart         # Save profil après onboarding
      get_user_profile_use_case.dart          # Load profil existant
```

**Data Layer:**
```
lib/data/
  models/
    user_dto.dart                      # DTO User (toJson/fromJson/toEntity/fromEntity)
  data_sources/
    local/
      user_local_data_source.dart      # Interface + Impl (CRUD SQLite users table)
  repositories/
    user_repository_impl.dart          # Implémentation UserRepository
```

**Presentation Layer:**
```
lib/presentation/
  screens/
    onboarding/
      weight_screen.dart               # Story 2.4
      age_screen.dart                  # Story 2.5
      gender_screen.dart               # Story 2.6
      activity_screen.dart             # Story 2.7
      location_screen.dart             # Story 2.8
      summary_screen.dart              # Story 2.9
  providers/
    onboarding_provider.dart           # State management flow onboarding (Riverpod)
  widgets/
    onboarding_progress_bar.dart       # Barre progression 5 étapes (optionnel)
```

**Tests:**
```
test/
  domain/
    entities/
      user_test.dart
      gender_test.dart
      activity_level_test.dart
    use_cases/
      user/
        calculate_hydration_goal_use_case_test.dart
        save_user_profile_use_case_test.dart
        get_user_profile_use_case_test.dart
  data/
    models/
      user_dto_test.dart
    repositories/
      user_repository_impl_test.dart
      user_repository_integration_test.dart
  presentation/
    screens/
      onboarding/
        weight_screen_test.dart
        age_screen_test.dart
        gender_screen_test.dart
        activity_screen_test.dart
        location_screen_test.dart
        summary_screen_test.dart
    providers/
      onboarding_provider_test.dart
```

---

## 🔗 Intégration Epic 1 → Epic 2

### Points d'intégration

1. **Routing conditionnel (main.dart):**
   - Si User profile non complété → Onboarding Flow (Story 2.10)
   - Si Avatar non sélectionné → Avatar Selection (Epic 1)
   - Sinon → Home Screen

2. **Database migration (database_helper.dart):**
   - Ajouter migration V3 → V4: Create `users` table
   - Schema: `users(id, weight, age, gender, activity_level, location, goal, created_at, updated_at)`

3. **Dependency Injection (injection.dart):**
   - Register UserLocalDataSource (lazy singleton)
   - Register UserRepository (lazy singleton)
   - Register Use Cases (factory)
   - Register OnboardingProvider (factory)

4. **Home Screen (home_screen.dart):**
   - Afficher hydration goal calculé (au lieu de hardcodé)
   - Récupérer goal depuis UserRepository

---

## 📐 Règles Métier Epic 2

### Calcul Hydration Goal (Story 2.2)

**Formule base:**
```
Base = weight (kg) × 35 ml/kg
```

**Ajustements:**
- **Age:**
  - 13-17 ans: +10%
  - 18-54 ans: +0%
  - 55-64 ans: -5%
  - 65+ ans: -10%

- **Gender:**
  - Male: +0%
  - Female: -5%
  - Other: +0%

- **Activity Level:**
  - Sedentary: +0%
  - Light: +10%
  - Moderate: +20%
  - Active: +30%

- **Climate (Location - optionnel Epic 2):**
  - Temperate: +0%
  - Hot/Dry: +15%
  - Cold: -5%

**Exemple:**
```
Profil: 70kg, 30 ans, Female, Moderate activity, Temperate climate
Base = 70 × 35 = 2450 ml
Age adjustment (18-54): 2450 × 1.0 = 2450 ml
Gender adjustment (Female): 2450 × 0.95 = 2327.5 ml
Activity adjustment (Moderate): 2327.5 × 1.2 = 2793 ml
Climate adjustment (Temperate): 2793 × 1.0 = 2793 ml
Goal final: 2800 ml (arrondi au 100ml près)
```

---

## 🎨 Design Specs Epic 2

### Onboarding Flow UX

**Progression visuelle:**
- Stepper horizontal en haut: 1️⃣ → 2️⃣ → 3️⃣ → 4️⃣ → 5️⃣ → ✅
- Bouton "Suivant" en bas (disabled si champ vide)
- Bouton "Retour" en haut-gauche (sauf première étape)

**Validation:**
- Weight: 30-200 kg (30-440 lbs)
- Age: 13-100 ans
- Gender: Required (no default)
- Activity: Required (no default)
- Location: Optional (skip button visible)

**Summary Screen:**
- Card profil récap (Weight, Age, Gender, Activity, Location)
- Card goal calculé (ex: "2800 ml / jour")
- Message personnalisé avatar (ex: "Parfait ! Je vais t'aider à atteindre ton objectif quotidien.")
- Bouton "Commencer" → Navigation vers Home Screen

---

## 🛠️ Tâches Techniques Préliminaires

### Avant de démarrer Story 2.1

1. ✅ Créer branche `epic-2-user-onboarding`
2. ✅ Archiver `dev-context-epic-1.md` → `dev-context-epic-1-archived.md` (fait)
3. ✅ Créer `dev-context-epic-2.md` (ce fichier)
4. ⏭️ Mettre à jour `database_helper.dart` (préparer migration V4)
5. ⏭️ Créer dossier `lib/presentation/screens/onboarding/`
6. ⏭️ Créer dossier `test/presentation/screens/onboarding/`

---

## 🚨 Risques & Dépendances Epic 2

### Risques identifiés

1. **Géolocalisation (Story 2.8):**
   - Permission géoloc peut être refusée → Fallback pays manuel requis
   - API reverse geocoding requise (Google/Nominatim) → Coût/Quotas

2. **Calcul hydration goal:**
   - Formule simplifiée (peut nécessiter ajustements médicaux)
   - Disclaimer requis ("Consulter un médecin pour besoins spécifiques")

3. **Tests widgets (warning Epic 1):**
   - 13 tests timeout sur Epic 1 → Mock timer services avant Epic 2

### Dépendances externes

- **geolocator** (package Flutter) pour détection position (Story 2.8)
- **geocoding** (package Flutter) pour reverse geocoding pays (Story 2.8)
- Aucune dépendance bloquante pour Stories 2.1-2.7 et 2.9-2.10

---

## 📝 Notes Développement

### Conventions Epic 2

1. **State Management:**
   - OnboardingProvider (StateNotifier) gère state multi-screen
   - State model: `OnboardingState(weight, age, gender, activityLevel, location, currentStep, isComplete)`

2. **Navigation:**
   - PageView avec PageController pour swipe horizontal (optionnel)
   - Named routes: `/onboarding/weight`, `/onboarding/age`, etc.

3. **Validation:**
   - Validation côté client (UI) + côté use case (domain)
   - Throw `ValidationException` si données invalides

4. **Persistance:**
   - Save profil à la fin (Summary Screen confirmation)
   - Pas de save intermédiaire (éviter données incomplètes en DB)

---

## ✅ Critères de Succès Epic 2

**Epic 2 sera validé si:**

- ✅ 10/10 stories implémentées et testées
- ✅ Flow onboarding complet fonctionnel (Weight → Age → Gender → Activity → Location → Summary → Home)
- ✅ Calcul hydration goal correct (tests unitaires avec cas limites)
- ✅ User profile persiste en SQLite
- ✅ Routing conditionnel fonctionne (nouveau user → Onboarding, user existant → skip)
- ✅ Tests coverage ≥80% (Domain 90%, Data 80%, Presentation 70%)
- ✅ Flutter analyze: 0 errors (warnings OK si documentés)
- ✅ QA Gate Epic 2 passed

---

## 🔗 Liens Utiles

- [Epic 2 PRD](../../prd/epic-2-user-onboarding.md)
- [Epic 1 QA Gate Report](../../qa/reports/epic-1-qa-gate-report.md)
- [Epic 1 Dev Context (archived)](../epic-1/dev-context-epic-1-archived.md)

---

**Dernière mise à jour:** 2026-01-15
**Status Epic 2:** ✅ COMPLETE (10/10 stories complètes)
**Branche actuelle:** `feature/epic-2-story-10-onboarding-flow-integration`
**Prochain milestone:** Epic 3 - Hydration Logging & Tracking
