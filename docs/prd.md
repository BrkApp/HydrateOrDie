# Hydrate or Die - Product Requirements Document (PRD)

**Version:** 1.0
**Date:** 2026-01-07
**Document Owner:** Product Manager John
**Status:** Draft

---

## Change Log

| Date | Version | Description | Author |
|------|---------|-------------|--------|
| 2026-01-07 | 1.0 | Initial PRD creation | PM John |

---

## Goals and Background Context

### Goals

- Créer une application mobile iOS/Android qui utilise la punition progressive et l'humour absurde pour améliorer l'hydratation des utilisateurs
- Atteindre un taux de rétention D30 >15% (vs 5-10% marché) grâce au système d'avatar Tamagotchi et validation selfie
- Valider le concept core (avatar + selfie + punition progressive) avant d'investir dans des extensions premium
- Lancer un MVP fonctionnel avec 11 features core identifiées dans le brief
- Établir une base utilisateurs de 10,000 téléchargements dans les 3 premiers mois post-lancement
- Atteindre une conversion freemium de 5% des utilisateurs actifs en premium dans les 90 jours

### Background Context

Les applications d'hydratation existantes souffrent de taux de rétention catastrophiques car elles adoptent toutes la même approche sérieuse/médicale avec tracking passif facile à ignorer. Les gens savent qu'ils devraient boire plus d'eau mais procrastinent et oublient régulièrement, rendant les rappels classiques inefficaces.

Hydrate or Die se positionne comme le premier rappel d'hydratation qui utilise la punition progressive et l'humour absurde pour créer un engagement émotionnel fort. En combinant un système d'avatar Tamagotchi (qui se déshydrate et meurt si l'utilisateur ne boit pas) avec une validation par selfie et des notifications mélodramatiques, l'app transforme une corvée santé en expérience mémorable et addictive. Le projet s'appuie sur des mécaniques comportementales éprouvées (Duolingo pour streaks + harcèlement, Tamagotchi pour responsabilité émotionnelle) appliquées à l'hydratation.

---

## Requirements

### Functional Requirements

**FR1:** Le système doit permettre à l'utilisateur de choisir parmi 3-4 avatars gratuits avec personnalités distinctes (Mère Autoritaire, Coach Sportif, Docteur, Ami Sarcastique)

**FR2:** L'avatar doit évoluer visuellement selon le niveau d'hydratation à travers 4 états distincts : Frais → Fatigué → Desséché → Mort

**FR3:** Lorsque l'avatar meurt, un fantôme doit prendre le relais (pas de points streak ce jour), avec résurrection automatique le lendemain

**FR4:** L'utilisateur doit valider son hydratation en prenant un selfie avec un verre d'eau visible dans la photo

**FR5:** Le système doit afficher des animations positives de l'avatar (content, danse, remerciement) lorsque l'utilisateur valide un verre d'eau

**FR6:** Les notifications doivent évoluer progressivement selon 4 niveaux d'escalade : Calme/doux → Préoccupé → Mélodramatique absurde → SPAM MAJUSCULES avec vulgarité censurée

**FR7:** En mode chaos (niveau max), les notifications doivent être envoyées dans des fenêtres de 5min avec intervalles imprévisibles (spam aléatoire intelligent)

**FR8:** Le système doit inclure des vibrations agaçantes en niveau d'escalade maximum

**FR9:** L'onboarding doit collecter 5 informations via questionnaire : Poids, Âge, Sexe, Niveau d'activité physique, Autorisation localisation (optionnel)

**FR10:** Le système doit calculer un objectif d'hydratation quotidien personnalisé basé sur les données onboarding (poids/âge/sexe/activité)

**FR11:** Le système doit afficher un calendrier historique simple montrant les jours où l'objectif a été atteint (✓) ou raté (✗)

