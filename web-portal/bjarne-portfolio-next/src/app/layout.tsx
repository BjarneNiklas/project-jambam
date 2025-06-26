// import React, { useState } from 'react';
import './globals.css';
import type { Metadata } from 'next';
import ThemeRegistry from '../components/ThemeRegistry';
import ProgressBar from '../components/ProgressBar';
import MobileSidebarController from '../components/MobileSidebarController';
import ScrollToTopButton from '../components/ScrollToTopButton';
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
        {/* FontAwesome weiterhin über CDN, da es für spezifische Icons in cv.json genutzt wird und eine Umstellung auf react-icons/Material Icons aufwendiger wäre und den Rahmen sprengt für eine reine Font-Optimierung */}
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
      </head>
      <body>
        <ThemeRegistry>
          <ProgressBar />
          <MobileSidebarController />
          <div style={{ width: '100%' }}>
            <div style={{ minWidth: 0, background: 'none' }}>
              {children}
            </div>
          </div>
          <ScrollToTopButton />
        </ThemeRegistry>
      </body>
    </html>
  );
}
