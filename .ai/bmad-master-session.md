# 🧙 BMad Master - Session de Pilotage
**Projet:** HydrateOrDie
**Date Début:** 2026-01-07
**Dernière MAJ:** 2026-01-07
**Phase Actuelle:** Planification (Pré-Développement)

---

## 📍 ÉTAT ACTUEL DU WORKFLOW

### ✅ PHASES COMPLÉTÉES

| Phase | Agent | Livrable | Statut | Date | Notes |
|-------|-------|----------|--------|------|-------|
| 1 | analyst | docs/brief.md | ✅ Terminé | 2026-01-07 | Concept validé |
| 2 | pm | docs/prd.md | ✅ Terminé | 2026-01-07 | 51 stories, 5 epics |
| 3 | architect | docs/architecture.md | ✅ Terminé | 2026-01-07 | Clean Architecture + contracts |
| 4 | pm | Review architect | ✅ Terminé | 2026-01-07 | Ajustements mineurs demandés, PRD inchangé |
| 5 | ux-expert | docs/front-end-spec.md | ✅ Terminé | 2026-01-07 | ~25K mots, 9 sections, 20 avatars specs, wireframes |
| 6 | po | Validation complète | ✅ Terminé | 2026-01-07 | 92% readiness, 0 blockers, 10/10 quality, APPROUVÉ |
| 7 | master | Sharding docs | ✅ Terminé | 2026-01-07 | 24 fichiers créés (6 PRD + 14 Architecture + 4 docs) |
| 8 | master | QA Gates création | ✅ Terminé | 2026-01-07 | 6 fichiers (5 epics + index), critères PASS/FAIL définis |
| 9 | dev | Story 1.1 (Flutter Setup) | ✅ Terminé | 2026-01-07 | Clean Architecture, CI/CD, tests passing |
| 10 | master | GitHub Setup + Cleanup | ✅ Terminé | 2026-01-08 | Repo synced, 151 .md files optimisés |
| 11 | dev | Story 1.2 (Domain Models) | ✅ Terminé | 2026-01-08 | 10 entities, 115 tests, 100% coverage |
| 12 | dev | Story 1.3 (Avatar Repository) | ✅ Terminé | 2026-01-08 | SQLite + SharedPrefs, DTOs, 128 tests passing |
| 13 | dev | Story 1.4 (Avatar Assets) | ✅ Terminé | 2026-01-08 | 20 assets emojis, AvatarDisplay widget, 51 tests |

### ⏸️ PHASE EN COURS

| Phase | Agent | Livrable | Statut | Début | Notes |
|-------|-------|----------|--------|-------|-------|
| 14 | dev | Story 1.5 (Dehydration Logic) | 🔄 Prêt | 2026-01-08 | Calcul hydratation + transitions état |

### 🔜 PHASES À VENIR

| Phase | Agent | Livrable | Dépendances | Notes |
|-------|-------|----------|-------------|-------|
| 15-17 | dev | Stories 1.5-1.8 | Stories 1.1-1.4 | Suite Epic 1 |
| 18 | user | Test Story 1.6 | Story 1.6 complétée | Test manuel Home Screen (premier écran visible) |
| 19 | qa | QA Gate Epic 1 | Epic 1 complété | Execute docs/qa/gates/epic-1-qa-gate.md |
| 20 | architect | Review Epic 1 | QA Gate passé | Vérif architecture Clean Architecture |
| 21 | pm | Review Epic 1 | Architect OK | Validation fonctionnelle (AC, specs PRD, comportement) |
| 22 | po | Acceptance Epic 1 | PM + Architect OK | Validation epic prêt pour Epic 2 |
| 23+ | dev | Epic 2 Onboarding | Epic 1 validé | Stories 2.1-2.10 |

---

## 🎯 DÉCISIONS CLÉS PRISES

### 1. Architecture Avatars (2026-01-07)

**Décision:** 4 avatars sélectionnables × 4 états + fantômes personnalisés

