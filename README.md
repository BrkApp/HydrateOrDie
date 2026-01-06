# HydrateOrDie 💀💧

**L'app de rappel d'hydratation la plus punitive du marché.**

Une app mobile native (iOS/Android) qui te spam de notifications jusqu'à ce que tu boives de l'eau.

## Stack Technique

- **Expo** (managed workflow)
- **React Native** 0.76+
- **react-native-reanimated** (animations fluides)
- **expo-image-picker** (caméra)
- **expo-notifications** (notifications punitives)
- **AsyncStorage** (persistence locale)
- **react-native-svg** (graphiques vectoriels)

## Installation

### Prérequis

- Node.js 18+
- npm ou yarn
- **Expo Go** app sur ton téléphone ([Android](https://play.google.com/store/apps/details?id=host.exp.exponent) | [iOS](https://apps.apple.com/app/expo-go/id982107779))

### Setup

```bash
# Installer les dépendances
npm install

# Lancer le serveur de développement
npm start
```

## Tester sur ton téléphone Android

### Option 1 : Expo Go (RECOMMANDÉ pour dev)

1. Lance `npm start`
2. Un QR code s'affiche dans le terminal
3. **Sur ton téléphone Android** :
   - Installe **Expo Go** depuis le Play Store
   - Ouvre Expo Go
   - Scan le QR code
4. L'app se lance instantanément ! ✨

### Option 2 : Build APK (pour distribuer)

```bash
# Install EAS CLI
npm install -g eas-cli

# Login to Expo
eas login

# Build APK
eas build --platform android --profile preview

# Télécharge l'APK et installe-le sur ton téléphone
```

## Features

### ✅ Implémentées (v1.0)

- **Effet eau qui monte** : Animation fluide du niveau d'eau du bas de l'écran
- **Logo squelette** : Centré dans l'eau, rappel visuel permanent
- **Messages punitifs** : Change selon ton niveau d'hydratation
  - < 30% : "Ton corps est 60% d'eau et 40% de déception"
  - 30-70% : "Les plantes boivent plus que toi. LES. PLANTES."
  - 70-100% : "Tu es presque hydraté. Presque."
  - 100%+ : "Wow. T'as réussi à boire de l'eau. Bravo."
- **Bouton caméra** : Prends une photo de ton verre → +250ml
- **Streak counter** : Nombre de jours consécutifs avec objectif atteint
- **Onboarding** : Définis ton objectif quotidien (défaut 2000ml)
- **Notifications locales** :
  - Reminders normaux toutes les heures (8h-22h)
  - Mode spam toutes les 5 min si pas bu depuis 2h
  - Messages qui escaladent (Normal → Warning → Spam → Aggressive)
- **Stockage local** :
  - Progression quotidienne
  - Streak
  - Objectif personnalisé
  - Reset automatique quotidien
  - Historique photos

### 🚧 À venir (Phase 2)

- **Détection ML** : TensorFlow Lite pour valider que c'est bien de l'eau
- **Graphiques** : Historique sur 7/30 jours
- **Thèmes personnalisés** : Couleurs et messages custom
- **Partage social** : Screenshot de ton streak
- **Apple HealthKit / Google Fit** : Sync hydratation

## Structure du projet

```
/
├── App.js                    # Point d'entrée
├── package.json
├── app.json                  # Config Expo
├── babel.config.js
├── screens/
│   ├── OnboardingScreen.js   # Premier lancement
│   ├── HomeScreen.js         # Écran principal
│   └── CameraScreen.js       # Validation photo
├── components/
│   ├── WaterEffect.js        # Animation eau qui monte
│   └── SkullLogo.js          # Logo SVG
├── services/
│   ├── storage.js            # AsyncStorage
│   └── notifications.js      # Push notifications
├── utils/
│   └── constants.js          # Couleurs, messages
└── assets/
    └── (icons à ajouter)
```

## Commandes

```bash
# Développement
npm start              # Lance Metro bundler
npm run android        # Lance sur émulateur Android
npm run ios            # Lance sur simulateur iOS (Mac seulement)

# Production
eas build              # Build APK/IPA
```

## Design

- **Palette** : Bleus électriques (#00B4D8), rouge punchy (#EF476F), vert lime (#06FFA5)
- **Dark mode** : Par défaut, fond #1A1B2E
- **Animations** : Over-the-top, impossibles à ignorer
- **Ton** : Agressif rigolo + absurde délirant

## Développement futur

### ML Photo Detection

```javascript
// Dans CameraScreen.js, ligne ~28
// TODO: Ajouter TensorFlow Lite
import * as tf from '@tensorflow/tfjs';
import { bundleResourceIO } from '@tensorflow/tfjs-react-native';

async function detectWater(imageUri) {
  // Charger modèle pré-entraîné
  const model = await tf.loadGraphModel(bundleResourceIO(modelJson, modelWeights));

  // Prétraiter image
  const imageTensor = await imageToTensor(imageUri);

  // Prédiction
  const predictions = await model.predict(imageTensor);

  // Retourner si eau détectée avec confidence > 0.7
  return predictions;
}
```

## Troubleshooting

### "Expo Go" ne se connecte pas

- Assure-toi que ton téléphone et ton PC sont sur le **même WiFi**
- Désactive temporairement le VPN si activé
- Utilise le mode tunnel : `expo start --tunnel`

### Notifications ne fonctionnent pas

- Les notifications ne fonctionnent pas dans Expo Go
- Il faut build un APK standalone : `eas build`

### Erreur de build

- Supprime node_modules : `rm -rf node_modules && npm install`
- Clear cache Expo : `expo start -c`

## License

Propriétaire - BrkApp 2026

## Roadmap

- [x] Setup Expo + React Native
- [x] Animation eau qui monte
- [x] Logo squelette
- [x] Caméra + photo
- [x] Notifications locales
- [x] AsyncStorage
- [x] Messages punitifs
- [ ] Détection ML (TensorFlow)
- [ ] Graphiques historique
- [ ] Thèmes custom
- [ ] Partage social
- [ ] Sync HealthKit

---

**Bois ou meurs.** 💀💧
