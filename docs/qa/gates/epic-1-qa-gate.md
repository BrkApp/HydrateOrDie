# QA Gate - Epic 1: Foundation & Avatar Core System

**Version:** 1.0
**Date:** 2026-01-07
**Status:** 🔴 Not Started

---

## 📋 Vue d'Ensemble

**Epic:** 1 - Foundation & Avatar Core System
**Objectif:** Établir l'infrastructure projet (Flutter app, Firebase, CI/CD) et implémenter le système d'avatar Tamagotchi avec ses 4 états de déshydratation et le système de mort temporaire/fantôme.
**Stories:** 1.1 à 1.8 (8 stories)
**Criticité:** CRITICAL (Base de tout le projet)

---

## ✅ VALIDATION FONCTIONNELLE

### Features Principales
- [ ] Application Flutter build et lance sur iOS simulateur sans erreur
- [ ] Application Flutter build et lance sur Android émulateur sans erreur
- [ ] 4 avatars disponibles avec personnalités distinctes (Mère Autoritaire, Coach Sportif, Docteur, Ami Sarcastique)
- [ ] Chaque avatar a 4 états visuels distincts: Fresh → Tired → Dehydrated → Dead
- [ ] État fantôme (Ghost) fonctionne après mort d'avatar
- [ ] Avatar se déshydrate progressivement selon timer (0-2h Fresh, 2-4h Tired, 4-6h Dehydrated, 6h+ Dead)
- [ ] Résurrection automatique du fantôme à minuit (00h00)
- [ ] Sélection initiale d'avatar au premier lancement fonctionne
- [ ] Avatar sélectionné persiste entre sessions app

### User Stories Acceptance Criteria

#### Story 1.1: Projet Flutter Initial
- [ ] Projet Flutter créé avec structure Clean Architecture (core/, data/, domain/, presentation/)
- [ ] pubspec.yaml contient toutes dépendances MVP (camera, notifications, sqflite, firebase, riverpod, get_it)
- [ ] Firebase configuré iOS + Android (GoogleService-Info.plist + google-services.json)
- [ ] GitHub Actions CI/CD exécute flutter test + flutter analyze sur chaque commit
- [ ] Écran canary "Hydrate or Die - Coming Soon" s'affiche au lancement
- [ ] README contient instructions setup complètes

#### Story 1.2: Modèles Avatar
- [ ] Classe Avatar avec propriétés: id, name, personality, currentState, imageAssetPath
- [ ] Enum AvatarState: fresh, tired, dehydrated, dead, ghost (5 états)
- [ ] Enum AvatarPersonality: authoritarianMother, sportsCoach, doctor, sarcasticFriend
- [ ] Méthodes toJson/fromJson fonctionnelles
- [ ] Tests unitaires coverage 100% des models

#### Story 1.3: Repository Avatar
- [ ] AvatarRepository implémente saveSelectedAvatar, getSelectedAvatar, updateAvatarState, getAvatarState
- [ ] Utilise shared_preferences pour avatar ID
- [ ] Utilise sqflite pour état avatar + timestamps
- [ ] Retourne état 'fresh' par défaut si nouvelle installation
- [ ] Tests unitaires + intégration passent

#### Story 1.4: Assets Visuels
- [ ] 16 assets minimum disponibles (4 avatars × 4 états)
- [ ] Assets placés dans assets/images/avatars/ ou assets/animations/avatars/
- [ ] pubspec.yaml déclare tous assets
- [ ] Images optimisées <500KB chacune
- [ ] Widget AvatarDisplay affiche avatar correct selon état + personnalité
- [ ] Widget test valide affichage pour toutes combinaisons

