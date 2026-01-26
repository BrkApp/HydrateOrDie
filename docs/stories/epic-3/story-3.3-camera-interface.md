# Story 3.3: Interface Caméra Guidée pour Selfie

**Epic:** Epic 3 - Validation Photo & Feedback Positif
**Story ID:** 3.3
**Status:** Ready for Review
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

- [x] Tous les AC validés
- [x] Widget tests passent (14 tests)
- [x] Camera preview fonctionne
- [x] Permission handling OK (Story 3.10)
- [x] Code suit conventions (flutter analyze: 0 issues)
- [ ] PM approval

---

## Links

- Epic: [epic-3-photo-validation.md](../../epics/epic-3-photo-validation.md)
- Previous: [story-3.2-hydration-log-repository.md](story-3.2-hydration-log-repository.md)
- Next: [story-3.4-photo-capture-storage.md](story-3.4-photo-capture-storage.md)

---

## Dev Agent Record

### Tasks
- [x] Implémenter CameraController et gestion lifecycle caméra
- [x] Créer widget CameraPreview avec overlay guide visuel
- [x] Ajouter instructions texte et bouton capture
- [x] Gérer tous les états d'erreur caméra
- [x] Écrire tests widgets complets
- [x] Exécuter flutter test (14 tests passent)
- [x] Exécuter flutter analyze (0 issues)

### Agent Model Used
- claude-sonnet-4-5-20250929

### Debug Log References
- N/A

### Completion Notes
- Interface caméra complète implémentée avec preview live
- Overlay guide visuel avec zones visage (ovale) et verre (rectangle arrondi)
- Instructions texte affichées en overlay semi-transparent
- Bouton capture (FloatingActionButton 72x72dp) placé centre bas
- Bouton annuler via AppBar (icône close)
- Gestion complète des erreurs : device unavailable, init failed, permission denied
- Tests widgets : 14 tests passent (Story 3.10 + Story 3.3)
- CustomPainter pour overlay guide avec labels "Visage" et "Verre"
- Capture photo placeholder pour Story 3.4 (TODO ajouté)

### File List
**Modified:**
- lib/presentation/screens/photo_validation/photo_validation_screen.dart
- test/presentation/screens/photo_validation/photo_validation_screen_test.dart

**Added:**
- _GuidanceOverlayPainter (CustomPainter interne dans photo_validation_screen.dart)

### Change Log
- [Story 3.3] Ajout import camera package et CameraController
- [Story 3.3] Ajout méthode _initializeCamera() avec gestion caméra frontale
- [Story 3.3] Ajout méthode _buildCameraInterface() avec CameraPreview + overlay
- [Story 3.3] Ajout méthode _buildCameraErrorState() pour erreurs caméra
- [Story 3.3] Ajout classe _GuidanceOverlayPainter pour overlay guide visuel
- [Story 3.3] Ajout méthode _capturePhoto() placeholder (TODO Story 3.4)
- [Story 3.3] Modification _buildBody() pour gérer état caméra initialisée
- [Story 3.3] Ajout dispose() pour libérer CameraController
- [Story 3.3] Tests : ajout groupe "Camera Interface (Story 3.3)" avec 3 tests
- [Story 3.3] Correction deprecated withOpacity() → withValues(alpha:)
- [Story 3.3] Suppression import camera inutilisé dans tests