**FR12:** Le système doit maintenir un compteur de streak (jours consécutifs où l'objectif est atteint) avec affichage flame icon 🔥

**FR13:** Le streak ne doit pas progresser le jour où l'avatar meurt (fantôme actif)

**FR14:** Les messages de notification doivent être adaptés à la personnalité de l'avatar sélectionné

**FR15:** Le ton des messages doit inclure de la vulgarité censurée (p*t@in), des références pop culture et des jeux de mots

**FR16:** Le système doit permettre à l'utilisateur de valider plusieurs verres d'eau par jour jusqu'à atteindre l'objectif

**FR17:** L'application doit fonctionner offline avec synchronisation quand le réseau est disponible

**FR18:** Le système doit sauvegarder localement les photos selfies (pas de cloud pour MVP)

**FR19:** Le système doit tracker la progression quotidienne vers l'objectif d'hydratation en temps réel

**FR20:** L'interface doit afficher clairement l'état actuel de l'avatar et le nombre de verres restants à boire

### Non-Functional Requirements

**NFR1:** L'application doit se lancer en moins de 2 secondes

**NFR2:** Les animations d'avatar doivent être fluides à 60 FPS minimum

**NFR3:** La taille totale de l'application ne doit pas dépasser 100 MB (avec avatars et animations)

**NFR4:** La consommation de batterie doit rester raisonnable malgré les notifications fréquentes et le tracking

**NFR5:** L'application doit supporter iOS 15+ (iPhone 8 et ultérieurs)

**NFR6:** L'application doit supporter Android 10+ (API level 29+)

**NFR7:** L'application doit être conforme RGPD pour les utilisateurs européens

**NFR8:** Les données personnelles collectées doivent être minimales et le consentement explicite

**NFR9:** L'utilisateur doit pouvoir supprimer son compte et toutes ses données (droit à l'effacement)

**NFR10:** Les photos selfies doivent être stockées localement par défaut (pas de cloud sauf opt-in)

**NFR11:** Toutes les communications API doivent utiliser HTTPS uniquement

**NFR12:** L'application doit maintenir un App Store rating >4.0/5 étoiles

**NFR13:** Le temps pour atteindre la première validation réussie doit être <5 minutes depuis l'installation

**NFR14:** L'interface doit supporter les tablettes (iPad, Android tablets) avec layout adaptatif

**NFR15:** L'application doit rester utilisable sans connexion réseau (mode offline)

---

## User Interface Design Goals

### Overall UX Vision

L'expérience utilisateur doit être **ludique, engageante et punitive de manière bienveillante**. L'interface doit mettre l'avatar au centre de l'expérience, créant un lien émotionnel fort avec l'utilisateur. Le design doit être épuré et minimaliste pour ne pas distraire du core loop (avatar + validation photo). L'onboarding doit être rapide (<5 min) et la prise de selfie doit être fluide et fun, jamais frustrante. Le ton visuel doit refléter l'humour absurde et mélodramatique de l'app tout en restant accessible au grand public (20-75 ans).

### Key Interaction Paradigms

- **Avatar central et expressif** : L'avatar occupe une place dominante sur l'écran principal, avec animations micro-interactions qui réagissent au temps écoulé et aux actions utilisateur
- **Validation photo guidée** : Interface caméra avec cadre visuel pour guider le positionnement du visage + verre, bouton de capture proéminent
- **Feedback immédiat** : Chaque action (validation verre, ouverture app) déclenche une réaction avatar instantanée
- **Notifications progressives** : Le ton et la fréquence évoluent visuellement et textuellement selon le niveau d'escalade
- **Calendrier historique simple** : Vue mensuelle avec icônes ✓/✗ pour progression rapide sans graphiques complexes
- **Streak proéminent** : Affichage permanent du compteur de jours consécutifs avec flame icon

### Core Screens and Views

1. **Écran d'onboarding** : 5 questions séquentielles avec progression visuelle
2. **Écran de sélection d'avatar** : Galerie des 3-4 avatars avec aperçu personnalité
3. **Écran principal (Home)** : Avatar central + état actuel + progression du jour + bouton "Je bois"
4. **Écran de validation photo** : Interface caméra frontale avec cadre guidé + bouton capture
5. **Écran de confirmation** : Animation avatar content + message positif après validation
6. **Écran historique/calendrier** : Vue calendrier mensuel avec jours atteints/ratés
7. **Écran profil/paramètres** : Modification objectif, avatar, notifications (minimaliste)

### Accessibility

