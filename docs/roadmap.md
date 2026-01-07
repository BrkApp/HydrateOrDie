# Roadmap & Progress Tracker - Hydrate or Die MVP

**Version:** 1.0
**Date Start:** 2026-01-07
**Target MVP Completion:** TBD
**Last Updated:** 2026-01-07

---

## 🎯 MVP Scope Overview

**Total Epics:** 5
**Total Stories:** 51
**Status:** 0/51 Completed (0%)

---

## 📊 Epic Progress Summary

| Epic | Stories | Completed | Progress | Status |
|------|---------|-----------|----------|--------|
| Epic 1 - Foundation & Avatar Core System | 8 | 0/8 | 0% | 🔴 Not Started |
| Epic 2 - Onboarding & Personnalisation | 10 | 0/10 | 0% | 🔴 Not Started |
| Epic 3 - Validation Photo & Feedback Positif | 10 | 0/10 | 0% | 🔴 Not Started |
| Epic 4 - Système de Notifications Punitives | 11 | 0/11 | 0% | 🔴 Not Started |
| Epic 5 - Progression & Rétention (Streaks & Historique) | 12 | 0/12 | 0% | 🔴 Not Started |
| **TOTAL** | **51** | **0/51** | **0%** | **🔴 Not Started** |

---

## 🚀 Epic 1: Foundation & Avatar Core System

**Goal:** Établir l'infrastructure projet (Flutter app, Firebase, CI/CD) et implémenter le système d'avatar Tamagotchi avec ses 4 états de déshydratation et le système de mort temporaire/fantôme.

**Priority:** Critical
**Progress:** 0/8 (0%)
**Status:** 🔴 Not Started

### Stories

- [ ] **1.1** - Projet Flutter Initial avec CI/CD
- [ ] **1.2** - Modèles de Données Avatar
- [ ] **1.3** - Repository Avatar avec Persistence Locale
- [ ] **1.4** - Assets Visuels Avatars (4 États x 4 Avatars)
- [ ] **1.5** - Logique de Déshydratation Progressive
- [ ] **1.6** - Écran Principal avec Avatar Réactif
- [ ] **1.7** - Système Fantôme (Mort Temporaire)
- [ ] **1.8** - Sélection Initiale Avatar

**Epic Completion Checklist:**
- [ ] Toutes les stories 1.1 à 1.8 complétées avec AC validés
- [ ] L'app build sans erreur sur iOS et Android
- [ ] Les tests automatiques passent (CI green)
- [ ] Code review effectué
- [ ] L'app est testable manuellement : sélection avatar → voir avatar se déshydrater → voir fantôme → résurrection
- [ ] Documentation technique mise à jour

**Link:** [Epic 1 Details](epics/epic-1-foundation.md)

---

## 📝 Epic 2: Onboarding & Personnalisation

**Goal:** Créer le flow d'onboarding en 5 questions, implémenter l'algorithme de calcul d'objectif hydratation personnalisé, et permettre la sélection d'avatar avec aperçu personnalité.

**Priority:** Critical
**Progress:** 0/10 (0%)
**Status:** 🔴 Not Started

### Stories

- [ ] **2.1** - Modèle de Données Profil Utilisateur
- [ ] **2.2** - Algorithme Calcul Objectif Hydratation
- [ ] **2.3** - Repository Profil Utilisateur
- [ ] **2.4** - Écran Onboarding Question Poids
- [ ] **2.5** - Écran Onboarding Question Âge
- [ ] **2.6** - Écran Onboarding Question Sexe
- [ ] **2.7** - Écran Onboarding Question Activité Physique
- [ ] **2.8** - Écran Onboarding Permission Localisation
- [ ] **2.9** - Écran Récapitulatif Onboarding avec Objectif
- [ ] **2.10** - Intégration Onboarding dans le Flow Initial

