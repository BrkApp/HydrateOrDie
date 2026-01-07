# Architecture Document - Hydrate or Die MVP

**Version:** 2.0 (Détaillée - Contrats Pre-Development)
**Date:** 2026-01-07
**Owner:** Winston (Architect) & Product Manager John
**Status:** DRAFT - Awaiting PM Validation
**Based On:** PRD v1.0, Tech Stack v1.0, System Architecture v1.0

---

## Navigation de l'Architecture

Ce document est fragmenté en plusieurs sections pour faciliter la navigation:

### Sections Principales

1. **[Vue d'Ensemble](overview.md)** - Executive Summary, Architecture Globale, Principes Architecturaux
2. **[Domain Layer](domain-layer.md)** - Business Logic Pure Dart, Entities, Use Cases, Repository Interfaces
3. **[Data Layer](data-layer.md)** - Repository Implementations, Models/DTOs, Data Sources, Sync Strategy
4. **[Presentation Layer](presentation-layer.md)** - UI Screens, State Management (Riverpod), Widgets, Navigation
5. **[Core Layer](core-layer.md)** - Utilities, Constants, Theme, Dependency Injection, Services
6. **[Data Architecture](data-architecture.md)** - Offline-First Flow, Database Schema (SQLite + Firestore)
7. **[Notification System](notification-system.md)** - Local Notifications, Escalation System, Message Generation
8. **[Photo Validation](photo-validation.md)** - Photo Capture Flow, Storage, Validation Logic
9. **[Background Jobs](background-jobs.md)** - App Lifecycle, Timers, Midnight Jobs
10. **[Security & Auth](security-auth.md)** - Authentication Flow, RGPD Compliance, Data Privacy
11. **[Analytics & Monitoring](analytics.md)** - Firebase Analytics Events, Crashlytics
12. **[Deployment & CI/CD](deployment.md)** - Build Pipeline, GitHub Actions, Versioning
13. **[V2 Features](v2-features.md)** - Weather API Integration, Future Enhancements

---

## Executive Summary

Hydrate or Die est une application mobile cross-platform (iOS/Android) construite avec **Flutter** et **Clean Architecture**, utilisant **Firebase** comme Backend-as-a-Service et **SQLite** pour la persistence locale offline-first. L'application combine un système d'avatar Tamagotchi, validation photo par selfie, notifications punitives progressives et mécaniques de rétention (streaks) pour transformer l'hydratation en habitude engageante.

**Principes Architecturaux Fondamentaux:**
- **Offline-First:** SQLite est la source de vérité, Firestore le backup cloud
- **Clean Architecture:** Séparation stricte Presentation/Domain/Data
- **Testabilité:** Domain layer 100% pure Dart, injectable, testable en isolation
- **RGPD Compliance:** Data minimization, consent explicite, droit à l'effacement

---

## Architecture Validation Checklist

Selon governance.md - Section "Checklist Pre-Development":

- [x] Architecture globale documentée avec diagrammes
- [x] Flux de données (data flow) définis
- [x] Patterns architecturaux justifiés (Clean Architecture)
- [x] Décisions techniques justifiées (Firebase, Riverpod, SQLite)
- [x] Structure dossiers détaillée avec conventions
- [x] Offline-first strategy définie
- [x] Security & RGPD compliance adressés
- [x] CI/CD pipeline décrit
- [x] Background jobs & timers planifiés
- [ ] Contrats d'interface créés (prochaine étape)
- [ ] Validation PM (awaiting)

---

## Prochaines Étapes

### Documents de Contrats à Créer

1. **docs/contracts/data-models.md** - Tous les models/DTOs/entities
2. **docs/contracts/database-schema.md** - SQLite + Firestore schémas complets
3. **docs/contracts/api-contracts.md** - Firebase Auth/Firestore/Storage APIs
4. **docs/contracts/repositories-interface.md** - Interfaces repositories
5. **docs/contracts/use-cases-interface.md** - Interfaces use cases

### Après Validation PM

6. Créer structure `lib/` selon conventions
7. Setup `pubspec.yaml` avec dépendances MVP
8. Configurer Firebase (iOS + Android)
9. Setup GitHub Actions CI/CD
10. Créer tests dummy pour valider CI

---

**Document créé le 2026-01-07 par Winston (Architect)**
**Status: DRAFT - Awaiting PM Validation**
**Next: Créer contracts/ directory avec tous les contrats d'interface**
