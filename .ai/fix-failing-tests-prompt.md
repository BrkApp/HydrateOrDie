# Prompt - Fix Failing Tests Epic 3

## Contexte

Epic 3 quasi-complet (9/10 stories), mais **37 tests échouent** sur flutter test.

**Problème:** Tests d'intégration SQLite + tests présentation en échec.

## Mission

1. **Identifier les tests en échec:**
   - Exécuter `flutter test --concurrency=1` et analyser output complet
   - Lister tous les tests FAILED avec messages d'erreur
   - Catégoriser par type (unit/widget/integration)

2. **Fixer les erreurs:**
   - Tests d'intégration SQLite: Vérifier isolation DB entre tests
   - Tests widget: Vérifier mocks/providers
   - Tests unit: Vérifier logique/assertions

3. **Valider:**
   - flutter test --concurrency=1 doit passer à 100%
   - flutter analyze doit être 0 errors

## Contraintes

- NE PAS skip de tests
- NE PAS modifier la logique métier pour faire passer tests
- Fixer les vraies causes racines
- Tous les tests doivent passer (0 failed)

## Résultat Attendu

```bash
flutter test --concurrency=1
# Output: +695 tests passed (0 failed)
```

## Démarrage

Commence par:
```bash
flutter test --concurrency=1 > test_results.txt 2>&1
```

Puis analyse test_results.txt pour identifier TOUS les tests en échec.
