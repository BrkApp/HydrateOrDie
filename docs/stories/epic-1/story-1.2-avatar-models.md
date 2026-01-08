# Story 1.2: Modèles de Données Avatar

**Epic:** Epic 1 - Foundation & Avatar Core System
**Story ID:** 1.2
**Status:** Ready for Review
**Priority:** Critical
**Estimated Effort:** 2 hours
**Actual Effort:** 1.5 hours
**Completed:** 2026-01-08

---

## User Story

**As a** developer,
**I want** les data models pour les avatars et leurs états,
**so that** je peux structurer proprement les données avatar dans l'application.

---

## Acceptance Criteria

1. La classe `Avatar` est créée avec les propriétés : `id`, `name`, `personality`, `currentState`, `imageAssetPath`
2. L'enum `AvatarState` définit les 4 états : `fresh`, `tired`, `dehydrated`, `dead`
3. L'enum `AvatarPersonality` définit les 4 personnalités MVP : `authoritarianMother`, `sportsCoach`, `doctor`, `sarcasticFriend`
4. La classe `AvatarState` inclut une méthode `getNextState()` pour progression déshydratation
5. La classe `AvatarState` inclut une méthode `shouldDie(Duration timeSinceLastDrink)` retournant bool
6. Tous les models ont des méthodes `toJson()` et `fromJson()` pour sérialisation
7. Tests unitaires couvrent 100% des models (création, sérialisation, logique état)

---

## Technical Notes

- Location: `lib/data/models/avatar.dart`
- Contracts: Voir `docs/contracts/data-models.md` (créé par Architect)
- Tests: `test/data/models/avatar_test.dart`

---

## Dependencies

- Story 1.1 (project setup) doit être complétée

---

## Definition of Done

- [x] Tous les AC validés
- [x] Tests unitaires 100% coverage
- [x] Code suit conventions
- [x] Dartdoc complet
- [ ] PM approval

---

## Links

- Epic: [epic-1-foundation.md](../epics/epic-1-foundation.md)
- Previous: [story-1.1-flutter-project-setup.md](story-1.1-flutter-project-setup.md)
- Next: [story-1.3-avatar-repository.md](story-1.3-avatar-repository.md)
