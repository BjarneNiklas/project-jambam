import { Inter, JetBrains_Mono, Roboto, Creepster } from 'next/font/google';

export const inter = Inter({
  subsets: ['latin'],
  display: 'swap',
  variable: '--font-inter',
});

export const roboto = Roboto({
  weight: ['400', '500', '700'],
  subsets: ['latin'],
  display: 'swap',
  variable: '--font-roboto',
});

export const jetbrains_mono = JetBrains_Mono({
  weight: ['400', '500', '600'],
  subsets: ['latin'],
  display: 'swap',
  variable: '--font-jetbrains-mono',
});

export const creepster = Creepster({
  weight: ['400'], // Creepster typically only has a 400 weight
  subsets: ['latin'],
  display: 'swap',
  variable: '--font-creepster',
});
