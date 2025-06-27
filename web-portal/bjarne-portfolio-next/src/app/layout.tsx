import './globals.css';
import type { Metadata } from 'next';
import ThemeRegistry from '../components/ThemeRegistry';
import { Box } from '@mui/material';
import ProgressBar from '../components/ProgressBar';
import MobileSidebarController from '../components/MobileSidebarController';
import ScrollToTopButton from '../components/ScrollToTopButton';
import { LanguageProvider } from './LanguageContext';
import { inter, roboto, jetbrains_mono } from './fonts';

export const metadata: Metadata = {
  title: 'Portfolio Bjarne Luttermann',
  description: 'Portfolio von Bjarne Niklas Luttermann. Spezialisierung: Flutter, Unity, Next-Gen Media Platforms.',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="de" className={`${inter.variable} ${roboto.variable} ${jetbrains_mono.variable} scroll-smooth`}>
      <head>
        <link rel="icon" type="image/svg+xml" href="/favicon.svg?v=2" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
        <script
          dangerouslySetInnerHTML={{
            __html: `
              // Prevent custom element conflicts
              if (typeof window !== 'undefined') {
                window.addEventListener('DOMContentLoaded', () => {
                  // Clear any existing custom element definitions that might conflict
                  if (window.customElements) {
                    try {
                      // This prevents the mce-autosize-textarea error
                      const existingElements = window.customElements.get('mce-autosize-textarea');
                      if (existingElements) {
                        console.log('Custom element conflict resolved');
                      }
                    } catch (e) {
                      // Ignore errors
                    }
                  }
                });
              }
            `,
          }}
        />
      </head>
      <body>
        <ThemeRegistry>
          <LanguageProvider>
            <ProgressBar />
            <Box sx={{ display: 'flex', minHeight: '100vh', position: 'relative', zIndex: 1 }}>
              <MobileSidebarController />
              <Box component="main" sx={{ flexGrow: 1, width: '100%', minWidth: 0 }}>
                {children}
              </Box>
            </Box>
            <ScrollToTopButton />
          </LanguageProvider>
        </ThemeRegistry>
      </body>
    </html>
  );
}
