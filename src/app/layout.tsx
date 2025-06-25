import './globals.css';
import type { Metadata } from 'next';
import { Inter, JetBrains_Mono } from 'next/font/google';
import Drawer from '../components/Drawer';
import React from 'react';
import { ThemeProvider, createTheme, CssBaseline } from '@mui/material';
import AppHeader from '../components/AppHeader';

const inter = Inter({ subsets: ['latin'], variable: '--font-inter' });
const jetbrains = JetBrains_Mono({ subsets: ['latin'], variable: '--font-jetbrains' });

const theme = createTheme({
  palette: {
    mode: 'light',
    primary: {
      main: '#14b8a6', // teal-500
    },
    secondary: {
      main: '#0ea5e9', // blue-500
    },
    background: {
      default: '#f8fafc', // light background
      paper: '#ffffff',
    },
    text: {
      primary: '#0f172a',
      secondary: '#64748b',
    },
  },
  shape: {
    borderRadius: 16,
  },
  typography: {
    fontFamily: `${inter.style.fontFamily}, ${jetbrains.style.fontFamily}, system-ui, sans-serif`,
  },
  components: {
    MuiButton: {
      styleOverrides: {
        root: {
          borderRadius: 12,
          textTransform: 'none',
          fontWeight: 600,
        },
      },
    },
    MuiPaper: {
      styleOverrides: {
        root: {
          borderRadius: 16,
        },
      },
    },
  },
});

export const metadata: Metadata = {
  title: 'Bjarne Niklas Luttermann - Media Informatics Portfolio',
  description: 'Portfolio von Bjarne Niklas Luttermann. Spezialisierung: Flutter, Unity, Next-Gen Media Platforms.',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="de" className="scroll-smooth">
      <head>
        <link rel="icon" type="image/svg+xml" href="/favicon.svg" />
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="" />
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
      </head>
      <body className={`${inter.variable} ${jetbrains.variable} font-sans antialiased`}>
        <ThemeProvider theme={theme}>
          <CssBaseline />
          <AppHeader />
          {/* Language Switcher */}
          <div className="fixed top-6 right-8 z-50">
            <button id="lang-switch" className="px-4 py-2 bg-teal-600 text-white rounded-full shadow hover:bg-teal-700 transition">EN</button>
          </div>
          <main>{children}</main>
          <footer className="w-full text-center py-2 bg-teal-600/10 text-teal-500 fixed bottom-0 left-0 z-40 text-sm">
            Diese Domain ist ggf. erwerbbar. Bei Interesse bitte Kontakt aufnehmen.
          </footer>
        </ThemeProvider>
      </body>
    </html>
  );
} 