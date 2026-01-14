# 🎯 Prompt Story 2.7 - Écran Onboarding Niveau d'Activité

**Date:** 2026-01-14
**Agent:** @dev
**Epic:** 2 - User Onboarding & Personnalisation
**Story:** 2.7 - Onboarding Activity Level Screen

---

## 📋 CONTEXTE

**Précédent:** Story 2.6 (Gender Screen) ✅ COMPLETE
**État:** Stories 2.1-2.6 complétées (60% Epic 2)
**Branche actuelle:** `feature/epic-2-story-6-onboarding-gender-screen`

---

## 🎯 OBJECTIF

Implémenter l'écran de sélection du **niveau d'activité physique** (Étape 4/5 du flow onboarding).

L'utilisateur doit choisir parmi **5 niveaux d'activité** :
1. **Sédentaire** - Peu ou pas d'exercice
2. **Léger** - 1-3x/semaine
3. **Modéré** - 3-5x/semaine
4. **Très actif** - 6-7x/semaine
5. **Extrêmement actif** - Sport intense quotidien

---

## 📚 FICHIERS À LIRE AVANT DE COMMENCER

**OBLIGATOIRE (ordre de lecture):**
```
1. docs/stories/epic-2/dev-context-epic-2.md
2. docs/stories/epic-2/story-2.7-onboarding-activity-screen.md
3. lib/domain/entities/activity_level.dart (déjà existe - Story 2.1)
4. lib/presentation/screens/onboarding/onboarding_gender_screen.dart (référence UI)
5. lib/presentation/providers/onboarding_provider.dart (state management)
6. docs/definition-of-done.md
```

---

## ✅ ACCEPTANCE CRITERIA (7 AC)

