# Epic 4: Système de Notifications Punitives

**Epic Goal:** Développer le système d'escalade progressive des notifications sur 4 niveaux (calme → préoccupé → mélodramatique → spam chaos), implémenter le spam aléatoire intelligent avec intervalles imprévisibles, créer les messages personnalisés par avatar avec vulgarité censurée et humour absurde, et ajouter les vibrations agaçantes. Ce système est le cœur de la mécanique "punitive" du concept.

**Value Delivered:** À la fin de cet epic, l'application envoie des rappels progressivement plus insistants et mélodramatiques si l'utilisateur ne boit pas, avec un ton unique et mémorable adapté à chaque avatar. Le système maximise l'engagement via l'agacement bienveillant sans être bloquable facilement.

---

## Story 4.1: Modèle de Données Notification System

**As a** developer,
**I want** un data model pour gérer l'état du système de notifications,
**so that** je peux tracker le niveau d'escalade et le timing des notifications.

### Acceptance Criteria

1. La classe `NotificationState` contient les propriétés : `currentLevel` (enum), `lastNotificationTime` (DateTime), `notificationsSentToday` (int), `userLastDrinkTime` (DateTime)
2. L'enum `NotificationLevel` définit les 4 niveaux : `calm`, `concerned`, `dramatic`, `chaos`
3. Le model inclut une méthode `shouldEscalate()` retournant bool basé sur le temps écoulé
4. Le model inclut une méthode `getNextLevel()` pour progression niveau
5. Le model inclut une méthode `reset()` pour réinitialiser à `calm` après hydratation
6. Le model a des méthodes `toJson()` et `fromJson()` pour sérialisation
7. Tests unitaires couvrent 100% du model (création, logique escalade, reset)

---

## Story 4.2: Algorithme Escalade Progressive

**As a** product owner,
**I want** que les notifications évoluent progressivement selon le temps écoulé,
**so that** l'utilisateur ressent une pression croissante mais pas immédiate.

### Acceptance Criteria

1. Le use case `CalculateNotificationLevelUseCase` détermine le niveau basé sur le temps écoulé depuis `lastDrinkTime`
2. La progression suit : Calm (0-2h), Concerned (2h-4h), Dramatic (4h-6h), Chaos (6h+)
3. Chaque niveau a une fréquence différente : Calm (1x/heure), Concerned (1x/30min), Dramatic (1x/15min), Chaos (spam 5-10min aléatoire)
4. Le niveau ne peut pas redescendre sans action utilisateur (escalade unidirectionnelle dans la journée)
5. À minuit, le niveau reset automatiquement à `calm` (nouveau jour = fresh start)
6. Le calcul prend en compte le dernier `lastDrinkTime` depuis `AvatarRepository`
7. Tests unitaires valident la progression pour différentes durées (0h, 1h, 3h, 5h, 7h)
8. Tests valident que le niveau ne redescend pas sans hydratation

---

## Story 4.3: Repository Notification State

**As a** developer,
**I want** un repository pour persister l'état des notifications,
**so that** le niveau d'escalade est sauvegardé entre les sessions.

### Acceptance Criteria

1. La classe `NotificationStateRepository` implémente : `saveState()`, `getState()`, `resetState()`, `incrementNotificationCount()`
2. Le repository utilise `shared_preferences` pour stocker l'état de notification
3. La méthode `getState()` retourne l'état sauvegardé ou un état par défaut (`calm`, 0 notifications) si nouveau jour
4. La méthode `resetState()` réinitialise le niveau à `calm` et `notificationsSentToday` à 0
5. Le repository détecte automatiquement le changement de jour et reset l'état
6. Le repository est injectable via `get_it`
7. Tests unitaires couvrent CRUD complet et détection changement de jour

---

## Story 4.4: Messages Personnalisés par Avatar et Niveau

**As a** user,
**I want** que les messages de notification reflètent la personnalité de mon avatar,
**so that** l'expérience est cohérente et mémorable.

### Acceptance Criteria

1. Une classe `NotificationMessageProvider` génère les messages basés sur `AvatarPersonality` et `NotificationLevel`
2. Chaque combinaison (4 avatars × 4 niveaux = 16 cas) a un pool de 5-10 messages variés
3. **Mère Autoritaire** :
   - Calm: "Mon chéri, pense à boire de l'eau 💧"
   - Concerned: "Ça fait 3h que tu n'as pas bu ! Je m'inquiète..."
   - Dramatic: "TU VEUX FINIR AUX URGENCES ?! BOIS MAINTENANT !"
   - Chaos: "P*T@IN MAIS BOIS !!! 😤😤😤"
