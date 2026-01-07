# Epic 3: Validation Photo & Feedback Positif

**Epic Goal:** Implémenter la validation par selfie avec interface caméra guidée, stockage local des photos, détection basique de présence de verre, et animations de feedback positif de l'avatar après validation. Cette mécanique est le cœur de l'engagement utilisateur et du différenciateur produit.

**Value Delivered:** À la fin de cet epic, les utilisateurs peuvent valider leur hydratation en prenant un selfie avec un verre d'eau, l'avatar réagit positivement avec animations, et la progression vers l'objectif quotidien est mise à jour. Le système empêche la triche facile et renforce l'attachement émotionnel via le feedback positif.

---

## Story 3.1: Modèle de Données Validation Hydratation

**As a** developer,
**I want** un data model pour les validations d'hydratation,
**so that** je peux tracker l'historique des verres bus.

### Acceptance Criteria

1. La classe `HydrationLog` contient les propriétés : `id` (UUID), `timestamp` (DateTime), `photoPath` (String), `glassSize` (enum), `validated` (bool)
2. L'enum `GlassSize` définit : `small` (200ml), `medium` (250ml), `large` (400ml), par défaut `medium`
3. Le model inclut une méthode `volumeLiters()` retournant le volume en litres basé sur `glassSize`
4. Le model a des méthodes `toJson()` et `fromJson()` pour sérialisation
5. Tests unitaires couvrent 100% du model (création, sérialisation, calcul volume)

---

## Story 3.2: Repository Historique Hydratation

**As a** developer,
**I want** un repository pour persister l'historique des validations,
**so that** la progression quotidienne est sauvegardée et calculable.

### Acceptance Criteria

1. La classe `HydrationLogRepository` implémente : `addLog()`, `getLogsForDate()`, `getTodayLogs()`, `getTotalVolumeForDate()`, `deleteOldLogs()`
2. Le repository utilise `sqflite` pour stocker les logs dans une table `hydration_logs`
3. Le schéma de table inclut toutes les propriétés du `HydrationLog` model + index sur `timestamp`
4. La méthode `getTodayLogs()` retourne tous les logs du jour actuel (00h00 - 23h59 UTC locale)
5. La méthode `getTotalVolumeForDate(date)` somme tous les volumes pour la date donnée
6. La méthode `deleteOldLogs()` supprime les logs de plus de 90 jours (RGPD + performance)
7. Le repository est injectable via `get_it`
8. Tests unitaires couvrent tous les scénarios (add, get today, get by date, volume calculation, delete old)
9. Tests d'intégration valident la persistence réelle et les requêtes de date

---

## Story 3.3: Interface Caméra Guidée pour Selfie

**As a** user,
**I want** une interface caméra simple et guidée pour prendre mon selfie,
**so that** la validation photo est rapide et sans friction.

### Acceptance Criteria

1. L'écran `PhotoValidationScreen` s'ouvre lorsque l'utilisateur tape le bouton "Je bois" sur HomeScreen
2. L'écran affiche la caméra frontale en plein écran avec preview live
3. Un cadre visuel (overlay semi-transparent) guide le positionnement : zone visage + zone verre
4. Des instructions texte s'affichent : "Prends un selfie avec ton verre d'eau 💧"
5. Un bouton de capture proéminent (icône caméra) est placé au centre bas
6. Un bouton "Annuler" permet de revenir au HomeScreen sans validation
7. La permission caméra est demandée automatiquement si pas encore accordée
8. Si permission caméra refusée : message d'erreur + redirection vers paramètres système
9. Widget test valide l'affichage de l'interface et les boutons (mock caméra)

---

## Story 3.4: Capture et Stockage Photo Locale

**As a** user,
**I want** que mes photos selfies soient sauvegardées localement,
**so that** j'ai une preuve de mes validations et mes données restent privées.

### Acceptance Criteria

