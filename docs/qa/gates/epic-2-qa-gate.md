# QA Gate - Epic 2: Onboarding & Personnalisation

**Version:** 1.0
**Date:** 2026-01-07
**Status:** 🔴 Not Started

---

## 📋 Vue d'Ensemble

**Epic:** 2 - Onboarding & Personnalisation
**Objectif:** Créer le flow d'onboarding en 5 questions pour collecter les informations utilisateur, implémenter l'algorithme de calcul d'objectif hydratation personnalisé scientifiquement validé, et intégrer la sélection d'avatar dans le flow initial.
**Stories:** 2.1 à 2.10 (10 stories)
**Criticité:** HIGH (Premier contact utilisateur - expérience critique)

---

## ✅ VALIDATION FONCTIONNELLE

### Features Principales
- [ ] Flow onboarding complet en 7 écrans: AvatarSelection → Poids → Âge → Sexe → Activité → Localisation → Résumé
- [ ] Collecte 5 informations utilisateur: Poids (kg/lbs), Âge, Sexe, Niveau activité, Permission localisation (optionnelle)
- [ ] Algorithme calcul objectif hydratation basé sur formule scientifique (poids × 0.033L × multiplicateurs)
- [ ] Objectif calculé affiché clairement en fin d'onboarding (ex: "2.5 Litres/jour")
- [ ] Profil utilisateur persisté localement (SQLite)
- [ ] Navigation avant/arrière fonctionnelle entre écrans onboarding
- [ ] Indicateur progression visible (1/5, 2/5, 3/5, 4/5, 5/5)
- [ ] Validation stricte des inputs (ranges valides, formats corrects)
- [ ] Skip onboarding si profil existe déjà (lancements suivants)

### User Stories Acceptance Criteria

#### Story 2.1: Modèle UserProfile
- [ ] Classe UserProfile avec propriétés: userId, weight, age, gender, activityLevel, locationPermissionGranted
- [ ] Enum Gender: male, female, other
- [ ] Enum ActivityLevel: sedentary, light, moderate, veryActive, extremelyActive
- [ ] Méthode calculée dailyHydrationGoalLiters retourne double
- [ ] Méthode isComplete() retourne true si toutes infos obligatoires renseignées
- [ ] Méthodes toJson/fromJson fonctionnelles
- [ ] Tests unitaires coverage 100% du model

#### Story 2.2: Algorithme Calcul Objectif
- [ ] CalculateHydrationGoalUseCase implémente formule: Base = weight × 0.033L
- [ ] Multiplicateur activityLevel: Sedentary (1.0), Light (1.1), Moderate (1.2), VeryActive (1.3), ExtremelyActive (1.5)
- [ ] Ajustement gender: Male (1.0), Female (0.95), Other (1.0)
- [ ] Ajustement age: <30 (1.0), 30-55 (0.95), >55 (0.9)
- [ ] Résultat arrondi à 0.1L près
- [ ] Résultat borné: minimum 1.5L, maximum 5.0L
- [ ] Commentaires code avec références scientifiques
- [ ] Tests unitaires couvrent tous cas edge (poids 30-300kg, âges 10-120, tous genders, tous activity levels)
- [ ] Tests valident calculs attendus (ex: homme 75kg 30ans sedentary = 2.5L ± 0.1L)

#### Story 2.3: Repository UserProfile
- [ ] UserProfileRepository implémente: saveProfile, getProfile, updateProfile, deleteProfile
- [ ] Utilise sqflite avec table user_profile
- [ ] getProfile() retourne null si aucun profil (nouveau user)
- [ ] saveProfile() override profil existant (un seul profil par installation)
- [ ] Tests unitaires CRUD complet
- [ ] Tests intégration persistence réelle