4. **Coach Sportif** :
   - Calm: "Hydrate-toi champion ! 💪"
   - Concerned: "Allez, un p'tit verre ! Ton corps en a besoin !"
   - Dramatic: "NO PAIN NO GAIN MAIS LÀ C'EST JUSTE STUPIDE ! BOIS !!"
   - Chaos: "BOUUUUGE-TOI !!! 🔥 EAU MAINTENANT !!! 🔥"
5. **Docteur** :
   - Calm: "Je vous recommande de vous hydrater."
   - Concerned: "Vos reins souffrent. Hydratation nécessaire."
   - Dramatic: "DÉSHYDRATATION CRITIQUE ! Intervention requise !"
   - Chaos: "CODE ROUGE ! H2O STAT !!! 🚨"
6. **Ami Sarcastique** :
   - Calm: "Yo, tu devrais boire un coup (d'eau hein)"
   - Concerned: "Sérieux, tu ressembles à une plante morte là..."
   - Dramatic: "Bon bah RIP toi je suppose 💀 C'était sympa te connaître"
   - Chaos: "BORDEL BOIS OU JE DÉMISSIONNE !!! 😡"
7. Les messages incluent emojis, vulgarité censurée (p*t@in, b*rd*l), et références pop culture
8. La méthode `getRandomMessage(personality, level)` retourne un message aléatoire du pool
9. Tests unitaires valident qu'un message existe pour chaque combinaison et contient le bon ton

---

## Story 4.5: Scheduling Notifications Locales

**As a** user,
**I want** recevoir des notifications push même quand l'app est fermée,
**so that** les rappels fonctionnent en background.

### Acceptance Criteria

