# Story 2.4: Écran Onboarding Question Poids

**Epic:** Epic 2 - Onboarding & Personnalisation
**Story ID:** 2.4
**Status:** Not Started
**Priority:** High
**Estimated Effort:** 4 hours

---

## User Story

**As a** new user,
**I want** renseigner mon poids lors de l'onboarding,
**so that** l'app peut calculer mon objectif d'hydratation.

---

## Acceptance Criteria

1. L'écran `OnboardingWeightScreen` s'affiche après la sélection d'avatar (Epic 1)
2. L'écran affiche : titre "Quel est ton poids ?", sous-titre explicatif "Nécessaire pour calculer ton objectif d'hydratation"
3. Un champ de saisie numérique permet d'entrer le poids avec clavier numérique (iOS/Android native)
4. L'unité est configurable (kg ou lbs) via toggle, par défaut kg
5. La validation vérifie : poids entre 30kg et 300kg (ou équivalent lbs), format numérique valide
6. Un message d'erreur s'affiche si la valeur est hors limites
7. Un bouton "Suivant" est activé seulement si la valeur est valide
8. Un indicateur de progression "1/5" est visible en haut de l'écran
9. Widget test valide l'affichage, la validation, et la navigation vers l'écran suivant

---

## Technical Notes

- Location: `lib/presentation/screens/onboarding/onboarding_weight_screen.dart`
- State management: Utiliser Bloc ou Provider
- Tests: `test/presentation/screens/onboarding/onboarding_weight_screen_test.dart`

---

## Dependencies

- Story 2.1 (UserProfile model) doit être complétée
- Story 1.8 (Avatar Selection) doit être complétée

---

## Definition of Done

- [ ] Tous les AC validés
- [ ] Widget tests passent
- [ ] Validation fonctionne correctement
- [ ] Code suit conventions
- [ ] Navigation testée
- [ ] PM approval

---

## Links

- Epic: [epic-2-onboarding.md](../../epics/epic-2-onboarding.md)
- Previous: [story-2.3-user-profile-repository.md](story-2.3-user-profile-repository.md)
- Next: [story-2.5-onboarding-age-screen.md](story-2.5-onboarding-age-screen.md)
