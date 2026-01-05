/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        // Bleus électriques - eau énergique
        primary: {
          50: '#E0F7FF',
          100: '#B3EDFF',
          200: '#80E3FF',
          300: '#4DD9FF',
          400: '#26D0FF',
          500: '#00B4D8', // Cyan vibrant
          600: '#0096C7',
          700: '#0077B6', // Bleu électrique principal
          800: '#005F8C',
          900: '#023E62',
        },
        // Rouge/Orange punchy - urgence
        danger: {
          50: '#FFE8ED',
          100: '#FFC2D1',
          200: '#FF99B3',
          300: '#FF7095',
          400: '#FF527E',
          500: '#EF476F', // Rouge punchy
          600: '#E63E66',
          700: '#DC345A',
          800: '#D32A4E',
          900: '#C41A3A',
        },
        urgent: {
          500: '#FF6B35', // Orange vif
          600: '#FF5722',
          700: '#F4511E',
        },
        // Success - vert lime
        success: {
          400: '#26FFAA',
          500: '#06FFA5', // Vert lime électrique
          600: '#00E690',
        },
        // Neutrals - gris chauds
        neutral: {
          50: '#F8F9FA',
          100: '#E9ECEF',
          200: '#CED4DA',
          300: '#ADB5BD',
          400: '#8D99AE', // Gris chaud moyen
          500: '#6C757D',
          600: '#495057',
          700: '#343A40',
          800: '#2B2D42', // Gris chaud foncé
          900: '#1A1B2E',
        },
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', 'sans-serif'],
        display: ['Space Grotesk', 'Inter', 'sans-serif'],
      },
      fontSize: {
        'dramatic': ['72px', { lineHeight: '1', fontWeight: '900' }],
        'punch': ['48px', { lineHeight: '1.1', fontWeight: '800' }],
      },
      boxShadow: {
        'brutal': '8px 8px 0px 0px rgba(0, 0, 0, 0.25)',
        'glow-cyan': '0 0 20px rgba(0, 180, 216, 0.5)',
        'glow-danger': '0 0 20px rgba(239, 71, 111, 0.5)',
        'strong': '0 10px 40px rgba(0, 0, 0, 0.3)',
      },
      animation: {
        'ripple': 'ripple 600ms ease-out',
        'shake': 'shake 0.5s cubic-bezier(.36,.07,.19,.97) both',
        'shake-violent': 'shake-violent 0.3s cubic-bezier(.36,.07,.19,.97) infinite',
        'pulse-slow': 'pulse 3s cubic-bezier(0.4, 0, 0.6, 1) infinite',
        'bounce-dramatic': 'bounce-dramatic 0.6s ease-in-out',
        'glitch': 'glitch 0.5s cubic-bezier(0.25, 0.46, 0.45, 0.94) infinite',
        'float': 'float 3s ease-in-out infinite',
        'gradient-shift': 'gradient-shift 8s ease infinite',
      },
      keyframes: {
        ripple: {
          '0%': { transform: 'scale(0)', opacity: '1' },
          '100%': { transform: 'scale(4)', opacity: '0' },
        },
        shake: {
          '10%, 90%': { transform: 'translate3d(-1px, 0, 0)' },
          '20%, 80%': { transform: 'translate3d(2px, 0, 0)' },
          '30%, 50%, 70%': { transform: 'translate3d(-4px, 0, 0)' },
          '40%, 60%': { transform: 'translate3d(4px, 0, 0)' },
        },
        'shake-violent': {
          '0%, 100%': { transform: 'translate3d(0, 0, 0)' },
          '10%, 30%, 50%, 70%, 90%': { transform: 'translate3d(-10px, 0, 0)' },
          '20%, 40%, 60%, 80%': { transform: 'translate3d(10px, 0, 0)' },
        },
        'bounce-dramatic': {
          '0%, 100%': { transform: 'translateY(0) scale(1)' },
          '50%': { transform: 'translateY(-30px) scale(1.1)' },
        },
        glitch: {
          '0%': { transform: 'translate(0)' },
          '20%': { transform: 'translate(-2px, 2px)' },
          '40%': { transform: 'translate(-2px, -2px)' },
          '60%': { transform: 'translate(2px, 2px)' },
          '80%': { transform: 'translate(2px, -2px)' },
          '100%': { transform: 'translate(0)' },
        },
        float: {
          '0%, 100%': { transform: 'translateY(0px)' },
          '50%': { transform: 'translateY(-20px)' },
        },
        'gradient-shift': {
          '0%, 100%': { backgroundPosition: '0% 50%' },
          '50%': { backgroundPosition: '100% 50%' },
        },
      },
      backdropBlur: {
        'glass': '12px',
      },
    },
  },
  plugins: [],
}
