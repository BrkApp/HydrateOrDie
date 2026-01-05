import { useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { motion } from 'framer-motion';
import { useAppStore } from '../stores/useAppStore';
import type { DailyProgress } from '../types';

export function DashboardPage() {
  const { t } = useTranslation();
  const navigate = useNavigate();

  const userProfile = useAppStore((state) => state.userProfile);
  const dailyProgress = useAppStore((state) => state.dailyProgress);
  const setDailyProgress = useAppStore((state) => state.setDailyProgress);

  useEffect(() => {
    if (!userProfile) {
      navigate('/onboarding');
      return;
    }

    // Initialize daily progress if not exists or if it's a new day
    const today = new Date().toISOString().split('T')[0];

    if (!dailyProgress || dailyProgress.date !== today) {
      const newProgress: DailyProgress = {
        id: crypto.randomUUID(),
        date: today,
        totalMl: 0,
        entries: [],
        streakCount: dailyProgress?.goalReached ? (dailyProgress.streakCount + 1) : 0,
        goalReached: false,
      };
      setDailyProgress(newProgress);
    }
  }, [userProfile, dailyProgress, setDailyProgress, navigate]);

  if (!userProfile || !dailyProgress) {
    return null;
  }

  const progressPercentage = Math.min(
    100,
    (dailyProgress.totalMl / userProfile.dailyGoal) * 100
  );

  const handleCameraClick = () => {
    navigate('/camera');
  };

  const handleQuickAdd = () => {
    // TODO: Implement quick add
    alert('Quick add - to be implemented');
  };

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900">
      {/* Header */}
      <div className="bg-gradient-to-r from-primary-500 to-primary-600 text-white px-6 py-8">
        <div className="max-w-md mx-auto">
          <div className="flex justify-between items-center mb-6">
            <div>
              <h1 className="text-2xl font-bold">
                {t('dashboard.title')}
              </h1>
              <p className="text-white/80">
                {t('dashboard.today')}, {new Date().toLocaleDateString()}
              </p>
            </div>
            <button
              onClick={() => navigate('/settings')}
              className="w-10 h-10 rounded-full bg-white/20 flex items-center justify-center hover:bg-white/30 transition-all"
            >
              ⚙️
            </button>
          </div>

          {/* Streak */}
          <div className="flex items-center gap-2 bg-white/10 rounded-lg px-4 py-3">
            <span className="text-2xl">🔥</span>
            <div>
              <p className="text-sm text-white/80">{t('dashboard.streak')}</p>
              <p className="text-xl font-bold">
                {dailyProgress.streakCount} {t('dashboard.days')}
              </p>
            </div>
          </div>
        </div>
      </div>

      {/* Main content */}
      <div className="max-w-md mx-auto px-6 -mt-4">
        {/* Progress Circle */}
        <motion.div
          initial={{ scale: 0.9, opacity: 0 }}
          animate={{ scale: 1, opacity: 1 }}
          className="card mb-6 flex flex-col items-center py-8"
        >
          <div className="relative w-48 h-48 mb-6">
            {/* Background circle */}
            <svg className="w-full h-full -rotate-90">
              <circle
                cx="96"
                cy="96"
                r="88"
                stroke="currentColor"
                strokeWidth="12"
                fill="none"
                className="text-gray-200 dark:text-gray-700"
              />
              <motion.circle
                cx="96"
                cy="96"
                r="88"
                stroke="currentColor"
                strokeWidth="12"
                fill="none"
                strokeLinecap="round"
                className="text-primary-500"
                initial={{ strokeDasharray: '552.92', strokeDashoffset: '552.92' }}
                animate={{
                  strokeDashoffset: 552.92 - (552.92 * progressPercentage) / 100,
                }}
                transition={{ duration: 1, ease: 'easeOut' }}
              />
            </svg>

            {/* Center text */}
            <div className="absolute inset-0 flex flex-col items-center justify-center">
              <p className="text-4xl font-bold text-primary-600">
                {Math.round(progressPercentage)}%
              </p>
              <p className="text-sm text-gray-500">
                {dailyProgress.totalMl} / {userProfile.dailyGoal} ml
              </p>
            </div>
          </div>

          <div className="text-center">
            <p className="text-sm text-gray-500 mb-1">{t('dashboard.lastDrink')}</p>
            <p className="font-medium">
              {dailyProgress.lastDrinkTime
                ? new Date(dailyProgress.lastDrinkTime).toLocaleTimeString('fr-FR', {
                    hour: '2-digit',
                    minute: '2-digit',
                  })
                : t('dashboard.never')}
            </p>
          </div>
        </motion.div>

        {/* Quick actions */}
        <div className="grid grid-cols-2 gap-4 mb-6">
          <button onClick={handleQuickAdd} className="card hover:shadow-lg transition-all">
            <div className="text-4xl mb-2">⚡</div>
            <p className="font-medium">{t('dashboard.quickAdd')}</p>
            <p className="text-xs text-gray-500">250ml</p>
          </button>
          <button onClick={() => navigate('/history')} className="card hover:shadow-lg transition-all">
            <div className="text-4xl mb-2">📊</div>
            <p className="font-medium">Historique</p>
            <p className="text-xs text-gray-500">{dailyProgress.entries.length} entrées</p>
          </button>
        </div>

        {/* Camera FAB */}
        <motion.button
          onClick={handleCameraClick}
          whileHover={{ scale: 1.05 }}
          whileTap={{ scale: 0.95 }}
          className="fixed bottom-8 right-8 w-16 h-16 bg-primary-500 rounded-full shadow-2xl flex items-center justify-center text-3xl hover:bg-primary-600 transition-colors"
        >
          📸
        </motion.button>
      </div>
    </div>
  );
}
