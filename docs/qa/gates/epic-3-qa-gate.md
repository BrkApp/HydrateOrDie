# QA Gate - Epic 3: Validation Photo & Feedback Positif

**Version:** 1.0
**Date:** 2026-01-07
**Status:** 🔴 Not Started

---

## 📋 Vue d'Ensemble

**Epic:** 3 - Validation Photo & Feedback Positif
**Objectif:** Implémenter la validation par selfie avec interface caméra guidée, stockage local optimisé des photos, et animations de feedback positif de l'avatar après validation. Cœur différenciateur du produit.
**Stories:** 3.1 à 3.10 (10 stories)
**Criticité:** CRITICAL (Mécanique engagement principale)

---

## ✅ VALIDATION FONCTIONNELLE

### Features Principales
- [ ] Bouton "Je bois" sur HomeScreen ouvre interface caméra
- [ ] Interface caméra frontale avec preview live et cadre guidé
- [ ] Capture photo selfie avec verre d'eau
- [ ] Photos sauvegardées localement (iOS Documents, Android Internal Storage)
- [ ] Sélection taille verre (200ml/250ml/400ml) après capture
- [ ] Validation hydratation enregistrée dans historique (SQLite)
- [ ] Avatar passe à état 'fresh' immédiatement après validation
- [ ] Écran feedback positif avec animation avatar content
- [ ] Progression quotidienne mise à jour en temps réel
- [ ] Permission caméra gérée gracieusement (messages clairs, redirection paramètres)

### User Stories Acceptance Criteria

#### Story 3.1: Modèle HydrationLog
- [ ] Classe HydrationLog: id (UUID), timestamp, photoPath, glassSize, validated
- [ ] Enum GlassSize: small (200ml), medium (250ml), large (400ml)
- [ ] Méthode volumeLiters() retourne volume basé sur glassSize
- [ ] Méthodes toJson/fromJson fonctionnelles
- [ ] Tests unitaires coverage 100%

#### Story 3.2: Repository Historique
- [ ] HydrationLogRepository implémente: addLog, getLogsForDate, getTodayLogs, getTotalVolumeForDate, deleteOldLogs
- [ ] Table sqflite hydration_logs avec index sur timestamp
- [ ] getTodayLogs() retourne logs 00h00-23h59 UTC locale
- [ ] getTotalVolumeForDate() somme volumes pour date
- [ ] deleteOldLogs() supprime logs >90 jours
- [ ] Tests unitaires CRUD complet + requêtes date
- [ ] Tests intégration persistence réelle

#### Story 3.3: Interface Caméra
- [ ] PhotoValidationScreen ouvre sur tap "Je bois"
- [ ] Caméra frontale affichée plein écran avec preview live
- [ ] Cadre overlay semi-transparent guide positionnement (zone visage + zone verre)
- [ ] Instructions texte: "Prends un selfie avec ton verre d'eau 💧"
- [ ] Bouton capture proéminent (centre bas)
- [ ] Bouton "Annuler" retourne HomeScreen
- [ ] Permission caméra demandée automatiquement si pas accordée
- [ ] Si permission refusée: message + bouton "Ouvrir Paramètres"
- [ ] Widget test valide affichage interface (caméra mockée)

#### Story 3.4: Capture et Stockage
- [ ] Photo capturée via camera package
- [ ] Sauvegarde iOS: Application Documents/hydration_photos/
- [ ] Sauvegarde Android: Internal Storage/hydration_photos/
- [ ] Nom fichier: hydration_YYYYMMDD_HHmmss.jpg
- [ ] Compression qualité 80% (target <500KB par photo)
- [ ] Chemin photo retourné pour créer HydrationLog
- [ ] Cleanup automatique: photos >90 jours supprimées (job nocturne)
- [ ] Gestion erreur storage plein: message clair utilisateur
- [ ] Tests unitaires logique nommage + compression
- [ ] Test intégration sauvegarde réelle device

#### Story 3.5: Détection Verre (Optionnel)
- [ ] Si implémenté: ValidatePhotoUseCase analyse image
- [ ] Détection basique formes circulaires/cylindriques (heuristique simple)
- [ ] Si aucune forme: warning "On ne voit pas de verre... Tu es sûr ?" + options "Confirmer" / "Reprendre"
- [ ] Si forme détectée: validation immédiate
- [ ] Timeout détection: 2 secondes max
- [ ] Fallback erreur détection: validation directe (non bloquant)
- [ ] **Note:** Story optionnelle MVP - peut être skippée si complexité trop haute

