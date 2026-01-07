# Epic 5: Progression & Rétention (Streaks & Historique)

**Epic Goal:** Créer le système de streaks Duolingo-style avec compteur de jours consécutifs, implémenter le calendrier historique affichant les jours atteints/ratés, et développer un écran de profil/paramètres minimaliste pour configurer l'app. Ces mécaniques de rétention renforcent l'engagement quotidien et la motivation long-terme.

**Value Delivered:** À la fin de cet epic, les utilisateurs voient leur progression jour par jour, sont motivés à maintenir leur streak, et peuvent configurer l'app selon leurs préférences. L'app fournit tous les outils de rétention nécessaires pour transformer l'hydratation en habitude durable.

---

## Story 5.1: Modèle de Données Streak

**As a** developer,
**I want** un data model pour gérer les streaks,
**so that** je peux tracker les jours consécutifs d'objectif atteint.

### Acceptance Criteria

1. La classe `StreakData` contient les propriétés : `currentStreak` (int), `longestStreak` (int), `lastStreakDate` (DateTime), `streakActive` (bool)
2. Le model inclut une méthode `incrementStreak(date)` qui incrémente le streak si date = hier + 1 jour
3. Le model inclut une méthode `breakStreak()` qui reset `currentStreak` à 0 et `streakActive` à false
4. Le model inclut une méthode `isStreakActiveToday()` retournant bool (vérifie si objectif atteint aujourd'hui)
5. Le model met à jour `longestStreak` si `currentStreak` > `longestStreak`
6. Le model a des méthodes `toJson()` et `fromJson()` pour sérialisation
7. Tests unitaires couvrent 100% du model (increment, break, longest streak update)

---

## Story 5.2: Logique Calcul Streak Quotidien

**As a** user,
**I want** que mon streak augmente automatiquement si j'atteins mon objectif quotidien,
**so that** je vois ma progression sans action manuelle.

### Acceptance Criteria

1. Le use case `UpdateStreakUseCase` est appelé à minuit (00h00) chaque jour via background job
2. Le use case vérifie si l'objectif hydratation de la veille a été atteint via `HydrationLogRepository.getTotalVolumeForDate(yesterday)`
3. Si objectif atteint : `StreakData.incrementStreak(yesterday)` est appelé
4. Si objectif raté : `StreakData.breakStreak()` est appelé
5. Le streak est également vérifié à chaque ouverture de l'app (catch-up si app pas ouverte à minuit)
6. Si l'avatar est mort le jour précédent (état `ghost`), le streak NE s'incrémente PAS (pénalité)
7. Tests unitaires valident tous les scénarios : objectif atteint, raté, avatar mort, plusieurs jours consécutifs

---

## Story 5.3: Repository Streak

**As a** developer,
**I want** un repository pour persister les données de streak,
**so that** le compteur est sauvegardé entre les sessions.

### Acceptance Criteria

1. La classe `StreakRepository` implémente : `saveStreak()`, `getStreak()`, `resetStreak()`
2. Le repository utilise `shared_preferences` pour stocker les données de streak
3. La méthode `getStreak()` retourne le streak sauvegardé ou un streak par défaut (0 jours) si nouveau user
4. Le repository est injectable via `get_it`
5. Tests unitaires couvrent CRUD complet (save, get, reset)

---

## Story 5.4: Affichage Streak sur HomeScreen

**As a** user,
**I want** voir mon streak actuel sur l'écran principal,
**so that** je suis motivé à le maintenir.

### Acceptance Criteria

1. Le HomeScreen affiche un widget `StreakDisplay` en haut de l'écran (header position)
2. Le widget affiche : flame icon 🔥 + nombre de jours + label "jour(s) de suite"
3. Si `currentStreak` = 0 : affiche "Commence ton streak aujourd'hui ! 🔥"
4. Si `currentStreak` >= 7 : le flame icon change pour 🔥🔥 (double flame)
5. Si `currentStreak` >= 30 : le flame icon change pour 🏆 (trophée)
6. Le widget est tapable et ouvre un modal affichant : `currentStreak`, `longestStreak`, et un message motivant
7. Widget test valide l'affichage pour différentes valeurs de streak (0, 5, 10, 30)

---

## Story 5.5: Modèle de Données Calendrier Historique

**As a** developer,
**I want** une structure de données pour le calendrier historique,
**so that** je peux afficher les jours atteints/ratés.

### Acceptance Criteria

1. La classe `DayStatus` contient : `date` (DateTime), `goalAchieved` (bool), `volumeDrank` (double), `goalVolume` (double)
2. Une méthode helper `getMonthStatus(year, month)` retourne une liste de `DayStatus` pour tous les jours du mois
3. La méthode interroge `HydrationLogRepository` pour obtenir le volume par jour
4. La méthode compare `volumeDrank` vs `goalVolume` (depuis `UserProfile`) pour déterminer `goalAchieved`
5. Les jours futurs retournent `goalAchieved = null` (non applicable)
6. Tests unitaires valident le calcul pour un mois complet avec différents scénarios

---

## Story 5.6: Écran Calendrier Historique

**As a** user,
**I want** voir un calendrier de mes jours d'hydratation passés,
**so that** je peux visualiser ma progression sur le long terme.

### Acceptance Criteria

1. L'écran `CalendarScreen` est accessible via une icône calendrier dans la navigation ou depuis le HomeScreen
2. L'écran affiche un calendrier mensuel (vue mois par mois)
3. Chaque jour du mois affiche : ✓ (vert) si objectif atteint, ✗ (rouge) si raté, vide si futur ou pas de données
4. Le jour actuel est highlight avec un border distinct
5. Des flèches permettent de naviguer entre les mois (précédent/suivant)
6. Taper sur un jour passé affiche un modal avec détails : date, volume bu, objectif, pourcentage atteint
7. Un résumé mensuel s'affiche en bas : "15/30 jours objectif atteint" avec pourcentage
8. Widget test valide l'affichage du calendrier et la navigation entre mois
9. Widget test valide l'affichage des symboles ✓/✗ selon les données

---

## Story 5.7: Stats Minimalistes sur Écran Profil

**As a** user,
**I want** voir quelques statistiques simples de ma progression,
**so that** je comprends mes performances sans complexité excessive.

### Acceptance Criteria

1. Un écran `ProfileScreen` est accessible via navigation bottom bar ou menu
2. L'écran affiche en haut : avatar actuel, nom de personnalité, et bouton "Changer d'avatar" (ouvre sélection avatar)
3. Section "Mes Statistiques" affiche :
   - Streak actuel : X jours 🔥
   - Streak le plus long : X jours 🏆
   - Jours objectif atteint ce mois : X/30
   - Volume total bu ce mois : X.XL
4. Les stats sont calculées en temps réel à l'ouverture de l'écran
5. Un bouton "Voir calendrier complet" navigue vers `CalendarScreen`
6. Widget test valide l'affichage de toutes les stats

---

## Story 5.8: Écran Paramètres Minimaliste

**As a** user,
**I want** configurer les paramètres essentiels de l'app,
**so that** je peux adapter l'expérience à mes besoins.

### Acceptance Criteria

1. L'écran `SettingsScreen` est accessible depuis `ProfileScreen` ou menu principal
2. L'écran affiche les sections suivantes :
   - **Profil** : Modifier poids, âge, activité (re-calcule objectif hydratation)
   - **Notifications** : Lien vers `NotificationSettingsScreen` (Epic 4)
   - **Avatar** : Bouton "Changer d'avatar"
   - **Objectif** : Affichage objectif actuel + option "Recalculer" (si profil modifié)
   - **Données** : Bouton "Supprimer mon compte et mes données" (RGPD)
   - **À propos** : Version app, liens légaux (Privacy Policy, Terms)
3. Chaque modification est sauvegardée immédiatement
4. Le bouton "Supprimer mon compte" affiche une confirmation : "Es-tu sûr ? Toutes tes données seront supprimées définitivement."
5. Si confirmé : suppression de toutes les données (profil, avatar, logs, photos, streaks) via repositories
6. Après suppression : retour à l'écran onboarding (nouveau user flow)
7. Widget test valide l'affichage et la navigation vers sous-écrans
8. Test d'intégration valide la suppression complète des données

---

## Story 5.9: Modification Profil et Recalcul Objectif

**As a** user,
**I want** pouvoir modifier mes informations de profil,
**so that** mon objectif d'hydratation reste adapté si je change (poids, activité, etc.).

### Acceptance Criteria

1. Un écran `EditProfileScreen` accessible depuis `SettingsScreen`
2. L'écran affiche des champs éditables pour : Poids, Âge, Sexe, Niveau d'activité
3. Les champs sont pré-remplis avec les valeurs actuelles du profil
4. Les validations sont identiques à l'onboarding (ranges valides)
5. Un bouton "Enregistrer" sauvegarde les modifications via `UserProfileRepository.updateProfile()`
6. Après sauvegarde, l'objectif hydratation est recalculé automatiquement via `CalculateHydrationGoalUseCase`
7. Un message de confirmation s'affiche : "Profil mis à jour ! Nouvel objectif : X.XL/jour"
8. Widget test valide l'édition et la sauvegarde du profil

---

## Story 5.10: Changement d'Avatar Post-Onboarding

**As a** user,
**I want** pouvoir changer d'avatar après l'onboarding,
**so that** je peux essayer différentes personnalités.

### Acceptance Criteria

1. Un écran `ChangeAvatarScreen` accessible depuis `ProfileScreen` ou `SettingsScreen`
2. L'écran réutilise le composant `AvatarSelectionScreen` (Epic 1)
3. L'avatar actuellement sélectionné est highlight visuellement
4. Taper sur un nouvel avatar et confirmer sauvegarde la sélection via `AvatarRepository`
5. L'avatar change immédiatement sur le HomeScreen après confirmation
6. **IMPORTANT** : Changer d'avatar ne reset PAS le streak ni l'historique (continuité)
7. Un message de confirmation s'affiche : "[Nouveau nom avatar] est maintenant ton compagnon d'hydratation !"
8. Widget test valide le flow de changement et la sauvegarde

---

## Story 5.11: Achievements/Badges Simples (Optionnel)

**As a** user,
**I want** débloquer des badges simples pour mes accomplissements,
**so that** j'ai des objectifs secondaires motivants.

### Acceptance Criteria (si story incluse dans MVP)

1. Un modèle `Achievement` définit : `id`, `title`, `description`, `icon`, `unlocked` (bool), `unlockedDate`
2. Les achievements disponibles dans MVP :
   - "Premier verre" : Valider sa première hydratation
   - "Streak 7 jours" : Atteindre 7 jours consécutifs
   - "Streak 30 jours" : Atteindre 30 jours consécutifs
   - "Objectif parfait" : Atteindre exactement l'objectif quotidien (100%)
   - "Sauveur d'avatar" : Ressusciter un avatar mort
3. Les achievements sont vérifiés automatiquement après chaque action clé (validation, streak update, etc.)
4. Un achievement débloqué affiche une notification in-app : modal célébration + animation
5. Un écran `AchievementsScreen` accessible depuis `ProfileScreen` liste tous les achievements (locked/unlocked)
6. Widget test valide l'affichage des achievements et le système de déblocage
7. **Note** : Cette story est OPTIONNELLE pour MVP - peut être déplacée en V2 si trop complexe

---

## Story 5.12: Bottom Navigation Bar

**As a** user,
**I want** naviguer facilement entre les écrans principaux,
**so that** j'accède rapidement aux différentes fonctions de l'app.

### Acceptance Criteria

1. Une `BottomNavigationBar` est présente sur tous les écrans principaux
2. Les tabs disponibles : "Home" (🏠), "Calendrier" (📅), "Profil" (👤)
3. Le tab actif est highlight visuellement
4. Taper sur un tab navigue vers l'écran correspondant
5. La navigation préserve l'état des écrans (pas de reload à chaque switch)
6. Widget test valide la navigation entre les 3 tabs principaux

---

## Epic 5 Completion Checklist

- [ ] Toutes les stories 5.1 à 5.12 sont complétées avec acceptance criteria validés
- [ ] Le système de streaks fonctionne : incrémente quotidiennement si objectif atteint
- [ ] Le calendrier historique affiche correctement les jours ✓/✗
- [ ] Les stats sur le profil sont calculées correctement
- [ ] Les paramètres permettent de configurer l'app et supprimer les données (RGPD)
- [ ] Le changement d'avatar fonctionne sans casser le streak
- [ ] La navigation bottom bar est fluide et intuitive
- [ ] Tests automatiques passent (unit + widget + integration)
- [ ] Test manuel complet valide le flow utilisateur quotidien

---

**Previous Epic:** [Epic 4 - Système de Notifications Punitives](epic-4-notifications.md)

---

## 🎉 MVP COMPLET !

À la fin de l'Epic 5, **l'application Hydrate or Die MVP est complète** et prête pour :

1. **Testing interne** : Tests manuels exhaustifs, beta testing avec groupe restreint
2. **App Store submission** : Préparation assets, screenshots, description, soumission iOS/Android
3. **Lancement** : Marketing initial, SEO, partage réseaux sociaux
4. **Feedback & Iteration** : Collecte feedbacks users, analyse métriques, priorisation V2

**Prochaines étapes post-MVP :**
- Analyser les métriques de rétention (D1, D7, D30)
- Identifier les avatars préférés et messages les plus efficaces
- Planifier les features V2 : Avatars premium, Apple Watch, météo intelligente, stats avancées

**Félicitations pour avoir défini un MVP solide et exécutable ! 🚀💧**
