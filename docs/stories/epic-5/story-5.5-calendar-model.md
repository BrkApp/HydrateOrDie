# Story 5.5: Modèle de Données Calendrier Historique

**Epic:** Epic 5 - Progression & Rétention (Streaks & Historique)
**Story ID:** 5.5
**Status:** Not Started
**Priority:** High
**Estimated Effort:** 3 hours

---

## User Story

**As a** developer,
**I want** une structure de données pour le calendrier historique,
**so that** je peux afficher les jours atteints/ratés.

---

## Acceptance Criteria

1. La classe `DayStatus` contient : `date` (DateTime), `goalAchieved` (bool), `volumeDrank` (double), `goalVolume` (double)
2. Une méthode helper `getMonthStatus(year, month)` retourne une liste de `DayStatus` pour tous les jours du mois
3. La méthode interroge `HydrationLogRepository` pour obtenir le volume par jour
4. La méthode compare `volumeDrank` vs `goalVolume` (depuis `UserProfile`) pour déterminer `goalAchieved`
5. Les jours futurs retournent `goalAchieved = null` (non applicable)
6. Tests unitaires valident le calcul pour un mois complet avec différents scénarios

---

## Technical Notes

- Location: `lib/data/models/day_status.dart`
- Helper: `lib/domain/usecases/get_month_status_usecase.dart`
- Dependencies: HydrationLogRepository, UserProfileRepository
- Tests: `test/domain/usecases/get_month_status_usecase_test.dart`

---

## Dependencies

- Story 3.2 (HydrationLog repository) doit être complétée
- Story 2.3 (UserProfile repository) doit être complétée

---

## Definition of Done

- [ ] Tous les AC validés
- [ ] Tests unitaires passent
- [ ] Month calculation correct
- [ ] Future dates handled
- [ ] Code suit conventions
- [ ] PM approval

---

## Links

- Epic: [epic-5-progression.md](../../epics/epic-5-progression.md)
- Previous: [story-5.4-streak-display.md](story-5.4-streak-display.md)
- Next: [story-5.6-calendar-screen.md](story-5.6-calendar-screen.md)
