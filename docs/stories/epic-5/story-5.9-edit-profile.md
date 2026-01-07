# Story 5.9: Modification Profil et Recalcul Objectif

**Epic:** Epic 5 - Progression & Rétention (Streaks & Historique)
**Story ID:** 5.9
**Status:** Not Started
**Priority:** Medium
**Estimated Effort:** 4 hours

---

## User Story

**As a** user,
**I want** pouvoir modifier mes informations de profil,
**so that** mon objectif d'hydratation reste adapté si je change (poids, activité, etc.).

---

## Acceptance Criteria

1. Un écran `EditProfileScreen` accessible depuis `SettingsScreen`
2. L'écran affiche des champs éditables pour : Poids, Âge, Sexe, Niveau d'activité
3. Les champs sont pré-remplis avec les valeurs actuelles du profil
4. Les validations sont identiques à l'onboarding (ranges valides)
5. Un bouton "Enregistrer" sauvegarde les modifications via `UserProfileRepository.updateProfile()`
6. Après sauvegarde, l'objectif hydratation est recalculé automatiquement via `CalculateHydrationGoalUseCase`
7. Un message de confirmation s'affiche : "Profil mis à jour ! Nouvel objectif : X.XL/jour"
8. Widget test valide l'édition et la sauvegarde du profil

---

## Technical Notes

- Location: `lib/presentation/screens/profile/edit_profile_screen.dart`
- Reuse: Onboarding validation logic
- Recalculation: Call CalculateHydrationGoalUseCase on save
- Tests: `test/presentation/screens/profile/edit_profile_screen_test.dart`

---

## Dependencies

- Story 5.8 (Settings screen) doit être complétée
- Story 2.3 (UserProfile repository) doit être complétée
- Story 2.2 (Calculate hydration goal) doit être complétée

---

## Definition of Done

- [ ] Tous les AC validés
- [ ] Widget tests passent
- [ ] Validation works
- [ ] Goal recalculated
- [ ] Confirmation message shown
- [ ] Code suit conventions
- [ ] PM approval

---

## Links

- Epic: [epic-5-progression.md](../../epics/epic-5-progression.md)
- Previous: [story-5.8-settings-screen.md](story-5.8-settings-screen.md)
- Next: [story-5.10-change-avatar.md](story-5.10-change-avatar.md)
