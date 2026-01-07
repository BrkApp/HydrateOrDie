# Story 3.10: Gestion Permissions Caméra

**Epic:** Epic 3 - Validation Photo & Feedback Positif
**Story ID:** 3.10
**Status:** Not Started
**Priority:** High
**Estimated Effort:** 3 hours

---

## User Story

**As a** user,
**I want** être guidé clairement si je n'ai pas accordé la permission caméra,
**so that** je peux facilement corriger et utiliser l'app.

---

## Acceptance Criteria

1. Au premier lancement de `PhotoValidationScreen`, la permission caméra est demandée via `permission_handler`
2. Si permission accordée : caméra s'ouvre normalement
3. Si permission refusée : écran affiche un message "Caméra nécessaire pour validation" avec explication + bouton "Ouvrir Paramètres"
4. Le bouton "Ouvrir Paramètres" utilise `openAppSettings()` pour rediriger vers les settings système
5. Après retour des settings, l'app re-vérifie la permission automatiquement
6. Si permission "refusée définitivement" (Android), affichage permanent du message paramètres
7. Un bouton "Annuler" permet de revenir au HomeScreen sans validation
8. Tests unitaires valident la logique de demande et gestion des états de permission
9. Widget test valide l'affichage du message d'erreur et du bouton paramètres

---

## Technical Notes

- Location: Update `lib/presentation/screens/photo/photo_validation_screen.dart`
- Package: `permission_handler`
- Permission states: granted, denied, permanently denied
- Tests: `test/presentation/screens/photo/photo_validation_screen_test.dart`

---

## Dependencies

- Story 3.3 (Camera interface) doit être complétée
- Package `permission_handler` doit être ajouté

---

## Definition of Done

- [ ] Tous les AC validés
- [ ] Tests unitaires passent
- [ ] Widget tests passent
- [ ] Permission handling complet
- [ ] Error states gérés
- [ ] Code suit conventions
- [ ] PM approval

---

## Links

- Epic: [epic-3-photo-validation.md](../../epics/epic-3-photo-validation.md)
- Previous: [story-3.9-glass-size-selection.md](story-3.9-glass-size-selection.md)
- Next: [story-4.1-notification-state-model.md](../epic-4/story-4.1-notification-state-model.md)
