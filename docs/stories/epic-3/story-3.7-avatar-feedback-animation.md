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

1. Après validation réussie, l'app navigue vers un écran `FeedbackScreen` temporaire (3-5 secondes)
2. L'avatar s'affiche avec animation positive : danse, saut de joie, ou remerciement (Lottie animation ou sprite sheet)
3. Un message positif s'affiche adapté à la personnalité de l'avatar (ex: Mère: "Bien joué mon chéri !", Coach: "YEAH ! Continue comme ça !", Docteur: "Excellent réflexe.", Ami: "T'es un champion 🏆")
4. Un effet sonore positif (optionnel, peut être désactivé) joue : applaudissements, ding, ou fanfare courte
5. L'écran affiche aussi la progression : "Tu as bu X.XL sur X.XL aujourd'hui" avec barre de progression visuelle
6. Après 3-5 secondes, retour automatique au HomeScreen avec avatar maintenant en état `fresh`
7. Un bouton "Continuer" permet de skip l'attente et retourner immédiatement au HomeScreen
8. Widget test valide l'affichage de l'animation, du message, et de la progression

---

## Technical Notes

- Location: `lib/presentation/screens/feedback/feedback_screen.dart`
- Animations: Lottie or custom animations
- Sound: `audioplayers` package (optional)
- Messages: Map personality to positive messages
- Tests: `test/presentation/screens/feedback/feedback_screen_test.dart`

---

## Dependencies

- Story 3.6 (Record hydration) doit être complétée
- Story 1.2 (Avatar personalities) doit être complétée
- Package `lottie` (optionnel) doit être ajouté

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