#### Story 2.4-2.8: Écrans Onboarding
- [ ] **Poids:** Champ numérique, validation 30-300kg (ou lbs), toggle kg/lbs, indicateur 1/5
- [ ] **Âge:** Champ numérique, validation 10-120 ans, indicateur 2/5
- [ ] **Sexe:** 3 boutons radio (Homme/Femme/Autre), highlight sélection, indicateur 3/5
- [ ] **Activité:** 5 cards (Sedentary à ExtremelyActive), icons + descriptions, indicateur 4/5
- [ ] **Localisation:** 2 boutons (Autoriser/Pas maintenant), demande permission système si Autoriser, optionnel non-bloquant, indicateur 5/5
- [ ] Tous écrans: validation input, messages erreur clairs, bouton "Suivant" activé seulement si valide
- [ ] Navigation "Retour" fonctionnelle (sauf depuis AvatarSelection)

#### Story 2.9: Écran Résumé
- [ ] Affiche objectif calculé en grand (ex: "2.5 Litres")
- [ ] Récapitulatif profil: "Homme, 30 ans, 75kg, Activité modérée"
- [ ] Message motivant avec nom avatar: "Prêt à hydrater [Nom Avatar] ?"
- [ ] Bouton "C'est parti !" sauvegarde profil via repository
- [ ] Navigation vers HomeScreen après sauvegarde
- [ ] Widget test valide affichage objectif + navigation
- [ ] Test intégration valide flow complet onboarding → sauvegarde → home

#### Story 2.10: Intégration Flow Initial
- [ ] Au lancement: si UserProfile existe ET Avatar existe → HomeScreen direct
- [ ] Si UserProfile n'existe pas OU Avatar n'existe pas → OnboardingFlow
- [ ] Flow ordre: AvatarSelection → Weight → Age → Gender → Activity → Location → Summary
- [ ] OnboardingNavigator gère navigation séquentielle
- [ ] Réponses sauvegardées temporairement dans state provider (pas DB avant Summary)
- [ ] Widget test valide flow complet avec navigation avant/arrière

### Flows Utilisateur End-to-End
- [ ] **Flow nouveau user complet:** Install app → AvatarSelection → 5 questions onboarding → Résumé avec objectif → HomeScreen avec avatar + objectif actif
- [ ] **Flow navigation arrière:** Répondre question 3 → Retour → Modifier question 2 → Avancer → Questions 3-5 → Résumé → Profil sauvegardé correctement
- [ ] **Flow validation errors:** Entrer poids invalide (500kg) → Message erreur → Bouton "Suivant" désactivé → Corriger → Bouton activé → Progression
- [ ] **Flow skip onboarding:** Compléter onboarding → Tuer app → Relancer app → HomeScreen direct (skip onboarding)

---

## 🚀 VALIDATION NON-FONCTIONNELLE (NFR)

### Performance
- [ ] Temps total onboarding (nouveau user): < 5 minutes (test utilisateur réel)
- [ ] Transition entre écrans onboarding: < 200ms
- [ ] Calcul objectif hydratation (use case): < 50ms
- [ ] Sauvegarde profil (SQLite): < 100ms
- [ ] Chargement profil existant (app launch): < 50ms

### Accessibilité (WCAG AA)
- [ ] Contraste texte labels questions: ≥4.5:1
- [ ] Boutons sélection (gender, activity): ≥44x44px
- [ ] Champs input (poids, âge) avec labels VoiceOver clairs
- [ ] Messages erreur annoncés par screen readers
- [ ] Navigation clavier entre champs input fonctionnelle (tab order logique)

### UX Onboarding
- [ ] Flow perçu comme rapide et fluide (pas lourd/ennuyant)
- [ ] Questions claires et non-intrusives
- [ ] Sous-titres explicatifs présents ("Nécessaire pour calculer ton objectif")
- [ ] Aucune question ne semble inutile ou trop personnelle
- [ ] Progression visible rassure utilisateur (1/5 → 5/5)
- [ ] Objectif final justifie les questions posées

### Validation Scientifique
- [ ] Formule calcul hydratation validée par sources:
  - Référence 1: European Food Safety Authority (EFSA) guidelines
  - Référence 2: Institute of Medicine (IOM) hydration recommendations
  - Référence 3: Exercice multipliers basés sur études scientifiques
