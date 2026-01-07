# Story 4.8: Gestion Permissions Notifications

**Epic:** Epic 4 - Système de Notifications Punitives
**Story ID:** 4.8
**Status:** Not Started
**Priority:** High
**Estimated Effort:** 4 hours

---

## User Story

**As a** user,
**I want** être guidé pour activer les notifications si je les ai refusées,
**so that** l'app peut fonctionner correctement.

---

## Acceptance Criteria

1. Au premier lancement post-onboarding, la permission notifications est demandée via `permission_handler`
2. Si permission accordée : notifications fonctionnent normalement
3. Si permission refusée : un banner persistant s'affiche sur HomeScreen : "Active les notifications pour profiter pleinement de l'app 🔔"
4. Le banner a un bouton "Activer" qui ouvre `openAppSettings()` vers les settings système
5. Le statut de permission est vérifié à chaque ouverture de l'app
6. Si permission accordée après refus initial, le banner disparaît automatiquement
7. Un toggle dans les paramètres permet de "Mettre en pause les notifications" temporairement (sans les désactiver système)
8. Tests unitaires valident la logique de demande et vérification de permission
9. Widget test valide l'affichage du banner et du bouton

---

## Technical Notes

- Location: `lib/presentation/screens/home/home_screen.dart` (banner)
- Permission: `permission_handler` for notifications
- Settings: Toggle in NotificationSettingsScreen
- Tests: Widget test for banner, unit test for permission logic

---

## Dependencies

- Package `permission_handler` doit être disponible
- Story 1.6 (HomeScreen) doit être complétée

---

## Definition of Done

- [ ] Tous les AC validés
- [ ] Tests unitaires passent
- [ ] Widget tests passent
- [ ] Banner fonctionne
- [ ] Permission handling complet
- [ ] Code suit conventions
- [ ] PM approval

---

## Links

- Epic: [epic-4-notifications.md](../../epics/epic-4-notifications.md)
- Previous: [story-4.7-night-pause.md](story-4.7-night-pause.md)
- Next: [story-4.9-background-escalation-job.md](story-4.9-background-escalation-job.md)
