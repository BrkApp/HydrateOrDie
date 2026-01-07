# Story 2.1: Modèle de Données Profil Utilisateur

**Epic:** Epic 2 - Onboarding & Personnalisation
**Story ID:** 2.1
**Status:** Not Started
**Priority:** Critical
**Estimated Effort:** 2 hours

---

## User Story

**As a** developer,
**I want** un data model pour le profil utilisateur,
**so that** je peux stocker les informations d'onboarding de manière structurée.

---

## Acceptance Criteria

1. La classe `UserProfile` contient les propriétés : `userId`, `weight` (kg), `age`, `gender` (enum Male/Female/Other), `activityLevel` (enum Sedentary/Light/Moderate/VeryActive/ExtremelyActive), `locationPermissionGranted` (bool)
2. La classe inclut une méthode calculée `dailyHydrationGoalLiters` retournant double
3. L'enum `Gender` définit : `male`, `female`, `other`
4. L'enum `ActivityLevel` définit : `sedentary`, `light`, `moderate`, `veryActive`, `extremelyActive`
5. Le model a des méthodes `toJson()` et `fromJson()` pour sérialisation
6. Le model a une méthode `isComplete()` retournant true si toutes les infos obligatoires sont renseignées
7. Tests unitaires couvrent 100% du model (création, validation, sérialisation)

---

## Technical Notes

- Location: `lib/data/models/user_profile.dart`
- Enums: `lib/data/models/gender.dart`, `lib/data/models/activity_level.dart`
- Tests: `test/data/models/user_profile_test.dart`

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

- Epic: [epic-2-onboarding.md](../../epics/epic-2-onboarding.md)
- Previous: [story-1.8-avatar-selection.md](../epic-1/story-1.8-avatar-selection.md)
- Next: [story-2.2-hydration-calculation.md](story-2.2-hydration-calculation.md)
