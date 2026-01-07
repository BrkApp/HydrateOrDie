# QA Gate - Epic 4: Système de Notifications Punitives

**Version:** 1.0
**Date:** 2026-01-07
**Status:** 🔴 Not Started

---

## 📋 Vue d'Ensemble

**Epic:** 4 - Système de Notifications Punitives
**Objectif:** Développer l'escalade progressive des notifications sur 4 niveaux (calme → préoccupé → mélodramatique → spam chaos), implémenter le spam aléatoire intelligent, créer messages personnalisés par avatar avec vulgarité censurée et humour absurde, et ajouter vibrations agaçantes.
**Stories:** 4.1 à 4.11 (11 stories)
**Criticité:** HIGH (Mécanique engagement clé - différenciateur produit)

---

## ✅ VALIDATION FONCTIONNELLE

### Features Principales
- [ ] Système escalade 4 niveaux fonctionne: Calm (0-2h) → Concerned (2-4h) → Dramatic (4-6h) → Chaos (6h+)
- [ ] Fréquence notifications adaptée par niveau: Calm (1h), Concerned (30min), Dramatic (15min), Chaos (5-10min random)
- [ ] Messages personnalisés par avatar ET niveau (4 avatars × 4 niveaux = 16 pools)
- [ ] Notifications arrivent en background (app fermée)
- [ ] Vibrations pattern agaçant en mode Chaos uniquement
- [ ] Pause automatique nocturne (22h-7h par défaut, configurable)
- [ ] Permissions notifications gérées gracieusement
- [ ] Écran paramètres notifications (toggle on/off, vibrations, heures pause)
- [ ] Analytics notifications trackées (sent, opened, level)
- [ ] Background job update niveau escalade périodiquement (15min)

### User Stories Acceptance Criteria

#### Story 4.1: Modèle NotificationState
- [ ] Classe NotificationState: currentLevel, lastNotificationTime, notificationsSentToday, userLastDrinkTime
- [ ] Enum NotificationLevel: calm, concerned, dramatic, chaos
- [ ] Méthode shouldEscalate() retourne bool basé sur temps écoulé
- [ ] Méthode getNextLevel() pour progression niveau
- [ ] Méthode reset() réinitialise à calm
- [ ] Méthodes toJson/fromJson fonctionnelles
- [ ] Tests unitaires coverage 100%

#### Story 4.2: Algorithme Escalade
- [ ] CalculateNotificationLevelUseCase détermine niveau basé sur temps depuis lastDrinkTime
- [ ] Progression: Calm (0-2h), Concerned (2-4h), Dramatic (4-6h), Chaos (6h+)
- [ ] Fréquences: Calm (1x/heure), Concerned (1x/30min), Dramatic (1x/15min), Chaos (5-10min aléatoire)
- [ ] Niveau ne redescend pas sans action utilisateur (escalade unidirectionnelle)
- [ ] Reset automatique à minuit (nouveau jour = calm)
- [ ] Calcul prend lastDrinkTime depuis AvatarRepository
- [ ] Tests unitaires progression tous scénarios (0h, 1h, 3h, 5h, 7h)
- [ ] Tests valident niveau ne redescend pas sans hydratation

#### Story 4.3: Repository NotificationState
- [ ] NotificationStateRepository implémente: saveState, getState, resetState, incrementNotificationCount
- [ ] Utilise shared_preferences pour état notification
- [ ] getState() retourne état par défaut (calm, 0 notifs) si nouveau jour
- [ ] resetState() réinitialise niveau calm + count 0
- [ ] Détection automatique changement jour → reset
- [ ] Tests unitaires CRUD + détection changement jour

#### Story 4.4: Messages Personnalisés
- [ ] NotificationMessageProvider génère messages basés sur AvatarPersonality + NotificationLevel
- [ ] 16 combinaisons (4 avatars × 4 niveaux) ont pool 5-10 messages variés
- [ ] **Mère Autoritaire:** Calm "Mon chéri, pense à boire 💧", Chaos "P*T@IN MAIS BOIS !!! 😤"
- [ ] **Coach Sportif:** Calm "Hydrate-toi champion ! 💪", Chaos "BOUUUUGE-TOI !!! 🔥"
- [ ] **Docteur:** Calm "Je vous recommande de vous hydrater.", Chaos "CODE ROUGE ! H2O STAT !!! 🚨"
- [ ] **Ami Sarcastique:** Calm "Yo, tu devrais boire", Chaos "BORDEL BOIS OU JE DÉMISSIONNE !!! 😡"
- [ ] Messages incluent emojis, vulgarité censurée (p*t@in, b*rd*l), références pop culture
- [ ] Méthode getRandomMessage(personality, level) retourne message aléatoire du pool
- [ ] Tests unitaires valident message existe pour chaque combinaison + bon ton

