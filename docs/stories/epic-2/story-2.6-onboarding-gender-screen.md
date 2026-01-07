# Story 2.6: Écran Onboarding Question Sexe

**Epic:** Epic 2 - Onboarding & Personnalisation
**Story ID:** 2.6
**Status:** Not Started
**Priority:** High
**Estimated Effort:** 3 hours

---

## User Story

**As a** new user,
**I want** renseigner mon sexe biologique lors de l'onboarding,
**so that** l'app peut ajuster mon objectif d'hydratation avec précision.

---

## Acceptance Criteria

1. L'écran `OnboardingGenderScreen` s'affiche après l'écran âge
2. L'écran affiche : titre "Sexe biologique", sous-titre "Utilisé uniquement pour calcul scientifique"
3. Trois boutons radio/cards : "Homme", "Femme", "Autre"
4. L'option sélectionnée est highlight visuellement
5. Bouton "Suivant" activé seulement si une option est sélectionnée
6. Indicateur de progression "3/5" visible
7. Widget test valide la sélection et navigation

---

## Technical Notes

- Location: `lib/presentation/screens/onboarding/onboarding_gender_screen.dart`
- UI: Use cards with radio button behavior
- Tests: `test/presentation/screens/onboarding/onboarding_gender_screen_test.dart`

---

## Dependencies

- Story 2.5 (Age screen) doit être complétée
- Story 2.1 (Gender enum) doit être complétée

---

## Definition of Done

- [ ] Tous les AC validés
- [ ] Widget tests passent
- [ ] Selection UI fonctionne
- [ ] Code suit conventions
- [ ] Navigation testée
- [ ] PM approval

---

## Links

- Epic: [epic-2-onboarding.md](../../epics/epic-2-onboarding.md)
- Previous: [story-2.5-onboarding-age-screen.md](story-2.5-onboarding-age-screen.md)
- Next: [story-2.7-onboarding-activity-screen.md](story-2.7-onboarding-activity-screen.md)
