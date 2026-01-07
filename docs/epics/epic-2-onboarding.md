# Epic 2: Onboarding & Personnalisation

**Epic Goal:** Créer un flow d'onboarding en 5 questions pour collecter les informations utilisateur (poids, âge, sexe, activité, localisation), implémenter l'algorithme de calcul d'objectif hydratation personnalisé basé sur ces données, et permettre la sélection d'avatar avec aperçu de personnalité. L'onboarding doit être rapide (<5 min) et conduire à un objectif d'hydratation pertinent.

**Value Delivered:** À la fin de cet epic, les nouveaux utilisateurs passent par un onboarding guidé, sélectionnent leur avatar, et obtiennent un objectif d'hydratation personnalisé scientifiquement calculé. L'app comprend les besoins individuels de chaque utilisateur.

---

## Story 2.1: Modèle de Données Profil Utilisateur

**As a** developer,
**I want** un data model pour le profil utilisateur,
**so that** je peux stocker les informations d'onboarding de manière structurée.

### Acceptance Criteria

1. La classe `UserProfile` contient les propriétés : `userId`, `weight` (kg), `age`, `gender` (enum Male/Female/Other), `activityLevel` (enum Sedentary/Light/Moderate/VeryActive/ExtremelyActive), `locationPermissionGranted` (bool)
2. La classe inclut une méthode calculée `dailyHydrationGoalLiters` retournant double
3. L'enum `Gender` définit : `male`, `female`, `other`
4. L'enum `ActivityLevel` définit : `sedentary`, `light`, `moderate`, `veryActive`, `extremelyActive`
5. Le model a des méthodes `toJson()` et `fromJson()` pour sérialisation
6. Le model a une méthode `isComplete()` retournant true si toutes les infos obligatoires sont renseignées
7. Tests unitaires couvrent 100% du model (création, validation, sérialisation)

---

## Story 2.2: Algorithme Calcul Objectif Hydratation

**As a** user,
**I want** un objectif d'hydratation adapté à mon profil,
**so that** l'app me guide avec des recommandations pertinentes et crédibles.

### Acceptance Criteria

1. Le use case `CalculateHydrationGoalUseCase` implémente la formule : Base = weight (kg) × 0.033 litres
2. L'algorithme applique un multiplicateur selon `activityLevel` : Sedentary (1.0), Light (1.1), Moderate (1.2), VeryActive (1.3), ExtremelyActive (1.5)
3. L'algorithme applique un ajustement selon `gender` : Male (1.0), Female (0.95), Other (1.0)
4. L'algorithme applique un ajustement selon `age` : <30 (1.0), 30-55 (0.95), >55 (0.9)
5. Le résultat final est arrondi à 0.1 litre près (ex: 2.3L, pas 2.347L)
6. Le résultat minimum est 1.5L et maximum 5.0L (safety bounds)
7. L'algorithme inclut des commentaires avec références scientifiques pour crédibilité
8. Tests unitaires couvrent tous les cas edge : poids très légers/lourds, tous âges, tous genders, tous activity levels
9. Tests valident que les calculs correspondent aux attentes (ex: homme 75kg 30ans sedentary = 2.5L ± 0.1L)

---

## Story 2.3: Repository Profil Utilisateur

**As a** developer,
**I want** un repository pour persister le profil utilisateur,
**so that** les données d'onboarding sont sauvegardées et accessibles.

### Acceptance Criteria

1. La classe `UserProfileRepository` implémente : `saveProfile()`, `getProfile()`, `updateProfile()`, `deleteProfile()`
2. Le repository utilise `sqflite` pour stocker le profil dans une table `user_profile`
3. Le schéma de table inclut toutes les propriétés du `UserProfile` model
4. La méthode `getProfile()` retourne `null` si aucun profil n'existe (nouveau user)
5. La méthode `saveProfile()` override le profil existant (un seul profil par installation)
6. Le repository est injectable via `get_it`
7. Tests unitaires couvrent CRUD complet (create, read, update, delete)
8. Tests d'intégration valident la persistence réelle avec sqflite

---

## Story 2.4: Écran Onboarding Question Poids

**As a** new user,
**I want** renseigner mon poids lors de l'onboarding,
**so that** l'app peut calculer mon objectif d'hydratation.

### Acceptance Criteria

1. L'écran `OnboardingWeightScreen` s'affiche après la sélection d'avatar (Epic 1)
2. L'écran affiche : titre "Quel est ton poids ?", sous-titre explicatif "Nécessaire pour calculer ton objectif d'hydratation"
3. Un champ de saisie numérique permet d'entrer le poids avec clavier numérique (iOS/Android native)
4. L'unité est configurable (kg ou lbs) via toggle, par défaut kg
5. La validation vérifie : poids entre 30kg et 300kg (ou équivalent lbs), format numérique valide
6. Un message d'erreur s'affiche si la valeur est hors limites
7. Un bouton "Suivant" est activé seulement si la valeur est valide
8. Un indicateur de progression "1/5" est visible en haut de l'écran
9. Widget test valide l'affichage, la validation, et la navigation vers l'écran suivant

---

## Story 2.5: Écran Onboarding Question Âge

**As a** new user,
**I want** renseigner mon âge lors de l'onboarding,
**so that** l'app peut ajuster mon objectif d'hydratation selon mon âge.

### Acceptance Criteria

1. L'écran `OnboardingAgeScreen` s'affiche après l'écran poids
2. L'écran affiche : titre "Quel âge as-tu ?", sous-titre "Ton besoin en eau varie selon l'âge"
3. Un champ de saisie numérique permet d'entrer l'âge avec clavier numérique
4. La validation vérifie : âge entre 10 et 120 ans
5. Un message d'erreur s'affiche si la valeur est hors limites
6. Bouton "Suivant" activé seulement si valide
7. Indicateur de progression "2/5" visible
8. Widget test valide l'affichage, validation, et navigation

