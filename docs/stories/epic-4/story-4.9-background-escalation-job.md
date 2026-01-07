# Story 4.9: Background Job Update Niveau Escalade

**Epic:** Epic 4 - Système de Notifications Punitives
**Story ID:** 4.9
**Status:** Not Started
**Priority:** High
**Estimated Effort:** 5 hours

---

## User Story

**As a** developer,
**I want** un background job qui met à jour le niveau d'escalade périodiquement,
**so that** les notifications reflètent le temps réel écoulé.

---

## Acceptance Criteria

1. Un `Timer.periodic` avec intervalle de 15 minutes vérifie le temps écoulé depuis `lastDrinkTime`
2. Le timer appelle `CalculateNotificationLevelUseCase` pour recalculer le niveau actuel
3. Si le niveau a changé (escalade), les notifications schedulées sont annulées et re-schedulées avec la nouvelle fréquence
4. Le timer est initialisé au lancement de l'app et tourne en background
5. Le timer est annulé proprement lors de la fermeture de l'app (cleanup)
6. Le niveau mis à jour est sauvegardé via `NotificationStateRepository`
7. Tests unitaires valident la logique du timer et le re-scheduling
8. Test d'intégration valide que le timer fonctionne réellement en background

---

## Technical Notes

- Location: `lib/core/services/notification_service.dart`
- Timer: Use `Timer.periodic` with 15-minute interval
- Cleanup: Dispose timer properly
- Tests: `test/core/services/notification_service_test.dart`

---

## Dependencies

- Story 4.2 (Escalation algorithm) doit être complétée
- Story 4.5 (Notification scheduling) doit être complétée
- Story 4.3 (Notification state repository) doit être complétée

---

## Definition of Done

- [ ] Tous les AC validés
- [ ] Tests unitaires passent
- [ ] Test d'intégration passe
- [ ] Timer fonctionne en background
- [ ] Re-scheduling correct
- [ ] Code suit conventions
- [ ] PM approval

---

## Links

- Epic: [epic-4-notifications.md](../../epics/epic-4-notifications.md)
- Previous: [story-4.8-notification-permissions.md](story-4.8-notification-permissions.md)
- Next: [story-4.10-notification-analytics.md](story-4.10-notification-analytics.md)
