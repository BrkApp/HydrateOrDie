# Story 4.7: Pause Automatique Notifications Nocturnes

**Epic:** Epic 4 - Système de Notifications Punitives
**Story ID:** 4.7
**Status:** Not Started
**Priority:** High
**Estimated Effort:** 4 hours

---

## User Story

**As a** user,
**I want** que les notifications s'arrêtent automatiquement la nuit,
**so that** je peux dormir sans être dérangé.

---

## Acceptance Criteria

1. Les notifications ne sont PAS envoyées entre 22h00 et 7h00 (heure locale par défaut)
2. Les horaires de pause sont configurables dans les paramètres : "Heure début pause", "Heure fin pause"
3. Les paramètres sont sauvegardés dans `shared_preferences`
4. Le use case `ScheduleNotificationUseCase` vérifie l'heure actuelle avant de scheduler
5. Si dans la fenêtre de pause, la notification est reportée à la fin de la pause (7h00 par défaut)
6. Un message dans les paramètres explique : "Les notifications seront en pause pendant tes heures de sommeil"
7. Tests unitaires valident que les notifications sont bien bloquées pendant la pause
8. Tests valident que les notifications reprennent après la fin de la pause

---

## Technical Notes

- Location: Update `lib/domain/usecases/schedule_notification_usecase.dart`
- Settings storage: `shared_preferences`
- Time check: Use DateTime.now().hour
- Tests: `test/domain/usecases/schedule_notification_usecase_test.dart`

---

## Dependencies

- Story 4.5 (Notification scheduling) doit être complétée

---

## Definition of Done

- [ ] Tous les AC validés
- [ ] Tests unitaires passent
- [ ] Pause nocturne fonctionne
- [ ] Settings UI créé
- [ ] Code suit conventions
- [ ] PM approval

---

## Links

- Epic: [epic-4-notifications.md](../../epics/epic-4-notifications.md)
- Previous: [story-4.6-chaos-vibrations.md](story-4.6-chaos-vibrations.md)
- Next: [story-4.8-notification-permissions.md](story-4.8-notification-permissions.md)
