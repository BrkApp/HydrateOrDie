# Story 5.12: Bottom Navigation Bar

**Epic:** Epic 5 - Progression & Rétention (Streaks & Historique)
**Story ID:** 5.12
**Status:** Not Started
**Priority:** Critical
**Estimated Effort:** 4 hours

---

## User Story

**As a** user,
**I want** naviguer facilement entre les écrans principaux,
**so that** j'accède rapidement aux différentes fonctions de l'app.

---

## Acceptance Criteria

1. Une `BottomNavigationBar` est présente sur tous les écrans principaux
2. Les tabs disponibles : "Home" (🏠), "Calendrier" (📅), "Profil" (👤)
3. Le tab actif est highlight visuellement
4. Taper sur un tab navigue vers l'écran correspondant
5. La navigation préserve l'état des écrans (pas de reload à chaque switch)
6. Widget test valide la navigation entre les 3 tabs principaux

---

## Technical Notes

- Location: `lib/presentation/navigation/main_navigation.dart`
- Widget: Flutter BottomNavigationBar
- State preservation: Use IndexedStack or similar
- Tabs: Home, Calendar, Profile
- Tests: `test/presentation/navigation/main_navigation_test.dart`

---

## Dependencies

- Story 1.6 (HomeScreen) doit être complétée
- Story 5.6 (CalendarScreen) doit être complétée
- Story 5.7 (ProfileScreen) doit être complétée

---

## Definition of Done

- [ ] Tous les AC validés
- [ ] Widget tests passent
- [ ] Navigation works smoothly
- [ ] State preserved
- [ ] All tabs functional
- [ ] Code suit conventions
- [ ] PM approval

---

## Links

- Epic: [epic-5-progression.md](../../epics/epic-5-progression.md)
- Previous: [story-5.11-achievements.md](story-5.11-achievements.md)
- Next: N/A (Final story of MVP)