#### Story 1.5: Logique Déshydratation
- [ ] UpdateAvatarStateUseCase calcule état basé sur temps écoulé depuis lastDrinkTime
- [ ] Progression: Fresh (0-2h), Tired (2-4h), Dehydrated (4-6h), Dead (6h+)
- [ ] Use case appelé à ouverture app + périodiquement (30min timer)
- [ ] Transitions loggées pour debug
- [ ] Tests couvrent tous scénarios temporels (0h, 1h, 3h, 5h, 7h)
- [ ] Timer background utilise Timer.periodic et est annulé proprement

#### Story 1.6: Écran Principal
- [ ] HomeScreen affiche avatar au centre (50% hauteur écran)
- [ ] Avatar correspond à l'état calculé en temps réel
- [ ] Texte indique état avec ton personnalité avatar
- [ ] Temps écoulé depuis dernière hydratation affiché (ex: "il y a 3h12")
- [ ] Écran se rafraîchit auto toutes les 60 secondes
- [ ] Bouton "Je bois" présent (UI seulement, non fonctionnel)
- [ ] State management (Riverpod) gère état avatar réactivement
- [ ] Widget test valide affichage pour chaque état

#### Story 1.7: Système Fantôme
- [ ] État 'ghost' ajouté à AvatarState enum
- [ ] Avatar passe de 'dead' à 'ghost' après 10 secondes
- [ ] Fantôme a asset visuel distinct (spectral/transparent)
- [ ] Message dramatique affiché en état ghost: "Ton avatar est mort aujourd'hui... Il reviendra demain."
- [ ] Résurrection automatique à minuit (00h00 locale) vers état 'fresh'
- [ ] Résurrection réinitialise lastDrinkTime à DateTime.now()
- [ ] Tests unitaires valident transitions dead → ghost → fresh
- [ ] Widget test valide affichage fantôme

#### Story 1.8: Sélection Avatar
- [ ] AvatarSelectionScreen s'affiche au premier lancement si aucun avatar sauvegardé
- [ ] Écran affiche 4 avatars en galerie (2x2 grid ou carrousel)
- [ ] Chaque avatar montre: image preview (fresh), nom, description personnalité
- [ ] Utilisateur peut taper avatar pour sélection (highlight visuel)
- [ ] Bouton "Confirmer" sauvegarde via AvatarRepository
- [ ] Navigation vers HomeScreen après confirmation
- [ ] Lancements suivants skip sélection et chargent avatar sauvegardé
- [ ] Widget test valide flow sélection + navigation

### Flows Utilisateur End-to-End
- [ ] **Flow nouveau user:** Install app → Voir sélection avatar → Choisir avatar → Voir HomeScreen avec avatar fresh
- [ ] **Flow déshydratation:** Avatar fresh → Attendre 2h → Avatar tired → Attendre 2h → Avatar dehydrated → Attendre 2h → Avatar dead → Ghost
- [ ] **Flow résurrection:** Avatar ghost → Attendre minuit → Avatar fresh (auto-résurrection)
- [ ] **Flow persistence:** Sélectionner avatar → Tuer app → Relancer app → Avatar sauvegardé chargé correctement

---

## 🚀 VALIDATION NON-FONCTIONNELLE (NFR)

### Performance
- [ ] App launch time: < 2s (mesuré sur iPhone 8 / Pixel 4)
- [ ] Screen transition HomeScreen ↔ AvatarSelection: < 300ms
- [ ] Database query getAvatarState(): < 50ms
- [ ] Memory usage app idle: < 100MB (baseline iOS/Android)
- [ ] Battery drain avec timer 30min: < 2% par heure (test 4h)

### Accessibilité (WCAG AA)
- [ ] Contraste texte avatar descriptions: ≥4.5:1
- [ ] Bouton "Confirmer" sélection avatar: ≥44x44px
- [ ] Labels VoiceOver/TalkBack présents sur avatars (ex: "Mère Autoritaire - Avatar sélectionnable")
- [ ] Navigation clavier fonctionnelle (focus states visibles)
- [ ] Textes alternatifs présents pour toutes images avatars

