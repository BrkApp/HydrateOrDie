# Story 2.2: Algorithme Calcul Objectif Hydratation

**Epic:** Epic 2 - Onboarding & Personnalisation
**Story ID:** 2.2
**Status:** Not Started
**Priority:** Critical
**Estimated Effort:** 4 hours

---

## User Story

**As a** user,
**I want** un objectif d'hydratation adapté à mon profil,
**so that** l'app me guide avec des recommandations pertinentes et crédibles.

---

## Acceptance Criteria

1. Le use case `CalculateHydrationGoalUseCase` implémente la formule : Base = weight (kg) × 0.033 litres
2. L'algorithme applique un multiplicateur selon `activityLevel` : Sedentary (1.0), Light (1.1), Moderate (1.2), VeryActive (1.3), ExtremelyActive (1.5)
3. L'algorithme applique un ajustement selon `gender` : Male (1.0), Female (0.95), Other (1.0)
4. L'algorithme applique un ajustement selon `age` : <30 (1.0), 30-55 (0.95), >55 (0.9)
5. Le résultat final est arrondi à 0.1 litre près (ex: 2.3L, pas 2.347L)
6. Le résultat minimum est 1.5L et maximum 5.0L (safety bounds)
7. L'algorithme inclut des commentaires avec références scientifiques pour crédibilité
8. Tests unitaires couvrent tous les cas edge : poids très légers/lourds, tous âges, tous genders, tous activity levels
9. Tests valident que les calculs correspondent aux attentes (ex: homme 75kg 30ans sedentary = 2.5L ± 0.1L)

---

## Technical Notes

- Location: `lib/domain/usecases/calculate_hydration_goal_usecase.dart`
- Tests: `test/domain/usecases/calculate_hydration_goal_usecase_test.dart`
- Références scientifiques à inclure dans les commentaires

---

## Dependencies

- Story 2.1 (UserProfile model) doit être complétée

---

## Definition of Done

- [ ] Tous les AC validés
- [ ] Tests unitaires couvrent tous les edge cases
- [ ] Code suit conventions
- [ ] Références scientifiques documentées
- [ ] PM approval

---

## Links

- Epic: [epic-2-onboarding.md](../../epics/epic-2-onboarding.md)
- Previous: [story-2.1-user-profile-model.md](story-2.1-user-profile-model.md)
- Next: [story-2.3-user-profile-repository.md](story-2.3-user-profile-repository.md)
