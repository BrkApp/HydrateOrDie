# Epic 1: Foundation & Avatar Core System

**Epic Goal:** Établir l'infrastructure projet complète (Flutter app, Firebase, CI/CD, tests) et implémenter le système d'avatar Tamagotchi avec ses 4 états de déshydratation et le système de mort temporaire/fantôme. Ce premier epic doit livrer une app fonctionnelle minimale avec avatar réactif.

**Value Delivered:** À la fin de cet epic, l'application peut être installée, un avatar peut être sélectionné et affiché avec ses différents états visuels basés sur un timer de déshydratation simulé. L'infrastructure CI/CD garantit la qualité du code dès le début.

---

## Story 1.1: Projet Flutter Initial avec CI/CD

**As a** developer,
**I want** un projet Flutter correctement configuré avec CI/CD et tests automatiques,
**so that** je peux développer avec confiance et qualité dès le premier jour.

### Acceptance Criteria

1. Le projet Flutter est créé avec structure Clean Architecture (core/, data/, domain/, presentation/)
2. Le fichier `pubspec.yaml` contient toutes les dépendances essentielles MVP (camera, flutter_local_notifications, permission_handler, shared_preferences, sqflite, firebase_core, riverpod/bloc, get_it)
3. La configuration Firebase est complète (iOS + Android) avec fichiers GoogleService-Info.plist et google-services.json
4. GitHub Actions CI/CD est configuré pour exécuter `flutter test` et `flutter analyze` sur chaque commit
5. Le projet build avec succès sur iOS (simulateur) et Android (émulateur) sans erreurs
6. Un écran canary simple "Hydrate or Die - Coming Soon" s'affiche au lancement de l'app (health-check visuel)
7. Les tests unitaires de base passent (au minimum un test dummy pour valider la CI)
8. Le README contient les instructions de setup (Flutter version, Firebase config, commandes build)

---

## Story 1.2: Modèles de Données Avatar

**As a** developer,
**I want** les data models pour les avatars et leurs états,
**so that** je peux structurer proprement les données avatar dans l'application.

### Acceptance Criteria

1. La classe `Avatar` est créée avec les propriétés : `id`, `name`, `personality`, `currentState`, `imageAssetPath`
2. L'enum `AvatarState` définit les 4 états : `fresh`, `tired`, `dehydrated`, `dead`
3. L'enum `AvatarPersonality` définit les 4 personnalités MVP : `authoritarianMother`, `sportsCoach`, `doctor`, `sarcasticFriend`
4. La classe `AvatarState` inclut une méthode `getNextState()` pour progression déshydratation
5. La classe `AvatarState` inclut une méthode `shouldDie(Duration timeSinceLastDrink)` retournant bool
6. Tous les models ont des méthodes `toJson()` et `fromJson()` pour sérialisation
7. Tests unitaires couvrent 100% des models (création, sérialisation, logique état)

---

## Story 1.3: Repository Avatar avec Persistence Locale

**As a** developer,
**I want** un repository pour persister et récupérer les données avatar,
**so that** l'avatar sélectionné et son état sont sauvegardés entre les sessions.

### Acceptance Criteria

1. La classe `AvatarRepository` implémente les méthodes : `saveSelectedAvatar()`, `getSelectedAvatar()`, `updateAvatarState()`, `getAvatarState()`
2. Le repository utilise `shared_preferences` pour stocker l'avatar ID sélectionné
3. Le repository utilise `sqflite` pour stocker l'état actuel de l'avatar (state, lastUpdated timestamp)
4. La méthode `getAvatarState()` retourne l'état sauvegardé ou `fresh` par défaut si nouvelle installation
5. Les timestamps sont stockés en UTC ISO 8601 format
6. Le repository est injectable via `get_it`
7. Tests unitaires couvrent tous les scénarios (save, get, update, avatar non sélectionné)
8. Tests d'intégration valident la persistence réelle avec sqflite et shared_preferences

---

## Story 1.4: Assets Visuels Avatars (4 États x 4 Avatars)

**As a** user,
**I want** voir des avatars visuellement distincts et expressifs,
**so that** je peux créer un lien émotionnel avec mon avatar.

### Acceptance Criteria

1. 4 avatars sont disponibles avec assets graphiques pour chaque état (16 images total minimum ou animations Lottie)
2. Chaque avatar a des assets pour : Fresh (souriant), Tired (fatigué), Dehydrated (desséché visiblement), Dead (effondré/skull)
3. Les assets sont placés dans `assets/images/avatars/` ou `assets/animations/avatars/` selon le format
4. Le fichier `pubspec.yaml` déclare tous les assets correctement
5. Les images sont optimisées (<500KB par asset) pour ne pas alourdir l'app
6. Un widget `AvatarDisplay` affiche l'avatar correct basé sur `AvatarState` et `AvatarPersonality`
7. Widget test valide que `AvatarDisplay` affiche bien l'image correspondante pour chaque combinaison état/personnalité

