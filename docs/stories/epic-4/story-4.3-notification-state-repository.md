# Story 4.3: Repository Notification State

**Epic:** Epic 4 - Système de Notifications Punitives
**Story ID:** 4.3
**Status:** Not Started
**Priority:** Critical
**Estimated Effort:** 3 hours

---

## User Story

**As a** developer,
**I want** un repository pour persister l'état des notifications,
**so that** le niveau d'escalade est sauvegardé entre les sessions.

---

## Acceptance Criteria

1. La classe `NotificationStateRepository` implémente : `saveState()`, `getState()`, `resetState()`, `incrementNotificationCount()`
2. Le repository utilise `shared_preferences` pour stocker l'état de notification
3. La méthode `getState()` retourne l'état sauvegardé ou un état par défaut (`calm`, 0 notifications) si nouveau jour
4. La méthode `resetState()` réinitialise le niveau à `calm` et `notificationsSentToday` à 0
5. Le repository détecte automatiquement le changement de jour et reset l'état
6. Le repository est injectable via `get_it`
7. Tests unitaires couvrent CRUD complet et détection changement de jour

---

## Technical Notes

- Location: `lib/data/repositories/notification_state_repository.dart`
- Interface: `lib/domain/repositories/notification_state_repository.dart`
- Storage: `shared_preferences`
- Tests: `test/data/repositories/notification_state_repository_test.dart`

---

## Dependencies

- Story 4.1 (NotificationState model) doit être complétée
- Package `shared_preferences` doit être ajouté

---

## Definition of Done

- [ ] Tous les AC validés
- [ ] Tests unitaires passent
- [ ] Day detection fonctionne
- [ ] Repository injectable
- [ ] Code suit conventions
- [ ] PM approval

---

## Links

- Epic: [epic-4-notifications.md](../../epics/epic-4-notifications.md)
- Previous: [story-4.2-escalation-algorithm.md](story-4.2-escalation-algorithm.md)
- Next: [story-4.4-personalized-messages.md](story-4.4-personalized-messages.md)