| Avatar | Personnalité | Style Visuel | Exemple Message |
|--------|--------------|--------------|-----------------|
| Docteur | Médical, scientifique | Blouse blanche, stéthoscope | "Vos reins nécessitent hydratation" |
| Coach | Sportif, motivant | Sifflet, survêtement | "Allez champion, bois maintenant !" |
| Mère Autoritaire | Maternelle, culpabilisante | Tablier, cuillère en bois | "Tu veux que je m'inquiète ?!" |
| Pote | Casual, complice | Hoodie, décontracté | "Mec, j'ai pas envie de crever là" |

**États de déshydratation:**
- Bien Hydraté (80-100%) : Souriant, couleurs vives
- Légèrement Déshydraté (50-79%) : Neutre, couleurs normales
- Déshydraté (20-49%) : Fatigué, couleurs ternes
- Critique (0-19%) : Souffrant, couleurs sombres
- **+ Fantôme personnalisé** (reconnaissable par accessoire caractéristique)

**Total assets:** 20 (4 avatars × 4 états + 4 fantômes)

**Plan création assets:**
- Phase 1: Dev avec émojis placeholders 👨‍⚕️🏃👩‍🍳🧑‍🤝‍🧑👻
- Phase 2: Génération Midjourney/DALL-E (2-3h, 10-20€)
- Phase 3: Remplacement placeholders par vrais assets

### 2. Design System (2026-01-07)

**Style global:**
- Vibe: Fun/Gamifié mais pas infantile (cible 18-35 ans)
- Références: Duolingo (gamification) + Tamagotchi (nostalgie)
- Ton: Playful avec edge (notifications punitives fun)

**Couleurs recommandées:**
- Primaire: Bleu eau #2196F3 (thème hydratation)
- Secondaire: Orange/Corail #FF6B6B (alertes)
- Success: Vert #4CAF50
- Warning: Orange #FF9800
- Error/Critique: Rouge #F44336

**Typographie suggérée:**
- Headings: Rounded/Friendly (Nunito, Quicksand)
- Body: Moderne/Lisible (Inter, Roboto)

### 3. Stratégie Conversations Agents (2026-01-07)

**Règle établie:**
- ✅ **Master (bmad-master):** Garder même conversation (pilotage continu)
- ✅ **Agents spécialisés:** Nouveau chat par tâche (contexte propre)

**Workflow conversations:**
```
Master (persistent) → Guide général
  ├─→ @analyst (nouveau chat) → brief.md
  ├─→ @pm (nouveau chat) → prd.md
  ├─→ @architect (nouveau chat) → architecture.md
  ├─→ @pm (nouveau chat) → review
  ├─→ @ux-expert (nouveau chat) → front-end-spec.md
  └─→ @po, @sm, @dev, @qa (nouveaux chats par tâche)
```

---

## 📊 AUDIT PROJET (2026-01-07)

### Note Globale: 13/20

**Forces identifiées:**
- ✅ Documentation business excellente (brief, PRD)
- ✅ Architecture Clean bien définie
- ✅ 51 stories détaillées avec AC
- ✅ Contracts complets (data models, schemas, interfaces)
- ✅ Governance stricte

**Manquants critiques identifiés:**
1. ❌ front-end-spec.md (EN COURS DE CRÉATION)
2. ❌ QA Gates (seront créés avant dev)
3. ❌ Wireframes (dans front-end-spec.md)
4. ❌ Design system (dans front-end-spec.md)

**Manquants normaux (créés plus tard dans workflow):**
- README.md → Story 1.1 (Dev)
- Firebase Setup Guide → Story 1.1 (Dev)
- CI/CD Docs → Story 1.1 (Dev)
- docs/dependencies.md → Story 1.1 (Dev)
- QA Gates templates → Avant Epic 1 (PO/QA)
- Deployment Guides → Avant MVP launch
- Legal Docs (Privacy Policy, ToS) → Avant MVP launch
- Analytics Catalog → Epic 4 (Dev)

**Conclusion:**
- Seul manquant LÉGITIME: front-end-spec.md (en cours)
- Tous les autres manquants sont NORMAUX et créés plus tard
- Note passera à ~17/20 après front-end-spec.md

---

## 🗺️ ROADMAP WORKFLOW BMAD

