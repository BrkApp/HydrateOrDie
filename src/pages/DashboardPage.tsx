import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { motion, AnimatePresence } from 'framer-motion';
import { useAppStore } from '../stores/useAppStore';
import { WaterGlass } from '../components/common/WaterGlass';
import type { DailyProgress } from '../types';

export function DashboardPage() {
  const { t } = useTranslation();
  const navigate = useNavigate();
  const [showConfetti, setShowConfetti] = useState(false);

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

  // Get dramatic message based on progress
  const getDramaticMessage = () => {
    if (progressPercentage >= 100) return '🎉 OBJECTIF ATTEINT ! TU VIS !';
    if (progressPercentage >= 70) return '😰 BOIS AVANT QU\'IL SOIT TROP TARD';
    if (progressPercentage >= 30) return '😡 TES CELLULES PLEURENT';
    return '💀 TU VAS MOURIR DÉSHYDRATÉ';
  };

  const getSubMessage = () => {
    if (progressPercentage >= 100) return 'Wow. T\'as réussi à boire de l\'eau. Bravo.';
    if (progressPercentage >= 70) return 'Tu es presque hydraté. Presque.';
    if (progressPercentage >= 30) return 'Les plantes boivent plus que toi. LES. PLANTES.';
    return 'Ton corps est 60% d\'eau et 40% de déception';
  };

  const handleCameraClick = () => {
    navigate('/camera');
  };

  const handleQuickAdd = () => {
    // Simulated quick add for now
    const newEntry = {
      id: crypto.randomUUID(),
      timestamp: new Date(),
      amount: 250,
      source: 'QUICK_ADD' as const,
    };

    const updatedProgress: DailyProgress = {
      ...dailyProgress,
      totalMl: dailyProgress.totalMl + 250,
      entries: [...dailyProgress.entries, newEntry],
      lastDrinkTime: new Date(),
      goalReached: dailyProgress.totalMl + 250 >= userProfile.dailyGoal,
    };

    if (updatedProgress.goalReached && !dailyProgress.goalReached) {
      setShowConfetti(true);
      setTimeout(() => setShowConfetti(false), 3000);
    }

    setDailyProgress(updatedProgress);
  };

  const timeSinceLastDrink = dailyProgress.lastDrinkTime
    ? Math.floor((Date.now() - new Date(dailyProgress.lastDrinkTime).getTime()) / 1000 / 60)
    : 999;

  const shouldShake = timeSinceLastDrink > 120; // Shake if 2h+ without drinking

  return (
    <div className="min-h-screen bg-gradient-to-br from-neutral-900 via-neutral-800 to-neutral-900">
      {/* Animated gradient background */}
      <div className="fixed inset-0 opacity-20 bg-gradient-to-r from-primary-500 via-danger-500 to-primary-500 bg-[length:200%_200%] animate-gradient-shift"></div>

      {/* Confetti explosion */}
      <AnimatePresence>
        {showConfetti && (
          <div className="fixed inset-0 pointer-events-none z-50">
            {[...Array(30)].map((_, i) => (
              <motion.div
                key={i}
                className="absolute w-3 h-3 rounded-full"
                style={{
                  left: `${50 + (Math.random() - 0.5) * 20}%`,
                  top: '40%',
                  background: ['#00B4D8', '#06FFA5', '#EF476F', '#FF6B35'][Math.floor(Math.random() * 4)],
                }}
                initial={{ scale: 0, y: 0 }}
                animate={{
                  scale: [0, 1, 0.5],
                  y: [0, -200 - Math.random() * 200],
                  x: (Math.random() - 0.5) * 400,
                  rotate: Math.random() * 360,
                }}
                exit={{ opacity: 0 }}
                transition={{ duration: 1.5, ease: 'easeOut' }}
              />
            ))}
          </div>
        )}
      </AnimatePresence>

      {/* Header */}
      <div className="relative px-6 py-6 flex justify-between items-center">
        <div>
          <h1 className="font-display text-2xl font-black text-white tracking-tight">
            HYDRATEORDIE
          </h1>
          <p className="text-neutral-400 text-sm">
            {new Date().toLocaleDateString('fr-FR', { weekday: 'long', day: 'numeric', month: 'long' })}
          </p>
        </div>
        <button
          onClick={() => navigate('/settings')}
          className="w-12 h-12 rounded-full bg-neutral-800/80 backdrop-blur-glass border border-neutral-700 flex items-center justify-center hover:bg-neutral-700 transition-all hover:scale-110 active:scale-95"
        >
          ⚙️
        </button>
      </div>

      {/* Main content */}
      <div className="relative max-w-md mx-auto px-6">
        {/* Streak card - glassmorphism */}
        <motion.div
          className="mb-6 p-4 rounded-2xl bg-neutral-800/40 backdrop-blur-glass border border-neutral-700/50 shadow-strong"
          whileHover={{ scale: 1.02 }}
        >
          <div className="flex items-center gap-3">
            <motion.span
              className="text-4xl"
              animate={{ scale: [1, 1.2, 1] }}
              transition={{ duration: 0.6, repeat: Infinity, repeatDelay: 2 }}
            >
              🔥
            </motion.span>
            <div className="flex-1">
              <p className="text-neutral-400 text-sm font-medium">SÉRIE EN COURS</p>
              <p className="text-3xl font-display font-black text-white">
                {dailyProgress.streakCount} {t('dashboard.days')}
              </p>
            </div>
            {dailyProgress.streakCount > 7 && (
              <span className="text-xs bg-success-500/20 text-success-500 px-3 py-1 rounded-full font-bold border border-success-500/30">
                ON FIRE
              </span>
            )}
          </div>
        </motion.div>

        {/* Mascot Hero - 40% of screen */}
        <motion.div
          className={`relative mb-8 ${shouldShake ? 'animate-shake-violent' : ''}`}
          animate={shouldShake ? {} : { y: [0, -5, 0] }}
          transition={{ duration: 3, repeat: Infinity }}
        >
          {/* Speech bubble with dramatic message */}
          <motion.div
            className="absolute -top-4 left-1/2 transform -translate-x-1/2 w-full max-w-xs z-10"
            initial={{ scale: 0, y: 20 }}
            animate={{ scale: 1, y: 0 }}
            transition={{ type: 'spring', delay: 0.3 }}
          >
            <div className={`p-4 rounded-2xl shadow-glow-${progressPercentage >= 100 ? 'cyan' : 'danger'} ${
              progressPercentage >= 100 ? 'bg-success-500/90' : progressPercentage >= 50 ? 'bg-urgent-500/90' : 'bg-danger-500/90'
            }`}>
              <p className="font-display font-black text-white text-center text-xl leading-tight uppercase">
                {getDramaticMessage()}
              </p>
              <p className="text-white/90 text-center text-xs mt-1">
                {getSubMessage()}
              </p>
            </div>
            {/* Bubble tail */}
            <div className={`w-4 h-4 ${
              progressPercentage >= 100 ? 'bg-success-500/90' : progressPercentage >= 50 ? 'bg-urgent-500/90' : 'bg-danger-500/90'
            } transform rotate-45 mx-auto -mt-2`}></div>
          </motion.div>

          {/* Progress ring around mascot */}
          <div className="relative w-full aspect-square max-w-sm mx-auto mt-16">
            {/* Background ring */}
            <svg className="absolute inset-0 w-full h-full -rotate-90">
              <circle
                cx="50%"
                cy="50%"
                r="45%"
                stroke="currentColor"
                strokeWidth="20"
                fill="none"
                className="text-neutral-800"
              />
              {/* Progress ring with gradient */}
              <motion.circle
                cx="50%"
                cy="50%"
                r="45%"
                stroke="url(#progressGradient)"
                strokeWidth="20"
                fill="none"
                strokeLinecap="round"
                style={{
                  strokeDasharray: `${2 * Math.PI * 45}%`,
                  strokeDashoffset: `${2 * Math.PI * 45 * (1 - progressPercentage / 100)}%`,
                }}
                initial={{ strokeDashoffset: `${2 * Math.PI * 45}%` }}
                animate={{
                  strokeDashoffset: `${2 * Math.PI * 45 * (1 - progressPercentage / 100)}%`,
                }}
                transition={{ duration: 1.5, ease: 'easeOut' }}
                className={progressPercentage >= 100 ? 'drop-shadow-glow-cyan' : ''}
              />
              <defs>
                <linearGradient id="progressGradient" x1="0%" y1="0%" x2="100%" y2="100%">
                  <stop offset="0%" stopColor="#00B4D8" />
                  <stop offset="50%" stopColor="#06FFA5" />
                  <stop offset="100%" stopColor="#00B4D8" />
                </linearGradient>
              </defs>
            </svg>

            {/* Water glass in center */}
            <div className="absolute inset-0 flex items-center justify-center">
              <WaterGlass fillPercentage={progressPercentage} size={250} />
            </div>

            {/* Percentage overlay */}
            <div className="absolute inset-0 flex items-center justify-center pointer-events-none">
              <motion.div
                className="text-center"
                initial={{ opacity: 0, scale: 0 }}
                animate={{ opacity: 1, scale: 1 }}
                transition={{ delay: 0.5 }}
              >
                <p className="font-display font-black text-6xl bg-gradient-to-r from-primary-300 to-success-400 bg-clip-text text-transparent drop-shadow-lg">
                  {Math.round(progressPercentage)}%
                </p>
                <p className="text-neutral-400 text-sm font-medium mt-1">
                  {dailyProgress.totalMl} / {userProfile.dailyGoal} ml
                </p>
              </motion.div>
            </div>
          </div>
        </motion.div>

        {/* Quick actions - Big, bold, impossible to ignore */}
        <div className="grid grid-cols-2 gap-4 mb-8">
          <motion.button
            onClick={handleQuickAdd}
            whileHover={{ scale: 1.05, y: -5 }}
            whileTap={{ scale: 0.95 }}
            className="p-6 rounded-3xl bg-gradient-to-br from-primary-600 to-primary-700 shadow-brutal hover:shadow-glow-cyan transition-all group relative overflow-hidden"
          >
            <motion.div
              className="absolute inset-0 bg-gradient-to-r from-transparent via-white/10 to-transparent"
              animate={{ x: ['-100%', '200%'] }}
              transition={{ duration: 2, repeat: Infinity, repeatDelay: 1 }}
            />
            <div className="relative z-10">
              <div className="text-5xl mb-2">⚡</div>
              <p className="font-display font-bold text-white text-lg">+250ml</p>
              <p className="text-primary-100 text-xs">INSTANT</p>
            </div>
          </motion.button>

          <motion.button
            onClick={() => navigate('/history')}
            whileHover={{ scale: 1.05, y: -5 }}
            whileTap={{ scale: 0.95 }}
            className="p-6 rounded-3xl bg-neutral-800/80 backdrop-blur-glass border-2 border-neutral-700 shadow-strong hover:border-primary-500 transition-all group"
          >
            <div className="text-5xl mb-2">📊</div>
            <p className="font-display font-bold text-white text-lg">Stats</p>
            <p className="text-neutral-400 text-xs">{dailyProgress.entries.length} entrées</p>
          </motion.button>
        </div>

        {/* Camera FAB - Pulsing, glowing, impossible to miss */}
        <motion.button
          onClick={handleCameraClick}
          whileHover={{ scale: 1.1 }}
          whileTap={{ scale: 0.9 }}
          className="fixed bottom-8 right-8 w-20 h-20 bg-gradient-to-br from-danger-500 to-urgent-500 rounded-full shadow-glow-danger flex items-center justify-center text-4xl z-50"
          animate={{
            boxShadow: [
              '0 0 20px rgba(239, 71, 111, 0.5)',
              '0 0 40px rgba(239, 71, 111, 0.8)',
              '0 0 20px rgba(239, 71, 111, 0.5)',
            ],
          }}
          transition={{ duration: 2, repeat: Infinity }}
        >
          📸
        </motion.button>
      </div>
    </div>
  );
}
