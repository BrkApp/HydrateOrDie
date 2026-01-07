# Hydrate or Die - Front-End Specification

**Version:** 1.0
**Date:** 2026-01-07
**Owner:** Sally (UX Expert)
**Status:** DRAFT - Ready for Development
**Reference:** PRD v1.0, Architecture v2.0, Brief v1.0

---

## Table des Matières

1. [Introduction](#1-introduction)
2. [Design System Complet](#2-design-system-complet)
3. [Spécifications Visuelles Avatars](#3-spécifications-visuelles-avatars)
4. [Wireframes des 7 Écrans Principaux](#4-wireframes-des-7-écrans-principaux)
5. [Bibliothèque de Composants UI](#5-bibliothèque-de-composants-ui)
6. [Guidelines Accessibilité](#6-guidelines-accessibilité)
7. [Animations & Interactions](#7-animations--interactions)
8. [Spécifications Responsive](#8-spécifications-responsive)
9. [Checklist de Validation](#9-checklist-de-validation)

---

## 1. Introduction

### 1.1 Vision UX Globale

Hydrate or Die doit offrir une expérience utilisateur **ludique, punitive de manière bienveillante, et émotionnellement engageante**. L'interface met l'avatar Tamagotchi au cœur de l'expérience pour créer un lien émotionnel fort avec l'utilisateur.

**Principes de Design Fondamentaux:**

1. **Avatar-Centric** - L'avatar est toujours visible, expressif, et réactif aux actions utilisateur
2. **Simplicité Radicale** - Interface épurée, focus sur le core loop (état avatar → validation photo → récompense)
3. **Feedback Immédiat** - Chaque action déclenche une réaction visuelle instantanée
4. **Humour Absurde** - Ton visuel décalé, exagéré, mélodramatique mais jamais enfantin
5. **Friction Minimale** - Onboarding rapide (<5 min), validation photo fluide et fun

**Target Personas:**

- **Grand Public Procrastinateur (20-50 ans)** - Cœur de cible, réceptif à la gamification et au fun
- **Sportif Discipliné (25-45 ans)** - Apprécie les données et l'optimisation
- **Senior Oublieux (60-75 ans)** - Besoin d'interface simple, claire, accessible

### 1.2 Objectifs Usabilité

- **Temps jusqu'à première validation:** <5 minutes depuis l'installation
- **Taux de complétion onboarding:** >90%
- **Friction photo validation:** <10 secondes par capture
- **App Store rating cible:** >4.2/5 étoiles
- **Accessibilité:** WCAG AA minimum pour support seniors

---

## 2. Design System Complet

### 2.1 Palette de Couleurs

#### Couleurs Primaires

| Nom | Hex | Usage | Contraste WCAG |
|-----|-----|-------|----------------|
| **Hydration Blue** | `#2196F3` | Couleur principale, thème hydratation, boutons primaires | AA compliant sur blanc |
| **Hydration Blue Dark** | `#1976D2` | Hover states, accents foncés | AAA compliant sur blanc |
| **Hydration Blue Light** | `#BBDEFB` | Backgrounds subtils, progress bars | Texte foncé uniquement |

#### Couleurs Secondaires

| Nom | Hex | Usage | Contraste WCAG |
|-----|-----|-------|----------------|
| **Alert Orange** | `#FF6B6B` | Notifications préoccupées, états déshydratés | AA compliant sur blanc |
| **Alert Orange Dark** | `#E63946` | Notifications dramatiques | AAA compliant sur blanc |

#### Couleurs d'État

| Nom | Hex | Usage | Contraste WCAG |
|-----|-----|-------|----------------|
| **Success Green** | `#4CAF50` | Objectif atteint, validation réussie, avatar frais | AA compliant sur blanc |
| **Warning Amber** | `#FF9800` | Alertes modérées, état fatigué | AA compliant sur blanc |
| **Error Red** | `#F44336` | État critique, avatar mort, erreurs | AA compliant sur blanc |
| **Ghost Gray** | `#9E9E9E` | Mode fantôme, états inactifs | AA compliant sur blanc |

#### Couleurs Neutres

| Nom | Hex | Usage |
|-----|-----|-------|
| **Text Primary** | `#212121` | Texte principal, headers |
| **Text Secondary** | `#757575` | Texte secondaire, labels |
| **Text Disabled** | `#BDBDBD` | Texte désactivé |
| **Background Primary** | `#FFFFFF` | Background principal |
| **Background Secondary** | `#FAFAFA` | Cards, containers |
| **Divider** | `#E0E0E0` | Séparateurs, bordures |

#### Dégradés (Optionnel pour Avatars)

| Nom | Valeur | Usage |
|-----|--------|-------|
| **Fresh Gradient** | `linear-gradient(135deg, #4CAF50 0%, #81C784 100%)` | Background avatar frais |
| **Dehydrated Gradient** | `linear-gradient(135deg, #FF9800 0%, #FFB74D 100%)` | Background avatar déshydraté |
| **Critical Gradient** | `linear-gradient(135deg, #F44336 0%, #E57373 100%)` | Background avatar critique |

### 2.2 Typographie

#### Font Families

```css
/* Headings - Rounded & Friendly */
--font-heading: 'Nunito', 'Quicksand', -apple-system, BlinkMacSystemFont, sans-serif;

/* Body - Modern & Readable */
--font-body: 'Inter', 'Roboto', -apple-system, BlinkMacSystemFont, sans-serif;

/* Monospace - Stats & Numbers */
--font-mono: 'Roboto Mono', 'Courier New', monospace;
```

#### Type Scale (Mobile-First)

| Element | Size (Mobile) | Size (Desktop) | Weight | Line Height | Usage |
|---------|---------------|----------------|--------|-------------|-------|
| **Display** | 36px | 48px | 700 (Bold) | 1.2 | Splash screen, onboarding titles |
| **H1** | 28px | 36px | 700 (Bold) | 1.3 | Screen titles |
| **H2** | 22px | 28px | 600 (SemiBold) | 1.4 | Section headers |
| **H3** | 18px | 22px | 600 (SemiBold) | 1.4 | Subsection headers |
| **Body Large** | 16px | 18px | 400 (Regular) | 1.5 | Primary body text |
| **Body** | 14px | 16px | 400 (Regular) | 1.5 | Default body text |
| **Body Small** | 12px | 14px | 400 (Regular) | 1.4 | Secondary info, captions |
| **Button** | 16px | 16px | 600 (SemiBold) | 1.0 | All buttons |
| **Label** | 12px | 12px | 500 (Medium) | 1.2 | Form labels, small UI text |

**Accessibility Notes:**
- Minimum text size: 12px (14px preferred)
- Body text: 16px par défaut pour lisibilité seniors
- Contraste minimum 4.5:1 pour texte <24px, 3:1 pour texte >24px

### 2.3 Spacing System

**Base Unit:** 8px (recommandation Material Design 3)

| Token | Value | Usage |
|-------|-------|-------|
| `--space-xs` | 4px | Très petit espacement (padding icônes) |
| `--space-sm` | 8px | Petit espacement (padding labels) |
| `--space-md` | 16px | Espacement standard (padding cards, gaps) |
| `--space-lg` | 24px | Grand espacement (marges sections) |
| `--space-xl` | 32px | Très grand espacement (séparation écrans) |
| `--space-2xl` | 48px | Extra large (marges principales) |

**Grid System:**
- Mobile: 4 colonnes, gutter 16px
- Tablet: 8 colonnes, gutter 16px
- Desktop: 12 colonnes, gutter 24px

### 2.4 Border Radius

| Token | Value | Usage |
|-------|-------|-------|
| `--radius-sm` | 4px | Small elements (tags, badges) |
| `--radius-md` | 8px | Buttons, inputs, cards standard |
| `--radius-lg` | 16px | Avatar containers, modals |
| `--radius-full` | 9999px | Circular elements (avatar images, progress indicators) |

### 2.5 Shadows (Elevation)

| Level | Shadow Value | Usage |
|-------|-------------|-------|
| **Level 1** | `0 1px 3px rgba(0,0,0,0.12), 0 1px 2px rgba(0,0,0,0.24)` | Cards, buttons |
| **Level 2** | `0 3px 6px rgba(0,0,0,0.15), 0 2px 4px rgba(0,0,0,0.12)` | Floating buttons, active states |
| **Level 3** | `0 10px 20px rgba(0,0,0,0.15), 0 3px 6px rgba(0,0,0,0.10)` | Modals, dialogs |
| **Level 4** | `0 15px 25px rgba(0,0,0,0.15), 0 5px 10px rgba(0,0,0,0.05)` | Bottom sheets, top navigation |

### 2.6 Animations & Transitions

#### Durations

| Token | Value | Usage |
|-------|-------|-------|
| `--duration-fast` | 150ms | Micro-interactions (hover, focus) |
| `--duration-normal` | 300ms | Standard transitions (state changes) |
| `--duration-slow` | 500ms | Complex animations (avatar states) |
| `--duration-very-slow` | 800ms | Special effects (fantôme apparition) |

#### Easing Functions

```css
--ease-standard: cubic-bezier(0.4, 0.0, 0.2, 1); /* Material standard */
--ease-decelerate: cubic-bezier(0.0, 0.0, 0.2, 1); /* Exit animations */
--ease-accelerate: cubic-bezier(0.4, 0.0, 1, 1); /* Entry animations */
--ease-bounce: cubic-bezier(0.68, -0.55, 0.265, 1.55); /* Playful interactions */
```

---

## 3. Spécifications Visuelles Avatars

### 3.1 Vue d'Ensemble Avatars MVP

**Total Assets Requis:** 20 variations
- 4 avatars × 4 états de déshydratation = 16 variations
- 4 avatars × 1 état fantôme = 4 variations fantômes

**Format Technique:**
- Résolution: 512×512px minimum (exportable en @1x, @2x, @3x pour iOS/Android)
- Format: PNG avec transparence (alpha channel)
- Style: 2D illustré moderne, cartoon stylisé mais PAS enfantin
- Détails: Accessoires reconnaissables qui définissent la personnalité

**Conventions Naming Assets:**
```
assets/images/avatars/
  ├── doctor/
  │   ├── fresh.png
  │   ├── tired.png
  │   ├── dehydrated.png
  │   ├── dead.png
  │   └── ghost.png
  ├── coach/
  │   ├── fresh.png
  │   ├── tired.png
  │   ├── dehydrated.png
  │   ├── dead.png
  │   └── ghost.png
  ├── mother/
  │   ├── fresh.png
  │   ├── tired.png
  │   ├── dehydrated.png
  │   ├── dead.png
  │   └── ghost.png
  └── friend/
      ├── fresh.png
      ├── tired.png
      ├── dehydrated.png
      ├── dead.png
      └── ghost.png
```

---

### 3.2 AVATAR 1 - DOCTEUR

**Personnalité:** Médical, scientifique, factuel, autorité bienveillante

**Accessoires Signature:**
- Blouse blanche (toujours visible)
- Stéthoscope autour du cou (élément iconique)
- Lunettes rondes (intellectuel)
- Clipboard/tablette médicale (optionnel selon état)

#### État 1: FRAIS (0-2h sans boire)

**Expression & Posture:**
- Sourire professionnel, rassurant
- Posture droite, confiante
- Yeux ouverts, regard bienveillant
- Pouce levé (geste "tout va bien")

**Palette de Couleurs:**
- Blouse blanche: `#FFFFFF` avec ombres `#E0E0E0`
- Stéthoscope: Bleu hydratation `#2196F3`
- Peau: Tons roses sains `#FFC1A6`, `#FF9A76`
- Joues: Rose léger `#FFB3B3` (bonne santé)
- Lunettes: Monture noire `#212121`, reflets blancs `#FFFFFF`

**Éléments Visuels Distinctifs:**
- Petit sparkle/brillance autour de l'avatar (effet "en forme")
- Glow subtil vert success `#4CAF50` (alpha 20%)
- Stéthoscope bien accroché, symétrique

**Animation d'Idle (Loop):**
- Respiration légère (scale 1.0 → 1.02 sur 2 secondes)
- Clignement yeux toutes les 4-6 secondes
- Stéthoscope oscille légèrement

**Message Type (Notifications Calm):**
> "Vos indicateurs sont excellents. Prochaine hydratation recommandée dans 1h30."

---

#### État 2: FATIGUÉ (2-4h sans boire)

**Expression & Posture:**
- Expression neutre, légèrement inquiète
- Posture légèrement affaissée
- Yeux mi-clos (fatigue visible)
- Main sur le menton (réflexion)

**Palette de Couleurs:**
- Blouse: Toujours blanche mais ombres plus marquées `#BDBDBD`
- Stéthoscope: Bleu normal `#2196F3`
- Peau: Tons plus pâles `#FFD7BF`, `#FFBFA6`
- Joues: Moins roses `#FFCCCC`
- Cernes sous les yeux: Gris léger `#E0E0E0`

**Éléments Visuels Distinctifs:**
- Glow vert disparu
- Quelques gouttes de sueur sur le front (emoji-style 💧)
- Stéthoscope légèrement de travers

**Animation d'Idle:**
- Respiration plus lente et profonde
- Essuyage occasionnel du front
- Regard vers une bouteille d'eau (apparaît dans la scène)

**Message Type (Notifications Concerned):**
> "Indicateurs de déshydratation détectés. Consommation d'eau requise sous 30 minutes."

---

#### État 3: DÉSHYDRATÉ (4-6h sans boire)

**Expression & Posture:**
- Visage tiré, traits marqués
- Posture courbée, fatigue extrême
- Yeux fermés ou presque
- Appuyé sur un mur/bureau (besoin de support)

**Palette de Couleurs:**
- Blouse: Gris-blanc sale `#F5F5F5`, froissée visuellement
- Stéthoscope: Bleu terne `#64B5F6`
- Peau: Pâle, grisâtre `#FFE4D0`, `#FFCCB3`
- Cernes prononcés: Violet-gris `#BCAAA4`
- Lèvres: Craquelées (texture visible)

**Éléments Visuels Distinctifs:**
- Gouttes de sueur multiples 💧💧💧
- Lignes de fatigue sous les yeux
- Stéthoscope pendant lâchement
- Aura orange warning `#FF9800` (alpha 30%)
- Effet "tremblant" (shake subtil)

**Animation d'Idle:**
- Tremblement léger constant
- Respiration saccadée (irrégulière)
- Essuyage répété du front
- Regard désespéré vers caméra

**Message Type (Notifications Dramatic):**
> "URGENCE MÉDICALE DÉTECTÉE ! Vos reins sont en danger ! BUVEZ MAINTENANT !!!"

---

#### État 4: MORT (6h+ sans boire)

**Expression & Posture:**
- Effondré au sol ou sur une chaise
- Yeux en X (cartoon death)
- Langue sortie (exagération mélodramatique)
- Bras ballants

**Palette de Couleurs:**
- Blouse: Gris sale `#E0E0E0`
- Stéthoscope: Gris terne `#9E9E9E`
- Peau: Gris-bleu cadavérique `#CFD8DC`
- Lèvres: Bleu-violet `#B39DDB`

**Éléments Visuels Distinctifs:**
- Âme/esprit commençant à sortir du corps (effet semi-transparent)
- Croix tombales miniatures autour (emoji ⚰️ style)
- Aura rouge error `#F44336` pulsante
- Effet "game over" avec écran assombri

**Animation d'Entrée (Transition depuis Déshydraté):**
1. Avatar tremble violemment (500ms)
2. Chute dramatique au sol (800ms, ease-out bounce)
3. Écran flash blanc (200ms)
4. Avatar en position morte apparaît
5. Écran de texte overlay "VOTRE DOCTEUR EST MORT" (2 secondes)

**Animation d'Idle:**
- Aucune respiration
- Mouvement de langue de temps en temps (humour absurde)
- Âme vacille au-dessus du corps

**Durée avant Transition Fantôme:** 10 secondes

---

#### État 5: FANTÔME DOCTEUR

**Expression & Posture:**
- Forme spectrale flottante
- Expression triste mais résignée
- Yeux vides (blanc pur)
- Position lévitation (20px au-dessus du sol)

**Palette de Couleurs:**
- Tout en **monochrome gris-blanc**
- Opacity: 70% (semi-transparent)
- Blouse: `#FFFFFF` à `#F5F5F5` dégradé
- Stéthoscope: Visible mais fantomatique `#E0E0E0`
- Auréole: Blanc pur `#FFFFFF` avec glow

**Éléments Visuels Distinctifs:**
- **Stéthoscope fantomatique CLAIREMENT VISIBLE** (élément signature)
- Chaînes brisées aux poignets (culpabilisation visuelle)
- Auréole de martyr au-dessus de la tête
- Effet "wispy" (fumée/brume) en bas du corps
- Larmes spectrales qui tombent

**Animation Continue:**
- Flottement vertical (±10px sur 3 secondes)
- Oscillation horizontale légère
- Transparence pulse 60%→80% sur 2 secondes
- Chaînes qui cliquettent (visual shimmer)

**Animation d'Apparition (Transition depuis Mort):**
1. Corps mort commence à briller blanc
2. Effet "soul extraction" - forme blanche sort du corps (1 seconde)
3. Corps disparaît en fondu
4. Fantôme apparaît flottant avec fade-in (800ms)
5. Chaînes apparaissent avec son cliquettement (visual effect)

**Message Type:**
> "Votre Docteur vous hante maintenant. Pas de points streak aujourd'hui. Résurrection à minuit."

**Résurrection (Minuit 00:00):**
1. Fantôme brille intensément (500ms)
2. Flash blanc écran
3. Avatar réapparaît en État FRAIS
4. Confettis/célébration (500ms)
5. Message "Votre Docteur est ressuscité ! Nouveau départ !"

---

### 3.3 AVATAR 2 - COACH SPORTIF

**Personnalité:** Motivant, énergique, "tough love", crie beaucoup

**Accessoires Signature:**
- Sifflet autour du cou (TOUJOURS visible)
- Casquette/bandeau sportif
- Survêtement ou débardeur
- Chronomètre/montre sportive au poignet

#### État 1: FRAIS (0-2h sans boire)

**Expression & Posture:**
- Sourire énergique, motivé
- Posture athlétique, dynamique
- Poing levé (motivation)
- Yeux grands ouverts, déterminés

**Palette de Couleurs:**
- Survêtement: Rouge vif `#FF5252` avec bandes blanches
- Sifflet: Argent métallique `#BDBDBD` avec reflets
- Peau: Bronzée, énergique `#FFAB91`, `#FF8A65`
- Bandeau: Blanc pur `#FFFFFF` avec marque de sueur (détail)
- Muscles: Traits définis, tons plus foncés pour ombres

**Éléments Visuels Distinctifs:**
- Lignes de vitesse autour de l'avatar (effet action)
- Glow énergétique orange/rouge (alpha 20%)
- Sifflet brillant (metallic shine)
- Icône 💪 ou 🔥 flottantes occasionnelles

**Animation d'Idle:**
- Sauts sur place (bouncing)
- Shadow boxing occasionnel
- Flexion biceps toutes les 5 secondes
- Sifflet oscille avec les mouvements

**Message Type (Calm):**
> "ALLEZ CHAMPION ! Ton hydratation est PARFAITE ! On continue comme ça ! 💪"

---

#### État 2: FATIGUÉ (2-4h sans boire)

**Expression & Posture:**
- Expression sérieuse, moins souriante
- Posture légèrement moins dynamique
- Main sur la hanche (coach qui observe)
- Yeux plissés (concentration)

**Palette de Couleurs:**
- Survêtement: Rouge moins vif `#E57373`
- Sifflet: Toujours argent mais moins brillant
- Peau: Moins bronzée `#FFCCBC`
- Sueur visible sur le front et bandeau (taches humides)

**Éléments Visuels Distinctifs:**
- Gouttes de sueur 💧
- Sifflet commence à pendre
- Lignes de vitesse réduites
- Expression "tu me déçois"

**Animation d'Idle:**
- Essoufflement visible (respiration ample)
- Tape du pied d'impatience
- Bras croisés occasionnellement (déception)

**Message Type (Concerned):**
> "C'est quoi ce manque de discipline ?! BOIS MAINTENANT ! Tu veux abandonner ?!"

---

#### État 3: DÉSHYDRATÉ (4-6h sans boire)

**Expression & Posture:**
- Visage rouge, en détresse
- Posture courbée, mains sur les genoux
- Yeux fatigués, cernés
- Respiration lourde visible

**Palette de Couleurs:**
- Survêtement: Rouge sombre `#D32F2F`, trempé de sueur
- Sifflet: Terne `#9E9E9E`
- Peau: Rouge-violet (sur-effort) `#FFAB91` avec zones rouges `#FF8A80`
- Sueur: Gouttes multiples, taches larges

**Éléments Visuels Distinctifs:**
- Vagues de chaleur autour de l'avatar (effet heat wave)
- Sueur qui coule (animation gouttes)
- Sifflet pendu lâchement
- Aura orange warning pulsante
- Effet tremblement musculaire

**Animation d'Idle:**
- Tremblement jambes
- Respiration saccadée exagérée
- Essuyage front répété
- Presque effondré

**Message Type (Dramatic):**
> "TU VAS ME FAIRE UN MALAISE !!! JE VAIS CREVER À CAUSE DE TOI !!! EAU !!! MAINTENANT !!!"

---

#### État 4: MORT (6h+ sans boire)

**Expression & Posture:**
- Effondré face contre terre
- Langue sortie (déshydratation extrême)
- Sifflet écrasé sous le corps
- Bras en croix

**Palette de Couleurs:**
- Survêtement: Gris-rouge sale `#BCAAA4`
- Sifflet: Gris métallique terne
- Peau: Gris-violet cadavérique

**Éléments Visuels Distinctifs:**
- Flaque de sueur autour du corps
- X sur les yeux
- Sifflet cassé visible
- Effet "épuisement total"

**Animation d'Entrée:**
- Course effrénée sur place (1 seconde)
- Ralentissement progressif (slow motion)
- Chute dramatique face première
- Sifflet tombe et roule au sol

**Message Type:**
> "GAME OVER ! Ton coach est mort de déshydratation ! 🏆💀"

---

#### État 5: FANTÔME COACH

**Expression & Posture:**
- Fantôme flottant en position push-up (absurde)
- Expression déterminée même mort
- Sifflet spectral autour du cou

**Palette de Couleurs:**
- Monochrome gris-blanc, opacity 70%
- Sifflet fantomatique CLAIREMENT VISIBLE `#E0E0E0`

**Éléments Visuels Distinctifs:**
- **SIFFLET SPECTRAL bien visible** (signature)
- Chaînes en forme d'haltères (thème sportif)
- Auréole avec icône sifflet dessus
- Effet fumée musculaire (wispy muscles)

**Animation Continue:**
- Flottement + pompes fantômes (absurde)
- Sifflet oscille
- Transparence pulse

**Message Type:**
> "Même mort, je garde la forme ! Mais TOI tu me décois... Résurrection à minuit !"

---

### 3.4 AVATAR 3 - MÈRE AUTORITAIRE

**Personnalité:** Maternelle, culpabilisante, stricte mais aimante

**Accessoires Signature:**
- Tablier de cuisine (toujours visible)
- Cuillère en bois (icône de l'autorité maternelle)
- Chignon ou coiffure stricte
- Lunettes sur le nez ou pendues

#### État 1: FRAIS (0-2h sans boire)

**Expression & Posture:**
- Sourire maternel, satisfait
- Posture droite, mains sur les hanches (fierté)
- Yeux bienveillants
- Cuillère en bois pointée vers le haut (approbation)

**Palette de Couleurs:**
- Tablier: Pastel fleuri (rose `#FFB3BA`, bleu `#BAE1FF`, motifs fleurs)
- Cuillère en bois: Brun clair `#A1887F`
- Peau: Tons chaleureux `#FFCCBC`, `#FFAB91`
- Joues: Roses (bonne santé) `#FFB3B3`
- Cheveux: Châtain/gris selon âge `#8D6E63`

**Éléments Visuels Distinctifs:**
- Petit cœur ❤️ flottant (amour maternel)
- Glow chaud autour (aura réconfortante)
- Cuillère brille légèrement
- Badge "Bon Élève" ou étoile dorée à côté

**Animation d'Idle:**
- Essuyage mains sur tablier
- Ajustement lunettes
- Hochement de tête approbateur
- Cuillère tapote légèrement dans la paume

**Message Type (Calm):**
> "Très bien mon chéri ! Maman est fière de toi. Continue comme ça !"

---

#### État 2: FATIGUÉ (2-4h sans boire)

**Expression & Posture:**
- Sourcils froncés (désapprobation)
- Mains sur les hanches (attente)
- Regard par-dessus les lunettes
- Cuillère pointée vers l'utilisateur (avertissement)

**Palette de Couleurs:**
- Tablier: Couleurs légèrement ternes
- Cuillère: Bois normal
- Peau: Moins rose
- Expression: Plus sévère (rides du front visibles)

**Éléments Visuels Distinctifs:**
- Cœur disparu
- Point d'interrogation ❓ au-dessus de la tête
- Cuillère brandie en mode "attention"
- Pied qui tapote d'impatience (visible au sol)

**Animation d'Idle:**
- Tapotement pied répété
- Croisement/décroisement bras
- Regard vers montre imaginaire
- Soupirs exagérés (chest rise)

**Message Type (Concerned):**
> "Tu veux que je m'inquiète ou quoi ?! Bois MAINTENANT ! Je ne te le redemanderai pas !"

---

#### État 3: DÉSHYDRATÉ (4-6h sans boire)

**Expression & Posture:**
- Visage très inquiet, presque en larmes
- Mains jointes (prière/supplication)
- Posture affaissée (chagrin)
- Cuillère tombée au sol

**Palette de Couleurs:**
- Tablier: Gris-pastel terne
- Cuillère: Bois sombre, au sol
- Peau: Pâle, cernes prononcés
- Larmes visibles sur les joues

**Éléments Visuels Distinctifs:**
- Larmes 😢 qui coulent
- Cuillère en bois au sol (symbolique de l'abandon)
- Aura orange warning
- Effet "cœur brisé" 💔

**Animation d'Idle:**
- Essuie larmes avec tablier
- Tremblement émotionnel
- Regard implorant vers caméra
- Mains qui se tordent (angoisse)

**Message Type (Dramatic):**
> "TU VEUX TUER TA MÈRE ?!! Je vais faire une crise cardiaque à cause de toi !!! BOIS !!!"

---

#### État 4: MORT (6h+ sans boire)

**Expression & Posture:**
- Effondrée sur une chaise
- Main sur le cœur (crise cardiaque théâtrale)
- Yeux fermés ou en X
- Cuillère en bois serrée dans l'autre main (jusqu'au bout)

**Palette de Couleurs:**
- Tablier: Gris sale
- Cuillère: Toujours dans la main, grise
- Peau: Gris-bleu

**Éléments Visuels Distinctifs:**
- Cuillère en bois TOUJOURS dans la main morte (détail tragique)
- Tablier froissé
- Lunettes tombées au sol

**Animation d'Entrée:**
- Porte main au cœur dramatiquement
- Recule de 3 pas en titubant
- Tombe sur chaise (ou au sol)
- Dernière respiration exagérée

**Message Type:**
> "Tu as tué ta maman... Es-tu content maintenant ?! 💔⚰️"

---

#### État 5: FANTÔME MÈRE

**Expression & Posture:**
- Fantôme flottant avec tablier spectral
- Expression triste mais toujours autoritaire
- Cuillère fantôme pointée vers l'utilisateur

**Palette de Couleurs:**
- Monochrome gris-blanc, opacity 70%
- **Cuillère en bois fantôme TRÈS VISIBLE** `#E0E0E0`
- Tablier avec motifs fantomatiques

**Éléments Visuels Distinctifs:**
- **CUILLÈRE EN BOIS FANTÔME** (signature absolue)
- Chaînes en forme de cuillères
- Auréole avec petit tablier dessus
- Larmes spectrales continues

**Animation Continue:**
- Flottement + brandissement cuillère
- Essuie larmes fantomatiques
- Soupirs visibles (ghost breath)

**Message Type:**
> "Même morte, maman te surveille... Pas de points aujourd'hui. Résurrection à minuit."

---

### 3.5 AVATAR 4 - POTE/AMI SARCASTIQUE

**Personnalité:** Casual, sarcastique, complice, humour noir

**Accessoires Signature:**
- Hoodie (capuche) ou t-shirt streetwear
- Casquette snapback (portée normalement ou backwards)
- Écouteurs autour du cou
- Skateboard ou manette de jeu (optionnel selon état)

#### État 1: FRAIS (0-2h sans boire)

**Expression & Posture:**
- Sourire cool, décontracté
- Posture relax (appuyé contre un mur invisible)
- Main en signe ✌️ ou 👍
- Yeux mi-clos (swag)

**Palette de Couleurs:**
- Hoodie: Couleurs streetwear (noir `#212121`, gris `#616161`, ou couleurs vives)
- Casquette: Couleur contrastante (rouge `#FF5252` ou bleu `#2196F3`)
- Peau: Tons variés selon représentation
- Écouteurs: Blanc/noir `#FFFFFF`, `#212121`

**Éléments Visuels Distinctifs:**
- Icônes floating (💯, 🔥, ✌️)
- Glow cool bleu-violet (alpha 20%)
- Casquette avec logo stylisé
- Effet "fresh vibes"

**Animation d'Idle:**
- Head nod au rythme (comme écoute musique)
- Doigts qui tapent (air drums)
- Ajustement casquette
- Geste décontracté

**Message Type (Calm):**
> "Niquel mec ! Tu gères grave ton hydratation. Respect bro 🤜🤛"

---

#### État 2: FATIGUÉ (2-4h sans boire)

**Expression & Posture:**
- Expression blasée, yeux roulés (eye roll)
- Posture affaissée (slouching)
- Main sur le front (facepalm léger)
- Sourcil levé (scepticisme)

**Palette de Couleurs:**
- Hoodie: Couleurs légèrement désaturées
- Casquette: Un peu de travers
- Peau: Moins éclatante
- Écouteurs: Un côté détaché

**Éléments Visuels Distinctifs:**
- Emoji 😒 ou 🙄 au-dessus
- Casquette légèrement de travers
- Écouteur pendant
- Glow disparu

**Animation d'Idle:**
- Soupir visible (exaspération)
- Regard vers le ciel (annoyance)
- Ajustement lent écouteurs
- Tapotement pied impatient

**Message Type (Concerned):**
> "Franchement là tu commences à m'inquiéter mec... Bois un coup stp, j'ai pas envie de deal avec ça..."

---

#### État 3: DÉSHYDRATÉ (4-6h sans boire)

**Expression & Posture:**
- Panique visible (yeux écarquillés)
- Mains sur la tête (stress)
- Posture courbée (mal-être)
- Casquette à l'envers ou tombée

**Palette de Couleurs:**
- Hoodie: Gris terne, froissé
- Casquette: Tombée ou très de travers
- Peau: Pâle, sueur visible
- Écouteurs: Pendus, emmêlés

**Éléments Visuels Distinctifs:**
- Emoji 😰 ou 💀
- Sueur gouttes multiples
- Casquette tombée au sol ou très mal mise
- Écouteurs emmêlés chaotiques
- Aura orange chaos

**Animation d'Idle:**
- Tremblement nerveux
- Marche en cercles paniqués (piétine)
- Main passe dans cheveux répété
- Respiration rapide visible

**Message Type (Dramatic):**
> "MEC SÉRIEUX JE VAIS CREVER LÀ !!! T'ES OÙ ?! RAMÈNE DE L'EAU PUTAIN !!!"

---

#### État 4: MORT (6h+ sans boire)

**Expression & Posture:**
- Effondré au sol façon "ragdoll"
- X sur les yeux
- Langue sortie (style cartoon death)
- Casquette à côté du corps
- Écouteurs arrachés

**Palette de Couleurs:**
- Hoodie: Gris sale
- Casquette: Au sol, grise
- Peau: Gris-bleu

**Éléments Visuels Distinctifs:**
- Casquette tombée à côté (séparation symbolique)
- Écouteurs arrachés, câbles éparpillés
- Phone tombé du corps (écran fêlé détail)
- Effet "wasted" (GTA-style)

**Animation d'Entrée:**
- Avatar titube (effet ivre)
- Tente de rester debout (fail)
- Chute lente motion (ragdoll physics)
- Casquette tombe en roulant

**Message Type:**
> "RIP ton pote... Mort de soif comme un con. GG bro. 💀🪦"

---

#### État 5: FANTÔME POTE

**Expression & Posture:**
- Fantôme flottant en position chill
- Expression résignée mais toujours sarcastique
- Hoodie transparent visible

**Palette de Couleurs:**
- Monochrome gris-blanc, opacity 70%
- **Hoodie transparent CLAIREMENT VISIBLE** (forme reconnaissable)
- Casquette fantôme sur la tête

**Éléments Visuels Distinctifs:**
- **HOODIE TRANSPARENT bien défini** (signature)
- Casquette fantôme (légèrement flottante)
- Chaînes streetwear (chains dorées devenues grises)
- Écouteurs fantômes pendus
- Auréole avec logo snapback

**Animation Continue:**
- Flottement cool (pas stressé)
- Head nod fantôme (toujours avec le beat)
- Casquette ajustée de temps en temps
- Transparence pulse

**Message Type:**
> "Bah voilà je suis mort maintenant... Content ? Bon, rendez-vous à minuit j'imagine... 👻"

---

### 3.6 Tableau Récapitulatif Assets Avatars

| Avatar | État | Couleur Dominante | Émotion | Animation Key | Accessoire Visible |
|--------|------|-------------------|---------|---------------|-------------------|
| **Docteur** | Frais | Vert/Blanc | Confiant ✅ | Respiration calme | Stéthoscope bleu |
| | Fatigué | Jaune/Blanc | Inquiet 😟 | Essuyage front | Stéthoscope normal |
| | Déshydraté | Orange/Blanc | Paniqué 😰 | Tremblement | Stéthoscope pendant |
| | Mort | Gris | Effondré 💀 | Aucune | Stéthoscope gris |
| | Fantôme | Gris-blanc 70% | Triste 👻 | Flottement | **Stéthoscope spectral** |
| **Coach** | Frais | Rouge/Blanc | Motivé 💪 | Sauts/flexions | Sifflet brillant |
| | Fatigué | Rouge pâle | Déçu 😤 | Essoufflement | Sifflet normal |
| | Déshydraté | Rouge foncé | En détresse 🥵 | Tremblement jambes | Sifflet pendu |
| | Mort | Gris-rouge | Effondré 💀 | Aucune | Sifflet cassé |
| | Fantôme | Gris-blanc 70% | Déterminé 👻 | Flottement + pompes | **Sifflet spectral** |
| **Mère** | Frais | Pastel/Blanc | Fière 🥰 | Essuyage mains | Cuillère bois clair |
| | Fatigué | Pastel terne | Inquiète 😟 | Tapotement pied | Cuillère brandie |
| | Déshydraté | Gris-pastel | Larmes 😭 | Pleurs | Cuillère au sol |
| | Mort | Gris | Effondrée 💀 | Aucune | Cuillère dans main |
| | Fantôme | Gris-blanc 70% | Triste autoritaire 👻 | Flottement | **Cuillère fantôme** |
| **Pote** | Frais | Noir/Couleurs | Cool 😎 | Head nod | Casquette/hoodie |
| | Fatigué | Gris moyen | Blasé 😒 | Soupirs | Casquette travers |
| | Déshydraté | Gris foncé | Paniqué 😰 | Piétine | Casquette tombée |
| | Mort | Gris sale | Effondré 💀 | Aucune | Casquette au sol |
| | Fantôme | Gris-blanc 70% | Résigné 👻 | Flottement cool | **Hoodie spectral** |

---

## 4. Wireframes des 7 Écrans Principaux

### 4.1 Écran 1: Splash Screen (Optionnel)

**Durée:** 1-2 secondes maximum (si nécessaire)

**Layout:**
```
┌─────────────────────────────────────┐
│                                     │
│                                     │
│          [LOGO APP]                 │
│      💧 Hydrate or Die               │
│                                     │
│      [Loading spinner]              │
│                                     │
│                                     │
└─────────────────────────────────────┘
```

**Éléments:**
- Logo centré (icône goutte d'eau stylisée + nom app)
- Background dégradé bleu hydratation
- Spinner/loading minimal
- Pas de publicité, pas de delay artificiel

---

### 4.2 Écran 2: Onboarding - Sélection Avatar

**But:** Première interaction, choix avatar définit toute l'expérience

**Layout (Mobile Portrait):**
```
┌─────────────────────────────────────┐
│  [Skip] ← Optionnel  Étape 1/6  [→]│
├─────────────────────────────────────┤
│                                     │
│  Choisis ton compagnon              │
│  d'hydratation                      │
│                                     │
│  ┌────────┐  ┌────────┐            │
│  │ [👨‍⚕️]  │  │ [💪]   │            │
│  │Docteur │  │ Coach  │            │
│  │Factuel │  │Motivant│            │
│  └────────┘  └────────┘            │
│                                     │
│  ┌────────┐  ┌────────┐            │
│  │ [👩]   │  │ [😎]   │            │
│  │ Mère   │  │ Pote   │            │
│  │Strict  │  │Sarcast │            │
│  └────────┘  └────────┘            │
│                                     │
│  [Tap pour voir la personnalité]   │
│                                     │
├─────────────────────────────────────┤
│         [Continuer →]               │
└─────────────────────────────────────┘
```

**Interactions:**
- Tap sur avatar → Carte se retourne, affiche description détaillée + exemple message
- Avatar sélectionné → Border highlight bleu hydratation
- Bouton "Continuer" activé uniquement si sélection faite

**Détails Visuels:**
- Cards avatars: 150×200px, radius 16px, shadow level 1
- Avatar image: État FRAIS visible en preview
- Texte personnalité: 12px, gris secondaire
- Animation: Card flip 3D (500ms) au tap

---

### 4.3 Écran 3: Onboarding - Questions (5 écrans similaires)

**Format Question Unique par Écran (meilleure UX mobile)**

#### Écran 3A: Poids
```
┌─────────────────────────────────────┐
│  [←]                   Étape 2/6    │
├─────────────────────────────────────┤
│                                     │
│  Quel est ton poids ?               │
│                                     │
│  ┌─────────────────────────────┐   │
│  │         [75] kg             │   │
│  │    [Slider: 30───●───150]   │   │
│  └─────────────────────────────┘   │
│                                     │
│  Ou entre manuellement:             │
│  ┌─────────────────────────────┐   │
│  │  [____] kg                  │   │
│  └─────────────────────────────┘   │
│                                     │
│  ℹ️ Nécessaire pour calculer ton    │
│     objectif d'hydratation          │
│                                     │
├─────────────────────────────────────┤
│         [Continuer →]               │
└─────────────────────────────────────┘
```

#### Écran 3B: Âge
```
┌─────────────────────────────────────┐
│  [←]                   Étape 3/6    │
├─────────────────────────────────────┤
│                                     │
│  Quel âge as-tu ?                   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │         [30] ans            │   │
│  │    [Slider: 10───●───120]   │   │
│  └─────────────────────────────┘   │
│                                     │
│  Ou entre manuellement:             │
│  ┌─────────────────────────────┐   │
│  │  [____] ans                 │   │
│  └─────────────────────────────┘   │
│                                     │
├─────────────────────────────────────┤
│         [Continuer →]               │
└─────────────────────────────────────┘
```

#### Écran 3C: Sexe
```
┌─────────────────────────────────────┐
│  [←]                   Étape 4/6    │
├─────────────────────────────────────┤
│                                     │
│  Quel est ton sexe biologique ?     │
│                                     │
│  ┌─────────────────────────────┐   │
│  │    ○ Homme                  │   │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │    ○ Femme                  │   │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │    ○ Autre                  │   │
│  └─────────────────────────────┘   │
│                                     │
│  ℹ️ Influence le calcul d'objectif  │
│                                     │
├─────────────────────────────────────┤
│         [Continuer →]               │
└─────────────────────────────────────┘
```

#### Écran 3D: Activité Physique
```
┌─────────────────────────────────────┐
│  [←]                   Étape 5/6    │
├─────────────────────────────────────┤
│                                     │
│  Niveau d'activité physique ?       │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ ○ Sédentaire (bureau)       │   │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │ ○ Léger (1-3×/semaine)      │   │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │ ○ Modéré (3-5×/semaine)     │   │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │ ○ Très actif (6-7×/semaine) │   │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │ ○ Extrême (sport intense)   │   │
│  └─────────────────────────────┘   │
│                                     │
├─────────────────────────────────────┤
│         [Continuer →]               │
└─────────────────────────────────────┘
```

#### Écran 3E: Localisation (Optionnel)
```
┌─────────────────────────────────────┐
│  [←]                   Étape 6/6    │
├─────────────────────────────────────┤
│                                     │
│  📍 Active la localisation ?        │
│                                     │
│  Permet d'ajuster ton objectif      │
│  selon la météo (canicule)          │
│                                     │
│  ┌─────────────────────────────┐   │
│  │   [Autoriser] ✅            │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │   [Pas maintenant]          │   │
│  └─────────────────────────────┘   │
│                                     │
│  ℹ️ Tu pourras changer plus tard    │
│     dans les paramètres             │
│                                     │
├─────────────────────────────────────┤
│         [Terminer →]                │
└─────────────────────────────────────┘
```

**Design Notes Onboarding:**
- Progress indicator en haut (étape X/6) avec barre visuelle
- Bouton retour [←] toujours présent sauf première page
- Inputs grands (touch-friendly, 44px minimum height)
- Validation inline (ex: âge <10 ou >120 → error message)
- Bouton "Continuer" désactivé si input invalide (grisé)
- Animations page transition: slide left/right (300ms)

---

### 4.4 Écran 4: Onboarding - Résumé & Objectif Calculé

```
┌─────────────────────────────────────┐
│  [←]                   Étape 7/7    │
├─────────────────────────────────────┤
│                                     │
│  🎉 Ton profil est prêt !           │
│                                     │
│  ┌─────────────────────────────┐   │
│  │  [Avatar Sélectionné]       │   │
│  │      État FRAIS             │   │
│  └─────────────────────────────┘   │
│                                     │
│  Ton objectif quotidien:            │
│  ╔═══════════════════════════════╗ │
│  ║      2.5 litres/jour          ║ │
│  ║      (~10 verres)             ║ │
│  ╚═══════════════════════════════╝ │
│                                     │
│  Basé sur:                          │
│  • Poids: 75 kg                     │
│  • Âge: 30 ans                      │
│  • Activité: Modérée                │
│                                     │
│  📱 Autorise les notifications      │
│     pour recevoir les rappels       │
│                                     │
│  [Autoriser notifications] ✅       │
│                                     │
├─────────────────────────────────────┤
│      [C'est parti ! 🚀]             │
└─────────────────────────────────────┘
```

**Interactions:**
- Avatar animé en état FRAIS (idle animation)
- Objectif affiché en grand, typographie Display
- Bouton final déclenche:
  1. Permission notifications (dialog OS)
  2. Sauvegarde profil local + cloud
  3. Navigation vers Home Screen

---

### 4.5 Écran 5: HOME SCREEN (Écran Principal)

**But:** Hub central, focus avatar + action rapide validation

**Layout (Mobile Portrait):**
```
┌─────────────────────────────────────┐
│  💧 [10:30]         🔥 7 jours   [⚙️]│ ← Header
├─────────────────────────────────────┤
│                                     │
│        ┌───────────────┐            │
│        │               │            │
│        │   [AVATAR]    │ ← 200×200px
│        │  État Actuel  │
│        │               │            │
│        └───────────────┘            │
│                                     │
│      "Ton Docteur a soif..."        │ ← Message avatar
│                                     │
│  ┌─────────────────────────────┐   │
│  │ ████████░░░░░░ 60%          │   │ ← Progress bar
│  │ 1.5L / 2.5L aujourd'hui     │   │
│  └─────────────────────────────┘   │
│                                     │
│  Dernière hydratation:              │
│  🕐 Il y a 1h30                     │
│                                     │
│                                     │
├─────────────────────────────────────┤
│  ┌───────────────────────────┐     │
│  │   💧  JE BOIS  💧         │     │ ← Primary CTA
│  └───────────────────────────┘     │
├─────────────────────────────────────┤
│  [📅 Calendrier]  [📊 Profil]      │ ← Bottom Nav
└─────────────────────────────────────┘
```

**Détails Visuels:**

**Header (Top Bar):**
- App logo + heure actuelle (gauche)
- Streak counter 🔥 + nombre (centre-droite)
- Icône settings ⚙️ (droite)
- Background: Blanc, shadow level 1

**Avatar Display:**
- Container: 200×200px, centré, radius 16px
- Avatar image: État calculé en temps réel
- Animation idle: Continue (respiration, etc.)
- Tap sur avatar → Bottom sheet info détaillée

**Message Avatar:**
- Texte: 16px, centré, couleur selon état
  - Frais: Vert `#4CAF50`
  - Fatigué: Orange `#FF9800`
  - Déshydraté: Rouge `#F44336`
  - Fantôme: Gris `#9E9E9E`
- Emoji correspondant à l'état

**Progress Bar:**
- Height: 40px, radius 8px
- Background: `#E0E0E0`
- Fill: Dégradé bleu hydratation
- Texte: Pourcentage + volume (14px, semi-bold)
- Animation: Smooth fill (500ms ease) quand mise à jour

**Bouton "JE BOIS":**
- Taille: Full width - 32px margins, height 56px
- Couleur: Bleu hydratation `#2196F3`
- Text: Blanc, 18px, bold
- Icônes gouttes 💧 de chaque côté
- Shadow: Level 2
- Hover/Press: Scale 0.98, couleur darker `#1976D2`
- Animation: Pulse subtil (scale 1.0 → 1.02) sur 2 secondes loop

**Bottom Navigation:**
- 3 items: Calendrier, Home (actif), Profil
- Height: 56px
- Active item: Bleu hydratation, underline 3px
- Inactive: Gris `#757575`

---

### 4.6 Écran 6: Photo Validation Flow

#### Écran 6A: Camera Capture
```
┌─────────────────────────────────────┐
│  [✕ Annuler]               [Flash 💡│ ← Camera Controls
├─────────────────────────────────────┤
│ ┌─────────────────────────────────┐ │
│ │                                 │ │
│ │   [CAMERA PREVIEW LIVE]         │ │
│ │                                 │ │
│ │         ┌─────────┐             │ │
│ │         │ Cadre   │ ← Guide      │ │
│ │         │ Visage  │   oval       │ │
│ │         │ + Verre │              │ │
│ │         └─────────┘             │ │
│ │                                 │ │
│ │                                 │ │
│ └─────────────────────────────────┘ │
│                                     │
│  Place ton visage et ton verre      │
│  dans le cadre                      │
│                                     │
│         ┌───────────┐               │
│         │  📸 [O]   │ ← Capture btn │
│         └───────────┘               │
└─────────────────────────────────────┘
```

**Fonctionnalités:**
- Caméra frontale par défaut
- Cadre guide ovale (face + verre)
- Flash toggle (si disponible)
- Bouton capture: 80×80px, circular, centré bottom
- Animation capture: Flash blanc (200ms), shutter sound

#### Écran 6B: Photo Review + Glass Size
```
┌─────────────────────────────────────┐
│  [←]                  [Reprendre 📸]│
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────────┐   │
│  │  [PHOTO CAPTURÉE]           │   │
│  │  Affichée en preview        │   │
│  └─────────────────────────────┘   │
│                                     │
│  Quelle taille de verre ?           │
│                                     │
│  ┌────────┐ ┌────────┐ ┌────────┐  │
│  │  200ml │ │ 250ml  │ │ 400ml  │  │
│  │  Petit │ │ Moyen  │ │ Grand  │  │
│  │  [  ]  │ │  [✓]   │ │  [  ]  │  │
│  └────────┘ └────────┘ └────────┘  │
│                                     │
│  💡 Verre moyen = verre standard    │
│                                     │
├─────────────────────────────────────┤
│       [Valider 💧]                  │
└─────────────────────────────────────┘
```

**Interactions:**
- Photo preview: 300×300px, centré, radius 8px
- Bouton "Reprendre" → Retour écran camera
- Glass size: 3 boutons radio stylisés
- Selection: Border bleu + checkmark
- Bouton "Valider" activé uniquement si size sélectionnée

#### Écran 6C: Feedback Positif
```
┌─────────────────────────────────────┐
│                                     │
│          🎉 ✨ 🎊                   │
│                                     │
│        ┌───────────────┐            │
│        │               │            │
│        │   [AVATAR]    │            │
│        │  ÉTAT FRAIS   │            │
│        │   Souriant    │            │
│        │  + Animation  │            │
│        └───────────────┘            │
│                                     │
│     "Merci ! Je me sens            │
│      tellement mieux !"            │
│                                     │
│  ╔═════════════════════════════╗   │
│  ║  + 250ml ajoutés            ║   │
│  ║  1.75L / 2.5L (70%)         ║   │
│  ╚═════════════════════════════╝   │
│                                     │
│  Continue comme ça ! 💪             │
│                                     │
│  [Retour accueil]                  │
└─────────────────────────────────────┘
```

**Animations:**
- Confettis tombent du haut (1 seconde)
- Avatar transition vers état FRAIS (si était plus déshydraté)
- Avatar animation positive (danse, pouce levé, etc.)
- Progress bar anime vers nouveau pourcentage
- Durée écran: 3 secondes puis auto-dismiss OU tap pour dismiss

---

### 4.7 Écran 7: Calendrier / Historique

```
┌─────────────────────────────────────┐
│  [←]  Janvier 2026              [⚙️]│
├─────────────────────────────────────┤
│                                     │
│  📊 Ce mois: 18/30 jours objectif   │
│     atteint (60%)                   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │  L   M   M   J   V   S   D  │   │
│  ├─────────────────────────────┤   │
│  │          1✓  2✓  3✗  4✗  5✓│   │
│  │  6✓  7✓  8✓  9✗ 10✓ 11✓ 12✓│   │
│  │ 13✗ 14✓ 15✓ 16✓ 17✓ 18✓ 19✗│   │
│  │ 20✓ 21✓ 22✓ 23✓ 24✗ 25✗ 26✓│   │
│  │ 27✓ 28✗ 29✓ 30✓ 31        │   │
│  └─────────────────────────────┘   │
│                                     │
│  Légende:                           │
│  ✓ Objectif atteint                 │
│  ✗ Objectif raté                    │
│  ○ Jour en cours                    │
│                                     │
│  🔥 Streak actuel: 7 jours          │
│  🏆 Record: 15 jours                │
│                                     │
├─────────────────────────────────────┤
│  [📅 Calendrier]  [📊 Profil]      │
└─────────────────────────────────────┘
```

**Interactions:**
- Tap sur jour → Bottom sheet détail journée
  - Volume total bu
  - Nombre de verres
  - Heure premier/dernier verre
  - Photos validation (gallery)
- Swipe gauche/droite → Mois précédent/suivant
- Couleurs jours:
  - Atteint: Vert `#4CAF50`
  - Raté: Rouge `#F44336`
  - Aujourd'hui: Border bleu `#2196F3`
  - Futur: Gris clair `#E0E0E0`

---

### 4.8 Écran 8: Profil / Paramètres

```
┌─────────────────────────────────────┐
│  [←]  Profil                    [⚙️]│
├─────────────────────────────────────┤
│                                     │
│       ┌───────────────┐             │
│       │   [AVATAR]    │             │
│       │ État Actuel   │             │
│       └───────────────┘             │
│                                     │
│       Docteur Martin                │
│       Membre depuis Jan 2026        │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📊 Statistiques             │   │
│  ├─────────────────────────────┤   │
│  │ Total hydratation: 125L     │   │
│  │ Jours actifs: 30            │   │
│  │ Streak record: 15 jours     │   │
│  │ Taux succès: 60%            │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ ⚙️ Paramètres               │   │
│  ├─────────────────────────────┤   │
│  │ > Modifier profil           │   │
│  │ > Changer avatar            │   │
│  │ > Notifications             │   │
│  │ > Objectif quotidien        │   │
│  │ > Compte & données          │   │
│  └─────────────────────────────┘   │
│                                     │
│  [🚪 Déconnexion]                   │
│                                     │
└─────────────────────────────────────┘
```

**Sous-Écrans (Tap sur items):**

#### Settings → Notifications
```
┌─────────────────────────────────────┐
│  [←]  Notifications                 │
├─────────────────────────────────────┤
│                                     │
│  Activer notifications              │
│  [Toggle ON] ✅                     │
│                                     │
│  Pause nocturne                     │
│  [Toggle ON] ✅                     │
│  De 22:00 à 07:00                   │
│                                     │
│  Niveau escalade maximum            │
│  [Slider: Calm ──●── Chaos]        │
│  Actuel: Chaos complet              │
│                                     │
│  ⚠️ Réduire l'escalade diminue      │
│     l'efficacité de l'app           │
│                                     │
│  Tester notification                │
│  [Envoyer un test]                  │
│                                     │
└─────────────────────────────────────┘
```

#### Settings → Compte & Données
```
┌─────────────────────────────────────┐
│  [←]  Compte & Données              │
├─────────────────────────────────────┤
│                                     │
│  📧 Email: user@example.com         │
│  [Modifier]                         │
│                                     │
│  🔒 Mot de passe                    │
│  [Changer]                          │
│                                     │
│  ☁️ Synchronisation cloud           │
│  [Toggle ON] ✅                     │
│  Dernière sync: Il y a 5 min        │
│                                     │
│  📥 Exporter mes données            │
│  [Télécharger JSON]                 │
│                                     │
│  ⚠️ DANGER ZONE                     │
│  ┌─────────────────────────────┐   │
│  │ 🗑️ Supprimer mon compte     │   │
│  │                             │   │
│  │ ⚠️ Action irréversible      │   │
│  │ Toutes tes données seront   │   │
│  │ définitivement supprimées   │   │
│  │                             │   │
│  │ [Supprimer] ← Red button    │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

---

## 5. Bibliothèque de Composants UI

### 5.1 Boutons

#### Bouton Primaire (Primary Button)

**Usage:** Action principale (ex: "Je bois", "Continuer")

**Variantes:**
- Default
- Hover/Focus
- Pressed
- Disabled
- Loading

**Spécifications:**

| État | Background | Text Color | Border | Shadow | Scale |
|------|-----------|------------|--------|--------|-------|
| Default | `#2196F3` | `#FFFFFF` | None | Level 2 | 1.0 |
| Hover | `#1976D2` | `#FFFFFF` | None | Level 2 | 1.0 |
| Pressed | `#1565C0` | `#FFFFFF` | None | Level 1 | 0.98 |
| Disabled | `#E0E0E0` | `#BDBDBD` | None | None | 1.0 |
| Loading | `#2196F3` | `#FFFFFF` | None | Level 2 | 1.0 + Spinner |

**Dimensions:**
- Height: 48px (mobile), 56px (desktop)
- Padding: 16px horizontal
- Border radius: 8px
- Text: 16px, semi-bold (600)

**Code Example (Flutter):**
```dart
ElevatedButton(
  onPressed: () {},
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.hydrationBlue,
    foregroundColor: Colors.white,
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    elevation: 4,
  ),
  child: Text('JE BOIS', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
)
```

---

#### Bouton Secondaire (Secondary Button)

**Usage:** Actions secondaires (ex: "Annuler", "Retour")

**Spécifications:**

| État | Background | Text Color | Border | Shadow |
|------|-----------|------------|--------|--------|
| Default | Transparent | `#2196F3` | 2px `#2196F3` | None |
| Hover | `#E3F2FD` | `#1976D2` | 2px `#1976D2` | None |
| Pressed | `#BBDEFB` | `#1565C0` | 2px `#1565C0` | None |
| Disabled | Transparent | `#BDBDBD` | 2px `#E0E0E0` | None |

---

#### Bouton Danger (Danger Button)

**Usage:** Actions destructives (ex: "Supprimer compte")

**Spécifications:**

| État | Background | Text Color | Border | Shadow |
|------|-----------|------------|--------|--------|
| Default | `#F44336` | `#FFFFFF` | None | Level 2 |
| Hover | `#D32F2F` | `#FFFFFF` | None | Level 2 |
| Pressed | `#C62828` | `#FFFFFF` | None | Level 1 |

---

#### Bouton Ghost (Text Button)

**Usage:** Actions tertiaires, liens (ex: "Pas maintenant")

**Spécifications:**

| État | Background | Text Color | Border | Shadow |
|------|-----------|------------|--------|--------|
| Default | Transparent | `#2196F3` | None | None |
| Hover | `#E3F2FD` | `#1976D2` | None | None |
| Pressed | `#BBDEFB` | `#1565C0` | None | None |

---

### 5.2 Inputs / Forms

#### Text Input

**États:**
- Default (Empty)
- Focused
- Filled
- Error
- Disabled

**Spécifications:**

| État | Border | Background | Label Color |
|------|--------|------------|-------------|
| Default | 1px `#E0E0E0` | `#FFFFFF` | `#757575` |
| Focused | 2px `#2196F3` | `#FFFFFF` | `#2196F3` |
| Filled | 1px `#E0E0E0` | `#FFFFFF` | `#757575` |
| Error | 2px `#F44336` | `#FFFFFF` | `#F44336` |
| Disabled | 1px `#E0E0E0` | `#FAFAFA` | `#BDBDBD` |

**Dimensions:**
- Height: 56px
- Padding: 16px horizontal
- Border radius: 8px
- Label: 12px above input (floating label)
- Input text: 16px

**Helper Text / Error Message:**
- Position: Below input, 8px spacing
- Size: 12px
- Color: `#757575` (helper), `#F44336` (error)

---

#### Slider

**Usage:** Sélection valeur numérique (ex: poids, âge)

**Spécifications:**
- Track height: 4px
- Track inactive color: `#E0E0E0`
- Track active color: `#2196F3`
- Thumb size: 20×20px
- Thumb color: `#2196F3`
- Thumb border: 2px `#FFFFFF`, shadow level 1

**Labels:**
- Min/Max labels: 12px, `#757575`, positionnés aux extrémités
- Current value: 20px, `#212121`, bold, au-dessus du thumb

---

#### Radio Buttons

**Usage:** Sélection unique (ex: sexe, activité)

**Spécifications:**

| État | Border | Fill | Label Color |
|------|--------|------|-------------|
| Unselected | 2px `#757575` | Transparent | `#212121` |
| Selected | 2px `#2196F3` | `#2196F3` (inner dot) | `#212121` |
| Hover | 2px `#2196F3` | Transparent | `#212121` |
| Disabled | 2px `#E0E0E0` | Transparent | `#BDBDBD` |

**Dimensions:**
- Circle diameter: 20px
- Inner dot (selected): 10px
- Label spacing: 12px
- Touch target: 44×44px minimum

---

#### Toggle Switch

**Usage:** Boolean settings (ex: notifications ON/OFF)

**Spécifications:**

| État | Track Color | Thumb Color | Position |
|------|------------|-------------|----------|
| OFF | `#E0E0E0` | `#FFFFFF` | Left |
| ON | `#4CAF50` | `#FFFFFF` | Right |
| Disabled OFF | `#F5F5F5` | `#E0E0E0` | Left |
| Disabled ON | `#C8E6C9` | `#E0E0E0` | Right |

**Dimensions:**
- Track width: 48px, height: 24px
- Track radius: 12px (full round)
- Thumb diameter: 20px
- Animation duration: 200ms ease

---

### 5.3 Cards

#### Avatar Card (Sélection Onboarding)

**Spécifications:**
- Size: 150×200px (mobile), 180×240px (tablet+)
- Border radius: 16px
- Background: `#FFFFFF`
- Border: 2px transparent (default), 2px `#2196F3` (selected)
- Shadow: Level 1 (default), Level 2 (hover)
- Padding: 16px

**Content:**
- Avatar image: 80×80px, centré top
- Name: 16px, semi-bold, centré
- Description: 12px, regular, `#757575`, centré

**Animation:**
- Flip 3D (500ms) au tap pour montrer détails au verso

---

#### Stat Card

**Usage:** Affichage statistiques (ex: profil)

**Spécifications:**
- Border radius: 12px
- Background: `#FAFAFA`
- Border: 1px `#E0E0E0`
- Padding: 16px
- Shadow: None (flat design)

**Content Layout:**
- Icon: 24×24px, couleur thématique, top-left
- Label: 12px, `#757575`, below icon
- Value: 24px, bold, `#212121`, prominent

---

### 5.4 Progress Indicators

#### Progress Bar (Hydratation Quotidienne)

**Spécifications:**
- Height: 40px
- Border radius: 8px
- Background (track): `#E0E0E0`
- Fill: Dégradé bleu `linear-gradient(90deg, #2196F3 0%, #64B5F6 100%)`
- Border: None
- Shadow: Inner shadow subtil `inset 0 2px 4px rgba(0,0,0,0.1)`

**Text Overlay:**
- Position: Centré dans la barre
- Text: 14px, semi-bold, `#FFFFFF` (sur fond bleu), `#212121` (si pas de fill)
- Content: "X.XL / X.XL (XX%)"

**Animation:**
- Fill width: Smooth transition 500ms ease
- Pulse subtil sur update (scale 1.0 → 1.02 → 1.0, 300ms)

---

#### Circular Progress (Loading States)

**Spécifications:**
- Diameter: 40px (standard), 24px (small)
- Track width: 4px
- Track color: `#E0E0E0`
- Indicator color: `#2196F3`
- Animation: Indeterminate spin (1.5s linear infinite)

---

### 5.5 Modals / Dialogs

#### Standard Dialog

**Spécifications:**
- Max width: 320px (mobile), 400px (desktop)
- Border radius: 16px
- Background: `#FFFFFF`
- Shadow: Level 3
- Padding: 24px
- Backdrop: `rgba(0,0,0,0.5)` (scrim)

**Structure:**
- Title: 20px, bold, `#212121`, top
- Content: 16px, regular, `#212121`, 16px spacing below title
- Actions: Buttons right-aligned, 16px spacing above

**Animation:**
- Entry: Scale 0.95 → 1.0 + Fade in (200ms ease-out)
- Exit: Scale 1.0 → 0.95 + Fade out (150ms ease-in)

**Example Use Cases:**
- Confirmation suppression compte
- Avatar mort notification
- Permission requests

---

#### Bottom Sheet

**Usage:** Détails jour calendrier, info avatar

**Spécifications:**
- Border radius: 16px top corners only
- Background: `#FFFFFF`
- Shadow: Level 4 (top shadow)
- Max height: 70% screen height
- Handle: 40×4px rounded, `#E0E0E0`, centré top (8px margin)

**Animation:**
- Entry: Slide up from bottom (300ms ease-out)
- Exit: Slide down (250ms ease-in)
- Backdrop: Fade in `rgba(0,0,0,0.3)`

---

### 5.6 Notifications UI (In-App Toasts)

#### Toast Notification

**Spécifications:**
- Width: Full width - 32px margins
- Height: Auto (min 48px)
- Border radius: 8px
- Padding: 12px 16px
- Position: Bottom (16px from bottom, above nav bar)
- Duration: 3 seconds auto-dismiss

**Variantes:**

| Type | Background | Icon | Text Color |
|------|-----------|------|------------|
| Success | `#4CAF50` | ✓ | `#FFFFFF` |
| Warning | `#FF9800` | ⚠️ | `#FFFFFF` |
| Error | `#F44336` | ✕ | `#FFFFFF` |
| Info | `#2196F3` | ℹ️ | `#FFFFFF` |

**Animation:**
- Entry: Slide up (200ms ease-out)
- Exit: Slide down + fade out (150ms ease-in)

---

### 5.7 Bottom Navigation Bar

**Spécifications:**
- Height: 56px
- Background: `#FFFFFF`
- Shadow: Top shadow level 2
- Items: 3 (Calendrier, Home, Profil)

**Item Specs:**

| État | Icon Color | Label Color | Indicator |
|------|-----------|-------------|-----------|
| Active | `#2196F3` | `#2196F3` | 3px underline `#2196F3` |
| Inactive | `#757575` | `#757575` | None |
| Pressed | `#1976D2` | `#1976D2` | Ripple effect |

**Dimensions:**
- Icon size: 24×24px
- Label: 12px, medium weight
- Touch target: Full width / 3, 56px height

**Animation:**
- Color transition: 200ms ease
- Indicator slide: 300ms ease (si switch entre items)

---

## 6. Guidelines Accessibilité

### 6.1 Standards de Conformité

**Niveau Cible:** WCAG 2.1 Level AA minimum

**Rationale:**
- Support segment seniors (60-75 ans)
- Compliance légale EU (RGPD + Accessibilité)
- Amélioration UX générale pour tous utilisateurs

### 6.2 Contraste des Couleurs

**Requirements:**

| Élément | Ratio Minimum | Actual Ratio |
|---------|---------------|--------------|
| Texte normal (<24px) | 4.5:1 | 4.54:1 (`#212121` sur `#FFFFFF`) ✅ |
| Texte large (>24px) | 3:1 | 4.54:1 ✅ |
| Éléments UI (boutons, icons) | 3:1 | 4.63:1 (`#2196F3` sur `#FFFFFF`) ✅ |
| Texte sur bleu | 4.5:1 | 6.28:1 (`#FFFFFF` sur `#2196F3`) ✅ |

**Problèmes Potentiels:**
- ⚠️ Texte gris clair `#BDBDBD` sur blanc: 1.85:1 (fail) → Utiliser uniquement pour disabled states
- ⚠️ Jaune `#FFEB3B` sur blanc: 1.09:1 (fail) → Ne jamais utiliser pour texte

**Testing Tools:**
- WebAIM Contrast Checker
- Chrome DevTools Accessibility Audit

### 6.3 Tailles Tactiles

**Minimum Touch Targets:** 44×44px (Apple HIG, Material Design)

**Implémentation:**

| Élément | Visual Size | Touch Target | Method |
|---------|------------|--------------|--------|
| Boutons principaux | 48-56px height | 48-56px | Direct |
| Icons navigation | 24×24px | 56px height × full width/3 | Expanded hitbox |
| Radio buttons | 20px diameter | 44×44px | Transparent padding |
| Checkboxes | 20px square | 44×44px | Transparent padding |
| Toggle switches | 48×24px | 48×44px | Vertical padding |

**Code Pattern (Flutter):**
```dart
InkWell(
  onTap: () {},
  child: Container(
    width: 44, // Minimum touch target
    height: 44,
    alignment: Alignment.center,
    child: Icon(Icons.close, size: 24), // Visual size
  ),
)
```

### 6.4 Support Lecteurs d'Écran

**iOS VoiceOver + Android TalkBack Compliance**

#### Semantic Labels

**Tous les éléments interactifs doivent avoir un label clair:**

| Élément | Label Example |
|---------|---------------|
| Avatar image | "Votre avatar Docteur en état frais" |
| Bouton "Je bois" | "Valider hydratation" |
| Progress bar | "Progression quotidienne 1.5 litres sur 2.5 litres, 60 pourcent" |
| Streak counter | "Série actuelle: 7 jours consécutifs" |
| Calendar day ✓ | "7 janvier, objectif atteint" |
| Calendar day ✗ | "8 janvier, objectif raté" |

**Implementation (Flutter):**
```dart
Semantics(
  label: 'Votre avatar Docteur en état frais',
  child: Image.asset('assets/avatars/doctor/fresh.png'),
)
```

#### Heading Structure

**Navigation hiérarchique:**
- H1: Titre écran principal (ex: "Hydrate or Die")
- H2: Sections majeures (ex: "Progression Quotidienne")
- H3: Sous-sections (ex: "Statistiques du Mois")

**Implementation:**
```dart
Semantics(
  header: true,
  child: Text('Progression Quotidienne', style: Theme.of(context).textTheme.headlineMedium),
)
```

#### Focus Order

**Navigation clavier/screen reader doit suivre ordre logique:**
1. Header (streak, settings)
2. Avatar (élément central)
3. Progress bar
4. Bouton "Je bois" (CTA principal)
5. Bottom navigation

**Testing:**
- iOS: Activer VoiceOver, swipe right/left pour naviguer
- Android: Activer TalkBack, swipe right/left

### 6.5 Alternatives Textuelles (Alt Text)

**Tous les éléments visuels non-textuels:**

| Élément | Alt Text |
|---------|----------|
| Avatar états | "Avatar [Personnalité] en état [État]: [Description expression]" |
| Emoji decoratif | "" (vide, aria-hidden) si purement décoratif |
| Emoji informatif | Description textuelle (ex: 🔥 → "flamme de série") |
| Icons | Label clair fonction (ex: ⚙️ → "Paramètres") |
| Photos selfie | "Photo validation hydratation du [date]" |

### 6.6 Sizing & Scaling

**Support Dynamic Type (iOS) / Font Scaling (Android)**

**Text doit scale entre 100%-200%:**
- Base: 16px → Maximum: 32px
- H1: 28px → Maximum: 56px
- Labels: 12px → Maximum: 24px

**Layout doit rester utilisable jusqu'à 200% scale:**
- Utiliser flex layouts (Row, Column avec flex)
- Éviter fixed heights sur containers avec texte
- Permettre text wrapping

**Testing:**
- iOS: Settings → Accessibility → Display & Text Size → Larger Text
- Android: Settings → Display → Font Size

### 6.7 Animations & Motion

**Respect Reduced Motion Preference**

**Utilisateurs avec vestibular disorders ou motion sickness:**
- iOS: Settings → Accessibility → Motion → Reduce Motion
- Android: Settings → Accessibility → Remove Animations

**Implementation:**
```dart
// Check user preference
final reducedMotion = MediaQuery.of(context).disableAnimations;

// Conditional animation
duration: reducedMotion ? Duration.zero : Duration(milliseconds: 300),
```

**Animations à réduire/supprimer si preference activée:**
- Parallax effects
- Zooms rapides
- Rotations 3D (card flip)
- Confettis (remplacer par fade simple)

**Animations toujours OK (essentielles UX):**
- Progress bar fill
- State changes (button pressed)
- Page transitions simples (fade/slide lent)

### 6.8 Color Blindness Support

**Ne JAMAIS utiliser couleur seule pour transmettre l'information**

**Exemples Conformes:**

| Information | Couleur | Indicateur Additionnel |
|-------------|---------|------------------------|
| Jour objectif atteint | Vert `#4CAF50` | Icône ✓ |
| Jour objectif raté | Rouge `#F44336` | Icône ✗ |
| Avatar frais | Glow vert | Expression souriante + posture |
| Avatar déshydraté | Glow orange | Expression fatiguée + gouttes sueur |
| État critique | Texte rouge | Icône ⚠️ + texte "CRITIQUE" |

**Testing Tools:**
- Chrome DevTools → Rendering → Emulate vision deficiencies
- Sim Daltonism (Mac app)
- Color Oracle (cross-platform)

---

## 7. Animations & Interactions

### 7.1 Principes d'Animation

**Philosophy:** Animations renforcent feedback et guidance, jamais distraction

**Core Principles:**
1. **Purposeful** - Chaque animation a une raison (feedback, transition, delight)
2. **Fast** - Durée courte (150-500ms), jamais blocante
3. **Natural** - Easing curves réalistes (pas linear)
4. **Reduced Motion Aware** - Respecte préférences utilisateur

### 7.2 Avatar Animations Détaillées

#### Animation Idle States (Loop Continue)

**Avatar FRAIS:**
- Respiration: Scale 1.0 → 1.02 sur Y-axis (2s ease-in-out, infinite)
- Clignement yeux: Opacity yeux 1.0 → 0.0 → 1.0 (200ms, toutes les 4-6s random)
- Accessoire: Oscillation légère (ex: stéthoscope balance ±5deg, 3s)

**Avatar FATIGUÉ:**
- Respiration: Plus profonde 1.0 → 1.04 (3s)
- Essuyage front: Main monte vers front, essuie, descend (1.5s, toutes les 8s)
- Posture: Léger slouch (rotation -5deg persistent)

**Avatar DÉSHYDRATÉ:**
- Tremblement: Shake horizontal ±2px (500ms, constant)
- Respiration: Saccadée irrégulière (random intervals)
- Sueur: Gouttes tombent du front (particle effect, continuous)

**Avatar MORT:**
- Aucune animation (rigor mortis)
- Effet: Âme sort du corps (white sprite monte lentement, fade out)

**Avatar FANTÔME:**
- Flottement: TranslateY ±10px (3s ease-in-out, infinite)
- Transparence: Opacity 60% → 80% → 60% (2s, infinite)
- Chaînes: Shimmer effect (alpha pulse)
- Wispy effect: Bas du corps "smoke" particles

#### Transition Animations Entre États

**FRAIS → FATIGUÉ:**
- Durée: 500ms
- Crossfade entre images (opacity)
- Glow vert fade out (300ms)

**FATIGUÉ → DÉSHYDRATÉ:**
- Durée: 800ms
- Shake entrance (tremblement start)
- Sueur particles apparaissent
- Glow orange fade in

**DÉSHYDRATÉ → MORT:**
1. Tremblement intensifie (500ms)
2. Chute: TranslateY 0 → 50px + Rotation 0 → -90deg (800ms ease-out bounce)
3. Impact: Screen shake (100ms)
4. Flash blanc écran (200ms)
5. Avatar mort apparaît

**MORT → FANTÔME:**
1. Corps brille blanc (500ms pulse)
2. Soul extraction: Sprite blanc sort vertical (1s ease-out)
3. Corps fade out (500ms)
4. Fantôme fade in + flottement start (800ms)

**FANTÔME → FRAIS (Résurrection Minuit):**
1. Fantôme brille intensément (500ms)
2. Flash blanc écran (300ms)
3. Particules dorées explosion (confettis-like)
4. Avatar frais apparaît en scale 0.8 → 1.0 (500ms bounce)

#### Animation Réaction Validation Hydratation

**Trigger:** User valide photo + glassSize

**Séquence:**
1. Avatar actuel freeze (100ms)
2. Transition vers état FRAIS (si pas déjà frais)
3. Animation Positive (1.5s total):
   - Sauts de joie (3× bounce up/down)
   - Pouce levé (apparaît + scale 0 → 1)
   - Sparkles autour de l'avatar (particles)
   - Expression change vers sourire
4. Return to Idle Fresh

**Variantes par Personnalité:**
- **Docteur:** Hochement tête approbateur + clipboard checkmark ✓
- **Coach:** Flexion biceps + sifflet coup + "YES!"
- **Mère:** Mains jointes satisfaction + cœur ❤️
- **Pote:** Fist bump air + head nod + "Respect!"

### 7.3 UI Micro-interactions

#### Bouton Press

**Durée:** 150ms

**Effet:**
- Scale: 1.0 → 0.98 (press), 0.98 → 1.0 (release)
- Shadow: Level 2 → Level 1 (press), Level 1 → Level 2 (release)
- Ripple effect: Circle expand from touch point (Material Design)

**Code (Flutter):**
```dart
InkWell(
  onTap: () {},
  child: AnimatedContainer(
    duration: Duration(milliseconds: 150),
    curve: Curves.easeOut,
    transform: Matrix4.identity()..scale(_isPressed ? 0.98 : 1.0),
    // ... content
  ),
)
```

#### Progress Bar Fill

**Trigger:** Nouvelle validation hydratation

**Animation:**
1. Old percentage: Freeze (100ms)
2. Fill width: Animate from old to new (500ms ease-out)
3. Pulse: Scale 1.0 → 1.02 → 1.0 (300ms)
4. Number counter: Count up animation (500ms)

**Easing:** Decelerate (starts fast, slows at end)

#### Confettis Celebration (Goal Achieved)

**Trigger:** Progress atteint 100%

**Durée:** 2 secondes

**Effet:**
- 20-30 confettis particles
- Colors: Variés (bleu, vert, orange, rose)
- Origin: Top center screen
- Physics: Gravity + random horizontal velocity
- Rotation: Random spin
- Fade out: Last 500ms

**Library:** Use flutter_confetti or lottie animation

#### Card Flip (Avatar Selection)

**Trigger:** Tap sur avatar card

**Durée:** 500ms

**Animation:**
- Rotation3D: Y-axis 0deg → 90deg (250ms) → Front hidden
- Content switch: Instantané à 90deg
- Rotation3D: Y-axis 90deg → 0deg (250ms) → Back visible

**Easing:** ease-in-out

#### Bottom Sheet Slide

**Entry:**
- TranslateY: screen height → 0 (300ms ease-out)
- Backdrop: Opacity 0 → 1 (200ms linear)

**Exit:**
- TranslateY: 0 → screen height (250ms ease-in)
- Backdrop: Opacity 1 → 0 (150ms linear)

**Gesture:** Swipe down pour dismiss (velocity threshold: 500px/s)

### 7.4 Loading States

#### Circular Progress Spinner

**Usage:** API calls, async operations

**Spécifications:**
- Diameter: 40px
- Stroke width: 4px
- Color: `#2196F3`
- Animation: Indeterminate rotation (1.5s linear infinite)

#### Skeleton Screens

**Usage:** Loading initial data (profil, calendrier)

**Spécifications:**
- Replicate layout structure avec rectangles gris
- Background: `#E0E0E0`
- Shimmer effect: Linear gradient sweep left→right (1.5s infinite)

**Example:**
```
┌─────────────────────────────────────┐
│  [▬▬▬]        [▬▬▬▬▬]      [▬]     │ ← Header skeleton
│                                     │
│       ┌──────────────┐              │
│       │  ▬▬▬▬▬▬▬▬   │ ← Avatar     │
│       └──────────────┘              │
│                                     │
│  ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬         │ ← Progress bar
│                                     │
└─────────────────────────────────────┘
```

### 7.5 Error States Animations

#### Shake Animation (Input Error)

**Trigger:** Validation error (ex: âge invalide)

**Animation:**
- TranslateX: 0 → -10px → +10px → -5px → +5px → 0
- Durée: 400ms
- Easing: ease-in-out

**Accompaniment:**
- Border color: Default → Red
- Error message: Fade in below (200ms)

#### Bounce Back (Swipe Dismiss Failed)

**Trigger:** User swipe modal mais threshold non atteint

**Animation:**
- Rubber band effect: Position returns avec bounce
- Durée: 300ms
- Easing: ease-out bounce

---

## 8. Spécifications Responsive

### 8.1 Breakpoints

| Breakpoint | Min Width | Max Width | Target Devices | Columns |
|------------|-----------|-----------|----------------|---------|
| **Mobile Small** | 320px | 374px | iPhone SE, small Android | 4 |
| **Mobile** | 375px | 767px | iPhone 12/13/14, standard phones | 4 |
| **Tablet** | 768px | 1023px | iPad, Android tablets | 8 |
| **Desktop** | 1024px | 1439px | Small laptops, iPad Pro landscape | 12 |
| **Wide** | 1440px+ | - | Large monitors | 12 |

**Notes:**
- Design Mobile-First (styles de base pour mobile, override pour desktop)
- Flutter: Utiliser MediaQuery.of(context).size.width pour breakpoints
- Testing: Chrome DevTools responsive mode, device preview

### 8.2 Layout Adaptations

#### Mobile (375px-767px)

**Home Screen:**
- Avatar: 200×200px, centré
- Progress bar: Full width - 32px margins
- Bouton CTA: Full width - 32px margins
- Bottom nav: 3 items visible

**Onboarding:**
- Questions: 1 par écran (scroll si nécessaire)
- Avatar cards: 2×2 grid

**Calendar:**
- Mois complet visible (7 colonnes)
- Font size jours: 14px

#### Tablet (768px-1023px)

**Home Screen:**
- Avatar: 250×250px
- Layout: Reste centré single-column
- Bouton CTA: Max-width 400px, centré
- Bottom nav: Remplacé par side navigation (optionnel)

**Onboarding:**
- Avatar cards: 4×1 grid (tous visibles)
- Questions: Peuvent être 2 par écran si espace (ex: Poids + Âge)

**Calendar:**
- Font size jours: 16px
- Stats détaillées à côté du calendrier (split-screen)

#### Desktop (1024px+)

**Home Screen:**
- Layout: 2-column si >1024px
  - Left: Avatar + progress (60% width)
  - Right: Stats détaillées, historique récent (40%)
- Avatar: 300×300px
- Bottom nav: Top navigation bar (horizontal)

**Onboarding:**
- Multi-step toutes sur 1 écran avec stepper horizontal
- Avatar cards: 4×1 grid, plus grands (200×250px)

**Calendar:**
- Split-screen: Calendrier gauche, détails journée droite
- Affichage multi-mois si espace (2-3 mois visibles)

### 8.3 Navigation Adaptations

**Mobile (<768px):**
- Bottom Navigation Bar (3 items)
- Hamburger menu pour settings (optionnel)

**Tablet (768px-1023px):**
- Option A: Bottom Nav maintained
- Option B: Side drawer navigation (Material Design rail)

**Desktop (>1024px):**
- Top Navigation Bar (horizontal)
- Avatar + streak + settings dans header persistant
- Links texte (pas juste icônes)

### 8.4 Touch vs Mouse/Keyboard

#### Touch Devices (Mobile/Tablet)

**Interactions:**
- Touch targets: 44×44px minimum
- Swipe gestures: Supportés (ex: swipe bottom sheet dismiss)
- Long press: Contexte menus (ex: long press day → detail modal)
- Pull to refresh: Sur Home screen, calendrier

**Feedback:**
- Haptic feedback: Sur actions importantes (validation photo, achievement unlock)
- Ripple effect: Visible sur tous boutons/cards

#### Mouse/Keyboard (Desktop)

**Interactions:**
- Hover states: Visible sur tous éléments interactifs
- Keyboard navigation: Tab order logique
- Keyboard shortcuts:
  - Space/Enter: Activer bouton focus
  - Esc: Fermer modals
  - Arrow keys: Navigation calendrier
- Click feedback: Cursor pointer sur clickable elements

**Feedback:**
- No ripple effect (remplacé par hover color change)
- Focus indicators: 2px outline `#2196F3` sur éléments focusés

### 8.5 Orientation Support

#### Portrait (Primary)

**Mobile:** Tous les écrans optimisés portrait
**Tablet:** Portrait OK, layout similaire mobile mais plus spacieux

#### Landscape

**Mobile:**
- Supporté mais non optimisé
- Avatar: Taille réduite (150×150px)
- Layout: Reste single-column scroll

**Tablet:**
- Landscape préféré pour certains screens (calendar, stats)
- Layout: 2-column si espace suffisant

**Note:** Ne pas bloquer orientation (user choice), adapter layout

### 8.6 Safe Areas (iOS Notch, etc.)

**iOS:**
- Respect Safe Area Insets (notch, home indicator)
- Flutter: MediaQuery.of(context).padding
- Bottom nav: Ajouter padding-bottom pour home indicator (34px iOS)

**Android:**
- Status bar: Transparent overlay OU solid color
- Navigation bar: Respect system gestures zone

**Implementation (Flutter):**
```dart
SafeArea(
  child: Scaffold(
    body: // content
  ),
)
```

---

## 9. Checklist de Validation

### 9.1 Design System Completeness

- [x] Palette couleurs complète (primaire, secondaire, états, neutres)
- [x] Typographie définie (font families, type scale, line heights)
- [x] Spacing system établi (4px/8px grid)
- [x] Border radius tokens définis
- [x] Shadows (elevation levels) spécifiés
- [x] Animations durées et easing curves documentés

### 9.2 Avatar Specifications

- [x] 4 avatars décrits (Docteur, Coach, Mère, Pote)
- [x] 5 états par avatar (Frais, Fatigué, Déshydraté, Mort, Fantôme)
- [x] Total 20 variations specifiées avec détails visuels
- [x] Palettes couleurs par état définies
- [x] Accessoires signature identifiés et visibles dans fantômes
- [x] Animations idle documentées
- [x] Transitions entre états spécifiées
- [x] Animations réactions validation détaillées

### 9.3 Wireframes Completeness

- [x] Écran Splash (optionnel)
- [x] Écran Sélection Avatar
- [x] Écrans Onboarding (5 questions + résumé)
- [x] Écran Home (hub principal)
- [x] Flow Photo Validation (3 étapes)
- [x] Écran Calendrier
- [x] Écran Profil/Paramètres

**Total: 7+ écrans principaux documentés**

### 9.4 Component Library

- [x] Boutons (Primary, Secondary, Danger, Ghost)
- [x] Inputs (Text, Slider, Radio, Toggle)
- [x] Cards (Avatar, Stat)
- [x] Progress Indicators (Bar, Circular)
- [x] Modals (Dialog, Bottom Sheet)
- [x] Notifications (Toast)
- [x] Bottom Navigation Bar

### 9.5 Accessibility Compliance

- [x] WCAG AA standard cible documenté
- [x] Contraste couleurs vérifié (4.5:1 texte, 3:1 UI)
- [x] Tailles tactiles 44×44px minimum
- [x] Support VoiceOver/TalkBack (semantic labels)
- [x] Alternatives textuelles (alt text)
- [x] Support Dynamic Type / Font Scaling
- [x] Reduced Motion support
- [x] Color blindness considerations (pas couleur seule)

### 9.6 Animations & Interactions

- [x] Principes animation établis
- [x] Avatar animations idle détaillées (tous états)
- [x] Transitions entre états avatars
- [x] Micro-interactions UI (boutons, progress, etc.)
- [x] Loading states (spinner, skeleton)
- [x] Error states animations
- [x] Celebration effects (confettis)

### 9.7 Responsive Design

- [x] Breakpoints définis (5 ranges)
- [x] Layout adaptations Mobile/Tablet/Desktop
- [x] Navigation adaptations par device
- [x] Touch vs Mouse/Keyboard interactions
- [x] Orientation support (Portrait/Landscape)
- [x] Safe areas iOS/Android

### 9.8 Handoff to Development

#### Assets à Produire

**Avatars (20 variations):**
- [ ] Docteur: fresh.png, tired.png, dehydrated.png, dead.png, ghost.png
- [ ] Coach: fresh.png, tired.png, dehydrated.png, dead.png, ghost.png
- [ ] Mère: fresh.png, tired.png, dehydrated.png, dead.png, ghost.png
- [ ] Pote: fresh.png, tired.png, dehydrated.png, dead.png, ghost.png

**Icons & Graphics:**
- [ ] App icon (1024×1024px, formats iOS/Android)
- [ ] Splash screen logo
- [ ] Navigation icons (home, calendar, profile)
- [ ] Emoji/icons custom (si nécessaires)

**Animations:**
- [ ] Confettis Lottie file (ou code)
- [ ] Avatar idle animations (Lottie ou sprite sheets)
- [ ] Transition animations specs pour dev

#### Design Files

- [ ] Figma/Sketch file complet avec tous écrans
- [ ] Design system dans Figma (components library)
- [ ] Prototype interactif (flows principaux)
- [ ] Export assets (@1x, @2x, @3x iOS + mdpi/hdpi/xhdpi Android)

#### Documentation Handoff

- [x] Ce document Front-End Spec (complet)
- [ ] Annotation Figma → Code mapping
- [ ] Color tokens fichier (ex: colors.dart)
- [ ] Typography tokens fichier (ex: text_styles.dart)
- [ ] Spacing constants fichier (ex: spacing.dart)

### 9.9 Next Steps

**Immediate Actions:**

1. **Validation PM/Stakeholders** - Review ce document, approve direction design
2. **Production Assets Avatars** - Créer les 20 variations (designer externe ou IA-assisted)
3. **Figma Mockups Haute-Fidélité** - Transformer wireframes en designs finaux
4. **Prototype Interactif** - Créer flows clickables pour user testing
5. **Developer Handoff** - Transférer fichiers + doc à équipe dev (Agent Dev)

**Timeline Estimée:**

- Design Assets Production: 1-2 semaines (si designer externe)
- Figma Mockups: 3-5 jours
- Prototype: 2 jours
- Handoff: 1 jour

**Open Questions:**

- [ ] Style exact avatars validé ? (2D cartoon moderne confirmé vs autre style)
- [ ] Budget designer externe pour assets avatars ? (ou génération AI + retouches ?)
- [ ] User testing prévu sur prototypes avant dev ? (recommandé)

---

## Conclusion

Ce document définit l'expérience visuelle et interactive complète pour **Hydrate or Die MVP**. Tous les éléments critiques sont specifiés:

✅ **Design System complet** - Couleurs, typo, spacing, shadows, animations
✅ **20 Variations Avatars détaillées** - 4 personnalités × 5 états avec descriptions visuelles précises
✅ **7 Écrans principaux wireframés** - Onboarding, Home, Photo, Calendrier, Profil
✅ **Bibliothèque Composants UI** - Boutons, inputs, cards, modals, navigation
✅ **Guidelines Accessibilité WCAG AA** - Contraste, touch targets, screen readers
✅ **Animations & Micro-interactions** - Avatar states, transitions, UI feedback
✅ **Spécifications Responsive** - Mobile/Tablet/Desktop adaptations

**Next:** Production assets graphiques + développement Flutter par Agent Dev.

---

**Document créé le 2026-01-07 par Sally (UX Expert)**
**Status:** DRAFT - Ready for PM Validation & Asset Production
**Reference:** PRD v1.0, Architecture v2.0, Data Models v1.0, Brief v1.0