1. Lorsque l'utilisateur tape le bouton capture, la photo est prise via `camera` package
2. La photo est sauvegardée dans le répertoire app local (iOS: Application Documents, Android: Internal Storage)
3. Le nom de fichier suit le format : `hydration_YYYYMMDD_HHmmss.jpg` (ex: `hydration_20260107_143022.jpg`)
4. La photo est compressée à qualité 80% pour limiter la taille (<500KB par photo)
5. Le chemin complet de la photo est retourné et utilisé pour créer le `HydrationLog`
6. Les photos de plus de 90 jours sont supprimées automatiquement (cleanup job nocturne)
7. Gestion d'erreur : si échec sauvegarde (storage plein), message d'erreur clair
8. Tests unitaires valident la logique de nommage et compression
9. Test d'intégration valide la sauvegarde réelle sur device/simulateur

---

## Story 3.5: Détection Basique Présence Verre (Optionnel)

**As a** product owner,
**I want** une détection basique pour vérifier qu'un verre est présent dans la photo,
**so that** on réduit la triche trop facile (photo sans verre).

### Acceptance Criteria

1. Après capture, un use case `ValidatePhotoUseCase` analyse l'image via détection basique
2. La détection utilise une heuristique simple : recherche de formes circulaires/cylindriques (OpenCV basic ou ML Kit)
3. Si aucune forme détectée : message warning "On ne voit pas de verre... Tu es sûr ? 🤔" avec options "Oui je confirme" / "Reprendre photo"
4. Si "Oui je confirme" : validation acceptée quand même (warning, pas blocage)
5. Si forme détectée : validation immédiate sans warning
6. La détection ne doit pas prendre plus de 2 secondes (timeout)
7. En cas d'erreur détection : fallback vers validation directe (pas de blocage)
8. **Note:** Cette story est OPTIONNELLE pour MVP - peut être remplacée par validation manuelle simple
9. Tests unitaires valident la logique avec images mock (verre présent / absent)

---

## Story 3.6: Enregistrement Validation et Update Progression

**As a** user,
**I want** que ma validation mette à jour ma progression quotidienne,
**so that** je vois mon avancement vers l'objectif.

### Acceptance Criteria

1. Après confirmation photo, le use case `RecordHydrationUseCase` crée un `HydrationLog` avec timestamp actuel et photoPath
2. Le log est sauvegardé via `HydrationLogRepository.addLog()`
3. Le `lastDrinkTime` de l'avatar est mis à jour via `AvatarRepository` (réinitialise le timer de déshydratation)
4. L'état de l'avatar est immédiatement recalculé et retourne à `fresh` si déshydraté
5. Le volume total du jour est recalculé via `getTotalVolumeForDate(today)`
6. La progression vers l'objectif est calculée : `(volumeToday / dailyGoal) × 100%`
7. Une analytics event est loggée : `hydration_validated` avec propriétés (timestamp, glassSize)
8. Tests unitaires valident la séquence complète : save log → update avatar → recalcul progression
9. Test d'intégration valide le flow end-to-end avec persistence réelle

---

## Story 3.7: Animations Avatar Feedback Positif

**As a** user,
**I want** que mon avatar réagisse positivement quand je bois,
**so that** je ressens une récompense émotionnelle et renforce mon engagement.

### Acceptance Criteria

1. Après validation réussie, l'app navigue vers un écran `FeedbackScreen` temporaire (3-5 secondes)
2. L'avatar s'affiche avec animation positive : danse, saut de joie, ou remerciement (Lottie animation ou sprite sheet)
3. Un message positif s'affiche adapté à la personnalité de l'avatar (ex: Mère: "Bien joué mon chéri !", Coach: "YEAH ! Continue comme ça !", Docteur: "Excellent réflexe.", Ami: "T'es un champion 🏆")
4. Un effet sonore positif (optionnel, peut être désactivé) joue : applaudissements, ding, ou fanfare courte
5. L'écran affiche aussi la progression : "Tu as bu X.XL sur X.XL aujourd'hui" avec barre de progression visuelle
6. Après 3-5 secondes, retour automatique au HomeScreen avec avatar maintenant en état `fresh`
7. Un bouton "Continuer" permet de skip l'attente et retourner immédiatement au HomeScreen
8. Widget test valide l'affichage de l'animation, du message, et de la progression