1. Le use case `ScheduleNotificationUseCase` utilise `flutter_local_notifications` pour scheduler les notifications
2. Les notifications sont schedulées avec intervalles basés sur le niveau : Calm (1h), Concerned (30min), Dramatic (15min), Chaos (aléatoire 5-10min)
3. Le titre de la notification affiche le nom de l'avatar (ex: "Maman dit :", "Coach Mike :", "Dr. Martin :", "Alex dit :")
4. Le body contient le message généré par `NotificationMessageProvider`
5. Les notifications utilisent une icône custom (goutte d'eau ou avatar icon)
6. En mode Chaos, l'intervalle aléatoire est calculé via `Random().nextInt(300) + 300` secondes (5-10min)
7. Les notifications sont annulées et re-schedulées après chaque hydratation validée
8. Tests unitaires valident la logique de scheduling pour chaque niveau
9. Tests d'intégration valident que les notifications apparaissent réellement (sur device/simulateur)

---

## Story 4.6: Vibrations Agaçantes en Mode Chaos

**As a** user,
**I want** que les notifications en mode chaos utilisent des vibrations insistantes,
**so that** je ne peux pas les ignorer facilement.

### Acceptance Criteria

1. En niveau `chaos`, les notifications déclenchent un pattern de vibration custom
2. Le pattern utilise : [0, 300, 100, 300, 100, 500] (pause, vibrate, pause, vibrate, pause, long vibrate)
3. Les vibrations ne sont actives QUE en mode chaos (pas pour calm, concerned, dramatic)
4. L'utilisateur peut désactiver les vibrations dans les paramètres (toggle "Vibrations actives")
5. La désactivation est sauvegardée dans `shared_preferences`
6. Tests unitaires valident que le pattern de vibration est appliqué uniquement en chaos
7. Test manuel sur device réel valide que les vibrations sont effectivement agaçantes mais pas excessives

---

## Story 4.7: Pause Automatique Notifications Nocturnes

**As a** user,
**I want** que les notifications s'arrêtent automatiquement la nuit,
**so that** je peux dormir sans être dérangé.

### Acceptance Criteria

1. Les notifications ne sont PAS envoyées entre 22h00 et 7h00 (heure locale par défaut)
2. Les horaires de pause sont configurables dans les paramètres : "Heure début pause", "Heure fin pause"
3. Les paramètres sont sauvegardés dans `shared_preferences`
4. Le use case `ScheduleNotificationUseCase` vérifie l'heure actuelle avant de scheduler
5. Si dans la fenêtre de pause, la notification est reportée à la fin de la pause (7h00 par défaut)
6. Un message dans les paramètres explique : "Les notifications seront en pause pendant tes heures de sommeil"
7. Tests unitaires valident que les notifications sont bien bloquées pendant la pause
8. Tests valident que les notifications reprennent après la fin de la pause

---

## Story 4.8: Gestion Permissions Notifications

**As a** user,
**I want** être guidé pour activer les notifications si je les ai refusées,
**so that** l'app peut fonctionner correctement.

### Acceptance Criteria

1. Au premier lancement post-onboarding, la permission notifications est demandée via `permission_handler`
2. Si permission accordée : notifications fonctionnent normalement
3. Si permission refusée : un banner persistant s'affiche sur HomeScreen : "Active les notifications pour profiter pleinement de l'app 🔔"
4. Le banner a un bouton "Activer" qui ouvre `openAppSettings()` vers les settings système
5. Le statut de permission est vérifié à chaque ouverture de l'app
6. Si permission accordée après refus initial, le banner disparaît automatiquement
7. Un toggle dans les paramètres permet de "Mettre en pause les notifications" temporairement (sans les désactiver système)
8. Tests unitaires valident la logique de demande et vérification de permission
9. Widget test valide l'affichage du banner et du bouton

---

## Story 4.9: Background Job Update Niveau Escalade

**As a** developer,
**I want** un background job qui met à jour le niveau d'escalade périodiquement,
**so that** les notifications reflètent le temps réel écoulé.

### Acceptance Criteria

1. Un `Timer.periodic` avec intervalle de 15 minutes vérifie le temps écoulé depuis `lastDrinkTime`
2. Le timer appelle `CalculateNotificationLevelUseCase` pour recalculer le niveau actuel
3. Si le niveau a changé (escalade), les notifications schedulées sont annulées et re-schedulées avec la nouvelle fréquence
4. Le timer est initialisé au lancement de l'app et tourne en background
5. Le timer est annulé proprement lors de la fermeture de l'app (cleanup)
6. Le niveau mis à jour est sauvegardé via `NotificationStateRepository`
7. Tests unitaires valident la logique du timer et le re-scheduling
8. Test d'intégration valide que le timer fonctionne réellement en background

---

## Story 4.10: Analytics Notifications

**As a** product owner,
**I want** tracker les métriques de notifications,
**so that** je peux analyser l'efficacité du système.

### Acceptance Criteria

1. Chaque notification envoyée logge un event analytics : `notification_sent` avec propriétés : `level`, `personality`, `timeSinceLastDrink`
2. Chaque tap sur notification logge : `notification_opened` avec mêmes propriétés
3. Le taux de dismiss (notification fermée sans action) est trackable via analytics
4. À la fin de la journée, un event summary logge : `daily_notification_summary` avec : `totalSent`, `maxLevelReached`, `notificationsThatTriggeredHydration`
5. Les analytics utilisent Firebase Analytics (anonymisées)
6. Tests unitaires valident que les events sont loggés aux bons moments

---

## Story 4.11: Écran Paramètres Notifications

**As a** user,
**I want** pouvoir configurer le comportement des notifications,
**so that** je peux adapter l'app à mes préférences.

### Acceptance Criteria

1. Un écran `NotificationSettingsScreen` accessible depuis le menu paramètres principal
2. L'écran affiche les options configurables :
   - Toggle "Notifications actives" (on/off global)
   - Toggle "Vibrations actives" (on/off pour mode chaos)
   - Time Picker "Heure début pause" (par défaut 22h00)
   - Time Picker "Heure fin pause" (par défaut 7h00)
   - Info text: "Le niveau d'escalade s'adapte automatiquement selon ton hydratation"
3. Toutes les modifications sont sauvegardées immédiatement dans `shared_preferences`
4. Les changements s'appliquent immédiatement (re-schedule des notifications si nécessaire)
5. Widget test valide l'affichage et la sauvegarde des paramètres

---

## Epic 4 Completion Checklist

- [ ] Toutes les stories 4.1 à 4.11 sont complétées avec acceptance criteria validés
- [ ] Le système d'escalade fonctionne : calm → concerned → dramatic → chaos
- [ ] Les messages sont différenciés par avatar et mémorables
- [ ] Les notifications arrivent en background même app fermée
- [ ] Les vibrations en mode chaos sont fonctionnelles et agaçantes (mais pas excessives)
- [ ] La pause nocturne fonctionne correctement
- [ ] Les permissions notifications sont gérées sans crash
- [ ] Tests automatiques passent (unit + widget + integration)
- [ ] Test manuel complet sur plusieurs heures valide l'escalade

---

**Previous Epic:** [Epic 3 - Validation Photo & Feedback Positif](epic-3-photo-validation.md)
**Next Epic:** [Epic 5 - Progression & Rétention (Streaks & Historique)](epic-5-progression.md)
