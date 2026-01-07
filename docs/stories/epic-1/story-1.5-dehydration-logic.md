# Story 1.5: Logique de Déshydratation Progressive

**Epic:** Epic 1 - Foundation & Avatar Core System
**Story ID:** 1.5
**Status:** Not Started
**Priority:** Critical
**Estimated Effort:** 3 hours

---

## User Story

**As a** user,
**I want** que mon avatar se déshydrate progressivement si je ne bois pas,
**so that** je ressens l'urgence de m'hydrater.

---

## Acceptance Criteria

1. Le use case `UpdateAvatarStateUseCase` calcule l'état actuel basé sur le temps écoulé depuis la dernière hydratation
2. La progression suit : Fresh (0-2h) → Tired (2-4h) → Dehydrated (4-6h) → Dead (6h+)
3. Le calcul utilise `DateTime.now()` comparé au timestamp `lastDrinkTime` stocké
4. Le use case est appelé automatiquement à l'ouverture de l'app et périodiquement en background (toutes les 30min via timer)
5. L'état de l'avatar est mis à jour dans le repository après calcul
6. Les transitions d'état sont loggées pour debug (niveau info)
7. Tests unitaires couvrent tous les scénarios temporels (0h, 1h, 3h, 5h, 7h après last drink)
8. Le timer background utilise `Timer.periodic` et est annulé proprement lors de la fermeture de l'app

---

## Technical Notes

- Location: `lib/domain/use_cases/update_avatar_state_use_case.dart`
- Timer: Géré dans un service ou provider au niveau app
- Logging: Utiliser `print` pour MVP (logger package en V2)

---

## Dependencies

- Story 1.2 (models)
- Story 1.3 (repository)

---

## Definition of Done

- [ ] Tous les AC validés
- [ ] Use case testé 80%+ coverage
- [ ] Timer fonctionne en background
- [ ] Logs présents pour debug
- [ ] Code suit conventions
- [ ] PM approval

---

## Links

- Epic: [epic-1-foundation.md](../epics/epic-1-foundation.md)
- Previous: [story-1.4-avatar-assets.md](story-1.4-avatar-assets.md)
- Next: [story-1.6-home-screen.md](story-1.6-home-screen.md)
