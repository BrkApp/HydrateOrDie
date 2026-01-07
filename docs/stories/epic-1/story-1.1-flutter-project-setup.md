# Story 1.1: Projet Flutter Initial avec CI/CD

**Epic:** Epic 1 - Foundation & Avatar Core System
**Story ID:** 1.1
**Status:** Not Started
**Priority:** Critical
**Estimated Effort:** 4 hours

---

## User Story

**As a** developer,
**I want** un projet Flutter correctement configuré avec CI/CD et tests automatiques,
**so that** je peux développer avec confiance et qualité dès le premier jour.

---

## Acceptance Criteria

1. Le projet Flutter est créé avec structure Clean Architecture (core/, data/, domain/, presentation/)
2. Le fichier `pubspec.yaml` contient toutes les dépendances essentielles MVP (camera, flutter_local_notifications, permission_handler, shared_preferences, sqflite, firebase_core, riverpod/bloc, get_it)
3. La configuration Firebase est complète (iOS + Android) avec fichiers GoogleService-Info.plist et google-services.json
4. GitHub Actions CI/CD est configuré pour exécuter `flutter test` et `flutter analyze` sur chaque commit
5. Le projet build avec succès sur iOS (simulateur) et Android (émulateur) sans erreurs
6. Un écran canary simple "Hydrate or Die - Coming Soon" s'affiche au lancement de l'app (health-check visuel)
7. Les tests unitaires de base passent (au minimum un test dummy pour valider la CI)
8. Le README contient les instructions de setup (Flutter version, Firebase config, commandes build)

---

## Technical Notes

- Flutter version: Stable channel (latest)
- Firebase: Utiliser FlutterFire CLI pour setup automatique
- CI/CD: GitHub Actions workflow dans `.github/workflows/ci.yml`
- Structure folders stricte selon `docs/governance.md`

---

## Dependencies

- None (première story du projet)

---

## Definition of Done

Référence: `docs/definition-of-done.md`

- [ ] Tous les acceptance criteria validés
- [ ] Build iOS + Android OK
- [ ] CI/CD pipeline passe
- [ ] README.md complet
- [ ] Code respecte conventions
- [ ] PM approval obtenue

---

## Links

- Epic: [epic-1-foundation.md](../epics/epic-1-foundation.md)
- Next Story: [story-1.2-avatar-models.md](story-1.2-avatar-models.md)
