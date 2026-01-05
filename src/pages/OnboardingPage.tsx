import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { motion, AnimatePresence } from 'framer-motion';
import { useAppStore } from '../stores/useAppStore';
import { calculateDailyGoal } from '../types';
import type { UserProfile } from '../types';

export function OnboardingPage() {
  const { t } = useTranslation();
  const navigate = useNavigate();
  const setUserProfile = useAppStore((state) => state.setUserProfile);
  const setHasCompletedOnboarding = useAppStore((state) => state.setHasCompletedOnboarding);

  const [step, setStep] = useState(0);
  const [formData, setFormData] = useState({
    name: '',
    weight: '',
    age: '',
    workStart: '09:00',
    workEnd: '18:00',
  });

  const handleNext = () => {
    if (step < 3) {
      setStep(step + 1);
    } else {
      completeOnboarding();
    }
  };

  const handleBack = () => {
    if (step > 0) {
      setStep(step - 1);
    }
  };

  const completeOnboarding = () => {
    const weight = parseFloat(formData.weight);
    const age = parseInt(formData.age);
    const dailyGoal = calculateDailyGoal(weight, age);

    const profile: UserProfile = {
      id: crypto.randomUUID(),
      name: formData.name,
      weight,
      age,
      dailyGoal,
      workStartTime: formData.workStart,
      workEndTime: formData.workEnd,
      createdAt: new Date(),
      isPremium: false,
    };

    setUserProfile(profile);
    setHasCompletedOnboarding(true);
    navigate('/dashboard');
  };

  const isStepValid = () => {
    switch (step) {
      case 0:
        return formData.name.trim().length > 0;
      case 1:
        return parseFloat(formData.weight) > 0 && parseFloat(formData.weight) < 300;
      case 2:
        return parseInt(formData.age) > 0 && parseInt(formData.age) < 120;
      case 3:
        return true;
      default:
        return false;
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-primary-500 to-primary-700 flex items-center justify-center p-4">
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        className="w-full max-w-md"
      >
        <div className="card bg-white/95 backdrop-blur">
          {/* Progress bar */}
          <div className="flex gap-2 mb-8">
            {[0, 1, 2, 3].map((i) => (
              <div
                key={i}
                className={`h-2 flex-1 rounded-full transition-all ${
                  i <= step ? 'bg-primary-500' : 'bg-gray-200'
                }`}
              />
            ))}
          </div>

          <AnimatePresence mode="wait">
            <motion.div
              key={step}
              initial={{ opacity: 0, x: 20 }}
              animate={{ opacity: 1, x: 0 }}
              exit={{ opacity: 0, x: -20 }}
              transition={{ duration: 0.3 }}
            >
              {step === 0 && (
                <div>
                  <h2 className="text-3xl font-bold mb-2">{t('onboarding.welcome')}</h2>
                  <p className="text-gray-600 mb-6">{t('onboarding.subtitle')}</p>
                  <label className="block mb-4">
                    <span className="text-sm font-medium text-gray-700 mb-2 block">
                      {t('onboarding.name')}
                    </span>
                    <input
                      type="text"
                      className="input-field"
                      placeholder={t('onboarding.namePlaceholder')}
                      value={formData.name}
                      onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                    />
                  </label>
                </div>
              )}

              {step === 1 && (
                <div>
                  <h2 className="text-3xl font-bold mb-6">{t('onboarding.weight')}</h2>
                  <label className="block mb-4">
                    <input
                      type="number"
                      className="input-field text-center text-2xl"
                      placeholder="70"
                      value={formData.weight}
                      onChange={(e) => setFormData({ ...formData, weight: e.target.value })}
                    />
                    <span className="text-gray-500 text-sm mt-2 block text-center">
                      {t('onboarding.weightUnit')}
                    </span>
                  </label>
                </div>
              )}

              {step === 2 && (
                <div>
                  <h2 className="text-3xl font-bold mb-6">{t('onboarding.age')}</h2>
                  <label className="block mb-4">
                    <input
                      type="number"
                      className="input-field text-center text-2xl"
                      placeholder="30"
                      value={formData.age}
                      onChange={(e) => setFormData({ ...formData, age: e.target.value })}
                    />
                    <span className="text-gray-500 text-sm mt-2 block text-center">
                      {t('onboarding.ageUnit')}
                    </span>
                  </label>
                </div>
              )}

              {step === 3 && (
                <div>
                  <h2 className="text-3xl font-bold mb-6">{t('onboarding.workHours')}</h2>
                  <div className="space-y-4 mb-6">
                    <label className="block">
                      <span className="text-sm font-medium text-gray-700 mb-2 block">
                        {t('onboarding.workStart')}
                      </span>
                      <input
                        type="time"
                        className="input-field"
                        value={formData.workStart}
                        onChange={(e) => setFormData({ ...formData, workStart: e.target.value })}
                      />
                    </label>
                    <label className="block">
                      <span className="text-sm font-medium text-gray-700 mb-2 block">
                        {t('onboarding.workEnd')}
                      </span>
                      <input
                        type="time"
                        className="input-field"
                        value={formData.workEnd}
                        onChange={(e) => setFormData({ ...formData, workEnd: e.target.value })}
                      />
                    </label>
                  </div>
                  <div className="card bg-primary-50 border-2 border-primary-200">
                    <p className="text-sm text-gray-600 mb-2">{t('onboarding.goal')}</p>
                    <p className="text-4xl font-bold text-primary-600">
                      {calculateDailyGoal(parseFloat(formData.weight) || 70, parseInt(formData.age) || 30)} ml
                    </p>
                    <p className="text-xs text-gray-500 mt-2">
                      {t('onboarding.goalCalculated')}
                    </p>
                  </div>
                </div>
              )}
            </motion.div>
          </AnimatePresence>

          {/* Navigation buttons */}
          <div className="flex gap-3 mt-8">
            {step > 0 && (
              <button onClick={handleBack} className="btn-secondary flex-1">
                {t('common.back')}
              </button>
            )}
            <button
              onClick={handleNext}
              disabled={!isStepValid()}
              className="btn-primary flex-1 disabled:opacity-50 disabled:cursor-not-allowed"
            >
              {step === 3 ? t('onboarding.start') : t('onboarding.next')}
            </button>
          </div>
        </div>
      </motion.div>
    </div>
  );
}
