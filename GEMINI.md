# GEMINI.md - Continuité Projet HydrateOrDie

**Objectif:** Ce fichier permet à Gemini (ou autre LLM) de faire des reviews PO/Architect/PM quand tokens Claude épuisés.

**Date création:** 2026-01-12
**Dernière MAJ:** 2026-01-12
**État projet:** Epic 2 Story 2.3 EN COURS

---

## 📋 PROJET - VUE D'ENSEMBLE

**Nom:** HydrateOrDie
**Type:** Application mobile Flutter (iOS + Android)
**Concept:** Gamified hydration tracking avec avatar Tamagotchi-style

**Stack:**
- Frontend: Flutter 3.x (Dart)
- Architecture: Clean Architecture (Domain/Data/Presentation)
- State: Riverpod 2.x
- Database: SQLite (sqflite) + SharedPreferences
- Backend: Firebase (optionnel, offline-first)
- Tests: flutter_test (Unit/Widget/Integration)

**Méthode:** BMad (Business-Managed Agile Development)
- Stories organisées en Epics
- Validation par QA Gate à la fin de chaque Epic
- Reviews: PO → Architect → PM avant validation finale

---

## 📊 ÉTAT ACTUEL (2026-01-12)

**Epic 1:** ✅ COMPLETE (8 stories + QA Gate validé)
**Epic 2:** 🚀 IN PROGRESS - Story 2.3 (20% complété)

### Progression Epic 2

| Story | Status | Livrable | Tests |
|-------|--------|----------|-------|
| 2.1 User Profile Model | ✅ | Entity User + enums Gender/ActivityLevel | 43 (100%) |
| 2.2 Hydration Calculation | ✅ | CalculateHydrationGoalUseCase | 584 (100%) |
| 2.3 User Profile Repository | 🚀 | Repository + SQLite + DI | En cours |
| 2.4-2.8 Onboarding Screens | ⏸️ | 5 écrans UI (Weight/Age/Gender/Activity/Location) | - |
| 2.9 Summary Screen | ⏸️ | Récap profil + goal calculé | - |
| 2.10 Flow Integration | ⏸️ | Navigation complète onboarding | - |

**Branche Git:** `feature/epic-2-story-3-user-profile-repository`

---

## 🏗️ ARCHITECTURE - DÉCISIONS CLÉS

### Clean Architecture (Strict)

```
lib/
├── core/              # DI (GetIt), constants, theme, utils
├── domain/            # Entities, Repository interfaces, Use Cases
├── data/              # DTOs/Models, Repository impl, Data Sources
└── presentation/      # Riverpod providers, Screens, Widgets
```

**Règles:**
- Domain = Pure Dart (ZERO dépendances Flutter/Firebase)
- Data = Implémentation repositories + DTOs
- Presentation = UI + State management (Riverpod)
- DI = GetIt dans `lib/core/injection.dart`

### Database Schema

**Version actuelle:** V3 (Epic 1)
**Prochaine version:** V4 (Epic 2 - Story 2.3)

**Tables existantes (V3):**
- `avatars` (id, personality, state, hydrationLevel, lastDrinkTime, etc.)

**Tables à créer (V4):**
- `user_profiles` (userId, weight, age, gender, activityLevel, locationPermissionGranted, dailyHydrationGoalLiters, createdAt, updatedAt)

**Convention:** Colonnes en camelCase (non-standard SQL mais validé fonctionnel)

### Avatar System (Epic 1)

**4 avatars:**
1. Docteur (médical, scientifique)
2. Coach (sportif, motivant)
3. Mère Autoritaire (maternelle, culpabilisante)
4. Pote (casual, complice)

**5 états par avatar:**
- Fresh (80-100% hydratation)
- Tired (50-79%)
- Dehydrated (20-49%)
- Dead (0-19%)
- Ghost (mort + résurrection à minuit)

**Assets:** 20 emojis placeholders (👨‍⚕️🏃👩‍🍳🧑‍🤝‍🧑👻) → PNG plus tard

### Hydration Goal Formula (Epic 2 - Story 2.2)

