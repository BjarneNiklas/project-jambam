import React, { useEffect, useRef, useState } from 'react';
import './ButterflyBackground.css';

interface Butterfly {
  id: number;
  x: number;
  y: number;
  size: number;
  speedX: number;
  speedY: number;
  color: string; // Added color property
  wingRotation: number; // For wing flapping animation
}

const ButterflyBackground: React.FC = () => {
  const containerRef = useRef<HTMLDivElement>(null);
  const [butterflies, setButterflies] = useState<Butterfly[]>([]);
  const requestRef = useRef<number>();

  const butterflyColors = ['#FFB6C1', '#FF69B4', '#DA70D6', '#BA55D3', '#ADD8E6', '#87CEFA'];

  const createButterfly = (containerWidth: number, containerHeight: number): Butterfly => {
    const size = Math.random() * 20 + 10; // Size between 10px and 30px
    return {
      id: Math.random(),
      x: Math.random() * containerWidth,
      y: Math.random() * containerHeight,
      size: size,
      speedX: (Math.random() - 0.5) * 2, // Random horizontal speed
      speedY: (Math.random() - 0.5) * 1, // Random vertical speed (slower)
      color: butterflyColors[Math.floor(Math.random() * butterflyColors.length)],
      wingRotation: 0,
    };
  };

  useEffect(() => {
    if (!containerRef.current) return;
    const container = containerRef.current;
    let animationFrameId: number;

    const DESKTOP_BREAKPOINT_BF = 1024; // Consistent naming with other components
    const MAX_CONTENT_WIDTH_BF = 1200;

    const setupAndAnimate = () => {
      const { width, height } = container.getBoundingClientRect();
      const isDesktop = width >= DESKTOP_BREAKPOINT_BF;
      const contentRenderWidth = Math.min(width, MAX_CONTENT_WIDTH_BF);
      const peripheralZoneWidth = (width - contentRenderWidth) / 2;

      constbutterfliesToSet: Butterfly[] = [];
      // Adjust density: fewer butterflies for peripheral display
      const numButterflies = isDesktop ? Math.floor(width / 250) : Math.floor(width / 150);

      for (let i = 0; i < numButterflies; i++) {
        let butterflyX;
        if (isDesktop && peripheralZoneWidth > 0) {
          if (Math.random() < 0.5) { // Left peripheral
            butterflyX = Math.random() * peripheralZoneWidth;
          } else { // Right peripheral
            butterflyX = width - peripheralZoneWidth + Math.random() * peripheralZoneWidth;
          }
        } else { // Mobile or full-width desktop (if content width is full screen)
          butterflyX = Math.random() * width;
        }
        const size = Math.random() * 20 + 10;
        butterfliesToSet.push({
          id: Math.random(),
          x: butterflyX,
          y: Math.random() * height,
          size: size,
          speedX: (Math.random() - 0.5) * (isDesktop ? 1.5 : 2), // Slower on desktop if peripheral
          speedY: (Math.random() - 0.5) * (isDesktop ? 0.75 : 1),
          color: butterflyColors[Math.floor(Math.random() * butterflyColors.length)],
          wingRotation: 0,
        });
      }
      setButterflies(butterfliesToSet);

      const animate = () => {
        setButterflies(prevButterflies =>
          prevButterflies.map(b => {
            let newX = b.x + b.speedX;
            let newY = b.y + b.speedY;
            let newSpeedX = b.speedX;
            let newSpeedY = b.speedY;

            const leftBoundary = isDesktop && peripheralZoneWidth > 0 ? (b.x < width / 2 ? 0 : width - peripheralZoneWidth) : 0;
            const rightBoundary = isDesktop && peripheralZoneWidth > 0 ? (b.x < width / 2 ? peripheralZoneWidth : width) : width;

            if (newX <= leftBoundary || newX >= rightBoundary - b.size) {
              newSpeedX *= -1;
              newX = b.x + newSpeedX; // Apply new direction immediately
            }
            if (newY <= 0 || newY >= height - b.size) {
              newSpeedY *= -1;
              newY = b.y + newSpeedY; // Apply new direction immediately
            }

            newX = Math.max(leftBoundary, Math.min(newX, rightBoundary - b.size));
            newY = Math.max(0, Math.min(newY, height - b.size));

            const wingRotation = Math.sin(Date.now() * 0.015) * 35; // Slightly faster flap

            return { ...b, x: newX, y: newY, speedX: newSpeedX, speedY: newSpeedY, wingRotation };
          })
        );
        animationFrameId = requestAnimationFrame(animate);
      };
      animationFrameId = requestAnimationFrame(animate);
    };

    setupAndAnimate(); // Initial setup
    window.addEventListener('resize', setupAndAnimate); // Re-setup on resize

    return () => {
      if (animationFrameId) {
        cancelAnimationFrame(animationFrameId);
      }
      window.removeEventListener('resize', setupAndAnimate);
    };
  }, [butterflyColors]); // Added butterflyColors to dependency array

  return (
    <div ref={containerRef} className="butterfly-background">
      {butterflies.map(b => (
        <div
          key={b.id}
          className="butterfly"
          style={{
            position: 'absolute',
            left: `${b.x}px`,
            top: `${b.y}px`,
            width: `${b.size}px`,
            height: `${b.size}px`,
            // backgroundColor: b.color, // Using SVG now
            transform: `rotate(${b.speedX > 0 ? -20 : 20}deg)`, // Tilt butterfly
          }}
        >
          {/* Simple SVG Butterfly */}
          <svg viewBox="0 0 100 100" style={{ width: '100%', height: '100%', overflow: 'visible' }}>
            {/* Left Wing */}
            <path
              d="M 50 50 Q 20 20 20 50 T 50 90"
              fill={b.color}
              transform={`rotate(${b.wingRotation}, 50, 50)`}
              style={{ transition: 'transform 0.1s ease-in-out' }}
            />
            {/* Right Wing */}
            <path
              d="M 50 50 Q 80 20 80 50 T 50 90"
              fill={b.color}
              transform={`scale(-1, 1) translate(-100, 0) rotate(${-b.wingRotation}, 50, 50)`}
              style={{ transition: 'transform 0.1s ease-in-out' }}
            />
            {/* Body */}
            <ellipse cx="50" cy="50" rx="5" ry="15" fill="#663300" />
          </svg>
        </div>
      ))}
    </div>
  );
};

export default ButterflyBackground;
