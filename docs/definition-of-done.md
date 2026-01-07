# Definition of Done (DoD) - Hydrate or Die

**Version:** 1.0
**Date:** 2026-01-07
**Owner:** Product Manager John
**Status:** MANDATORY - Checklist obligatoire pour chaque story

---

## 🎯 Objectif

Ce document définit la **checklist obligatoire** que CHAQUE story doit satisfaire avant d'être considérée "Done".

**Règle d'or :** Une story ne peut être marquée "Done" que si TOUS les items de cette checklist sont ✅.

---

## 📋 Checklist Definition of Done

### 1. Requirements & Acceptance Criteria

- [ ] **Tous les acceptance criteria de la story sont remplis**
  - Chaque AC listé dans l'epic est implémenté
  - Aucun AC n'est skip ou partiellement fait
  - Comportement vérifié manuellement

- [ ] **Le scope de la story est respecté strictement**
  - Pas de features "bonus" ajoutées sans validation PM
  - Pas de scope drift (modifications non autorisées)
  - Si changement nécessaire découvert → Nouvelle story créée, pas de modification à la volée

- [ ] **Les edge cases identifiés sont gérés**
  - Cas nominaux fonctionnent
  - Cas d'erreur gérés (user errors, network errors, etc.)
  - Fallbacks implémentés si applicable

---

### 2. Code Quality

- [ ] **Code respecte les conventions Flutter/Dart**
  - Naming conventions respectées (PascalCase classes, camelCase variables, etc.)
  - Structure de fichiers conforme à `docs/governance.md`
  - Imports organisés (dart: → package: → relative)

- [ ] **`dart format .` exécuté sans modifications nécessaires**
  - Code formaté selon Flutter conventions
  - Ligne max 80 caractères respectée
  - Pas de trailing whitespaces

- [ ] **`dart analyze` ne rapporte AUCUN warning/error**
  - Aucune erreur de compilation
  - Aucun warning (unused imports, variables, etc.)
  - Score analysis : 0 issues

- [ ] **Dartdoc présent pour toutes les classes/méthodes publiques**
  - Chaque classe publique a un /// comment descriptif
  - Chaque méthode publique documente params et return value
  - Edge cases documentés dans dartdoc si pertinent

- [ ] **Aucun code commenté laissé dans les fichiers**
  - Pas de blocs de code commentés (dead code)
  - Pas de `// TODO` ou `// FIXME` non résolus
  - Si TODO nécessaire → Créer une story pour le tracking, pas de TODO inline

- [ ] **Aucun hardcoded values (utiliser constants)**
  - Pas de magic numbers (ex: `if (duration > 7200)` → `if (duration > kTwoHoursInSeconds)`)
  - Constants définis dans `lib/core/constants/`
  - Configuration externalisée si applicable

- [ ] **Gestion des erreurs complète**
  - Toutes les opérations async wrappées en try-catch
  - Erreurs loggées avec contexte (via logger package ou print debug)
  - Messages d'erreur user-friendly (pas de stack traces brutes à l'utilisateur)

---

### 3. Testing

- [ ] **Unit tests écrits et passent**
  - Tous les use cases ont des tests unitaires
  - Tous les models ont des tests (toJson, fromJson, validation)
  - Toute logique de calcul testée (hydratation goal, streak, etc.)
  - Coverage minimum respecté : Domain 80%, Data 70%

- [ ] **Widget tests écrits et passent (si story UI)**
  - Écrans principaux testés (affichage, navigation)
  - Widgets réutilisables testés
  - Interactions utilisateur testées (tap, input, etc.)
  - Coverage minimum : Presentation 50%

- [ ] **Integration tests écrits et passent (si story critique)**
  - Flows critiques testés end-to-end
  - Persistence vérifiée (sauvegarde → reload → données présentes)
  - Navigation multi-écrans testée

- [ ] **Tous les tests existants passent toujours (non-régression)**
  - `flutter test` passe à 100%
  - Aucun test précédent cassé par les changements
  - Si un test existant doit changer → Justification documentée

- [ ] **Coverage report vérifié**
  - Exécuter `flutter test --coverage`
  - Vérifier `coverage/lcov.info` pour coverage par fichier
  - Atteindre ou dépasser les minimums requis

---

### 4. Build & CI/CD

- [ ] **Build réussit sur iOS (simulateur ou device)**
  - `flutter build ios` passe sans erreur
  - App lance sur simulateur iOS sans crash
  - Features testées fonctionnent sur iOS

- [ ] **Build réussit sur Android (émulateur ou device)**
  - `flutter build apk` passe sans erreur
  - App lance sur émulateur Android sans crash
  - Features testées fonctionnent sur Android

- [ ] **CI/CD pipeline passe (GitHub Actions)**
  - Tests automatiques passent sur CI
  - Analyse code passe (dart analyze)
  - Build passe sur CI
  - Aucun warning CI ignoré

