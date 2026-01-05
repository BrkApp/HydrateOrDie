# HydrateOrDie 💧💀

**Bois ou meurs** - L'app de rappel d'hydratation la plus punitive du marché.

## Stack Technique

- **React 18** + TypeScript
- **Vite** (build ultra-rapide)
- **Capacitor** (iOS/Android natif)
- **TailwindCSS v3** (Material Design 3)
- **Zustand** (state management)
- **React Router** (navigation)
- **i18next** (FR/EN)
- **Framer Motion** (animations)
- **TensorFlow.js** (détection d'eau - Phase 4)

## Installation

```bash
# Installer les dépendances
npm install

# Lancer en développement (navigateur)
npm run dev

# Builder pour production
npm run build
```

## Développement Mobile

```bash
# Ajouter les plateformes (une seule fois)
npx cap add android
npx cap add ios

# Synchroniser après chaque build
npm run build
npx cap sync

# Ouvrir dans Android Studio
npx cap open android

# Ouvrir dans Xcode
npx cap open ios
```

## Structure du Projet

```
src/
├── components/        # Composants réutilisables
│   ├── common/       # Boutons, inputs, etc.
│   ├── dashboard/    # Composants du dashboard
│   ├── onboarding/   # Composants onboarding
│   └── camera/       # Composants caméra
├── pages/            # Pages principales
│   ├── SplashScreen.tsx
│   ├── OnboardingPage.tsx
│   ├── DashboardPage.tsx
│   ├── CameraPage.tsx
│   └── SettingsPage.tsx
├── stores/           # Zustand stores
│   └── useAppStore.ts
├── services/         # Services (storage, API)
│   └── localStorage.ts
├── types/            # TypeScript types
│   └── index.ts
├── constants/        # Constantes et messages
│   └── messages.ts
├── i18n/            # Traductions
│   ├── index.ts
│   └── locales/
│       ├── fr.json
│       └── en.json
└── utils/           # Fonctions utilitaires
```

## Features (Phase 1 - ✅ Complétée)

✅ Setup complet Vite + React + Capacitor
✅ Architecture dossiers et TypeScript types
✅ Zustand store avec persistence LocalStorage
✅ SplashScreen avec animations
✅ Onboarding (4 étapes, calcul auto objectif)
✅ Dashboard (progress circulaire, streak, FAB)
✅ Settings (langue FR/EN, thème clair/sombre)
✅ 100+ messages notif (6 tons × 4 intensités)
✅ i18n FR/EN
✅ Build réussi (415 KB JS gzipped)

## Roadmap

### Phase 2 - UI Complète (À faire)
- Enrichir le Dashboard (graphiques, historique)
- Créer composants réutilisables
- Animations Framer Motion avancées
- Page Premium
- Page Notifications Settings

### Phase 3 - Notifications Push
- Scheduler avec work hours
- Spam mode progressif
- Local notifications avec Capacitor

### Phase 4 - Détection ML
- Intégration TensorFlow.js
- Détection verre/bouteille d'eau
- Validation photo avec confidence score

### Phase 5 - Premium & Distribution
- In-app purchases (RevenueCat)
- Build APK/IPA
- Tests sur devices
- Déploiement stores

## Messages Punitifs

L'app utilise 6 tons de messages :
- **PUNITIVE** : "💀 BOIS. MAINTENANT."
- **MOTIVATIONAL** : "💪 Tu peux le faire !"
- **FRIENDLY** : "😊 Hey, un petit verre ?"
- **PROFESSIONAL** : "📋 Hydratation recommandée."
- **AGGRESSIVE** : "🔥 SPAM MODE ACTIVÉ."
- **HUMOROUS** : "🦆 Même les canards boivent plus que toi."

Chaque ton a 4 niveaux d'intensité : NORMAL → WARNING → SPAM → AGGRESSIVE

## Commandes Utiles

```bash
# Dev server avec hot reload
npm run dev

# Build production
npm run build

# Preview du build
npm run preview

# Linter
npm run lint
```

## License

Propriétaire - BrkApp 2026
