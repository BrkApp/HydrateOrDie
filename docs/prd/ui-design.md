# User Interface Design Goals

**Partie du:** [Product Requirements Document](index.md)

---

## Overall UX Vision

L'expérience utilisateur doit être **ludique, engageante et punitive de manière bienveillante**. L'interface doit mettre l'avatar au centre de l'expérience, créant un lien émotionnel fort avec l'utilisateur. Le design doit être épuré et minimaliste pour ne pas distraire du core loop (avatar + validation photo). L'onboarding doit être rapide (<5 min) et la prise de selfie doit être fluide et fun, jamais frustrante. Le ton visuel doit refléter l'humour absurde et mélodramatique de l'app tout en restant accessible au grand public (20-75 ans).

## Key Interaction Paradigms

- **Avatar central et expressif** : L'avatar occupe une place dominante sur l'écran principal, avec animations micro-interactions qui réagissent au temps écoulé et aux actions utilisateur
- **Validation photo guidée** : Interface caméra avec cadre visuel pour guider le positionnement du visage + verre, bouton de capture proéminent
- **Feedback immédiat** : Chaque action (validation verre, ouverture app) déclenche une réaction avatar instantanée
- **Notifications progressives** : Le ton et la fréquence évoluent visuellement et textuellement selon le niveau d'escalade
- **Calendrier historique simple** : Vue mensuelle avec icônes ✓/✗ pour progression rapide sans graphiques complexes
- **Streak proéminent** : Affichage permanent du compteur de jours consécutifs avec flame icon

## Core Screens and Views

1. **Écran d'onboarding** : 5 questions séquentielles avec progression visuelle
2. **Écran de sélection d'avatar** : Galerie des 3-4 avatars avec aperçu personnalité
3. **Écran principal (Home)** : Avatar central + état actuel + progression du jour + bouton "Je bois"
4. **Écran de validation photo** : Interface caméra frontale avec cadre guidé + bouton capture
5. **Écran de confirmation** : Animation avatar content + message positif après validation
6. **Écran historique/calendrier** : Vue calendrier mensuel avec jours atteints/ratés
7. **Écran profil/paramètres** : Modification objectif, avatar, notifications (minimaliste)

## Accessibility

**WCAG AA** - L'application doit respecter les standards WCAG AA pour être utilisable par les seniors (60-75 ans) qui constituent un segment utilisateur tertiaire important. Cela inclut :
- Contraste de couleurs suffisant pour lisibilité
- Taille de texte ajustable
- Boutons suffisamment larges pour manipulation tactile
- Support VoiceOver/TalkBack pour utilisateurs malvoyants
- Pas de dépendance exclusive à la couleur pour transmettre l'information

## Branding

**Ton visuel : Fun, absurde, mélodramatique**

- Palette de couleurs vives et énergiques (bleu hydratation, orange/rouge pour urgence)
- Typographie lisible mais avec caractère (pas trop sérieuse)
- Iconographie simple et expressive (emoji-like)
- Animations exagérées et théâtrales pour renforcer le côté drama queen
- Vulgarité censurée visible dans le texte (p*t@in) mais jamais graphiquement offensante
- Style général "cartoon moderne" accessible mais pas enfantin

## Target Device and Platforms

**Cross-Platform : iOS & Android Mobile**

- **Développement** : Flutter pour codebase unique iOS/Android
- **Plateformes primaires** : Smartphones iOS 15+ et Android 10+
- **Support secondaire** : Tablettes avec layout adaptatif responsive
- **Pas de version web** dans le MVP (mobile-first exclusivement)
- **Orientation** : Portrait principalement, landscape non bloqué mais non optimisé

---

[⬅️ Requirements](requirements.md) | [➡️ Technical Assumptions](technical-assumptions.md)
