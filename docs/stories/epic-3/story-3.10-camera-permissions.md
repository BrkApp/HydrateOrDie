# Story 3.10: Gestion Permissions Caméra

**Epic:** Epic 3 - Validation Photo & Feedback Positif
**Story ID:** 3.10
**Status:** Ready for Review
**Priority:** High
**Estimated Effort:** 3 hours
**Agent Model Used:** Claude Sonnet 4.5

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

- [x] Tous les AC validés
- [x] Tests unitaires passent
- [x] Widget tests passent
- [x] Permission handling complet
- [x] Error states gérés
- [x] Code suit conventions
- [ ] PM approval

---

## Links

- Epic: [epic-3-photo-validation.md](../../epics/epic-3-photo-validation.md)
- Previous: [story-3.9-glass-size-selection.md](story-3.9-glass-size-selection.md)
- Next: [story-4.1-notification-state-model.md](../epic-4/story-4.1-notification-state-model.md)

---

## Dev Agent Record

### Debug Log References
- N/A - Aucun problème majeur rencontré

### Completion Notes
- Package `permission_handler` ajouté dans pubspec.yaml (v11.4.0)
- Permissions Android déclarées dans AndroidManifest.xml (CAMERA + camera feature)
- Permissions iOS déclarées dans Info.plist (NSCameraUsageDescription + NSPhotoLibraryUsageDescription)
- `CameraPermissionService` créé dans `lib/core/services/` avec 4 états: granted, denied, permanentlyDenied, restricted
- Service enregistré dans GetIt (injection.dart)
- `PhotoValidationScreen` mise à jour avec gestion complète des permissions
- 11 tests unitaires pour le service (enum + méthodes)
- 12 widget tests pour PhotoValidationScreen (tous états + interactions)
- Tous les tests passent (23/23)
- flutter analyze: 0 issues

### File List
**Created:**
- `lib/core/services/camera_permission_service.dart`
- `test/core/services/camera_permission_service_test.dart`
- `test/presentation/screens/photo_validation/photo_validation_screen_test.dart`
- `test/presentation/screens/photo_validation/photo_validation_screen_test.mocks.dart`

**Modified:**
- `pubspec.yaml` (ajout permission_handler)
- `android/app/src/main/AndroidManifest.xml` (permissions caméra)
- `ios/Runner/Info.plist` (descriptions permissions)
- `lib/core/di/injection.dart` (enregistrement service)
- `lib/presentation/screens/photo_validation/photo_validation_screen.dart` (logique permissions complète)

### Change Log
- **2026-01-16:** Story 3.10 complétée - Infrastructure permissions caméra prête pour Story 3.3
