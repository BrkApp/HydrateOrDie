# Synthèse Clarifications Stories Epic 3

**Date:** 2026-01-16
**Product Manager:** John
**Action:** Clarification AC ambigus identifiés dans pm-stories-review.md

---

## ✅ Clarifications Complétées

### 📋 Story 3.4 - Capture et Stockage Photo Locale

#### AC #3 - Format Timestamp (CLARIFIÉ)
**Problème initial:** Format `YYYYMMDD_HHmmss` ambigu

**Solution appliquée:**
```
Format exact: Année(4 chiffres) + Mois(2 chiffres) + Jour(2 chiffres) + underscore + Heure(2 chiffres) + Minute(2 chiffres) + Seconde(2 chiffres)
Implémentation: DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())
Exemples valides: hydration_20260116_093045.jpg, hydration_20261231_235959.jpg
```

**Impact:** Dev peut maintenant implémenter sans ambiguïté. Package `intl` ajouté aux Technical Notes.

#### AC #4 - Compression Photo (CLARIFIÉ)
**Problème initial:** "Qualité 80%" et "<500KB" non testables précisément

**Solution appliquée:**
```
La photo est compressée avec quality parameter 80 (package image) pour limiter la taille (cible <500KB en moyenne pour photos typiques selfie+verre)
- Implémentation: image.encodeJpg(photo, quality: 80)
- Note: Taille finale dépend du contenu photo, <500KB est une cible moyenne, pas une garantie stricte
- Tests doivent vérifier quality parameter = 80, pas taille finale exacte
```

**Impact:** AC devient testable (vérifier quality=80 dans code), pas de fausse attente sur taille fichier stricte.

#### AC #6 - Cleanup Job (CLARIFIÉ)
**Problème initial:** "Cleanup job nocturne" non défini (background task? foreground?)

**Solution appliquée:**
```
Les photos de plus de 90 jours sont supprimées automatiquement lors de l'ouverture de l'app (pas de background task, exécution foreground uniquement)
- Logique: Comparaison DateTime.now().difference(fileCreationDate).inDays > 90
- Exécution: Appel dans main.dart après init GetIt, avant runApp
- Justification: Simple, cross-platform, pas de permissions background nécessaires
```

**Impact:** Implémentation cross-platform simple, pas de complexité background tasks iOS/Android.

---

### 📋 Story 3.6 - Enregistrement Validation et Update Progression

#### AC #1 - Trigger "Confirmation Photo" (CLARIFIÉ)
**Problème initial:** "Après confirmation photo" non défini

**Solution appliquée:**
```
Après sélection taille verre (Story 3.9 terminée), le use case RecordHydrationUseCase est appelé avec params: photoPath (String), glassSize (GlassSize enum)
- Le use case crée un HydrationLog avec timestamp actuel (DateTime.now()), photoPath, glassSize, validated = true
- Trigger exact: Navigation depuis GlassSizeSelectionScreen après tap sur option verre
```

**Impact:** Flow clarifié, dépendance Story 3.9 ajoutée dans Dependencies section.

#### AC #7 - Analytics Optionnel (CLARIFIÉ)
**Problème initial:** Analytics suppose Firebase disponible, mais Firebase optionnel pour dev

**Solution appliquée:**
```
Une analytics event est loggée hydration_validated avec propriétés (timestamp, glassSize) SI Firebase Analytics disponible, sinon skip silencieusement (pas d'erreur)
- Implémentation: Wrapper try-catch autour FirebaseAnalytics.logEvent(), ignorer exception si Firebase mock/indisponible
- Log debug si skip: "Analytics skipped - Firebase not available"
```

**Impact:** Code robuste, fonctionne en dev sans Firebase mock, pas de crash si Firebase indisponible.

---

### 📋 Story 3.9 - Sélection Taille de Verre

#### AC #1 - Ordre Flow (CLARIFIÉ)
**Problème initial:** "Après capture photo (et avant/après validation photo)" ambigu

**Solution appliquée:**
```
Après capture photo (Story 3.4), un écran GlassSizeSelectionScreen s'affiche immédiatement
- Navigation depuis: PhotoValidationScreen après _capturePhoto() réussie
- Parameters passés: photoPath (String) du fichier sauvegardé
- Note: Story 3.5 (détection verre) est optionnelle et non implémentée pour MVP
```

**Impact:** Flow MVP simplifié sans Story 3.5, ordre d'exécution clair (3.4 → 3.9 direct).

#### AC #5 - Navigation (CLARIFIÉ)
**Problème initial:** Navigation vers FeedbackScreen mais dépendance floue

**Solution appliquée:**
```
Taper une option la sélectionne ET appelle immédiatement RecordHydrationUseCase puis navigue vers écran de transition
- Flow: Tap → Record log → Navigate to FeedbackScreen (Story 3.7 si implémentée) OU retour HomeScreen
- Parameters: photoPath + glassSize sélectionné
```