#### Story 4.5: Scheduling Notifications
- [ ] ScheduleNotificationUseCase utilise flutter_local_notifications
- [ ] Intervalles basés niveau: Calm (1h), Concerned (30min), Dramatic (15min), Chaos (random 5-10min)
- [ ] Titre notification: nom avatar (ex: "Maman dit :", "Coach Mike :")
- [ ] Body: message généré par NotificationMessageProvider
- [ ] Icon custom: goutte d'eau ou avatar icon
- [ ] Mode Chaos: intervalle aléatoire Random().nextInt(300) + 300 secondes (5-10min)
- [ ] Notifications annulées et re-schedulées après hydratation validée
- [ ] Tests unitaires logique scheduling chaque niveau
- [ ] Tests intégration notifications apparaissent réellement

#### Story 4.6: Vibrations Chaos
- [ ] En niveau chaos: notifications déclenchent pattern vibration custom
- [ ] Pattern: [0, 300, 100, 300, 100, 500] (pause, vibrate, pause, vibrate, long vibrate)
- [ ] Vibrations UNIQUEMENT en chaos (pas calm, concerned, dramatic)
- [ ] Toggle "Vibrations actives" dans paramètres (désactivable)
- [ ] Désactivation sauvegardée shared_preferences
- [ ] Tests unitaires pattern appliqué uniquement chaos
- [ ] Test manuel device réel: vibrations agaçantes mais pas excessives

#### Story 4.7: Pause Nocturne
- [ ] Notifications bloquées entre 22h00-7h00 (heure locale par défaut)
- [ ] Horaires configurables: "Heure début pause", "Heure fin pause" (time pickers)
- [ ] Paramètres sauvegardés shared_preferences
- [ ] ScheduleNotificationUseCase vérifie heure avant scheduler
- [ ] Si dans pause: notification reportée fin pause (7h00 par défaut)
- [ ] Message paramètres: "Notifications en pause pendant tes heures de sommeil"
- [ ] Tests unitaires notifications bloquées pendant pause
- [ ] Tests notifications reprennent après fin pause

#### Story 4.8: Gestion Permissions
- [ ] Permission notifications demandée au premier lancement post-onboarding
- [ ] Si accordée: notifications fonctionnent normalement
- [ ] Si refusée: banner persistant HomeScreen "Active les notifications 🔔" + bouton "Activer"
- [ ] Bouton "Activer" ouvre openAppSettings() → settings système
- [ ] Statut permission vérifié à chaque ouverture app
- [ ] Banner disparaît si permission accordée après refus
- [ ] Toggle paramètres "Mettre en pause notifications" (pause temporaire sans désactiver système)
- [ ] Tests unitaires logique demande + vérification
- [ ] Widget test banner + bouton

#### Story 4.9: Background Job Escalade
- [ ] Timer.periodic 15min vérifie temps écoulé depuis lastDrinkTime
- [ ] Timer appelle CalculateNotificationLevelUseCase recalculer niveau
- [ ] Si niveau changé (escalade): notifications annulées + re-schedulées nouvelle fréquence
- [ ] Timer initialisé app launch, tourne background
- [ ] Timer annulé proprement fermeture app (cleanup)
- [ ] Niveau mis à jour sauvegardé NotificationStateRepository
- [ ] Tests unitaires logique timer + re-scheduling
- [ ] Test intégration timer fonctionne réellement background

#### Story 4.10: Analytics Notifications
- [ ] Event analytics notification_sent (props: level, personality, timeSinceLastDrink)
- [ ] Event notification_opened (props: level, personality)
- [ ] Event dismiss notification trackable
- [ ] Event daily_notification_summary (props: totalSent, maxLevelReached, notificationsThatTriggeredHydration)
- [ ] Analytics Firebase Analytics (anonymisées)
- [ ] Tests unitaires events loggés bons moments

#### Story 4.11: Écran Paramètres
- [ ] NotificationSettingsScreen accessible depuis menu paramètres
- [ ] Options configurables:
  - Toggle "Notifications actives" (on/off global)
  - Toggle "Vibrations actives" (on/off chaos)
  - Time Picker "Heure début pause" (défaut 22h00)
  - Time Picker "Heure fin pause" (défaut 7h00)
  - Info text: "Niveau escalade s'adapte automatiquement"
- [ ] Modifications sauvegardées immédiatement shared_preferences
- [ ] Changements appliqués immédiatement (re-schedule notifications si nécessaire)
- [ ] Widget test affichage + sauvegarde paramètres