**Epic Completion Checklist:**
- [ ] Toutes les stories 2.1 à 2.10 complétées avec AC validés
- [ ] Le calcul d'objectif hydratation est validé scientifiquement
- [ ] Le flow d'onboarding complet prend <5 minutes en test manuel
- [ ] Les tests automatiques passent (unit + widget + integration)
- [ ] L'app guide correctement nouveau user : onboarding → home avec objectif personnalisé
- [ ] Code review effectué

**Link:** [Epic 2 Details](epics/epic-2-onboarding.md)

---

## 📸 Epic 3: Validation Photo & Feedback Positif

**Goal:** Implémenter la validation par selfie avec interface caméra guidée, stockage local des photos, et animations de feedback positif de l'avatar après validation.

**Priority:** Critical
**Progress:** 0/10 (0%)
**Status:** 🔴 Not Started

### Stories

- [ ] **3.1** - Modèle de Données Validation Hydratation
- [ ] **3.2** - Repository Historique Hydratation
- [ ] **3.3** - Interface Caméra Guidée pour Selfie
- [ ] **3.4** - Capture et Stockage Photo Locale
- [ ] **3.5** - Détection Basique Présence Verre (Optionnel)
- [ ] **3.6** - Enregistrement Validation et Update Progression
- [ ] **3.7** - Animations Avatar Feedback Positif
- [ ] **3.8** - Bouton "Je bois" sur HomeScreen
- [ ] **3.9** - Sélection Taille de Verre
- [ ] **3.10** - Gestion Permissions Caméra

**Epic Completion Checklist:**
- [ ] Toutes les stories 3.1 à 3.10 complétées avec AC validés
- [ ] Le flow photo complet fonctionne : HomeScreen → Photo → Sélection taille → Feedback → HomeScreen
- [ ] Les photos sont sauvegardées localement et visibles dans le storage app
- [ ] L'avatar réagit positivement avec animations après validation
- [ ] La progression quotidienne se met à jour correctement
- [ ] Les permissions caméra sont gérées sans crash
- [ ] Tests automatiques passent (unit + widget + integration)
- [ ] Test manuel complet du flow photo réussi

**Link:** [Epic 3 Details](epics/epic-3-photo-validation.md)

---

## 🔔 Epic 4: Système de Notifications Punitives

**Goal:** Développer l'escalade progressive des notifications (4 niveaux), spam aléatoire intelligent, messages personnalisés par avatar, et vibrations agaçantes.

**Priority:** High
**Progress:** 0/11 (0%)
**Status:** 🔴 Not Started

### Stories

- [ ] **4.1** - Modèle de Données Notification System
- [ ] **4.2** - Algorithme Escalade Progressive
- [ ] **4.3** - Repository Notification State
- [ ] **4.4** - Messages Personnalisés par Avatar et Niveau
- [ ] **4.5** - Scheduling Notifications Locales
- [ ] **4.6** - Vibrations Agaçantes en Mode Chaos
- [ ] **4.7** - Pause Automatique Notifications Nocturnes
- [ ] **4.8** - Gestion Permissions Notifications
- [ ] **4.9** - Background Job Update Niveau Escalade
- [ ] **4.10** - Analytics Notifications
- [ ] **4.11** - Écran Paramètres Notifications

**Epic Completion Checklist:**
- [ ] Toutes les stories 4.1 à 4.11 complétées avec AC validés
- [ ] Le système d'escalade fonctionne : calm → concerned → dramatic → chaos
- [ ] Les messages sont différenciés par avatar et mémorables
- [ ] Les notifications arrivent en background même app fermée
- [ ] Les vibrations en mode chaos sont fonctionnelles et agaçantes (mais pas excessives)
- [ ] La pause nocturne fonctionne correctement
- [ ] Les permissions notifications sont gérées sans crash
- [ ] Tests automatiques passent (unit + widget + integration)
- [ ] Test manuel complet sur plusieurs heures valide l'escalade

**Link:** [Epic 4 Details](epics/epic-4-notifications.md)

---