```
Base = weight (kg) × 0.033 litres

Facteurs:
- Activity: Sedentary(1.0), Light(1.1), Moderate(1.2), VeryActive(1.3), ExtremelyActive(1.5)
- Gender: Male(1.0), Female(0.95), Other(1.0)
- Age: <30(1.0), 30-55(0.95), >55(0.9)

Goal final (L) = Base × Activity × Gender × Age
Bounds: min 1.5L, max 5.0L, arrondi 0.1L
```

---

## 🎯 WORKFLOW REVIEWS

### Quand faire les reviews ?

**Après chaque story complète:**
- Story complétée + tests passing + flutter analyze 0 errors
- Dev agent commit code + update dev-context
- PUIS lancer reviews PO/Architect/PM

**Après chaque Epic complet:**
- QA Gate obligatoire (docs/qa/gates/epic-X-qa-gate.md)
- Reviews approfondies (architecture + fonctionnel + acceptance)

---

## 📝 REVIEW PO (Product Owner)

### Rôle
Valider que la story/epic répond aux critères business et AC (Acceptance Criteria).

### Checklist PO

**Pour une Story:**
- [ ] Tous les AC de la story sont remplis (lire story file)
- [ ] Comportement conforme aux specs PRD (lire docs/prd/)
- [ ] User flow logique et intuitif
- [ ] Messages/textes appropriés (ton, langue, clarté)
- [ ] Edge cases gérés (erreurs, états vides, etc.)
- [ ] Aucune régression fonctionnelle (features Epic 1 toujours OK)

**Pour un Epic:**
- [ ] Tous les AC de toutes les stories validés
- [ ] QA Gate report analysé (lire docs/qa/reports/)
- [ ] Flow utilisateur E2E fonctionnel
- [ ] Valeur business délivrée conforme au PRD
- [ ] Prêt pour démo client/utilisateurs

**Commandes utiles:**
```bash
# Lire story file
cat docs/stories/epic-X/story-X.Y-*.md

# Lire PRD shard correspondant
cat docs/prd/epic-X-*.md

# Lire QA Gate report (si Epic complet)
cat docs/qa/reports/epic-X-qa-gate-report.md

# Vérifier tests passing
flutter test

# Lancer app pour test manuel
flutter run
```

**Output PO Review:**
```
## PO Review - Story X.Y

**Status:** ✅ APPROVED / ⚠️ APPROVED WITH RESERVATIONS / ❌ REJECTED

### Acceptance Criteria
- [x] AC1: [description] - ✅ Validé
- [x] AC2: [description] - ✅ Validé
- [ ] AC3: [description] - ❌ Manquant/Incomplet

### Conformité PRD
- ✅ Comportement conforme specs
- ⚠️ Écart mineur: [description + justification acceptable/non]

### Edge Cases
- ✅ Erreurs gérées correctement
- ✅ États vides/null gérés
- ⚠️ [Cas particulier à améliorer]

### Blockers
- [Liste blockers si REJECTED]

### Recommendations
- [Améliorations suggérées - non bloquantes]

**Décision finale:** APPROVED / APPROVED WITH RESERVATIONS / REJECTED
```

---

## 🏛️ REVIEW ARCHITECT

### Rôle
Valider que l'implémentation respecte Clean Architecture et standards techniques.

### Checklist Architect

**Clean Architecture:**
- [ ] Domain layer = Pure Dart (ZERO import Flutter/Firebase/sqflite)
- [ ] Entities dans domain/entities/
- [ ] Repository interfaces dans domain/repositories/
- [ ] Use Cases dans domain/use_cases/
- [ ] DTOs dans data/models/ (toJson/fromJson/toEntity/fromEntity)
- [ ] Repository impl dans data/repositories/
- [ ] Data Sources dans data/datasources/local/ ou /remote/
- [ ] Providers Riverpod dans presentation/providers/
- [ ] Screens dans presentation/screens/
- [ ] Widgets réutilisables dans presentation/widgets/