#### Story 3.6: Enregistrement Validation
- [ ] RecordHydrationUseCase crée HydrationLog avec timestamp + photoPath + glassSize
- [ ] Log sauvegardé via HydrationLogRepository.addLog()
- [ ] lastDrinkTime avatar mis à jour (AvatarRepository)
- [ ] État avatar recalculé → retourne 'fresh' si déshydraté
- [ ] Volume total jour recalculé via getTotalVolumeForDate(today)
- [ ] Progression calculée: (volumeToday / dailyGoal) × 100%
- [ ] Analytics event loggé: hydration_validated (timestamp, glassSize)
- [ ] Tests unitaires séquence complète
- [ ] Test intégration flow end-to-end

#### Story 3.7: Animations Feedback Positif
- [ ] FeedbackScreen s'affiche après validation
- [ ] Animation avatar positif: danse, saut joie, remerciement (Lottie ou sprite)
- [ ] Message adapté personnalité avatar:
  - Mère: "Bien joué mon chéri !"
  - Coach: "YEAH ! Continue comme ça !"
  - Docteur: "Excellent réflexe."
  - Ami: "T'es un champion 🏆"
- [ ] Effet sonore positif (optionnel, désactivable): applaudissements/ding
- [ ] Progression affichée: "Tu as bu X.XL sur X.XL aujourd'hui" + barre visuelle
- [ ] Retour auto HomeScreen après 3-5 secondes
- [ ] Bouton "Continuer" permet skip attente
- [ ] Widget test valide affichage animation + message + progression

#### Story 3.8: Bouton "Je bois"
- [ ] HomeScreen affiche bouton "Je bois 💧" en bas écran
- [ ] Bouton couleur primary (bleu hydratation), hauteur ≥60dp
- [ ] Tap ouvre PhotoValidationScreen immédiatement
- [ ] Bouton accessible même si avatar dead/ghost (permet résurrection anticipée)
- [ ] Si objectif atteint: texte bouton "Je bois encore +" (permet dépasser objectif)
- [ ] Widget test valide affichage + navigation

#### Story 3.9: Sélection Taille Verre
- [ ] GlassSizeSelectionScreen s'affiche après capture photo
- [ ] 3 options: "Petit verre (200ml)", "Verre moyen (250ml)", "Grand verre (400ml)"
- [ ] Icons visuels verre proportionnels taille
- [ ] Option "Verre moyen" pré-sélectionnée par défaut
- [ ] Tap option → navigation FeedbackScreen
- [ ] glassSize passé à RecordHydrationUseCase
- [ ] Widget test valide sélection + navigation

#### Story 3.10: Gestion Permissions Caméra
- [ ] Permission demandée via permission_handler au premier lancement PhotoValidationScreen
- [ ] Si accordée: caméra s'ouvre normalement
- [ ] Si refusée: écran message "Caméra nécessaire pour validation" + bouton "Ouvrir Paramètres"
- [ ] Bouton paramètres utilise openAppSettings()
- [ ] Re-vérification permission automatique après retour settings
- [ ] Si refusée définitivement (Android): affichage permanent message paramètres
- [ ] Bouton "Annuler" retourne HomeScreen sans validation
- [ ] Tests unitaires logique demande permission
- [ ] Widget test message erreur + bouton

### Flows Utilisateur End-to-End
- [ ] **Flow validation complet:** HomeScreen → Tap "Je bois" → Caméra ouvre → Capture selfie → Sélection taille → Feedback positif → HomeScreen (avatar fresh, progression +250ml)
- [ ] **Flow permission refusée:** Tap "Je bois" → Permission demandée → Refuser → Message erreur → "Ouvrir Paramètres" → Settings → Autoriser → Retour app → Caméra fonctionne
- [ ] **Flow annulation:** Caméra ouverte → Tap "Annuler" → Retour HomeScreen (aucune validation)
- [ ] **Flow dépassement objectif:** Objectif atteint (2.5L/2.5L) → Tap "Je bois encore +" → Validation → Progression 2.75L/2.5L (110%)

---

## 🚀 VALIDATION NON-FONCTIONNELLE (NFR)

