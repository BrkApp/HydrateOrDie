# Hotfix Epic 3 - Fix 18 Tests Restants

**Context:** Après hotfixes (avatar selection + glass size no pre-selection), 18 tests échouent encore.

---

## 🎯 Mission

Identifier et fixer les **18 tests en échec** après modifications hotfix:
1. Avatar selection ajouté en premier dans onboarding flow
2. Glass size `_selectedSize` changé de `GlassSize.medium` → `GlassSize?` (nullable, null par défaut)
3. Instructions glass size changées

---

## ✅ Tests Déjà Fixés

- ✅ `test/presentation/screens/photo/glass_size_selection_screen_test.dart` (2 tests fixés)
- ✅ `test/presentation/screens/onboarding/onboarding_flow_screen_test.dart` (12/12 passent)

---

## 🔍 Identifier Tests en Échec

```bash
flutter test --concurrency=1
```

**Résultat attendu:** 732 tests total, 18 en échec.

**Commandes debug:**
```bash
# Output complet dans fichier
flutter test --concurrency=1 > test_results.txt 2>&1

# Filtrer les échecs
grep -A 10 "FAILED" test_results.txt
```

---

## 🚨 Causes Probables

### Hypothèse A: Tests Onboarding Provider
- `onboarding_provider_test.dart` peut s'attendre à 6 étapes au lieu de 7
- Vérifier assertions sur nombre de steps

### Hypothèse B: Tests Integration Onboarding
- Tests end-to-end onboarding flow
- Peut manquer step avatar selection dans séquence

### Hypothèse C: Tests Widget Autres Screens
- Peut-être tests qui créent OnboardingFlowScreen et s'attendent à structure ancienne

---

## 📝 Fix Pattern

Pour chaque test en échec:

1. **Lire le test**
2. **Identifier l'assertion cassée**
3. **Mettre à jour pour refléter:**
   - 7 steps au lieu de 6 (avatar selection ajouté)
   - Pas de pré-sélection glass size
   - Nouveau texte instructions

---

## ✅ Validation

Après fix:
```bash
flutter test --concurrency=1
# Expected: +732 tests (100% pass)
```

---

## 📊 Fichiers Suspects

- `test/presentation/providers/onboarding_provider_test.dart`
- `test/presentation/screens/onboarding/*_test.dart`
- Tests d'intégration onboarding

---

**Priorité:** P0 (BLOQUANT)
**Durée estimée:** 15-20 min
