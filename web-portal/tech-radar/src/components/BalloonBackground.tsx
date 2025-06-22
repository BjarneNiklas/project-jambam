import React, { useEffect, useRef } from 'react';
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

const BalloonBackground: React.FC = () => {
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const balloonsRef = useRef<Balloon[]>([]);
  const animationRef = useRef<number>();

  const colors = [
    '#ef4444', // Red
    '#3b82f6', // Blue
    '#10b981', // Emerald
    '#f59e0b', // Amber
    '#ec4899', // Pink
    '#8b5cf6', // Violet
  ];

  const drawBalloon = (ctx: CanvasRenderingContext2D, balloon: Balloon) => {
    const { x, y, size, color } = balloon;
    
    // Balloon body
    ctx.beginPath();
    ctx.ellipse(x, y, size, size * 1.2, 0, 0, Math.PI * 2);
    ctx.fillStyle = color;
    ctx.fill();

    // Highlight
    ctx.beginPath();
    ctx.ellipse(x - size * 0.3, y - size * 0.4, size * 0.3, size * 0.5, -Math.PI / 4, 0, Math.PI * 2);
    ctx.fillStyle = 'rgba(255, 255, 255, 0.4)';
    ctx.fill();

    // Knot
    ctx.beginPath();
    ctx.moveTo(x - size * 0.1, y + size * 1.2);
    ctx.lineTo(x + size * 0.1, y + size * 1.2);
    ctx.lineTo(x, y + size * 1.2 + 5);
    ctx.closePath();
    ctx.fillStyle = color;
    ctx.fill();
    
    // String
    ctx.beginPath();
    ctx.moveTo(x, y + size * 1.2 + 5);
    ctx.lineTo(x + Math.sin(y / 50) * 5, y + size * 1.2 + 45);
    ctx.strokeStyle = '#a1a1aa';
    ctx.lineWidth = 1;
    ctx.stroke();
  };
  
  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;

    const ctx = canvas.getContext('2d');
    if (!ctx) return;

    const setCanvasSize = () => {
      canvas.width = window.innerWidth;
      canvas.height = window.innerHeight;
    };

    setCanvasSize();
    window.addEventListener('resize', setCanvasSize);

    const generateBalloons = () => {
      const balloonCount = Math.floor(window.innerWidth / 150);
      for (let i = 0; i < balloonCount; i++) {
        balloonsRef.current.push({
          id: i,
          x: Math.random() * canvas.width,
          y: canvas.height + Math.random() * canvas.height,
          size: Math.random() * 10 + 15,
          speed: Math.random() * 0.5 + 0.3,
          color: colors[Math.floor(Math.random() * colors.length)],
          sway: Math.random() * Math.PI,
          swaySpeed: Math.random() * 0.01 + 0.005,
          swayAmplitude: Math.random() * 20 + 10,
        });
      }
    };

    generateBalloons();

    const animate = () => {
      ctx.clearRect(0, 0, canvas.width, canvas.height);

      balloonsRef.current.forEach((balloon, index) => {
        balloon.y -= balloon.speed;
        balloon.sway += balloon.swaySpeed;
        balloon.x += Math.sin(balloon.sway) * (balloon.swayAmplitude / 100);

        drawBalloon(ctx, balloon);

        if (balloon.y < -balloon.size * 2) {
          // Reset balloon to the bottom
          balloonsRef.current[index] = {
            ...balloon,
            y: canvas.height + balloon.size,
            x: Math.random() * canvas.width,
          };
        }
      });

      animationRef.current = requestAnimationFrame(animate);
    };

    animate();

    return () => {
      window.removeEventListener('resize', setCanvasSize);
      if (animationRef.current) {
        cancelAnimationFrame(animationRef.current);
      }
    };
  }, []);

  return <canvas ref={canvasRef} className="balloon-background" />;
};

export default BalloonBackground; 