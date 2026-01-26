# Epic 3 - Bugs Trouvés en Test Manuel APK

**Date:** 2026-01-26
**APK Testé:** app-release.apk (53.2MB) - Build 2026-01-23
**Testeur:** User
**Device:** Android

---

## 🐛 BUG #1 - Avatar Selection Manquant dans Onboarding

**Sévérité:** 🔴 CRITIQUE (Bloquant UX)

**Description:**
Dans le flow onboarding, l'utilisateur n'a pas accès à l'écran de sélection des 4 avatars.

**Steps to Reproduce:**
1. Fresh install app
2. Lancer app
3. Flow onboarding démarre
4. Pas d'écran avatar selection (4 choix: Doctor, Coach, Mother, Friend)

**Comportement Attendu:**
- L'onboarding devrait inclure l'écran AvatarSelectionScreen
- User doit pouvoir choisir parmi 4 avatars avant de continuer

**Comportement Actuel:**
- AvatarSelectionScreen skip complètement
- Avatar probablement assigné par défaut (quel avatar?)

**Impact:**
- User ne peut pas personnaliser son expérience
- Story 1.8 (Avatar Selection) non fonctionnelle en prod

**Fichiers Suspects:**
- `lib/presentation/screens/onboarding/onboarding_flow_screen.dart`
- Route/navigation onboarding manquante?

**Priorité:** P0 (MUST FIX avant merge)

---

## 🐛 BUG #2 - Progress Bar Stagne à 0% + Historique Pas Mis à Jour

**Sévérité:** 🔴 CRITIQUE (Feature principale cassée)

**Description:**
Après avoir enregistré une hydratation (photo + glass size), la progress bar reste bloquée à 0% et l'historique "Dernière hydratation" n'affiche aucune mise à jour.

**Steps to Reproduce:**
1. HomeScreen → Tap "J'ai bu !"
2. Autoriser caméra (permission OK ✅)
3. Capturer photo (OK ✅)
4. Sélectionner glass size (ex: Medium 250ml) (OK ✅)
5. Valider
6. Retour HomeScreen

**Comportement Attendu:**
- **Progress bar:** Devrait passer de 0% à X% (ex: 250ml / 2000ml goal = 12.5%)
- **Historique:** Section "Dernière hydratation" devrait afficher:
  - Heure du log
  - Volume (250ml)
  - Peut-être photo thumbnail

**Comportement Actuel:**
- **Progress bar:** Reste à 0% (pas d'animation, pas de mise à jour)
- **Historique:** Aucun log visible, ou section vide

**Impact:**
- **Story 3.6** (Record Hydration) partiellement cassée
- **Story 3.7** (Avatar Feedback Animation) pas visible
- User ne voit aucun feedback de son action
- Impossibilité de tracker progression quotidienne

**Hypothèses Possibles:**

### Hypothèse A: RecordHydrationUseCase ne s'exécute pas
- Navigation retour se fait avant l'enregistrement
- Use case appelé mais erreur silencieuse (try-catch trop permissif?)

### Hypothèse B: Persistence OK mais UI pas refresh
- Log enregistré en DB
- HomeScreen providers pas notifiés (Riverpod listen manquant?)
- `ref.watch()` au lieu de `ref.read()` manquant?

### Hypothèse C: Calcul progress incorrect
- RecordHydrationUseCase s'exécute
- Avatar.lastDrinkTime mis à jour
- Mais calcul % goal cassé (division par zéro? goal null?)

**Fichiers Suspects:**
- `lib/domain/use_cases/hydration/record_hydration_use_case.dart`
- `lib/presentation/screens/home/home_screen.dart`
- `lib/presentation/providers/*` (providers Riverpod)
- `lib/data/repositories/hydration_log_repository_impl.dart`

**Debug Recommandé:**
```dart
// Dans RecordHydrationUseCase
print('🔍 DEBUG: Recording hydration - volume: $volumeMl');
print('🔍 DEBUG: User goal: ${user.dailyGoalMl}');
print('🔍 DEBUG: Progress calculated: ${progress}%');

// Dans HomeScreen
print('🔍 DEBUG: HomeScreen rebuild - logs count: ${logs.length}');
print('🔍 DEBUG: Current progress: ${userState.progress}%');
```

**Priorité:** P0 (MUST FIX avant merge)

---

## ✅ Fonctionnalités OK (Pour Référence)

- ✅ Permissions caméra (Story 3.10)
- ✅ Camera preview + capture (Story 3.4)
- ✅ Glass size selection UI (Story 3.9)
- ✅ Navigation flow complet
- ✅ Pas de crash

---

## 📊 Résumé

**Total bugs critiques:** 2
**Total bugs mineurs:** 0

**Bloquants merge:** OUI (2 bugs P0)

**Action Requise:**
1. Fix Bug #1 (Avatar Selection)
2. Fix Bug #2 (Progress Bar + Historique)
3. Rebuild APK
4. Re-test manuel complet
5. Si OK → Merge

---

**Créé par:** @bmad-master
**Date:** 2026-01-26
