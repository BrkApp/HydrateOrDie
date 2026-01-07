# Story 2.3: Repository Profil Utilisateur

**Epic:** Epic 2 - Onboarding & Personnalisation
**Story ID:** 2.3
**Status:** Not Started
**Priority:** Critical
**Estimated Effort:** 3 hours

---

## User Story

**As a** developer,
**I want** un repository pour persister le profil utilisateur,
**so that** les données d'onboarding sont sauvegardées et accessibles.

---

## Acceptance Criteria

1. La classe `UserProfileRepository` implémente : `saveProfile()`, `getProfile()`, `updateProfile()`, `deleteProfile()`
2. Le repository utilise `sqflite` pour stocker le profil dans une table `user_profile`
3. Le schéma de table inclut toutes les propriétés du `UserProfile` model
4. La méthode `getProfile()` retourne `null` si aucun profil n'existe (nouveau user)
5. La méthode `saveProfile()` override le profil existant (un seul profil par installation)
6. Le repository est injectable via `get_it`
7. Tests unitaires couvrent CRUD complet (create, read, update, delete)
8. Tests d'intégration valident la persistence réelle avec sqflite

---

## Technical Notes

- Location: `lib/data/repositories/user_profile_repository.dart`
- Interface: `lib/domain/repositories/user_profile_repository.dart`
- Tests: `test/data/repositories/user_profile_repository_test.dart`
- Dependency injection: Configure dans `lib/core/di/injection_container.dart`

---

## Dependencies

- Story 2.1 (UserProfile model) doit être complétée
- Package `sqflite` doit être ajouté

---

## Definition of Done

- [ ] Tous les AC validés
- [ ] Tests unitaires passent
- [ ] Tests d'intégration passent
- [ ] Code suit conventions
- [ ] Repository injectable via get_it
- [ ] PM approval

---

## Links

- Epic: [epic-2-onboarding.md](../../epics/epic-2-onboarding.md)
- Previous: [story-2.2-hydration-calculation.md](story-2.2-hydration-calculation.md)
- Next: [story-2.4-onboarding-weight-screen.md](story-2.4-onboarding-weight-screen.md)
