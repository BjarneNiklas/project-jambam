import React, { useEffect, useRef } from 'react';
import './StarsBackground.css';

interface Star {
  id: number;
  x: number;
  y: number;
  size: number;
  opacity: number;
  twinkleSpeed: number;
  twinkleOffset: number;
  color: string;
}

const StarsBackground: React.FC = () => {
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const starsRef = useRef<Star[]>([]);
  const animationRef = useRef<number>();

  const starColors = ['#FFFFFF', '#FFFFAA', '#FFDDAA', '#AABBFF', '#FFF0F5'];

  const drawStar = (ctx: CanvasRenderingContext2D, star: Star, currentOpacity: number) => {
    ctx.beginPath();
    ctx.arc(star.x, star.y, star.size, 0, Math.PI * 2, false);
    ctx.fillStyle = `rgba(${hexToRgb(star.color)}, ${currentOpacity})`;
    ctx.fill();
  };

  const hexToRgb = (hex: string): string => {
    let r = '0', g = '0', b = '0';
    if (hex.length === 4) { // #RGB
      r = "0x" + hex[1] + hex[1];
      g = "0x" + hex[2] + hex[2];
      b = "0x" + hex[3] + hex[3];
    } else if (hex.length === 7) { // #RRGGBB
      r = "0x" + hex[1] + hex[2];
      g = "0x" + hex[3] + hex[4];
      b = "0x" + hex[5] + hex[6];
    }
    return `${+r},${+g},${+b}`;
  };


  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    if (!ctx) return;

    const DESKTOP_BREAKPOINT_ST = 1024;
    const MAX_CONTENT_WIDTH_ST = 1200;

    const setCanvasDimensions = () => {
      canvas.width = window.innerWidth;
      canvas.height = window.innerHeight;
    };

    const generateStars = () => {
      starsRef.current = [];
      const isDesktop = canvas.width >= DESKTOP_BREAKPOINT_ST;
      const contentRenderWidth = Math.min(canvas.width, MAX_CONTENT_WIDTH_ST);
      const peripheralZoneWidth = (canvas.width - contentRenderWidth) / 2;

      // Adjust density: fewer stars for peripheral display, or more concentrated there
      const starDensityFactor = isDesktop && peripheralZoneWidth > 0 ? 3000 : 5000;
      const starCount = Math.floor((canvas.width * canvas.height) / starDensityFactor);

      for (let i = 0; i < starCount; i++) {
        let x;
        if (isDesktop && peripheralZoneWidth > 0) {
          if (Math.random() < 0.5) { // Left peripheral
            x = Math.random() * peripheralZoneWidth;
          } else { // Right peripheral
            x = canvas.width - peripheralZoneWidth + Math.random() * peripheralZoneWidth;
          }
        } else { // Mobile or full-width desktop
          x = Math.random() * canvas.width;
        }
        starsRef.current.push({
          id: i,
          x: x,
          y: Math.random() * canvas.height,
          size: Math.random() * 1.5 + 0.5,
          opacity: Math.random() * 0.6 + 0.4, // Slightly brighter stars
          twinkleSpeed: Math.random() * 0.015 + 0.003, // Slower twinkle
          twinkleOffset: Math.random() * Math.PI * 2,
          color: starColors[Math.floor(Math.random() * starColors.length)],
        });
      }
    };

    const handleResize = () => {
        setCanvasDimensions();
        generateStars();
    };

    setCanvasDimensions();
    generateStars();
    window.addEventListener('resize', handleResize);

    const animate = (time: number) => {
      if (!ctx) return; // Ensure context is still valid
      ctx.clearRect(0, 0, canvas.width, canvas.height);

      starsRef.current.forEach(star => {
        const currentOpacity = star.opacity * (0.6 + 0.4 * Math.sin(star.twinkleOffset + time * star.twinkleSpeed));
        drawStar(ctx, star, currentOpacity);
      });

      animationRef.current = requestAnimationFrame(animate);
    };

    animationRef.current = requestAnimationFrame(animate);

    return () => {
      window.removeEventListener('resize', handleResize);
      if (animationRef.current) {
        cancelAnimationFrame(animationRef.current);
      }
    };
  }, [starColors, drawStar]); // Added dependencies

  return <canvas ref={canvasRef} className="stars-background" />;
};

export default StarsBackground;