- [ ] Résultats cohérents pour profils types:
  - Homme 75kg 30ans sedentary → ~2.5L ✅
  - Femme 60kg 25ans moderate → ~2.1L ✅
  - Homme 90kg 40ans veryActive → ~3.5L ✅
- [ ] Bounds (1.5L min, 5.0L max) justifiés médicalement

### Offline-First
- [ ] Onboarding fonctionne 100% offline
- [ ] Profil sauvegardé localement (SQLite)
- [ ] Aucun appel Firebase requis pour compléter onboarding
- [ ] Sync cloud en background après sauvegarde (best effort)

### Sécurité & RGPD
- [ ] Données minimales collectées (seulement nécessaire pour calcul)
- [ ] Consent implicite (utilisateur entre données volontairement)
- [ ] Permission localisation clairement optionnelle ("Pas maintenant" disponible)
- [ ] Aucune donnée collectée avant sauvegarde finale (pas de tracking intermédiaire)

### Tests
- [ ] Coverage global Epic 2: ≥80%
  - [ ] Domain layer (CalculateHydrationGoalUseCase): ≥90%
  - [ ] Data layer (UserProfileRepository, models): ≥80%
  - [ ] Presentation layer (écrans onboarding): ≥70%
- [ ] Tests unitaires passent (focus: algorithme calcul objectif)
- [ ] Tests widgets passent (tous écrans onboarding)
- [ ] Tests intégration passent (flow complet onboarding → sauvegarde)

---

## 🏗️ VALIDATION ARCHITECTURE

### Clean Architecture
- [ ] Structure respectée:
  - domain/entities/user.dart
  - domain/use_cases/calculate_hydration_goal_use_case.dart
  - data/models/user_profile_model.dart
  - data/repositories/user_profile_repository_impl.dart
  - presentation/screens/onboarding/ (7 écrans)
- [ ] Use case CalculateHydrationGoalUseCase testé en isolation (repository mocké)
- [ ] UserProfile entity dans domain/, UserProfileModel dans data/
- [ ] Aucune logique métier dans presentation layer

### Code Quality
- [ ] `flutter analyze`: 0 errors, 0 warnings
- [ ] `dart format .`: code formaté
- [ ] Conventions nommage:
  - Classes: OnboardingWeightScreen, CalculateHydrationGoalUseCase
  - Enums: ActivityLevel.sedentary, Gender.male
  - Constants: kMinWeight = 30, kMaxWeight = 300
- [ ] Dartdoc pour CalculateHydrationGoalUseCase (formule expliquée)
- [ ] Pas de magic numbers (multiplicateurs extraits en constants)
- [ ] Validation input centralisée (validators.dart dans core/utils/)

### State Management (Riverpod)
- [ ] OnboardingProvider gère state temporaire (réponses avant sauvegarde)
- [ ] State immutable (pas de mutation directe)
- [ ] Navigation gérée par GoRouter ou Navigator 2.0
- [ ] Loading state géré pendant sauvegarde profil

---

## 📚 VALIDATION DOCUMENTATION

### Code Documentation
- [ ] CalculateHydrationGoalUseCase documenté avec:
  - Formule mathématique complète
  - Références scientifiques (liens EFSA, IOM)
  - Exemples calculs pour profils types
- [ ] Enums Gender, ActivityLevel documentés (signification chaque valeur)
- [ ] README.md mis à jour avec flow onboarding

### Project Documentation
- [ ] docs/architecture.md à jour avec onboarding flow
- [ ] Changelog maintenu pour toutes stories Epic 2
- [ ] Formule calcul objectif documentée dans docs/ (future référence)

---

## 🎨 VALIDATION UI/UX

### Design System
- [ ] Couleurs cohérentes avec Epic 1
- [ ] Typographie:
  - Titres questions: 24sp bold
  - Sous-titres explicatifs: 14sp regular, couleur secondaire
  - Labels inputs: 16sp
