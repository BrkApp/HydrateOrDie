# Story 3.2: Repository Historique Hydratation

**Epic:** Epic 3 - Validation Photo & Feedback Positif
**Story ID:** 3.2
**Status:** Not Started
**Priority:** Critical
**Estimated Effort:** 4 hours

---

## User Story

**As a** developer,
**I want** un repository pour persister l'historique des validations,
**so that** la progression quotidienne est sauvegardée et calculable.

---

## Acceptance Criteria

1. La classe `HydrationLogRepository` implémente : `addLog()`, `getLogsForDate()`, `getTodayLogs()`, `getTotalVolumeForDate()`, `deleteOldLogs()`
2. Le repository utilise `sqflite` pour stocker les logs dans une table `hydration_logs`
3. Le schéma de table inclut toutes les propriétés du `HydrationLog` model + index sur `timestamp`
4. La méthode `getTodayLogs()` retourne tous les logs du jour actuel (00h00 - 23h59 UTC locale)
5. La méthode `getTotalVolumeForDate(date)` somme tous les volumes pour la date donnée
6. La méthode `deleteOldLogs()` supprime les logs de plus de 90 jours (RGPD + performance)
7. Le repository est injectable via `get_it`
8. Tests unitaires couvrent tous les scénarios (add, get today, get by date, volume calculation, delete old)
9. Tests d'intégration valident la persistence réelle et les requêtes de date

---

## Technical Notes

- Location: `lib/data/repositories/hydration_log_repository.dart`
- Interface: `lib/domain/repositories/hydration_log_repository.dart`
- Tests: `test/data/repositories/hydration_log_repository_test.dart`
- Database: sqflite with proper indexes

---

## Dependencies

- Story 3.1 (HydrationLog model) doit être complétée
- Package `sqflite` doit être ajouté

---

## Definition of Done

- [ ] Tous les AC validés
- [ ] Tests unitaires passent
- [ ] Tests d'intégration passent
- [ ] Code suit conventions
- [ ] Repository injectable via get_it
- [ ] PM approval

---

## Links

- Epic: [epic-3-photo-validation.md](../../epics/epic-3-photo-validation.md)
- Previous: [story-3.1-hydration-log-model.md](story-3.1-hydration-log-model.md)
- Next: [story-3.3-camera-interface.md](story-3.3-camera-interface.md)
