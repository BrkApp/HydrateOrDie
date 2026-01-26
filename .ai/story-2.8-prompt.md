# 🎯 Prompt Story 2.8 - Écran Onboarding Localisation (Optionnel)

**Date:** 2026-01-14
**Agent:** @dev
**Epic:** 2 - User Onboarding & Personnalisation
**Story:** 2.8 - Onboarding Location Permission Screen

---

## 📋 CONTEXTE

**Précédent:** Story 2.7 (Activity Screen) ✅ COMPLETE
**État:** Stories 2.1-2.7 complétées (70% Epic 2)
**Branche actuelle:** `feature/epic-2-story-7-onboarding-activity-screen`

---

## 🎯 OBJECTIF

Implémenter l'écran de **permission de localisation** (Étape 5/5 du flow onboarding).

**IMPORTANT:** Cet écran est **OPTIONNEL** - l'utilisateur peut autoriser ou refuser, les deux choix permettent de progresser.

**Objectif futur (V2):** Ajuster les rappels d'hydratation en fonction de la météo locale (ex: canicule).

---

## 📚 FICHIERS À LIRE AVANT DE COMMENCER

**OBLIGATOIRE (ordre de lecture):**
```
1. docs/stories/epic-2/dev-context-epic-2.md
2. docs/stories/epic-2/story-2.8-onboarding-location-screen.md
3. lib/presentation/screens/onboarding/onboarding_activity_screen.dart (référence UI)
4. lib/presentation/providers/onboarding_provider.dart (updateLocation method)
5. docs/dependencies.md (vérifier si permission_handler est approuvé)
6. docs/definition-of-done.md
```

---

## ✅ ACCEPTANCE CRITERIA (8 AC)

1. ✅ L'écran `OnboardingLocationScreen` s'affiche après l'écran activité
2. ✅ L'écran affiche : titre **"Autoriser la localisation ?"**, sous-titre **"Optionnel : permettra d'ajuster les rappels en fonction de la météo (canicule)"**
3. ✅ Deux boutons verticaux :
   - **"Autoriser"** (bouton primaire ElevatedButton)
   - **"Pas maintenant"** (bouton secondaire OutlinedButton)
4. ✅ Si "Autoriser" : demande la **permission système** via `permission_handler`
5. ✅ Si permission accordée : enregistre `locationPermissionGranted = true` dans provider
6. ✅ Si "Pas maintenant" OU permission refusée : enregistre `locationPermissionGranted = false`
7. ✅ Indicateur de progression **"Étape 5 sur 5"** visible en haut
8. ✅ Les deux options permettent de **progresser vers Summary Screen** (Story 2.9)

---

## 🏗️ ARCHITECTURE

### Fichiers à créer

```
lib/presentation/screens/onboarding/
  onboarding_location_screen.dart          # UI Screen (ConsumerWidget)

test/presentation/screens/onboarding/
  onboarding_location_screen_test.dart     # Widget tests
```

### Package à ajouter

**IMPORTANT:** Vérifier d'abord si `permission_handler` est dans les dépendances approuvées.

Si OUI → Ajouter dans `pubspec.yaml`:
```yaml
dependencies:
  permission_handler: ^11.0.0
```

Si NON → **Utiliser une approche simplifiée** sans package (voir section Alternative ci-dessous).

---

## 🎨 SPÉCIFICATIONS UI

### Layout

```
AppBar (transparent, back button)
  ↓
SafeArea
  ↓
Padding(24)
  ↓
Column:
  - Text "Étape 5 sur 5" (bodySmall, grey)
  - SizedBox(32)
  - Icon(Icons.location_on, size: 80, color: primary)
  - SizedBox(24)
  - Text "Autoriser la localisation ?" (headlineMedium, bold, center)
  - SizedBox(12)
  - Text "Optionnel : permettra d'ajuster les rappels..." (bodyMedium, grey, center)
  - SizedBox(48)
  - ElevatedButton "Autoriser" (primaire, full width)
  - SizedBox(16)
  - OutlinedButton "Pas maintenant" (secondaire, full width)
  - Spacer()
```

### Boutons Design

```dart
// Bouton primaire
ElevatedButton(
  onPressed: _handleAuthorize,
  style: ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  child: const Text(
    'Autoriser',
    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  ),
)

// Bouton secondaire
OutlinedButton(
  onPressed: _handleSkip,
  style: OutlinedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  child: Text(
    'Pas maintenant',
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
    ),
  ),
)
```

---

## 🔧 IMPLÉMENTATION

### Option A: Avec permission_handler (si approuvé)

