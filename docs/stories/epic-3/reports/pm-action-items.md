# Action Items - Epic 3 Stories Review

**Date:** 2026-01-16
**Product Manager:** John
**Source:** [pm-stories-review.md](pm-stories-review.md)

---

## 🔴 BLOQUANT - Priorité 0 (À Faire IMMÉDIATEMENT)

### 1. Créer DoD Report Story 3.1
- **ID:** ACTION-E3-001
- **Story:** 3.1 - Modèle de Données Validation Hydratation
- **Tâche:** Créer `docs/stories/epic-3/reports/story-3.1-dod-report.md`
- **Raison:** Story "Ready for Review" sans DoD report (violation governance.md section 6)
- **Template:** Utiliser story-3.2-dod-report.md comme référence
- **Effort:** 1 heure
- **Assigné:** Dev Agent
- **Deadline:** Avant merge Story 3.1

### 2. Créer DoD Report Story 3.8
- **ID:** ACTION-E3-002
- **Story:** 3.8 - Bouton "Je bois" sur HomeScreen
- **Tâche:** Créer `docs/stories/epic-3/reports/story-3.8-dod-report.md`
- **Raison:** Story "Ready for Review" sans DoD report (violation governance.md section 6)
- **Template:** Utiliser story-3.10-dod-report.md comme référence
- **Effort:** 1 heure
- **Assigné:** Dev Agent
- **Deadline:** Avant merge Story 3.8

### 3. Clarifier Story 3.4 - AC #3 Format Timestamp
- **ID:** ACTION-E3-003
- **Story:** 3.4 - Capture et Stockage Photo Locale
- **Tâche:** Spécifier format exact du timestamp dans nom fichier
- **Problème Actuel:**
  - AC #3 dit `YYYYMMDD_HHmmss`
  - Exemple montre `hydration_20260107_143022.jpg`
  - Format ambigu: underscores où exactement?
- **Solution Recommandée:**
  - Option A: `YYYYMMDD_HHmmss` → `hydration_20260107_143022.jpg` (actuel exemple)
  - Option B: `YYYY-MM-DD_HH-mm-ss` → `hydration_2026-01-07_14-30-22.jpg` (ISO lisible)
  - **Décision PM requise:** Choisir Option A ou B
- **Effort:** 15 minutes
- **Assigné:** PM John
- **Deadline:** Avant start dev Story 3.4

### 4. Clarifier Story 3.4 - AC #4 Compression Photo
- **ID:** ACTION-E3-004
- **Story:** 3.4 - Capture et Stockage Photo Locale
- **Tâche:** Reformuler AC #4 pour être testable
- **Problème Actuel:**
  - "compressée à qualité 80% pour limiter la taille (<500KB par photo)"
  - Qualité 80% = parameter 0-100 du package image?
  - <500KB non garanti (dépend contenu photo)
- **Solution Recommandée:**
  - Remplacer par: "Photo compressée avec quality parameter 80 (package image), taille cible <500KB en moyenne pour photos typiques selfie+verre"
  - Ajouter Technical Note: "Utiliser image.encodeJpg(quality: 80)"
- **Effort:** 15 minutes
- **Assigné:** PM John
- **Deadline:** Avant start dev Story 3.4

### 5. Clarifier Story 3.6 - AC #1 Trigger "Confirmation Photo"
- **ID:** ACTION-E3-005
- **Story:** 3.6 - Enregistrement Validation et Update Progression
- **Tâche:** Spécifier trigger exact "Après confirmation photo"
- **Problème Actuel:**
  - AC #1 dit "Après confirmation photo" mais non défini
  - Story 3.5 (détection verre)? Story 3.9 (sélection taille)?
  - Ordre flow ambigu
- **Solution Recommandée:**
  - Remplacer "Après confirmation photo" par "Après sélection taille verre (Story 3.9)"
  - Ajouter dépendance explicite: "Story 3.9 (Glass size selection) doit être complétée"
  - Clarifier flow: 3.4 capture → 3.5 détection (optionnel) → 3.9 sélection → **3.6 enregistrement** → 3.7 feedback
