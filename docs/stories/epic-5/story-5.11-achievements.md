# Story 5.11: Achievements/Badges Simples (Optionnel)

**Epic:** Epic 5 - Progression & Rétention (Streaks & Historique)
**Story ID:** 5.11
**Status:** Not Started
**Priority:** Low
**Estimated Effort:** 6 hours

---

## User Story

**As a** user,
**I want** débloquer des badges simples pour mes accomplissements,
**so that** j'ai des objectifs secondaires motivants.

---

## Acceptance Criteria (si story incluse dans MVP)

1. Un modèle `Achievement` définit : `id`, `title`, `description`, `icon`, `unlocked` (bool), `unlockedDate`
2. Les achievements disponibles dans MVP : "Premier verre" : Valider sa première hydratation, "Streak 7 jours" : Atteindre 7 jours consécutifs, "Streak 30 jours" : Atteindre 30 jours consécutifs, "Objectif parfait" : Atteindre exactement l'objectif quotidien (100%), "Sauveur d'avatar" : Ressusciter un avatar mort
3. Les achievements sont vérifiés automatiquement après chaque action clé (validation, streak update, etc.)
4. Un achievement débloqué affiche une notification in-app : modal célébration + animation
5. Un écran `AchievementsScreen` accessible depuis `ProfileScreen` liste tous les achievements (locked/unlocked)
6. Widget test valide l'affichage des achievements et le système de déblocage
7. **Note** : Cette story est OPTIONNELLE pour MVP - peut être déplacée en V2 si trop complexe

---

## Technical Notes

- Location: `lib/data/models/achievement.dart`, `lib/presentation/screens/achievements/achievements_screen.dart`
- Check logic: After hydration validation, streak update, etc.
- Modal: Celebration animation on unlock
- **OPTIONAL**: Can be deferred to V2
- Tests: `test/data/models/achievement_test.dart`

---

## Dependencies

- Story 5.3 (Streak repository) doit être complétée
- Story 3.6 (Record hydration) doit être complétée

---

## Definition of Done

- [ ] Tous les AC validés (si story incluse)
- [ ] Tests unitaires passent
- [ ] Achievement model created
- [ ] Unlock logic works
- [ ] Celebration modal displays
- [ ] AchievementsScreen created
- [ ] Code suit conventions
- [ ] PM approval

---

## Links

- Epic: [epic-5-progression.md](../../epics/epic-5-progression.md)
- Previous: [story-5.10-change-avatar.md](story-5.10-change-avatar.md)
- Next: [story-5.12-bottom-navigation.md](story-5.12-bottom-navigation.md)
