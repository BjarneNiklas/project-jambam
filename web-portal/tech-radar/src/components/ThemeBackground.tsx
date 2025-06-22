import React from 'react';
import { useTheme } from '../contexts/ThemeContext';
import BubbleBackground from './BubbleBackground';
import BalloonBackground from './BalloonBackground';

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
    // Add other themes here in the future
    default:
      // Fallback to bubbles or render nothing
      return <BubbleBackground />;
  }
};

export default ThemeBackground; 