**Impact:** Flexibilité MVP - fonctionne même si Story 3.7 pas encore implémentée (fallback HomeScreen).

#### Dependencies (MISES À JOUR)
```
- Story 3.1 (GlassSize enum) doit être complétée
- Story 3.4 (Photo capture storage) doit être complétée (fournit photoPath)
- Story 3.6 (RecordHydrationUseCase) doit être complétée (appelé depuis 3.9)
- Story 3.7 (Feedback screen) optionnelle pour MVP (si non implémentée: retour HomeScreen)
```

---

### 📋 Story 3.5 - Détection Basique Présence Verre

#### DÉCISION: DÉFÉRÉE EN V2
**Status updated:** `DEFERRED TO V2 (PM Decision 2026-01-16)`

**Raisons:**
1. **AC trop vagues:** AC #2 "OpenCV basic" non défini (HoughCircles? Contours? ML Kit modèle?)
2. **Complexité vs Valeur:** 6h dev + intégration package externe pour anti-triche basique
3. **MVP Scope:** Flow MVP fonctionne sans (3.4 capture → 3.9 sélection taille → 3.6 enregistrement)
4. **Fallback existe:** AC #4 "Oui je confirme" permet bypass = détection devient cosmétique

**Flow MVP sans Story 3.5:**
```
User tape "Je bois" (3.8)
  ↓
Permissions caméra (3.10)
  ↓
Interface caméra (3.3)
  ↓
Capture + sauvegarde photo (3.4)
  ↓
→ Direct à sélection taille verre (3.9) (pas de détection)
  ↓
Enregistrement hydration (3.6)
  ↓
Feedback avatar (3.7)
```

**Pour V2 (si nécessaire):**
- Créer spike technique 2h: Tester ML Kit Object Detection API + Google Vision API
- Si concluant: Implémenter avec specs précises algorithme
- Si non concluant: Abandonner feature

**Impact:** Réduction scope MVP (-6h dev), simplification flow, pas de package externe ML/OpenCV.

---

### 📋 Story 3.7 - Animations Avatar Feedback Positif

#### AC #2 - Animations (CLARIFIÉ)
**Problème initial:** "Danse, saut de joie, ou remerciement" trop vague, "Lottie ou sprite sheet" non spécifié

**Solution appliquée:**
```
L'avatar s'affiche avec animation positive Flutter simple (scale + bounce)
- Animation MVP: Scale up 1.0 → 1.2 → 1.0 (duration 800ms) + rotation légère -5° → +5° → 0° (duration 600ms)
- Pas de Lottie pour MVP (simplicité + pas de package externe)
- Animation loop 2 fois pendant affichage écran (4 secondes = 2 cycles animation)
- Avatar image chargé depuis AvatarState actuel (fresh après hydratation)
```

**Technical implementation:**
```dart
- Flutter AnimationController + Tween (scale + rotation)
- ScaleTransition pour scale up/down
- RotationTransition pour bounce rotation
- AnimationController duration: 800ms, repeat: 2 times
```

**Impact:** Implémentation simple Flutter natif, pas de recherche assets Lottie, pas de package externe, cross-platform garanti.

#### AC #4 - Scope Son (RETIRÉ)
**Problème initial:** "Son optionnel, peut être désactivé" mais aucune story settings

**Solution appliquée:**
```
~~Un effet sonore positif (optionnel, peut être désactivé) joue : applaudissements, ding, ou fanfare courte~~
- RETIRÉE DU SCOPE MVP: Feature déférée en Epic 4 "User Settings"
- Raison: Nécessite settings utilisateur (activer/désactiver son) non disponible MVP
- V2: Créer Story 4.X "Sound Effects + Settings"
```

**Impact:** Réduction scope MVP, focus animations visuelles, évite scope creep settings.

#### AC #3 - Messages (CLARIFIÉ)
**Messages exacts spécifiés:**
```dart
const kFeedbackMessages = {
  AvatarPersonality.authoritarianMother: "Bien joué mon chéri ! Continue comme ça.",
  AvatarPersonality.sportsCoach: "YEAH ! Excellent ! Tu gères !",
  AvatarPersonality.doctor: "Excellent réflexe. Ton corps te remercie.",
  AvatarPersonality.sarcasticFriend: "Wow, tu bois de l'eau ! T'es un champion 🏆",
};
```

**Impact:** Dev copie-colle messages exacts, pas d'improvisation tone.

---

## 📊 Impact Global Clarifications

### Stories Débloquées pour Dev

| Story | Status Avant | Status Après | Blockers Résolus |
|-------|--------------|--------------|-------------------|
| 3.4 | ❌ BLOCKED | ✅ READY | AC #3, #4, #6 clarifiés |
| 3.5 | ❌ BLOCKED | ⏸️ DEFERRED V2 | Dépriorisée |
| 3.6 | ❌ BLOCKED | ✅ READY | AC #1, #7 clarifiés |
| 3.7 | ❌ BLOCKED | ✅ READY | AC #2, #4 clarifiés/retirés |
| 3.9 | ⚠️ PARTIAL | ✅ READY | AC #1, dependencies clarifiés |