**Dependency Injection:**
- [ ] Nouveaux repositories enregistrés dans core/injection.dart
- [ ] Use Cases enregistrés (factory ou lazy singleton selon besoin)
- [ ] Data Sources enregistrés (lazy singleton)

**Database:**
- [ ] Migration propre (V3→V4) avec gestion backward compatibility
- [ ] Colonnes camelCase (convention projet)
- [ ] Indexes appropriés pour performance
- [ ] Schema documenté dans data/datasources/local/

**Code Quality:**
- [ ] Dartdoc sur toutes classes/méthodes publiques
- [ ] Naming conventions respectées (snake_case files, PascalCase classes, camelCase vars)
- [ ] Pas de code dupliqué
- [ ] Pas de dépendances circulaires
- [ ] Error handling approprié (try-catch, exceptions custom)

**Tests:**
- [ ] Coverage Domain ≥80%
- [ ] Coverage Data ≥70%
- [ ] Coverage Presentation ≥50%
- [ ] Tests unitaires + widget tests + integration tests selon besoin
- [ ] Mocks appropriés (Mockito pour repositories, etc.)

**Commandes utiles:**
```bash
# Vérifier structure Clean Architecture
ls -R lib/domain lib/data lib/presentation

# Vérifier imports Domain (doit être ZERO Flutter)
grep -r "import 'package:flutter" lib/domain/

# Vérifier tests coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
# Ouvrir coverage/html/index.html

# Vérifier analyse statique
flutter analyze

# Vérifier DI setup
cat lib/core/injection.dart
```

**Output Architect Review:**
```
## Architect Review - Story X.Y

**Status:** ✅ APPROVED / ⚠️ APPROVED WITH TECH DEBT / ❌ REJECTED

### Clean Architecture
- ✅ Domain layer pure Dart
- ✅ Separation of concerns respectée
- ⚠️ [Violation mineure + justification]

### Code Quality
- ✅ Dartdoc complet
- ✅ Naming conventions OK
- ✅ Pas de duplication
- ⚠️ [Point à améliorer]

### Database
- ✅ Migration V3→V4 propre
- ✅ Schema documenté
- ✅ Indexes appropriés

### Tests
- ✅ Domain: 95% coverage
- ✅ Data: 85% coverage
- ⚠️ Presentation: 45% coverage (acceptable si AC validés)

### Technical Debt
- [Liste dette technique identifiée - non bloquante]

### Blockers
- [Liste blockers si REJECTED]

**Décision finale:** APPROVED / APPROVED WITH TECH DEBT / REJECTED
```

---

## 📊 REVIEW PM (Product Manager)

### Rôle
Valider que l'Epic/Story s'intègre bien dans la roadmap globale et respecte les priorités business.

### Checklist PM

**Scope & Priorités:**
- [ ] Story implémentée correspond au scope défini
- [ ] Pas de feature creep (fonctionnalités non demandées)
- [ ] Priorités respectées (Critical > High > Medium > Low)
- [ ] Dépendances stories respectées (ex: 2.3 dépend de 2.2)

**Intégration Roadmap:**
- [ ] Epic s'intègre bien avec Epics précédents
- [ ] Pas de régression fonctionnelle
- [ ] Prépare bien les Epics suivants
- [ ] Valeur incrémentale livrée

**Risques & Blockers:**
- [ ] Risques identifiés et mitigés
- [ ] Pas de blockers critiques pour la suite
- [ ] Dette technique acceptable
- [ ] Performance acceptable

**User Experience:**
- [ ] Flow utilisateur cohérent avec vision produit
- [ ] Pas de friction utilisateur majeure
- [ ] Feedback utilisateur pris en compte (si tests manuels faits)

**Métriques:**
- [ ] Coverage tests conforme (Domain ≥80%, Data ≥70%, Presentation ≥50%)
- [ ] 0 erreurs flutter analyze
- [ ] Tous tests passing
- [ ] Build réussi (APK/IPA générable)

