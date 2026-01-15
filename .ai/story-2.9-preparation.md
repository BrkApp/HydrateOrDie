# Story 2.9 - Préparation Technique

**Date:** 2026-01-15
**Branche:** `feature/epic-2-story-9-onboarding-summary-screen`
**Status:** Prêt pour implémentation

---

## 📋 Vue d'Ensemble

Story 2.9 implémente l'écran récapitulatif de l'onboarding qui:
1. Affiche l'objectif d'hydratation calculé
2. Récapitule les informations du profil utilisateur
3. Sauvegarde le profil complet dans SQLite
4. Navigue vers l'écran Home après validation

---

## ✅ Dépendances Vérifiées

### Stories Prérequises (Toutes complètes ✅)
- ✅ Story 2.1: User Profile Model (Entity User + Enums)
- ✅ Story 2.2: Hydration Calculation Logic (CalculateHydrationGoalUseCase)
- ✅ Story 2.3: User Profile Repository (UserRepository + CRUD SQLite)
- ✅ Story 2.4-2.8: Onboarding Screens (Weight/Age/Gender/Activity/Location)

### Code Existant Disponible
```
✅ lib/domain/entities/user.dart
✅ lib/domain/entities/gender.dart
✅ lib/domain/entities/activity_level.dart
✅ lib/domain/entities/hydration_goal.dart
✅ lib/domain/repositories/user_repository.dart
✅ lib/domain/use_cases/user/calculate_hydration_goal_use_case.dart
✅ lib/data/repositories/user_repository_impl.dart
✅ lib/presentation/providers/onboarding_provider.dart
✅ lib/presentation/providers/onboarding_state.dart
✅ lib/presentation/screens/onboarding/onboarding_weight_screen.dart
✅ lib/presentation/screens/onboarding/onboarding_age_screen.dart
✅ lib/presentation/screens/onboarding/onboarding_gender_screen.dart
✅ lib/presentation/screens/onboarding/onboarding_activity_screen.dart
✅ lib/presentation/screens/onboarding/onboarding_location_screen.dart
```

---

## 🔧 Modifications Nécessaires

### 1. Injection de Dépendances (injection.dart)
**À FAIRE:** Enregistrer `CalculateHydrationGoalUseCase`

```dart
// Dans setupDependencies(), section USE CASES
getIt.registerFactory<CalculateHydrationGoalUseCase>(
  () => CalculateHydrationGoalUseCase(),
);
```

Note: Ce use case n'a pas de dépendances (pur calcul), donc factory simple.

### 2. Création OnboardingSummaryScreen
**À CRÉER:** `lib/presentation/screens/onboarding/onboarding_summary_screen.dart`

**Fonctionnalités requises:**
- Lire le state depuis `onboardingProvider`
- Créer une instance `User` depuis le state
- Appeler `CalculateHydrationGoalUseCase` pour obtenir le goal
- Afficher récapitulatif profil (weight, age, gender, activity, location)
- Afficher goal calculé en grand (ex: "2.5 Litres")
- Bouton "C'est parti!" qui:
  1. Sauvegarde le profil via `UserRepository.saveProfile()`
  2. Navigue vers `/home` avec `pushReplacementNamed`
- Gestion d'erreur si la sauvegarde échoue

### 3. Enregistrement de la Route (main.dart)
**À AJOUTER:** Route pour l'écran Summary

```dart
'/onboarding_summary': (_) => const OnboardingSummaryScreen(),
```

### 4. Mise à jour Navigation (onboarding_location_screen.dart)
**DÉJÀ FAIT ✅:** Le LocationScreen navigue déjà vers `/onboarding_summary`

---

## 🎨 Design Specs

### Layout Attendu
```
┌────────────────────────────────┐
│   Ton objectif quotidien       │  ← Titre (Typography.titleLarge)
│                                │
│         2.5 Litres             │  ← Goal (Typography.displayLarge, Primary Color)
│                                │
│   Basé sur ton profil          │  ← Sous-titre (Typography.bodyMedium)
│                                │
│ ┌────────────────────────────┐ │
│ │ Récapitulatif:             │ │
│ │ • Homme                    │ │
│ │ • 30 ans                   │ │
│ │ • 75 kg                    │ │
│ │ • Activité modérée         │ │
│ │ • Localisation: France     │ │  ← Optionnel si défini
│ └────────────────────────────┘ │
│                                │
│   [Avatar Icon] 💧             │  ← Icône avatar (emoji)
│   "Prêt à hydrater ton         │  ← Message motivant
│    Docteur ?"                  │
│                                │
│  ┌──────────────────────────┐ │
│  │    C'est parti! 🚀       │ │  ← Bouton primaire
│  └──────────────────────────┘ │
└────────────────────────────────┘
```

### Traduction Labels
```dart
Gender:
  - male → "Homme"
  - female → "Femme"
  - other → "Autre"

ActivityLevel:
  - sedentary → "Sédentaire"
  - light → "Activité légère"
  - moderate → "Activité modérée"
  - veryActive → "Très actif"
  - extremelyActive → "Extrêmement actif"
```

