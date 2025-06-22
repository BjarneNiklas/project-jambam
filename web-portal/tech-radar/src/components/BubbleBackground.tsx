import React, { useEffect, useRef, useCallback } from 'react';
import './BubbleBackground.css';

interface Bubble {
  id: number;
  x: number;
  y: number;
  size: number;
  speed: number;
  opacity: number;
  wobble: number;
  wobbleSpeed: number;
  wobbleOffset: number;
  color: string;
  // life and maxLife removed as bubbles are now persistent within viewport
}

interface Particle {
  id: number;
  x: number;
  y: number;
  vx: number;
  vy: number;
  life: number;
  maxLife: number;
  color: string;
  size: number;
}

const hexToRgba = (hex: string, alpha: number): string => {
  const r = parseInt(hex.slice(1, 3), 16);
  const g = parseInt(hex.slice(3, 5), 16);
  const b = parseInt(hex.slice(5, 7), 16);

  if (isNaN(r) || isNaN(g) || isNaN(b)) {
    return `rgba(255, 255, 255, ${alpha})`; // Fallback
  }
  return `rgba(${r}, ${g}, ${b}, ${alpha})`;
};

const DESKTOP_BREAKPOINT = 1024; // px, for peripheral animation
const MAX_CONTENT_WIDTH = 1200; // px, max width of main content area for peripheral calculations

