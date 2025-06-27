"use client";

import React from 'react';
import ThemeRegistry from './ThemeRegistry';
import { LanguageProvider } from '../app/LanguageContext';
import ProgressBar from './ProgressBar';
import { Box } from '@mui/material';
import MobileSidebarController from './MobileSidebarController';
import ScrollToTopButton from './ScrollToTopButton';

export default function ClientProviders({
  children,
}: {
  children: React.ReactNode
}) {
  return (
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
  );
}