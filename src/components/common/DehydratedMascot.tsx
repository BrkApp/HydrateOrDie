import { motion } from 'framer-motion';

type MascotState = 'dying' | 'worried' | 'angry' | 'happy';

interface DehydratedMascotProps {
  state: MascotState;
  size?: number;
  className?: string;
}

export function DehydratedMascot({ state, size = 200, className = '' }: DehydratedMascotProps) {
  // Expression changes based on state
  const getEyeY = () => {
    switch (state) {
      case 'dying': return '45'; // Eyes sinking
      case 'worried': return '42';
      case 'angry': return '40';
      case 'happy': return '38';
    }
  };

  const getMouthPath = () => {
    switch (state) {
      case 'dying': return 'M 40 75 Q 50 78 60 75'; // Weak frown
      case 'worried': return 'M 40 72 Q 50 75 60 72'; // Slight frown
      case 'angry': return 'M 40 70 Q 50 68 60 70'; // Angry frown
      case 'happy': return 'M 40 68 Q 50 72 60 68'; // Smile
    }
  };

  const getAnimation = () => {
    switch (state) {
      case 'dying':
        return {
          y: [0, 5, 0],
          opacity: [1, 0.8, 1],
          transition: { duration: 2, repeat: Infinity },
        };
      case 'worried':
        return {
          rotate: [-2, 2, -2],
          transition: { duration: 1.5, repeat: Infinity },
        };
      case 'angry':
        return {
          scale: [1, 1.05, 1],
          transition: { duration: 0.5, repeat: Infinity },
        };
      case 'happy':
        return {
          y: [0, -10, 0],
          transition: { duration: 0.6, repeat: Infinity, repeatDelay: 2 },
        };
    }
  };

  return (
    <motion.svg
      width={size}
      height={size}
      viewBox="0 0 100 100"
      className={className}
      animate={getAnimation()}
    >
      {/* Head - skull-like shape */}
      <g>
        {/* Skull outline */}
        <ellipse
          cx="50"
          cy="45"
          rx="35"
          ry="40"
          fill="#2B2D42"
          stroke={state === 'angry' ? '#EF476F' : state === 'happy' ? '#06FFA5' : '#8D99AE'}
          strokeWidth="3"
        />

        {/* Cheekbones - visible when dehydrated */}
        {(state === 'dying' || state === 'worried') && (
          <>
            <ellipse cx="30" cy="50" rx="8" ry="12" fill="#1A1B2E" opacity="0.3" />
            <ellipse cx="70" cy="50" rx="8" ry="12" fill="#1A1B2E" opacity="0.3" />
          </>
        )}

        {/* Eyes - sunken */}
        <g>
          {/* Eye sockets */}
          <ellipse cx="38" cy={getEyeY()} rx="8" ry="10" fill="#1A1B2E" />
          <ellipse cx="62" cy={getEyeY()} rx="8" ry="10" fill="#1A1B2E" />

          {/* Eye pupils */}
          <circle
            cx="38"
            cy={getEyeY()}
            r={state === 'dying' ? '2' : '3'}
            fill={state === 'angry' ? '#EF476F' : state === 'happy' ? '#06FFA5' : '#00B4D8'}
          />
          <circle
            cx="62"
            cy={getEyeY()}
            r={state === 'dying' ? '2' : '3'}
            fill={state === 'angry' ? '#EF476F' : state === 'happy' ? '#06FFA5' : '#00B4D8'}
          />
        </g>

        {/* Mouth - desperate/happy */}
        <motion.path
          d={getMouthPath()}
          stroke={state === 'angry' ? '#EF476F' : state === 'happy' ? '#06FFA5' : '#8D99AE'}
          strokeWidth="3"
          fill="none"
          strokeLinecap="round"
          animate={state === 'dying' ? { opacity: [1, 0.5, 1] } : {}}
          transition={{ duration: 1.5, repeat: Infinity }}
        />

        {/* Tongue (for dying state - dehydrated) */}
        {state === 'dying' && (
          <ellipse cx="50" cy="75" rx="4" ry="2" fill="#DC345A" opacity="0.6" />
        )}
      </g>

      {/* Water glass being held */}
      <g transform="translate(70, 60)">
        {/* Glass */}
        <rect
          x="0"
          y="0"
          width="20"
          height="30"
          fill="none"
          stroke="#00B4D8"
          strokeWidth="2"
          rx="2"
        />

        {/* Water level - changes with state */}
        <motion.rect
          x="2"
          y={state === 'happy' ? '10' : state === 'angry' ? '20' : '25'}
          width="16"
          height={state === 'happy' ? '18' : state === 'angry' ? '8' : '3'}
          fill="#00B4D8"
          opacity="0.6"
          animate={{
            opacity: [0.4, 0.7, 0.4],
          }}
          transition={{ duration: 2, repeat: Infinity }}
        />

        {/* Bubbles */}
        {state === 'happy' && (
          <>
            <motion.circle
              cx="10"
              cy="15"
              r="1.5"
              fill="#00B4D8"
              opacity="0.8"
              animate={{ y: [0, -5], opacity: [0.8, 0] }}
              transition={{ duration: 1, repeat: Infinity, delay: 0 }}
            />
            <motion.circle
              cx="14"
              cy="18"
              r="1"
              fill="#00B4D8"
              opacity="0.8"
              animate={{ y: [0, -5], opacity: [0.8, 0] }}
              transition={{ duration: 1, repeat: Infinity, delay: 0.3 }}
            />
          </>
        )}

        {/* Hand holding glass */}
        <path
          d="M -5 25 Q -3 28 0 30"
          stroke="#2B2D42"
          strokeWidth="3"
          fill="none"
          strokeLinecap="round"
        />
      </g>

      {/* Speech bubble (optional - for messages) */}
      {state === 'angry' && (
        <g>
          <rect x="2" y="5" width="40" height="20" rx="10" fill="#EF476F" opacity="0.9" />
          <polygon points="38,25 42,30 40,25" fill="#EF476F" opacity="0.9" />
          <text x="22" y="18" fontSize="10" fontWeight="bold" fill="white" textAnchor="middle">
            BOIS!
          </text>
        </g>
      )}
    </motion.svg>
  );
}
