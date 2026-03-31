/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './pages/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
    './app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        bg: { DEFAULT: '#050A0F', card: '#0A1628', border: '#1A2D4A' },
        accent: { blue: '#0066FF', cyan: '#00D4FF', green: '#00FF94', red: '#FF4444' },
        text: { primary: '#FFFFFF', secondary: '#8899AA', muted: '#445566' },
      },
      fontFamily: { sans: ['Inter', 'system-ui', 'sans-serif'] },
    },
  },
  plugins: [],
}