---

## Story 3.8: Bouton "Je bois" sur HomeScreen

**As a** user,
**I want** un bouton clair et accessible sur l'écran principal pour valider mon hydratation,
**so that** l'action principale est toujours à portée de main.

### Acceptance Criteria

1. Le HomeScreen (Epic 1) affiche un bouton primaire proéminent "Je bois 💧" en bas de l'écran
2. Le bouton utilise la couleur primaire de l'app (bleu hydratation) et est suffisamment large (taille minimum 60dp hauteur pour accessibilité)
3. Taper le bouton ouvre immédiatement le `PhotoValidationScreen` (Story 3.3)
4. Le bouton reste accessible même si l'avatar est en état `dead` ou `ghost` (permet de ressusciter plus tôt)
5. Si l'objectif quotidien est déjà atteint, le bouton affiche "Je bois encore +" (permet de dépasser l'objectif)
6. Widget test valide l'affichage du bouton et la navigation vers PhotoValidationScreen

---

## Story 3.9: Sélection Taille de Verre

**As a** user,
**I want** indiquer la taille de mon verre après la photo,
**so that** le volume enregistré correspond à ce que j'ai réellement bu.

### Acceptance Criteria

1. Après capture photo (et avant/après validation photo), un écran `GlassSizeSelectionScreen` s'affiche
2. L'écran affiche trois options : "Petit verre (200ml)", "Verre moyen (250ml)", "Grand verre (400ml)"
3. Chaque option affiche un icon visuel de verre proportionnel à la taille
4. L'option "Verre moyen" est pré-sélectionnée par défaut
5. Taper une option la sélectionne et navigue vers FeedbackScreen (Story 3.7)
6. Le `glassSize` sélectionné est passé au `RecordHydrationUseCase` pour enregistrement
7. Widget test valide la sélection et la navigation

---

## Story 3.10: Gestion Permissions Caméra

**As a** user,
**I want** être guidé clairement si je n'ai pas accordé la permission caméra,
**so that** je peux facilement corriger et utiliser l'app.

### Acceptance Criteria

1. Au premier lancement de `PhotoValidationScreen`, la permission caméra est demandée via `permission_handler`
2. Si permission accordée : caméra s'ouvre normalement
3. Si permission refusée : écran affiche un message "Caméra nécessaire pour validation" avec explication + bouton "Ouvrir Paramètres"
4. Le bouton "Ouvrir Paramètres" utilise `openAppSettings()` pour rediriger vers les settings système
5. Après retour des settings, l'app re-vérifie la permission automatiquement
6. Si permission "refusée définitivement" (Android), affichage permanent du message paramètres
7. Un bouton "Annuler" permet de revenir au HomeScreen sans validation
8. Tests unitaires valident la logique de demande et gestion des états de permission
9. Widget test valide l'affichage du message d'erreur et du bouton paramètres

---

## Epic 3 Completion Checklist

- [ ] Toutes les stories 3.1 à 3.10 sont complétées avec acceptance criteria validés
- [ ] Le flow photo complet fonctionne : HomeScreen → Photo → Sélection taille → Feedback → HomeScreen
- [ ] Les photos sont sauvegardées localement et visibles dans le storage app
- [ ] L'avatar réagit positivement avec animations après validation
- [ ] La progression quotidienne se met à jour correctement
- [ ] Les permissions caméra sont gérées sans crash
- [ ] Tests automatiques passent (unit + widget + integration)
- [ ] Test manuel complet du flow photo réussi

---

**Previous Epic:** [Epic 2 - Onboarding & Personnalisation](epic-2-onboarding.md)
**Next Epic:** [Epic 4 - Système de Notifications Punitives](epic-4-notifications.md)