### Réduction Scope MVP

**Features retirées:**
- ❌ Story 3.5: Détection verre automatique (déférée V2)
- ❌ Story 3.7 AC #4: Effets sonores (déférés Epic 4)

**Économies estimées:**
- Story 3.5: -6h dev + package externe ML/OpenCV
- Story 3.7 son: -2h dev + package audioplayers + settings UI

**Total gain:** ~8h dev + 2 packages externes évités

### Flow MVP Final Clarifié

```mermaid
graph TD
    A[3.8: Bouton Je bois] --> B[3.10: Permissions caméra]
    B --> C[3.3: Interface caméra]
    C --> D[3.4: Capture + sauvegarde photo]
    D --> E[3.9: Sélection taille verre]
    E --> F[3.6: Enregistrement hydration]
    F --> G[3.7: Feedback animation avatar]
    G --> H[Retour HomeScreen]

    style D fill:#90EE90
    style E fill:#90EE90
    style F fill:#90EE90
    style G fill:#90EE90
```

**Flow simplifié:** 7 stories (était 8 avec 3.5)

---

## 🎯 Prochaines Actions

### ✅ Complété
1. ✅ Clarifier Story 3.4 AC #3 (format timestamp)
2. ✅ Clarifier Story 3.4 AC #4 (compression photo)
3. ✅ Clarifier Story 3.6 AC #1 (trigger confirmation)
4. ✅ Clarifier Story 3.6 AC #7 (analytics optionnel)
5. ✅ Clarifier Story 3.9 AC #1 (ordre flow)
6. ✅ Décider sort Story 3.5 (déférée V2)
7. ✅ Clarifier Story 3.7 AC #2 (animations)
8. ✅ Clarifier Story 3.7 AC #4 (scope son retiré)

### 📝 Reste à Faire (Priorité 0)
1. ❌ Créer DoD Report Story 3.1
2. ❌ Créer DoD Report Story 3.8

**ETA:** 2h (1h par report)

### 🚀 Ready for Dev
Stories **DÉBLOQUÉES** et prêtes pour implémentation:
- ✅ Story 3.4 (après 3.3 complète)
- ✅ Story 3.6 (après 3.2, 3.9, 1.3, 1.5 complètes)
- ✅ Story 3.7 (après 3.6, 1.2 complètes)
- ✅ Story 3.9 (après 3.1, 3.4, 3.6 complètes)

---

## 📈 Métriques Qualité

### Avant Clarifications
- Stories avec AC ambigus: **5/10 (50%)**
- Stories bloquées pour dev: **5/10 (50%)**
- Score qualité moyen: **84.5%**

### Après Clarifications
- Stories avec AC ambigus: **0/9 (0%)** (3.5 déférée)
- Stories bloquées pour dev: **0/9 (0%)**
- Score qualité moyen estimé: **~92%** (+7.5 points)

### Amélioration
- ✅ **+50% stories ready for dev** (0/10 → 5/9 après dependencies)
- ✅ **100% AC testables** (toutes ambiguïtés résolues)
- ✅ **Scope MVP réduit** (-8h dev, focus valeur)

---

## 🔗 Fichiers Modifiés

1. [story-3.4-photo-capture-storage.md](../story-3.4-photo-capture-storage.md)
   - AC #3: Format timestamp clarifié avec implémentation
   - AC #4: Compression quality parameter spécifié
   - AC #6: Cleanup job foreground clarifié
   - Technical Notes: Ajout intl package, photo_cleanup_utils.dart

2. [story-3.6-record-hydration.md](../story-3.6-record-hydration.md)
   - AC #1: Trigger exact spécifié (après Story 3.9)
   - AC #7: Analytics optionnel Firebase clarifié
   - Dependencies: Ajout Story 3.9

3. [story-3.9-glass-size-selection.md](../story-3.9-glass-size-selection.md)
   - AC #1: Ordre flow clarifié (après 3.4, pas 3.5)
   - AC #5: Navigation fallback HomeScreen si 3.7 non implémentée
   - Dependencies: Ajout 3.4, 3.6, 3.7 optionnelle

4. [story-3.5-glass-detection.md](../story-3.5-glass-detection.md)
   - Status: DEFERRED TO V2
   - PM Decision section ajoutée avec justification
   - Flow MVP sans 3.5 documenté

5. [story-3.7-avatar-feedback-animation.md](../story-3.7-avatar-feedback-animation.md)
   - AC #2: Animation Flutter simple spécifiée (scale + rotation)
   - AC #4: Son retiré scope MVP (déféré Epic 4)
   - AC #3: Messages exacts hardcodés fournis
   - Technical Notes: Implémentation AnimationController détaillée

---

**Rapport créé par:** John (Product Manager)
**Date:** 2026-01-16
**Durée clarifications:** 2h30
**Status:** ✅ TERMINÉ - Stories débloquées pour dev
