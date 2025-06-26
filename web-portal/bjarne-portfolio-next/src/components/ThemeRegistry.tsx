'use client';
import React, { useState } from 'react';
import { ThemeProvider, createTheme } from '@mui/material/styles';
import CssBaseline from '@mui/material/CssBaseline';
import { useServerInsertedHTML } from 'next/navigation';
import createCache from '@emotion/cache';
import { CacheProvider } from '@emotion/react';
// Import font variables if you need to access them directly in the theme,
// otherwise, they are globally available via CSS variables defined in layout.tsx
// import { inter, roboto, jetbrains_mono } from '../app/fonts';

// Main ThemeRegistry component
export default function ThemeRegistry({ children }: { children: React.ReactNode }) {
  const [{ cache, flush }] = useState(() => {
    const cache = createCache({ key: 'mui' });
    cache.compat = true;
    const prevInsert = cache.insert;
    let inserted: string[] = [];
    cache.insert = (...args) => {
      const serialized = args[1];
      if (cache.inserted[serialized.name] === undefined) {
        inserted.push(serialized.name);
      }
      return prevInsert(...args);
    };
    const flush = () => {
      const prevInserted = inserted;
      inserted = [];
      return prevInserted;
    };
    return { cache, flush };
  });

  useServerInsertedHTML(() => {
    const names = flush();
    if (names.length === 0) {
      return null;
    }
    let styles = '';
    for (const name of names) {
      styles += cache.inserted[name];
    }
    return (
      <style
        key={cache.key}
        data-emotion={`${cache.key} ${names.join(' ')}`}
        dangerouslySetInnerHTML={{
          __html: styles,
        }}
      />
    );
  });

  const theme = createTheme({
    palette: {
      mode: 'dark',
      primary: {
        main: '#009688', // MUI Teal
        light: '#33ab9f',
        dark: '#00695f',
        contrastText: '#ffffff',
      },
      secondary: {
        main: '#26a69a', // heller Teal
        light: '#64d8cb',
        dark: '#00796b',
        contrastText: '#ffffff',
      },
      background: {
        default: '#0a0a0a', // Set the global background color here
        paper: '#1a1a1a',
      },
      text: {
        primary: '#ffffff',
        secondary: '#a0a0a0',
      },
    },
    typography: {
      // Use the CSS variable for Inter as the primary font.
      // Roboto and JetBrains Mono can be used specifically where needed by applying their CSS variables.
      fontFamily: 'var(--font-inter), var(--font-roboto), Roboto, Helvetica, Arial, sans-serif',
      h1: {
        fontWeight: 700,
      },
      h2: {
        fontWeight: 600,
      },
      h3: {
        fontWeight: 600,
      },
      h4: {
        fontWeight: 500,
      },
      h5: {
        fontWeight: 500,
      },
      h6: {
        fontWeight: 500,
      },
      // Example for using JetBrains Mono for specific elements if needed via MUI components
      // caption: {
      //   fontFamily: 'var(--font-jetbrains-mono), monospace',
      // },
    },
    components: {
      MuiButton: {
        styleOverrides: {
          root: {
            borderRadius: 8,
            textTransform: 'none',
            fontWeight: 500,
          },
        },
      },
      MuiCard: {
        styleOverrides: {
          root: {
            borderRadius: 12,
            background: 'rgba(26, 26, 26, 0.8)', // Slightly transparent paper
            backdropFilter: 'blur(10px)',
            border: '1px solid rgba(0, 150, 136, 0.1)',
          },
        },
      },
      MuiCssBaseline: {
        styleOverrides: `
          body {
            background-color: #0a0a0a; /* Ensure body background is set */
          }
        `,
      },
    },
  });

  return (
    <CacheProvider value={cache}>
      <ThemeProvider theme={theme}>
        <CssBaseline />
        {children}
      </ThemeProvider>
    </CacheProvider>
  );
} 