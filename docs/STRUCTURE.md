# Structure de la Documentation Fragmentée

**Date:** 2026-01-07

---

## Vue d'Ensemble

```
docs/
├── README.md                          # Guide principal de navigation
├── SHARDING_REPORT.md                 # Rapport détaillé de fragmentation
├── VALIDATION_CHECKLIST.md            # Checklist de validation d'intégrité
├── STRUCTURE.md                       # Ce fichier (structure visuelle)
│
├── prd.md                             # [ORIGINAL] Product Requirements (17 KB)
├── architecture.md                    # [ORIGINAL] Architecture Document (40 KB)
│
├── prd/                               # ⭐ PRD FRAGMENTÉ (6 fichiers)
│   ├── index.md                       # Point d'entrée avec navigation
│   ├── context-and-goals.md           # Goals + Background Context
│   ├── requirements.md                # FR1-FR20 + NFR1-NFR15
│   ├── ui-design.md                   # UX Vision, Screens, Accessibility
│   ├── technical-assumptions.md       # Architecture, Testing, Packages
│   └── epic-list.md                   # Liste des 5 epics MVP
│
└── architecture/                      # ⭐ ARCHITECTURE FRAGMENTÉE (14 fichiers)
    ├── index.md                       # Point d'entrée avec navigation
    ├── overview.md                    # Executive Summary + Diagramme global
    ├── domain-layer.md                # Pure Dart: Entities, Use Cases, Interfaces
    ├── data-layer.md                  # Repository Impl, Models, Data Sources
    ├── presentation-layer.md          # UI, Screens, Widgets, Riverpod
    ├── core-layer.md                  # Constants, Theme, DI (get_it)
    ├── data-architecture.md           # Offline-First Flow, DB Schema
    ├── notification-system.md         # Escalation 4 niveaux, Scheduling
    ├── photo-validation.md            # Photo Capture & Storage Flow
    ├── background-jobs.md             # App Lifecycle, Timers, Midnight Jobs
    ├── security-auth.md               # Firebase Auth, RGPD, Privacy
    ├── analytics.md                   # Firebase Analytics Events
    ├── deployment.md                  # CI/CD Pipeline, GitHub Actions
    └── v2-features.md                 # Weather API, Future Enhancements
```

---

## Hiérarchie de Navigation

### PRD (Product Requirements Document)

```
index.md (Point d'entrée)
    │
    ├──► context-and-goals.md
    │       └──► Goals (6 objectifs)
    │       └──► Background Context
    │
    ├──► requirements.md
    │       └──► Functional Requirements (FR1-FR20)
    │       └──► Non-Functional Requirements (NFR1-NFR15)
    │
    ├──► ui-design.md
    │       └──► Overall UX Vision
    │       └──► Key Interaction Paradigms
    │       └──► Core Screens (7 écrans)
    │       └──► Accessibility (WCAG AA)
    │       └──► Branding & Target Platforms
    │
    ├──► technical-assumptions.md
    │       └──► Repository Structure (Monorepo)
    │       └──► Service Architecture (Firebase)
    │       └──► Testing Requirements (Unit + Integration)
    │       └──► Additional Technical Assumptions
    │
    └──► epic-list.md
            └──► Epic 1: Foundation & Avatar Core System
            └──► Epic 2: Onboarding & Personnalisation
            └──► Epic 3: Validation Photo & Feedback
            └──► Epic 4: Système de Notifications
            └──► Epic 5: Progression & Rétention
```

### Architecture Document

```
index.md (Point d'entrée)
    │
    ├──► overview.md
    │       └──► Executive Summary
    │       └──► Principes Architecturaux Fondamentaux
    │       └──► Diagramme Architecture Globale
    │
    ├──► CLEAN ARCHITECTURE LAYERS
    │   │
    │   ├──► domain-layer.md
    │   │       └──► Entities (User, Avatar, Streak...)
    │   │       └──► Repository Interfaces (abstractions)
    │   │       └──► Use Cases (business logic pure)
    │   │
    │   ├──► data-layer.md
    │   │       └──► Models/DTOs (sérialisables)
    │   │       └──► Repository Implementations
    │   │       └──► Data Sources (Local SQLite + Remote Firestore)
    │   │       └──► Offline-First Sync Strategy
    │   │
    │   ├──► presentation-layer.md
    │   │       └──► Screens (Splash, Onboarding, Home, Photo...)
    │   │       └──► Widgets (réutilisables)
    │   │       └──► Providers (Riverpod StateNotifiers)
    │   │       └──► Navigation (GoRouter)
    │   │
    │   └──► core-layer.md
    │           └──► Constants (app, assets, notifications)
    │           └──► Theme (Material Design 3)
    │           └──► Dependency Injection (get_it)
    │           └──► Services (notification, analytics, background)
    │
    ├──► SYSTÈMES SPÉCIFIQUES
    │   │
    │   ├──► data-architecture.md
    │   │       └──► Offline-First Data Flow
    │   │       └──► Database Schema (SQLite + Firestore)
    │   │
    │   ├──► notification-system.md
    │   │       └──► Escalation System (4 niveaux)
    │   │       └──► Local Notifications (flutter_local_notifications)
    │   │       └──► Message Generation (personnalisé par avatar)
    │   │
    │   ├──► photo-validation.md
    │   │       └──► Photo Capture Flow (camera package)
    │   │       └──► Storage Strategy (local + opt-in cloud)
    │   │       └──► Glass Size Selection
    │   │
    │   ├──► background-jobs.md
    │   │       └──► App Lifecycle Management
    │   │       └──► Timers (Avatar State, Notifications)
    │   │       └──► Midnight Jobs (Streak, Reset, Resurrect)
    │   │
    │   ├──► security-auth.md
    │   │       └──► Authentication Flow (Firebase Auth)
    │   │       └──► Data Privacy & RGPD Compliance
    │   │       └──► Delete Account Flow
    │   │
    │   ├──► analytics.md
    │   │       └──► Firebase Analytics Events (User + Technical)
    │   │       └──► Crashlytics
    │   │
    │   └──► deployment.md
    │           └──► CI/CD Pipeline (GitHub Actions)
    │           └──► Build & Release (iOS + Android)
    │           └──► Environments (dev, prod)
    │
    └──► v2-features.md
            └──► Weather API Integration
            └──► Apple Watch / Wear OS
            └──► Advanced Analytics Dashboard
            └──► Social Features
            └──► Premium Avatar Packs
```

