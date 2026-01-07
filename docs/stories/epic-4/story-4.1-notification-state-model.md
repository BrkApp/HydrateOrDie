# Story 4.1: Modèle de Données Notification System

**Epic:** Epic 4 - Système de Notifications Punitives
**Story ID:** 4.1
**Status:** Not Started
**Priority:** Critical
**Estimated Effort:** 2 hours

---

## User Story

**As a** developer,
**I want** un data model pour gérer l'état du système de notifications,
**so that** je peux tracker le niveau d'escalade et le timing des notifications.

---

## Acceptance Criteria

1. La classe `NotificationState` contient les propriétés : `currentLevel` (enum), `lastNotificationTime` (DateTime), `notificationsSentToday` (int), `userLastDrinkTime` (DateTime)
2. L'enum `NotificationLevel` définit les 4 niveaux : `calm`, `concerned`, `dramatic`, `chaos`
3. Le model inclut une méthode `shouldEscalate()` retournant bool basé sur le temps écoulé
4. Le model inclut une méthode `getNextLevel()` pour progression niveau
5. Le model inclut une méthode `reset()` pour réinitialiser à `calm` après hydratation
6. Le model a des méthodes `toJson()` et `fromJson()` pour sérialisation
7. Tests unitaires couvrent 100% du model (création, logique escalade, reset)

---

## Technical Notes

- Location: `lib/data/models/notification_state.dart`
- Enum: `lib/data/models/notification_level.dart`
- Tests: `test/data/models/notification_state_test.dart`

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

- Epic: [epic-4-notifications.md](../../epics/epic-4-notifications.md)
- Previous: [story-3.10-camera-permissions.md](../epic-3/story-3.10-camera-permissions.md)
- Next: [story-4.2-escalation-algorithm.md](story-4.2-escalation-algorithm.md)