## 📈 Epic 5: Progression & Rétention (Streaks & Historique)

**Goal:** Créer le système de streaks Duolingo-style, calendrier historique, et écran de profil/paramètres minimaliste.

**Priority:** High
**Progress:** 0/12 (0%)
**Status:** 🔴 Not Started

### Stories

- [ ] **5.1** - Modèle de Données Streak
- [ ] **5.2** - Logique Calcul Streak Quotidien
- [ ] **5.3** - Repository Streak
- [ ] **5.4** - Affichage Streak sur HomeScreen
- [ ] **5.5** - Modèle de Données Calendrier Historique
- [ ] **5.6** - Écran Calendrier Historique
- [ ] **5.7** - Stats Minimalistes sur Écran Profil
- [ ] **5.8** - Écran Paramètres Minimaliste
- [ ] **5.9** - Modification Profil et Recalcul Objectif
- [ ] **5.10** - Changement d'Avatar Post-Onboarding
- [ ] **5.11** - Achievements/Badges Simples (Optionnel)
- [ ] **5.12** - Bottom Navigation Bar

**Epic Completion Checklist:**
- [ ] Toutes les stories 5.1 à 5.12 complétées avec AC validés
- [ ] Le système de streaks fonctionne : incrémente quotidiennement si objectif atteint
- [ ] Le calendrier historique affiche correctement les jours ✓/✗
- [ ] Les stats sur le profil sont calculées correctement
- [ ] Les paramètres permettent de configurer l'app et supprimer les données (RGPD)
- [ ] Le changement d'avatar fonctionne sans casser le streak
- [ ] La navigation bottom bar est fluide et intuitive
- [ ] Tests automatiques passent (unit + widget + integration)
- [ ] Test manuel complet valide le flow utilisateur quotidien

**Link:** [Epic 5 Details](epics/epic-5-progression.md)

---

## 🎯 Milestones & Key Dates

### Milestone 1: Architecture & Contracts (Pre-Development)
**Target:** Week 1
**Status:** 🔴 Not Started

**Deliverables:**
- [ ] `docs/architecture.md` créé par Architect
- [ ] `docs/contracts/data-models.md` créé
- [ ] `docs/contracts/database-schema.md` créé
- [ ] `docs/contracts/api-contracts.md` créé
- [ ] `docs/contracts/repositories-interface.md` créé
- [ ] `docs/contracts/use-cases-interface.md` créé
- [ ] Structure de dossiers `lib/` créée
- [ ] `pubspec.yaml` avec toutes dépendances MVP
- [ ] GitHub Actions CI/CD configuré

---

### Milestone 2: Epic 1 Complete (Foundation)
**Target:** Week 2-3
**Status:** 🔴 Not Started
**Blocker:** Architecture docs required first

**Criteria:**
- [ ] Epic 1 completion checklist 100%
- [ ] App builds iOS + Android
- [ ] Avatar system functional
- [ ] PM approval

---

### Milestone 3: Epic 2 Complete (Onboarding)
**Target:** Week 4
**Status:** 🔴 Not Started
**Blocker:** Epic 1 completion required

**Criteria:**
- [ ] Epic 2 completion checklist 100%
- [ ] Onboarding flow <5min
- [ ] Hydration goal calculation validated
- [ ] PM approval

---

### Milestone 4: Epic 3 Complete (Photo Validation)
**Target:** Week 5-6
**Status:** 🔴 Not Started
**Blocker:** Epic 2 completion required

**Criteria:**
- [ ] Epic 3 completion checklist 100%
- [ ] Photo flow functional
- [ ] Avatar feedback animations working
- [ ] PM approval

---

### Milestone 5: Epic 4 Complete (Notifications)
**Target:** Week 7
**Status:** 🔴 Not Started
**Blocker:** Epic 3 completion required

**Criteria:**
- [ ] Epic 4 completion checklist 100%
- [ ] Notification escalade working
- [ ] Messages personalized
- [ ] PM approval

---

