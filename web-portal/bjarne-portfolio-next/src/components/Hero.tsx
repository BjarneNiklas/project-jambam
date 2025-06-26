'use client';

import React, { useEffect, useRef, useState } from 'react';
import { Box, Typography, Stack, useTheme } from '@mui/material';

const claims = {
  de: [
    'Deine Vision? Realisiert!',
    'Ideen mit Spitzentechnologie umsetzen.',
    'Gemeinsam die Zukunft gestalten.'
  ],
  en: [
    'Your vision? Realized!',
    'Realizing ideas with cutting-edge technology.',
    'Shaping the future together.'
  ]
};

const Hero: React.FC = () => {
  const [lang, setLang] = useState<'de' | 'en'>('de');
  const [claimIndex, setClaimIndex] = useState(0);
  const claimRef = useRef<HTMLDivElement>(null);
  const theme = useTheme();

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
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        overflow: 'hidden',
        backgroundColor: 'transparent',
        margin: 0,
        padding: 0,
      }}
    >
      {/* Animated background */}
      <Box sx={{ position: 'absolute', inset: 0, zIndex: 0, backgroundColor: 'transparent' }}>
        {/* Aura-Effekt nur oben beim Hexagon - eingeschränkt auf oberen Bereich */}
        <Box sx={{
          position: 'absolute',
          top: 0,
          left: 0,
          right: 0,
          height: '120vh',
          zIndex: 1,
          overflow: 'hidden',
          backgroundColor: 'transparent', // Explicitly set to transparent
        }}>
          <div className="animate-aurav-outer" style={{
            height: '100%',
            background: 'radial-gradient(circle at 50% 30%, #FFFBE0 0%, #FFD60A 17%, #FFD60A 43%, #FF9500 58%, #FF3B30 73%, #007AFF 88%, transparent 98%)'
          }} />
          <div className="animate-aurav-core" style={{
            height: '100%',
            background: 'radial-gradient(circle at 50% 30%, #FFD60A 0%, #FFD60A 33%, #FF9500 48%, #FF3B30 68%, #007AFF 83%, transparent 93%)'
          }} />
        </Box>

        {/* Hexagon mit Strahlen wieder zentriert */}
        <Box sx={{
          position: 'absolute',
          top: '50%',
          left: '50%',
          transform: 'translate(-50%, -50%)',
          zIndex: 3,
          width: { xs: 700, md: 950 },
          height: { xs: 700, md: 950 },
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          pointerEvents: 'none',
        }}>
          <svg
            width="100%"
            height="100%"
            viewBox="0 0 1000 1000"
            fill="none"
            xmlns="http://www.w3.org/2000/svg"
            className="hexagon-hero-anim"
            style={{
              filter: 'drop-shadow(0 0 80px #ffe066)',
              transform: 'perspective(1200px) rotateX(18deg) rotateY(-12deg)',
              transition: 'filter 0.5s, transform 1.2s cubic-bezier(.4,2,.6,1)',
            }}
          >
            <defs>
              <linearGradient id="hex-rot-blau" x1="150" y1="325" x2="850" y2="325" gradientUnits="userSpaceOnUse">
                <stop offset="0%" stopColor="#ff3b3b" />
                <stop offset="100%" stopColor="#00eaff" />
              </linearGradient>
              <linearGradient id="hex-blau-gruen" x1="850" y1="325" x2="500" y2="850" gradientUnits="userSpaceOnUse">
                <stop offset="0%" stopColor="#007AFF" />
                <stop offset="100%" stopColor="#34C759" />
              </linearGradient>
              <linearGradient id="hex-gruen-rot" x1="500" y1="850" x2="150" y2="325" gradientUnits="userSpaceOnUse">
                <stop offset="0%" stopColor="#34C759" />
                <stop offset="100%" stopColor="#FF3B30" />
              </linearGradient>
              <linearGradient id="hex-rot-blau2" x1="150" y1="325" x2="150" y2="675" gradientUnits="userSpaceOnUse">
                <stop offset="0%" stopColor="#ff3b3b" />
                <stop offset="100%" stopColor="#00eaff" />
              </linearGradient>
              <linearGradient id="hex-blau-gruen2" x1="500" y1="150" x2="850" y2="325" gradientUnits="userSpaceOnUse">
                <stop offset="0%" stopColor="#00eaff" />
                <stop offset="100%" stopColor="#00ff99" />
              </linearGradient>
              <linearGradient id="hex-gruen-rot2" x1="850" y1="675" x2="500" y2="850" gradientUnits="userSpaceOnUse">
                <stop offset="0%" stopColor="#00ff99" />
                <stop offset="100%" stopColor="#ff3b3b" />
              </linearGradient>
              <linearGradient id="y-gelb-blau" x1="500" y1="580" x2="850" y2="325" gradientUnits="userSpaceOnUse">
                <stop offset="0%" stopColor="#FFD60A" />
                <stop offset="100%" stopColor="#007AFF" />
              </linearGradient>
              <linearGradient id="y-gelb-rot" x1="500" y1="580" x2="150" y2="325" gradientUnits="userSpaceOnUse">
                <stop offset="0%" stopColor="#FF9500" />
                <stop offset="100%" stopColor="#FF3B30" />
              </linearGradient>
              <linearGradient id="y-gelb-gruen" x1="500" y1="580" x2="500" y2="850" gradientUnits="userSpaceOnUse">
                <stop offset="0%" stopColor="#FFD60A" />
                <stop offset="100%" stopColor="#34C759" />
              </linearGradient>
              <linearGradient id="hex-gelb-orange" x1="150" y1="675" x2="500" y2="580" gradientUnits="userSpaceOnUse">
                <stop offset="0%" stopColor="#FFD60A" />
                <stop offset="100%" stopColor="#FF9500" />
              </linearGradient>
              <linearGradient id="hex-tuerkis-blau" x1="850" y1="675" x2="500" y2="580" gradientUnits="userSpaceOnUse">
                <stop offset="0%" stopColor="#32D6FF" />
                <stop offset="100%" stopColor="#007AFF" />
              </linearGradient>
              <linearGradient id="hex-violett-blau" x1="500" y1="150" x2="850" y2="325" gradientUnits="userSpaceOnUse">
                <stop offset="0%" stopColor="#AF52DE" />
                <stop offset="100%" stopColor="#007AFF" />
              </linearGradient>
            </defs>
            {/* Schwarzes Hexagon als Füllung */}
            <polygon
              points="500,150 850,325 850,675 500,850 150,675 150,325"
              fill="#111"
            />
            {/* Hexagon-Linien mit korrektem Farbverlauf (jetzt garantiert vor dem Hexagon) */}
            {/* Oben rechts nach unten: blau → grün (jetzt blau → blau) */}
            <line x1="850" y1="325" x2="500" y2="850" stroke="url(#hex-blau-gruen)" strokeWidth="11" opacity="0.95" strokeLinecap="round" />
            {/* Unten nach oben links: blau → rot */}
            <line x1="500" y1="850" x2="150" y2="325" stroke="url(#hex-gruen-rot)" strokeWidth="11" opacity="0.95" strokeLinecap="round" />
            {/* Die anderen drei Linien entfernt - nur noch die Y-Linien sichtbar */}
            {/* Y-Linien (dünn, mit Glow und Farbverlauf, jetzt garantiert über dem Hexagon) */}
            <line x1="500" y1="580" x2="850" y2="325" stroke="url(#y-gelb-blau)" strokeWidth="7" opacity="0.98" strokeLinecap="round" style={{ filter: 'drop-shadow(0 0 16px #fff700)' }} />
            <line x1="500" y1="580" x2="150" y2="325" stroke="url(#y-gelb-rot)" strokeWidth="7" opacity="0.98" strokeLinecap="round" style={{ filter: 'drop-shadow(0 0 16px #fff700)' }} />
            <line x1="500" y1="580" x2="500" y2="850" stroke="url(#y-gelb-gruen)" strokeWidth="7" opacity="0.98" strokeLinecap="round" style={{ filter: 'drop-shadow(0 0 16px #fff700)' }} />
            {/* 5 glowy Eckpunkte VOR dem Hexagon */}
            {[
              [850,325], [850,675], [500,850], [150,675], [150,325]
            ].map(([x, y], i) => (
              <ellipse
                key={i}
                cx={x}
                cy={y}
                rx="110"
                ry="44"
                fill="#fff"
                opacity="0.95"
                style={{ filter: 'drop-shadow(0 0 48px #00eaff)' }}
                className="hex-corner-glow"
              />
            ))}
            {/* Glowy oberer Eckpunkt HINTER dem Hexagon */}
            <ellipse
              cx={500}
              cy={150}
              rx="110"
              ry="44"
              fill="#fff"
              opacity="0.95"
              style={{ filter: 'drop-shadow(0 0 48px #00eaff)' }}
              className="hex-corner-glow"
            />
            {/* Leuchtender Mittelpunkt */}
            <ellipse cx="500" cy="580" rx="125" ry="48" fill="#fff" opacity="0.98" style={{ filter: 'drop-shadow(0 0 64px #fff700)' }} />
            
            {/* Bubble Keywords - Text IN den Bubbles mit perfekten Rainbow-Farben */}
            {/* 1. Zentrale Bubble - Design Thinking */}
            <text
              x="500"
              y="580"
              textAnchor="middle"
              dominantBaseline="middle"
              fill="#FFD60A"
              fontSize="30"
              fontWeight="700"
              opacity="0.95"
            >
              <tspan x="500" dy="-18">Design</tspan>
              <tspan x="500" dy="36">Thinking</tspan>
            </text>
            
            {/* 2. Oben Links - AI Development */}
            <text
              x="150"
              y="325"
              textAnchor="middle"
              dominantBaseline="middle"
              fill="#FF3B30"
              fontSize="27"
              fontWeight="700"
              opacity="0.95"
            >
              <tspan x="150" dy="-14">AI</tspan>
              <tspan x="150" dy="28">Development</tspan>
            </text>
            
            {/* 3. Oben Rechts - API Integration */}
            <text
              x="850"
              y="325"
              textAnchor="middle"
              dominantBaseline="middle"
              fill="#007AFF"
              fontSize="27"
              fontWeight="700"
              opacity="0.95"
            >
              <tspan x="850" dy="-14">API</tspan>
              <tspan x="850" dy="28">Integration</tspan>
            </text>
            
            {/* 4. Unten - Innovation Research */}
            <text
              x="500"
              y="850"
              textAnchor="middle"
              dominantBaseline="middle"
              fill="#34C759"
              fontSize="27"
              fontWeight="700"
              opacity="0.95"
            >
              <tspan x="500" dy="-14">Innovation</tspan>
              <tspan x="500" dy="28">Research</tspan>
            </text>
            
            {/* 5. Oben - Game Engineering */}
            <text
              x="500"
              y="150"
              textAnchor="middle"
              dominantBaseline="middle"
              fill="#AF52DE"
              fontSize="27"
              fontWeight="700"
              opacity="0.95"
            >
              <tspan x="500" dy="-14">Game</tspan>
              <tspan x="500" dy="28">Engineering</tspan>
            </text>
            
            {/* 6. Links Unten - Mobile Co-Creation */}
            <text
              x="150"
              y="675"
              textAnchor="middle"
              dominantBaseline="middle"
              fill="#FF9500"
              fontSize="24"
              fontWeight="700"
              opacity="0.95"
            >
              <tspan x="150" dy="-12">Mobile</tspan>
              <tspan x="150" dy="24">Co-Creation</tspan>
            </text>
            
            {/* 7. Rechts Unten - Social Learning */}
            <text
              x="850"
              y="675"
              textAnchor="middle"
              dominantBaseline="middle"
              fill="#32D6FF"
              fontSize="24"
              fontWeight="700"
              opacity="0.95"
            >
              <tspan x="850" dy="-12">Social</tspan>
              <tspan x="850" dy="24">Learning</tspan>
            </text>
          </svg>
        </Box>
      </Box>
      {/* Main content */}
      <Box sx={{ position: 'relative', zIndex: 1, textAlign: 'center', px: 2, maxWidth: 900, mx: 'auto' }}>
        {/* Slogan Switcher */}
        <Box sx={{ position: 'absolute', top: -160, left: '50%', transform: 'translateX(-50%)', zIndex: 2 }}>
          <button
            style={{
              padding: '10px 24px',
              borderRadius: 8,
              border: 'none',
              background: theme.palette.primary.light,
              color: '#fff',
              fontWeight: 600,
              fontSize: 18,
              boxShadow: '0 2px 8px rgba(0,0,0,0.08)',
              cursor: 'pointer',
              transition: 'background 0.2s',
            }}
            onClick={() => setClaimIndex((prev) => (prev + 1) % claims[lang].length)}
            aria-label="Slogan wechseln"
          >
            {claims[lang][claimIndex]}
          </button>
        </Box>
        {/* Animated claim */}
        {/* Slogan-Text entfernt, Slogan ist nur noch im Button sichtbar */}
      </Box>
    </Box>
  );
};

export default Hero;