### Offline-First
- [ ] App fonctionne 100% offline (aucune connexion réseau requise pour Epic 1)
- [ ] Avatar sélectionné persiste localement (SQLite + shared_preferences)
- [ ] États avatar sauvegardés localement avec timestamps UTC
- [ ] Aucun crash si Firebase inaccessible

### Sécurité
- [ ] Aucune donnée sensible loggée en console (pas de PII)
- [ ] Firebase Security Rules configurées (même si non utilisé Epic 1)
- [ ] Permissions minimales demandées (aucune pour Epic 1)

### Tests
- [ ] Coverage global Epic 1: ≥80%
  - [ ] Domain layer (use cases, entities): ≥90%
  - [ ] Data layer (repositories, models): ≥80%
  - [ ] Presentation layer (screens, widgets): ≥70%
- [ ] Tests unitaires passent: `flutter test` 100% green
- [ ] Tests widgets passent (AvatarDisplay, HomeScreen, AvatarSelectionScreen)
- [ ] Tests intégration passent (persistence avatar, déshydratation flow)
- [ ] CI/CD pipeline green (GitHub Actions)

---

## 🏗️ VALIDATION ARCHITECTURE

### Clean Architecture
- [ ] Structure dossiers respecte conventions:
  - lib/core/ (constants, theme, utils, di)
  - lib/data/ (models, repositories impl, data_sources)
  - lib/domain/ (entities, repositories interfaces, use_cases)
  - lib/presentation/ (screens, widgets, providers)
- [ ] Aucune dépendance circulaire (domain ne dépend PAS de data/presentation)
- [ ] Use cases testés unitairement avec repositories mockés
- [ ] Repositories implémentent interfaces définies dans domain/
- [ ] Entities Avatar dans domain/entities/ uniquement (pas de duplication)

### Code Quality
- [ ] `flutter analyze`: 0 errors, 0 warnings
- [ ] `dart format .`: code formaté selon conventions Flutter
- [ ] Conventions nommage respectées:
  - Classes: PascalCase (Avatar, AvatarRepository)
  - Variables/methods: camelCase (currentState, updateAvatarState)
  - Constantes: kPrefixCamelCase (kAvatarStateTransitionDuration)
  - Fichiers: snake_case (avatar_repository.dart)
- [ ] Commentaires dartdoc présents pour toutes classes/méthodes publiques
- [ ] Pas de code commenté/mort (dead code)
- [ ] Pas de TODOs non-documentés (si TODO → créer story)
- [ ] Constants utilisées (pas de magic numbers/strings hardcodés)

### State Management (Riverpod)
- [ ] Providers définis correctement (AvatarStateNotifier, HomeProvider)
- [ ] State immutable (état avatar ne mute pas directement)
- [ ] Pas de setState() dans widgets (utiliser Riverpod providers)
- [ ] Loading/Error states gérés (ex: loading avatar depuis DB)

---

## 📚 VALIDATION DOCUMENTATION

### Code Documentation
- [ ] README.md contient:
  - Instructions setup Flutter (version requise: stable)
  - Instructions Firebase config (iOS + Android)
  - Commandes build (flutter run, flutter test)
  - Structure projet expliquée
- [ ] Commentaires dartdoc pour:
  - Avatar, AvatarState, AvatarPersonality (entities)
  - AvatarRepository interface + implementation
  - UpdateAvatarStateUseCase
- [ ] Data models documentés (toJson/fromJson expliqués)

### Project Documentation
- [ ] docs/architecture.md à jour avec structure Epic 1
- [ ] Changelog maintenu:
  - [EPIC-1.1] Initialize Flutter project with Clean Architecture
  - [EPIC-1.2] Create Avatar models and entities
  - ... (toutes stories documentées)

---

## 🎨 VALIDATION UI/UX