### PHASE DE PLANIFICATION (Actuelle)
```
├─ ✅ analyst → brief.md
├─ ✅ pm → prd.md
├─ ❌ ux-expert → front-end-spec.md (MANQUÉE initialement, EN COURS maintenant)
├─ ✅ architect → architecture.md
├─ ✅ pm → review architect suggestions
├─ ⏸️  po → validate all docs with po-master-checklist
├─ ⏸️  Fix issues if PO finds any (conditionnel)
└─ ⏸️  po → shard documents
```

### PHASE DE DÉVELOPPEMENT (À venir)
```
├─ sm → create stories (répété 51×)
├─ dev → implement story
├─ qa → review implementation (optionnel)
└─ Repeat for all epics
```

---

## 📝 PROCHAINES ÉTAPES

### Étape Immédiate
**[EN COURS]** UX-Expert termine docs/front-end-spec.md

### Après UX-Expert
1. **PO Validation** (Étape 3/5)
   - Lance @po avec po-master-checklist
   - Valide: brief, prd, front-end-spec, architecture
   - Identifie problèmes éventuels

2. **Fix Issues** (Conditionnel)
   - Si PO trouve problèmes → Retour agents concernés
   - Re-validation PO

3. **Sharding Docs** (Étape 4/5)
   - PO shard docs/prd.md → docs/prd/
   - PO shard docs/architecture.md → docs/architecture/
   - Facilite navigation pour agents Dev

4. **Story Creation** (Étape 5/5)
   - SM crée stories une par une
   - Commence par Story 1.1 (Flutter Project Setup)

5. **Développement**
   - Dev implémente Story 1.1
   - Story 1.1 crée TOUS les docs techniques manquants:
     * README.md
     * Firebase Setup Guide
     * CI/CD configuration
     * docs/dependencies.md

---

## 🚧 BLOCKERS & RISQUES IDENTIFIÉS

### Blockers Actuels
Aucun

### Risques Surveillés
1. **Front-end-spec trop vague** → Risque: Dev ne sait pas quoi implémenter
   - Mitigation: Prompt détaillé fourni à UX-Expert avec specs précises
   - Status: 🟢 Sous contrôle

2. **Assets avatars retardent dev UI** → Risque: Stories 1.6, 1.8 bloquées
   - Mitigation: Stratégie placeholders émojis → génération Midjourney → remplacement
   - Status: 🟢 Plan établi

3. **QA Gates manquants** → Risque: Validation stories inconsistante
   - Mitigation: PO créera templates avant Epic 1
   - Status: 🟡 À surveiller

---

## 💡 COMMANDES MASTER DISPONIBLES

**Commandes utilisées dans cette session:**
- ✅ `*help` - Lister commandes (auto-run au démarrage)
- ⬜ `*create-doc {template}` - Créer document depuis template
- ⬜ `*execute-checklist {checklist}` - Exécuter checklist validation
- ⬜ `*task {task}` - Exécuter tâche BMad
- ⬜ `*kb` - Toggle mode KB (documentation BMad)
- ⬜ `*shard-doc {doc}` - Fragmenter document
- ⬜ `*exit` - Quitter Master

**Note:** Préfixe `*` obligatoire pour toutes commandes

---

## 📚 RESSOURCES CLÉS CONSULTÉES

