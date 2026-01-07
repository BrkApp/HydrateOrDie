# Story 5.7: Stats Minimalistes sur Écran Profil

**Epic:** Epic 5 - Progression & Rétention (Streaks & Historique)
**Story ID:** 5.7
**Status:** Not Started
**Priority:** High
**Estimated Effort:** 4 hours

---

## User Story

**As a** user,
**I want** voir quelques statistiques simples de ma progression,
**so that** je comprends mes performances sans complexité excessive.

---

## Acceptance Criteria

1. Un écran `ProfileScreen` est accessible via navigation bottom bar ou menu
2. L'écran affiche en haut : avatar actuel, nom de personnalité, et bouton "Changer d'avatar" (ouvre sélection avatar)
3. Section "Mes Statistiques" affiche : Streak actuel : X jours 🔥, Streak le plus long : X jours 🏆, Jours objectif atteint ce mois : X/30, Volume total bu ce mois : X.XL
4. Les stats sont calculées en temps réel à l'ouverture de l'écran
5. Un bouton "Voir calendrier complet" navigue vers `CalendarScreen`
6. Widget test valide l'affichage de toutes les stats

---

## Technical Notes

- Location: `lib/presentation/screens/profile/profile_screen.dart`
- Stats calculation: Real-time from repositories
- Navigation: To CalendarScreen and AvatarSelection
- Tests: `test/presentation/screens/profile/profile_screen_test.dart`

---

## Dependencies

- Story 5.3 (Streak repository) doit être complétée
- Story 5.5 (Calendar model) doit être complétée
- Story 1.8 (Avatar selection) doit être complétée

---

## Definition of Done

- [ ] Tous les AC validés
- [ ] Widget tests passent
- [ ] All stats displayed
- [ ] Navigation works
- [ ] Real-time calculation
- [ ] Code suit conventions
- [ ] PM approval

---

## Links

- Epic: [epic-5-progression.md](../../epics/epic-5-progression.md)
- Previous: [story-5.6-calendar-screen.md](story-5.6-calendar-screen.md)
- Next: [story-5.8-settings-screen.md](story-5.8-settings-screen.md)
