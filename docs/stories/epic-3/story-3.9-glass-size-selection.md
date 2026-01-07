# Story 3.9: Sélection Taille de Verre

**Epic:** Epic 3 - Validation Photo & Feedback Positif
**Story ID:** 3.9
**Status:** Not Started
**Priority:** High
**Estimated Effort:** 3 hours

---

## User Story

**As a** user,
**I want** indiquer la taille de mon verre après la photo,
**so that** le volume enregistré correspond à ce que j'ai réellement bu.

---

## Acceptance Criteria

1. Après capture photo (et avant/après validation photo), un écran `GlassSizeSelectionScreen` s'affiche
2. L'écran affiche trois options : "Petit verre (200ml)", "Verre moyen (250ml)", "Grand verre (400ml)"
3. Chaque option affiche un icon visuel de verre proportionnel à la taille
4. L'option "Verre moyen" est pré-sélectionnée par défaut
5. Taper une option la sélectionne et navigue vers FeedbackScreen (Story 3.7)
6. Le `glassSize` sélectionné est passé au `RecordHydrationUseCase` pour enregistrement
7. Widget test valide la sélection et la navigation

---

## Technical Notes

- Location: `lib/presentation/screens/photo/glass_size_selection_screen.dart`
- UI: Cards with glass icons
- Default: Medium (250ml)
- Tests: `test/presentation/screens/photo/glass_size_selection_screen_test.dart`

---

## Dependencies

- Story 3.1 (GlassSize enum) doit être complétée
- Story 3.3 (Photo validation) doit être complétée
- Story 3.7 (Feedback screen) doit être complétée

---

## Definition of Done

- [ ] Tous les AC validés
- [ ] Widget tests passent
- [ ] Selection UI fonctionne
- [ ] Icons appropriés
- [ ] Navigation OK
- [ ] Code suit conventions
- [ ] PM approval

---

## Links

- Epic: [epic-3-photo-validation.md](../../epics/epic-3-photo-validation.md)
- Previous: [story-3.8-drink-button.md](story-3.8-drink-button.md)
- Next: [story-3.10-camera-permissions.md](story-3.10-camera-permissions.md)
