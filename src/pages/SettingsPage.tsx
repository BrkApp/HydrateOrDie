import { useNavigate } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { useAppStore } from '../stores/useAppStore';

export function SettingsPage() {
  const { t, i18n } = useTranslation();
  const navigate = useNavigate();

  const userProfile = useAppStore((state) => state.userProfile);
  const appSettings = useAppStore((state) => state.appSettings);
  const setAppSettings = useAppStore((state) => state.setAppSettings);

  const handleLanguageChange = (lang: 'fr' | 'en') => {
    i18n.changeLanguage(lang);
    setAppSettings({ ...appSettings, language: lang });
  };

  const handleThemeChange = (theme: 'light' | 'dark' | 'auto') => {
    setAppSettings({ ...appSettings, theme });

    if (theme === 'dark') {
      document.documentElement.classList.add('dark');
    } else if (theme === 'light') {
      document.documentElement.classList.remove('dark');
    } else {
      // Auto: use system preference
      if (window.matchMedia('(prefers-color-scheme: dark)').matches) {
        document.documentElement.classList.add('dark');
      } else {
        document.documentElement.classList.remove('dark');
      }
    }
  };

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900">
      {/* Header */}
      <div className="bg-white dark:bg-gray-800 px-6 py-4 shadow-sm flex items-center gap-4">
        <button
          onClick={() => navigate('/dashboard')}
          className="w-10 h-10 rounded-full bg-gray-100 dark:bg-gray-700 flex items-center justify-center hover:bg-gray-200 dark:hover:bg-gray-600 transition-all"
        >
          ←
        </button>
        <h1 className="text-xl font-bold">{t('settings.title')}</h1>
      </div>

      <div className="max-w-md mx-auto px-6 py-6 space-y-6">
        {/* Profile section */}
        <div className="card">
          <h2 className="font-bold mb-4">{t('settings.profile')}</h2>
          {userProfile && (
            <div className="space-y-2 text-sm">
              <p><span className="text-gray-500">Nom:</span> {userProfile.name}</p>
              <p><span className="text-gray-500">Poids:</span> {userProfile.weight} kg</p>
              <p><span className="text-gray-500">Âge:</span> {userProfile.age} ans</p>
              <p><span className="text-gray-500">Objectif:</span> {userProfile.dailyGoal} ml</p>
            </div>
          )}
        </div>

        {/* Appearance */}
        <div className="card">
          <h2 className="font-bold mb-4">{t('settings.appearance')}</h2>

          <div className="space-y-4">
            <div>
              <label className="text-sm font-medium block mb-2">
                {t('settings.language')}
              </label>
              <div className="flex gap-2">
                <button
                  onClick={() => handleLanguageChange('fr')}
                  className={`flex-1 py-2 px-4 rounded-lg font-medium transition-all ${
                    appSettings.language === 'fr'
                      ? 'bg-primary-500 text-white'
                      : 'bg-gray-100 dark:bg-gray-700'
                  }`}
                >
                  Français
                </button>
                <button
                  onClick={() => handleLanguageChange('en')}
                  className={`flex-1 py-2 px-4 rounded-lg font-medium transition-all ${
                    appSettings.language === 'en'
                      ? 'bg-primary-500 text-white'
                      : 'bg-gray-100 dark:bg-gray-700'
                  }`}
                >
                  English
                </button>
              </div>
            </div>

            <div>
              <label className="text-sm font-medium block mb-2">
                {t('settings.theme')}
              </label>
              <div className="flex gap-2">
                {(['light', 'dark', 'auto'] as const).map((theme) => (
                  <button
                    key={theme}
                    onClick={() => handleThemeChange(theme)}
                    className={`flex-1 py-2 px-4 rounded-lg font-medium transition-all ${
                      appSettings.theme === theme
                        ? 'bg-primary-500 text-white'
                        : 'bg-gray-100 dark:bg-gray-700'
                    }`}
                  >
                    {t(`settings.${theme}`)}
                  </button>
                ))}
              </div>
            </div>
          </div>
        </div>

        {/* Notifications */}
        <div className="card">
          <h2 className="font-bold mb-4">{t('settings.notifications')}</h2>
          <button
            onClick={() => navigate('/notifications')}
            className="w-full text-left py-3 px-4 bg-gray-50 dark:bg-gray-700 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-600 transition-all"
          >
            Configurer les notifications →
          </button>
        </div>

        {/* Premium */}
        <div className="card bg-gradient-to-r from-primary-500 to-primary-600 text-white">
          <h2 className="font-bold mb-2">{t('settings.premium')}</h2>
          <p className="text-white/80 text-sm mb-4">
            Débloque des fonctionnalités exclusives
          </p>
          <button
            onClick={() => navigate('/premium')}
            className="w-full py-3 px-4 bg-white text-primary-600 rounded-lg font-medium hover:bg-white/90 transition-all"
          >
            Découvrir Premium
          </button>
        </div>
      </div>
    </div>
  );
}