### Flows Utilisateur End-to-End
- [ ] **Flow escalade complet:** Dernière hydratation → Attendre 1h → Notif Calm → Attendre 1h → Notif Concerned → Attendre 2h → Notifs Dramatic (15min) → Attendre 2h → Notifs Chaos (random 5-10min, vibrations)
- [ ] **Flow reset après hydratation:** En mode Dramatic → Valider hydratation (Epic 3) → Niveau reset Calm → Notifications fréquence 1h
- [ ] **Flow pause nocturne:** 21h50 → Notifications normales → 22h00 → Notifications stoppent → 7h00 → Notifications reprennent
- [ ] **Flow permission refusée:** Refuser permission → Banner HomeScreen → "Activer" → Settings → Autoriser → Retour app → Banner disparu → Notifications fonctionnent

---

## 🚀 VALIDATION NON-FONCTIONNELLE (NFR)

### Performance
- [ ] Calcul niveau notification (use case): < 50ms
- [ ] Scheduling notification (flutter_local_notifications): < 100ms
- [ ] Background timer (15min check): < 200ms CPU burst
- [ ] Memory usage timer background: < 5MB overhead

### Battery Drain
- [ ] Battery drain notifications actives (24h test): < 5% par jour
- [ ] Background timer 15min: < 2% par jour
- [ ] Mode Chaos (max spam 10min): < 8% par jour
- [ ] **CRITIQUE:** Battery drain acceptable malgré notifications fréquentes

### Notifications Background
- [ ] Notifications arrivent avec app fermée (background/killed)
- [ ] Notifications arrivent même après reboot device (scheduled persistent)
- [ ] Tap notification ouvre app HomeScreen
- [ ] Dismiss notification ne crash pas app

### Vibrations
- [ ] Pattern vibration perceptible mais pas excessif (test utilisateur)
- [ ] Vibrations respectent settings device (Do Not Disturb mode)
- [ ] Aucune vibration si toggle désactivé (paramètres)

### Accessibilité (WCAG AA)
- [ ] Notifications lisibles (texte clair, pas seulement emojis)
- [ ] Titre + body présents (pas seulement titre)
- [ ] Messages accessibles screen readers (TalkBack/VoiceOver)

### Offline-First
- [ ] Notifications fonctionnent 100% offline (locales)
- [ ] État notification persisté localement (shared_preferences)
- [ ] Aucun besoin réseau pour système notifications

### Sécurité & RGPD
- [ ] Aucune donnée personnelle dans notifications (pas de PII)
- [ ] Analytics anonymisées (Firebase)
- [ ] User peut désactiver notifications (toggle paramètres)

### Tests
- [ ] Coverage global Epic 4: ≥80%
  - [ ] Domain layer (CalculateNotificationLevelUseCase, ScheduleNotificationUseCase): ≥90%
  - [ ] Data layer (NotificationStateRepository, MessageProvider): ≥80%
  - [ ] Presentation layer (NotificationSettingsScreen): ≥70%
- [ ] Tests unitaires passent (focus: logique escalade, messages)
- [ ] Tests intégration passent (notifications réelles, timer background)

---

## 🏗️ VALIDATION ARCHITECTURE

### Clean Architecture
- [ ] Structure respectée:
  - domain/entities/notification_state.dart
  - domain/use_cases/calculate_notification_level_use_case.dart
  - domain/use_cases/schedule_notification_use_case.dart
  - data/models/notification_state_model.dart
  - core/services/notification_service.dart
  - presentation/screens/settings/notification_settings_screen.dart
- [ ] Use cases testés en isolation (repositories mockés)
- [ ] NotificationService abstrait (interface)

### Code Quality
- [ ] `flutter analyze`: 0 errors, 0 warnings
- [ ] `dart format .`: code formaté
- [ ] Messages notifications externalisés (pas hardcodés inline)
- [ ] Constants: kCalmInterval = Duration(hours: 1), kChaosMinInterval = 300 (secondes)
- [ ] Dartdoc pour CalculateNotificationLevelUseCase (algorithme escalade expliqué)
- [ ] Gestion erreurs scheduling (permission denied, etc.)

### State Management (Riverpod)
- [ ] NotificationProvider gère état actuel (niveau, dernière notif)
- [ ] State mis à jour réactivement après hydratation
- [ ] Settings notifications sauvegardées immédiatement

---

## 📚 VALIDATION DOCUMENTATION

### Code Documentation
- [ ] Algorithme escalade documenté (thresholds temps, fréquences)
- [ ] Messages notifications documentés (16 combinaisons)
- [ ] Pattern vibration documenté
- [ ] Pause nocturne logic documentée

### Project Documentation
- [ ] README.md: permissions notifications requises
- [ ] Changelog maintenu pour toutes stories Epic 4
- [ ] docs/architecture.md: notification system architecture ajoutée

