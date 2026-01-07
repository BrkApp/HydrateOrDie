# QA Gate - Epic 5: Progression & Rétention (Streaks & Historique)

**Version:** 1.0
**Date:** 2026-01-07
**Status:** 🔴 Not Started

---

## 📋 Vue d'Ensemble

**Epic:** 5 - Progression & Rétention (Streaks & Historique)
**Objectif:** Créer le système de streaks Duolingo-style avec compteur de jours consécutifs, implémenter le calendrier historique affichant les jours atteints/ratés, et développer un écran de profil/paramètres minimaliste pour configurer l'app et supprimer données (RGPD).
**Stories:** 5.1 à 5.12 (12 stories)
**Criticité:** MEDIUM (Rétention long-terme - complète MVP)

---

## ✅ VALIDATION FONCTIONNELLE

### Features Principales
- [ ] Système streaks fonctionne: incrémente si objectif atteint, break si raté
- [ ] Compteur streak affiché sur HomeScreen (🔥 X jours)
- [ ] Calendrier historique affiche jours ✓ (objectif atteint) / ✗ (raté)
- [ ] Navigation calendrier mois par mois fonctionnelle
- [ ] Écran profil avec stats: streak actuel, streak max, jours atteints mois, volume total mois
- [ ] Écran paramètres: modifier profil, changer avatar, notifications, supprimer compte
- [ ] Modification profil recalcule objectif hydratation
- [ ] Changement avatar post-onboarding fonctionne (ne reset pas streak)
- [ ] Suppression compte et données fonctionne (RGPD compliance)
- [ ] Bottom navigation bar (Home, Calendrier, Profil)
- [ ] Achievements simples (optionnel MVP): Premier verre, Streak 7j, Streak 30j

### User Stories Acceptance Criteria

#### Story 5.1: Modèle StreakData
- [ ] Classe StreakData: currentStreak, longestStreak, lastStreakDate, streakActive
- [ ] Méthode incrementStreak(date) incrémente si date = hier + 1 jour
- [ ] Méthode breakStreak() reset currentStreak à 0
- [ ] Méthode isStreakActiveToday() retourne bool
- [ ] Met à jour longestStreak si currentStreak > longestStreak
- [ ] Méthodes toJson/fromJson fonctionnelles
- [ ] Tests unitaires coverage 100% (increment, break, longest update)

#### Story 5.2: Logique Calcul Streak
- [ ] UpdateStreakUseCase appelé à minuit (00h00) chaque jour via background job
- [ ] Vérifie si objectif veille atteint via HydrationLogRepository.getTotalVolumeForDate(yesterday)
- [ ] Si objectif atteint: incrementStreak(yesterday)
- [ ] Si objectif raté: breakStreak()
- [ ] Vérifié également à ouverture app (catch-up si app pas ouverte minuit)
- [ ] Si avatar mort veille (ghost): streak NE s'incrémente PAS (pénalité)
- [ ] Tests unitaires tous scénarios: atteint, raté, mort, plusieurs jours consécutifs

#### Story 5.3: Repository Streak
- [ ] StreakRepository implémente: saveStreak, getStreak, resetStreak
- [ ] Utilise shared_preferences
- [ ] getStreak() retourne streak par défaut (0 jours) si nouveau user
- [ ] Tests unitaires CRUD complet

#### Story 5.4: Affichage Streak HomeScreen
- [ ] HomeScreen affiche widget StreakDisplay en header
- [ ] Widget affiche: 🔥 + nombre jours + "jour(s) de suite"
- [ ] Si currentStreak = 0: "Commence ton streak aujourd'hui ! 🔥"
- [ ] Si currentStreak ≥ 7: double flame 🔥🔥
- [ ] Si currentStreak ≥ 30: trophée 🏆
- [ ] Widget tapable → modal affiche currentStreak, longestStreak, message motivant
- [ ] Widget test valide affichage pour 0, 5, 10, 30 jours