---

## Story 1.5: Logique de Déshydratation Progressive

**As a** user,
**I want** que mon avatar se déshydrate progressivement si je ne bois pas,
**so that** je ressens l'urgence de m'hydrater.

### Acceptance Criteria

1. Le use case `UpdateAvatarStateUseCase` calcule l'état actuel basé sur le temps écoulé depuis la dernière hydratation
2. La progression suit : Fresh (0-2h) → Tired (2-4h) → Dehydrated (4-6h) → Dead (6h+)
3. Le calcul utilise `DateTime.now()` comparé au timestamp `lastDrinkTime` stocké
4. Le use case est appelé automatiquement à l'ouverture de l'app et périodiquement en background (toutes les 30min via timer)
5. L'état de l'avatar est mis à jour dans le repository après calcul
6. Les transitions d'état sont loggées pour debug (niveau info)
7. Tests unitaires couvrent tous les scénarios temporels (0h, 1h, 3h, 5h, 7h après last drink)
8. Le timer background utilise `Timer.periodic` et est annulé proprement lors de la fermeture de l'app

---

## Story 1.6: Écran Principal avec Avatar Réactif

**As a** user,
**I want** voir mon avatar et son état actuel sur l'écran principal,
**so that** je sais immédiatement si je dois boire.

### Acceptance Criteria

1. L'écran `HomeScreen` affiche l'avatar sélectionné au centre (taille proéminente, 50% de la hauteur écran)
2. L'avatar affiché correspond à l'état calculé en temps réel (fresh/tired/dehydrated/dead)
3. Un texte indique l'état actuel avec ton correspondant à la personnalité (ex: "Je vais bien !" / "J'ai soif..." / "AIDE-MOI !" / "💀")
4. Le temps écoulé depuis la dernière hydratation est affiché (ex: "Dernière hydratation : il y a 3h12")
5. L'écran se rafraîchit automatiquement toutes les 60 secondes pour refléter la progression
6. Un bouton "Je bois" est présent (non fonctionnel pour cette story, juste UI)
7. Le state management (Riverpod/Bloc) gère l'état de l'avatar réactivement
8. Widget test valide l'affichage correct de l'avatar et des informations pour chaque état

---

## Story 1.7: Système Fantôme (Mort Temporaire)

**As a** user,
**I want** que mon avatar devienne un fantôme s'il meurt au lieu de disparaître définitivement,
**so that** je peux continuer à utiliser l'app même après un échec.

### Acceptance Criteria

1. Un nouvel état `ghost` est ajouté à l'enum `AvatarState` (5 états total)
2. Quand l'avatar atteint l'état `dead`, il passe automatiquement en état `ghost` après 10 secondes
3. Le fantôme a un asset visuel distinct (version transparente/spectrale de l'avatar)
4. En état `ghost`, un message s'affiche : "Ton avatar est mort aujourd'hui... Il reviendra demain." avec ton dramatique
5. À minuit (00h00 locale), le fantôme ressuscite automatiquement en état `fresh` via background job
6. La résurrection réinitialise `lastDrinkTime` à `DateTime.now()`
7. Tests unitaires valident la transition `dead` → `ghost` et `ghost` → `fresh` à minuit
8. Un widget test valide l'affichage du fantôme avec le message approprié

---

## Story 1.8: Sélection Initiale Avatar

**As a** new user,
**I want** choisir mon avatar lors de la première utilisation,
**so that** je peux personnaliser mon expérience.

### Acceptance Criteria

1. Un écran `AvatarSelectionScreen` s'affiche au premier lancement de l'app (si aucun avatar sauvegardé)
2. L'écran affiche les 4 avatars disponibles en galerie (2x2 grid ou carrousel horizontal)
3. Chaque avatar montre : image preview (état fresh), nom, et description courte personnalité (1 phrase)
4. L'utilisateur peut taper sur un avatar pour le sélectionner (highlight visuel)
5. Un bouton "Confirmer" valide la sélection et sauvegarde via `AvatarRepository`
6. Après confirmation, l'app navigue vers `HomeScreen` avec l'avatar sélectionné
7. Les lancements suivants skip cet écran et chargent directement l'avatar sauvegardé
8. Widget test valide le flow de sélection et la navigation

---

## Epic 1 Completion Checklist

- [ ] Toutes les stories 1.1 à 1.8 sont complétées avec acceptance criteria validés
- [ ] L'app build sans erreur sur iOS et Android
- [ ] Les tests automatiques passent (CI green)
- [ ] Code review effectué (pair programming avec Claude ou autre dev)
- [ ] L'app est testable manuellement : sélection avatar → voir avatar se déshydrater → voir fantôme → résurrection
- [ ] Documentation technique mise à jour (architecture decisions, setup)

---

**Next Epic:** [Epic 2 - Onboarding & Personnalisation](epic-2-onboarding.md)
