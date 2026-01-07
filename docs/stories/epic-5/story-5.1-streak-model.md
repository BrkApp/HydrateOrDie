# Story 5.1: Modèle de Données Streak

**Epic:** Epic 5 - Progression & Rétention (Streaks & Historique)
**Story ID:** 5.1
**Status:** Not Started
**Priority:** Critical
**Estimated Effort:** 2 hours

---

## User Story

**As a** developer,
**I want** un data model pour gérer les streaks,
**so that** je peux tracker les jours consécutifs d'objectif atteint.

---

## Acceptance Criteria

1. La classe `StreakData` contient les propriétés : `currentStreak` (int), `longestStreak` (int), `lastStreakDate` (DateTime), `streakActive` (bool)
2. Le model inclut une méthode `incrementStreak(date)` qui incrémente le streak si date = hier + 1 jour
3. Le model inclut une méthode `breakStreak()` qui reset `currentStreak` à 0 et `streakActive` à false
4. Le model inclut une méthode `isStreakActiveToday()` retournant bool (vérifie si objectif atteint aujourd'hui)
5. Le model met à jour `longestStreak` si `currentStreak` > `longestStreak`
6. Le model a des méthodes `toJson()` et `fromJson()` pour sérialisation
7. Tests unitaires couvrent 100% du model (increment, break, longest streak update)

---

## Technical Notes

- Location: `lib/data/models/streak_data.dart`
- Tests: `test/data/models/streak_data_test.dart`

---

## Dependencies

- Epic 1 foundation doit être complété

---

## Definition of Done

- [ ] Tous les AC validés
- [ ] Tests unitaires 100% coverage
- [ ] Code suit conventions
- [ ] Dartdoc complet
- [ ] PM approval

---

## Links

- Epic: [epic-5-progression.md](../../epics/epic-5-progression.md)
- Previous: [story-4.11-notification-settings-screen.md](../epic-4/story-4.11-notification-settings-screen.md)
- Next: [story-5.2-streak-calculation.md](story-5.2-streak-calculation.md)
