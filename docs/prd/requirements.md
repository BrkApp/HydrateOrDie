# Requirements

**Partie du:** [Product Requirements Document](index.md)

---

## Functional Requirements

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

## Non-Functional Requirements

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

[⬅️ Contexte et Objectifs](context-and-goals.md) | [➡️ UI/UX Design](ui-design.md)
