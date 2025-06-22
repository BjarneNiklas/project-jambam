/** @jsxImportSource @emotion/react */
import React, { useState, useEffect, useRef } from 'react';
import { css, keyframes } from '@emotion/react';

// --- CONFIG & COLORS ---
const hexSize = 100, strokeWidth = 5;
const petrol = '#0b4f6c', accent = '#145b78', teal = '#00d4aa';
const seedBrown = '#a16207', seedGold = '#d97706';
const saplingGreen = '#22c55e', treeTrunk = '#8B4513';
const fireRed = '#ef4444', fireOrange = '#f97316', fireYellow = '#fde047';
const C = { C1: '#ef4444', C2: '#f97316', C3: '#fde047', C4: '#22c55e', C5: '#3b82f6', C6: '#a855f7' };

// --- KEYFRAMES ---
const rotate = keyframes`from{transform:rotate(0deg)}to{transform:rotate(360deg)}`;
const lightningGlow = keyframes`0%,100%{filter:drop-shadow(0 0 8px ${teal});opacity:.9}50%{filter:drop-shadow(0 0 18px ${teal});opacity:1}`;
const seedFall = keyframes`0%{opacity:0;transform:translateY(-10px)}80%{opacity:1;transform:translateY(0)}100%{opacity:1}`;
const grow = keyframes`from{transform:scale(0);opacity:0}to{transform:scale(1);opacity:1}`;
const lightningStrike = keyframes`0%{opacity:0}30%{opacity:1;filter:drop-shadow(0 0 25px #fff)}100%{opacity:0}`;
const fireFlicker = keyframes`0%,100%{transform:scale(1) rotate(0);opacity:.9}50%{transform:scale(1.1) rotate(1deg);opacity:1}`;
const screenShake = keyframes`0%,100%{transform:translateX(0)}10%,30%,50%,70%,90%{transform:translateX(-2px)}20%,40%,60%,80%{transform:translateX(2px)}`;
const sparkFly = keyframes`0%{opacity:1;transform:translate(0,0) scale(1)}100%{opacity:0;transform:translate(var(--x-end), -60px) scale(0)}`;
const dustPuff = keyframes`0%{opacity:0.7;transform:scale(0)}100%{opacity:0;transform:scale(1.5)}`;
const fastRotate360 = keyframes`from { transform: rotate(0deg); } to { transform: rotate(360deg); }`;

// --- STYLES ---
const logoStyle = css`
  cursor: pointer; position: relative; transition: transform 0.3s ease; user-select: none;
  &:hover { transform: scale(1.05); }
  &.is-shaking { animation: ${screenShake} 0.3s ease-in-out; }

  .hexagon-rotator { 
    transform-origin: 50px 50px; 
  }
  &.is-animating .hexagon-rotator { animation: ${rotate} 15s linear infinite; }

  .logo-element {
    transform-origin: 50% 80%;
    transition: opacity 0.4s ease-in-out;
    opacity: 0;
    pointer-events: none;
  }
  
  &.phase-lightning .lightning-bolt { 
    opacity: 1; 
    animation: ${lightningGlow} 3s ease-in-out infinite; 
  }
  &:hover .lightning-bolt { animation-duration: 1.5s; }
  
  &.phase-seed {
    .seed { opacity: 1; animation: ${seedFall} 0.5s ease-out forwards; }
    .dust { opacity: 1; animation: ${dustPuff} 0.6s ease-out; }
  }
  
  &.phase-sapling .sapling { opacity: 1; animation: ${grow} 1s ease-out forwards; }
  
  &.phase-tree .tree { opacity: 1; }
  
  &.phase-strike {
    .strike-bolt { opacity: 1; animation: ${lightningStrike} 0.4s ease-out forwards; }
    .hexagon-rotator { animation: ${fastRotate360} 0.8s ease-out; }
  }
  
  &.phase-burning {
    .tree { opacity: 1; }
    .fire { opacity: 1; animation: ${fireFlicker} 0.15s linear infinite; }
    .spark { opacity: 1; animation: ${sparkFly} 1.5s ease-out forwards; }
  }
`;

