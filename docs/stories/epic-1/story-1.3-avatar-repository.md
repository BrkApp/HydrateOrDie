# Story 1.3: Repository Avatar avec Persistence Locale

**Epic:** Epic 1 - Foundation & Avatar Core System
**Story ID:** 1.3
**Status:** Not Started
**Priority:** Critical
**Estimated Effort:** 3 hours

---

## User Story

**As a** developer,
**I want** un repository pour persister et récupérer les données avatar,
**so that** l'avatar sélectionné et son état sont sauvegardés entre les sessions.

---

## Acceptance Criteria

1. La classe `AvatarRepository` implémente les méthodes : `saveSelectedAvatar()`, `getSelectedAvatar()`, `updateAvatarState()`, `getAvatarState()`
2. Le repository utilise `shared_preferences` pour stocker l'avatar ID sélectionné
3. Le repository utilise `sqflite` pour stocker l'état actuel de l'avatar (state, lastUpdated timestamp)
4. La méthode `getAvatarState()` retourne l'état sauvegardé ou `fresh` par défaut si nouvelle installation
5. Les timestamps sont stockés en UTC ISO 8601 format
6. Le repository est injectable via `get_it`
7. Tests unitaires couvrent tous les scénarios (save, get, update, avatar non sélectionné)
8. Tests d'intégration valident la persistence réelle avec sqflite et shared_preferences

---

## Technical Notes

- Location: `lib/data/repositories/avatar_repository.dart`
- Interface: `lib/domain/repositories/avatar_repository.dart`
- DB Schema: Voir `docs/contracts/database-schema.md`
- DI: Enregistrer dans `lib/core/di/injection.dart`

---

## Dependencies

- Story 1.2 (avatar models) doit être complétée

---

## Definition of Done

- [ ] Tous les AC validés
- [ ] Tests unitaires + integration tests
- [ ] Coverage 70%+
- [ ] Code suit conventions
- [ ] Repository injectable
- [ ] PM approval

---

## Links

- Epic: [epic-1-foundation.md](../epics/epic-1-foundation.md)
- Previous: [story-1.2-avatar-models.md](story-1.2-avatar-models.md)
- Next: [story-1.4-avatar-assets.md](story-1.4-avatar-assets.md)
