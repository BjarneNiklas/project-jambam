'use client';

import React, { useEffect, useRef, useState } from 'react';
import { Box, Typography } from '@mui/material';
import KeyboardArrowDownIcon from '@mui/icons-material/KeyboardArrowDown';
import { keyframes } from '@mui/system';
import { useLanguage } from '../app/LanguageContext';
import IconButton from '@mui/material/IconButton';
import VisibilityIcon from '@mui/icons-material/Visibility';
import VisibilityOffIcon from '@mui/icons-material/VisibilityOff';

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

// Keyframes für die Bounce-Animation
const bounce = keyframes`
  0%, 20%, 50%, 80%, 100% {
    transform: translateY(0);
  }
  40% {
    transform: translateY(-15px);
  }
  60% {
    transform: translateY(-10px);
  }
`;

// Hilfsfunktion für Textbreite
function getTextWidth(text, font) {
  if (typeof window === 'undefined') return 80;
  const canvas = document.createElement('canvas');
  const ctx = canvas.getContext('2d');
  ctx.font = font;
  return ctx.measureText(text).width;
}

const Hero: React.FC = () => {
  const { lang } = useLanguage();
  const [claimIndex, setClaimIndex] = useState(0);
  const claimRef = useRef<HTMLSpanElement>(null);
  const [showScrollIcon, setShowScrollIcon] = useState(true);

  useEffect(() => {
    const handleScroll = () => {
      if (window.scrollY > 50) {
        setShowScrollIcon(false);
      } else {
        setShowScrollIcon(true);
      }
    };
    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  useEffect(() => {
    if (!claimRef.current) return;
    claimRef.current.classList.add('fade-out');
    const timeout = setTimeout(() => {
      if (claimRef.current) {
        claimRef.current.textContent = claims[lang][claimIndex];
        claimRef.current.classList.remove('fade-out');
      }
    }, 500);
    return () => clearTimeout(timeout);
  }, [claimIndex, lang]);

  useEffect(() => {
    const interval = setInterval(() => {
      setClaimIndex((prev) => (prev + 1) % claims[lang].length);
    }, 3500);
    return () => clearInterval(interval);
  }, [lang]);

  const isMobile = typeof window !== 'undefined' && window.innerWidth < 600;
  const svgMaxWidth = isMobile ? '90vw' : '95vw';
  const svgMaxHeight = isMobile ? '70vh' : '80vh';
  const labelFontSize = isMobile ? 36 : 32;
  const ellipseRy = isMobile ? 28 : 36;
  const labelFont = `bold ${labelFontSize}px Inter, Arial, sans-serif`;
  const leftX = isMobile ? 220 : 100;
  const rightX = isMobile ? 780 : 900;
  const topY = isMobile ? 220 : 100;
  const bottomY = isMobile ? 780 : 900;
  const midY = isMobile ? 540 : 580;

  // Hexagon-Ecken zentral definieren (wiederhergestellt):
  const hexCoords = [
    { cx: 500, cy: 120, label: 'Game Engineering', color: '#AF52DE' },
    { cx: 870, cy: 300, label: 'API Integration', color: '#007AFF' },
    { cx: 870, cy: 700, label: 'Social Learning', color: '#32D6FF' },
    { cx: 500, cy: 880, label: 'Innovation Research', color: '#34C759' },
    { cx: 130, cy: 700, label: 'Mobile Co-Creation', color: '#FF3B30' },
    { cx: 130, cy: 300, label: 'AI Development', color: '#FF9500' },
  ];

  return (
    <>
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
        {/* Animated background bleibt wie gehabt */}
        <Box sx={{ position: 'absolute', inset: 0, zIndex: 0, backgroundColor: 'transparent' }}>
          {/* Aura-Effekt im Hintergrund */}
          <Box sx={{
            position: 'absolute',
            top: 0,
            left: 0,
            right: 0,
            height: '120vh',
            zIndex: 1,
            overflow: 'hidden',
            backgroundColor: 'transparent',
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
          {/* Hexagon im Vordergrund vom Aura-Effekt */}
          <Box sx={{
            position: 'absolute',
            top: '50%',
            left: '50%',
            transform: 'translate(-50%, -50%)',
            zIndex: 2,
            width: '100%',
            height: '100%',
            maxWidth: '95vw',
            maxHeight: '80vh',
            minWidth: 0,
            minHeight: 0,
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
                maxWidth: svgMaxWidth,
                maxHeight: svgMaxHeight,
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
                points={hexCoords.map(pt => `${pt.cx},${pt.cy}`).join(' ')}
                fill="#111"
              />
              {/* Hexagon-Linien mit korrektem Farbverlauf (jetzt garantiert vor dem Hexagon) */}
              {/* Oben rechts nach unten: blau → grün (jetzt blau → blau) */}
              <line x1={hexCoords[1].cx} y1={hexCoords[1].cy} x2={hexCoords[3].cx} y2={hexCoords[3].cy} stroke="url(#hex-blau-gruen)" strokeWidth="11" opacity="0.95" strokeLinecap="round" />
              {/* Unten nach oben links: blau → rot */}
              <line x1={hexCoords[3].cx} y1={hexCoords[3].cy} x2={hexCoords[5].cx} y2={hexCoords[5].cy} stroke="url(#hex-gruen-rot)" strokeWidth="11" opacity="0.95" strokeLinecap="round" />
              {/* Die anderen drei Linien entfernt - nur noch die Y-Linien sichtbar */}
              {/* Y-Linien (dünn, mit Glow und Farbverlauf, jetzt garantiert über dem Hexagon) */}
              <line x1="500" y1="580" x2={hexCoords[1].cx} y2={hexCoords[1].cy} stroke="url(#y-gelb-blau)" strokeWidth="7" opacity="0.98" strokeLinecap="round" style={{ filter: 'drop-shadow(0 0 16px #fff700)' }} />
              <line x1="500" y1="580" x2={hexCoords[5].cx} y2={hexCoords[5].cy} stroke="url(#y-gelb-rot)" strokeWidth="7" opacity="0.98" strokeLinecap="round" style={{ filter: 'drop-shadow(0 0 16px #fff700)' }} />
              <line x1="500" y1="580" x2={hexCoords[3].cx} y2={hexCoords[3].cy} stroke="url(#y-gelb-gruen)" strokeWidth="7" opacity="0.98" strokeLinecap="round" style={{ filter: 'drop-shadow(0 0 16px #fff700)' }} />
              {/* Glowy oberer Eckpunkt HINTER dem Hexagon */}
              {/* Keyword texts removed from SVG for a11y and SEO. Will be added as HTML elements. */}
              {hexCoords.map((pt, i) => {
                const rx = getTextWidth(pt.label, labelFont) / 2 + 36;
                return (
                  <g key={i}>
                    <ellipse cx={pt.cx} cy={pt.cy} rx={rx} ry={ellipseRy} fill="#fff" opacity="0.98" style={{ filter: 'drop-shadow(0 0 24px #fff)' }} />
                    <text x={pt.cx} y={pt.cy} textAnchor="middle" dominantBaseline="middle" fill={pt.color} fontWeight="800" fontSize={labelFontSize} style={{ textShadow: '0 2px 8px #fff, 0 0 2px #000' }}>{pt.label}</text>
                  </g>
                );
              })}
              {/* Mittleres Oval wieder einfügen */}
              <>
                <ellipse cx={500} cy={580} rx={getTextWidth('Design Thinking', labelFont) / 2 + 36} ry={ellipseRy} fill="#fff" opacity="0.98" style={{ filter: 'drop-shadow(0 0 24px #fff)' }} />
                <text x={500} y={580} textAnchor="middle" dominantBaseline="middle" fill="#FFD60A" fontWeight="800" fontSize={labelFontSize} style={{ textShadow: '0 2px 8px #fff, 0 0 2px #000' }}>Design Thinking</text>
              </>
            </svg>
            {/* HTML Keyword Texts - Position these absolutely over the SVG */}
            {/* Example for one keyword, others would follow a similar pattern */}
            {/* Positioning requires careful adjustment based on the SVG's viewbox and rendered size */}
            <Box sx={{
              position: 'absolute',
              top: 0, left: 0, width: '100%', height: '100%', // Container for positioning
              pointerEvents: 'none', // So they don't interfere with SVG interactions if any
              zIndex: 3, // Ensure they are above the main SVG elements but below interactive UI like claim
            }}>
            </Box>

            {/* Slogan/Claim auf 75% Höhe des Hexagons */}
            <Box sx={{
              position: 'absolute',
              top: { xs: '48%', sm: '40%', md: '42%' },
              left: '50%',
              transform: 'translate(-50%, -50%)',
              zIndex: 3,
              width: '80%',
              maxWidth: { xs: '98%', sm: '90%' },
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              pointerEvents: 'auto',
            }}>
              <span
                ref={claimRef}
                style={{
                  transition: 'opacity 0.7s',
                  opacity: 1,
                  textShadow: '0 2px 16px #000, 0 0 32px #FFD60A',
                  fontSize: isMobile ? '0.9rem' : '1.1rem',
                  fontWeight: 600,
                  color: 'white',
                }}
              >
                {claims[lang][claimIndex]}
              </span>
            </Box>
          </Box>
        </Box>
        {/* Main content darunter (nur noch minimal, da Buttons in About sind) */}
        <Box sx={{ position: 'relative', zIndex: 4, textAlign: 'center', px: 2, maxWidth: 900, mx: 'auto', mt: { xs: 40, md: 60, lg: 80 } }}>
          {/* CTA Buttons entfernt - sind jetzt im About-Bereich */}
        </Box>
        {/* Scroll Down Indicator */}
        <Box
          sx={{
            position: 'absolute',
            bottom: 32,
            left: '50%',
            transform: 'translateX(-50%)',
            zIndex: 5,
            opacity: showScrollIcon ? 1 : 0,
            transition: 'opacity 0.3s ease-in-out',
          }}
        >
          <KeyboardArrowDownIcon
            sx={{
              fontSize: '3rem',
              color: 'primary.main',
              animation: `${bounce} 2s infinite`,
            }}
          />
        </Box>
      </Box>
    </>
  );
};

export default Hero;