#### Story 5.5: Modèle Calendrier
- [ ] Classe DayStatus: date, goalAchieved, volumeDrank, goalVolume
- [ ] Méthode helper getMonthStatus(year, month) retourne liste DayStatus tous jours mois
- [ ] Interroge HydrationLogRepository pour volume par jour
- [ ] Compare volumeDrank vs goalVolume (UserProfile) pour goalAchieved
- [ ] Jours futurs: goalAchieved = null
- [ ] Tests unitaires calcul mois complet avec scénarios variés

#### Story 5.6: Écran Calendrier
- [ ] CalendarScreen accessible via navigation ou HomeScreen
- [ ] Affiche calendrier mensuel (vue mois)
- [ ] Chaque jour: ✓ (vert) si atteint, ✗ (rouge) si raté, vide si futur/pas de données
- [ ] Jour actuel highlight (border distinct)
- [ ] Flèches navigation mois précédent/suivant
- [ ] Tap jour passé → modal détails: date, volume bu, objectif, pourcentage
- [ ] Résumé mensuel bas écran: "15/30 jours objectif atteint" + pourcentage
- [ ] Widget test affichage calendrier + navigation mois
- [ ] Widget test symboles ✓/✗ selon données

#### Story 5.7: Stats Profil
- [ ] ProfileScreen accessible via bottom nav
- [ ] Affiche en haut: avatar actuel, nom personnalité, bouton "Changer d'avatar"
- [ ] Section "Mes Statistiques":
  - Streak actuel: X jours 🔥
  - Streak le plus long: X jours 🏆
  - Jours objectif atteint ce mois: X/30
  - Volume total bu ce mois: X.XL
- [ ] Stats calculées temps réel à ouverture écran
- [ ] Bouton "Voir calendrier complet" navigue CalendarScreen
- [ ] Widget test affichage toutes stats

#### Story 5.8: Écran Paramètres
- [ ] SettingsScreen accessible depuis ProfileScreen ou menu
- [ ] Sections:
  - **Profil:** Modifier poids, âge, activité
  - **Notifications:** Lien NotificationSettingsScreen (Epic 4)
  - **Avatar:** Bouton "Changer d'avatar"
  - **Objectif:** Affichage objectif actuel + "Recalculer" (si profil modifié)
  - **Données:** Bouton "Supprimer mon compte et mes données"
  - **À propos:** Version app, liens Privacy Policy, Terms
- [ ] Modifications sauvegardées immédiatement
- [ ] Bouton "Supprimer compte" → confirmation: "Es-tu sûr ? Toutes données supprimées définitivement."
- [ ] Si confirmé: suppression ALL données (profil, avatar, logs, photos, streaks) via repositories
- [ ] Après suppression: retour onboarding (clean slate)
- [ ] Widget test affichage + navigation
- [ ] Test intégration suppression complète données

#### Story 5.9: Modification Profil
- [ ] EditProfileScreen accessible depuis SettingsScreen
- [ ] Champs éditables: Poids, Âge, Sexe, Niveau activité
- [ ] Champs pré-remplis valeurs actuelles
- [ ] Validations identiques onboarding (ranges valides)
- [ ] Bouton "Enregistrer" sauvegarde via UserProfileRepository.updateProfile()
- [ ] Objectif hydratation recalculé automatiquement via CalculateHydrationGoalUseCase
- [ ] Message confirmation: "Profil mis à jour ! Nouvel objectif : X.XL/jour"
- [ ] Widget test édition + sauvegarde

#### Story 5.10: Changement Avatar
- [ ] ChangeAvatarScreen accessible depuis ProfileScreen/SettingsScreen
- [ ] Réutilise AvatarSelectionScreen (Epic 1)
- [ ] Avatar actuel highlight visuellement
- [ ] Tap nouvel avatar + confirmer → sauvegarde via AvatarRepository
- [ ] Avatar change immédiatement HomeScreen
- [ ] **IMPORTANT:** Changer avatar ne reset PAS streak ni historique
- [ ] Message confirmation: "[Nom avatar] est maintenant ton compagnon !"
- [ ] Widget test flow changement + sauvegarde