- **Effort:** 20 minutes
- **Assigné:** PM John
- **Deadline:** Avant start dev Story 3.6

---

## 🟡 IMPORTANT - Priorité 1 (Cette Semaine)

### 6. Décider Sort Story 3.5 - Détection Verre
- **ID:** ACTION-E3-006
- **Story:** 3.5 - Détection Basique Présence Verre
- **Tâche:** Décision Go/No-Go pour MVP
- **Problèmes Actuels:**
  - AC #2 trop vague ("OpenCV basic" non défini)
  - Story marquée OPTIONNELLE mais 9 AC détaillés (confusion)
  - Risque over-engineering pour MVP
- **Options:**
  - **Option A (RECOMMANDÉE):** Déprioriser en V2, remplacer par validation manuelle simple
    - Flow MVP: 3.4 capture → 3.9 sélection (sans détection automatique)
    - Gain: -6h dev, scope MVP réduit
  - **Option B:** Créer Story 3.5.0 "Spike Technique Détection Verre" (2h research ML Kit/OpenCV)
    - Si spike concluant: Implémenter 3.5 avec specs précises
    - Si spike non concluant: Revenir Option A
- **Effort:** 2h spike OU 15 minutes dépriorisation
- **Assigné:** PM John (décision) + Dev Agent (spike si Option B)
- **Deadline:** Vendredi 2026-01-17

### 7. Spécifier Animations Story 3.7
- **ID:** ACTION-E3-007
- **Story:** 3.7 - Animations Avatar Feedback Positif
- **Tâche:** Définir animations avatar exactes
- **Problème Actuel:**
  - AC #2 dit "danse, saut de joie, ou remerciement" (lequel?)
  - "Lottie animation ou sprite sheet" (quelle source?)
- **Options:**
  - **Option A (RAPIDE):** Animations Flutter simples
    - Scale up/down (1.0 → 1.2 → 1.0) + rotation légère
    - Pas de Lottie, pas d'assets externes
    - Effort: 2h dev
  - **Option B (QUALITÉ):** Lottie animations
    - Trouver 4 animations Lottie free (LottieFiles)
    - 1 par personality (Mère: applause, Coach: celebration, Docteur: checkmark, Ami: party)
    - Effort: 4h recherche assets + intégration
- **Solution Recommandée:** Option A pour MVP, Option B pour V1.1
- **Effort:** 1h documentation si Option A, 4h si Option B
- **Assigné:** PM John (décision) + UX (assets si Option B)
- **Deadline:** Vendredi 2026-01-17

### 8. Clarifier Story 3.6 - AC #7 Analytics Optionnel
- **ID:** ACTION-E3-008
- **Story:** 3.6 - Enregistrement Validation et Update Progression
- **Tâche:** Préciser gestion Firebase Analytics optionnel
- **Problème Actuel:**
  - AC #7 suppose Firebase disponible
  - Firebase optionnel pour dev (mock config fourni)
  - Pas de gestion si Firebase indisponible/offline
- **Solution Recommandée:**
  - Remplacer AC #7 par: "Une analytics event est loggée (`hydration_validated`) si Firebase Analytics disponible, sinon skip silencieusement (pas d'erreur)"
  - Ajouter Technical Note: "Wrapper try-catch autour FirebaseAnalytics.logEvent(), ignorer exception si Firebase mock"
- **Effort:** 15 minutes
- **Assigné:** PM John
- **Deadline:** Avant start dev Story 3.6

### 9. Clarifier Story 3.9 - AC #1 Ordre Flow
- **ID:** ACTION-E3-009
- **Story:** 3.9 - Sélection Taille de Verre
- **Tâche:** Clarifier ordre flow "avant/après validation photo"
- **Problème Actuel:**
  - AC #1 dit "Après capture photo (et avant/après validation photo)"
  - "avant/après" ambigu - c'est avant OU après?
