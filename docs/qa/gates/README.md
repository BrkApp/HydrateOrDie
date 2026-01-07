# QA Gates - Hydrate or Die MVP

**Version:** 1.0
**Date:** 2026-01-07
**Owner:** QA Team & Product Manager John
**Status:** Active

---

## Vue d'Ensemble

Ce dossier contient les **QA Gates** (checklists de validation) pour chaque Epic du projet HydrateOrDie MVP. Un QA Gate est un point de validation obligatoire avant qu'un Epic puisse être considéré comme "Done" et prêt pour production.

**Objectif:** Garantir que chaque Epic respecte les standards de qualité définis (fonctionnel, NFR, architecture, tests, documentation) avant de progresser vers l'Epic suivant ou la release MVP.

---

## Liste des QA Gates

### Epic 1: Foundation & Avatar Core System
**Fichier:** [epic-1-qa-gate.md](epic-1-qa-gate.md)

**Objectif:** Infrastructure projet + Avatar Tamagotchi avec 4 états

**Criticité:** CRITICAL (Base de tout le projet)

**Focus Validation:**
- Architecture Clean respectée
- CI/CD fonctionnel
- Tests coverage ≥80%
- Avatar réactif aux états de déshydratation

---

### Epic 2: Onboarding & Personnalisation
**Fichier:** [epic-2-qa-gate.md](epic-2-qa-gate.md)

**Objectif:** Flow onboarding 5 questions + Calcul objectif hydratation personnalisé

**Criticité:** HIGH (Premier contact utilisateur)

**Focus Validation:**
- Flow onboarding complet en <5 minutes
- Calcul objectif scientifiquement validé
- UX fluide et claire
- Validation données utilisateur stricte

---

### Epic 3: Validation Photo & Feedback Positif
**Fichier:** [epic-3-qa-gate.md](epic-3-qa-gate.md)

**Objectif:** Selfie avec verre + Stockage local + Feedback avatar

**Criticité:** CRITICAL (Cœur différenciateur produit)

**Focus Validation:**
- Performance caméra (<300ms pour capture)
- Stockage photos optimisé (<500KB/photo)
- Permissions caméra gérées sans crash
- Animations feedback fluides 60 FPS

---

### Epic 4: Système de Notifications Punitives
**Fichier:** [epic-4-qa-gate.md](epic-4-qa-gate.md)

**Objectif:** Escalade notifications 4 niveaux + Messages personnalisés

**Criticité:** HIGH (Mécanique engagement clé)

**Focus Validation:**
- Escalade progressive fonctionne correctement
- Notifications arrivent en background
- Battery drain acceptable (<5% par jour)
- Messages adaptés par avatar et niveau

---

### Epic 5: Progression & Rétention (Streaks & Historique)
**Fichier:** [epic-5-qa-gate.md](epic-5-qa-gate.md)

**Objectif:** Système streaks + Calendrier historique + Paramètres

**Criticité:** MEDIUM (Rétention long-terme)

**Focus Validation:**
- Logique streak correcte (incrémente/break)
- Calendrier affiche correctement ✓/✗
- Performance calculs calendrier (<100ms)
- RGPD compliance (suppression données)

---

## Process de Validation QA Gate

### Étape 1: Exécution Epic
- Dev team complète toutes les stories de l'Epic
- Tous les acceptance criteria sont remplis
- Tests passent (CI green)

### Étape 2: Auto-Review Dev
- Dev team exécute la checklist QA Gate de l'Epic
- Report complet produit avec statuts ✅/❌ pour chaque item

### Étape 3: QA Review
- QA Agent (ou humain) valide manuellement les critères critiques
- Tests manuels des flows end-to-end
- Vérification NFR (performance, accessibilité, etc.)

### Étape 4: PM Approval
- PM John valide le QA Gate
- Décision: ✅ PASSED / ❌ FAILED / 🟡 PASSED WITH WARNINGS

### Étape 5: Corrections (si FAILED)
- Dev team corrige les blockers identifiés
- Re-soumission pour review
- Loop jusqu'à PASSED

### Étape 6: Next Epic ou Release
- Si PASSED → Progression Epic suivant
- Si Epic 5 PASSED → MVP Ready for Release

---

## Critères de Passage Généraux

**Pour qu'un Epic PASSE son QA Gate:**

- ✅ **100% Validation Fonctionnelle** (toutes features OK)
- ✅ **95% Validation NFR** (max 1-2 items mineurs en warning)
- ✅ **100% Validation Architecture** (Clean Arch stricte)
- ✅ **Tests Coverage ≥80%** (Domain 90%, Data 80%, Presentation 70%)
- ✅ **Stabilité: 0 crash critique**
- ✅ **Build iOS + Android OK**

**Si 1 item CRITIQUE échoue → Epic FAILED, retour dev**

---

## NFR Transverses à Tous les Epics

Ces NFR s'appliquent à TOUS les Epics et sont vérifiés dans chaque QA Gate:

### Performance
- App launch time: < 2s
- Screen transition: < 300ms
- Database queries: < 100ms
- Memory usage: < 150MB (iPhone 8 baseline)

### Accessibilité (WCAG AA)
- Contraste texte: ≥4.5:1
- Tailles tactiles: ≥44x44px
- Labels lecteur d'écran présents
- Navigation clavier fonctionnelle

### Offline-First
- App fonctionne sans réseau
- Données persistées localement (SQLite)
- Sync Firebase quand réseau revient
- Conflicts handled gracefully

### Sécurité
- Aucune donnée sensible en logs
- HTTPS uniquement
- Permissions minimales (Principle of Least Privilege)
- RGPD: Suppression données fonctionnelle

### Tests
- Coverage global: ≥80%
  - Domain layer: ≥90%
  - Data layer: ≥80%
  - Presentation layer: ≥70%
- Tests unitaires passent
- Tests widgets passent
- Tests intégration passent (si applicable)

### Architecture
- Clean Architecture respectée (Domain ↔ Data ↔ Presentation)
- Aucune dépendance circulaire
- Use cases testés unitairement
- Repositories mockés dans tests

### Code Quality
- `flutter analyze`: 0 errors, 0 warnings
- `dart format`: code formaté
- Conventions nommage respectées
- Pas de TODOs non-documentés
- Pas de code commenté/mort

---

## Metrics de Success MVP

**À la fin de l'Epic 5 (MVP complet), ces métriques doivent être atteintes:**

- ✅ 5/5 Epics PASSED
- ✅ Build iOS + Android OK
- ✅ App Store submission ready
- ✅ Tests coverage global ≥80%
- ✅ 0 crash critique en tests manuels
- ✅ Performance baseline atteinte
- ✅ RGPD compliance validée
- ✅ Documentation complète

---

## Contact & Escalation

**QA Lead:** TBD
**PM Validation:** Product Manager John
**Escalation:** Si blockers critiques non résolus → PM décision

---

*Document créé le 2026-01-07 - QA Gates obligatoires pour MVP HydrateOrDie*