### Performance
- [ ] Ouverture caméra (PhotoValidationScreen): < 500ms
- [ ] Capture photo: < 300ms (tap bouton → photo prise)
- [ ] Compression photo: < 500ms (qualité 80%)
- [ ] Sauvegarde photo fichier local: < 200ms
- [ ] Enregistrement HydrationLog (SQLite): < 100ms
- [ ] Affichage FeedbackScreen: < 200ms (transition fluide)
- [ ] Animation feedback 60 FPS constant (pas de jank)

### Stockage & Photos
- [ ] Taille photo après compression: < 500KB (target 300-400KB)
- [ ] 90 jours photos (max 90 validations/jour): ~4GB max (acceptable)
- [ ] Cleanup automatique fonctionne: photos >90 jours supprimées
- [ ] Détection storage plein: message clair "Espace insuffisant, libère du stockage"
- [ ] Performance scan photos anciennes (cleanup): < 2 secondes

### Caméra & Permissions
- [ ] Preview caméra fluide (30 FPS minimum)
- [ ] Aucun freeze UI pendant permission system dialog
- [ ] Transition settings → app smooth (pas de crash)
- [ ] Support iOS 15+ et Android 10+ (compatibilité caméra API)

### Battery Drain
- [ ] Caméra utilisée uniquement pendant capture (pas en background)
- [ ] Caméra fermée/released après capture (pas de leak ressources)
- [ ] Battery drain session photo (ouverture → capture → fermeture): < 1% (mesuré)

### Accessibilité (WCAG AA)
- [ ] Bouton "Je bois": ≥60x60px (large target)
- [ ] Bouton capture caméra: ≥60x60px
- [ ] Contraste texte instructions caméra: ≥4.5:1 (sur overlay)
- [ ] Labels VoiceOver: "Bouton prendre photo", "Bouton annuler"
- [ ] Messages feedback accessibles screen readers

### Offline-First
- [ ] Validation photo fonctionne 100% offline
- [ ] Photos stockées localement uniquement (pas cloud pour MVP)
- [ ] HydrationLog sauvegardé localement (SQLite)
- [ ] Sync Firestore en background (best effort, non bloquant)

### Sécurité & Privacy
- [ ] Photos stockées localement par défaut (pas upload cloud automatique)
- [ ] Chemin photos non exposé publiquement (internal storage)
- [ ] Aucune photo envoyée à serveur externe sans opt-in explicite
- [ ] RGPD: deleteOldLogs() respecte right to be forgotten

### Tests
- [ ] Coverage global Epic 3: ≥80%
  - [ ] Domain layer (RecordHydrationUseCase, ValidatePhotoUseCase): ≥90%
  - [ ] Data layer (HydrationLogRepository, photo storage): ≥80%
  - [ ] Presentation layer (PhotoValidationScreen, FeedbackScreen): ≥70%
- [ ] Tests unitaires passent (focus: logique enregistrement validation)
- [ ] Tests widgets passent (screens photo, feedback, sélection taille)
- [ ] Tests intégration passent (flow complet photo → validation → update avatar)

---

## 🏗️ VALIDATION ARCHITECTURE

### Clean Architecture
- [ ] Structure respectée:
  - domain/entities/hydration_log.dart
  - domain/use_cases/record_hydration_use_case.dart
  - data/models/hydration_log_model.dart
  - data/repositories/hydration_log_repository_impl.dart
  - data/data_sources/local/photo_file_storage.dart
  - presentation/screens/photo/ (3 écrans)
- [ ] Use case RecordHydrationUseCase testé en isolation
- [ ] Repositories mockés dans tests use cases
- [ ] Photo storage abstrait (interface PhotoStorageRepository)

### Code Quality
- [ ] `flutter analyze`: 0 errors, 0 warnings
- [ ] `dart format .`: code formaté
- [ ] Gestion erreurs caméra complète (try-catch, messages clairs)
- [ ] Gestion erreurs stockage complète (storage plein, permissions)
- [ ] Dartdoc pour RecordHydrationUseCase, ValidatePhotoUseCase
- [ ] Constants extraites: kPhotoCompressionQuality = 80, kPhotoMaxSizeKB = 500

### State Management (Riverpod)
- [ ] PhotoValidationProvider gère state capture (idle, capturing, captured, error)
- [ ] FeedbackProvider gère animation playback
- [ ] Loading states gérés (compression photo, sauvegarde)
- [ ] Error states gérés (permission denied, storage full, camera error)

---

## 📚 VALIDATION DOCUMENTATION

