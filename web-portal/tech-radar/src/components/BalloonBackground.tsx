import React, { useEffect, useRef, useCallback } from 'react';
import './BalloonBackground.css';

interface Balloon {
  id: number;
  x: number;
  y: number;
  size: number;
  speed: number;
  color: string;
  sway: number;
  swaySpeed: number;
  swayAmplitude: number;
}

const DESKTOP_BREAKPOINT = 1024; // px
const MAX_CONTENT_WIDTH = 1200; // px

const BalloonBackground: React.FC = () => {
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const balloonsRef = useRef<Balloon[]>([]);
  const animationRef = useRef<number>();

  const colors = [
    '#ef4444', '#3b82f6', '#10b981', '#f59e0b', '#ec4899', '#8b5cf6',
  ];

  const drawBalloon = useCallback((ctx: CanvasRenderingContext2D, balloon: Balloon) => {
    const { x, y, size, color } = balloon;
    
    ctx.beginPath();
    ctx.ellipse(x, y, size, size * 1.2, 0, 0, Math.PI * 2);
    ctx.fillStyle = color;
    ctx.fill();

    ctx.beginPath();
    ctx.ellipse(x - size * 0.3, y - size * 0.4, size * 0.3, size * 0.5, -Math.PI / 4, 0, Math.PI * 2);
    ctx.fillStyle = 'rgba(255, 255, 255, 0.4)';
    ctx.fill();

    ctx.beginPath();
    ctx.moveTo(x - size * 0.1, y + size * 1.2);
    ctx.lineTo(x + size * 0.1, y + size * 1.2);
    ctx.lineTo(x, y + size * 1.2 + 5);
    ctx.closePath();
    ctx.fillStyle = color;
    ctx.fill();
    
    ctx.beginPath();
    ctx.moveTo(x, y + size * 1.2 + 5);
    ctx.lineTo(x + Math.sin(y / 50) * 5, y + size * 1.2 + 45); // String sway
    ctx.strokeStyle = '#a1a1aa';
    ctx.lineWidth = 1;
    ctx.stroke();
  }, []);
  
  const generateBalloon = useCallback((canvasWidth: number, canvasHeight: number, isDesktopPeripheral: boolean): Balloon => {
    let x;
    const contentWidth = Math.min(canvasWidth, MAX_CONTENT_WIDTH);
    const peripheralWidth = (canvasWidth - contentWidth) / 2;

    if (isDesktopPeripheral && canvasWidth > DESKTOP_BREAKPOINT) {
      if (Math.random() < 0.5) { // Left side
        x = Math.random() * peripheralWidth;
      } else { // Right side
        x = canvasWidth - peripheralWidth + Math.random() * peripheralWidth;
      }
    } else {
      x = Math.random() * canvasWidth;
    }

    return {
      id: Math.random(),
      x,
      y: canvasHeight + Math.random() * canvasHeight * 0.5 + 50, // Start further down
      size: Math.random() * 8 + 12, // Slightly smaller max size: 12 to 20
      speed: Math.random() * 0.4 + 0.2, // Slightly slower: 0.2 to 0.6
      color: colors[Math.floor(Math.random() * colors.length)],
      sway: Math.random() * Math.PI,
      swaySpeed: Math.random() * 0.008 + 0.003, // Slower sway
      swayAmplitude: Math.random() * 15 + 8, // Smaller sway amplitude
    };
  }, [colors]);

  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    if (!ctx) return;

    const setCanvasDimensions = () => {
      canvas.width = window.innerWidth;
      canvas.height = window.innerHeight;
    };

    const regenerateBalloons = () => {
        const isDesktop = window.innerWidth >= DESKTOP_BREAKPOINT;
        // Adjust density based on screen type
        const balloonDensityFactor = isDesktop ? 200 : 120; // More sparse on desktop peripherals
        const balloonCount = Math.floor(window.innerWidth / balloonDensityFactor);

        balloonsRef.current = [];
        for (let i = 0; i < balloonCount; i++) {
            balloonsRef.current.push(generateBalloon(canvas.width, canvas.height, isDesktop));
        }
    };

    const handleResize = () => {
        setCanvasDimensions();
        regenerateBalloons();
    };

    setCanvasDimensions();
    regenerateBalloons();
    window.addEventListener('resize', handleResize);

    const animate = () => {
      ctx.clearRect(0, 0, canvas.width, canvas.height);

      const isDesktop = window.innerWidth >= DESKTOP_BREAKPOINT;
      const contentWidth = Math.min(canvas.width, MAX_CONTENT_WIDTH);
      const peripheralWidth = (canvas.width - contentWidth) / 2;
      const leftPeripheralBoundary = peripheralWidth;
      const rightPeripheralBoundary = canvas.width - peripheralWidth;

      balloonsRef.current.forEach((balloon, index) => {
        balloon.y -= balloon.speed;
        balloon.sway += balloon.swaySpeed;
        let currentSway = Math.sin(balloon.sway) * (balloon.swayAmplitude / 100);
        balloon.x += currentSway;

        drawBalloon(ctx, balloon);

        if (balloon.y < -balloon.size * 2.5) { // Reset when well off-screen
          const newBalloon = generateBalloon(canvas.width, canvas.height, isDesktop);
          balloonsRef.current[index] = { ...newBalloon, id: balloon.id }; // Preserve ID for key if needed
        } else if (isDesktop) {
            // Prevent balloons from drifting into the center content area too much
            if (balloon.x - balloon.size < leftPeripheralBoundary && balloon.x + balloon.size > leftPeripheralBoundary && currentSway > 0) { // Moving right into center from left
                 balloon.x = leftPeripheralBoundary - balloon.size - Math.random() * 5; // Push back
                 balloon.sway += Math.PI /2; // Change sway direction
            } else if (balloon.x + balloon.size > rightPeripheralBoundary && balloon.x - balloon.size < rightPeripheralBoundary && currentSway < 0) { // Moving left into center from right
                 balloon.x = rightPeripheralBoundary + balloon.size + Math.random() * 5; // Push back
                 balloon.sway += Math.PI /2; // Change sway direction
            }
        }
      });

      animationRef.current = requestAnimationFrame(animate);
    };

    animate();

    return () => {
      window.removeEventListener('resize', handleResize);
      if (animationRef.current) {
        cancelAnimationFrame(animationRef.current);
      }
    };
  }, [drawBalloon, generateBalloon]); // Added dependencies

  return <canvas ref={canvasRef} className="balloon-background" />;
};

export default BalloonBackground; 