### Design System
- [ ] Couleurs respectent palette définie:
  - Primary: Bleu hydratation (#2196F3 ou similaire)
  - Background: Blanc/Gris clair
  - Avatar states: couleurs distinctes (fresh=vert, tired=jaune, dehydrated=orange, dead=rouge, ghost=gris)
- [ ] Typographie:
  - Font: System default (Roboto Android, San Francisco iOS)
  - Tailles: Headers 24sp, Body 16sp, Captions 12sp
- [ ] Spacing système 8px grid respecté (padding 8, 16, 24, 32px)
- [ ] Composants réutilisables utilisés (AvatarDisplay widget)

### Avatars
- [ ] 4 avatars visuellement distincts et reconnaissables
- [ ] Transitions états fluides (si animations: 300-500ms)
- [ ] États clairement différenciés visuellement:
  - Fresh: Souriant, couleurs vives
  - Tired: Yeux fatigués, couleurs atténuées
  - Dehydrated: Aspect desséché, couleurs ternes
  - Dead: Effondré/skull, couleurs sombres
  - Ghost: Transparent/spectral, effet glow

### Responsive
- [ ] Testé sur petits écrans (iPhone SE: 375x667)
- [ ] Testé sur écrans moyens (iPhone 13: 390x844)
- [ ] Testé sur grands écrans (iPad: 1024x768)
- [ ] Orientations portrait ET landscape fonctionnelles (layout s'adapte)
- [ ] Pas d'overflow horizontal/vertical

---

## 🐛 VALIDATION STABILITÉ

### Crash-Free
- [ ] Aucun crash reproductible sur iOS simulateur
- [ ] Aucun crash reproductible sur Android émulateur
- [ ] Edge cases gérés:
  - Avatar non sélectionné (nouveau user) → Affiche sélection
  - SQLite DB vide → Crée tables automatiquement
  - Timestamp corrompu → Fallback vers DateTime.now()
  - Timer background interrompu → Redémarre à réouverture app
- [ ] App ne freeze pas pendant:
  - Chargement avatar depuis DB (async)
  - Calcul état déshydratation (use case)
  - Transitions écrans

### Regression Testing
- [ ] Pas de régression (Epic 1 est le premier, donc N/A)
- [ ] Tous tests existants passent (CI green)

---

## 📊 CRITÈRES DE PASSAGE

**Pour que cet Epic PASSE le QA Gate:**

- ✅ **100% Validation Fonctionnelle** (8/8 stories OK, tous AC remplis)
- ✅ **95% Validation NFR** (max 1-2 items mineurs en warning)
- ✅ **100% Validation Architecture** (Clean Arch stricte, 0 dépendance circulaire)
- ✅ **Tests Coverage ≥80%** (Domain 90%, Data 80%, Presentation 70%)
- ✅ **Stabilité: 0 crash critique** (tests manuels iOS + Android)
- ✅ **Build iOS + Android OK** (pas d'erreur compilation)
- ✅ **CI/CD pipeline green** (GitHub Actions 100% pass)

**Si 1 item CRITIQUE échoue → Epic FAILED, retour @dev**

---

## 🔴 BLOCKERS IDENTIFIÉS

*Liste des blockers critiques empêchant validation (à remplir pendant review):*

1. N/A (à compléter lors de la review)

---

## 🟡 WARNINGS (Non-Bloquants)

*Liste des warnings mineurs à adresser en V2 (à remplir pendant review):*

1. N/A (à compléter lors de la review)

---

## ✅ VALIDATION FINALE

**Validé par:** _________________
**Date validation:** _________________
**Status final:** ⬜ PASSED / ⬜ FAILED / ⬜ PASSED WITH WARNINGS

**Notes QA:**
_______________________________________________________________________
_______________________________________________________________________
_______________________________________________________________________

**Métriques Mesurées:**
- App launch time: _______ ms
- Coverage global: _______ %
- Crashes détectés: _______
- Build iOS: ✅ / ❌
- Build Android: ✅ / ❌

---

**Prochaine étape:** Epic 2 - Onboarding & Personnalisation

---

*QA Gate créé le 2026-01-07 - Epic 1 Foundation & Avatar Core System*
