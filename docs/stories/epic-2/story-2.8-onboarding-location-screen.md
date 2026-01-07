# Story 2.8: Écran Onboarding Permission Localisation

**Epic:** Epic 2 - Onboarding & Personnalisation
**Story ID:** 2.8
**Status:** Not Started
**Priority:** Medium
**Estimated Effort:** 3 hours

---

## User Story

**As a** new user,
**I want** choisir si j'autorise la localisation,
**so that** l'app peut ajuster les rappels en fonction de la météo (V2 feature).

---

## Acceptance Criteria

1. L'écran `OnboardingLocationScreen` s'affiche après l'écran activité
2. L'écran affiche : titre "Autoriser la localisation ?", sous-titre "Optionnel : permettra d'ajuster les rappels en fonction de la météo (canicule)"
3. Deux options : "Autoriser" (bouton primaire) et "Pas maintenant" (bouton secondaire)
4. Si "Autoriser" : demande la permission système via `permission_handler`, puis navigue suivant
5. Si "Pas maintenant" : enregistre `locationPermissionGranted = false`, navigue suivant
6. Indicateur de progression "5/5" visible
7. Les deux options permettent de progresser (pas bloquant)
8. Widget test valide les deux flows (autoriser et refuser)

---

## Technical Notes

- Location: `lib/presentation/screens/onboarding/onboarding_location_screen.dart`
- Package: `permission_handler`
- Tests: `test/presentation/screens/onboarding/onboarding_location_screen_test.dart`

---

## Dependencies

- Story 2.7 (Activity screen) doit être complétée
- Package `permission_handler` doit être ajouté

---

## Definition of Done

- [ ] Tous les AC validés
- [ ] Widget tests passent
- [ ] Permission handling fonctionne
- [ ] Code suit conventions
- [ ] Les deux flows testés
- [ ] PM approval

---

## Links

- Epic: [epic-2-onboarding.md](../../epics/epic-2-onboarding.md)
- Previous: [story-2.7-onboarding-activity-screen.md](story-2.7-onboarding-activity-screen.md)
- Next: [story-2.9-onboarding-summary-screen.md](story-2.9-onboarding-summary-screen.md)
