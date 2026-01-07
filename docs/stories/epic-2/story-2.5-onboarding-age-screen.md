# Story 2.5: Écran Onboarding Question Âge

**Epic:** Epic 2 - Onboarding & Personnalisation
**Story ID:** 2.5
**Status:** Not Started
**Priority:** High
**Estimated Effort:** 3 hours

---

## User Story

**As a** new user,
**I want** renseigner mon âge lors de l'onboarding,
**so that** l'app peut ajuster mon objectif d'hydratation selon mon âge.

---

## Acceptance Criteria

1. L'écran `OnboardingAgeScreen` s'affiche après l'écran poids
2. L'écran affiche : titre "Quel âge as-tu ?", sous-titre "Ton besoin en eau varie selon l'âge"
3. Un champ de saisie numérique permet d'entrer l'âge avec clavier numérique
4. La validation vérifie : âge entre 10 et 120 ans
5. Un message d'erreur s'affiche si la valeur est hors limites
6. Bouton "Suivant" activé seulement si valide
7. Indicateur de progression "2/5" visible
8. Widget test valide l'affichage, validation, et navigation

---

## Technical Notes

- Location: `lib/presentation/screens/onboarding/onboarding_age_screen.dart`
- Similar structure to weight screen
- Tests: `test/presentation/screens/onboarding/onboarding_age_screen_test.dart`

---

## Dependencies

- Story 2.4 (Weight screen) doit être complétée

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
- Previous: [story-2.4-onboarding-weight-screen.md](story-2.4-onboarding-weight-screen.md)
- Next: [story-2.6-onboarding-gender-screen.md](story-2.6-onboarding-gender-screen.md)
