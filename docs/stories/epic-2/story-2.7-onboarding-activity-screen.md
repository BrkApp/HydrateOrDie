# Story 2.7: Écran Onboarding Question Activité Physique

**Epic:** Epic 2 - Onboarding & Personnalisation
**Story ID:** 2.7
**Status:** Not Started
**Priority:** High
**Estimated Effort:** 4 hours

---

## User Story

**As a** new user,
**I want** indiquer mon niveau d'activité physique lors de l'onboarding,
**so that** l'app calcule un objectif adapté à mon mode de vie.

---

## Acceptance Criteria

1. L'écran `OnboardingActivityScreen` s'affiche après l'écran genre
2. L'écran affiche : titre "Niveau d'activité physique", sous-titre "À quelle fréquence fais-tu du sport ?"
3. Cinq options sous forme de cards : "Sédentaire (peu ou pas d'exercice)", "Léger (1-3x/semaine)", "Modéré (3-5x/semaine)", "Très actif (6-7x/semaine)", "Extrêmement actif (sport intense quotidien)"
4. Chaque card affiche un icon visuel + label + description courte
5. L'option sélectionnée est highlight visuellement
6. Bouton "Suivant" activé seulement si une option est sélectionnée
7. Indicateur de progression "4/5" visible
8. Widget test valide la sélection et navigation

---

## Technical Notes

- Location: `lib/presentation/screens/onboarding/onboarding_activity_screen.dart`
- UI: Scrollable list of cards with icons
- Icons: Use relevant fitness icons
- Tests: `test/presentation/screens/onboarding/onboarding_activity_screen_test.dart`

---

## Dependencies

- Story 2.6 (Gender screen) doit être complétée
- Story 2.1 (ActivityLevel enum) doit être complétée

---

## Definition of Done

- [ ] Tous les AC validés
- [ ] Widget tests passent
- [ ] Selection UI fonctionne
- [ ] Icons appropriés
- [ ] Code suit conventions
- [ ] Navigation testée
- [ ] PM approval

---

## Links

- Epic: [epic-2-onboarding.md](../../epics/epic-2-onboarding.md)
- Previous: [story-2.6-onboarding-gender-screen.md](story-2.6-onboarding-gender-screen.md)
- Next: [story-2.8-onboarding-location-screen.md](story-2.8-onboarding-location-screen.md)
