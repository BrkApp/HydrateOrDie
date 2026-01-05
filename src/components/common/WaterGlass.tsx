import { motion } from 'framer-motion';

interface WaterGlassProps {
  fillPercentage: number; // 0-100
  size?: number;
  className?: string;
}

export function WaterGlass({ fillPercentage, size = 200, className = '' }: WaterGlassProps) {
  const waterHeight = Math.max(5, (fillPercentage / 100) * 70); // 5-70% of glass height

  // Color changes based on hydration level
  const getWaterColor = () => {
    if (fillPercentage >= 100) return '#06FFA5'; // Success green
    if (fillPercentage >= 70) return '#00B4D8'; // Cyan
    if (fillPercentage >= 30) return '#FF6B35'; // Orange warning
    return '#EF476F'; // Danger red
  };

  return (
    <motion.svg
      width={size}
      height={size}
      viewBox="0 0 100 120"
      className={className}
      initial={{ scale: 0 }}
      animate={{ scale: 1 }}
      transition={{ type: 'spring', stiffness: 200, damping: 15 }}
    >
      <defs>
        {/* Gradient for water */}
        <linearGradient id="waterGradient" x1="0%" y1="0%" x2="0%" y2="100%">
          <stop offset="0%" stopColor={getWaterColor()} stopOpacity="0.9" />
          <stop offset="100%" stopColor={getWaterColor()} stopOpacity="0.6" />
        </linearGradient>

        {/* Shine gradient */}
        <linearGradient id="shineGradient" x1="0%" y1="0%" x2="100%" y2="0%">
          <stop offset="0%" stopColor="white" stopOpacity="0" />
          <stop offset="50%" stopColor="white" stopOpacity="0.3" />
          <stop offset="100%" stopColor="white" stopOpacity="0" />
        </linearGradient>

        {/* Clip path for water to stay inside glass */}
        <clipPath id="glassClip">
          <path d="M 25 20 L 30 90 Q 30 95 35 95 L 65 95 Q 70 95 70 90 L 75 20 Z" />
        </clipPath>
      </defs>

      {/* Glass outline */}
      <g filter="url(#glassGlow)">
        <path
          d="M 25 20 L 30 90 Q 30 95 35 95 L 65 95 Q 70 95 70 90 L 75 20 Z"
          fill="none"
          stroke="#8D99AE"
          strokeWidth="3"
          opacity="0.8"
        />

        {/* Glass rim - thicker */}
        <ellipse
          cx="50"
          cy="20"
          rx="25"
          ry="4"
          fill="none"
          stroke="#8D99AE"
          strokeWidth="3"
          opacity="0.9"
        />

        {/* Glass bottom */}
        <ellipse
          cx="50"
          cy="93"
          rx="15"
          ry="3"
          fill="#2B2D42"
          opacity="0.5"
        />
      </g>

      {/* Water with animated waves */}
      <g clipPath="url(#glassClip)">
        {/* Main water body */}
        <motion.rect
          x="25"
          y={95 - waterHeight}
          width="50"
          height={waterHeight}
          fill="url(#waterGradient)"
          initial={{ height: 0, y: 95 }}
          animate={{
            height: waterHeight,
            y: 95 - waterHeight,
          }}
          transition={{ duration: 1.5, ease: 'easeOut' }}
        />

        {/* Animated wave effect on top of water */}
        <motion.path
          d={`M 25 ${95 - waterHeight} Q 37.5 ${95 - waterHeight - 3} 50 ${95 - waterHeight} T 75 ${95 - waterHeight}`}
          fill={getWaterColor()}
          opacity="0.7"
          animate={{
            d: [
              `M 25 ${95 - waterHeight} Q 37.5 ${95 - waterHeight - 3} 50 ${95 - waterHeight} T 75 ${95 - waterHeight}`,
              `M 25 ${95 - waterHeight} Q 37.5 ${95 - waterHeight + 2} 50 ${95 - waterHeight} T 75 ${95 - waterHeight}`,
              `M 25 ${95 - waterHeight} Q 37.5 ${95 - waterHeight - 3} 50 ${95 - waterHeight} T 75 ${95 - waterHeight}`,
            ],
          }}
          transition={{ duration: 2, repeat: Infinity, ease: 'easeInOut' }}
        />

        {/* Second wave layer for depth */}
        <motion.path
          d={`M 25 ${95 - waterHeight + 5} Q 37.5 ${95 - waterHeight + 2} 50 ${95 - waterHeight + 5} T 75 ${95 - waterHeight + 5}`}
          fill={getWaterColor()}
          opacity="0.4"
          animate={{
            d: [
              `M 25 ${95 - waterHeight + 5} Q 37.5 ${95 - waterHeight + 2} 50 ${95 - waterHeight + 5} T 75 ${95 - waterHeight + 5}`,
              `M 25 ${95 - waterHeight + 5} Q 37.5 ${95 - waterHeight + 8} 50 ${95 - waterHeight + 5} T 75 ${95 - waterHeight + 5}`,
              `M 25 ${95 - waterHeight + 5} Q 37.5 ${95 - waterHeight + 2} 50 ${95 - waterHeight + 5} T 75 ${95 - waterHeight + 5}`,
            ],
          }}
          transition={{ duration: 2.5, repeat: Infinity, ease: 'easeInOut', delay: 0.3 }}
        />

        {/* Bubbles - only show when filling up */}
        {waterHeight > 10 && (
          <>
            <motion.circle
              cx="40"
              cy={95 - waterHeight / 2}
              r="2"
              fill="white"
              opacity="0.6"
              animate={{
                cy: [95 - waterHeight / 2, 95 - waterHeight - 10],
                opacity: [0.6, 0],
              }}
              transition={{ duration: 2, repeat: Infinity, delay: 0 }}
            />
            <motion.circle
              cx="55"
              cy={95 - waterHeight / 3}
              r="1.5"
              fill="white"
              opacity="0.6"
              animate={{
                cy: [95 - waterHeight / 3, 95 - waterHeight - 8],
                opacity: [0.6, 0],
              }}
              transition={{ duration: 1.8, repeat: Infinity, delay: 0.5 }}
            />
            <motion.circle
              cx="45"
              cy={95 - waterHeight * 0.7}
              r="1"
              fill="white"
              opacity="0.5"
              animate={{
                cy: [95 - waterHeight * 0.7, 95 - waterHeight - 5],
                opacity: [0.5, 0],
              }}
              transition={{ duration: 1.5, repeat: Infinity, delay: 1 }}
            />
          </>
        )}
      </g>

      {/* Glass shine effect */}
      <ellipse
        cx="35"
        cy="45"
        rx="8"
        ry="25"
        fill="url(#shineGradient)"
        opacity="0.4"
        transform="rotate(-20 35 45)"
      />

      {/* Glow filter definition */}
      <defs>
        <filter id="glassGlow" x="-50%" y="-50%" width="200%" height="200%">
          <feGaussianBlur stdDeviation="2" result="blur" />
          <feFlood floodColor={getWaterColor()} floodOpacity="0.3" />
          <feComposite in2="blur" operator="in" />
          <feMerge>
            <feMergeNode />
            <feMergeNode in="SourceGraphic" />
          </feMerge>
        </filter>
      </defs>

      {/* Percentage text below glass */}
      <text
        x="50"
        y="110"
        textAnchor="middle"
        fontSize="12"
        fontWeight="bold"
        fill={getWaterColor()}
        opacity="0.8"
      >
        {Math.round(fillPercentage)}%
      </text>
    </motion.svg>
  );
}
