import React, { useState } from 'react';
import {
  View,
  Text,
  TextInput,
  TouchableOpacity,
  StyleSheet,
  KeyboardAvoidingView,
  Platform,
} from 'react-native';
import { storage } from '../services/storage';
import { notifications } from '../services/notifications';
import { COLORS } from '../utils/constants';

export default function OnboardingScreen({ onComplete }) {
  const [dailyGoal, setDailyGoal] = useState('2000');

  const handleStart = async () => {
    const goal = parseInt(dailyGoal) || 2000;
    await storage.setDailyGoal(goal);
    await storage.setOnboardingDone();

    // Request notification permissions
    await notifications.requestPermissions();
    await notifications.scheduleNormalReminders();

    onComplete();
  };

  return (
    <KeyboardAvoidingView
      behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
      style={styles.container}
    >
      <View style={styles.content}>
        <Text style={styles.title}>HydrateOrDie</Text>
        <Text style={styles.subtitle}>💀💧</Text>

        <Text style={styles.tagline}>
          L'app de rappel d'hydratation{'\n'}la plus punitive du marché
        </Text>

        <View style={styles.card}>
          <Text style={styles.label}>Objectif quotidien</Text>
          <View style={styles.inputContainer}>
            <TextInput
              style={styles.input}
              value={dailyGoal}
              onChangeText={setDailyGoal}
              keyboardType="number-pad"
              placeholder="2000"
              placeholderTextColor={COLORS.GRAY}
            />
            <Text style={styles.unit}>ml</Text>
          </View>

          <Text style={styles.hint}>
            Recommandation : 2000-3000 ml par jour
          </Text>
        </View>

        <TouchableOpacity style={styles.button} onPress={handleStart}>
          <Text style={styles.buttonText}>COMMENCER</Text>
        </TouchableOpacity>

        <Text style={styles.warning}>
          ⚠️ L'app te spammera si tu ne bois pas
        </Text>
      </View>
    </KeyboardAvoidingView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: COLORS.DARK_BG,
  },
  content: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 24,
  },
  title: {
    fontSize: 48,
    fontWeight: '900',
    color: COLORS.WHITE,
    marginBottom: 8,
    textAlign: 'center',
  },
  subtitle: {
    fontSize: 32,
    marginBottom: 16,
  },
  tagline: {
    fontSize: 16,
    color: COLORS.TEXT_LIGHT,
    textAlign: 'center',
    marginBottom: 48,
  },
  card: {
    width: '100%',
    backgroundColor: COLORS.DARK_CARD,
    borderRadius: 24,
    padding: 24,
    marginBottom: 32,
  },
  label: {
    fontSize: 14,
    color: COLORS.GRAY,
    marginBottom: 12,
    fontWeight: '600',
  },
  inputContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: COLORS.DARK_BG,
    borderRadius: 16,
    paddingHorizontal: 16,
  },
  input: {
    flex: 1,
    fontSize: 32,
    fontWeight: '700',
    color: COLORS.WHITE,
    paddingVertical: 16,
  },
  unit: {
    fontSize: 24,
    color: COLORS.GRAY,
    marginLeft: 8,
  },
  hint: {
    fontSize: 12,
    color: COLORS.GRAY,
    marginTop: 12,
  },
  button: {
    width: '100%',
    backgroundColor: COLORS.PRIMARY,
    borderRadius: 999,
    paddingVertical: 18,
    alignItems: 'center',
    shadowColor: COLORS.PRIMARY,
    shadowOffset: { width: 0, height: 8 },
    shadowOpacity: 0.3,
    shadowRadius: 16,
    elevation: 8,
  },
  buttonText: {
    fontSize: 18,
    fontWeight: '700',
    color: COLORS.WHITE,
    letterSpacing: 1,
  },
  warning: {
    fontSize: 14,
    color: COLORS.DANGER,
    marginTop: 24,
    textAlign: 'center',
  },
});
