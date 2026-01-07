# Story 1.8: Sélection Initiale Avatar

**Epic:** Epic 1 - Foundation & Avatar Core System
**Story ID:** 1.8
**Status:** Not Started
**Priority:** Critical
**Estimated Effort:** 3 hours

---

## User Story

**As a** new user,
**I want** choisir mon avatar lors de la première utilisation,
**so that** je peux personnaliser mon expérience.

---

## Acceptance Criteria

1. Un écran `AvatarSelectionScreen` s'affiche au premier lancement de l'app (si aucun avatar sauvegardé)
2. L'écran affiche les 4 avatars disponibles en galerie (2x2 grid ou carrousel horizontal)
3. Chaque avatar montre : image preview (état fresh), nom, et description courte personnalité (1 phrase)
4. L'utilisateur peut taper sur un avatar pour le sélectionner (highlight visuel)
5. Un bouton "Confirmer" valide la sélection et sauvegarde via `AvatarRepository`
6. Après confirmation, l'app navigue vers `HomeScreen` avec l'avatar sélectionné
7. Les lancements suivants skip cet écran et chargent directement l'avatar sauvegardé
8. Widget test valide le flow de sélection et la navigation

---

## Technical Notes

- Location: `lib/presentation/screens/avatar_selection/avatar_selection_screen.dart`
- Navigation: Gérer le routing initial (splash → selection OU home)
- Descriptions: Voir brief.md pour personnalités des avatars

---

## Dependencies

- Story 1.3 (repository pour sauvegarde)
- Story 1.4 (avatar assets)

---

## Definition of Done

- [ ] AvatarSelectionScreen complet
- [ ] Navigation conditionnelle fonctionne
- [ ] Sauvegarde avatar OK
- [ ] Widget tests passent
- [ ] UI conforme UX specs
- [ ] PM approval

---

## Links

- Epic: [epic-1-foundation.md](../epics/epic-1-foundation.md)
- Previous: [story-1.7-ghost-system.md](story-1.7-ghost-system.md)
- Next Epic: [Epic 2 - Onboarding](../epic-2/story-2.1-user-profile-model.md)
