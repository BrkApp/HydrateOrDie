# 🧙 BMad Master - Session de Pilotage
**Projet:** HydrateOrDie
**Date Début:** 2026-01-07
**Dernière MAJ:** 2026-01-12
**Phase Actuelle:** Tests Manuels (Epic 1 - COMPLETE, Debugging Phase)

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
| 14 | dev | Story 1.5 (Dehydration Logic) | ✅ Terminé | 2026-01-09 | Use Case + Timer Service, 35 tests, transitions automatiques |
| 15 | dev | Story 1.6 (Home Screen) | ✅ Terminé | 2026-01-09 | PREMIER ÉCRAN UI! 65 tests, 4 widgets, auto-refresh 60s |
| 16 | dev | Story 1.7 (Ghost System) | ✅ Terminé | 2026-01-11 | Résurrection + dead→ghost transition, 13 tests, 62/62 DOD |
| 17 | dev | Story 1.8 (Avatar Selection) | ✅ Terminé | 2026-01-12 | **EPIC 1 COMPLETE!** Grid 2×2, 4 avatars, 11 tests |
| 18 | master | Token Optimization | ✅ Terminé | 2026-01-12 | .claudeignore, .CLAUDE.md, ~10-15K tokens économisés |
| 19 | dev | Bugfix 1.8 UI Overflow | ✅ Terminé | 2026-01-12 | Fix 2.6-6.6px overflow, Flexible widget, padding/size adjusted |
| 20 | dev | Bugfix 1.8 DB Schema | ✅ Terminé | 2026-01-12 | **CRITICAL FIX:** Migration V2→V3, snake_case→camelCase columns |

### ⏸️ PHASE EN COURS

| Phase | Agent | Livrable | Statut | Début | Notes |
|-------|-------|----------|--------|-------|-------|
| 21 | user | Test Epic 1 Manuel | 🧪 En test | 2026-01-12 | APK v3 (10:04), test sur téléphone Android |

### 🔜 PHASES À VENIR

| Phase | Agent | Livrable | Dépendances | Notes |
|-------|-------|----------|-------------|-------|
| 22 | user | Validation Bugfixes | Test manuel OK | Confirmer navigation Home Screen fonctionne |
| 20 | qa | QA Gate Epic 1 | Tests manuels OK | Execute docs/qa/gates/epic-1-qa-gate.md |
| 21 | architect | Review Epic 1 | QA Gate passé | Vérif architecture Clean Architecture |
| 22 | pm | Review Epic 1 | Architect OK | Validation fonctionnelle (AC, specs PRD, comportement) |
| 23 | po | Acceptance Epic 1 | PM + Architect OK | Validation epic prêt pour Epic 2 |
| 24+ | dev | Epic 2 Onboarding | Epic 1 validé | Stories 2.1-2.10 |

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

### PHASE DE PLANIFICATION (Complétée ✅)
```
├─ ✅ analyst → brief.md
├─ ✅ pm → prd.md
├─ ✅ ux-expert → front-end-spec.md
├─ ✅ architect → architecture.md
├─ ✅ pm → review architect suggestions
├─ ✅ po → validate all docs with po-master-checklist (92% readiness)
├─ ✅ master → shard documents (24 fichiers)
└─ ✅ master → create QA gates (6 fichiers)
```

### PHASE DE DÉVELOPPEMENT (Epic 1 Complete ✅)
```
Epic 1: Core Avatar System (8/8 stories ✅ + 2 bugfixes critiques)
├─ ✅ Story 1.1 → Flutter Setup
├─ ✅ Story 1.2 → Domain Models
├─ ✅ Story 1.3 → Avatar Repository
├─ ✅ Story 1.4 → Avatar Assets
├─ ✅ Story 1.5 → Dehydration Logic
├─ ✅ Story 1.6 → Home Screen
├─ ✅ Story 1.7 → Ghost System
├─ ✅ Story 1.8 → Avatar Selection (COMPLETE - 2026-01-12)
├─ ✅ Bugfix 1.8a → UI Overflow (2.6-6.6px overflow descriptions)
└─ ✅ Bugfix 1.8b → DB Schema (StorageException: snake_case→camelCase migration)
```

---

## 📝 PROCHAINES ÉTAPES

### Étape Immédiate
**[EN COURS]** Test Manuel APK v3 (2026-01-12 10:04) - Validation bugfixes critiques

**Action utilisateur:**
1. Désinstaller ancienne app du téléphone
2. Installer APK v3: `build/app/outputs/flutter-apk/app-debug.apk` (169 MB)
3. Tester:
   - ✅ Overflow UI fixé (descriptions avatars visibles)
   - ❓ Navigation vers Home Screen (CRITICAL - StorageException était bloquante)
   - ✅ Sélection avatars fonctionne (bordure bleue)

