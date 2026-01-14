# Story 2.7 - Écran Onboarding Question Activité Physique - Rapport de Complétion

**Date:** 2026-01-14
**Story ID:** 2.7
**Statut:** ✅ Complété

## Résumé

Implémentation de l'écran de sélection du niveau d'activité physique (Sédentaire/Léger/Modéré/Très actif/Extrêmement actif) avec 5 cartes cliquables, icônes spécifiques, progression "4/5", et navigation vers l'écran de localisation.

## Fichiers Créés
- `lib/presentation/screens/onboarding/onboarding_activity_screen.dart`
- `test/presentation/screens/onboarding/onboarding_activity_screen_test.dart`
- `docs/stories/epic-2/reports/story-2.7-completion-report.md`
- `docs/stories/epic-2/reports/story-2.7-dod-report.md`

## Fichiers Modifiés
- `lib/main.dart` (ajout route `/onboarding_activity` + import)

## Tests
✅ 7 widget tests passent (100%)
✅ flutter analyze: 0 erreurs critiques (44 warnings info préexistants)
✅ Régression complète: 528 tests passent

## Acceptance Criteria
✅ AC1: Écran s'affiche après l'écran genre
✅ AC2: Titre "Niveau d'activité physique" + sous-titre "À quelle fréquence fais-tu du sport ?"
✅ AC3: 5 options (Sédentaire, Léger, Modéré, Très actif, Extrêmement actif)
✅ AC4: Chaque card avec icon + label + description
✅ AC5: Option sélectionnée highlight visuellement
✅ AC6: Bouton "Suivant" activé seulement si sélection
✅ AC7: Indicateur progression "Étape 4 sur 5" visible

## Spécifications Techniques

### UI Implementation
- **Layout:** Row-based cards (icon à gauche, texte à droite)
- **Icons utilisés:**
  - Sédentaire: `Icons.weekend`
  - Léger: `Icons.directions_walk`
  - Modéré: `Icons.directions_run`
  - Très actif: `Icons.fitness_center`
  - Extrêmement actif: `Icons.local_fire_department`
- **State:** Local `ActivityLevel? _selectedActivity`
- **Navigation:** `/onboarding_activity` → `/onboarding_location` (Story 2.8)

### Tests Créés
1. Display activity level selection screen
2. Next button disabled when no activity selected
3. Enable next button when activity is selected
4. Highlight selected activity card
5. Update provider state when activity is selected
6. Display all activity icons
7. Navigate back when back button is pressed

## Notes
- Navigation vers `/onboarding_location` échouera silencieusement car Story 2.8 n'est pas encore implémentée (comportement attendu)
- Aucune modification de `activity_level.dart` (enum déjà créé en Story 2.1)
- Pattern UI cohérent avec Gender Screen (Story 2.6)

## Commit
```
[EPIC-2.7] Implement onboarding activity screen

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
```