- **Solution Recommandée:**
  - Si Story 3.5 dépriorisée (ACTION-E3-006): "Après capture photo (Story 3.4), avant enregistrement (Story 3.6)"
  - Si Story 3.5 incluse: "Après capture photo (Story 3.4) et validation verre (Story 3.5), avant feedback (Story 3.7)"
- **Effort:** 10 minutes
- **Assigné:** PM John
- **Deadline:** Après décision Story 3.5 (ACTION-E3-006)

### 10. Clarifier Story 3.7 - Scope Son
- **ID:** ACTION-E3-010
- **Story:** 3.7 - Animations Avatar Feedback Positif
- **Tâche:** Décider si son fait partie du scope MVP
- **Problème Actuel:**
  - AC #4 dit "effet sonore positif (optionnel, peut être désactivé)"
  - "Optionnel" = scope creep? Comment désactiver (pas de settings story)?
- **Options:**
  - **Option A (RECOMMANDÉE):** Retirer son de Story 3.7 AC
    - Créer Story 4.X "Effets Sonores + Settings" dans Epic 4
    - Story 3.7 focus animations visuelles uniquement
  - **Option B:** Inclure son simple (pas de settings désactivation)
    - Son joue toujours, pas d'option désactivation MVP
    - Settings dans Epic 4 later
