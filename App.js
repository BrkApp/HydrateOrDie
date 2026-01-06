import React, { useState, useEffect } from 'react';
import { View, ActivityIndicator } from 'react-native';
import OnboardingScreen from './screens/OnboardingScreen';
import HomeScreen from './screens/HomeScreen';
import CameraScreen from './screens/CameraScreen';
import { storage } from './services/storage';
import { COLORS } from './utils/constants';

export default function App() {
  const [isLoading, setIsLoading] = useState(true);
  const [hasCompletedOnboarding, setHasCompletedOnboarding] = useState(false);
  const [showCamera, setShowCamera] = useState(false);
  const [onPhotoTakenCallback, setOnPhotoTakenCallback] = useState(null);

  useEffect(() => {
    checkOnboarding();
  }, []);

  const checkOnboarding = async () => {
    const isDone = await storage.isOnboardingDone();
    setHasCompletedOnboarding(isDone);
    setIsLoading(false);
  };

  const handleOnboardingComplete = () => {
    setHasCompletedOnboarding(true);
  };

  const handleCameraPress = (callback) => {
    setOnPhotoTakenCallback(() => callback);
    setShowCamera(true);
  };

  const handlePhotoTaken = (newTotal) => {
    setShowCamera(false);
    if (onPhotoTakenCallback) {
      onPhotoTakenCallback(newTotal);
    }
  };

  const handleCameraCancel = () => {
    setShowCamera(false);
  };

  if (isLoading) {
    return (
      <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center', backgroundColor: COLORS.DARK_BG }}>
        <ActivityIndicator size="large" color={COLORS.PRIMARY} />
      </View>
    );
  }

  if (showCamera) {
    return (
      <CameraScreen
        onPhotoTaken={handlePhotoTaken}
        onCancel={handleCameraCancel}
      />
    );
  }

  if (!hasCompletedOnboarding) {
    return <OnboardingScreen onComplete={handleOnboardingComplete} />;
  }

  return <HomeScreen onCameraPress={handleCameraPress} />;
}