**WCAG AA** - L'application doit respecter les standards WCAG AA pour être utilisable par les seniors (60-75 ans) qui constituent un segment utilisateur tertiaire important. Cela inclut :
- Contraste de couleurs suffisant pour lisibilité
- Taille de texte ajustable
- Boutons suffisamment larges pour manipulation tactile
- Support VoiceOver/TalkBack pour utilisateurs malvoyants
- Pas de dépendance exclusive à la couleur pour transmettre l'information

### Branding

**Ton visuel : Fun, absurde, mélodramatique**

- Palette de couleurs vives et énergiques (bleu hydratation, orange/rouge pour urgence)
- Typographie lisible mais avec caractère (pas trop sérieuse)
- Iconographie simple et expressive (emoji-like)
- Animations exagérées et théâtrales pour renforcer le côté drama queen
- Vulgarité censurée visible dans le texte (p*t@in) mais jamais graphiquement offensante
- Style général "cartoon moderne" accessible mais pas enfantin

### Target Device and Platforms

**Cross-Platform : iOS & Android Mobile**

- **Développement** : Flutter pour codebase unique iOS/Android
- **Plateformes primaires** : Smartphones iOS 15+ et Android 10+
- **Support secondaire** : Tablettes avec layout adaptatif responsive
- **Pas de version web** dans le MVP (mobile-first exclusivement)
- **Orientation** : Portrait principalement, landscape non bloqué mais non optimisé

---

## Technical Assumptions

### Repository Structure

**Monorepo**

Le projet utilisera une structure monorepo avec une seule application Flutter contenant tous les composants (mobile iOS + Android). Cette approche simplifie le développement initial pour un MVP et permet une itération rapide. La structure suivra Clean Architecture :

```
hydrate-or-die/
├── lib/
│   ├── core/           # Constants, themes, utils
│   ├── data/           # Models, repositories, data sources
│   ├── domain/         # Business logic, use cases
│   ├── presentation/   # UI (screens, widgets, state management)
│   └── main.dart
├── assets/
│   ├── images/         # Avatars, icons
│   ├── animations/     # Lottie files
│   └── fonts/
├── test/
└── docs/
```

### Service Architecture

**Monolith mobile app avec Backend-as-a-Service (Firebase)**

Pour le MVP, l'application sera monolithique côté mobile (pas de microservices) avec Firebase comme BaaS :

- **Frontend** : Flutter (Dart) - Application mobile unique
- **Backend** : Firebase (Authentication, Firestore, Cloud Storage, Cloud Functions, Analytics, Crashlytics)
- **Database locale** : SQLite via sqflite pour données critiques offline
- **Database cloud** : Firestore pour sync multi-devices et backup
- **Architecture pattern** : Clean Architecture avec séparation presentation/domain/data
- **State Management** : Riverpod (choix préféré) ou Bloc
- **Dependency Injection** : get_it package

**Rationale** : Firebase réduit drastiquement le temps de développement backend pour un MVP, offre un plan gratuit généreux (Spark), et scale automatiquement. Monolith mobile simplifie la maintenance initiale.

### Testing Requirements

**Unit + Integration Testing (Testing Pyramid complet)**

- **Unit Tests obligatoires** : Toute logique business (domain layer, use cases, calculs hydratation)
- **Widget Tests obligatoires** : Composants UI critiques (avatar states, photo validation, onboarding)
- **Integration Tests** : Flows critiques end-to-end (onboarding complet, validation photo → update avatar)
- **Pas de tests E2E automatisés** dans MVP (coût/temps), mais **tests manuels systématiques** avant chaque release
- **Coverage minimum** : 70% pour domain layer, 50% pour presentation layer
- **CI/CD** : Tests automatiques exécutés sur chaque commit (GitHub Actions)

**Rationale** : Tests obligatoires pour garantir qualité et éviter régressions, surtout pour logique core (streaks, avatar states, notifications). Testing pyramid équilibré adapté aux ressources limitées du MVP.

### Additional Technical Assumptions and Requests

- **Flutter packages requis** :
  - `camera` : Accès caméra frontale pour selfies
  - `flutter_local_notifications` : Notifications push locales
  - `permission_handler` : Gestion permissions (caméra, notifications, localisation optionnelle)
  - `shared_preferences` : Stockage settings simples
  - `sqflite` : Base de données locale SQLite
  - `firebase_core`, `firebase_auth`, `cloud_firestore` : Intégration Firebase
  - `flutter_secure_storage` : Stockage sécurisé tokens authentification
  - `riverpod` ou `flutter_bloc` : State management
  - `get_it` : Dependency injection