**Commandes utiles:**
```bash
# Lire roadmap
cat docs/roadmap.md

# Lire PRD complet
cat docs/prd.md

# Vérifier progression Epic
cat docs/stories/epic-X/dev-context-epic-X.md

# Vérifier governance
cat docs/governance.md

# Build APK pour test
flutter build apk --debug

# Vérifier métriques
flutter test --coverage
flutter analyze
```

**Output PM Review:**
```
## PM Review - Story X.Y / Epic X

**Status:** ✅ APPROVED / ⚠️ APPROVED WITH NOTES / ❌ REJECTED

### Scope
- ✅ Story scope respecté
- ✅ Pas de feature creep
- ✅ Priorités conformes

### Roadmap Integration
- ✅ S'intègre bien avec Epic 1
- ✅ Prépare Epic 3 correctement
- ✅ Pas de régression

### Risques
- ⚠️ [Risque identifié + mitigation]
- ✅ Pas de blockers critiques

### UX
- ✅ Flow cohérent avec vision produit
- ⚠️ [Point UX à améliorer - non bloquant]

### Métriques
- ✅ Tests: Domain 95%, Data 85%, Presentation 50%
- ✅ Flutter analyze: 0 errors
- ✅ Build OK

### Next Steps
- [Actions recommandées pour story/epic suivante]

**Décision finale:** APPROVED / APPROVED WITH NOTES / REJECTED
```

---

## 📚 DOCUMENTS CLÉS

**À lire AVANT toute review:**

### Governance & Standards
- `docs/governance.md` - Règles non-négociables
- `docs/definition-of-done.md` - Checklist DoD obligatoire
- `docs/architecture.md` - Architecture système complète
- `CLAUDE.md` - Instructions développement (conventions code)

### Business & Specs
- `docs/brief.md` - Vision produit & concept
- `docs/prd.md` - Product Requirements (51 stories, 5 epics)
- `docs/prd/epic-X-*.md` - PRD shard par epic
- `docs/front-end-spec.md` - Specs UI/UX détaillées

### Epic 2 Specific
- `docs/stories/epic-2/dev-context-epic-2.md` - État Epic 2 + architecture
- `docs/stories/epic-2/story-2.X-*.md` - Story files individuelles
- `docs/qa/gates/epic-2-qa-gate.md` - Critères QA Gate Epic 2

### Epic 1 (Référence - Complété)
- `docs/stories/epic-1/dev-context-epic-1-archived.md` - Epic 1 archivé
- `docs/qa/reports/epic-1-qa-gate-report.md` - QA Gate Epic 1 validé

---

## 🚀 COMMANDES RAPIDES

### Analyse Projet
```bash
# État Git
git status
git log --oneline -5
git branch --show-current

# Lire état Epic actuel
cat docs/stories/epic-2/dev-context-epic-2.md

# Lire story en cours
cat docs/stories/epic-2/story-2.3-user-profile-repository.md

# Session Master (état global)
cat .ai/bmad-master-session.md
```

### Tests & Qualité
```bash
# Tous les tests
flutter test

# Tests avec coverage
flutter test --coverage

# Analyse statique
flutter analyze

# Formatter
dart format .

# Build
flutter build apk --debug
```

### Structure Projet
```bash
# Voir structure Clean Architecture
tree lib/domain lib/data lib/presentation

# Compter fichiers par layer
find lib/domain -name "*.dart" | wc -l
find lib/data -name "*.dart" | wc -l
find lib/presentation -name "*.dart" | wc -l

# Compter tests
find test/ -name "*_test.dart" | wc -l
```

---

## 🎯 PROMPTS TYPES POUR GEMINI

### Review PO Story 2.3
```
Joue le rôle d'un Product Owner expérimenté.

Contexte: Projet HydrateOrDie, Epic 2 Story 2.3 (User Profile Repository) vient d'être complétée.

Tâche:
1. Lis docs/stories/epic-2/story-2.3-user-profile-repository.md
2. Lis docs/prd/epic-2-user-onboarding.md
3. Vérifie que TOUS les AC sont remplis
4. Valide conformité specs PRD
5. Identifie edge cases manquants
6. Produis PO Review selon template GEMINI.md

Sois exigeant mais pragmatique. Focus: valeur business + expérience utilisateur.
```

