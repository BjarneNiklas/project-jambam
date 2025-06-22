import React, { useEffect, useRef } from 'react';
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
  life: number;
  maxLife: number;
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
    return `rgba(255, 255, 255, ${alpha})`; // Fallback for invalid hex
  }

  return `rgba(${r}, ${g}, ${b}, ${alpha})`;
};

const BubbleBackground: React.FC = () => {
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const bubblesRef = useRef<Bubble[]>([]);
  const particlesRef = useRef<Particle[]>([]);
  const animationRef = useRef<number>();
  const timeRef = useRef<number>(0);

  // Beautiful colorful palette
  const colors = [
    '#6366f1', // Indigo
    '#8b5cf6', // Violet
    '#ec4899', // Pink
    '#06b6d4', // Cyan
    '#10b981', // Emerald
    '#f59e0b', // Amber
    '#ef4444', // Red
    '#3b82f6', // Blue
    '#84cc16', // Lime
    '#f97316', // Orange
  ];

  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;

    const ctx = canvas.getContext('2d');
    if (!ctx) return;

    // Force canvas to be viewport-sized and fixed
    const setCanvasSize = () => {
      const totalHeight = Math.max(document.body.scrollHeight, document.body.offsetHeight, document.documentElement.clientHeight, document.documentElement.scrollHeight, document.documentElement.offsetHeight);
      canvas.width = window.innerWidth;
      canvas.height = totalHeight;
      canvas.style.width = window.innerWidth + 'px';
      canvas.style.height = totalHeight + 'px';
    };

    setCanvasSize();
    window.addEventListener('resize', setCanvasSize);

    // Handle click events - use viewport coordinates
    const handleClick = (event: MouseEvent) => {
      const clickX = event.clientX;
      const clickY = event.clientY + window.scrollY;

      // Check if any bubble was clicked
      bubblesRef.current.forEach((bubble, index) => {
        const distance = Math.sqrt(
          Math.pow(clickX - bubble.x, 2) + Math.pow(clickY - bubble.y, 2)
        );

        if (distance <= bubble.size) {
          // Create explosion particles
          createExplosion(bubble.x, bubble.y, bubble.color, bubble.size);
          
          // Remove the bubble
          bubblesRef.current.splice(index, 1);
        }
      });
    };

    canvas.addEventListener('click', handleClick);

    // Create explosion effect
    const createExplosion = (x: number, y: number, color: string, size: number) => {
      const particleCount = Math.floor(size * 2);
      
      for (let i = 0; i < particleCount; i++) {
        const angle = (Math.PI * 2 * i) / particleCount;
        const speed = Math.random() * 3 + 1;
        
        const particle: Particle = {
          id: Date.now() + Math.random(),
          x: x,
          y: y,
          vx: Math.cos(angle) * speed,
          vy: Math.sin(angle) * speed,
          life: 0,
          maxLife: Math.random() * 60 + 40,
          color: color,
          size: Math.random() * 4 + 2
        };
        
        particlesRef.current.push(particle);
      }
    };

    // Generate initial bubbles
    const generateBubbles = () => {
      const bubbles: Bubble[] = [];
      const bubbleCount = Math.floor(window.innerWidth / 80);
      const totalHeight = Math.max(document.body.scrollHeight, document.body.offsetHeight, document.documentElement.clientHeight, document.documentElement.scrollHeight, document.documentElement.offsetHeight);
      
      for (let i = 0; i < bubbleCount; i++) {
        const color = colors[Math.floor(Math.random() * colors.length)];
        
        bubbles.push({
          id: i,
          x: Math.random() * window.innerWidth,
          y: Math.random() * totalHeight,
          size: Math.random() * 18 + 6,
          speed: Math.random() * 0.3 + 0.1,
          opacity: Math.random() * 0.4 + 0.2,
          wobble: 0,
          wobbleSpeed: Math.random() * 0.015 + 0.008,
          wobbleOffset: Math.random() * Math.PI * 2,
          color: color,
          life: 0,
          maxLife: Math.random() * 800 + 600
        });
      }
      
      bubblesRef.current = bubbles;
    };

    generateBubbles();

    // Animation loop
    const animate = (timestamp: number) => {
      timeRef.current = timestamp;
      const scrollY = window.scrollY;
      const totalHeight = Math.max(document.body.scrollHeight, document.body.offsetHeight, document.documentElement.clientHeight, document.documentElement.scrollHeight, document.documentElement.offsetHeight);
      ctx.clearRect(0, 0, window.innerWidth, window.innerHeight);

      // Update and draw particles
      particlesRef.current = particlesRef.current.filter(particle => {
        particle.life += 1;
        particle.x += particle.vx;
        particle.y += particle.vy;
        particle.vy += 0.1; // Gravity

        if (particle.life < particle.maxLife) {
          const opacity = 1 - (particle.life / particle.maxLife);
          const screenY = particle.y - scrollY;
          if (screenY >= -particle.size && screenY <= window.innerHeight + particle.size) {
            ctx.beginPath();
            ctx.arc(particle.x, screenY, particle.size * opacity, 0, Math.PI * 2);
            ctx.fillStyle = hexToRgba(particle.color, opacity);
            ctx.fill();
          }
          return true;
        }
        return false;
      });

      bubblesRef.current.forEach((bubble) => {
        // Move bubble up with gentle horizontal wobble
        bubble.y -= bubble.speed;
        bubble.wobble += bubble.wobbleSpeed;
        bubble.x += Math.sin(bubble.wobble + bubble.wobbleOffset) * 0.5;

        // Wrap around when bubble goes off screen
        if (bubble.y < -bubble.size) {
          bubble.y = totalHeight + bubble.size;
          bubble.x = Math.random() * window.innerWidth;
        }

        // Draw bubble if it's in the visible area
        const screenY = bubble.y - scrollY;
        if (screenY >= -bubble.size && screenY <= window.innerHeight + bubble.size) {
          drawColorfulBubble(ctx, bubble, bubble.opacity, screenY);
        }
      });

      animationRef.current = requestAnimationFrame(animate);
    };

    animate(0);

    // Cleanup
    return () => {
      window.removeEventListener('resize', setCanvasSize);
      canvas.removeEventListener('click', handleClick);
      if (animationRef.current) {
        cancelAnimationFrame(animationRef.current);
      }
    };
  }, []);

  const drawColorfulBubble = (ctx: CanvasRenderingContext2D, bubble: Bubble, opacity: number, screenY: number) => {
    const { x, size, color } = bubble;
    
    // Create gradient for colorful bubble
    const gradient = ctx.createRadialGradient(
      x - size * 0.3, 
      screenY - size * 0.3, 
      0,
      x, 
      screenY, 
      size
    );

    // Use robust RGBA values for the gradient to prevent crashes
    gradient.addColorStop(0, hexToRgba(color, opacity * 0.8)); // Inner part
    gradient.addColorStop(0.6, hexToRgba(color, opacity));     // Middle part
    gradient.addColorStop(1, hexToRgba(color, opacity * 0.3)); // Outer edge

    // Draw main bubble
    ctx.beginPath();
    ctx.arc(x, screenY, size, 0, Math.PI * 2);
    ctx.fillStyle = gradient;
    ctx.fill();

    // Add bright highlight
    const highlightGradient = ctx.createRadialGradient(
      x - size * 0.4, 
      screenY - size * 0.4, 
      0,
      x - size * 0.4, 
      screenY - size * 0.4, 
      size * 0.7
    );
    
    highlightGradient.addColorStop(0, `rgba(255, 255, 255, ${opacity * 0.9})`);
    highlightGradient.addColorStop(0.6, `rgba(255, 255, 255, ${opacity * 0.4})`);
    highlightGradient.addColorStop(1, 'rgba(255, 255, 255, 0)');

    ctx.beginPath();
    ctx.arc(x - size * 0.4, screenY - size * 0.4, size * 0.7, 0, Math.PI * 2);
    ctx.fillStyle = highlightGradient;
    ctx.fill();

    // Add secondary highlight
    ctx.beginPath();
    ctx.arc(x - size * 0.2, screenY - size * 0.2, size * 0.3, 0, Math.PI * 2);
    ctx.fillStyle = `rgba(255, 255, 255, ${opacity * 0.6})`;
    ctx.fill();

    // Add glow effect
    ctx.beginPath();
    ctx.arc(x, screenY, size + 2, 0, Math.PI * 2);
    ctx.strokeStyle = color + '40';
    ctx.lineWidth = 2;
    ctx.stroke();
  };

  return (
    <canvas
      ref={canvasRef}
      className="bubble-background"
      style={{
        position: 'fixed',
        top: 0,
        left: 0,
        width: '100vw',
        height: '100vh',
        pointerEvents: 'auto',
        zIndex: 0,
        opacity: 1,
        cursor: 'pointer'
      }}
    />
  );
};

export default BubbleBackground; 