---

## 🎨 VALIDATION UI/UX

### Design Notifications
- [ ] Titre notifications court et clair (max 40 caractères)
- [ ] Body notifications lisible (max 100 caractères)
- [ ] Emojis utilisés mais pas excessifs (1-3 par message)
- [ ] Ton escalade perceptible: Calm (doux) → Chaos (caps lock, multiple emojis)

### Écran Paramètres
- [ ] Toggles Material Design standard
- [ ] Time pickers Material Design (AM/PM ou 24h selon locale)
- [ ] Info text explicatifs pour chaque paramètre
- [ ] Layout clair et organisé (sections)

### Messages Tonalité
- [ ] Messages Calm: bienveillants, encourageants
- [ ] Messages Concerned: légèrement inquiets, insistants
- [ ] Messages Dramatic: mélodramatiques, caps lock partiels, multiples emojis
- [ ] Messages Chaos: CAPS LOCK MAJORITAIRE, vulgarité censurée, emojis excessifs, absurde
- [ ] Ton cohérent avec personnalité avatar (Mère ≠ Coach ≠ Docteur ≠ Ami)

---

## 🐛 VALIDATION STABILITÉ

### Crash-Free
- [ ] Aucun crash si permission notifications refusée
- [ ] Aucun crash si notification tapped avec app killed
- [ ] Edge cases gérés:
  - Timer background app killed → Redémarre à réouverture
  - Notifications schedulées > limite OS (64 iOS) → Gestion queue
  - Changement timezone → Pause nocturne ajustée
  - Changement heure système (daylight saving) → Logique robuste

### Regression Testing
- [ ] Epics 1-3 toujours fonctionnels:
  - Validation photo reset niveau notification (Calm)
  - Avatar état fonctionne
  - Onboarding fonctionne
- [ ] Flows critiques validés end-to-end

---

## 📊 CRITÈRES DE PASSAGE

**Pour que cet Epic PASSE le QA Gate:**

- ✅ **100% Validation Fonctionnelle** (11/11 stories OK, escalade fonctionne correctement)
- ✅ **95% Validation NFR** (battery drain <5%/jour, notifications arrivent background)
- ✅ **100% Validation Architecture** (Clean Arch, notification service abstrait)
- ✅ **Tests Coverage ≥80%** (use cases escalade + scheduling ≥90%)
- ✅ **Stabilité: 0 crash critique** (permissions, background gérés)
- ✅ **Messages adaptés par avatar et mémorables** (review qualité messages)

**Si 1 item CRITIQUE échoue → Epic FAILED, retour @dev**

**Items CRITIQUES pour Epic 4:**
- Escalade progressive fonctionne (Calm → Chaos mesurable)
- Notifications arrivent en background (app fermée)
- Battery drain acceptable (<5% par jour mode normal, <8% mode Chaos)
- Messages personnalisés par avatar et niveau (16 pools complets)
- Pause nocturne fonctionne (aucune notif 22h-7h)

---

## 🔴 BLOCKERS IDENTIFIÉS

*Liste des blockers critiques empêchant validation:*

1. N/A (à compléter lors de la review)

---

## 🟡 WARNINGS (Non-Bloquants)

*Liste des warnings mineurs à adresser en V2:*

1. N/A (à compléter lors de la review)

---

## ✅ VALIDATION FINALE

**Validé par:** _________________
**Date validation:** _________________
**Status final:** ⬜ PASSED / ⬜ FAILED / ⬜ PASSED WITH WARNINGS

**Notes QA:**
_______________________________________________________________________
_______________________________________________________________________

**Métriques Mesurées:**
- Battery drain 24h (mode normal): _______ %
- Battery drain 24h (mode Chaos): _______ %
- Notifications reçues background: ✅ / ❌
- Escalade progressive observée: ✅ / ❌
- Coverage global Epic 4: _______ %

**Test Escalade (sur 8h):**
- 0-2h Calm (1x/heure): _______ notifs reçues
- 2-4h Concerned (1x/30min): _______ notifs reçues
- 4-6h Dramatic (1x/15min): _______ notifs reçues
- 6-8h Chaos (5-10min random): _______ notifs reçues

**Qualité Messages:**
- Messages Mère Autoritaire: ⬜ Mémorables / ⬜ Génériques
- Messages Coach Sportif: ⬜ Mémorables / ⬜ Génériques
- Messages Docteur: ⬜ Mémorables / ⬜ Génériques
- Messages Ami Sarcastique: ⬜ Mémorables / ⬜ Génériques

---

**Prochaine étape:** Epic 5 - Progression & Rétention (Streaks & Historique)

---

*QA Gate créé le 2026-01-07 - Epic 4 Système de Notifications Punitives*