```dart
import 'package:permission_handler/permission_handler.dart';

class OnboardingLocationScreen extends ConsumerWidget {
  const OnboardingLocationScreen({super.key});

  Future<void> _handleAuthorize(BuildContext context, WidgetRef ref) async {
    // Demander permission
    final status = await Permission.location.request();

    if (status.isGranted) {
      // Permission accordée
      ref.read(onboardingProvider.notifier).updateLocation('granted');
    } else {
      // Permission refusée
      ref.read(onboardingProvider.notifier).updateLocation(null);
    }

    // Naviguer vers Summary (Story 2.9)
    if (context.mounted) {
      Navigator.of(context).pushNamed('/onboarding_summary');
    }
  }

  void _handleSkip(BuildContext context, WidgetRef ref) {
    // Pas de permission
    ref.read(onboardingProvider.notifier).updateLocation(null);

    // Naviguer vers Summary
    Navigator.of(context).pushNamed('/onboarding_summary');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // UI ici
  }
}
```

### Option B: Sans permission_handler (approche simplifiée)

```dart
class OnboardingLocationScreen extends ConsumerWidget {
  const OnboardingLocationScreen({super.key});

  void _handleAuthorize(BuildContext context, WidgetRef ref) {
    // Simuler autorisation (pas de vraie demande système)
    ref.read(onboardingProvider.notifier).updateLocation('mock_granted');

    // TODO: Implémenter vraie permission en V2
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Localisation activée (mode développement)'),
        duration: Duration(seconds: 2),
      ),
    );

    // Naviguer vers Summary
    Navigator.of(context).pushNamed('/onboarding_summary');
  }

  void _handleSkip(BuildContext context, WidgetRef ref) {
    ref.read(onboardingProvider.notifier).updateLocation(null);
    Navigator.of(context).pushNamed('/onboarding_summary');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // UI ici
  }
}
```

**RECOMMANDATION:** Utiliser **Option B** (simplifiée) pour MVP, implémenter vraie permission en V2.

---

## 🔗 NAVIGATION

### Route à créer dans main.dart

```dart
'/onboarding_location': (context) => const OnboardingLocationScreen(),
```

### Navigation flow

```
Activity Screen (2.7)
  → [Suivant] → Location Screen (2.8)
  → [Autoriser OU Pas maintenant] → Summary Screen (2.9 - PAS ENCORE IMPLÉMENTÉ)
```

**IMPORTANT:** La navigation vers `/onboarding_summary` échouera silencieusement car Story 2.9 n'existe pas encore. C'est **normal et accepté** pour cette story.

---

## 🧪 TESTS REQUIS

### Widget Tests (onboarding_location_screen_test.dart)

```dart
group('OnboardingLocationScreen', () {
  testWidgets('should display location permission screen', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: const OnboardingLocationScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Autoriser la localisation ?'), findsOneWidget);
    expect(find.text('Autoriser'), findsOneWidget);
    expect(find.text('Pas maintenant'), findsOneWidget);
    expect(find.text('Étape 5 sur 5'), findsOneWidget);
    expect(find.byIcon(Icons.location_on), findsOneWidget);
  });

  testWidgets('should update provider when skip is pressed', (tester) async {
    // Test "Pas maintenant" → updateLocation(null)
  });

  testWidgets('should show both buttons as enabled', (tester) async {
    // Test que les 2 boutons sont toujours enabled (pas bloquant)
  });
});
```

---

## 📝 ÉTAPES D'IMPLÉMENTATION

### 1. Préparation (5 min)
- [ ] Créer branche `feature/epic-2-story-8-onboarding-location-screen`
- [ ] Lire tous les fichiers obligatoires listés ci-dessus
- [ ] **DÉCISION:** Choisir Option A (permission_handler) OU Option B (simplifiée)

### 2. Dépendances (5 min - SI Option A)
- [ ] Vérifier `docs/dependencies.md` si `permission_handler` est approuvé
- [ ] Si OUI: Ajouter dans `pubspec.yaml`
- [ ] Si NON: Utiliser Option B (simplifiée)
- [ ] `flutter pub get`

### 3. Implémentation UI (25 min)
- [ ] Créer `lib/presentation/screens/onboarding/onboarding_location_screen.dart`
- [ ] Implémenter ConsumerWidget
- [ ] Méthode `_handleAuthorize()` avec demande permission (Option A) OU mock (Option B)
- [ ] Méthode `_handleSkip()` avec `updateLocation(null)`
- [ ] UI complète avec Icon + Titre + Sous-titre + 2 boutons
- [ ] AppBar avec bouton retour
- [ ] Indicateur "Étape 5 sur 5"

### 4. Navigation (5 min)
- [ ] Ajouter route `/onboarding_location` dans `lib/main.dart`
- [ ] Ajouter import `OnboardingLocationScreen`
- [ ] Tester navigation depuis Activity Screen (Story 2.7)

### 5. Tests (15 min)
- [ ] Créer `test/presentation/screens/onboarding/onboarding_location_screen_test.dart`
- [ ] Test: display location permission screen
- [ ] Test: update provider when skip is pressed
- [ ] Test: both buttons enabled
- [ ] Exécuter `flutter test test/presentation/screens/onboarding/onboarding_location_screen_test.dart`

