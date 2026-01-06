import React, { useEffect } from 'react';
import { Dimensions } from 'react-native';
import Animated, {
  useSharedValue,
  useAnimatedProps,
  withTiming,
  withRepeat,
  Easing,
} from 'react-native-reanimated';
import Svg, { Path, Defs, LinearGradient, Stop } from 'react-native-svg';
import { COLORS } from '../utils/constants';

const { width: SCREEN_WIDTH, height: SCREEN_HEIGHT } = Dimensions.get('window');

const AnimatedPath = Animated.createAnimatedComponent(Path);

export default function WaterEffect({ fillPercentage }) {
  // Water height (0-100% of screen)
  const waterHeight = useSharedValue(0);

  // Wave animation offset
  const waveOffset = useSharedValue(0);

  useEffect(() => {
    // Animate water height
    waterHeight.value = withTiming(fillPercentage, {
      duration: 1500,
      easing: Easing.out(Easing.cubic),
    });
  }, [fillPercentage]);

  useEffect(() => {
    // Continuous wave animation
    waveOffset.value = withRepeat(
      withTiming(1, {
        duration: 2000,
        easing: Easing.inOut(Easing.sin),
      }),
      -1,
      false
    );
  }, []);

  const animatedProps = useAnimatedProps(() => {
    const height = (waterHeight.value / 100) * SCREEN_HEIGHT;
    const y = SCREEN_HEIGHT - height;

    // Wave parameters
    const amplitude = 15;
    const frequency = 2;
    const phase = waveOffset.value * Math.PI * 2;

    // Create wavy top edge using sine wave
    let pathData = `M 0 ${y}`;

    for (let x = 0; x <= SCREEN_WIDTH; x += 5) {
      const wave = Math.sin((x / SCREEN_WIDTH) * Math.PI * frequency + phase) * amplitude;
      pathData += ` L ${x} ${y + wave}`;
    }

    // Close the path at bottom
    pathData += ` L ${SCREEN_WIDTH} ${SCREEN_HEIGHT} L 0 ${SCREEN_HEIGHT} Z`;

    return {
      d: pathData,
    };
  });

  // Color changes based on fill percentage
  const getWaterColor = () => {
    if (fillPercentage >= 100) return COLORS.SUCCESS;
    if (fillPercentage >= 70) return COLORS.CYAN;
    if (fillPercentage >= 30) return COLORS.URGENT;
    return COLORS.DANGER;
  };

  return (
    <Svg
      width={SCREEN_WIDTH}
      height={SCREEN_HEIGHT}
      style={{ position: 'absolute', bottom: 0, left: 0 }}
    >
      <Defs>
        <LinearGradient id="waterGradient" x1="0%" y1="0%" x2="0%" y2="100%">
          <Stop offset="0%" stopColor={getWaterColor()} stopOpacity="0.4" />
          <Stop offset="100%" stopColor={getWaterColor()} stopOpacity="0.8" />
        </LinearGradient>
      </Defs>

      <AnimatedPath animatedProps={animatedProps} fill="url(#waterGradient)" />
    </Svg>
  );
}
