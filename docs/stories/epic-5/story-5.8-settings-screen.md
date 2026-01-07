# Story 5.8: Écran Paramètres Minimaliste

**Epic:** Epic 5 - Progression & Rétention (Streaks & Historique)
**Story ID:** 5.8
**Status:** Not Started
**Priority:** High
**Estimated Effort:** 5 hours

---

## User Story

**As a** user,
**I want** configurer les paramètres essentiels de l'app,
**so that** je peux adapter l'expérience à mes besoins.

---

## Acceptance Criteria

1. L'écran `SettingsScreen` est accessible depuis `ProfileScreen` ou menu principal
2. L'écran affiche les sections suivantes : **Profil** : Modifier poids, âge, activité (re-calcule objectif hydratation), **Notifications** : Lien vers `NotificationSettingsScreen` (Epic 4), **Avatar** : Bouton "Changer d'avatar", **Objectif** : Affichage objectif actuel + option "Recalculer" (si profil modifié), **Données** : Bouton "Supprimer mon compte et mes données" (RGPD), **À propos** : Version app, liens légaux (Privacy Policy, Terms)
3. Chaque modification est sauvegardée immédiatement
4. Le bouton "Supprimer mon compte" affiche une confirmation : "Es-tu sûr ? Toutes tes données seront supprimées définitivement."
5. Si confirmé : suppression de toutes les données (profil, avatar, logs, photos, streaks) via repositories
6. Après suppression : retour à l'écran onboarding (nouveau user flow)
7. Widget test valide l'affichage et la navigation vers sous-écrans
8. Test d'intégration valide la suppression complète des données

---

## Technical Notes

- Location: `lib/presentation/screens/settings/settings_screen.dart`
- Sections: Profile, Notifications, Avatar, Goal, Data, About
- Data deletion: Clear all repositories
- Tests: `test/presentation/screens/settings/settings_screen_test.dart`

---

## Dependencies

- Story 5.7 (Profile screen) doit être complétée
- Story 4.11 (Notification settings) doit être complétée

---

## Definition of Done

- [ ] Tous les AC validés
- [ ] Widget tests passent
- [ ] Integration test passe
- [ ] All sections present
- [ ] Data deletion works
- [ ] RGPD compliant
- [ ] Code suit conventions
- [ ] PM approval

---

## Links

- Epic: [epic-5-progression.md](../../epics/epic-5-progression.md)
- Previous: [story-5.7-profile-stats.md](story-5.7-profile-stats.md)
- Next: [story-5.9-edit-profile.md](story-5.9-edit-profile.md)
