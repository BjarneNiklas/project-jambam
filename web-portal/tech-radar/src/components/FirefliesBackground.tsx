import React, { useEffect, useRef } from 'react';
import './FirefliesBackground.css';

interface Firefly {
  id: number;
  x: number;
  y: number;
  size: number;
  vx: number; // velocity x
  vy: number; // velocity y
  opacity: number;
  maxOpacity: number;
  opacitySpeed: number;
  color: string;
  targetX: number; // For more natural movement
  targetY: number; // For more natural movement
  timeToChangeTarget: number;
}

const FirefliesBackground: React.FC = () => {
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const firefliesRef = useRef<Firefly[]>([]);
  const animationRef = useRef<number>();

  const fireflyColors = ['#FFFFE0', '#FFFACD', '#FFEFD5', '#FAFAD2']; // Light yellow/gold hues

  const drawFirefly = (ctx: CanvasRenderingContext2D, firefly: Firefly) => {
    ctx.beginPath();
    // Outer glow
    const glowGradient = ctx.createRadialGradient(firefly.x, firefly.y, firefly.size * 0.5, firefly.x, firefly.y, firefly.size * 2);
    glowGradient.addColorStop(0, `rgba(${hexToRgb(firefly.color)}, ${firefly.opacity * 0.8})`);
    glowGradient.addColorStop(1, `rgba(${hexToRgb(firefly.color)}, 0)`);
    ctx.fillStyle = glowGradient;
    ctx.arc(firefly.x, firefly.y, firefly.size * 2, 0, Math.PI * 2, false);
    ctx.fill();

    // Inner core
    ctx.beginPath();
    ctx.arc(firefly.x, firefly.y, firefly.size, 0, Math.PI * 2, false);
    ctx.fillStyle = `rgba(${hexToRgb(firefly.color)}, ${firefly.opacity})`;
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

    const DESKTOP_BREAKPOINT_FF = 1024;
    const MAX_CONTENT_WIDTH_FF = 1200;

    const setCanvasDimensions = () => {
      canvas.width = window.innerWidth;
      canvas.height = window.innerHeight;
    };

    const createFirefly = (id: number, currentCanvasWidth: number, currentCanvasHeight: number, isDesktop: boolean, peripheralWidth: number): Firefly => {
      const size = Math.random() * 2 + 1;
      let x;

      if (isDesktop && peripheralWidth > 0) {
        if (Math.random() < 0.5) { // Left peripheral
          x = Math.random() * peripheralWidth;
        } else { // Right peripheral
          x = currentCanvasWidth - peripheralWidth + Math.random() * peripheralWidth;
        }
      } else { // Mobile or full-width desktop
        x = Math.random() * currentCanvasWidth;
      }

      const y = Math.random() * currentCanvasHeight;
      return {
        id, x, y, size,
        vx: (Math.random() - 0.5) * 0.3, // Slower base velocity
        vy: (Math.random() - 0.5) * 0.3,
        opacity: 0,
        maxOpacity: Math.random() * 0.6 + 0.2, // Can be a bit brighter
        opacitySpeed: Math.random() * 0.01 + 0.003, // Slower blinking
        color: fireflyColors[Math.floor(Math.random() * fireflyColors.length)],
        targetX: x, // Initial target is current position
        targetY: y,
        timeToChangeTarget: Math.random() * 250 + 150, // Longer time to change target
      };
    };

    const generateFireflies = () => {
      firefliesRef.current = [];
      const isDesktop = canvas.width >= DESKTOP_BREAKPOINT_FF;
      const contentRenderWidth = Math.min(canvas.width, MAX_CONTENT_WIDTH_FF);
      const peripheralZoneWidth = (canvas.width - contentRenderWidth) / 2;

      const densityFactor = isDesktop && peripheralZoneWidth > 0 ? 6000 : 8000; // Adjust density
      const fireflyCount = Math.floor((canvas.width * canvas.height) / densityFactor);

      for (let i = 0; i < fireflyCount; i++) {
        firefliesRef.current.push(createFirefly(i, canvas.width, canvas.height, isDesktop, peripheralZoneWidth));
      }
    };

    const handleResize = () => {
        setCanvasDimensions();
        generateFireflies();
    };

    setCanvasDimensions();
    generateFireflies();
    window.addEventListener('resize', handleResize);

    const animate = () => { // Removed timestamp as it's not used
      if(!ctx) return;
      ctx.clearRect(0, 0, canvas.width, canvas.height);

      const isDesktop = canvas.width >= DESKTOP_BREAKPOINT_FF;
      const contentRenderWidth = Math.min(canvas.width, MAX_CONTENT_WIDTH_FF);
      const peripheralZoneWidth = (canvas.width - contentRenderWidth) / 2;
      const leftPeripheralBoundary = peripheralZoneWidth;
      const rightPeripheralBoundary = canvas.width - peripheralZoneWidth;


      firefliesRef.current.forEach(firefly => {
        firefly.opacity += firefly.opacitySpeed;
        if (firefly.opacity > firefly.maxOpacity || firefly.opacity < 0) {
          firefly.opacitySpeed *= -1;
          firefly.opacity = Math.max(0, Math.min(firefly.opacity, firefly.maxOpacity)); // Clamp
        }

        // Movement towards target
        firefly.timeToChangeTarget--;
        if (firefly.timeToChangeTarget <= 0) {
          firefly.targetX = firefly.x + (Math.random() - 0.5) * 100;
          firefly.targetY = firefly.y + (Math.random() - 0.5) * 100;
          firefly.timeToChangeTarget = Math.random() * 200 + 100; // Reset timer
        }

        const dx = firefly.targetX - firefly.x;
        const dy = firefly.targetY - firefly.y;
        const dist = Math.sqrt(dx * dx + dy * dy);

        if (dist > 1) {
          firefly.vx = (dx / dist) * 0.3; // Adjust speed
          firefly.vy = (dy / dist) * 0.3;
        } else {
          firefly.vx = 0;
          firefly.vy = 0;
        }

        firefly.x += firefly.vx;
        firefly.y += firefly.vy;

        // Boundary check (wrap around)
        if (firefly.x > canvas.width + firefly.size * 2) firefly.x = -firefly.size * 2;
        else if (firefly.x < -firefly.size * 2) firefly.x = canvas.width + firefly.size * 2;
        if (firefly.y > canvas.height + firefly.size * 2) firefly.y = -firefly.size * 2;
        else if (firefly.y < -firefly.size * 2) firefly.y = canvas.height + firefly.size * 2;

        drawFirefly(ctx, firefly);
      });

      animationRef.current = requestAnimationFrame(animate);
    };

    animate(0);

    return () => {
      window.removeEventListener('resize', handleResize);
      if (animationRef.current) {
        cancelAnimationFrame(animationRef.current);
      }
    };
  }, []);

  return <canvas ref={canvasRef} className="fireflies-background" />;
};

export default FirefliesBackground;
