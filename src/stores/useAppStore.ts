import { create } from 'zustand';
import type {
  AppState,
  UserProfile,
  DailyProgress,
  WaterEntry,
  NotificationSettings,
  AppSettings,
  NotificationIntensity,
} from '../types';
import { localStorageService } from '../services/localStorage';

// Default settings
const defaultNotificationSettings: NotificationSettings = {
  enabled: true,
  normalIntervalMinutes: 50,
  spamIntervalMinutes: 5,
  currentIntensity: 'NORMAL' as NotificationIntensity,
  messageTone: 'PUNITIVE',
  workHoursOnly: true,
};

const defaultAppSettings: AppSettings = {
  language: 'fr',
  theme: 'auto',
  mlConfidenceThreshold: 0.7,
  strictMode: true,
  soundEnabled: true,
  hapticsEnabled: true,
  animationsEnabled: true,
};

export const useAppStore = create<AppState>((set, get) => ({
  // Initial state from localStorage
  userProfile: localStorageService.getUserProfile(),
  dailyProgress: localStorageService.getDailyProgress(),
  notificationSettings:
    localStorageService.getNotificationSettings() || defaultNotificationSettings,
  appSettings: localStorageService.getAppSettings() || defaultAppSettings,
  isLoading: false,
  hasCompletedOnboarding: localStorageService.getHasCompletedOnboarding(),

  // User Profile actions
  setUserProfile: (profile: UserProfile) => {
    localStorageService.saveUserProfile(profile);
    set({ userProfile: profile });
  },

  // Daily Progress actions
  setDailyProgress: (progress: DailyProgress) => {
    localStorageService.saveDailyProgress(progress);
    set({ dailyProgress: progress });
  },

  addWaterEntry: (entry: WaterEntry) => {
    const { dailyProgress, userProfile } = get();
    if (!dailyProgress || !userProfile) return;

    const updatedProgress: DailyProgress = {
      ...dailyProgress,
      totalMl: dailyProgress.totalMl + entry.amount,
      entries: [...dailyProgress.entries, entry],
      lastDrinkTime: entry.timestamp,
      goalReached: dailyProgress.totalMl + entry.amount >= userProfile.dailyGoal,
    };

    // Update streak if goal is reached
    if (updatedProgress.goalReached && !dailyProgress.goalReached) {
      updatedProgress.streakCount = dailyProgress.streakCount + 1;
    }

    localStorageService.saveDailyProgress(updatedProgress);
    set({ dailyProgress: updatedProgress });
  },

  // Notification Settings actions
  setNotificationSettings: (settings: NotificationSettings) => {
    localStorageService.saveNotificationSettings(settings);
    set({ notificationSettings: settings });
  },

  updateNotificationIntensity: (intensity: NotificationIntensity) => {
    const { notificationSettings } = get();
    const updated = {
      ...notificationSettings,
      currentIntensity: intensity,
      spamModeActiveSince: intensity === 'SPAM' ? new Date() : notificationSettings.spamModeActiveSince,
    };
    localStorageService.saveNotificationSettings(updated);
    set({ notificationSettings: updated });
  },

  // App Settings actions
  setAppSettings: (settings: AppSettings) => {
    localStorageService.saveAppSettings(settings);
    set({ appSettings: settings });
  },

  // UI State actions
  setIsLoading: (loading: boolean) => set({ isLoading: loading }),

  // Onboarding actions
  setHasCompletedOnboarding: (completed: boolean) => {
    localStorageService.setHasCompletedOnboarding(completed);
    set({ hasCompletedOnboarding: completed });
  },
}));
