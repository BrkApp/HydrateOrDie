# Hotfix Epic 3 - Bug #2: Progress Bar Stagne à 0% + Historique Vide

**Sévérité:** 🔴 CRITIQUE
**Epic:** 3
**Stories Affectées:** 3.6, 3.7 (Record Hydration + Avatar Feedback)

---

## 🐛 Problème

Après avoir enregistré une hydratation via le flow complet (photo + glass size), la progress bar reste bloquée à 0% et l'historique "Dernière hydratation" ne se met jamais à jour.

**Cause racine:** HomeScreen utilise `const currentVolume = 0;` (hardcodé) au lieu de récupérer les vrais logs depuis `HydrationLogRepository`.

---

## 🎯 Solution

**Fichier:** `lib/presentation/screens/home/home_screen.dart`

### Changements Requis

**Ligne 60-62:** Remplacer le placeholder par une vraie récupération des logs.

**AVANT:**
```dart
// TODO(Story 3.2): Replace with actual hydration logs from HydrationLogRepository
const currentVolume = 0; // Placeholder until Story 3.2 (in mL)
final goalReached = currentVolume >= goalVolume;
```

**APRÈS:**
```dart
// Calculate today's hydration volume from logs
final logs = ref.watch(hydrationLogsProvider); // Provider à créer
final currentVolume = logs.when(
  data: (logsList) {
    // Sum volumes from today's logs only
    final now = DateTime.now();
    final todayLogs = logsList.where((log) {
      final logDate = log.timestamp;
      return logDate.year == now.year &&
             logDate.month == now.month &&
             logDate.day == now.day;
    });
    return todayLogs.fold<int>(0, (sum, log) => sum + log.volumeMl);
  },
  loading: () => 0,
  error: (_, __) => 0,
);
final goalReached = currentVolume >= goalVolume;
```

---

## 📦 Provider Manquant

**Créer:** `lib/presentation/providers/hydration_logs_provider.dart`

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydrate_or_die/core/di/injection.dart';
import 'package:hydrate_or_die/domain/entities/hydration_log.dart';
import 'package:hydrate_or_die/domain/repositories/hydration_log_repository.dart';

/// Provider to fetch all hydration logs for current user
final hydrationLogsProvider = FutureProvider<List<HydrationLog>>((ref) async {
  final repository = getIt<HydrationLogRepository>();
  // Assuming singleton user ID = '1'
  return repository.getLogsForUser('1');
});
```

**Import requis dans home_screen.dart:**
```dart
import 'package:hydrate_or_die/presentation/providers/hydration_logs_provider.dart';
```

---

## 🔄 Rafraîchissement Auto

Pour que la progress bar se mette à jour **immédiatement** après enregistrement, il faut invalider le provider après `RecordHydrationUseCase`.

**Option 1:** Invalider dans PhotoValidationScreen après record:
```dart
// After recording hydration
ref.invalidate(hydrationLogsProvider);
Navigator.of(context).pop(); // Return to HomeScreen
```

**Option 2:** Utiliser StreamProvider pour auto-refresh (plus robuste).

---

## ✅ Validation

Après fix:
1. HomeScreen → Tap "J'ai bu !"
2. Capturer photo
3. Sélectionner glass size (ex: 250ml)
4. Valider
5. **Vérifications:**
   - [ ] Progress bar passe de 0% → X% (ex: 12.5% si 250ml/2000ml)
   - [ ] "Dernière hydratation: À l'instant" s'affiche
   - [ ] Animation progress bar visible (500ms)
6. Kill app + Restart
7. **Vérifications:**
   - [ ] Progress bar conserve la valeur (ex: 12.5%)
   - [ ] Historique visible avec heure correcte

---

## 📊 Impact

- **Files modifiés:** 2
  - `home_screen.dart` (logic currentVolume)
  - `hydration_logs_provider.dart` (nouveau)
- **Lines changed:** ~30-40
- **Tests requis:**
  - Widget test HomeScreen avec logs
  - Integration test full hydration flow

---

## 🚨 Note Critique

Ce bug **bloque complètement la validation Epic 3**. Sans ce fix:
- Story 3.6 (Record Hydration) non fonctionnelle en apparence
- Story 3.7 (Avatar Feedback) invisible
- UX complètement cassée (aucun feedback utilisateur)

---

**Priorité:** P0 (BLOQUANT)
**Durée estimée:** 20-30 min