#### Story 5.11: Achievements (Optionnel)
- [ ] Si inclus MVP: Modèle Achievement: id, title, description, icon, unlocked, unlockedDate
- [ ] Achievements disponibles:
  - "Premier verre": Valider première hydratation
  - "Streak 7 jours": Atteindre 7 jours consécutifs
  - "Streak 30 jours": Atteindre 30 jours consécutifs
  - "Objectif parfait": Atteindre exactement 100% objectif
  - "Sauveur d'avatar": Ressusciter avatar mort
- [ ] Achievements vérifiés automatiquement après actions clés
- [ ] Achievement débloqué: modal célébration + animation
- [ ] AchievementsScreen liste tous achievements (locked/unlocked)
- [ ] Widget test affichage + système déblocage
- [ ] **Note:** Story OPTIONNELLE MVP - peut être V2 si complexité trop haute

#### Story 5.12: Bottom Navigation
- [ ] BottomNavigationBar présente tous écrans principaux
- [ ] Tabs: "Home" (🏠), "Calendrier" (📅), "Profil" (👤)
- [ ] Tab actif highlight visuellement
- [ ] Tap tab navigue écran correspondant
- [ ] Navigation préserve état écrans (pas de reload)
- [ ] Widget test navigation 3 tabs

### Flows Utilisateur End-to-End
- [ ] **Flow streak complet:** Jour 1 objectif atteint → Minuit → Streak incrémente 1 jour → Jour 2 objectif atteint → Streak 2 jours → Jour 3 objectif raté → Streak break 0 jours
- [ ] **Flow calendrier:** Ouvrir calendrier → Naviguer mois précédent → Voir jours ✓/✗ → Tap jour passé → Modal détails correct
- [ ] **Flow modification profil:** Paramètres → Modifier profil → Changer poids 75kg → 80kg → Enregistrer → Objectif recalculé 2.5L → 2.6L
- [ ] **Flow changement avatar:** Profil → Changer avatar → Sélectionner nouveau → Confirmer → HomeScreen affiche nouvel avatar → Streak inchangé
- [ ] **Flow suppression compte:** Paramètres → Supprimer compte → Confirmation → Toutes données supprimées → Retour onboarding

---

## 🚀 VALIDATION NON-FONCTIONNELLE (NFR)

### Performance
- [ ] Calcul streak quotidien (UpdateStreakUseCase): < 100ms
- [ ] Chargement calendrier mois (30 jours): < 200ms
- [ ] Calcul stats profil (4 métriques): < 150ms
- [ ] Navigation entre tabs bottom nav: < 200ms
- [ ] Suppression compte et données: < 2 secondes

### Performance Calendrier
- [ ] Affichage calendrier mois actuel: < 100ms
- [ ] Navigation mois précédent/suivant: < 150ms (requête DB + render)
- [ ] Tap jour pour détails: < 50ms (modal appear)
- [ ] Scroll calendrier fluide (60 FPS)

### Accessibilité (WCAG AA)
- [ ] Widget streak: labels VoiceOver clairs ("Streak actuel 5 jours")
- [ ] Calendrier: jours tapables ≥44x44px
- [ ] Symboles ✓/✗ avec couleurs ET formes (pas seulement couleur)
- [ ] Stats profil: hiérarchie texte claire (headers vs values)
- [ ] Bottom nav: labels clairs + icons reconnaissables

### Offline-First
- [ ] Calendrier fonctionne 100% offline (données SQLite)
- [ ] Streak calculé localement (shared_preferences)
- [ ] Stats profil calculées localement
- [ ] Modifications profil sauvegardées localement
- [ ] Sync Firestore background (best effort)

### Sécurité & RGPD
- [ ] **CRITIQUE:** Suppression compte supprime TOUTES données:
  - SQLite: user_profile, avatar_state, hydration_logs, streak_data
  - Shared_preferences: toutes clés app
  - File system: toutes photos hydration_photos/
  - Firestore: document user complet
  - Firebase Storage: photos cloud (si opt-in)
