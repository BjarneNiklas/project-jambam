'use client';

import React, { useEffect, useRef, useState } from 'react';
import { Box, Typography, Stack, useTheme } from '@mui/material';

const claims = {
  de: [
    'Deine Vision? Realisiert!',
    'Spitzentechnologie. Echte Ergebnisse.',
    'Gemeinsam Zukunft gestalten.'
  ],
  en: [
    'Your vision? Realized!',
    'Cutting-edge tech. Real results.',
    'Shaping the future together.'
  ]
};

const Hero: React.FC = () => {
  const [lang, setLang] = useState<'de' | 'en'>('de');
  const [claimIndex, setClaimIndex] = useState(0);
  const claimRef = useRef<HTMLDivElement>(null);
  const theme = useTheme();

  useEffect(() => {
    const interval = setInterval(() => {
      setClaimIndex((prev) => (prev + 1) % claims[lang].length);
    }, 3500);
    return () => clearInterval(interval);
  }, [lang]);

  useEffect(() => {
    const btn = document.getElementById('lang-switch');
    if (btn) {
      btn.textContent = lang === 'de' ? 'EN' : 'DE';
      btn.onclick = () => setLang((l) => (l === 'de' ? 'en' : 'de'));
    }
  }, [lang]);

  return (
    <Box
      component="section"
      id="home"
      sx={{
        position: 'relative',
        minHeight: '100vh',
        marginTop: '64px',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        overflow: 'hidden',
        bgcolor: theme.palette.background.default,
      }}
    >
      {/* Animated background */}
      <Box sx={{ position: 'absolute', inset: 0, zIndex: 0 }}>
        <Box sx={{ position: 'absolute', inset: 0, bgcolor: 'background.default' }} />
        <div className="absolute inset-0 animate-aura-light" id="aura-background" />
        {/* Floating circles */}
        <Box sx={{ position: 'absolute', top: '10%', left: '15%', width: 96, height: 96, bgcolor: 'white', opacity: 0.1, borderRadius: '50%', filter: 'blur(32px)' }} />
        <Box sx={{ position: 'absolute', top: '30%', right: '20%', width: 128, height: 128, bgcolor: 'white', opacity: 0.15, borderRadius: '50%', filter: 'blur(32px)' }} />
        <Box sx={{ position: 'absolute', bottom: '25%', left: '10%', width: 80, height: 80, bgcolor: 'white', opacity: 0.12, borderRadius: '50%', filter: 'blur(32px)' }} />
        <Box sx={{ position: 'absolute', bottom: '15%', right: '15%', width: 112, height: 112, bgcolor: 'white', opacity: 0.18, borderRadius: '50%', filter: 'blur(32px)' }} />
        <Box sx={{ position: 'absolute', top: '50%', left: '5%', width: 64, height: 64, bgcolor: 'white', opacity: 0.08, borderRadius: '50%', filter: 'blur(32px)' }} />
        <Box sx={{ position: 'absolute', top: '20%', left: '40%', width: 96, height: 96, bgcolor: 'white', opacity: 0.1, borderRadius: '50%', filter: 'blur(32px)' }} />
        <Box sx={{ position: 'absolute', bottom: '5%', left: '45%', width: 120, height: 120, bgcolor: 'white', opacity: 0.15, borderRadius: '50%', filter: 'blur(32px)' }} />
      </Box>
      {/* Main content */}
      <Box sx={{ position: 'relative', zIndex: 1, textAlign: 'center', px: 2, maxWidth: 900, mx: 'auto' }}>
        {/* Greeting */}
        <Stack direction="row" justifyContent="center" mb={3} spacing={2}>
          {lang === 'de' && (
            <Typography variant="body1" sx={{ px: 2, py: 1, bgcolor: 'primary.light', color: 'primary.main', borderRadius: 8, fontWeight: 500, fontSize: 16, boxShadow: 1 }}>
              Schön, dass du da bist!
            </Typography>
          )}
          {lang === 'en' && (
            <Typography variant="body1" sx={{ px: 2, py: 1, bgcolor: 'primary.light', color: 'primary.main', borderRadius: 8, fontWeight: 500, fontSize: 16, boxShadow: 1 }}>
              Welcome, glad to have you here!
            </Typography>
          )}
        </Stack>
        {/* Animated claim */}
        <Box mb={6}>
          <Typography
            ref={claimRef}
            id="animated-claim"
            variant="h2"
            sx={{
              fontWeight: 700,
              fontSize: { xs: '2rem', md: '3rem' },
              color: 'text.primary',
              transition: 'all 0.5s',
            }}
          >
            {claims[lang][claimIndex]}
          </Typography>
        </Box>
        {/* Call to action or avatar could go here */}
      </Box>
    </Box>
  );
};

export default Hero; 