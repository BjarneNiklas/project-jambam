import React, { createContext, useContext, useState, useEffect, ReactNode, useCallback } from 'react';

type Theme = 'none' | 'bubbles' | 'balloons' | 'butterflies' | 'stars' | 'fireflies';

interface ThemeContextType {
  currentTheme: Theme;
  changeTheme: (theme: Theme) => void;
  animationsEnabled: boolean;
  toggleAnimations: () => void;
}

const ThemeContext = createContext<ThemeContextType | undefined>(undefined);

const isMobile = () => window.innerWidth < 768;

export const ThemeProvider: React.FC<{ children: ReactNode }> = ({ children }) => {
  const [currentTheme, setCurrentTheme] = useState<Theme>('bubbles');
  const [animationsEnabled, setAnimationsEnabled] = useState<boolean>(() => {
    const savedPreference = localStorage.getItem('jambam-animations-enabled');
    if (savedPreference) {
      return JSON.parse(savedPreference);
    }
    // Mobile-first: disabled by default on mobile
    return !isMobile();
  });

  useEffect(() => {
    const savedTheme = localStorage.getItem('jambam-theme') as Theme | null;
    if (savedTheme) {
      setCurrentTheme(savedTheme);
    }
  }, []);

  const changeTheme = useCallback((theme: Theme) => {
    localStorage.setItem('jambam-theme', theme);
    setCurrentTheme(theme);
  }, []);

  const toggleAnimations = useCallback(() => {
    setAnimationsEnabled(prev => {
      const newState = !prev;
      localStorage.setItem('jambam-animations-enabled', JSON.stringify(newState));
      return newState;
    });
  }, []);

  const value = React.useMemo(() => ({
    currentTheme,
    changeTheme,
    animationsEnabled,
    toggleAnimations
  }), [currentTheme, changeTheme, animationsEnabled, toggleAnimations]);

  return (
    <ThemeContext.Provider value={value}>
      {children}
    </ThemeContext.Provider>
  );
};

export const useTheme = (): ThemeContextType => {
  const context = useContext(ThemeContext);
  if (context === undefined) {
    throw new Error('useTheme must be used within a ThemeProvider');
  }
  return context;
}; 