- [ ] Spacing 8px grid respecté
- [ ] Composants réutilisables: CustomButton, CustomTextField

### Onboarding Screens
- [ ] Indicateur progression (1/5 → 5/5) visible et clair
- [ ] Bouton "Suivant" disabled state visuellement distinct (grisé)
- [ ] Bouton "Retour" discret mais accessible
- [ ] Champs input avec labels flottants (Material Design)
- [ ] Messages erreur affichés sous champs (couleur rouge, icon warning)
- [ ] Écran résumé: objectif affiché très prominemment (64sp, couleur primary)

### Responsive
- [ ] Testé sur petits écrans (iPhone SE: 375x667) - pas d'overflow
- [ ] Testé sur grands écrans (iPad: 1024x768) - layout centré
- [ ] Clavier numérique s'affiche automatiquement pour poids/âge
- [ ] Clavier ne cache pas bouton "Suivant" (scroll ou resize)

---

## 🐛 VALIDATION STABILITÉ

### Crash-Free
- [ ] Aucun crash si input invalide (gestion erreurs complète)
- [ ] Edge cases gérés:
  - Utilisateur laisse champ vide → Validation empêche progression
  - Utilisateur entre lettres dans champ numérique → Input rejeté
  - Utilisateur tape "Retour" depuis écran 1 → Pas de crash (retour bloqué ou app quit)
  - Permission localisation refusée → Flow continue (optionnel)
- [ ] App ne freeze pas pendant sauvegarde profil (async avec loading)

### Regression Testing
- [ ] Epic 1 toujours fonctionnel:
  - Avatar sélectionné en onboarding persiste
  - HomeScreen affiche avatar après onboarding
  - Déshydratation avatar fonctionne après onboarding
- [ ] Flows critiques Epic 1 validés end-to-end

---

## 📊 CRITÈRES DE PASSAGE

**Pour que cet Epic PASSE le QA Gate:**

- ✅ **100% Validation Fonctionnelle** (10/10 stories OK, flow onboarding complet <5min)
- ✅ **95% Validation NFR** (performance OK, UX fluide, validation scientifique OK)
- ✅ **100% Validation Architecture** (Clean Arch, use case testé en isolation)
- ✅ **Tests Coverage ≥80%** (focus algorithme calcul objectif ≥90%)
- ✅ **Stabilité: 0 crash critique** (validation input robuste)
- ✅ **UX onboarding perçue comme rapide et claire** (test utilisateur)

**Si 1 item CRITIQUE échoue → Epic FAILED, retour @dev**

**Items CRITIQUES pour Epic 2:**
- Calcul objectif scientifiquement validé (sources citées)
- Flow onboarding <5 minutes (mesuré)
- Validation input robuste (aucun crash possible)
- UX fluide et claire (pas de friction)

---

## 🔴 BLOCKERS IDENTIFIÉS

*Liste des blockers critiques empêchant validation:*

1. N/A (à compléter lors de la review)

---

## 🟡 WARNINGS (Non-Bloquants)

*Liste des warnings mineurs à adresser en V2:*

1. N/A (à compléter lors de la review)

---

## ✅ VALIDATION FINALE

**Validé par:** _________________
**Date validation:** _________________
**Status final:** ⬜ PASSED / ⬜ FAILED / ⬜ PASSED WITH WARNINGS

**Notes QA:**
_______________________________________________________________________
_______________________________________________________________________

**Métriques Mesurées:**
- Temps onboarding complet: _______ minutes
- Calcul objectif: _______ ms
- Coverage global Epic 2: _______ %
- Tests utilisateur UX: ⬜ Fluide / ⬜ Friction détectée

**Validation Scientifique:**
- Formule validée: ✅ / ❌
- Sources citées: ✅ / ❌
- Résultats cohérents profils types: ✅ / ❌

---

**Prochaine étape:** Epic 3 - Validation Photo & Feedback Positif

---

*QA Gate créé le 2026-01-07 - Epic 2 Onboarding & Personnalisation*