- [ ] **Aucune nouvelle dépendance ajoutée sans validation PM**
  - Si nouvelle dépendance nécessaire → Validation PM obtenue
  - Dépendance documentée dans `docs/dependencies.md`
  - Version de la dépendance fixée (pas de `^` ou range large)

---

### 5. Database & Persistence

- [ ] **Schéma DB respecté (si story impacte DB)**
  - Tables créées selon `docs/contracts/database-schema.md`
  - Aucune déviation du schéma sans validation Architect
  - Migrations DB créées si nécessaire

- [ ] **Indexes créés si spécifiés dans schéma**
  - Performance queries vérifiée
  - Pas de full table scans sur grandes tables

- [ ] **Données persistées correctement**
  - Sauvegarde → Kill app → Relance app → Données présentes
  - Aucune perte de données après restart
  - Synchronisation cloud fonctionnelle (si applicable)

- [ ] **RGPD compliance respectée (si données personnelles)**
  - Consentement explicite obtenu si nécessaire
  - Données minimales collectées
  - Option de suppression implémentée (si applicable)

---

### 6. UI/UX (si story UI)

- [ ] **Design conforme aux specs UX (wireframes/maquettes)**
  - Layout respecté
  - Couleurs/fonts conformes au design system
  - Spacing/padding conformes

- [ ] **Responsive design vérifié**
  - Testé sur plusieurs tailles d'écran (small phone, tablet)
  - Pas d'overflow horizontal/vertical
  - Layout s'adapte correctement

- [ ] **Accessibility WCAG AA respectée**
  - Contraste couleurs suffisant (4.5:1 minimum)
  - Boutons suffisamment larges (44x44 minimum)
  - Labels accessibles pour screen readers
  - Support VoiceOver/TalkBack vérifié

- [ ] **Animations fluides (60 FPS)**
  - Aucun lag ou jank visible
  - Transitions smooth
  - Performance vérifiée sur device réel (pas que simulateur)

- [ ] **États de chargement gérés**
  - Loading indicators affichés pendant opérations async
  - Skeleton screens si chargement long
  - Pas de freeze UI

- [ ] **États vides gérés (empty states)**
  - Message clair si aucune donnée (ex: "Aucun historique pour l'instant")
  - Call-to-action si applicable (ex: "Commence à t'hydrater !")

---

### 7. Manual Testing

- [ ] **Happy path testé manuellement**
  - Flow nominal fonctionne de bout en bout
  - Comportement attendu vérifié
  - Screenshots pris (si UI) pour documentation

- [ ] **Edge cases testés manuellement**
  - Cas limites vérifiés (valeurs min/max, etc.)
  - Comportement avec données vides
  - Comportement après erreur

- [ ] **Test sur iOS ET Android**
  - Story testée sur les 2 plateformes
  - Aucune régression spécifique plateforme
  - Permissions gérées correctement sur les 2 OS

- [ ] **Test offline (si applicable)**
  - App fonctionne sans connexion réseau
  - Données locales accessibles
  - Sync automatique quand réseau revient

- [ ] **Test avec données réelles (pas que mock)**
  - Testé avec volume réaliste de données
  - Performance OK avec données réelles
  - Aucun bug découvert avec vraies données

---

### 8. Documentation

- [ ] **Dartdoc inline à jour**
  - Code auto-documenté via dartdoc
  - Changements dans comportement documentés

- [ ] **README.md mis à jour (si setup modifié)**
  - Instructions setup à jour
  - Nouvelles dépendances documentées
  - Commandes CLI mises à jour

- [ ] **Architecture doc mise à jour (si architecture changée)**
  - `docs/architecture.md` reflète les changements
  - Nouveaux patterns documentés

- [ ] **Contracts mis à jour (si interfaces changées)**
  - `docs/contracts/` à jour
  - Nouveaux models/APIs documentés

- [ ] **CHANGELOG.md mis à jour**
  - Ajout entrée pour la story complétée
  - Format : `[EPIC-X.Y] Description changement`

---

### 9. Git & Versioning

- [ ] **Branch nommée correctement**
  - Format : `feature/epic-X-story-Y-short-description`
  - Exemple : `feature/epic-1-story-2-avatar-models`

- [ ] **Commits bien formatés**
  - Format : `[EPIC-X.Y] Description`
  - Messages clairs et descriptifs
  - Commits atomiques (1 changement logique = 1 commit)

- [ ] **Pull Request créée**
  - PR de feature branch vers develop
  - Titre clair : `[EPIC-X.Y] Story description`
  - Description PR liste les AC complétés
  - Screenshots inclus (si UI)

- [ ] **Aucun fichier non pertinent commité**
  - Pas de fichiers IDE (.vscode, .idea)
  - Pas de fichiers générés (build/, .dart_tool/)
  - .gitignore respecté

- [ ] **Aucun conflict Git**
  - Branch à jour avec develop
  - Conflicts résolus proprement
  - Rebase clean

---

### 10. Review & Validation

- [ ] **Self-review effectuée par agent dev**
  - Agent a parcouru toute la checklist
  - Agent confirme que TOUS les items sont ✅
  - Agent a testé manuellement

