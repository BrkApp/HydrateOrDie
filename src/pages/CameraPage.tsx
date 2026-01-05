import { useNavigate } from 'react-router-dom';
import { useTranslation } from 'react-i18next';

export function CameraPage() {
  const { t } = useTranslation();
  const navigate = useNavigate();

  return (
    <div className="min-h-screen bg-gray-900 flex flex-col">
      {/* Header */}
      <div className="bg-black/50 px-6 py-4 flex items-center gap-4">
        <button
          onClick={() => navigate('/dashboard')}
          className="w-10 h-10 rounded-full bg-white/10 flex items-center justify-center hover:bg-white/20 transition-all"
        >
          ←
        </button>
        <h1 className="text-white font-medium">{t('camera.title')}</h1>
      </div>

      {/* Camera placeholder */}
      <div className="flex-1 flex items-center justify-center">
        <div className="text-center text-white/60">
          <div className="text-6xl mb-4">📷</div>
          <p className="text-lg">{t('camera.instructions')}</p>
          <p className="text-sm mt-2">Phase 4: TensorFlow.js integration</p>
        </div>
      </div>

      {/* Controls */}
      <div className="bg-black/50 px-6 py-8">
        <button className="btn-primary w-full">
          {t('camera.takePhoto')}
        </button>
      </div>
    </div>
  );
}
