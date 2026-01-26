# Story 3.7: Animations Avatar Feedback Positif

**Epic:** Epic 3 - Validation Photo & Feedback Positif
**Story ID:** 3.7
**Status:** Not Started
**Priority:** High
**Estimated Effort:** 6 hours

---

## User Story

**As a** user,
**I want** que mon avatar réagisse positivement quand je bois,
**so that** je ressens une récompense émotionnelle et renforce mon engagement.

---

## Acceptance Criteria

1. Après validation réussie (Story 3.6 `RecordHydrationUseCase` terminé), l'app navigue vers un écran `FeedbackScreen` temporaire (durée affichage: 4 secondes)
   - Navigation depuis: `GlassSizeSelectionScreen` (Story 3.9) après enregistrement
   - Parameters passés: Aucun (lecture state depuis providers)
2. L'avatar s'affiche avec animation positive Flutter simple (scale + bounce)
   - **Animation MVP:** Scale up 1.0 → 1.2 → 1.0 (duration 800ms) + rotation légère -5° → +5° → 0° (duration 600ms)
   - Pas de Lottie pour MVP (simplicité + pas de package externe)
   - Animation loop 2 fois pendant affichage écran (4 secondes = 2 cycles animation)
   - Avatar image chargé depuis AvatarState actuel (fresh après hydratation)
3. Un message positif s'affiche adapté à la personnalité de l'avatar
   - Mère autoritaire: "Bien joué mon chéri ! Continue comme ça."
   - Coach sportif: "YEAH ! Excellent ! Tu gères !"
   - Docteur: "Excellent réflexe. Ton corps te remercie."
   - Ami sarcastique: "Wow, tu bois de l'eau ! T'es un champion 🏆"
   - Messages hardcodés dans Map<AvatarPersonality, String>
4. ~~Un effet sonore positif (optionnel, peut être désactivé) joue : applaudissements, ding, ou fanfare courte~~
   - **RETIRÉE DU SCOPE MVP:** Feature déférée en Epic 4 "User Settings"
   - Raison: Nécessite settings utilisateur (activer/désactiver son) non disponible MVP
   - V2: Créer Story 4.X "Sound Effects + Settings"
5. L'écran affiche aussi la progression : "Tu as bu X.XL sur X.XL aujourd'hui" avec barre de progression visuelle
   - Format: "Tu as bu 0.75L sur 2.0L aujourd'hui" (1 décimale)
   - Barre progression: LinearProgressIndicator value = volumeToday / dailyGoal (plafonné 1.0)
   - Couleur barre: Bleu primaire si <100%, vert si ≥100%
6. Après 4 secondes, retour automatique au HomeScreen avec avatar maintenant en état `fresh`
   - Timer: `Future.delayed(Duration(seconds: 4), () => Navigator.pop(context))`
   - Avatar state déjà mis à jour par Story 3.6 (pas de update dans 3.7)
7. Un bouton "Continuer" en bas écran permet de skip l'attente et retourner immédiatement au HomeScreen
   - UI: TextButton "Continuer" centre bas écran
   - Action: Cancel timer + Navigator.pop(context)
8. Widget test valide l'affichage de l'animation, du message, et de la progression
   - Test: Avatar affiché avec animation active
   - Test: Message personnalisé correct selon personality
   - Test: Progression affichée avec format correct
   - Test: Timer auto-dismiss après 4 secondes
   - Test: Bouton "Continuer" pop immédiat

---

## Technical Notes

- Location: `lib/presentation/screens/feedback/feedback_screen.dart`
- Animations: Flutter AnimationController + Tween (scale + rotation)
  - ScaleTransition pour scale up/down
  - RotationTransition pour bounce rotation
  - AnimationController duration: 800ms, repeat: 2 times
- ~~Sound: `audioplayers` package (optional)~~ RETIRÉ MVP
- Messages: Map<AvatarPersonality, String> dans constants
  ```dart
  const kFeedbackMessages = {
    AvatarPersonality.authoritarianMother: "Bien joué mon chéri ! Continue comme ça.",
    AvatarPersonality.sportsCoach: "YEAH ! Excellent ! Tu gères !",
    AvatarPersonality.doctor: "Excellent réflexe. Ton corps te remercie.",
    AvatarPersonality.sarcasticFriend: "Wow, tu bois de l'eau ! T'es un champion 🏆",
  };
  ```
- Tests: `test/presentation/screens/feedback/feedback_screen_test.dart`
- Auto-dismiss: Cancel timer dans dispose() pour éviter memory leak

---

## Dependencies

- Story 3.6 (Record hydration) doit être complétée (met à jour avatar state + volume)
- Story 1.2 (Avatar personalities) doit être complétée (pour messages personnalisés)
- ~~Package `lottie` (optionnel) doit être ajouté~~ RETIRÉ - Animations Flutter natives uniquement

---

## Definition of Done

- [ ] Tous les AC validés
- [ ] Widget tests passent
- [ ] Animations fonctionnent
- [ ] Messages personnalisés OK
- [ ] Auto-dismiss fonctionne
- [ ] Code suit conventions
- [ ] PM approval

---

## Links

- Epic: [epic-3-photo-validation.md](../../epics/epic-3-photo-validation.md)
- Previous: [story-3.6-record-hydration.md](story-3.6-record-hydration.md)
- Next: [story-3.8-drink-button.md](story-3.8-drink-button.md)
