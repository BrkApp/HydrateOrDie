# Story 3.4: Capture et Stockage Photo Locale

**Epic:** Epic 3 - Validation Photo & Feedback Positif
**Story ID:** 3.4
**Status:** Not Started
**Priority:** Critical
**Estimated Effort:** 4 hours

---

## User Story

**As a** user,
**I want** que mes photos selfies soient sauvegardées localement,
**so that** j'ai une preuve de mes validations et mes données restent privées.

---

## Acceptance Criteria

1. Lorsque l'utilisateur tape le bouton capture, la photo est prise via `camera` package
2. La photo est sauvegardée dans le répertoire app local (iOS: Application Documents, Android: Internal Storage)
3. Le nom de fichier suit le format : `hydration_YYYYMMDD_HHmmss.jpg` (ex: `hydration_20260107_143022.jpg`)
4. La photo est compressée à qualité 80% pour limiter la taille (<500KB par photo)
5. Le chemin complet de la photo est retourné et utilisé pour créer le `HydrationLog`
6. Les photos de plus de 90 jours sont supprimées automatiquement (cleanup job nocturne)
7. Gestion d'erreur : si échec sauvegarde (storage plein), message d'erreur clair
8. Tests unitaires valident la logique de nommage et compression
9. Test d'intégration valide la sauvegarde réelle sur device/simulateur

---

## Technical Notes

- Location: `lib/domain/usecases/capture_photo_usecase.dart`
- Package: `path_provider` for storage paths
- Package: `image` for compression
- Tests: `test/domain/usecases/capture_photo_usecase_test.dart`

---

## Dependencies

- Story 3.3 (Camera interface) doit être complétée
- Package `path_provider` doit être ajouté
- Package `image` doit être ajouté

---

## Definition of Done

- [ ] Tous les AC validés
- [ ] Tests unitaires passent
- [ ] Test d'intégration passe
- [ ] Compression fonctionne
- [ ] Cleanup job OK
- [ ] Code suit conventions
- [ ] PM approval

---

## Links

- Epic: [epic-3-photo-validation.md](../../epics/epic-3-photo-validation.md)
- Previous: [story-3.3-camera-interface.md](story-3.3-camera-interface.md)
- Next: [story-3.5-glass-detection.md](story-3.5-glass-detection.md)
