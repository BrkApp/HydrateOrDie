# Story 5.10: Changement d'Avatar Post-Onboarding

**Epic:** Epic 5 - Progression & Rétention (Streaks & Historique)
**Story ID:** 5.10
**Status:** Not Started
**Priority:** Medium
**Estimated Effort:** 3 hours

---

## User Story

**As a** user,
**I want** pouvoir changer d'avatar après l'onboarding,
**so that** je peux essayer différentes personnalités.

---

## Acceptance Criteria

1. Un écran `ChangeAvatarScreen` accessible depuis `ProfileScreen` ou `SettingsScreen`
2. L'écran réutilise le composant `AvatarSelectionScreen` (Epic 1)
3. L'avatar actuellement sélectionné est highlight visuellement
4. Taper sur un nouvel avatar et confirmer sauvegarde la sélection via `AvatarRepository`
5. L'avatar change immédiatement sur le HomeScreen après confirmation
6. **IMPORTANT** : Changer d'avatar ne reset PAS le streak ni l'historique (continuité)
7. Un message de confirmation s'affiche : "[Nouveau nom avatar] est maintenant ton compagnon d'hydratation !"
8. Widget test valide le flow de changement et la sauvegarde

---

## Technical Notes

- Location: `lib/presentation/screens/avatar/change_avatar_screen.dart`
- Reuse: AvatarSelectionScreen component
- Repository: Save via AvatarRepository
- Important: DO NOT reset streak or history
- Tests: `test/presentation/screens/avatar/change_avatar_screen_test.dart`

---

## Dependencies

- Story 1.8 (Avatar selection) doit être complétée
- Story 1.3 (Avatar repository) doit être complétée
- Story 5.7 (Profile screen) doit être complétée

---

## Definition of Done

- [ ] Tous les AC validés
- [ ] Widget tests passent
- [ ] Avatar changes correctly
- [ ] Streak NOT reset
- [ ] Confirmation shown
- [ ] Code suit conventions
- [ ] PM approval

---

## Links

- Epic: [epic-5-progression.md](../../epics/epic-5-progression.md)
- Previous: [story-5.9-edit-profile.md](story-5.9-edit-profile.md)
- Next: [story-5.11-achievements.md](story-5.11-achievements.md)
