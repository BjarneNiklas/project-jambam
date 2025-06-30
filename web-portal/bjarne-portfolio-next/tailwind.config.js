/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./src/app/**/*.{js,ts,jsx,tsx}",
    "../../app/(routes)/**/*.{js,ts,jsx,tsx}", // Added path for root app routes
    "./src/components/**/*.{js,ts,jsx,tsx}",
    "./src/data/**/*.{js,ts,jsx,tsx}",
    "./src/styles/**/*.{js,ts,jsx,tsx,css}"
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['var(--font-inter)', 'sans-serif'],
        creepster: ['var(--font-creepster)', 'cursive'],
      },
    },
  },
  plugins: [
    require('@tailwindcss/typography'),
  ],
}

