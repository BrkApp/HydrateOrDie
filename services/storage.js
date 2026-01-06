import AsyncStorage from '@react-native-async-storage/async-storage';

const KEYS = {
  DAILY_GOAL: 'dailyGoal',
  TODAY_ML: 'todayMl',
  LAST_DRINK_TIME: 'lastDrinkTime',
  STREAK: 'streak',
  LAST_DATE: 'lastDate',
  ONBOARDING_DONE: 'onboardingDone',
  PHOTOS: 'photos',
};

export const storage = {
  // Onboarding
  async setOnboardingDone() {
    await AsyncStorage.setItem(KEYS.ONBOARDING_DONE, 'true');
  },

  async isOnboardingDone() {
    const value = await AsyncStorage.getItem(KEYS.ONBOARDING_DONE);
    return value === 'true';
  },

  // Daily goal
  async setDailyGoal(ml) {
    await AsyncStorage.setItem(KEYS.DAILY_GOAL, ml.toString());
  },

  async getDailyGoal() {
    const value = await AsyncStorage.getItem(KEYS.DAILY_GOAL);
    return value ? parseInt(value) : 2000; // default 2000ml
  },

  // Today's progress
  async getTodayMl() {
    await this.checkAndResetDaily();
    const value = await AsyncStorage.getItem(KEYS.TODAY_ML);
    return value ? parseInt(value) : 0;
  },

  async addMl(ml) {
    await this.checkAndResetDaily();
    const current = await this.getTodayMl();
    const newTotal = current + ml;
    await AsyncStorage.setItem(KEYS.TODAY_ML, newTotal.toString());
    await AsyncStorage.setItem(KEYS.LAST_DRINK_TIME, new Date().toISOString());

    // Check if goal reached today
    const goal = await this.getDailyGoal();
    if (current < goal && newTotal >= goal) {
      await this.incrementStreak();
    }

    return newTotal;
  },

  // Last drink time
  async getLastDrinkTime() {
    const value = await AsyncStorage.getItem(KEYS.LAST_DRINK_TIME);
    return value ? new Date(value) : null;
  },

  // Streak
  async getStreak() {
    const value = await AsyncStorage.getItem(KEYS.STREAK);
    return value ? parseInt(value) : 0;
  },

  async incrementStreak() {
    const current = await this.getStreak();
    await AsyncStorage.setItem(KEYS.STREAK, (current + 1).toString());
  },

  async resetStreak() {
    await AsyncStorage.setItem(KEYS.STREAK, '0');
  },

  // Daily reset logic
  async checkAndResetDaily() {
    const today = new Date().toISOString().split('T')[0]; // YYYY-MM-DD
    const lastDate = await AsyncStorage.getItem(KEYS.LAST_DATE);

    if (lastDate !== today) {
      // New day - check if goal was reached yesterday
      const yesterdayMl = await this.getTodayMl();
      const goal = await this.getDailyGoal();

      if (yesterdayMl < goal && lastDate) {
        // Goal not reached - reset streak
        await this.resetStreak();
      }

      // Reset daily progress
      await AsyncStorage.setItem(KEYS.TODAY_ML, '0');
      await AsyncStorage.setItem(KEYS.LAST_DATE, today);
    }
  },

  // Photos
  async savePhoto(uri) {
    const photos = await this.getPhotos();
    photos.push({ uri, timestamp: new Date().toISOString() });
    // Keep only last 50 photos
    const recent = photos.slice(-50);
    await AsyncStorage.setItem(KEYS.PHOTOS, JSON.stringify(recent));
  },

  async getPhotos() {
    const value = await AsyncStorage.getItem(KEYS.PHOTOS);
    return value ? JSON.parse(value) : [];
  },

  // Clear all (for testing)
  async clearAll() {
    await AsyncStorage.clear();
  },
};