- **Permissions iOS/Android** :
  - Caméra frontale (obligatoire pour validation selfie)
  - Notifications push (obligatoire pour rappels)
  - Localisation (optionnelle pour météo V2, demandée en onboarding)

- **Notifications** :
  - Utilisation de notifications locales (pas de serveur push pour MVP)
  - Scheduling intelligent avec intervalles variables
  - Gestion du Do Not Disturb / Focus Mode iOS/Android
  - Pause automatique notifications nocturnes (22h-7h par défaut, personnalisable)

- **Sécurité et conformité** :
  - Authentification email/password + Apple Sign-In (iOS) + Google Sign-In (Android)
  - Stockage sécurisé des credentials avec `flutter_secure_storage`
  - HTTPS uniquement pour toutes communications API
  - Certificate pinning pour production
  - Privacy Policy et Terms of Service conformes RGPD
  - Analytics anonymisées (Firebase Analytics)

- **Déploiement** :
  - CI/CD via GitHub Actions (build, test, deploy)
  - Déploiement Apple App Store (TestFlight pour beta)
  - Déploiement Google Play Store (Internal/Beta tracks pour tests)
  - Versioning sémantique (MAJOR.MINOR.PATCH)

- **Contraintes techniques identifiées** :
  - Impossible de forcer plein écran non-dismissable pour notifications (limitations OS)
  - Impossible de bloquer autres apps ou changer fond d'écran automatiquement
  - Détection AI avancée photo (eau vs jus) reportée en V2 (coût/complexité)
  - Notifications fréquentes risquent désactivation par user → Équilibrage critique

---

## Epic List

Les détails complets de chaque epic (stories et acceptance criteria) sont disponibles dans des fichiers séparés pour faciliter la navigation et éviter la surcharge du PRD principal.

### Epic 1: Foundation & Avatar Core System
**Objectif :** Établir l'infrastructure projet (Flutter app, Firebase, CI/CD) et implémenter le système d'avatar Tamagotchi avec ses 4 états de déshydratation et le système de mort temporaire/fantôme.

**Détails :** [epics/epic-1-foundation.md](epics/epic-1-foundation.md)

---

### Epic 2: Onboarding & Personnalisation
**Objectif :** Créer le flow d'onboarding en 5 questions, implémenter l'algorithme de calcul d'objectif hydratation personnalisé, et permettre la sélection d'avatar avec aperçu personnalité.

**Détails :** [epics/epic-2-onboarding.md](epics/epic-2-onboarding.md)

---

### Epic 3: Validation Photo & Feedback Positif
**Objectif :** Implémenter la validation par selfie avec interface caméra guidée, stockage local des photos, et animations de feedback positif de l'avatar après validation.

**Détails :** [epics/epic-3-photo-validation.md](epics/epic-3-photo-validation.md)

---

### Epic 4: Système de Notifications Punitives
**Objectif :** Développer l'escalade progressive des notifications (4 niveaux), spam aléatoire intelligent, messages personnalisés par avatar, et vibrations agaçantes.

**Détails :** [epics/epic-4-notifications.md](epics/epic-4-notifications.md)

---

### Epic 5: Progression & Rétention (Streaks & Historique)
**Objectif :** Créer le système de streaks Duolingo-style, calendrier historique des jours atteints/ratés, et écran de profil/paramètres minimaliste.

**Détails :** [epics/epic-5-progression.md](epics/epic-5-progression.md)

---

## Next Steps

### UX Expert Prompt

Le PRD est maintenant complet. Prochaine étape : Travailler avec l'agent UX Expert pour créer les wireframes, design system, et prototypes visuels des 7 écrans core identifiés.

**Commande recommandée :** `*ux-expert` avec ce PRD comme input.

### Architect Prompt

Après validation UX, travailler avec l'agent Architect pour définir l'architecture technique détaillée : data models, structure Flutter, intégrations Firebase, et plan de développement par phases.

**Commande recommandée :** `*architect` avec ce PRD + designs UX comme inputs.

---

*PRD créé le 2026-01-07 par PM John*
*Basé sur Project Brief v1.0 par BA Mary*