### Milestone 6: Epic 5 Complete (Progression & Retention)
**Target:** Week 8
**Status:** 🔴 Not Started
**Blocker:** Epic 4 completion required

**Criteria:**
- [ ] Epic 5 completion checklist 100%
- [ ] Streaks working
- [ ] Calendar functional
- [ ] PM approval

---

### Milestone 7: MVP Complete & Beta Ready
**Target:** Week 9
**Status:** 🔴 Not Started
**Blocker:** All epics completion required

**Deliverables:**
- [ ] All 51 stories completed
- [ ] Full regression testing passed
- [ ] Performance tested on real devices
- [ ] Security audit completed
- [ ] Privacy Policy & Terms finalized
- [ ] App Store assets ready (screenshots, descriptions, icons)
- [ ] Beta deployed to TestFlight (iOS) + Internal Track (Android)
- [ ] Beta testers recruited (10-20 users)

---

### Milestone 8: Public Launch
**Target:** Week 10+
**Status:** 🔴 Not Started
**Blocker:** Beta testing & feedback

**Deliverables:**
- [ ] Beta feedback incorporated
- [ ] Critical bugs fixed
- [ ] App Store submission iOS
- [ ] Google Play submission Android
- [ ] Marketing materials ready
- [ ] Launch announcement prepared

---

## 📋 Current Sprint (Week X)

**Sprint Goal:** [To be defined at sprint start]
**Sprint Duration:** [To be defined]
**Stories in Sprint:** [To be selected]

### Sprint Backlog
- [ ] Story X.Y - [Title]
- [ ] Story X.Y - [Title]

### Sprint Burndown
- Day 1: X stories remaining
- Day 2: X stories remaining
- ...

---

## 🚧 Blockers & Risks

### Active Blockers
None currently

### Identified Risks
1. **Risk:** Flutter learning curve for solo dev
   - **Mitigation:** Focus on MVP, extensive documentation, Claude Code assistance
   - **Status:** 🟡 Monitoring

2. **Risk:** Firebase costs if early traction
   - **Mitigation:** Spark plan free tier, monitoring usage
   - **Status:** 🟢 Low priority

3. **Risk:** App Store review rejection (punitive tone)
   - **Mitigation:** Beta testing tone, guidelines compliance check
   - **Status:** 🟡 Monitoring

---

## 📊 Metrics Dashboard

### Code Metrics
- **Lines of Code:** 0
- **Test Coverage:** 0%
  - Domain: 0%
  - Data: 0%
  - Presentation: 0%
- **Code Quality:** `dart analyze` - N/A

### Build Status
- **iOS Build:** 🔴 Not Started
- **Android Build:** 🔴 Not Started
- **CI/CD:** 🔴 Not Configured

### Performance
- **App Size:** N/A
- **Startup Time:** N/A
- **Memory Usage:** N/A

---

## 🎉 Completed Stories Log

### Epic 1
*No stories completed yet*

### Epic 2
*No stories completed yet*

### Epic 3
*No stories completed yet*

### Epic 4
*No stories completed yet*

### Epic 5
*No stories completed yet*

---

## 📝 Notes & Decisions Log

### 2026-01-07
- **Decision:** PRD, Governance, and Stories structure finalized
- **Action:** Architecture phase to begin
- **Owner:** PM John

---

## 🔄 Version History

| Date | Version | Changes | Author |
|------|---------|---------|--------|
| 2026-01-07 | 1.0 | Initial roadmap creation | PM John |

---

## 📞 Team & Stakeholders

**Product Manager:** John
**Solo Developer:** User (with Claude Code assistance)
**Stakeholders:** User (founder)

---

*Roadmap last updated: 2026-01-07*
*Update this document as stories are completed to track progress*

**Instructions:**
- Mark stories with [x] when completed and PM approved
- Update progress percentages in Epic summaries
- Update milestone statuses as work progresses
- Log blockers and decisions in respective sections
- Keep metrics dashboard current
