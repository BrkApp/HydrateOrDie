# Story 3.9: Sélection Taille de Verre

**Epic:** Epic 3 - Validation Photo & Feedback Positif
**Story ID:** 3.9
**Status:** Ready for Review
**Priority:** High
**Estimated Effort:** 3 hours
**Actual Effort:** 2.5 hours

---

## User Story

**As a** user,
**I want** indiquer la taille de mon verre après la photo,
**so that** le volume enregistré correspond à ce que j'ai réellement bu.

---

## Acceptance Criteria

1. Après capture photo (Story 3.4), un écran `GlassSizeSelectionScreen` s'affiche immédiatement
   - Navigation depuis: `PhotoValidationScreen` après `_capturePhoto()` réussie
   - Parameters passés: `photoPath` (String) du fichier sauvegardé
   - Note: Story 3.5 (détection verre) est optionnelle et non implémentée pour MVP
2. L'écran affiche trois options : "Petit verre (200ml)", "Verre moyen (250ml)", "Grand verre (400ml)"
   - UI: 3 Cards verticales avec tap gesture
   - Texte: Labels français avec volumes en ml
3. Chaque option affiche un icon visuel de verre proportionnel à la taille
   - Small: Icon verre 24x32 dp
   - Medium: Icon verre 28x40 dp
   - Large: Icon verre 32x48 dp
   - Icons: Material Icons (local_drink) avec scale différente OU custom assets
4. L'option "Verre moyen" (250ml) est pré-sélectionnée visuellement par défaut
   - Indication visuelle: Border bleu primaire + checkmark icon
   - Utilisateur peut changer sélection avant validation
5. Taper une option la sélectionne ET appelle immédiatement `RecordHydrationUseCase` puis navigue vers écran de transition
   - Flow: Tap → Record log → Navigate to FeedbackScreen (Story 3.7 si implémentée) OU retour HomeScreen
   - Parameters: photoPath + glassSize sélectionné
6. Le `glassSize` sélectionné est passé au `RecordHydrationUseCase.execute(photoPath, glassSize)` pour enregistrement
   - Use case crée HydrationLog avec volume calculé depuis glassSize
   - Enregistrement synchrone (await) avant navigation
7. Widget test valide la sélection et la navigation
   - Test: 3 options affichées avec labels corrects
   - Test: Medium pré-sélectionné par défaut
   - Test: Tap change sélection
   - Test: Tap appelle RecordHydrationUseCase avec bon glassSize
   - Test: Navigation vers FeedbackScreen après enregistrement

---

## Technical Notes

- Location: `lib/presentation/screens/photo/glass_size_selection_screen.dart`
- UI: Cards with glass icons
- Default: Medium (250ml)
- Tests: `test/presentation/screens/photo/glass_size_selection_screen_test.dart`

---

## Dependencies

- Story 3.1 (GlassSize enum) doit être complétée
- Story 3.4 (Photo capture storage) doit être complétée (fournit photoPath)
- Story 3.6 (RecordHydrationUseCase) doit être complétée (appelé depuis 3.9)
- Story 3.7 (Feedback screen) optionnelle pour MVP (si non implémentée: retour HomeScreen)

---

## Definition of Done

- [x] Tous les AC validés
- [x] Widget tests passent (12/12 tests OK)
- [x] Selection UI fonctionne
- [x] Icons appropriés (Material Icons local_drink avec scales)
- [x] Navigation OK (PhotoValidation → GlassSize → Home)
- [x] Code suit conventions (flutter analyze: 0 issues)
- [ ] PM approval

---

## Links

- Epic: [epic-3-photo-validation.md](../../epics/epic-3-photo-validation.md)
- Previous: [story-3.8-drink-button.md](story-3.8-drink-button.md)
- Next: [story-3.10-camera-permissions.md](story-3.10-camera-permissions.md)
