import React from 'react';
import Svg, { Path, Circle, Ellipse } from 'react-native-svg';

export default function SkullLogo({ size = 120, color = '#FFFFFF' }) {
  return (
    <Svg width={size} height={size} viewBox="0 0 100 100">
      {/* Skull outline */}
      <Ellipse
        cx="50"
        cy="45"
        rx="30"
        ry="35"
        fill="none"
        stroke={color}
        strokeWidth="3"
      />

      {/* Eye sockets */}
      <Ellipse cx="38" cy="40" rx="8" ry="10" fill={color} />
      <Ellipse cx="62" cy="40" rx="8" ry="10" fill={color} />

      {/* Nose triangle */}
      <Path d="M 50 50 L 45 60 L 55 60 Z" fill={color} />

      {/* Teeth */}
      <Path
        d="M 35 70 L 35 75 M 40 70 L 40 75 M 45 70 L 45 75 M 50 70 L 50 75 M 55 70 L 55 75 M 60 70 L 60 75 M 65 70 L 65 75"
        stroke={color}
        strokeWidth="2"
        strokeLinecap="round"
      />

      {/* Jawline */}
      <Path
        d="M 30 65 Q 50 72 70 65"
        fill="none"
        stroke={color}
        strokeWidth="3"
      />

      {/* 💀 emoji style */}
      <Circle cx="50" cy="90" r="3" fill={color} opacity="0.3" />
    </Svg>
  );
}
