# Story 3.3: Interface Caméra Guidée pour Selfie

**Epic:** Epic 3 - Validation Photo & Feedback Positif
**Story ID:** 3.3
**Status:** Not Started
**Priority:** Critical
**Estimated Effort:** 6 hours

---

## User Story

**As a** user,
**I want** une interface caméra simple et guidée pour prendre mon selfie,
**so that** la validation photo est rapide et sans friction.

---

## Acceptance Criteria

1. L'écran `PhotoValidationScreen` s'ouvre lorsque l'utilisateur tape le bouton "Je bois" sur HomeScreen
2. L'écran affiche la caméra frontale en plein écran avec preview live
3. Un cadre visuel (overlay semi-transparent) guide le positionnement : zone visage + zone verre
4. Des instructions texte s'affichent : "Prends un selfie avec ton verre d'eau 💧"
5. Un bouton de capture proéminent (icône caméra) est placé au centre bas
6. Un bouton "Annuler" permet de revenir au HomeScreen sans validation
7. La permission caméra est demandée automatiquement si pas encore accordée
8. Si permission caméra refusée : message d'erreur + redirection vers paramètres système
9. Widget test valide l'affichage de l'interface et les boutons (mock caméra)

---

## Technical Notes

- Location: `lib/presentation/screens/photo/photo_validation_screen.dart`
- Package: `camera` plugin
- Permission: `permission_handler`
- Tests: `test/presentation/screens/photo/photo_validation_screen_test.dart`

---

## Dependencies

- Package `camera` doit être ajouté
- Package `permission_handler` doit être ajouté (Epic 2)

---

## Definition of Done

- [ ] Tous les AC validés
- [ ] Widget tests passent
- [ ] Camera preview fonctionne
- [ ] Permission handling OK
- [ ] Code suit conventions
- [ ] PM approval

---

## Links

- Epic: [epic-3-photo-validation.md](../../epics/epic-3-photo-validation.md)
- Previous: [story-3.2-hydration-log-repository.md](story-3.2-hydration-log-repository.md)
- Next: [story-3.4-photo-capture-storage.md](story-3.4-photo-capture-storage.md)