- **Solution Recommandée:** Option A (retirer son AC #4)
- **Effort:** 10 minutes update story
- **Assigné:** PM John
- **Deadline:** Vendredi 2026-01-17

---

## 🟢 NICE TO HAVE - Priorité 2 (Prochaine Itération)

### 11. Standardiser Template DoD Reports
- **ID:** ACTION-E3-011
- **Tâche:** Créer template DoD report réutilisable
- **Raison:** Stories 3.2 et 3.10 ont excellents DoD reports, utiliser comme template
- **Livrable:** `docs/templates/dod-report-template.md`
- **Sections Template:**
  1. Requirements Met (AC checklist)
  2. Coding Standards & Project Structure
  3. Testing (Unit, Widget, Integration)
  4. Functionality & Verification
  5. Story Administration
  6. Dependencies, Build & Configuration
  7. Documentation
  8. Final Confirmation (What accomplished, Challenges, Ready for review)
- **Effort:** 1 heure
- **Assigné:** PM John
- **Deadline:** Fin Sprint actuel

### 12. Créer Flow Diagram Epic 3
- **ID:** ACTION-E3-012
- **Tâche:** Créer diagramme flow utilisateur complet Epic 3
- **Raison:** Visualiser dépendances inter-stories, clarifier ordre
- **Livrable:** `docs/stories/epic-3/flow-diagram.md` (Mermaid syntax)
- **Contenu:**
  - Flow nominal: 3.8 → 3.10 → 3.3 → 3.4 → (3.5) → 3.9 → 3.6 → 3.7
  - Flow erreur: Permission denied, Camera fail, Storage full
  - Flow optionnel: Détection verre (3.5), Son (future)
- **Effort:** 1 heure
- **Assigné:** PM John
- **Deadline:** Avant start dev Story 3.4

### 13. Clarifier Cleanup Photos Story 3.4
- **ID:** ACTION-E3-013
- **Story:** 3.4 - Capture et Stockage Photo Locale
- **Tâche:** Clarifier "cleanup job nocturne" AC #6
- **Problème Actuel:**
  - AC #6 dit "photos de plus de 90 jours sont supprimées automatiquement (cleanup job nocturne)"
  - Comment démarrer job? Background task? App foreground?
  - iOS/Android gestion différente background tasks
- **Solution Recommandée:**
  - Ajouter Technical Note: "Cleanup exécuté à chaque ouverture app (foreground), pas background task"
  - Logique: `await deleteOldPhotos()` dans `main.dart` après init GetIt
  - Justification: Simple, cross-platform, pas de permissions background
- **Effort:** 15 minutes
- **Assigné:** PM John
- **Deadline:** Avant start dev Story 3.4

### 14. Documenter Gap Sync Firebase
- **ID:** ACTION-E3-014
- **Tâche:** Créer story Epic 4 pour gestion sync offline/online
- **Raison:** Gap identifié - stories 3.2, 3.6 mentionnent Firebase sync mais aucune story couvre "Que faire si sync échoue?"
- **Livrable:** Story 4.X "Gestion Sync Offline/Online Firebase"
- **Contenu Story:**
  - AC: Détection connexion réseau (connectivity_plus)
  - AC: Queue locale logs non synced (synced_to_cloud flag)
  - AC: Retry automatique sync quand réseau revient
  - AC: Indicateur UI "Sync en cours" / "Hors ligne"
- **Effort:** 2 heures création story
- **Assigné:** PM John
- **Deadline:** Avant fin Epic 3 (pour Epic 4 planning)

### 15. Créer Story Epic 4 - User Settings
- **ID:** ACTION-E3-015
- **Tâche:** Créer story Epic 4 pour settings utilisateur
- **Raison:** Gap identifié - Story 3.7 mentionne "son peut être désactivé" mais aucune story settings
- **Livrable:** Story 4.Y "User Settings Screen"
- **Contenu Story:**
  - AC: Écran settings accessible depuis HomeScreen
  - AC: Toggle son ON/OFF (persistent SharedPreferences)
  - AC: Toggle notifications ON/OFF
  - AC: Toggle animations avatar ON/OFF
  - AC: Bouton "Réinitialiser données" (confirmation dialog)
- **Effort:** 2 heures création story
- **Assigné:** PM John
- **Deadline:** Avant fin Epic 3 (pour Epic 4 planning)

---

## 📊 Tracking Progress

### Bloquants (Priorité 0)
- [ ] ACTION-E3-001: DoD Report Story 3.1
- [ ] ACTION-E3-002: DoD Report Story 3.8
- [ ] ACTION-E3-003: Clarifier 3.4 AC #3 timestamp
- [ ] ACTION-E3-004: Clarifier 3.4 AC #4 compression
- [ ] ACTION-E3-005: Clarifier 3.6 AC #1 trigger

**Progress:** 0/5 (0%) | **Blockers:** 5 stories can't start dev

### Importants (Priorité 1)
- [ ] ACTION-E3-006: Décider sort Story 3.5
- [ ] ACTION-E3-007: Spécifier animations Story 3.7
- [ ] ACTION-E3-008: Clarifier 3.6 AC #7 analytics
- [ ] ACTION-E3-009: Clarifier 3.9 AC #1 ordre flow
- [ ] ACTION-E3-010: Clarifier 3.7 scope son

**Progress:** 0/5 (0%) | **ETA Completion:** Vendredi 2026-01-17

### Nice to Have (Priorité 2)
- [ ] ACTION-E3-011: Template DoD reports
- [ ] ACTION-E3-012: Flow diagram Epic 3
- [ ] ACTION-E3-013: Clarifier cleanup photos 3.4
- [ ] ACTION-E3-014: Story 4.X sync Firebase
- [ ] ACTION-E3-015: Story 4.Y user settings

**Progress:** 0/5 (0%) | **Non-blocking**

---

## 🎯 Prochaines Étapes Recommandées

### Cette Semaine (Priorité 0 + 1)
1. **Lundi PM:** Créer DoD reports 3.1 et 3.8 (2h)
2. **Lundi PM:** Clarifier stories 3.4 et 3.6 (1h)
3. **Mardi PM:** Décider sort Story 3.5 (Go/No-Go MVP)
4. **Mercredi PM:** Spécifier animations 3.7 + scope son
5. **Jeudi PM:** Clarifier story 3.9 ordre flow
6. **Vendredi:** Review final + unblock dev stories restantes

### Semaine Prochaine (Priorité 2)
7. Créer template DoD reports
8. Créer flow diagram Epic 3
9. Planifier stories Epic 4 (Sync + Settings)

**ETA Unblock Epic 3:** Fin de semaine (5 jours ouvrés)
**ETA Completion Epic 3:** +2 semaines dev après unblock (stories 3.4-3.9)

---

**Action Items créés par:** John (Product Manager)
**Date:** 2026-01-16
**Next Review:** Vendredi 2026-01-17 (Progress check)
