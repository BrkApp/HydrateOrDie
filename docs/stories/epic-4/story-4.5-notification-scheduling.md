# Story 4.5: Scheduling Notifications Locales

**Epic:** Epic 4 - Système de Notifications Punitives
**Story ID:** 4.5
**Status:** Not Started
**Priority:** Critical
**Estimated Effort:** 6 hours

---

## User Story

**As a** user,
**I want** recevoir des notifications push même quand l'app est fermée,
**so that** les rappels fonctionnent en background.

---

## Acceptance Criteria

1. Le use case `ScheduleNotificationUseCase` utilise `flutter_local_notifications` pour scheduler les notifications
2. Les notifications sont schedulées avec intervalles basés sur le niveau : Calm (1h), Concerned (30min), Dramatic (15min), Chaos (aléatoire 5-10min)
3. Le titre de la notification affiche le nom de l'avatar (ex: "Maman dit :", "Coach Mike :", "Dr. Martin :", "Alex dit :")
4. Le body contient le message généré par `NotificationMessageProvider`
5. Les notifications utilisent une icône custom (goutte d'eau ou avatar icon)
6. En mode Chaos, l'intervalle aléatoire est calculé via `Random().nextInt(300) + 300` secondes (5-10min)
7. Les notifications sont annulées et re-schedulées après chaque hydratation validée
8. Tests unitaires valident la logique de scheduling pour chaque niveau
9. Tests d'intégration valident que les notifications apparaissent réellement (sur device/simulateur)

---

## Technical Notes

- Location: `lib/domain/usecases/schedule_notification_usecase.dart`
- Package: `flutter_local_notifications`
- Platform-specific: Configure iOS and Android separately
- Tests: `test/domain/usecases/schedule_notification_usecase_test.dart`

---

## Dependencies

- Story 4.2 (Escalation algorithm) doit être complétée
- Story 4.4 (Message provider) doit être complétée
- Package `flutter_local_notifications` doit être ajouté

---

## Definition of Done

- [ ] Tous les AC validés
- [ ] Tests unitaires passent
- [ ] Tests d'intégration passent
- [ ] Notifications fonctionnent en background
- [ ] Code suit conventions
- [ ] PM approval

---

## Links

- Epic: [epic-4-notifications.md](../../epics/epic-4-notifications.md)
- Previous: [story-4.4-personalized-messages.md](story-4.4-personalized-messages.md)
- Next: [story-4.6-chaos-vibrations.md](story-4.6-chaos-vibrations.md)
