import React from 'react';
import { useTheme } from '../contexts/ThemeContext';
import BubbleBackground from './BubbleBackground';
import BalloonBackground from './BalloonBackground';
import ButterflyBackground from './ButterflyBackground';
import StarsBackground from './StarsBackground';
import FirefliesBackground from './FirefliesBackground';

const ThemeBackground: React.FC = () => {
  const { currentTheme, animationsEnabled } = useTheme();

  // Return null if animations are globally disabled by the user or for performance reasons
  if (!animationsEnabled || currentTheme === 'none') {
    return null;
  }

  // Switch between different background components based on the theme
  switch (currentTheme) {
    case 'bubbles':
      return <BubbleBackground />;
    case 'balloons':
      return <BalloonBackground />;
    case 'butterflies':
      return <ButterflyBackground />;
    case 'stars':
      return <StarsBackground />;
    case 'fireflies':
      return <FirefliesBackground />;
    default:
      // Fallback to bubbles or render nothing if theme is unrecognized
      return <BubbleBackground />;
  }
};

export default ThemeBackground; 