const BubbleBackground: React.FC = () => {
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const bubblesRef = useRef<Bubble[]>([]);
  const particlesRef = useRef<Particle[]>([]);
  const animationRef = useRef<number>();
  // timeRef removed as not actively used for bubble logic

  const colors = [
    '#6366f1', '#8b5cf6', '#ec4899', '#06b6d4', '#10b981',
    '#f59e0b', '#ef4444', '#3b82f6', '#84cc16', '#f97316',
  ];

  const drawColorfulBubble = useCallback((ctx: CanvasRenderingContext2D, bubble: Bubble) => {
    const { x, y, size, color, opacity } = bubble;

    const gradient = ctx.createRadialGradient(x - size * 0.3, y - size * 0.3, 0, x, y, size);
    gradient.addColorStop(0, hexToRgba(color, opacity * 0.8));
    gradient.addColorStop(0.6, hexToRgba(color, opacity));
    gradient.addColorStop(1, hexToRgba(color, opacity * 0.3));

    ctx.beginPath();
    ctx.arc(x, y, size, 0, Math.PI * 2);
    ctx.fillStyle = gradient;
    ctx.fill();

    const highlightGradient = ctx.createRadialGradient(x - size * 0.4, y - size * 0.4, 0, x - size * 0.4, y - size * 0.4, size * 0.7);
    highlightGradient.addColorStop(0, `rgba(255, 255, 255, ${opacity * 0.9})`);
    highlightGradient.addColorStop(0.6, `rgba(255, 255, 255, ${opacity * 0.4})`);
    highlightGradient.addColorStop(1, 'rgba(255, 255, 255, 0)');

    ctx.beginPath();
    ctx.arc(x - size * 0.4, y - size * 0.4, size * 0.7, 0, Math.PI * 2);
    ctx.fillStyle = highlightGradient;
    ctx.fill();

    ctx.beginPath();
    ctx.arc(x - size * 0.2, y - size * 0.2, size * 0.3, 0, Math.PI * 2);
    ctx.fillStyle = `rgba(255, 255, 255, ${opacity * 0.6})`;
    ctx.fill();
  }, []);


  const createExplosion = useCallback((x: number, y: number, color: string, size: number) => {
    const particleCount = Math.floor(size * 1.5); // Reduced particle count for performance
    for (let i = 0; i < particleCount; i++) {
      const angle = (Math.PI * 2 * i) / particleCount;
      const speed = Math.random() * 2 + 0.5; // Reduced speed
      particlesRef.current.push({
        id: Date.now() + Math.random(), x, y,
        vx: Math.cos(angle) * speed, vy: Math.sin(angle) * speed,
        life: 0, maxLife: Math.random() * 40 + 30, // Shorter life
        color, size: Math.random() * 3 + 1,
      });
    }
  }, []);

  const generateBubble = useCallback((canvasWidth: number, canvasHeight: number, isDesktopPeripheral: boolean): Bubble => {
    let x;
    const contentWidth = Math.min(canvasWidth, MAX_CONTENT_WIDTH);
    const peripheralWidth = (canvasWidth - contentWidth) / 2;

    if (isDesktopPeripheral && canvasWidth > DESKTOP_BREAKPOINT) {
      // Place in left or right peripheral areas
      if (Math.random() < 0.5) { // Left side
        x = Math.random() * peripheralWidth;
      } else { // Right side
        x = canvasWidth - peripheralWidth + Math.random() * peripheralWidth;
      }
    } else {
      // Full width for mobile or non-peripheral setup
      x = Math.random() * canvasWidth;
    }

    return {
      id: Math.random(),
      x,
      y: Math.random() * canvasHeight,
      size: Math.random() * 15 + 5, // Slightly smaller max size
      speed: Math.random() * 0.25 + 0.05, // Slower speed
      opacity: Math.random() * 0.3 + 0.15, // Slightly lower opacity
      wobble: 0,
      wobbleSpeed: Math.random() * 0.01 + 0.005,
      wobbleOffset: Math.random() * Math.PI * 2,
      color: colors[Math.floor(Math.random() * colors.length)],
    };
  }, [colors]);


  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    if (!ctx) return;

    const setCanvasDimensions = () => {
      canvas.width = window.innerWidth;
      canvas.height = window.innerHeight; // Fixed to viewport height
      // Style settings moved to CSS for clarity
    };

    const regenerateBubbles = () => {
        const isDesktop = window.innerWidth >= DESKTOP_BREAKPOINT;
        const bubbleCount = isDesktop ? Math.floor(window.innerWidth / 100) : Math.floor(window.innerWidth / 70); // Adjusted density

        bubblesRef.current = [];
        for (let i = 0; i < bubbleCount; i++) {
            bubblesRef.current.push(generateBubble(canvas.width, canvas.height, isDesktop));
        }
    };

    const handleResize = () => {
        setCanvasDimensions();
        regenerateBubbles();
    };

    setCanvasDimensions();
    regenerateBubbles();
    window.addEventListener('resize', handleResize);

    const handleClick = (event: MouseEvent) => {
      // Coordinates are relative to the canvas, which is viewport-sized
      const clickX = event.clientX;
      const clickY = event.clientY;

      for (let i = bubblesRef.current.length - 1; i >= 0; i--) {
        const bubble = bubblesRef.current[i];
        const distance = Math.sqrt(Math.pow(clickX - bubble.x, 2) + Math.pow(clickY - bubble.y, 2));
        if (distance <= bubble.size) {
          createExplosion(bubble.x, bubble.y, bubble.color, bubble.size);
          bubblesRef.current.splice(i, 1);
          // Add a new bubble to maintain count, respecting peripheral logic
          const isDesktop = window.innerWidth >= DESKTOP_BREAKPOINT;
          bubblesRef.current.push(generateBubble(canvas.width, canvas.height, isDesktop));
          break; // Pop one bubble per click
        }
      }
    };
    canvas.addEventListener('click', handleClick);

    const animate = () => {
      ctx.clearRect(0, 0, canvas.width, canvas.height);

      particlesRef.current = particlesRef.current.filter(p => {
        p.life++;
        p.x += p.vx;
        p.y += p.vy;
        p.vy += 0.05; // Reduced gravity

        if (p.life < p.maxLife) {
          const particleOpacity = 1 - (p.life / p.maxLife);
          ctx.beginPath();
          ctx.arc(p.x, p.y, p.size * particleOpacity, 0, Math.PI * 2);
          ctx.fillStyle = hexToRgba(p.color, particleOpacity);
          ctx.fill();
          return true;
        }
        return false;
      });

      const isDesktop = window.innerWidth >= DESKTOP_BREAKPOINT;
      const contentWidth = Math.min(canvas.width, MAX_CONTENT_WIDTH);
      const peripheralWidth = (canvas.width - contentWidth) / 2;
      const leftPeripheralBoundary = peripheralWidth;
      const rightPeripheralBoundary = canvas.width - peripheralWidth;

      bubblesRef.current.forEach(bubble => {
        bubble.y -= bubble.speed;
        bubble.wobble += bubble.wobbleSpeed;
        bubble.x += Math.sin(bubble.wobble + bubble.wobbleOffset) * 0.3; // Reduced wobble effect

        if (bubble.y < -bubble.size) {
          bubble.y = canvas.height + bubble.size;
          // Reset X position respecting peripheral logic
          if (isDesktop) {
            if (Math.random() < 0.5) {
              bubble.x = Math.random() * leftPeripheralBoundary;
            } else {
              bubble.x = rightPeripheralBoundary + Math.random() * (canvas.width - rightPeripheralBoundary);
            }
          } else {
            bubble.x = Math.random() * canvas.width;
          }
        }

        // Boundary checks for horizontal movement in peripheral mode
        if (isDesktop) {
            if (bubble.x < leftPeripheralBoundary && (bubble.x + bubble.size > leftPeripheralBoundary)) { // Approaching center from left
                 bubble.x = leftPeripheralBoundary - bubble.size - Math.random() * 5; // Push back
                 bubble.wobbleOffset += Math.PI; // Reverse wobble direction
            } else if (bubble.x > rightPeripheralBoundary && (bubble.x - bubble.size < rightPeripheralBoundary)) { // Approaching center from right
                 bubble.x = rightPeripheralBoundary + bubble.size + Math.random() * 5; // Push back
                 bubble.wobbleOffset += Math.PI; // Reverse wobble direction
            }
            // Keep within defined peripheral X zones if it strayed
            if (bubble.x > leftPeripheralBoundary && bubble.x < rightPeripheralBoundary) {
                 // If a bubble ends up in the center (e.g. due to resize), move it out
                if (Math.random() < 0.5) bubble.x = Math.random() * leftPeripheralBoundary;
                else bubble.x = rightPeripheralBoundary + Math.random() * (canvas.width - rightPeripheralBoundary);
            }
        }


        drawColorfulBubble(ctx, bubble);
      });

      animationRef.current = requestAnimationFrame(animate);
    };

    animationRef.current = requestAnimationFrame(animate);

    return () => {
      window.removeEventListener('resize', handleResize);
      canvas.removeEventListener('click', handleClick);
      if (animationRef.current) {
        cancelAnimationFrame(animationRef.current);
      }
    };
  }, [colors, createExplosion, drawColorfulBubble, generateBubble]);

  return (
    <canvas
      ref={canvasRef}
      className="bubble-background"
      // Inline styles removed, should be in BubbleBackground.css
    />
  );
};

export default BubbleBackground; 