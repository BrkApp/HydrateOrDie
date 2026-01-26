# Story 3.6: Enregistrement Validation et Update Progression

**Epic:** Epic 3 - Validation Photo & Feedback Positif
**Story ID:** 3.6
**Status:** Not Started
**Priority:** Critical
**Estimated Effort:** 4 hours

---

## User Story

**As a** user,
**I want** que ma validation mette à jour ma progression quotidienne,
**so that** je vois mon avancement vers l'objectif.

---

## Acceptance Criteria

1. Après sélection taille verre (Story 3.9 terminée), le use case `RecordHydrationUseCase` est appelé avec params: `photoPath` (String), `glassSize` (GlassSize enum)
   - Le use case crée un `HydrationLog` avec timestamp actuel (`DateTime.now()`), photoPath, glassSize, validated = true
   - Trigger exact: Navigation depuis `GlassSizeSelectionScreen` après tap sur option verre
2. Le log est sauvegardé via `HydrationLogRepository.addLog()`
3. Le `lastDrinkTime` de l'avatar est mis à jour via `AvatarRepository.updateLastDrinkTime(DateTime.now())` (réinitialise le timer de déshydratation)
4. L'état de l'avatar est immédiatement recalculé via `AvatarStateManager.recalculateState()` et retourne à `fresh` si déshydraté
5. Le volume total du jour est recalculé via `HydrationLogRepository.getTotalVolumeForDate(DateTime.now())`
6. La progression vers l'objectif est calculée : `(volumeToday / user.dailyGoal) × 100%` (plafonné à 100%)
7. Une analytics event est loggée `hydration_validated` avec propriétés (timestamp, glassSize) SI Firebase Analytics disponible, sinon skip silencieusement (pas d'erreur)
   - Implémentation: Wrapper try-catch autour `FirebaseAnalytics.logEvent()`, ignorer exception si Firebase mock/indisponible
   - Log debug si skip: "Analytics skipped - Firebase not available"
8. Tests unitaires valident la séquence complète : save log → update avatar → recalcul progression (avec mocks pour tous repositories)
9. Test d'intégration valide le flow end-to-end avec persistence réelle (SQLite + SharedPreferences)

---

## Technical Notes

- Location: `lib/domain/usecases/record_hydration_usecase.dart`
- Dependencies: HydrationLogRepository, AvatarRepository
- Analytics: Firebase Analytics
- Tests: `test/domain/usecases/record_hydration_usecase_test.dart`

---

## Dependencies

- Story 3.2 (HydrationLog repository) doit être complétée
- Story 3.9 (Glass size selection) doit être complétée (fournit glassSize parameter)
- Story 1.3 (Avatar repository) doit être complétée
- Story 1.5 (Dehydration logic) doit être complétée

---

## Definition of Done

- [ ] Tous les AC validés
- [ ] Tests unitaires passent
- [ ] Test d'intégration passe
- [ ] Avatar state update OK
- [ ] Progression calculée OK
- [ ] Analytics logged
- [ ] Code suit conventions
- [ ] PM approval

---

## Links

- Epic: [epic-3-photo-validation.md](../../epics/epic-3-photo-validation.md)
- Previous: [story-3.5-glass-detection.md](story-3.5-glass-detection.md)
- Next: [story-3.7-avatar-feedback-animation.md](story-3.7-avatar-feedback-animation.md)