### Review Architect Story 2.3
```
Joue le rôle d'un Software Architect senior spécialisé Clean Architecture + Flutter.

Contexte: Projet HydrateOrDie, Epic 2 Story 2.3 (User Profile Repository) vient d'être complétée.

Tâche:
1. Vérifie structure Clean Architecture stricte
2. Lis lib/domain/repositories/user_profile_repository.dart
3. Lis lib/data/repositories/user_profile_repository_impl.dart
4. Lis lib/data/datasources/local/user_profile_local_data_source.dart
5. Vérifie DI setup dans lib/core/injection.dart
6. Analyse migration DB V3→V4
7. Vérifie coverage tests (≥80% Domain, ≥70% Data)
8. Produis Architect Review selon template GEMINI.md

Sois strict sur Clean Architecture. Identifie toute violation ou dette technique.
```

### Review PM Epic 2 (après toutes stories)
```
Joue le rôle d'un Product Manager expérimenté.

Contexte: Projet HydrateOrDie, Epic 2 (User Onboarding) complet, 10/10 stories.

Tâche:
1. Lis docs/stories/epic-2/dev-context-epic-2.md (progression)
2. Lis docs/qa/reports/epic-2-qa-gate-report.md (si existe)
3. Vérifie intégration avec Epic 1
4. Valide que Epic 2 prépare bien Epic 3 (Hydration Tracking)
5. Analyse risques & blockers
6. Évalue métriques globales (tests, coverage, performance)
7. Produis PM Review selon template GEMINI.md

Sois stratégique. Focus: roadmap + risques + valeur incrémentale.
```

---

## 📊 MÉTRIQUES CIBLES

**Tests Coverage:**
- Domain: ≥80% (OBLIGATOIRE)
- Data: ≥70% (OBLIGATOIRE)
- Presentation: ≥50% (ACCEPTABLE si AC validés)

**Code Quality:**
- flutter analyze: 0 errors (warnings OK si documentés)
- Dartdoc: 100% classes/méthodes publiques
- Pas de code mort (unused imports, vars, etc.)

**Performance:**
- Build time: <2min (flutter build apk)
- Test time: <30s (flutter test)
- App launch: <3s (cold start)

**Git:**
- Commits atomiques avec préfixe [EPIC-X.Y]
- Branches: feature/epic-X-story-Y-description
- Merge vers master après chaque story (Epic 2+)

---

## ⚠️ POINTS D'ATTENTION

### Dette Technique Connue
1. **Assets placeholders:** Emojis → PNG migration post-MVP
2. **Tests timeouts:** 13 widget tests timeout Epic 1 (acceptable)
3. **Database camelCase:** Non-standard SQL mais validé fonctionnel
4. **Offline mode:** Firebase optionnel, mock config fournie

### Risques Surveillance
1. **Géolocalisation (Story 2.8):** Permission refusée → Fallback pays manuel requis
2. **Formule hydratation:** Simplifiée, validation médicale recommandée avant prod
3. **Performance SQLite:** Monitoring requis si >1000 hydration entries

### Blockers Critiques (Aucun actuellement)
- Epic 1 validé ✅
- Epic 2 Stories 2.1-2.2 complètes ✅
- Story 2.3 en cours 🚀

---

## 🔄 MISE À JOUR CE FICHIER

**Quand mettre à jour GEMINI.md:**
- Après chaque Epic complet (architecture changes)
- Nouvelles décisions architecturales importantes
- Changements governance/standards
- Nouvelles dettes techniques critiques

**Comment mettre à jour:**
```bash
# Éditer fichier
nano GEMINI.md

# Commiter
git add GEMINI.md
git commit -m "docs: update GEMINI.md with [description]"
git push origin master
```

---

**Dernière MAJ:** 2026-01-12 (Epic 2 Story 2.3 en cours)
**Prochaine MAJ prévue:** Fin Epic 2 (après Story 2.10 + QA Gate)

*Ce fichier est maintenu pour assurer continuité reviews PO/Architect/PM sur LLMs alternatifs.*
