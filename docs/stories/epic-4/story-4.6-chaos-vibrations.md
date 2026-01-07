# Story 4.6: Vibrations Agaçantes en Mode Chaos

**Epic:** Epic 4 - Système de Notifications Punitives
**Story ID:** 4.6
**Status:** Not Started
**Priority:** Medium
**Estimated Effort:** 3 hours

---

## User Story

**As a** user,
**I want** que les notifications en mode chaos utilisent des vibrations insistantes,
**so that** je ne peux pas les ignorer facilement.

---

## Acceptance Criteria

1. En niveau `chaos`, les notifications déclenchent un pattern de vibration custom
2. Le pattern utilise : [0, 300, 100, 300, 100, 500] (pause, vibrate, pause, vibrate, pause, long vibrate)
3. Les vibrations ne sont actives QUE en mode chaos (pas pour calm, concerned, dramatic)
4. L'utilisateur peut désactiver les vibrations dans les paramètres (toggle "Vibrations actives")
5. La désactivation est sauvegardée dans `shared_preferences`
6. Tests unitaires valident que le pattern de vibration est appliqué uniquement en chaos
7. Test manuel sur device réel valide que les vibrations sont effectivement agaçantes mais pas excessives

---

## Technical Notes

- Location: Update `lib/domain/usecases/schedule_notification_usecase.dart`
- Package: Use `flutter_local_notifications` vibration pattern
- Settings: Store in shared_preferences
- Tests: `test/domain/usecases/schedule_notification_usecase_test.dart`

---

## Dependencies

- Story 4.5 (Notification scheduling) doit être complétée
- Package `shared_preferences` doit être disponible

---

## Definition of Done

- [ ] Tous les AC validés
- [ ] Tests unitaires passent
- [ ] Vibrations fonctionnent en chaos
- [ ] Toggle settings fonctionne
- [ ] Test manuel validé
- [ ] Code suit conventions
- [ ] PM approval

---

## Links

- Epic: [epic-4-notifications.md](../../epics/epic-4-notifications.md)
- Previous: [story-4.5-notification-scheduling.md](story-4.5-notification-scheduling.md)
- Next: [story-4.7-night-pause.md](story-4.7-night-pause.md)
