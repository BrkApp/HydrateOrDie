# Story 3.8: Bouton "Je bois" sur HomeScreen

**Epic:** Epic 3 - Validation Photo & Feedback Positif
**Story ID:** 3.8
**Status:** Not Started
**Priority:** Critical
**Estimated Effort:** 2 hours

---

## User Story

**As a** user,
**I want** un bouton clair et accessible sur l'écran principal pour valider mon hydratation,
**so that** l'action principale est toujours à portée de main.

---

## Acceptance Criteria

1. Le HomeScreen (Epic 1) affiche un bouton primaire proéminent "Je bois 💧" en bas de l'écran
2. Le bouton utilise la couleur primaire de l'app (bleu hydratation) et est suffisamment large (taille minimum 60dp hauteur pour accessibilité)
3. Taper le bouton ouvre immédiatement le `PhotoValidationScreen` (Story 3.3)
4. Le bouton reste accessible même si l'avatar est en état `dead` ou `ghost` (permet de ressusciter plus tôt)
5. Si l'objectif quotidien est déjà atteint, le bouton affiche "Je bois encore +" (permet de dépasser l'objectif)
6. Widget test valide l'affichage du bouton et la navigation vers PhotoValidationScreen

---

## Technical Notes

- Location: Update `lib/presentation/screens/home/home_screen.dart`
- Button widget: Custom or Material ElevatedButton
- Navigation: Push to PhotoValidationScreen
- Tests: Update `test/presentation/screens/home/home_screen_test.dart`

---

## Dependencies

- Story 1.6 (HomeScreen) doit être complétée
- Story 3.3 (PhotoValidation screen) doit être complétée

---

## Definition of Done

- [ ] Tous les AC validés
- [ ] Widget tests passent
- [ ] Button accessible
- [ ] Navigation fonctionne
- [ ] Code suit conventions
- [ ] PM approval

---

## Links

- Epic: [epic-3-photo-validation.md](../../epics/epic-3-photo-validation.md)
- Previous: [story-3.7-avatar-feedback-animation.md](story-3.7-avatar-feedback-animation.md)
- Next: [story-3.9-glass-size-selection.md](story-3.9-glass-size-selection.md)
