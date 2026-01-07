# Story 4.11: Écran Paramètres Notifications

**Epic:** Epic 4 - Système de Notifications Punitives
**Story ID:** 4.11
**Status:** Not Started
**Priority:** High
**Estimated Effort:** 4 hours

---

## User Story

**As a** user,
**I want** pouvoir configurer le comportement des notifications,
**so that** je peux adapter l'app à mes préférences.

---

## Acceptance Criteria

1. Un écran `NotificationSettingsScreen` accessible depuis le menu paramètres principal
2. L'écran affiche les options configurables : Toggle "Notifications actives" (on/off global), Toggle "Vibrations actives" (on/off pour mode chaos), Time Picker "Heure début pause" (par défaut 22h00), Time Picker "Heure fin pause" (par défaut 7h00), Info text: "Le niveau d'escalade s'adapte automatiquement selon ton hydratation"
3. Toutes les modifications sont sauvegardées immédiatement dans `shared_preferences`
4. Les changements s'appliquent immédiatement (re-schedule des notifications si nécessaire)
5. Widget test valide l'affichage et la sauvegarde des paramètres

---

## Technical Notes

- Location: `lib/presentation/screens/settings/notification_settings_screen.dart`
- UI: Toggles and time pickers
- Storage: `shared_preferences`
- Apply changes: Call schedule notification usecase on change
- Tests: `test/presentation/screens/settings/notification_settings_screen_test.dart`

---

## Dependencies

- Story 4.5 (Notification scheduling) doit être complétée
- Story 4.6 (Vibrations) doit être complétée
- Story 4.7 (Night pause) doit être complétée

---

## Definition of Done

- [ ] Tous les AC validés
- [ ] Widget tests passent
- [ ] Settings UI complete
- [ ] All toggles work
- [ ] Changes applied immediately
- [ ] Code suit conventions
- [ ] PM approval

---

## Links

- Epic: [epic-4-notifications.md](../../epics/epic-4-notifications.md)
- Previous: [story-4.10-notification-analytics.md](story-4.10-notification-analytics.md)
- Next: [story-5.1-streak-model.md](../epic-5/story-5.1-streak-model.md)
