# Story 5.2: Logique Calcul Streak Quotidien

**Epic:** Epic 5 - Progression & Rétention (Streaks & Historique)
**Story ID:** 5.2
**Status:** Not Started
**Priority:** Critical
**Estimated Effort:** 4 hours

---

## User Story

**As a** user,
**I want** que mon streak augmente automatiquement si j'atteins mon objectif quotidien,
**so that** je vois ma progression sans action manuelle.

---

## Acceptance Criteria

1. Le use case `UpdateStreakUseCase` est appelé à minuit (00h00) chaque jour via background job
2. Le use case vérifie si l'objectif hydratation de la veille a été atteint via `HydrationLogRepository.getTotalVolumeForDate(yesterday)`
3. Si objectif atteint : `StreakData.incrementStreak(yesterday)` est appelé
4. Si objectif raté : `StreakData.breakStreak()` est appelé
5. Le streak est également vérifié à chaque ouverture de l'app (catch-up si app pas ouverte à minuit)
6. Si l'avatar est mort le jour précédent (état `ghost`), le streak NE s'incrémente PAS (pénalité)
7. Tests unitaires valident tous les scénarios : objectif atteint, raté, avatar mort, plusieurs jours consécutifs

---

## Technical Notes

- Location: `lib/domain/usecases/update_streak_usecase.dart`
- Background: Called by daily job and on app open
- Dependencies: HydrationLogRepository, AvatarRepository, UserProfileRepository
- Tests: `test/domain/usecases/update_streak_usecase_test.dart`

---

## Dependencies

- Story 5.1 (StreakData model) doit être complétée
- Story 3.2 (HydrationLog repository) doit être complétée
- Story 2.3 (UserProfile repository) doit être complétée

---

## Definition of Done

- [ ] Tous les AC validés
- [ ] Tests unitaires passent
- [ ] All scenarios tested
- [ ] Ghost penalty works
- [ ] Code suit conventions
- [ ] PM approval

---

## Links

- Epic: [epic-5-progression.md](../../epics/epic-5-progression.md)
- Previous: [story-5.1-streak-model.md](story-5.1-streak-model.md)
- Next: [story-5.3-streak-repository.md](story-5.3-streak-repository.md)
