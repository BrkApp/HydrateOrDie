export const COLORS = {
  // Bleus électriques
  PRIMARY: '#00B4D8',
  PRIMARY_DARK: '#0077B6',
  CYAN: '#00B4D8',

  // Rouge/Orange punchy
  DANGER: '#EF476F',
  URGENT: '#FF6B35',

  // Success
  SUCCESS: '#06FFA5',

  // Neutrals
  DARK_BG: '#1A1B2E',
  DARK_CARD: '#2B2D42',
  GRAY: '#8D99AE',

  // Text
  WHITE: '#FFFFFF',
  TEXT_LIGHT: 'rgba(255, 255, 255, 0.8)',
};

export const GLASS_ML = 250; // Standard glass size

export const MESSAGES = {
  DEHYDRATED: [
    'Ton corps est 60% d\'eau et 40% de déception',
    'Les plantes boivent plus que toi. LES. PLANTES.',
    'Tu vas mourir déshydraté',
    'Tes cellules pleurent',
  ],
  LOW: [
    'Allez, encore un effort !',
    'Tu es presque hydraté. Presque.',
    'Bois avant qu\'il soit trop tard',
  ],
  GOOD: [
    'Pas mal, continue !',
    'Tu es sur la bonne voie',
    'Encore un peu',
  ],
  ACHIEVED: [
    'Objectif atteint ! Tu vis !',
    'Wow. T\'as réussi à boire de l\'eau. Bravo.',
    'Félicitations, tu es hydraté',
  ],
};

export function getMotivationalMessage(currentMl, goalMl) {
  const percentage = (currentMl / goalMl) * 100;

  if (percentage >= 100) {
    return MESSAGES.ACHIEVED[Math.floor(Math.random() * MESSAGES.ACHIEVED.length)];
  } else if (percentage >= 70) {
    return MESSAGES.GOOD[Math.floor(Math.random() * MESSAGES.GOOD.length)];
  } else if (percentage >= 30) {
    return MESSAGES.LOW[Math.floor(Math.random() * MESSAGES.LOW.length)];
  } else {
    return MESSAGES.DEHYDRATED[Math.floor(Math.random() * MESSAGES.DEHYDRATED.length)];
  }
}