---

## Statistiques

### Documents Originaux

| Document | Taille | Lignes | Headers |
|----------|--------|--------|---------|
| prd.md | 17 KB | 327 | 29 |
| architecture.md | 40 KB | 979 | 32 |
| **TOTAL** | **57 KB** | **1306** | **61** |

### Documents Fragmentés

| Catégorie | Fichiers | Taille Totale |
|-----------|----------|---------------|
| PRD | 6 | ~18.7 KB |
| Architecture | 14 | ~43.9 KB |
| **TOTAL** | **20** | **~62.6 KB** |

**Note:** La taille totale fragmentée est légèrement supérieure en raison des liens de navigation ajoutés et des en-têtes "Partie de:" dans chaque fragment.

---

## Avantages de la Structure Fragmentée

### Pour les Agents de Développement

1. **Navigation Ciblée**
   - Accès direct à la section pertinente sans parcourir 1000+ lignes
   - Liens de navigation intégrés (précédent/suivant/index)

2. **Isolation du Contexte**
   - Focus sur un aspect technique précis (ex: Domain Layer uniquement)
   - Moins de charge cognitive lors de la lecture

3. **Collaboration Facilitée**
   - Plusieurs agents peuvent référencer différentes sections simultanément
   - Réduction des conflits sur les fichiers (pas de monolithe)

4. **Maintenance Simplifiée**
   - Mises à jour localisées (ex: modifier seulement security-auth.md)
   - Historique Git plus lisible (commits ciblés)

### Pour les Humains

1. **Compréhension Progressive**
   - Possibilité de lire une section à la fois
   - Table des matières claire dans les index

2. **Référencement Facile**
   - URL directe vers une section spécifique
   - Bookmarks précis dans le navigateur

3. **Recherche Efficace**
   - Grep/Find sur des fichiers plus petits
   - Moins de résultats non pertinents

---

## Workflow de Lecture Recommandé

### Pour Nouveaux Arrivants

```
1. docs/README.md
       ↓
2. docs/prd/index.md (comprendre le produit)
       ↓
3. docs/prd/context-and-goals.md (vision globale)
       ↓
4. docs/architecture/index.md (comprendre la structure technique)
       ↓
5. docs/architecture/overview.md (principes architecturaux)
       ↓
6. Naviguer selon les besoins spécifiques...
```

### Pour Développement par Epic

```
Epic 1 (Foundation & Avatar):
  - prd/epic-list.md → Epic 1
  - architecture/domain-layer.md → Avatar Use Cases
  - architecture/data-layer.md → Avatar Repository
  - architecture/presentation-layer.md → Home Screen

Epic 3 (Photo Validation):
  - prd/epic-list.md → Epic 3
  - architecture/photo-validation.md → Flow complet
  - architecture/presentation-layer.md → Photo Screens

Epic 4 (Notifications):
  - prd/epic-list.md → Epic 4
  - architecture/notification-system.md → System complet
  - architecture/background-jobs.md → Timers
```

---

## Prochaines Étapes

### Documentation à Créer

1. **Epics Détaillés** (référencés mais non créés)
   - docs/prd/epic-1-foundation.md
   - docs/prd/epic-2-onboarding.md
   - docs/prd/epic-3-photo-validation.md
   - docs/prd/epic-4-notifications.md
   - docs/prd/epic-5-progression.md

2. **Contracts d'Interface** (référencés dans architecture)
   - docs/contracts/data-models.md
   - docs/contracts/database-schema.md
   - docs/contracts/api-contracts.md
   - docs/contracts/repositories-interface.md
   - docs/contracts/use-cases-interface.md

3. **UX Design Documents** (après validation UX Expert)
   - docs/ux/wireframes.md
   - docs/ux/design-system.md
   - docs/ux/prototypes.md

---

**Document créé le:** 2026-01-07
**Structure validée:** ✅
**Prêt pour utilisation:** ✅
