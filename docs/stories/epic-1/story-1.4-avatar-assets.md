# Story 1.4: Assets Visuels Avatars (4 États x 4 Avatars)

**Epic:** Epic 1 - Foundation & Avatar Core System
**Story ID:** 1.4
**Status:** Not Started
**Priority:** High
**Estimated Effort:** 4 hours

---

## User Story

**As a** user,
**I want** voir des avatars visuellement distincts et expressifs,
**so that** je peux créer un lien émotionnel avec mon avatar.

---

## Acceptance Criteria

1. 4 avatars sont disponibles avec assets graphiques pour chaque état (16 images total minimum ou animations Lottie)
2. Chaque avatar a des assets pour : Fresh (souriant), Tired (fatigué), Dehydrated (desséché visiblement), Dead (effondré/skull)
3. Les assets sont placés dans `assets/images/avatars/` ou `assets/animations/avatars/` selon le format
4. Le fichier `pubspec.yaml` déclare tous les assets correctement
5. Les images sont optimisées (<500KB par asset) pour ne pas alourdir l'app
6. Un widget `AvatarDisplay` affiche l'avatar correct basé sur `AvatarState` et `AvatarPersonality`
7. Widget test valide que `AvatarDisplay` affiche bien l'image correspondante pour chaque combinaison état/personnalité

---

## Technical Notes

- Assets: Utiliser Figma/Canva pour création ou assets gratuits (avec licence)
- Format préféré: PNG optimisé ou Lottie JSON
- Widget location: `lib/presentation/widgets/avatar_display.dart`
- Naming convention: `avatar_[personality]_[state].png`

---

## Dependencies

- Story 1.2 (avatar models) pour les enums
- UX Expert doit avoir fourni les designs avatars

---

## Definition of Done

- [ ] 16 assets créés et optimisés
- [ ] pubspec.yaml à jour
- [ ] AvatarDisplay widget fonctionnel
- [ ] Widget tests passent
- [ ] Assets <500KB chacun
- [ ] PM approval

---

## Links

- Epic: [epic-1-foundation.md](../epics/epic-1-foundation.md)
- Previous: [story-1.3-avatar-repository.md](story-1.3-avatar-repository.md)
- Next: [story-1.5-dehydration-logic.md](story-1.5-dehydration-logic.md)
