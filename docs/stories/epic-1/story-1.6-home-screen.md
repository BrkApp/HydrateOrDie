# Story 1.6: Écran Principal avec Avatar Réactif

**Epic:** Epic 1 - Foundation & Avatar Core System
**Story ID:** 1.6
**Status:** Not Started
**Priority:** Critical
**Estimated Effort:** 4 hours

---

## User Story

**As a** user,
**I want** voir mon avatar et son état actuel sur l'écran principal,
**so that** je sais immédiatement si je dois boire.

---

## Acceptance Criteria

1. L'écran `HomeScreen` affiche l'avatar sélectionné au centre (taille proéminente, 50% de la hauteur écran)
2. L'avatar affiché correspond à l'état calculé en temps réel (fresh/tired/dehydrated/dead)
3. Un texte indique l'état actuel avec ton correspondant à la personnalité (ex: "Je vais bien !" / "J'ai soif..." / "AIDE-MOI !" / "💀")
4. Le temps écoulé depuis la dernière hydratation est affiché (ex: "Dernière hydratation : il y a 3h12")
5. L'écran se rafraîchit automatiquement toutes les 60 secondes pour refléter la progression
6. Un bouton "Je bois" est présent (non fonctionnel pour cette story, juste UI)
7. Le state management (Riverpod/Bloc) gère l'état de l'avatar réactivement
8. Widget test valide l'affichage correct de l'avatar et des informations pour chaque état

---

## Technical Notes

- Location: `lib/presentation/screens/home/home_screen.dart`
- State management: Provider/Bloc dans `lib/presentation/providers/home_provider.dart`
- Auto-refresh: StreamBuilder ou Timer.periodic dans provider

---

## Dependencies

- Story 1.4 (AvatarDisplay widget)
- Story 1.5 (UpdateAvatarStateUseCase)

---

## Definition of Done

- [ ] HomeScreen complet et fonctionnel
- [ ] Avatar se met à jour automatiquement
- [ ] Widget tests passent
- [ ] UI conforme à UX specs
- [ ] State management réactif
- [ ] PM approval

---

## Links

- Epic: [epic-1-foundation.md](../epics/epic-1-foundation.md)
- Previous: [story-1.5-dehydration-logic.md](story-1.5-dehydration-logic.md)
- Next: [story-1.7-ghost-system.md](story-1.7-ghost-system.md)