---

## Story 2.6: Écran Onboarding Question Sexe

**As a** new user,
**I want** renseigner mon sexe biologique lors de l'onboarding,
**so that** l'app peut ajuster mon objectif d'hydratation avec précision.

### Acceptance Criteria

1. L'écran `OnboardingGenderScreen` s'affiche après l'écran âge
2. L'écran affiche : titre "Sexe biologique", sous-titre "Utilisé uniquement pour calcul scientifique"
3. Trois boutons radio/cards : "Homme", "Femme", "Autre"
4. L'option sélectionnée est highlight visuellement
5. Bouton "Suivant" activé seulement si une option est sélectionnée
6. Indicateur de progression "3/5" visible
7. Widget test valide la sélection et navigation

---

## Story 2.7: Écran Onboarding Question Activité Physique

**As a** new user,
**I want** indiquer mon niveau d'activité physique lors de l'onboarding,
**so that** l'app calcule un objectif adapté à mon mode de vie.

### Acceptance Criteria

1. L'écran `OnboardingActivityScreen` s'affiche après l'écran genre
2. L'écran affiche : titre "Niveau d'activité physique", sous-titre "À quelle fréquence fais-tu du sport ?"
3. Cinq options sous forme de cards : "Sédentaire (peu ou pas d'exercice)", "Léger (1-3x/semaine)", "Modéré (3-5x/semaine)", "Très actif (6-7x/semaine)", "Extrêmement actif (sport intense quotidien)"
4. Chaque card affiche un icon visuel + label + description courte
5. L'option sélectionnée est highlight visuellement
6. Bouton "Suivant" activé seulement si une option est sélectionnée
7. Indicateur de progression "4/5" visible
8. Widget test valide la sélection et navigation

---

## Story 2.8: Écran Onboarding Permission Localisation

**As a** new user,
**I want** choisir si j'autorise la localisation,
**so that** l'app peut ajuster les rappels en fonction de la météo (V2 feature).

### Acceptance Criteria

1. L'écran `OnboardingLocationScreen` s'affiche après l'écran activité
2. L'écran affiche : titre "Autoriser la localisation ?", sous-titre "Optionnel : permettra d'ajuster les rappels en fonction de la météo (canicule)"
3. Deux options : "Autoriser" (bouton primaire) et "Pas maintenant" (bouton secondaire)
4. Si "Autoriser" : demande la permission système via `permission_handler`, puis navigue suivant
5. Si "Pas maintenant" : enregistre `locationPermissionGranted = false`, navigue suivant
6. Indicateur de progression "5/5" visible
7. Les deux options permettent de progresser (pas bloquant)
8. Widget test valide les deux flows (autoriser et refuser)

---

## Story 2.9: Écran Récapitulatif Onboarding avec Objectif

**As a** new user,
**I want** voir mon objectif d'hydratation calculé à la fin de l'onboarding,
**so that** je sais combien je dois boire quotidiennement.

### Acceptance Criteria

1. L'écran `OnboardingSummaryScreen` s'affiche après la question localisation
2. L'écran affiche : titre "Ton objectif quotidien", objectif calculé en grand (ex: "2.5 Litres"), sous-titre "Basé sur ton profil personnel"
3. Un récapitulatif résume les infos : "Homme, 30 ans, 75kg, Activité modérée"
4. Un message motivant s'affiche : "Prêt à hydrater [Nom Avatar] ?" avec icon avatar
5. Bouton "C'est parti !" valide et sauvegarde le profil via `UserProfileRepository`
6. Après sauvegarde, navigation vers `HomeScreen` (Epic 1) avec avatar et objectif actifs
7. Widget test valide l'affichage de l'objectif calculé et la navigation finale
8. Test d'intégration valide le flow complet onboarding → sauvegarde profil → écran home

---

## Story 2.10: Intégration Onboarding dans le Flow Initial

**As a** new user,
**I want** passer automatiquement par l'onboarding lors de ma première utilisation,
**so that** je configure l'app dès le début.

### Acceptance Criteria

1. Au lancement de l'app, vérification : si `UserProfile` existe ET `Avatar` existe → HomeScreen
2. Si `UserProfile` n'existe pas OU `Avatar` n'existe pas → OnboardingFlow
3. Le `OnboardingFlow` suit l'ordre : AvatarSelection (Epic 1) → Weight → Age → Gender → Activity → Location → Summary
4. Un widget `OnboardingNavigator` gère la navigation séquentielle entre les écrans
5. Chaque écran sauvegarde temporairement sa réponse dans un state provider/bloc
6. Seul l'écran Summary sauvegarde définitivement le profil complet
7. Un bouton "Retour" permet de revenir à l'écran précédent (sauf depuis AvatarSelection)
8. Widget test valide le flow complet avec navigation avant/arrière

---

## Epic 2 Completion Checklist

- [ ] Toutes les stories 2.1 à 2.10 sont complétées avec acceptance criteria validés
- [ ] Le calcul d'objectif hydratation est validé scientifiquement (références citées)
- [ ] Le flow d'onboarding complet prend <5 minutes en test manuel
- [ ] Les tests automatiques passent (unit + widget + integration)
- [ ] L'app guide correctement nouveau user : onboarding → home avec objectif personnalisé
- [ ] Code review effectué

---

**Previous Epic:** [Epic 1 - Foundation & Avatar Core System](epic-1-foundation.md)
**Next Epic:** [Epic 3 - Validation Photo & Feedback Positif](epic-3-photo-validation.md)
