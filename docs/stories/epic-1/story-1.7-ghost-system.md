# Story 1.7: Système Fantôme (Mort Temporaire)

**Epic:** Epic 1 - Foundation & Avatar Core System
**Story ID:** 1.7
**Status:** Not Started
**Priority:** High
**Estimated Effort:** 3 hours

---

## User Story

**As a** user,
**I want** que mon avatar devienne un fantôme s'il meurt au lieu de disparaître définitivement,
**so that** je peux continuer à utiliser l'app même après un échec.

---

## Acceptance Criteria

1. Un nouvel état `ghost` est ajouté à l'enum `AvatarState` (5 états total)
2. Quand l'avatar atteint l'état `dead`, il passe automatiquement en état `ghost` après 10 secondes
3. Le fantôme a un asset visuel distinct (version transparente/spectrale de l'avatar)
4. En état `ghost`, un message s'affiche : "Ton avatar est mort aujourd'hui... Il reviendra demain." avec ton dramatique
5. À minuit (00h00 locale), le fantôme ressuscite automatiquement en état `fresh` via background job
6. La résurrection réinitialise `lastDrinkTime` à `DateTime.now()`
7. Tests unitaires valident la transition `dead` → `ghost` et `ghost` → `fresh` à minuit
8. Un widget test valide l'affichage du fantôme avec le message approprié

---

## Technical Notes

- Modifier `AvatarState` enum pour ajouter `ghost`
- Assets: 4 ghost variations (1 par personality)
- Background job: Utiliser `flutter_workmanager` ou Timer pour résurrection minuit

---

## Dependencies

- Story 1.2 (models - modifier enum)
- Story 1.4 (ajouter ghost assets)
- Story 1.5 (modifier logic pour inclure ghost transition)

---

## Definition of Done

- [ ] Ghost state fonctionnel
- [ ] Transition dead → ghost automatique
- [ ] Résurrection minuit fonctionne
- [ ] Tests couvrent tous scénarios
- [ ] Ghost assets présents
- [ ] PM approval

---

## Links

- Epic: [epic-1-foundation.md](../epics/epic-1-foundation.md)
- Previous: [story-1.6-home-screen.md](story-1.6-home-screen.md)
- Next: [story-1.8-avatar-selection.md](story-1.8-avatar-selection.md)
