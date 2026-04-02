/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './src/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        background: '#050A0F',
        card: '#0E2235',
        card2: '#102848',
        green: '#00FF88',
        coral: '#FF4D6D',
        amber: '#FFB347',
        ice: '#C8F0FF',
        muted: '#5A8FAA',
        border: '#1A3A5C',
      },
      fontFamily: {
        sans: ['var(--font-dm-sans)', 'system-ui', 'sans-serif'],
        syne: ['var(--font-syne)', 'sans-serif'],
      },
    },
  },
  plugins: [],
}
