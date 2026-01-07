# Story 5.4: Affichage Streak sur HomeScreen

**Epic:** Epic 5 - Progression & Rétention (Streaks & Historique)
**Story ID:** 5.4
**Status:** Not Started
**Priority:** High
**Estimated Effort:** 4 hours

---

## User Story

**As a** user,
**I want** voir mon streak actuel sur l'écran principal,
**so that** je suis motivé à le maintenir.

---

## Acceptance Criteria

1. Le HomeScreen affiche un widget `StreakDisplay` en haut de l'écran (header position)
2. Le widget affiche : flame icon 🔥 + nombre de jours + label "jour(s) de suite"
3. Si `currentStreak` = 0 : affiche "Commence ton streak aujourd'hui ! 🔥"
4. Si `currentStreak` >= 7 : le flame icon change pour 🔥🔥 (double flame)
5. Si `currentStreak` >= 30 : le flame icon change pour 🏆 (trophée)
6. Le widget est tapable et ouvre un modal affichant : `currentStreak`, `longestStreak`, et un message motivant
7. Widget test valide l'affichage pour différentes valeurs de streak (0, 5, 10, 30)

---

## Technical Notes

- Location: `lib/presentation/widgets/streak_display.dart`
- Update: Modify HomeScreen to include StreakDisplay
- Modal: Simple dialog showing stats
- Tests: `test/presentation/widgets/streak_display_test.dart`

---

## Dependencies

- Story 5.3 (Streak repository) doit être complétée
- Story 1.6 (HomeScreen) doit être complétée

---

## Definition of Done

- [ ] Tous les AC validés
- [ ] Widget tests passent
- [ ] Display looks good
- [ ] Modal works
- [ ] Icons change correctly
- [ ] Code suit conventions
- [ ] PM approval

---

## Links

- Epic: [epic-5-progression.md](../../epics/epic-5-progression.md)
- Previous: [story-5.3-streak-repository.md](story-5.3-streak-repository.md)
- Next: [story-5.5-calendar-model.md](story-5.5-calendar-model.md)