- [ ] Aucune donnée résiduelle après suppression
- [ ] Test RGPD: supprimer compte → réinstaller app → aucune donnée ancienne

### Tests
- [ ] Coverage global Epic 5: ≥80%
  - [ ] Domain layer (UpdateStreakUseCase, GetMonthStatusUseCase): ≥90%
  - [ ] Data layer (StreakRepository, calendar queries): ≥80%
  - [ ] Presentation layer (CalendarScreen, ProfileScreen): ≥70%
- [ ] Tests unitaires passent (focus: logique streak, calcul calendrier)
- [ ] Tests widgets passent (calendrier, profil, paramètres)
- [ ] Tests intégration passent (streak update, suppression données)

---

## 🏗️ VALIDATION ARCHITECTURE

### Clean Architecture
- [ ] Structure respectée:
  - domain/entities/streak.dart, day_status.dart
  - domain/use_cases/update_streak_use_case.dart, get_month_status_use_case.dart
  - data/models/streak_model.dart
  - data/repositories/streak_repository_impl.dart
  - presentation/screens/calendar/, profile/, settings/
- [ ] Use cases testés en isolation
- [ ] Repositories mockés dans tests use cases

### Code Quality
- [ ] `flutter analyze`: 0 errors, 0 warnings
- [ ] `dart format .`: code formaté
- [ ] Logique calendrier commentée (calculs dates complexes)
- [ ] Dartdoc pour UpdateStreakUseCase (logique incrémente/break)
- [ ] Constants: kStreakFlameThreshold = 7, kStreakTrophyThreshold = 30
- [ ] Gestion erreurs suppression données (try-catch, logs)

### State Management (Riverpod)
- [ ] StreakProvider gère état streak réactif
- [ ] CalendarProvider gère état calendrier (mois actuel, cache données)
- [ ] ProfileProvider gère stats profil
- [ ] Loading states gérés (calculs stats, suppression données)

---

## 📚 VALIDATION DOCUMENTATION

### Code Documentation
- [ ] Logique streak documentée (conditions incrémente vs break)
- [ ] Calcul calendrier documenté (getMonthStatus algorithm)
- [ ] Suppression données documentée (RGPD compliance steps)

### Project Documentation
- [ ] README.md: feature streaks + calendrier décrites
- [ ] Changelog maintenu pour toutes stories Epic 5
- [ ] docs/architecture.md: streak & calendar architecture ajoutée

---

## 🎨 VALIDATION UI/UX

### Design System
- [ ] Couleurs cohérentes Epics 1-4
- [ ] Typographie:
  - Streak display: 32sp bold (proéminent)
  - Stats profil: 24sp headers, 20sp values
  - Calendrier: 14sp jours mois

### Widget Streak
- [ ] Flame icon 🔥 visible et reconnaissable
- [ ] Double flame 🔥🔥 ≥7 jours (célébration visuelle)
- [ ] Trophée 🏆 ≥30 jours (achievement visuel)
- [ ] Nombre jours lisible (grande taille, couleur primary)

### Calendrier
- [ ] Layout calendrier clair (grid 7 colonnes = jours semaine)
- [ ] Headers jours semaine (L M M J V S D)
- [ ] Symboles ✓/✗ distincts et visibles
- [ ] Jour actuel highlight (border primary, background subtil)
- [ ] Résumé mensuel visible bas écran (pas caché)

### Écran Profil
- [ ] Avatar affiché prominemment en haut
- [ ] Stats organisées en cards/sections
- [ ] Icons accompagnent stats (🔥 streak, 🏆 longest, ✓ mois)
- [ ] Bouton "Changer avatar" visible mais secondaire

### Bottom Navigation
- [ ] Icons reconnaissables (home, calendar, profile)
- [ ] Labels présents (pas seulement icons)
- [ ] Tab actif: couleur primary, inactifs: gris
- [ ] Hauteur standard (56dp Material Design)