### 6. Validation Finale (10 min)
- [ ] `flutter test` → Tous les tests passent
- [ ] `flutter analyze` → 0 nouvelles erreurs critiques
- [ ] Test manuel : Navigation Weight → Age → Gender → Activity → Location
- [ ] Test manuel : Tester "Autoriser" ET "Pas maintenant"

### 7. Commit & Reports (10 min)
- [ ] Commit: `[EPIC-2.8] Implement onboarding location screen`
- [ ] Créer `docs/stories/epic-2/reports/story-2.8-completion-report.md`
- [ ] Créer `docs/stories/epic-2/reports/story-2.8-dod-report.md`

---

## 🚨 PIÈGES À ÉVITER

1. ❌ **NE PAS bloquer** l'utilisateur si permission refusée - Les 2 choix doivent progresser
2. ❌ **NE PAS créer Story 2.9 (Summary Screen)** - Hors scope
3. ❌ **NE PAS modifier** `onboarding_provider.dart` - `updateLocation()` existe déjà
4. ❌ **NE PAS ajouter** `permission_handler` sans vérifier `docs/dependencies.md` d'abord
5. ✅ **IMPORTANT:** Navigation vers `/onboarding_summary` échouera silencieusement (Story 2.9 pas implémentée) - C'est normal !
6. ✅ **RECOMMANDATION:** Utiliser Option B (simplifiée) pour MVP, implémenter vraie permission en V2

---

## 🎨 RÉFÉRENCE VISUELLE

**Design:** Layout centré vertical avec:
- Grand icon `Icons.location_on` (80px)
- Titre + Sous-titre centrés
- 2 boutons full-width empilés verticalement
- Différent de Gender/Activity (pas de cards cliquables)

---

## 📏 CONVENTIONS

- **Fichiers:** snake_case
- **Classes:** PascalCase
- **Variables:** camelCase
- **Dartdoc:** Obligatoire pour toutes les méthodes publiques
- **State Management:** Riverpod (ConsumerWidget, pas StatefulWidget)
- **Navigation:** Named routes (`Navigator.of(context).pushNamed(...)`)

---

## ✅ DEFINITION OF DONE

- [ ] Tous les 8 AC validés
- [ ] Widget tests créés et passent (3 tests minimum)
- [ ] `flutter test` → 0 nouvelles erreurs
- [ ] `flutter analyze` → 0 nouvelles erreurs critiques
- [ ] Code suit conventions (snake_case, dartdoc, etc.)
- [ ] Navigation testée manuellement (Weight → Age → Gender → Activity → Location)
- [ ] Les 2 flows testés ("Autoriser" et "Pas maintenant")
- [ ] Commit avec message `[EPIC-2.8] Implement onboarding location screen`
- [ ] Reports créés dans `docs/stories/epic-2/reports/`

---

## 🔗 RESSOURCES

**Story File:**
- `docs/stories/epic-2/story-2.8-onboarding-location-screen.md`

**Dev Context:**
- `docs/stories/epic-2/dev-context-epic-2.md`

**Référence UI:**
- `lib/presentation/screens/onboarding/onboarding_activity_screen.dart` (Story 2.7)

**Provider:**
- `lib/presentation/providers/onboarding_provider.dart` (updateLocation method)

**Dependencies:**
- `docs/dependencies.md` (vérifier permission_handler)

---

## 🚀 COMMANDE DE DÉMARRAGE

```bash
# Créer branche
git checkout -b feature/epic-2-story-8-onboarding-location-screen

# Lancer story
@dev Implémente Story 2.8 - Onboarding Location Permission Screen.
Suis le prompt dans .ai/story-2.8-prompt.md.
Utilise l'Option B (simplifiée sans permission_handler) pour MVP.
```

---

**Durée estimée:** 1h15 (75 minutes)
**Effort:** Medium
**Agent:** @dev

---

## 📌 NOTES IMPORTANTES

### Pourquoi cet écran est optionnel ?

La localisation sera utilisée en **V2** pour :
- Détecter la météo locale (API météo)
- Ajuster les rappels d'hydratation en cas de canicule (+15% goal)
- Proposer des points d'eau à proximité (carte)

Pour le **MVP (Epic 2)**, on collecte juste la préférence utilisateur, sans utiliser vraiment la localisation.

### Permission système Android/iOS

Si vous implémentez avec `permission_handler`, ajoutez aussi:

**Android** (`android/app/src/main/AndroidManifest.xml`):
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

**iOS** (`ios/Runner/Info.plist`):
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Nous utilisons votre localisation pour ajuster les rappels d'hydratation selon la météo.</string>
```

Mais pour **Option B (simplifiée)**, ces configurations ne sont pas nécessaires.

---

*Prompt créé par @bmad-master - 2026-01-14*