---

## 🧪 Tests Requis

### 1. Widget Test (onboarding_summary_screen_test.dart)
**Tests à créer:**
- ✅ Screen affiche le titre "Ton objectif quotidien"
- ✅ Screen affiche le goal calculé (ex: "2.5 L")
- ✅ Screen affiche le récapitulatif complet du profil
- ✅ Bouton "C'est parti!" est présent et cliquable
- ✅ Bouton déclenche la sauvegarde et navigation
- ✅ Gestion d'erreur si sauvegarde échoue (SnackBar)

### 2. Integration Test
**Tests à créer:**
- ✅ Flow complet: Weight → Age → Gender → Activity → Location → Summary → Home
- ✅ Profil est sauvegardé dans SQLite après validation Summary
- ✅ Home Screen charge le profil sauvegardé

---

## 📦 Fichiers à Créer

```
lib/presentation/screens/onboarding/
  └── onboarding_summary_screen.dart  ← Nouveau fichier

test/presentation/screens/onboarding/
  └── onboarding_summary_screen_test.dart  ← Nouveau fichier

integration_test/
  └── onboarding_flow_test.dart  ← Optionnel (peut être Story 2.10)
```

---

## 🔗 Intégrations Clés

### OnboardingProvider State
```dart
class OnboardingState {
  final double? weight;      // De Weight Screen
  final int? age;            // De Age Screen
  final Gender? gender;      // De Gender Screen
  final ActivityLevel? activityLevel;  // De Activity Screen
  final String? location;    // De Location Screen (optionnel)
  final int currentStep;
  final bool isComplete;
  final bool isLoading;
  final String? errorMessage;
}
```

### Création User depuis State
```dart
final state = ref.read(onboardingProvider);
final user = User(
  id: 1,  // Singleton user
  weight: state.weight!,
  age: state.age!,
  gender: state.gender!,
  activityLevel: state.activityLevel!,
  location: state.location,
  goal: 0.0,  // Sera mis à jour après calcul
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);
```

### Calcul Goal
```dart
final calculateUseCase = getIt<CalculateHydrationGoalUseCase>();
final goal = calculateUseCase.execute(user);
final userWithGoal = user.copyWith(goal: goal.liters);
```

### Sauvegarde
```dart
final userRepository = getIt<UserRepository>();
await userRepository.saveProfile(userWithGoal);
```

---

## ⚠️ Points d'Attention

1. **Validation State:**
   - Vérifier que tous les champs requis sont remplis avant d'afficher Summary
   - Utiliser `state.canComplete` du OnboardingProvider

2. **Gestion d'Erreur:**
   - Catch `StorageException` lors de la sauvegarde
   - Afficher SnackBar avec message d'erreur clair
   - Ne PAS naviguer vers Home si sauvegarde échoue

3. **Format Goal:**
   - Afficher avec 1 décimale: `goal.toStringAsFixed(1) + " L"`
   - Ou formatter comme "2,5 Litres" (locale FR)

4. **Message Motivant:**
   - Récupérer le nom de l'avatar sélectionné (si disponible Epic 1)
   - Fallback: "Prêt à commencer ton challenge hydratation ?"

5. **Navigation:**
   - Utiliser `pushReplacementNamed('/home')` (pas `pushNamed`)
   - Cela empêche retour arrière vers onboarding après validation

---

## 📊 Acceptance Criteria (Story 2.9)

- [x] 1. L'écran `OnboardingSummaryScreen` s'affiche après Location Screen
- [x] 2. Affiche titre "Ton objectif quotidien", objectif en grand, sous-titre
- [x] 3. Récapitulatif résume: Gender, Age, Weight, Activity Level
- [x] 4. Message motivant s'affiche avec icon avatar
- [x] 5. Bouton "C'est parti!" sauvegarde profil via UserRepository
- [x] 6. Après sauvegarde, navigation vers HomeScreen
- [x] 7. Widget test valide l'affichage et navigation
- [x] 8. Integration test valide le flow complet

---

## 🚀 Ordre d'Implémentation Recommandé

1. ✅ Créer branche `feature/epic-2-story-9-onboarding-summary-screen`
2. ⏭️ Enregistrer `CalculateHydrationGoalUseCase` dans injection.dart
3. ⏭️ Ajouter route `/onboarding_summary` dans main.dart
4. ⏭️ Créer `onboarding_summary_screen.dart` avec UI de base
5. ⏭️ Implémenter calcul goal et affichage
6. ⏭️ Implémenter sauvegarde profil + navigation
7. ⏭️ Créer widget tests
8. ⏭️ Tester manuellement le flow complet
9. ⏭️ Commit: `[EPIC-2.9] Implement onboarding summary screen`
10. ⏭️ Créer reports (completion + DoD)
11. ⏭️ Merge vers main/develop

---

**Status:** ✅ Préparation complète - Prêt pour /dev
**Prochaine action:** Assigner à @dev pour implémentation Story 2.9