---

## 🐛 VALIDATION STABILITÉ

### Crash-Free
- [ ] Aucun crash si streak = 0 (nouveau user)
- [ ] Aucun crash si calendrier mois vide (aucune hydratation)
- [ ] Aucun crash suppression données (tous repositories gérés)
- [ ] Edge cases gérés:
  - Streak incrémente correctement après 30+ jours (pas de limite)
  - Calendrier fonctionne pour années passées (2024, 2023, etc.)
  - Changement timezone ne casse pas logique streak
  - Modification profil avec valeurs identiques → pas d'erreur

### Regression Testing
- [ ] Epics 1-4 toujours fonctionnels:
  - Avatar fonctionne après changement (Epic 5)
  - Notifications continuent après modification profil
  - Validation photo fonctionne
  - Onboarding fonctionne
- [ ] Flow complet nouveau user → MVP complet fonctionne end-to-end

---

## 📊 CRITÈRES DE PASSAGE

**Pour que cet Epic PASSE le QA Gate:**

- ✅ **100% Validation Fonctionnelle** (12/12 stories OK, streak + calendrier + paramètres complets)
- ✅ **95% Validation NFR** (performance calendrier <200ms, RGPD compliance stricte)
- ✅ **100% Validation Architecture** (Clean Arch)
- ✅ **Tests Coverage ≥80%** (UpdateStreakUseCase ≥90%)
- ✅ **Stabilité: 0 crash critique** (suppression données robuste)
- ✅ **RGPD: Suppression données 100% complète** (vérification forensique)

**Si 1 item CRITIQUE échoue → Epic FAILED, retour @dev**

**Items CRITIQUES pour Epic 5:**
- Logique streak correcte (incrémente/break selon objectif atteint/raté)
- Calendrier affiche correctement ✓/✗ (données historiques précises)
- Suppression compte supprime TOUTES données (RGPD compliance stricte)
- Performance calendrier acceptable (<200ms pour mois)
- Bottom navigation fonctionnelle (3 tabs accessibles)

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
- Calcul streak: _______ ms
- Chargement calendrier mois: _______ ms
- Calcul stats profil: _______ ms
- Suppression données: _______ secondes
- Coverage global Epic 5: _______ %

**Test Streak (sur 7 jours):**
- Jour 1 objectif atteint → Streak: _______ (attendu: 1)
- Jour 2 objectif atteint → Streak: _______ (attendu: 2)
- Jour 3 objectif raté → Streak: _______ (attendu: 0)
- Jour 4 objectif atteint → Streak: _______ (attendu: 1)

**Test RGPD Suppression:**
- SQLite tables supprimées: ✅ / ❌
- SharedPreferences cleared: ✅ / ❌
- Photos locales supprimées: ✅ / ❌
- Firestore user deleted: ✅ / ❌
- Aucune donnée résiduelle: ✅ / ❌

**Test Calendrier:**
- Affichage mois actuel: ✅ / ❌
- Symboles ✓/✗ corrects: ✅ / ❌
- Navigation mois précédent/suivant: ✅ / ❌
- Modal détails jour: ✅ / ❌

---

## 🎉 MVP COMPLET !

**Si cet Epic PASSE, le MVP HydrateOrDie est COMPLET et prêt pour:**

1. **Testing Beta** : Tests utilisateurs réels, feedback collection
2. **App Store Submission** : Préparation assets, soumission iOS/Android
3. **Launch** : Marketing initial, release production

**Métriques Success MVP (Post-Launch):**
- Taux rétention D1: >40%
- Taux rétention D7: >20%
- Taux rétention D30: >15% (objectif clé)
- App Store rating: >4.0/5.0
- Crash-free rate: >99%

---

**Prochaines étapes post-Epic 5:** [MVP Ready for Release](../roadmap.md)

---

*QA Gate créé le 2026-01-07 - Epic 5 Progression & Rétention - FINAL MVP EPIC*
