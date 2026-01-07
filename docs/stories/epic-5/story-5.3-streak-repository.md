# Story 5.3: Repository Streak

**Epic:** Epic 5 - Progression & Rétention (Streaks & Historique)
**Story ID:** 5.3
**Status:** Not Started
**Priority:** Critical
**Estimated Effort:** 2 hours

---

## User Story

**As a** developer,
**I want** un repository pour persister les données de streak,
**so that** le compteur est sauvegardé entre les sessions.

---

## Acceptance Criteria

1. La classe `StreakRepository` implémente : `saveStreak()`, `getStreak()`, `resetStreak()`
2. Le repository utilise `shared_preferences` pour stocker les données de streak
3. La méthode `getStreak()` retourne le streak sauvegardé ou un streak par défaut (0 jours) si nouveau user
4. Le repository est injectable via `get_it`
5. Tests unitaires couvrent CRUD complet (save, get, reset)

---

## Technical Notes

- Location: `lib/data/repositories/streak_repository.dart`
- Interface: `lib/domain/repositories/streak_repository.dart`
- Storage: `shared_preferences`
- Tests: `test/data/repositories/streak_repository_test.dart`

---

## Dependencies

- Story 5.1 (StreakData model) doit être complétée
- Package `shared_preferences` doit être disponible

---

## Definition of Done

- [ ] Tous les AC validés
- [ ] Tests unitaires passent
- [ ] Repository injectable
- [ ] Code suit conventions
- [ ] PM approval

---

## Links

- Epic: [epic-5-progression.md](../../epics/epic-5-progression.md)
- Previous: [story-5.2-streak-calculation.md](story-5.2-streak-calculation.md)
- Next: [story-5.4-streak-display.md](story-5.4-streak-display.md)