### Documents Projet
- docs/brief.md (38KB)
- docs/prd.md (16KB)
- docs/architecture.md (35KB)
- docs/governance.md (17KB)
- docs/roadmap.md (13KB)
- docs/contracts/*.md (5 fichiers)

### Configuration BMad
- .bmad-core/core-config.yaml (configuration projet)
- .bmad-core/workflows/greenfield-fullstack.yaml (workflow référence)

### Templates Disponibles
- prd-tmpl.yaml
- architecture-tmpl.yaml
- front-end-spec-tmpl.yaml
- story-tmpl.yaml
- project-brief-tmpl.yaml

### Checklists Disponibles
- po-master-checklist.md
- story-dod-checklist.md
- architect-checklist.md

---

## 🔄 HISTORIQUE MODIFICATIONS

| Date | Modification | Auteur |
|------|--------------|--------|
| 2026-01-07 | Création fichier suivi | BMad Master |
| 2026-01-07 | Ajout décisions avatars (4 avatars × 5 états) | BMad Master |
| 2026-01-07 | Ajout audit projet (13/20) | BMad Master |
| 2026-01-07 | Ajout roadmap workflow complet | BMad Master |
| 2026-01-07 | ✅ Phase 5 complétée (UX-Expert front-end-spec.md) | BMad Master |
| 2026-01-07 | ✅ Phase 6 complétée (PO Validation 92% readiness, APPROUVÉ) | BMad Master |
| 2026-01-07 | ✅ Phase 7 complétée (Sharding 24 fichiers: 6 PRD + 14 Arch) | BMad Master |
| 2026-01-07 | ✅ Phase 8 complétée (QA Gates 6 fichiers, critères mesurables) | BMad Master |
| 2026-01-07 | ✅ Phase 9 complétée (Story 1.1 - Flutter Setup + CI/CD) | Dev Agent |
| 2026-01-08 | ✅ Phase 10 complétée (GitHub Setup + Cleanup 151 .md) | BMad Master |
| 2026-01-08 | Ajout section "Moments de Test Manuel" (8 checkpoints) | BMad Master |
| 2026-01-08 | ✅ Phase 11 complétée (Story 1.2 - 10 entities, 100% coverage) | Dev Agent |
| 2026-01-08 | ✅ Phase 12 complétée (Story 1.3 - Repository + DTOs, SQLite) | Dev Agent |
| 2026-01-08 | Correction dev-context.md + création prompt-template | BMad Master |
| 2026-01-08 | ✅ Phase 13 complétée (Story 1.4 - Assets + AvatarDisplay) | Dev Agent |

---

## 📌 NOTES IMPORTANTES

1. **Saut d'étape UX corrigé:** Workflow initial a sauté ux-expert, maintenant rectifié
2. **Front-end-spec critique:** Ce doc résout 50% des manquants identifiés dans l'audit
3. **Stratégie assets:** Ne PAS bloquer dev, utiliser placeholders puis remplacer
4. **Conversations agents:** Master = persistent, autres = nouveau chat par tâche
5. **Ce fichier doit être MAJ après chaque décision/phase importante**
6. **Stratégie Git:** Epic 1 direct sur master (foundation), Epic 2+ branches feature/epic-X
7. **Validations:** Par EPIC (pas par story) - QA Gate + Architect + PO après chaque epic

---

**Dernière action:** ✅ Story 1.4 complétée (20 assets + AvatarDisplay widget, 51 tests)
**Prochaine action:** DÉVELOPPEMENT - @dev implémente Story 1.5 (Dehydration Logic)

---

## 🧪 MOMENTS DE TEST MANUEL (User Testing)

### Quand Tester?

| Story | Moment Test | Commandes | Ce qu'il faut vérifier |
|-------|------------|-----------|------------------------|
| **1.1** ✅ | MAINTENANT | `flutter run` (iOS/Android) | App lance avec "Hydrate or Die" canary screen |
| **1.6** | Après Story 1.6 | `flutter run` | Home screen affiche avatar + barre hydratation |
| **1.8** | Après Story 1.8 | `flutter run` | Sélection avatar fonctionne (4 choix) |
| **2.10** | Après Story 2.10 | `flutter run` | Onboarding flow complet (poids, âge, sexe, activité) |
| **3.8** | Après Story 3.8 | `flutter run` | Bouton "Boire" fonctionne, avatar réagit |
| **3.6** | Après Story 3.6 | `flutter run` + photo | Caméra s'ouvre, photo enregistrée |
| **4.11** | Après Story 4.11 | `flutter run` + attente | Notifications reçues (autoriser permissions!) |
| **5.12** | Après Story 5.12 (MVP) | `flutter run` | Test complet E2E du flow utilisateur |

### Démarche de Test Complète

#### 1️⃣ **Test Story 1.1 (MAINTENANT - Flutter Setup)**

```bash
# Dans le terminal (Windows):
cd c:\Users\hhhh\Desktop\Claude\HydrateOrDie

# Vérifier que Flutter est installé
flutter doctor

# Lancer sur simulateur iOS (si macOS) ou émulateur Android
flutter run

# OU build pour voir s'il n'y a pas d'erreurs
flutter build apk --debug  # Android
flutter build ios --debug  # iOS (nécessite macOS)
```

**✅ Critères de réussite:**
- App se lance sans crash
- Écran affiche "Hydrate or Die - Coming Soon" (canary screen)
- Pas d'erreurs dans la console

#### 2️⃣ **Tests Automatisés (Toujours valables)**

```bash
# Après chaque story, vérifier:
flutter test                    # Tests unitaires + widget
flutter analyze                 # Analyse statique (0 issues)
flutter test --coverage         # Coverage ≥80%
```

#### 3️⃣ **Test Story 1.6 (Home Screen avec Avatar)**

```bash
flutter run
```

**✅ Critères de réussite:**
- Avatar s'affiche (emoji placeholder ou vrai asset)
- Barre d'hydratation visible (0-100%)
- État avatar change selon hydratation
- Fantôme s'affiche si mort (hydratation 0%)

#### 4️⃣ **Test Story 3.6 (Photo Validation)**

```bash
flutter run

# Dans l'app:
# 1. Appuyer sur bouton "Drink"
# 2. Autoriser permissions caméra
# 3. Prendre photo d'un verre
# 4. Vérifier que l'hydratation augmente
```

**✅ Critères de réussite:**
- Caméra s'ouvre (demande permissions)
- Photo capturée et stockée localement
- Hydratation +250ml après validation
- Avatar réagit (animation positive)

#### 5️⃣ **Test Story 4.11 (Notifications)**

```bash
flutter run

# Dans l'app:
# 1. Autoriser notifications
# 2. Ne pas boire pendant 2h
# 3. Vérifier notifications escalade (4 niveaux)
```

**✅ Critères de réussite:**
- Notifications s'affichent (Local Notifications)
- Messages personnalisés selon avatar choisi
- Vibrations chaos au niveau 4
- Pause nocturne fonctionne (22h-8h)

#### 6️⃣ **Test MVP Complet (Story 5.12)**

**Flow E2E complet:**
1. Onboarding (poids, âge, sexe, activité, localisation)
2. Sélection avatar (4 choix)
3. Boire via photo (validation verre)
4. Vérifier streak (jour 1)
5. Consulter calendrier (historique)
6. Modifier profil (settings)
7. Changer avatar (settings)
8. Attendre notifications (2h sans boire)

---

### 📱 Setup Environnement de Test

#### **Prérequis:**
```bash
# 1. Installer Flutter SDK
# Télécharge: https://docs.flutter.dev/get-started/install/windows

# 2. Installer Android Studio (pour émulateur Android)
# Télécharge: https://developer.android.com/studio

# 3. Créer un émulateur Android
# Android Studio > Device Manager > Create Device > Pixel 5 (Android 13)

# 4. Vérifier setup
flutter doctor
```

#### **Lancer Tests:**

**MÉTHODE RECOMMANDÉE - Téléphone Android physique:**
```bash
# 1. Active USB Debugging sur téléphone:
#    Paramètres > À propos > Appuie 7× sur "Numéro de build"
#    Paramètres > Options développement > Active "Débogage USB"

# 2. Connecte téléphone USB + autorise débogage

# 3. Vérifie détection:
flutter devices

# 4. Lance app:
cd c:\Users\hhhh\Desktop\Claude\HydrateOrDie
flutter run
# (Choisir le device Android dans la liste)

# Hot Reload: Appuie 'r' dans terminal après modifications code
```

**Alternative - Émulateur Android Studio:**
```bash
# Démarrer émulateur Android
# (depuis Android Studio Device Manager)

# Lancer app
flutter run
```

---

### 🚨 Quand M'Alerter Pour Tests

**Je te dirai explicitement quand tester après:**
1. ✅ Story 1.1 (MAINTENANT)
2. Story 1.6 (Home Screen)
3. Story 1.8 (Avatar Selection)
4. Story 2.10 (Onboarding complet)
5. Story 3.6 (Photo + caméra)
6. Story 3.8 (Bouton Drink)
7. Story 4.11 (Notifications)
8. Story 5.12 (MVP complet - test E2E)

**Format alerte:**
> 🧪 **TEMPS DE TESTER!** Story X.Y complétée.
> Commandes: `flutter run`
> Vérifier: [Liste critères]

---

*Ce fichier est maintenu par @bmad-master pour assurer continuité et éviter hallucinations contextuelles.*
