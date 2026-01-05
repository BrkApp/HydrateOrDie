// User Profile
export interface UserProfile {
  id: string;
  name: string;
  weight: number; // kg
  age: number;
  dailyGoal: number; // ml
  workStartTime: string; // HH:mm
  workEndTime: string; // HH:mm
  createdAt: Date;
  isPremium: boolean;
  premiumExpiry?: Date;
}

// Water Entry
export type WaterSource = 'CAMERA' | 'MANUAL' | 'QUICK_ADD';

export interface WaterEntry {
  id: string;
  timestamp: Date;
  amount: number; // ml
  source: WaterSource;
  photoUrl?: string;
  mlConfidence?: number; // 0-1
}

// Daily Progress
export interface DailyProgress {
  id: string;
  date: string; // YYYY-MM-DD
  totalMl: number;
  entries: WaterEntry[];
  streakCount: number;
  goalReached: boolean;
  lastDrinkTime?: Date;
}

// Notification Settings
export type NotificationIntensity = 'NORMAL' | 'WARNING' | 'SPAM' | 'AGGRESSIVE';

export type MessageTone = 'PUNITIVE' | 'MOTIVATIONAL' | 'FRIENDLY' | 'PROFESSIONAL' | 'AGGRESSIVE' | 'HUMOROUS';

export interface NotificationSettings {
  enabled: boolean;
  normalIntervalMinutes: number; // 45-60
  spamIntervalMinutes: number; // 5
  currentIntensity: NotificationIntensity;
  messageTone: MessageTone;
  workHoursOnly: boolean;
  quietHoursStart?: string; // HH:mm
  quietHoursEnd?: string; // HH:mm
  lastNotificationTime?: Date;
  spamModeActiveSince?: Date;
}

// App Settings
export interface AppSettings {
  language: 'fr' | 'en';
  theme: 'light' | 'dark' | 'auto';
  mlConfidenceThreshold: number; // 0-1, default 0.7
  strictMode: boolean; // reject uncertain detections
  soundEnabled: boolean;
  hapticsEnabled: boolean;
  animationsEnabled: boolean;
}

// ML Detection Result
export interface MLDetectionResult {
  isWaterDetected: boolean;
  confidence: number; // 0-1
  detectedObjects: string[];
  timestamp: Date;
}

// App State (for Zustand)
export interface AppState {
  // User
  userProfile: UserProfile | null;
  setUserProfile: (profile: UserProfile) => void;

  // Progress
  dailyProgress: DailyProgress | null;
  setDailyProgress: (progress: DailyProgress) => void;
  addWaterEntry: (entry: WaterEntry) => void;

  // Settings
  notificationSettings: NotificationSettings;
  setNotificationSettings: (settings: NotificationSettings) => void;
  updateNotificationIntensity: (intensity: NotificationIntensity) => void;

  appSettings: AppSettings;
  setAppSettings: (settings: AppSettings) => void;

  // UI State
  isLoading: boolean;
  setIsLoading: (loading: boolean) => void;

  // Onboarding
  hasCompletedOnboarding: boolean;
  setHasCompletedOnboarding: (completed: boolean) => void;
}

// Navigation
export type RouteParams = {
  '/': undefined;
  '/onboarding': undefined;
  '/dashboard': undefined;
  '/camera': undefined;
  '/settings': undefined;
  '/history': undefined;
  '/premium': undefined;
}

// Constants for calculations
export const STANDARD_GLASS_ML = 250;
export const MIN_DAILY_GOAL = 1000; // 1L
export const MAX_DAILY_GOAL = 5000; // 5L

export function calculateDailyGoal(weight: number, age: number): number {
  let base = weight * 30; // 30ml per kg

  // Age adjustments
  if (age < 30) base *= 1.1;
  else if (age > 55) base *= 0.95;

  // Round to nearest 250ml
  const rounded = Math.round(base / 250) * 250;

  // Clamp between min and max
  return Math.max(MIN_DAILY_GOAL, Math.min(MAX_DAILY_GOAL, rounded));
}