**Si navigation échoue encore:** Copier logs Logcat Android Studio (filtre: DEBUG/ERROR)

### Après Tests Manuels OK (Fin Epic 1)
1. **Test Manuel Epic 1**
   - User teste `flutter run`
   - Vérifie: Home Screen + Avatar Selection + Ghost System
   - Valide transitions dead → ghost → fresh (minuit)

2. **QA Gate Epic 1**
   - Lance @qa avec docs/qa/gates/epic-1-qa-gate.md
   - Vérifie 100% AC remplis (8 stories)
   - Génère rapport QA

3. **Review Epic 1**
   - @architect → Vérifie Clean Architecture respectée
   - @pm → Valide comportements vs PRD specs

4. **Acceptance Epic 1**
   - @po → Validation finale epic
   - Si OK → Débute Epic 2 (Onboarding)

5. **Epic 2 - User Onboarding**
   - Stories 2.1 à 2.10
   - Configuration profil utilisateur complète

---

## 🚧 BLOCKERS & RISQUES IDENTIFIÉS

### Blockers Actuels
Aucun - Epic 1 en excellente progression (87.5%)

### Risques Surveillés
1. **Tests manuels Epic 1** → Risque: Bugs UI non détectés par tests unitaires
   - Mitigation: Test manuel complet après Story 1.8
   - Status: 🟡 EN COURS (APK v3 en test)

2. **Database migration V2→V3** → Risque: Perte données utilisateur après bugfix
   - Mitigation: Migration automatique preserve les données (selected_avatar_id→personality mapping)
   - Status: 🟢 RÉSOLU (code testé, à valider manuellement sur APK)

3. **StorageException navigation** → Risque: Bug critique bloquant sélection avatar
   - Mitigation: Schéma DB corrigé (snake_case→camelCase), tests passent
   - Status: 🟡 CORRIGÉ (à valider sur device réel)

4. **Résurrection minuit** → Risque: Timer ne déclenche pas correctement
   - Mitigation: Test manuel simulation minuit requis
   - Status: 🟡 À valider manuellement

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
| 2026-01-09 | Mise à jour dev-context.md après Story 1.4 (commit a586f1a) | BMad Master |
| 2026-01-09 | ✅ Phase 14 complétée (Story 1.5 - Use Case + Timer Service) | Dev Agent |
| 2026-01-09 | ✅ Phase 15 complétée (Story 1.6 - Home Screen, PREMIER ÉCRAN UI!) | Dev Agent |
| 2026-01-11 | ✅ Phase 16 complétée (Story 1.7 - Ghost System, 62/62 DOD) | Dev Agent |
| 2026-01-11 | Mise à jour session: Epic 1 87.5% complété (7/8 stories) | BMad Master |

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

**Dernière action:** ✅ Story 1.7 complétée (Ghost System - Résurrection + dead→ghost, 13 tests, 62/62 DOD)
**Prochaine action:** DÉVELOPPEMENT - @dev implémente Story 1.8 (Avatar Selection Screen) - DERNIÈRE STORY EPIC 1!

---

## 🧪 MOMENTS DE TEST MANUEL (User Testing)

### Quand Tester?

| Story | Moment Test | Commandes | Ce qu'il faut vérifier |
|-------|------------|-----------|------------------------|
| **1.1** ✅ | ~~FAIT~~ | `flutter run` (iOS/Android) | App lance avec "Hydrate or Die" canary screen |
| **1.6** ✅ | ~~FAIT~~ | `flutter run` | Home screen affiche avatar + barre hydratation |
| **1.7** ✅ | ~~FAIT~~ | `flutter run` + attente 10s | Dead → Ghost transition + messages dramatiques |
| **1.8** | 🚨 APRÈS STORY 1.8 | `flutter run` | Sélection avatar fonctionne (4 choix) + persistence |
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
1. ✅ Story 1.1 (FAIT)
2. ✅ Story 1.6 (FAIT - Home Screen)
3. ✅ Story 1.7 (FAIT - Ghost System)
4. 🚨 Story 1.8 (PROCHAIN - Avatar Selection) ← **FIN EPIC 1**
5. Story 2.10 (Onboarding complet)
6. Story 3.6 (Photo + caméra)
7. Story 3.8 (Bouton Drink)
8. Story 4.11 (Notifications)
9. Story 5.12 (MVP complet - test E2E)

**Format alerte:**
> 🧪 **TEMPS DE TESTER!** Story X.Y complétée.
> Commandes: `flutter run`
> Vérifier: [Liste critères]

---

*Ce fichier est maintenu par @bmad-master pour assurer continuité et éviter hallucinations contextuelles.*
