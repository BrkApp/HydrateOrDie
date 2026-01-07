# Story 4.10: Analytics Notifications

**Epic:** Epic 4 - Système de Notifications Punitives
**Story ID:** 4.10
**Status:** Not Started
**Priority:** Medium
**Estimated Effort:** 3 hours

---

## User Story

**As a** product owner,
**I want** tracker les métriques de notifications,
**so that** je peux analyser l'efficacité du système.

---

## Acceptance Criteria

1. Chaque notification envoyée logge un event analytics : `notification_sent` avec propriétés : `level`, `personality`, `timeSinceLastDrink`
2. Chaque tap sur notification logge : `notification_opened` avec mêmes propriétés
3. Le taux de dismiss (notification fermée sans action) est trackable via analytics
4. À la fin de la journée, un event summary logge : `daily_notification_summary` avec : `totalSent`, `maxLevelReached`, `notificationsThatTriggeredHydration`
5. Les analytics utilisent Firebase Analytics (anonymisées)
6. Tests unitaires valident que les events sont loggés aux bons moments

---

## Technical Notes

- Location: Add analytics to `lib/domain/usecases/schedule_notification_usecase.dart`
- Package: `firebase_analytics`
- Events: notification_sent, notification_opened, daily_notification_summary
- Privacy: Ensure data is anonymized
- Tests: Mock analytics in tests

---

## Dependencies

- Story 4.5 (Notification scheduling) doit être complétée
- Package `firebase_analytics` doit être ajouté

---

## Definition of Done

- [ ] Tous les AC validés
- [ ] Tests unitaires passent
- [ ] Analytics events logged
- [ ] Firebase configured
- [ ] Privacy compliant
- [ ] Code suit conventions
- [ ] PM approval

---

## Links

- Epic: [epic-4-notifications.md](../../epics/epic-4-notifications.md)
- Previous: [story-4.9-background-escalation-job.md](story-4.9-background-escalation-job.md)
- Next: [story-4.11-notification-settings-screen.md](story-4.11-notification-settings-screen.md)
