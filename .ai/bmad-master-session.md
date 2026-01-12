# 🧙 BMad Master - Session de Pilotage
**Projet:** HydrateOrDie
**Date Début:** 2026-01-07
**Dernière MAJ:** 2026-01-12
**Phase:** Epic 2 - Story 2.2 IN PROGRESS

---

## 📍 ÉTAT ACTUEL

**Epic 1:** ✅ COMPLETE (8/8 stories + 2 bugfixes + QA Gate validé)
**Epic 2:** 🚀 IN PROGRESS (1/10 stories, Story 2.2 en cours)
**Branche:** `feature/epic-2-story-2-hydration-calculation`

### Phase en Cours
| Phase | Agent | Livrable | Statut | Début | Notes |
|-------|-------|----------|--------|-------|-------|
| 26 | dev | Story 2.2 (Hydration Calculation) | 🚀 IN PROGRESS | 2026-01-12 | Use Case calcul besoins hydriques |

### Prochaines Phases
| Phase | Livrable | Dépendances |
|-------|----------|-------------|
| 27 | Story 2.3 (User Profile Repository) | Story 2.2 OK |
| 28-32 | Stories 2.4-2.8 (Onboarding Screens) | Story 2.3 OK |
| 33 | Story 2.9 (Summary Screen) | Stories 2.4-2.8 OK |
| 34 | Story 2.10 (Flow Integration) | Story 2.9 OK |
| 35 | QA Gate Epic 2 | Story 2.10 OK |

---

## 📊 PROGRESSION EPICS

### Epic 1 - Core Avatar System ✅
| Story | Status | Tests | Notes |
|-------|--------|-------|-------|
| 1.1 Flutter Setup | ✅ | Pass | Clean Architecture, CI/CD |
| 1.2 Domain Models | ✅ | 115 (100%) | 10 entities |
| 1.3 Avatar Repository | ✅ | 128 | SQLite + SharedPrefs |
| 1.4 Avatar Assets | ✅ | 51 | 20 emojis placeholders |
| 1.5 Dehydration Logic | ✅ | 35 | Use Case + Timer |
| 1.6 Home Screen | ✅ | 65 | Premier écran UI |
| 1.7 Ghost System | ✅ | 13 | Résurrection minuit |
| 1.8 Avatar Selection | ✅ | 11 | Grid 2×2, 4 avatars |
| Bugfix a | ✅ | - | UI Overflow 2.6-6.6px |
| Bugfix b | ✅ | - | DB Migration V2→V3 |
| **QA Gate** | ✅ | **98%** | PASSED WITH WARNINGS (13 timeouts) |

**Total:** 250+ tests, Coverage 98%, 0 flutter analyze errors

### Epic 2 - User Onboarding 🚀 (10%)
| Story | Status | Tests | Notes |
|-------|--------|-------|-------|
| 2.1 User Profile Model | ✅ | 43 (100%) | Fichiers préexistants |
| 2.2 Hydration Calculation | 🚀 | - | Use Case formule |
| 2.3 User Profile Repository | ⏸️ | - | CRUD SQLite |
| 2.4-2.8 Onboarding Screens | ⏸️ | - | 5 screens UI |
| 2.9 Summary Screen | ⏸️ | - | Récap + goal |
| 2.10 Flow Integration | ⏸️ | - | Navigation |

---

## 🎯 DÉCISIONS CLÉS

### Avatars (2026-01-07)
- **4 avatars:** Docteur, Coach, Mère, Pote
- **5 états:** Fresh, Tired, Dehydrated, Dead, Ghost
- **20 assets:** Emojis placeholders → PNG plus tard
- **Messages:** Personnalisés par avatar

### Design System (2026-01-07)
- **Vibe:** Fun/Gamifié (18-35 ans), Duolingo + Tamagotchi
- **Couleurs:** Bleu #2196F3 (primaire), Orange #FF6B6B (alertes)
- **Ton:** Playful avec edge

### Workflow (2026-01-07)
- **Master:** Conversation persistente (pilotage)
- **Agents:** Nouveau chat par tâche
- **Git:** Epic 1 direct master, Epic 2+ feature branches
- **Validation:** QA Gate par EPIC

### Database (2026-01-08)
- **Schema:** camelCase columns (non-standard mais fonctionnel)
- **Version:** V3 (avatars table)
- **Migration:** Automatique V1→V2→V3

---

## 📝 HISTORIQUE CLÉS

| Date | Event | Agent |
|------|-------|-------|
| 2026-01-07 | Brief + PRD + Architecture créés | analyst, pm, architect |
| 2026-01-07 | Front-end spec + PO validation (92%) | ux-expert, po |
| 2026-01-07 | Sharding 24 docs + QA Gates 6 files | master |
| 2026-01-08 | Stories 1.1-1.3 complètes (Foundation) | dev |
| 2026-01-09 | Stories 1.4-1.6 complètes (UI démarrée) | dev |
| 2026-01-11 | Story 1.7 complète (Ghost System) | dev |
| 2026-01-12 | Epic 1 COMPLETE + 2 bugfixes critiques | dev |
| 2026-01-12 | QA Gate Epic 1 validé (98% coverage) | qa |
| 2026-01-12 | Epic 2 démarré - Story 2.1 complète | dev |

---

## 🚀 PROCHAINES ÉTAPES

### Immédiat (Story 2.2)
1. @dev implémente CalculateHydrationGoalUseCase
2. Formule: Base = weight × 0.033L + factors (activity/gender/age)
3. Tests edge cases: tous profils
4. Commit: [EPIC-2.2] Add hydration goal calculation

### Après Story 2.2
1. Story 2.3: User Profile Repository (SQLite CRUD)
2. Stories 2.4-2.8: Onboarding screens (Weight/Age/Gender/Activity/Location)
3. Story 2.9: Summary Screen (récap + goal)
4. Story 2.10: Flow Integration (navigation complète)
5. QA Gate Epic 2

---

## 🚧 RISQUES SURVEILLÉS

1. **Tests timeouts Epic 1:** 13 widget tests timeout (warning acceptable)
2. **Assets placeholders:** Emojis → PNG migration requise post-MVP
3. **Géolocalisation Story 2.8:** Permission refusée → Fallback pays manuel
4. **DB camelCase:** Non-standard SQL mais validé fonctionnel

---

## 💡 COMMANDES MASTER

**Utilisées:**
- ✅ `*help` - Liste commandes
- ✅ `*task execute-checklist` - QA Gates
- ✅ `*shard-doc` - Fragmentation docs

**Disponibles:**
- `*create-doc {template}` - Créer document
- `*kb` - Toggle mode KB (doc BMad)
- `*exit` - Quitter Master

---

## 📚 RESSOURCES CLÉS

**Docs Projet:**
- docs/brief.md, docs/prd.md, docs/architecture.md
- docs/stories/epic-1/dev-context-epic-1-archived.md (Epic 1 complete)
- docs/stories/epic-2/dev-context-epic-2.md (Epic 2 actif)
- docs/qa/gates/epic-1-qa-gate.md (validé)
- docs/governance.md, docs/definition-of-done.md

**Config BMad:**
- .bmad-core/core-config.yaml
- .bmad-core/workflows/greenfield-fullstack.yaml

---

**Dernière action:** ✅ Story 2.1 COMPLETE (43/43 tests, 100% coverage)
**Action en cours:** 🚀 Story 2.2 - Hydration Calculation Logic (Use Case)
**Prochaine étape:** Story 2.3 - User Profile Repository (SQLite)

---

*Fichier maintenu par @bmad-master pour continuité projet.*
