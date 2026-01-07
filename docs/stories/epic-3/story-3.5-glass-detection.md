# Story 3.5: Détection Basique Présence Verre (Optionnel)

**Epic:** Epic 3 - Validation Photo & Feedback Positif
**Story ID:** 3.5
**Status:** Not Started
**Priority:** Medium
**Estimated Effort:** 6 hours

---

## User Story

**As a** product owner,
**I want** une détection basique pour vérifier qu'un verre est présent dans la photo,
**so that** on réduit la triche trop facile (photo sans verre).

---

## Acceptance Criteria

1. Après capture, un use case `ValidatePhotoUseCase` analyse l'image via détection basique
2. La détection utilise une heuristique simple : recherche de formes circulaires/cylindriques (OpenCV basic ou ML Kit)
3. Si aucune forme détectée : message warning "On ne voit pas de verre... Tu es sûr ? 🤔" avec options "Oui je confirme" / "Reprendre photo"
4. Si "Oui je confirme" : validation acceptée quand même (warning, pas blocage)
5. Si forme détectée : validation immédiate sans warning
6. La détection ne doit pas prendre plus de 2 secondes (timeout)
7. En cas d'erreur détection : fallback vers validation directe (pas de blocage)
8. **Note:** Cette story est OPTIONNELLE pour MVP - peut être remplacée par validation manuelle simple
9. Tests unitaires valident la logique avec images mock (verre présent / absent)

---

## Technical Notes

- Location: `lib/domain/usecases/validate_photo_usecase.dart`
- Options: OpenCV or Google ML Kit for detection
- Fallback: Always allow validation if detection fails
- Tests: `test/domain/usecases/validate_photo_usecase_test.dart`
- **OPTIONAL**: Can be deferred to V2

---

## Dependencies

- Story 3.4 (Photo capture) doit être complétée
- Package ML Kit ou OpenCV (TBD)

---

## Definition of Done

- [ ] Tous les AC validés (si story incluse)
- [ ] Tests unitaires passent
- [ ] Detection fonctionne avec timeout
- [ ] Fallback fonctionne
- [ ] Code suit conventions
- [ ] PM approval

---

## Links

- Epic: [epic-3-photo-validation.md](../../epics/epic-3-photo-validation.md)
- Previous: [story-3.4-photo-capture-storage.md](story-3.4-photo-capture-storage.md)
- Next: [story-3.6-record-hydration.md](story-3.6-record-hydration.md)