1. ✅ L'écran `OnboardingActivityScreen` s'affiche après l'écran genre
2. ✅ L'écran affiche : titre "Niveau d'activité physique", sous-titre "À quelle fréquence fais-tu du sport ?"
3. ✅ **Cinq options** sous forme de cards :
   - Sédentaire (peu ou pas d'exercice)
   - Léger (1-3x/semaine)
   - Modéré (3-5x/semaine)
   - Très actif (6-7x/semaine)
   - Extrêmement actif (sport intense quotidien)
4. ✅ Chaque card affiche un **icon visuel** + **label** + **description courte**
5. ✅ L'option sélectionnée est **highlight visuellement** (border + background primaire)
6. ✅ Bouton "Suivant" activé **seulement si** une option est sélectionnée
7. ✅ Indicateur de progression **"Étape 4 sur 5"** visible en haut

---

## 🏗️ ARCHITECTURE

### Fichiers à créer

```
lib/presentation/screens/onboarding/
  onboarding_activity_screen.dart          # UI Screen (ConsumerStatefulWidget)

test/presentation/screens/onboarding/
  onboarding_activity_screen_test.dart     # Widget tests
```

### Pattern UI (même que Gender Screen)

```dart
class OnboardingActivityScreen extends ConsumerStatefulWidget {
  // State local: ActivityLevel? _selectedActivity

  // Méthodes:
  // - _selectActivity(ActivityLevel activity)
  // - _handleNext() → updateActivityLevel() + Navigation vers /onboarding_location
  // - _buildActivityCard(...)

  // UI:
  // - AppBar avec bouton retour
  // - "Étape 4 sur 5"
  // - Titre + Sous-titre
  // - 5 Cards scrollables (SingleChildScrollView)
  // - Bouton "Suivant" (enabled si sélection)
}
```

---

## 🎨 SPÉCIFICATIONS UI

### Layout

```
AppBar (transparent, back button)
  ↓
SingleChildScrollView
  ↓
Padding(24)
  ↓
Column:
  - Text "Étape 4 sur 5" (bodySmall, grey)
  - SizedBox(32)
  - Text "Niveau d'activité physique" (headlineMedium, bold)
  - SizedBox(12)
  - Text "À quelle fréquence fais-tu du sport ?" (bodyMedium, grey)
  - SizedBox(48)
  - _buildActivityCard(sedentary, "Sédentaire", "Peu ou pas d'exercice", Icons.weekend)
  - SizedBox(16)
  - _buildActivityCard(light, "Léger", "1-3 fois par semaine", Icons.directions_walk)
  - SizedBox(16)
  - _buildActivityCard(moderate, "Modéré", "3-5 fois par semaine", Icons.directions_run)
  - SizedBox(16)
  - _buildActivityCard(veryActive, "Très actif", "6-7 fois par semaine", Icons.fitness_center)
  - SizedBox(16)
  - _buildActivityCard(extremelyActive, "Extrêmement actif", "Sport intense quotidien", Icons.local_fire_department)
  - SizedBox(48)
  - ElevatedButton "Suivant" (enabled si _selectedActivity != null)
```

### Card Design

```dart
InkWell(
  onTap: () => _selectActivity(activity),
  child: Card(
    elevation: isSelected ? 4 : 1,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(
        color: isSelected ? primary : outline.withValues(alpha: 0.2),
        width: isSelected ? 2 : 1,
      ),
    ),
    child: Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isSelected ? primary.withValues(alpha: 0.1) : null,
      ),
      child: Row(
        children: [
          Icon(icon, size: 32, color: isSelected ? primary : grey),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: titleMedium, fontWeight: isSelected ? bold : normal),
                SizedBox(height: 4),
                Text(description, style: bodySmall, color: grey),
              ],
            ),
          ),
        ],
      ),
    ),
  ),
)
```

### Icons Recommandés

```dart
ActivityLevel.sedentary → Icons.weekend
ActivityLevel.light → Icons.directions_walk
ActivityLevel.moderate → Icons.directions_run
ActivityLevel.veryActive → Icons.fitness_center
ActivityLevel.extremelyActive → Icons.local_fire_department
```

---

## 🔗 NAVIGATION

### Route à créer dans main.dart

```dart
'/onboarding_activity': (context) => const OnboardingActivityScreen(),
```

### Navigation flow

```
Gender Screen (2.6)
  → [Suivant] → Activity Screen (2.7)
  → [Suivant] → Location Screen (2.8 - PAS ENCORE IMPLÉMENTÉ)
```

**IMPORTANT:** La navigation vers `/onboarding_location` échouera silencieusement car Story 2.8 n'existe pas encore. C'est **normal et accepté** pour cette story.

---

## 🧪 TESTS REQUIS

### Widget Tests (onboarding_activity_screen_test.dart)

```dart
group('OnboardingActivityScreen', () {
  testWidgets('should display activity level selection screen', (tester) async {
    // Arrange
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: const OnboardingActivityScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Niveau d\'activité physique'), findsOneWidget);
    expect(find.text('Sédentaire'), findsOneWidget);
    expect(find.text('Léger'), findsOneWidget);
    expect(find.text('Modéré'), findsOneWidget);
    expect(find.text('Très actif'), findsOneWidget);
    expect(find.text('Extrêmement actif'), findsOneWidget);
    expect(find.text('Étape 4 sur 5'), findsOneWidget);
  });

  testWidgets('next button should be disabled when no activity selected', (tester) async {
    // Test bouton disabled
  });

  testWidgets('should enable next button when activity is selected', (tester) async {
    // Test bouton enabled après sélection
  });

  testWidgets('should highlight selected activity card', (tester) async {
    // Test visual feedback
  });
});
```

---

## 📝 ÉTAPES D'IMPLÉMENTATION

### 1. Préparation (5 min)
- [ ] Créer branche `feature/epic-2-story-7-onboarding-activity-screen`
- [ ] Lire tous les fichiers obligatoires listés ci-dessus

### 2. Implémentation UI (30 min)
- [ ] Créer `lib/presentation/screens/onboarding/onboarding_activity_screen.dart`
- [ ] Implémenter ConsumerStatefulWidget
- [ ] State local `ActivityLevel? _selectedActivity`
- [ ] Méthode `_selectActivity(ActivityLevel activity)`
- [ ] Méthode `_handleNext()` avec `updateActivityLevel()` + navigation
- [ ] Méthode `_buildActivityCard(...)` avec 5 paramètres
- [ ] UI complète avec 5 cards scrollables
- [ ] Bouton "Suivant" conditionnel
- [ ] AppBar avec bouton retour

### 3. Navigation (5 min)
- [ ] Ajouter route `/onboarding_activity` dans `lib/main.dart`
- [ ] Ajouter import `OnboardingActivityScreen`
- [ ] Tester navigation depuis Gender Screen (Story 2.6)

### 4. Tests (20 min)
- [ ] Créer `test/presentation/screens/onboarding/onboarding_activity_screen_test.dart`
- [ ] Test: display all activity options
- [ ] Test: next button disabled by default
- [ ] Test: next button enabled when activity selected
- [ ] Test: visual highlight on selection
- [ ] Exécuter `flutter test test/presentation/screens/onboarding/onboarding_activity_screen_test.dart`

### 5. Validation Finale (10 min)
- [ ] `flutter test` → Tous les tests passent
- [ ] `flutter analyze` → 0 nouvelles erreurs critiques
- [ ] Test manuel : Navigation Weight → Age → Gender → Activity
- [ ] Visual check : Cards, Icons, Spacing, Highlight

### 6. Commit & Reports (10 min)
- [ ] Commit: `[EPIC-2.7] Implement onboarding activity screen`
- [ ] Créer `docs/stories/epic-2/reports/story-2.7-completion-report.md`
- [ ] Créer `docs/stories/epic-2/reports/story-2.7-dod-report.md`

---

## 🚨 PIÈGES À ÉVITER

1. ❌ **NE PAS créer Story 2.8 (Location Screen)** - Hors scope
2. ❌ **NE PAS modifier `activity_level.dart`** - Déjà créé en Story 2.1
3. ❌ **NE PAS oublier** le `initState()` pour pré-remplir si `state.activityLevel != null`
4. ❌ **NE PAS utiliser** `Icons.sports` (générique) - Utiliser les icons spécifiques listés
5. ✅ **IMPORTANT:** Navigation vers `/onboarding_location` échouera silencieusement (Story 2.8 pas implémentée) - C'est normal !

---

## 🎨 RÉFÉRENCE VISUELLE

**Inspiration:** Même design que Gender Screen (Story 2.6) mais avec 5 cards verticales au lieu de 3.

**Cards:** Row layout (Icon à gauche, Texte à droite) au lieu de Column (Icon en haut, Texte en bas)

---

## 📏 CONVENTIONS

- **Fichiers:** snake_case
- **Classes:** PascalCase
- **Variables:** camelCase
- **Dartdoc:** Obligatoire pour toutes les méthodes publiques
- **State Management:** Riverpod (ConsumerStatefulWidget)
- **Navigation:** Named routes (`Navigator.of(context).pushNamed(...)`)

---

## ✅ DEFINITION OF DONE

- [ ] Tous les 7 AC validés
- [ ] Widget tests créés et passent (4 tests minimum)
- [ ] `flutter test` → 0 nouvelles erreurs
- [ ] `flutter analyze` → 0 nouvelles erreurs critiques
- [ ] Code suit conventions (snake_case, dartdoc, etc.)
- [ ] Navigation testée manuellement (Weight → Age → Gender → Activity)
- [ ] Icons appropriés utilisés (5 différents)
- [ ] Commit avec message `[EPIC-2.7] Implement onboarding activity screen`
- [ ] Reports créés dans `docs/stories/epic-2/reports/`

---

## 🔗 RESSOURCES

**Story File:**
- `docs/stories/epic-2/story-2.7-onboarding-activity-screen.md`

**Dev Context:**
- `docs/stories/epic-2/dev-context-epic-2.md`

**Référence UI:**
- `lib/presentation/screens/onboarding/onboarding_gender_screen.dart` (Story 2.6)

**Enum ActivityLevel:**
- `lib/domain/entities/activity_level.dart`

**Provider:**
- `lib/presentation/providers/onboarding_provider.dart`

---

## 🚀 COMMANDE DE DÉMARRAGE

```bash
# Créer branche
git checkout -b feature/epic-2-story-7-onboarding-activity-screen

# Lancer story
@dev Implémente Story 2.7 - Onboarding Activity Level Screen.
Suis le prompt dans .ai/story-2.7-prompt.md.
```

---

**Durée estimée:** 1h20 (80 minutes)
**Effort:** Medium
**Agent:** @dev

---

*Prompt créé par @bmad-master - 2026-01-14*
