# Story 3.1: Modèle de Données Validation Hydratation

**Epic:** Epic 3 - Validation Photo & Feedback Positif
**Story ID:** 3.1
**Status:** Not Started
**Priority:** Critical
**Estimated Effort:** 2 hours

---

## User Story

**As a** developer,
**I want** un data model pour les validations d'hydratation,
**so that** je peux tracker l'historique des verres bus.

---

## Acceptance Criteria

1. La classe `HydrationLog` contient les propriétés : `id` (UUID), `timestamp` (DateTime), `photoPath` (String), `glassSize` (enum), `validated` (bool)
2. L'enum `GlassSize` définit : `small` (200ml), `medium` (250ml), `large` (400ml), par défaut `medium`
3. Le model inclut une méthode `volumeLiters()` retournant le volume en litres basé sur `glassSize`
4. Le model a des méthodes `toJson()` et `fromJson()` pour sérialisation
5. Tests unitaires couvrent 100% du model (création, sérialisation, calcul volume)

---

## Technical Notes

- Location: `lib/data/models/hydration_log.dart`
- Enum: `lib/data/models/glass_size.dart`
- Tests: `test/data/models/hydration_log_test.dart`

---

## Dependencies

- Epic 1 foundation doit être complété

---

## Definition of Done

- [ ] Tous les AC validés
- [ ] Tests unitaires 100% coverage
- [ ] Code suit conventions
- [ ] Dartdoc complet
- [ ] PM approval

---

## Links

- Epic: [epic-3-photo-validation.md](../../epics/epic-3-photo-validation.md)
- Previous: [story-2.10-onboarding-flow-integration.md](../epic-2/story-2.10-onboarding-flow-integration.md)
- Next: [story-3.2-hydration-log-repository.md](story-3.2-hydration-log-repository.md)
