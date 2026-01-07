# Documentation Hydrate or Die

Bienvenue dans la documentation du projet **Hydrate or Die**!

---

## Structure de la Documentation

La documentation du projet est organisée de manière modulaire pour faciliter la navigation:

### Documents Principaux

#### 1. Product Requirements Document (PRD)

**Point d'entrée:** [docs/prd/index.md](prd/index.md)

Le PRD est fragmenté en 6 sections logiques:
- **Context & Goals** - Objectifs et contexte du projet
- **Requirements** - Exigences fonctionnelles et non-fonctionnelles
- **UI/UX Design** - Vision UX, écrans, accessibilité, branding
- **Technical Assumptions** - Architecture, testing, packages
- **Epic List** - Liste des 5 epics du MVP

#### 2. Architecture Document

**Point d'entrée:** [docs/architecture/index.md](architecture/index.md)

Le document d'architecture est fragmenté en 14 sections techniques:
- **Overview** - Vue d'ensemble et principes architecturaux
- **Domain Layer** - Business logic pure (Dart)
- **Data Layer** - Repositories, models, data sources
- **Presentation Layer** - UI, state management (Riverpod)
- **Core Layer** - Utilities, DI, constants
- **Data Architecture** - Offline-first, database schema
- **Notification System** - Escalation, scheduling
- **Photo Validation** - Capture et stockage
- **Background Jobs** - Lifecycle, timers
- **Security & Auth** - Firebase Auth, RGPD
- **Analytics** - Firebase Analytics, Crashlytics
- **Deployment** - CI/CD, GitHub Actions
- **V2 Features** - Weather API, futures enhancements

---

## Navigation

Chaque fichier fragmenté contient:
- Des liens de navigation en bas de page (⬅️ précédent | ➡️ suivant)
- Un lien de retour rapide à l'index (🏠)
- Une indication claire de la partie du document parent

---

## Documents Originaux (Backup)

Les documents originaux complets sont disponibles pour référence:
- [docs/prd.md](prd.md) - PRD complet (17 KB, 327 lignes)
- [docs/architecture.md](architecture.md) - Architecture complète (40 KB, 979 lignes)

---

## Rapport de Fragmentation

Pour comprendre comment les documents ont été fragmentés:
- [docs/SHARDING_REPORT.md](SHARDING_REPORT.md) - Rapport détaillé de fragmentation

---

## Pour les Agents de Développement

### Workflow Recommandé

1. **Découverte:** Commencez par [prd/index.md](prd/index.md) pour comprendre le produit
2. **Architecture:** Consultez [architecture/index.md](architecture/index.md) pour la structure technique
3. **Développement:** Naviguez vers les sections spécifiques selon le epic/story en cours
4. **Contrats:** Référez-vous aux contracts/ (à créer) pour les interfaces et modèles

### Avantages de la Structure Fragmentée

- **Navigation rapide:** Accès direct aux sections pertinentes
- **Isolation:** Focus sur une partie technique sans distraction
- **Collaboration:** Plusieurs agents peuvent travailler sur différentes sections
- **Maintenance:** Mises à jour localisées sans impacter l'ensemble

---

## Statut de la Documentation

- ✅ PRD fragmenté (6 fichiers)
- ✅ Architecture fragmentée (14 fichiers)
- ⏳ Epics détaillés (à créer dans prd/)
- ⏳ Contracts d'interface (à créer dans contracts/)
- ⏳ UX Design documents (à créer après validation UX Expert)

---

**Dernière mise à jour:** 2026-01-07
**Version:** 1.0
