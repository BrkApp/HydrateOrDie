import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  TouchableOpacity,
  StyleSheet,
  Dimensions,
} from 'react-native';
import { StatusBar } from 'expo-status-bar';
import WaterEffect from '../components/WaterEffect';
import SkullLogo from '../components/SkullLogo';
import { storage } from '../services/storage';
import { notifications } from '../services/notifications';
import { COLORS, getMotivationalMessage } from '../utils/constants';

const { width: SCREEN_WIDTH } = Dimensions.get('window');

export default function HomeScreen({ onCameraPress }) {
  const [todayMl, setTodayMl] = useState(0);
  const [dailyGoal, setDailyGoal] = useState(2000);
  const [streak, setStreak] = useState(0);
  const [message, setMessage] = useState('');

  useEffect(() => {
    loadData();

    // Check notifications escalation every minute
    const interval = setInterval(() => {
      notifications.checkAndEscalate();
    }, 60000);

    return () => clearInterval(interval);
  }, []);

  useEffect(() => {
    // Update message when progress changes
    setMessage(getMotivationalMessage(todayMl, dailyGoal));
  }, [todayMl, dailyGoal]);

  const loadData = async () => {
    const ml = await storage.getTodayMl();
    const goal = await storage.getDailyGoal();
    const streakCount = await storage.getStreak();

    setTodayMl(ml);
    setDailyGoal(goal);
    setStreak(streakCount);
  };

  const handleCameraComplete = (newTotal) => {
    setTodayMl(newTotal);

    // Cancel spam mode if goal reached
    if (newTotal >= dailyGoal) {
      notifications.cancelSpamMode();
    }
  };

  const fillPercentage = Math.min(100, (todayMl / dailyGoal) * 100);
  const remainingMl = Math.max(0, dailyGoal - todayMl);

  return (
    <View style={styles.container}>
      <StatusBar style="light" />

      {/* Water effect in background */}
      <WaterEffect fillPercentage={fillPercentage} />

      {/* Content overlay */}
      <View style={styles.content}>
        {/* Streak at top */}
        <View style={styles.streakContainer}>
          <Text style={styles.streakEmoji}>🔥</Text>
          <Text style={styles.streakText}>{streak} jours</Text>
        </View>

        {/* Skull logo in center */}
        <View style={styles.logoContainer}>
          <SkullLogo size={140} color={COLORS.WHITE} />
        </View>

        {/* Progress text */}
        <View style={styles.progressContainer}>
          <Text style={styles.progressText}>
            {remainingMl > 0
              ? `Il te reste ${remainingMl} ml à boire aujourd'hui`
              : '🎉 Objectif atteint !'}
          </Text>

          <Text style={styles.messageText}>{message}</Text>

          <View style={styles.statsRow}>
            <View style={styles.statBox}>
              <Text style={styles.statValue}>{todayMl}</Text>
              <Text style={styles.statLabel}>bu aujourd'hui</Text>
            </View>
            <View style={styles.statDivider} />
            <View style={styles.statBox}>
              <Text style={styles.statValue}>{dailyGoal}</Text>
              <Text style={styles.statLabel}>objectif</Text>
            </View>
          </View>
        </View>

        {/* Camera button */}
        <TouchableOpacity
          style={styles.cameraButton}
          onPress={() => onCameraPress(handleCameraComplete)}
          activeOpacity={0.8}
        >
          <Text style={styles.cameraButtonText}>J'ai bu ! 📸</Text>
        </TouchableOpacity>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: COLORS.DARK_BG,
  },
  content: {
    flex: 1,
    justifyContent: 'space-between',
    paddingVertical: 60,
    paddingHorizontal: 24,
  },
  streakContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    alignSelf: 'center',
    backgroundColor: COLORS.DARK_CARD + '80',
    paddingHorizontal: 20,
    paddingVertical: 12,
    borderRadius: 999,
    backdropFilter: 'blur(10px)',
  },
  streakEmoji: {
    fontSize: 24,
    marginRight: 8,
  },
  streakText: {
    fontSize: 18,
    fontWeight: '700',
    color: COLORS.WHITE,
  },
  logoContainer: {
    alignItems: 'center',
    justifyContent: 'center',
  },
  progressContainer: {
    alignItems: 'center',
  },
  progressText: {
    fontSize: 18,
    fontWeight: '600',
    color: COLORS.WHITE,
    textAlign: 'center',
    marginBottom: 12,
  },
  messageText: {
    fontSize: 14,
    color: COLORS.TEXT_LIGHT,
    textAlign: 'center',
    marginBottom: 24,
  },
  statsRow: {
    flexDirection: 'row',
    backgroundColor: COLORS.DARK_CARD + '80',
    borderRadius: 20,
    padding: 16,
    alignItems: 'center',
  },
  statBox: {
    flex: 1,
    alignItems: 'center',
  },
  statValue: {
    fontSize: 32,
    fontWeight: '900',
    color: COLORS.PRIMARY,
  },
  statLabel: {
    fontSize: 12,
    color: COLORS.GRAY,
    marginTop: 4,
  },
  statDivider: {
    width: 1,
    height: 40,
    backgroundColor: COLORS.GRAY + '40',
    marginHorizontal: 16,
  },
  cameraButton: {
    backgroundColor: COLORS.DANGER,
    borderRadius: 999,
    paddingVertical: 20,
    alignItems: 'center',
    shadowColor: COLORS.DANGER,
    shadowOffset: { width: 0, height: 8 },
    shadowOpacity: 0.4,
    shadowRadius: 16,
    elevation: 12,
  },
  cameraButtonText: {
    fontSize: 20,
    fontWeight: '900',
    color: COLORS.WHITE,
    letterSpacing: 1,
  },
});
