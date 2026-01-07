# Story 2.9: Écran Récapitulatif Onboarding avec Objectif

**Epic:** Epic 2 - Onboarding & Personnalisation
**Story ID:** 2.9
**Status:** Not Started
**Priority:** Critical
**Estimated Effort:** 5 hours

---

## User Story

**As a** new user,
**I want** voir mon objectif d'hydratation calculé à la fin de l'onboarding,
**so that** je sais combien je dois boire quotidiennement.

---

## Acceptance Criteria

1. L'écran `OnboardingSummaryScreen` s'affiche après la question localisation
2. L'écran affiche : titre "Ton objectif quotidien", objectif calculé en grand (ex: "2.5 Litres"), sous-titre "Basé sur ton profil personnel"
3. Un récapitulatif résume les infos : "Homme, 30 ans, 75kg, Activité modérée"
4. Un message motivant s'affiche : "Prêt à hydrater [Nom Avatar] ?" avec icon avatar
5. Bouton "C'est parti !" valide et sauvegarde le profil via `UserProfileRepository`
6. Après sauvegarde, navigation vers `HomeScreen` (Epic 1) avec avatar et objectif actifs
7. Widget test valide l'affichage de l'objectif calculé et la navigation finale
8. Test d'intégration valide le flow complet onboarding → sauvegarde profil → écran home

---

## Technical Notes

- Location: `lib/presentation/screens/onboarding/onboarding_summary_screen.dart`
- Use case: Call `CalculateHydrationGoalUseCase` to get goal
- Repository: Save via `UserProfileRepository`
- Tests: `test/presentation/screens/onboarding/onboarding_summary_screen_test.dart`

---

## Dependencies

- Story 2.8 (Location screen) doit être complétée
- Story 2.2 (Calculate hydration goal) doit être complétée
- Story 2.3 (UserProfile repository) doit être complétée

---

## Definition of Done

- [ ] Tous les AC validés
- [ ] Widget tests passent
- [ ] Integration test passe
- [ ] Calcul objectif correct
- [ ] Sauvegarde fonctionne
- [ ] Navigation finale OK
- [ ] PM approval

---

## Links

- Epic: [epic-2-onboarding.md](../../epics/epic-2-onboarding.md)
- Previous: [story-2.8-onboarding-location-screen.md](story-2.8-onboarding-location-screen.md)
- Next: [story-2.10-onboarding-flow-integration.md](story-2.10-onboarding-flow-integration.md)