// --- COMPONENT ---
type AnimationPhase = 'lightning' | 'seed' | 'sapling' | 'tree' | 'strike' | 'burning';

const useAudio = (src: string) => {
  const audioRef = useRef<HTMLAudioElement | null>(null);
  useEffect(() => {
    audioRef.current = new Audio(src);
    audioRef.current.volume = 0.3;
  }, [src]);
  return () => {
    audioRef.current?.play().catch(e => console.error("Audio play failed:", e));
  };
};

const LogoHexSpark: React.FC<{ className?: string; onClick?: () => void }> = ({ className, onClick }) => {
  const [phase, setPhase] = useState<AnimationPhase>('lightning');
  const [isShaking, setIsShaking] = useState(false);

  // --- SOUNDS (add sound files to /public/sounds/) ---
  const playStrikeSound = useAudio('/sounds/strike.mp3');
  const playFireSound = useAudio('/sounds/fire.mp3');
  const playGrowSound = useAudio('/sounds/grow.mp3');
  const playSeedSound = useAudio('/sounds/seed.mp3');

  useEffect(() => {
    let timers: NodeJS.Timeout[] = [];
    
    if (phase === 'seed') { 
      playSeedSound(); 
      timers.push(setTimeout(() => setPhase('sapling'), 900));
    }
    else if (phase === 'sapling') { 
      playGrowSound(); 
      timers.push(setTimeout(() => setPhase('tree'), 1800));
    }
    else if (phase === 'tree') { 
      timers.push(setTimeout(() => setPhase('strike'), 3000));
    }
    else if (phase === 'strike') {
      playStrikeSound();
      setIsShaking(true);
      timers.push(setTimeout(() => setPhase('burning'), 200));
      timers.push(setTimeout(() => setIsShaking(false), 300));
    }
    else if (phase === 'burning') { 
      playFireSound(); 
      timers.push(setTimeout(() => setPhase('lightning'), 1200));
    }
    
    return () => timers.forEach(clearTimeout);
  }, [phase, playFireSound, playGrowSound, playSeedSound, playStrikeSound]);

  const handleClick = () => {
    if (phase === 'lightning') setPhase('seed');
    onClick?.();
  };

  return (
    <div className={`${className} phase-${phase} ${phase !== 'lightning' ? 'is-animating' : ''} ${isShaking ? 'is-shaking' : ''}`} css={logoStyle} onClick={handleClick}>
      <svg viewBox={`-15 -15 ${hexSize + 30} ${hexSize + 30}`} width={hexSize} height={hexSize}>
        <defs>
          <linearGradient id="hexagonFillGradient" x1="0" y1="0" x2="1" y2="1"><stop offset="0%" stopColor={accent} /><stop offset="100%" stopColor={petrol} /></linearGradient>
          
          {/* Gradients for each side of the hexagon for a seamless rainbow effect */}
          <linearGradient id="grad1" x1="50" y1="1" x2="95" y2="25" gradientUnits="userSpaceOnUse"><stop stopColor={C.C1} /><stop offset="1" stopColor={C.C2} /></linearGradient>
          <linearGradient id="grad2" x1="95" y1="25" x2="95" y2="75" gradientUnits="userSpaceOnUse"><stop stopColor={C.C2} /><stop offset="1" stopColor={C.C3} /></linearGradient>
          <linearGradient id="grad3" x1="95" y1="75" x2="50" y2="99" gradientUnits="userSpaceOnUse"><stop stopColor={C.C3} /><stop offset="1" stopColor={C.C4} /></linearGradient>
          <linearGradient id="grad4" x1="50" y1="99" x2="5" y2="75" gradientUnits="userSpaceOnUse"><stop stopColor={C.C4} /><stop offset="1" stopColor={C.C5} /></linearGradient>
          <linearGradient id="grad5" x1="5" y1="75" x2="5" y2="25" gradientUnits="userSpaceOnUse"><stop stopColor={C.C5} /><stop offset="1" stopColor={C.C6} /></linearGradient>
          <linearGradient id="grad6" x1="5" y1="25" x2="50" y2="1" gradientUnits="userSpaceOnUse"><stop stopColor={C.C6} /><stop offset="1" stopColor={C.C1} /></linearGradient>
        </defs>

        <g className="hexagon-rotator">
            {/* The background fill */}
            <polygon points="50,1 95,25 95,75 50,99 5,75 5,25" fill="url(#hexagonFillGradient)" stroke="none" />
            
            {/* The rainbow border, composed of 6 paths with individual gradients */}
            <path d="M 50 1 L 95 25" stroke="url(#grad1)" strokeWidth={strokeWidth} fill="none" strokeLinecap="round" />
            <path d="M 95 25 L 95 75" stroke="url(#grad2)" strokeWidth={strokeWidth} fill="none" strokeLinecap="round" />
            <path d="M 95 75 L 50 99" stroke="url(#grad3)" strokeWidth={strokeWidth} fill="none" strokeLinecap="round" />
            <path d="M 50 99 L 5 75" stroke="url(#grad4)" strokeWidth={strokeWidth} fill="none" strokeLinecap="round" />
            <path d="M 5 75 L 5 25" stroke="url(#grad5)" strokeWidth={strokeWidth} fill="none" strokeLinecap="round" />
            <path d="M 5 25 L 50 1" stroke="url(#grad6)" strokeWidth={strokeWidth} fill="none" strokeLinecap="round" />
        </g>
        
        {/* All animation elements */}
        <g className="logo-element lightning-bolt"><path d="M56 25 L45 50 L52 50 L46 70 L62 45 L55 45 Z" fill={teal} /></g>
        
        <g className="logo-element seed"><ellipse cx="50" cy="70" rx="5" ry="8" fill={seedBrown} /><ellipse cx="50" cy="68" rx="2.5" ry="4" fill={seedGold} /></g>
        
        {/* Dust puff on land */}
        <g className="logo-element dust">
            {Array.from({ length: 7 }).map((_, i) => (
                <circle key={i} cx="50" cy="20" r="3" fill="#c2b280" style={{ transform: `rotate(${(360 / 7) * i}deg) translateX(0.3px)` }} />
            ))}
        </g>

        <g className="logo-element sapling"><path d="M50 75 V 55" stroke={saplingGreen} strokeWidth="3" /><path d="M50 65 C 40 60, 40 50, 48 50" stroke={saplingGreen} strokeWidth="3" fill="none" /><path d="M50 65 C 60 60, 60 50, 52 50" stroke={saplingGreen} strokeWidth="3" fill="none" /></g>
        <g className="logo-element tree"><rect x="47" y="55" width="6" height="20" fill={treeTrunk} /><circle cx="50" cy="40" r="15" fill={saplingGreen} /><circle cx="42" cy="45" r="10" fill={saplingGreen} /><circle cx="58" cy="45" r="10" fill={saplingGreen} /></g>
        <g className="logo-element strike-bolt"><path d="M56 25 L45 50 L52 50 L46 70 L62 45 L55 45 Z" fill="#fff" /></g>
        
        <g className="logo-element fire">
            <path d="M40 60 Q 50 20, 60 60 Q 50 40, 40 60" fill={fireRed} />
            <path d="M45 60 Q 50 30, 55 60 Q 50 45, 45 60" fill={fireOrange} />
            <path d="M48 60 Q 50 40, 52 60 Q 50 50, 48 60" fill={fireYellow} />
            {/* Sparks */}
            {Array.from({ length: 10 }).map((_, i) => (
                <circle key={i} cx="50" cy="50" r="1.5" fill={fireOrange} className="spark" style={{ '--x-end': `${(Math.random() - 0.5) * 60}px`, animationDelay: `${Math.random() * 0.5}s` } as React.CSSProperties} />
            ))}
        </g>
      </svg>
    </div>
  );
};

export default LogoHexSpark;