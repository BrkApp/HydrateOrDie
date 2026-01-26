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
   - Format exact: Année(4 chiffres) + Mois(2 chiffres) + Jour(2 chiffres) + underscore + Heure(2 chiffres) + Minute(2 chiffres) + Seconde(2 chiffres)
   - Implémentation: `DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())`
   - Exemples valides: `hydration_20260116_093045.jpg`, `hydration_20261231_235959.jpg`
4. La photo est compressée avec quality parameter 80 (package `image`) pour limiter la taille (cible <500KB en moyenne pour photos typiques selfie+verre)
   - Implémentation: `image.encodeJpg(photo, quality: 80)`
   - Note: Taille finale dépend du contenu photo, <500KB est une cible moyenne, pas une garantie stricte
   - Tests doivent vérifier quality parameter = 80, pas taille finale exacte
5. Le chemin complet de la photo est retourné et utilisé pour créer le `HydrationLog`
6. Les photos de plus de 90 jours sont supprimées automatiquement lors de l'ouverture de l'app (pas de background task, exécution foreground uniquement)
   - Logique: Comparaison `DateTime.now().difference(fileCreationDate).inDays > 90`
   - Exécution: Appel dans `main.dart` après init GetIt, avant runApp
   - Justification: Simple, cross-platform, pas de permissions background nécessaires
7. Gestion d'erreur : si échec sauvegarde (storage plein), message d'erreur clair "Impossible de sauvegarder la photo. Vérifie ton espace de stockage."
8. Tests unitaires valident la logique de nommage (format timestamp) et compression (quality parameter = 80)
9. Test d'intégration valide la sauvegarde réelle sur device/simulateur (création fichier + lecture + vérification contenu)

---

## Technical Notes

- Location: `lib/domain/usecases/capture_photo_usecase.dart`
- Package: `path_provider` for storage paths
- Package: `image` for compression (encodeJpg method)
- Package: `intl` for DateFormat (timestamp formatting)
- Tests: `test/domain/usecases/capture_photo_usecase_test.dart`
- Cleanup logic: Create `lib/core/utils/photo_cleanup_utils.dart` with `deleteOldPhotos()` method
- Cleanup execution: Call in `main.dart` après `await configureDependencies()` et avant `runApp()`

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
