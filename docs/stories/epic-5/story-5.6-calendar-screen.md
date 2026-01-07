# Story 5.6: Écran Calendrier Historique

**Epic:** Epic 5 - Progression & Rétention (Streaks & Historique)
**Story ID:** 5.6
**Status:** Not Started
**Priority:** High
**Estimated Effort:** 6 hours

---

## User Story

**As a** user,
**I want** voir un calendrier de mes jours d'hydratation passés,
**so that** je peux visualiser ma progression sur le long terme.

---

## Acceptance Criteria

1. L'écran `CalendarScreen` est accessible via une icône calendrier dans la navigation ou depuis le HomeScreen
2. L'écran affiche un calendrier mensuel (vue mois par mois)
3. Chaque jour du mois affiche : ✓ (vert) si objectif atteint, ✗ (rouge) si raté, vide si futur ou pas de données
4. Le jour actuel est highlight avec un border distinct
5. Des flèches permettent de naviguer entre les mois (précédent/suivant)
6. Taper sur un jour passé affiche un modal avec détails : date, volume bu, objectif, pourcentage atteint
7. Un résumé mensuel s'affiche en bas : "15/30 jours objectif atteint" avec pourcentage
8. Widget test valide l'affichage du calendrier et la navigation entre mois
9. Widget test valide l'affichage des symboles ✓/✗ selon les données

---

## Technical Notes

- Location: `lib/presentation/screens/calendar/calendar_screen.dart`
- Calendar widget: Use `table_calendar` package or custom implementation
- Navigation: Month arrows
- Modal: Show day details on tap
- Tests: `test/presentation/screens/calendar/calendar_screen_test.dart`

---

## Dependencies

- Story 5.5 (Calendar model) doit être complétée
- Package `table_calendar` (optionnel)

---

## Definition of Done

- [ ] Tous les AC validés
- [ ] Widget tests passent
- [ ] Calendar displays correctly
- [ ] Navigation works
- [ ] Day details modal works
- [ ] Monthly summary correct
- [ ] Code suit conventions
- [ ] PM approval

---

## Links

- Epic: [epic-5-progression.md](../../epics/epic-5-progression.md)
- Previous: [story-5.5-calendar-model.md](story-5.5-calendar-model.md)
- Next: [story-5.7-profile-stats.md](story-5.7-profile-stats.md)
