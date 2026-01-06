import * as Notifications from 'expo-notifications';
import * as Device from 'expo-device';
import { Platform } from 'react-native';
import { storage } from './storage';

// Configuration du handler de notifications
Notifications.setNotificationHandler({
  handleNotification: async () => ({
    shouldShowAlert: true,
    shouldPlaySound: true,
    shouldSetBadge: true,
  }),
});

// Messages punitifs par niveau d'escalade
const MESSAGES = {
  NORMAL: [
    '💧 Il est temps de boire !',
    '🚰 Hydrate-toi maintenant',
    '💦 Ton corps a besoin d\'eau',
    '🌊 N\'oublie pas de boire',
  ],
  WARNING: [
    '⚠️ Ça fait un moment... Bois !',
    '😰 Tu commences à te déshydrater',
    '⏰ ATTENTION : Hydratation urgente',
    '🔔 Dernière chance avant spam mode',
  ],
  SPAM: [
    '🚨 SPAM MODE ACTIVÉ - BOIS MAINTENANT',
    '💀 TU VAS MOURIR DÉSHYDRATÉ',
    '😡 TES CELLULES PLEURENT',
    '⛔ EAU. VERRE. BOUCHE. MAINTENANT.',
    '🔥 CHAQUE MINUTE SANS EAU = UNE NOTIFICATION',
  ],
  AGGRESSIVE: [
    '💥 TU L\'AURAS CHERCHÉ',
    '💀💀💀 TON CORPS TE DÉTESTE',
    '🚨🚨🚨 URGENCE HYDRIQUE ABSOLUE',
    '⚰️ DÉSHYDRATATION = GAME OVER',
    'Les plantes boivent plus que toi. LES. PLANTES.',
  ],
};

function getRandomMessage(level) {
  const messages = MESSAGES[level];
  return messages[Math.floor(Math.random() * messages.length)];
}

export const notifications = {
  async requestPermissions() {
    if (Device.isDevice) {
      const { status: existingStatus } = await Notifications.getPermissionsAsync();
      let finalStatus = existingStatus;

      if (existingStatus !== 'granted') {
        const { status } = await Notifications.requestPermissionsAsync();
        finalStatus = status;
      }

      if (finalStatus !== 'granted') {
        return false;
      }

      if (Platform.OS === 'android') {
        await Notifications.setNotificationChannelAsync('hydration', {
          name: 'Hydratation',
          importance: Notifications.AndroidImportance.MAX,
          vibrationPattern: [0, 250, 250, 250],
          sound: true,
        });
      }

      return true;
    }
    return false;
  },

  async scheduleNormalReminders() {
    // Cancel existing
    await Notifications.cancelAllScheduledNotificationsAsync();

    // Schedule reminder every 60 minutes during wake hours (8am - 10pm)
    for (let hour = 8; hour < 22; hour++) {
      await Notifications.scheduleNotificationAsync({
        content: {
          title: 'HydrateOrDie 💧',
          body: getRandomMessage('NORMAL'),
          sound: true,
          priority: 'high',
        },
        trigger: {
          hour,
          minute: 0,
          repeats: true,
        },
      });
    }
  },

  async checkAndEscalate() {
    const lastDrink = await storage.getLastDrinkTime();
    if (!lastDrink) return;

    const now = new Date();
    const minutesSinceLastDrink = (now - lastDrink) / 1000 / 60;

    // Normal: < 90 min
    // Warning: 90-120 min
    // Spam: 120-180 min
    // Aggressive: 180+ min

    if (minutesSinceLastDrink > 180) {
      await this.sendAggressiveNotification();
      // Schedule spam every 5 min
      await this.scheduleSpamMode();
    } else if (minutesSinceLastDrink > 120) {
      await this.sendSpamNotification();
    } else if (minutesSinceLastDrink > 90) {
      await this.sendWarningNotification();
    }
  },

  async sendWarningNotification() {
    await Notifications.scheduleNotificationAsync({
      content: {
        title: '⚠️ AVERTISSEMENT',
        body: getRandomMessage('WARNING'),
        sound: true,
        priority: 'high',
        vibrate: [0, 250, 250, 250],
      },
      trigger: null, // immediate
    });
  },

  async sendSpamNotification() {
    await Notifications.scheduleNotificationAsync({
      content: {
        title: '🚨 SPAM MODE',
        body: getRandomMessage('SPAM'),
        sound: true,
        priority: 'max',
        vibrate: [0, 500, 100, 500],
      },
      trigger: null,
    });
  },

  async sendAggressiveNotification() {
    await Notifications.scheduleNotificationAsync({
      content: {
        title: '💀 CRITIQUE',
        body: getRandomMessage('AGGRESSIVE'),
        sound: true,
        priority: 'max',
        vibrate: [0, 500, 100, 500, 100, 500],
      },
      trigger: null,
    });
  },

  async scheduleSpamMode() {
    // Cancel normal reminders
    await Notifications.cancelAllScheduledNotificationsAsync();

    // Schedule notification every 5 minutes
    await Notifications.scheduleNotificationAsync({
      content: {
        title: '🚨 SPAM MODE ACTIF',
        body: getRandomMessage('SPAM'),
        sound: true,
        priority: 'max',
      },
      trigger: {
        seconds: 300, // 5 minutes
        repeats: true,
      },
    });
  },

  async cancelSpamMode() {
    await Notifications.cancelAllScheduledNotificationsAsync();
    await this.scheduleNormalReminders();
  },
};
