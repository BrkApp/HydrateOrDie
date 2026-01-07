# Story 4.2: Algorithme Escalade Progressive

**Epic:** Epic 4 - Système de Notifications Punitives
**Story ID:** 4.2
**Status:** Not Started
**Priority:** Critical
**Estimated Effort:** 4 hours

---

## User Story

**As a** product owner,
**I want** que les notifications évoluent progressivement selon le temps écoulé,
**so that** l'utilisateur ressent une pression croissante mais pas immédiate.

---

## Acceptance Criteria

1. Le use case `CalculateNotificationLevelUseCase` détermine le niveau basé sur le temps écoulé depuis `lastDrinkTime`
2. La progression suit : Calm (0-2h), Concerned (2h-4h), Dramatic (4h-6h), Chaos (6h+)
3. Chaque niveau a une fréquence différente : Calm (1x/heure), Concerned (1x/30min), Dramatic (1x/15min), Chaos (spam 5-10min aléatoire)
4. Le niveau ne peut pas redescendre sans action utilisateur (escalade unidirectionnelle dans la journée)
5. À minuit, le niveau reset automatiquement à `calm` (nouveau jour = fresh start)
6. Le calcul prend en compte le dernier `lastDrinkTime` depuis `AvatarRepository`
7. Tests unitaires valident la progression pour différentes durées (0h, 1h, 3h, 5h, 7h)
8. Tests valident que le niveau ne redescend pas sans hydratation

---

## Technical Notes

- Location: `lib/domain/usecases/calculate_notification_level_usecase.dart`
- Dependencies: AvatarRepository for lastDrinkTime
- Tests: `test/domain/usecases/calculate_notification_level_usecase_test.dart`

---

## Dependencies

- Story 4.1 (NotificationState model) doit être complétée
- Story 1.3 (Avatar repository) doit être complétée

---

## Definition of Done

- [ ] Tous les AC validés
- [ ] Tests unitaires couvrent tous les cas
- [ ] Escalation logic correcte
- [ ] Code suit conventions
- [ ] PM approval

---

## Links

- Epic: [epic-4-notifications.md](../../epics/epic-4-notifications.md)
- Previous: [story-4.1-notification-state-model.md](story-4.1-notification-state-model.md)
- Next: [story-4.3-notification-state-repository.md](story-4.3-notification-state-repository.md)
