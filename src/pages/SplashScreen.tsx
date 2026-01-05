import { useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAppStore } from '../stores/useAppStore';
import { motion } from 'framer-motion';

export function SplashScreen() {
  const navigate = useNavigate();
  const hasCompletedOnboarding = useAppStore((state) => state.hasCompletedOnboarding);

  useEffect(() => {
    const timer = setTimeout(() => {
      navigate(hasCompletedOnboarding ? '/dashboard' : '/onboarding');
    }, 2000);

    return () => clearTimeout(timer);
  }, [hasCompletedOnboarding, navigate]);

  return (
    <div className="min-h-screen bg-gradient-to-br from-primary-500 to-primary-700 flex items-center justify-center">
      <motion.div
        initial={{ scale: 0.5, opacity: 0 }}
        animate={{ scale: 1, opacity: 1 }}
        transition={{ duration: 0.5 }}
        className="text-center"
      >
        <motion.div
          animate={{ rotate: [0, 10, -10, 0] }}
          transition={{ repeat: Infinity, duration: 2 }}
          className="text-8xl mb-4"
        >
          💧
        </motion.div>
        <h1 className="text-5xl font-bold text-white mb-2">HydrateOrDie</h1>
        <p className="text-xl text-white/80">Bois ou meurs 💀</p>
      </motion.div>
    </div>
  );
}
