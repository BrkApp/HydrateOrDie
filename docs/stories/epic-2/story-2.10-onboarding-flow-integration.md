# Story 2.10: Intégration Onboarding dans le Flow Initial

**Epic:** Epic 2 - Onboarding & Personnalisation
**Story ID:** 2.10
**Status:** Not Started
**Priority:** Critical
**Estimated Effort:** 4 hours

---

## User Story

**As a** new user,
**I want** passer automatiquement par l'onboarding lors de ma première utilisation,
**so that** je configure l'app dès le début.

---

## Acceptance Criteria

1. Au lancement de l'app, vérification : si `UserProfile` existe ET `Avatar` existe → HomeScreen
2. Si `UserProfile` n'existe pas OU `Avatar` n'existe pas → OnboardingFlow
3. Le `OnboardingFlow` suit l'ordre : AvatarSelection (Epic 1) → Weight → Age → Gender → Activity → Location → Summary
4. Un widget `OnboardingNavigator` gère la navigation séquentielle entre les écrans
5. Chaque écran sauvegarde temporairement sa réponse dans un state provider/bloc
6. Seul l'écran Summary sauvegarde définitivement le profil complet
7. Un bouton "Retour" permet de revenir à l'écran précédent (sauf depuis AvatarSelection)
8. Widget test valide le flow complet avec navigation avant/arrière

---

## Technical Notes

- Location: `lib/presentation/flows/onboarding_flow.dart`
- State management: Use Bloc or Provider to hold temporary onboarding data
- Navigation: Custom navigator or PageView
- Tests: `test/presentation/flows/onboarding_flow_test.dart`

---

## Dependencies

- Stories 2.1 à 2.9 doivent être complétées
- Story 1.8 (Avatar selection) doit être complétée

---

## Definition of Done

- [ ] Tous les AC validés
- [ ] Widget tests passent
- [ ] Flow complet testé
- [ ] Navigation avant/arrière fonctionne
- [ ] State management correct
- [ ] Code suit conventions
- [ ] PM approval

---

## Links

- Epic: [epic-2-onboarding.md](../../epics/epic-2-onboarding.md)
- Previous: [story-2.9-onboarding-summary-screen.md](story-2.9-onboarding-summary-screen.md)
- Next: [story-3.1-hydration-log-model.md](../epic-3/story-3.1-hydration-log-model.md)
