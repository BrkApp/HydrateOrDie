# Hotfix Epic 3 - Bug #1: Avatar Selection Manquant

**Sévérité:** 🔴 CRITIQUE
**Epic:** 3
**Story Affectée:** 1.8 (Avatar Selection)

---

## 🐛 Problème

L'écran de sélection avatar (AvatarSelectionScreen) n'apparaît jamais dans le flow onboarding. L'utilisateur ne peut pas choisir parmi les 4 avatars (Doctor, Coach, Mother, Friend).

---

## 🎯 Solution

**Fichier:** `lib/presentation/screens/onboarding/onboarding_flow_screen.dart`

**Ligne 45-52:** Ajouter `AvatarSelectionScreen()` au début de la liste `_screens`.

**Changement requis:**
```dart
final List<Widget> _screens = const [
  AvatarSelectionScreen(),  // ✅ AJOUTER CETTE LIGNE
  OnboardingWeightScreen(),
  OnboardingAgeScreen(),
  OnboardingGenderScreen(),
  OnboardingActivityScreen(),
  OnboardingLocationScreen(),
  OnboardingSummaryScreen(),
];
```

**Import requis:**
```dart
import 'package:hydrate_or_die/presentation/screens/avatar/avatar_selection_screen.dart';
```

---

## ✅ Validation

Après fix:
1. Fresh install app
2. Onboarding démarre
3. **Premier écran = Avatar Selection (4 choix)**
4. Sélectionner un avatar
5. Continuer flow onboarding normal
6. Vérifier que l'avatar sélectionné s'affiche sur HomeScreen

---

## 📊 Impact

- **Files modifiés:** 1
- **Lines changed:** +2 (1 import, 1 screen ajouté)
- **Tests requis:** Widget test onboarding flow

---

**Priorité:** P0 (BLOQUANT)
**Durée estimée:** 5 min