- [ ] **Report de review soumis au PM**
  - Checklist complète fournie avec statuts
  - Screenshots/vidéos fournis pour démo
  - Justifications pour tout item ❌ (si applicable)

- [ ] **PM validation obtenue**
  - PM a reviewé le code
  - PM a testé manuellement les AC
  - PM a approuvé la PR

---

## 🚨 Critères Bloquants (MUST HAVE)

Ces items sont **BLOQUANTS ABSOLUS**. Si un seul est ❌, la story NE PEUT PAS être "Done" :

1. ❌ Tous les acceptance criteria pas remplis → **BLOCK**
2. ❌ `dart analyze` rapporte des errors → **BLOCK**
3. ❌ Tests unitaires ne passent pas → **BLOCK**
4. ❌ Build iOS ou Android fail → **BLOCK**
5. ❌ Régression détectée (tests existants cassés) → **BLOCK**
6. ❌ Scope drift (features non validées ajoutées) → **BLOCK**
7. ❌ Nouvelle dépendance sans validation PM → **BLOCK**
8. ❌ Edge cases critiques non gérés (crash possible) → **BLOCK**

---

## 📊 Process de Validation

### Étape 1 : Agent Dev Self-Review

L'agent dev exécute cette checklist complète et produit un report :

```markdown
## Story [EPIC-X.Y] - Definition of Done Report

### 1. Requirements & Acceptance Criteria
- [x] Tous les AC remplis
- [x] Scope respecté
- [x] Edge cases gérés

### 2. Code Quality
- [x] Conventions respectées
- [x] dart format OK
- [x] dart analyze OK (0 issues)
- [x] Dartdoc présent
- [x] Aucun code commenté
- [x] Constants utilisées
- [x] Gestion erreurs complète

### 3. Testing
- [x] Unit tests (coverage 85%)
- [x] Widget tests (coverage 60%)
- [x] Integration tests
- [x] Non-régression OK
- [x] Coverage vérifié

... (tous les items)

### Screenshots
[Inclure screenshots pour démo UI]

### Notes
[Tout commentaire pertinent]
```

### Étape 2 : PM Review

Le PM (moi) :
1. Lit le report de l'agent
2. Vérifie les items critiques
3. Teste manuellement les AC
4. **Décision** : ✅ APPROVE ou ❌ REJECT avec feedback

### Étape 3 : Corrections (si REJECT)

Si REJECT :
1. PM fournit feedback détaillé (quels items ❌, pourquoi)
2. Agent dev corrige
3. Agent re-soumet avec nouveau report
4. Loop jusqu'à APPROVE

### Étape 4 : Merge

Une fois APPROVE :
1. Merge PR vers develop
2. Story marquée "Done" dans tracking
3. Passage à la story suivante

---

## 🎓 Exemples de Reports

### Exemple 1 : Story APPROVED ✅

```markdown
## Story [EPIC-1.2] - Avatar Models - DoD Report

**Status:** ✅ READY FOR REVIEW

### 1. Requirements
- [x] All 7 AC completed
- [x] Scope respected (no extras)
- [x] Edge cases handled (invalid states, null values)

### 2. Code Quality
- [x] Conventions OK
- [x] dart format OK
- [x] dart analyze: 0 issues
- [x] Dartdoc complete for Avatar, AvatarState, AvatarPersonality
- [x] No dead code
- [x] Constants used (kAvatarStateTransitionDuration, etc.)

### 3. Testing
- [x] Unit tests: 12 tests, 100% coverage on models
- [x] Tests cover: creation, serialization, state transitions, edge cases
- [x] All existing tests pass

### 4. Build
- [x] iOS build OK
- [x] Android build OK
- [x] CI pipeline green

### 5. Documentation
- [x] data-models.md updated with Avatar schema
- [x] CHANGELOG.md updated

**Ready for PM approval.**
```

### Exemple 2 : Story REJECTED ❌

```markdown
## Story [EPIC-3.4] - Photo Capture - DoD Report

**Status:** ❌ NEEDS WORK

### Issues Found:
1. ❌ dart analyze: 3 warnings (unused imports)
2. ❌ Widget tests missing for PhotoValidationScreen
3. ❌ Edge case not handled: camera permission denied permanently
4. ❌ No error handling for storage full scenario

### What Works:
- [x] Happy path photo capture works
- [x] Unit tests pass
- [x] Build OK

**Action Required:**
- Fix analyze warnings
- Add widget tests
- Handle permission denied permanently (redirect to settings)
- Add try-catch for storage full

Will re-submit after fixes.
```

---

## 📞 Questions & Support

**Si l'agent dev est bloqué sur un item de la checklist :**
→ Question au PM immédiatement

**Si un item semble impossible à satisfaire :**
→ Escalation PM pour décision (possible exception ou reformulation AC)

**Pas de skip d'items sans validation PM.**

---

*Document créé le 2026-01-07 par PM John*
*Cette checklist est MANDATORY pour toutes les stories. Aucune exception.*
