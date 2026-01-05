import type {
  UserProfile,
  DailyProgress,
  NotificationSettings,
  AppSettings,
} from '../types';

const KEYS = {
  USER_PROFILE: 'hydrate_user_profile',
  DAILY_PROGRESS: 'hydrate_daily_progress',
  PROGRESS_HISTORY: 'hydrate_progress_history',
  NOTIFICATION_SETTINGS: 'hydrate_notification_settings',
  APP_SETTINGS: 'hydrate_app_settings',
  HAS_COMPLETED_ONBOARDING: 'hydrate_onboarding_completed',
} as const;

class LocalStorageService {
  // User Profile
  getUserProfile(): UserProfile | null {
    const data = localStorage.getItem(KEYS.USER_PROFILE);
    if (!data) return null;

    const parsed = JSON.parse(data);
    // Convert date strings back to Date objects
    return {
      ...parsed,
      createdAt: new Date(parsed.createdAt),
      premiumExpiry: parsed.premiumExpiry ? new Date(parsed.premiumExpiry) : undefined,
    };
  }

  saveUserProfile(profile: UserProfile): void {
    localStorage.setItem(KEYS.USER_PROFILE, JSON.stringify(profile));
  }

  // Daily Progress
  getDailyProgress(): DailyProgress | null {
    const data = localStorage.getItem(KEYS.DAILY_PROGRESS);
    if (!data) return null;

    const parsed = JSON.parse(data);
    return {
      ...parsed,
      entries: parsed.entries.map((entry: any) => ({
        ...entry,
        timestamp: new Date(entry.timestamp),
      })),
      lastDrinkTime: parsed.lastDrinkTime ? new Date(parsed.lastDrinkTime) : undefined,
    };
  }

  saveDailyProgress(progress: DailyProgress): void {
    localStorage.setItem(KEYS.DAILY_PROGRESS, JSON.stringify(progress));

    // Also save to history
    this.addToHistory(progress);
  }

  // Progress History
  getProgressHistory(): DailyProgress[] {
    const data = localStorage.getItem(KEYS.PROGRESS_HISTORY);
    if (!data) return [];

    const parsed = JSON.parse(data);
    return parsed.map((item: any) => ({
      ...item,
      entries: item.entries.map((entry: any) => ({
        ...entry,
        timestamp: new Date(entry.timestamp),
      })),
      lastDrinkTime: item.lastDrinkTime ? new Date(item.lastDrinkTime) : undefined,
    }));
  }

  private addToHistory(progress: DailyProgress): void {
    const history = this.getProgressHistory();

    // Remove existing entry for same date if present
    const filtered = history.filter((p) => p.date !== progress.date);

    // Add new entry
    filtered.push(progress);

    // Keep only last 90 days
    const sorted = filtered
      .sort((a, b) => b.date.localeCompare(a.date))
      .slice(0, 90);

    localStorage.setItem(KEYS.PROGRESS_HISTORY, JSON.stringify(sorted));
  }

  // Notification Settings
  getNotificationSettings(): NotificationSettings | null {
    const data = localStorage.getItem(KEYS.NOTIFICATION_SETTINGS);
    if (!data) return null;

    const parsed = JSON.parse(data);
    return {
      ...parsed,
      lastNotificationTime: parsed.lastNotificationTime
        ? new Date(parsed.lastNotificationTime)
        : undefined,
      spamModeActiveSince: parsed.spamModeActiveSince
        ? new Date(parsed.spamModeActiveSince)
        : undefined,
    };
  }

  saveNotificationSettings(settings: NotificationSettings): void {
    localStorage.setItem(KEYS.NOTIFICATION_SETTINGS, JSON.stringify(settings));
  }

  // App Settings
  getAppSettings(): AppSettings | null {
    const data = localStorage.getItem(KEYS.APP_SETTINGS);
    return data ? JSON.parse(data) : null;
  }

  saveAppSettings(settings: AppSettings): void {
    localStorage.setItem(KEYS.APP_SETTINGS, JSON.stringify(settings));
  }

  // Onboarding
  getHasCompletedOnboarding(): boolean {
    return localStorage.getItem(KEYS.HAS_COMPLETED_ONBOARDING) === 'true';
  }

  setHasCompletedOnboarding(completed: boolean): void {
    localStorage.setItem(KEYS.HAS_COMPLETED_ONBOARDING, String(completed));
  }

  // Clear all data (for testing or logout)
  clearAll(): void {
    Object.values(KEYS).forEach((key) => {
      localStorage.removeItem(key);
    });
  }
}

export const localStorageService = new LocalStorageService();