### Code Documentation
- [ ] RecordHydrationUseCase documenté (flow complet)
- [ ] Photo compression strategy documentée
- [ ] Cleanup policy documentée (90 jours)
- [ ] Permission handling documenté

### Project Documentation
- [ ] README.md à jour (permissions caméra requises)
- [ ] Changelog maintenu pour toutes stories Epic 3
- [ ] docs/architecture.md: photo storage architecture ajoutée

---

## 🎨 VALIDATION UI/UX

### Design System
- [ ] Couleurs cohérentes avec Epics 1-2
- [ ] Bouton "Je bois" proéminent (couleur primary, large)
- [ ] Overlay caméra: semi-transparent (50% opacity), cadre blanc visible
- [ ] FeedbackScreen: couleurs joyeuses (vert success, animations colorées)

### Interface Caméra
- [ ] Preview caméra plein écran (immersif)
- [ ] Cadre guidé visible mais non intrusif
- [ ] Instructions texte lisibles (fond semi-opaque derrière texte)
- [ ] Bouton capture: icon caméra reconnaissable, couleur primary
- [ ] Bouton annuler: discret (coin haut gauche, icon X)

### Animations Feedback
- [ ] Animation avatar fluide 60 FPS (pas de saccades)
- [ ] Durée animation: 2-3 secondes (ni trop courte ni trop longue)
- [ ] Messages positifs affichés lisiblement (24sp, couleur primary)
- [ ] Barre progression visuelle claire (Material LinearProgressIndicator)
- [ ] Transition FeedbackScreen → HomeScreen smooth

### Responsive
- [ ] Caméra preview adapté à tous ratios écran (16:9, 19:9, 4:3)
- [ ] Pas de déformation image (aspect ratio respecté)
- [ ] Boutons accessibles sur petits écrans (iPhone SE)
- [ ] Overlay cadre s'adapte à taille écran

---

## 🐛 VALIDATION STABILITÉ

### Crash-Free
- [ ] Aucun crash si permission caméra refusée
- [ ] Aucun crash si storage plein
- [ ] Aucun crash si caméra déjà utilisée (autre app)
- [ ] Edge cases gérés:
  - User quitte app pendant capture → Caméra released proprement
  - Photo capturée mais app killed avant sauvegarde → Pas de log orphelin
  - Compression photo échoue → Fallback sauvegarde sans compression + warning
  - SQLite DB locked → Retry avec timeout

### Regression Testing
- [ ] Epics 1-2 toujours fonctionnels:
  - Avatar change état après validation (fresh)
  - Onboarding toujours fonctionnel
  - HomeScreen affiche progression correctement
- [ ] Flows critiques validés end-to-end

---

## 📊 CRITÈRES DE PASSAGE

**Pour que cet Epic PASSE le QA Gate:**

- ✅ **100% Validation Fonctionnelle** (10/10 stories OK, flow photo complet fonctionne)
- ✅ **95% Validation NFR** (performance caméra <500ms, photos <500KB, battery <1%)
- ✅ **100% Validation Architecture** (Clean Arch, photo storage abstrait)
- ✅ **Tests Coverage ≥80%** (RecordHydrationUseCase ≥90%)
- ✅ **Stabilité: 0 crash critique** (permissions, storage, caméra gérés)
- ✅ **Animations feedback fluides 60 FPS** (test visuel)

**Si 1 item CRITIQUE échoue → Epic FAILED, retour @dev**

**Items CRITIQUES pour Epic 3:**
- Performance caméra (capture <300ms, pas de freeze)
- Gestion permissions caméra robuste (aucun crash)
- Photos optimisées <500KB (compression fonctionnelle)
- Flow validation complet fonctionne end-to-end
- Animations feedback fluides (60 FPS, pas de jank)

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
- Ouverture caméra: _______ ms
- Capture photo: _______ ms
- Compression photo: _______ ms (taille moyenne: _______ KB)
- Battery drain session photo: _______ %
- Animation FPS: _______ (target 60)
- Coverage global Epic 3: _______ %

**Tests Device:**
- iOS 15 (iPhone 8): ✅ / ❌
- iOS 17 (iPhone 14): ✅ / ❌
- Android 10 (Pixel 4): ✅ / ❌
- Android 13 (Pixel 7): ✅ / ❌

---

**Prochaine étape:** Epic 4 - Système de Notifications Punitives

---

*QA Gate créé le 2026-01-07 - Epic 3 Validation Photo & Feedback Positif*
