import React, { createContext, useContext, useState, ReactNode, useEffect } from 'react';

interface DarkModeContextType {
  isDarkMode: boolean;
  toggleDarkMode: () => void;
}

const DarkModeContext = createContext<DarkModeContextType | undefined>(undefined);

export const useDarkMode = () => {
  const context = useContext(DarkModeContext);
  if (context === undefined) {
    throw new Error('useDarkMode must be used within a DarkModeProvider');
  }
  return context;
};

interface DarkModeProviderProps {
  children: ReactNode;
}

export const DarkModeProvider: React.FC<DarkModeProviderProps> = ({ children }) => {
  // Load dark mode preference from localStorage or default to false
  const getInitialDarkMode = (): boolean => {
    const saved = localStorage.getItem('darkMode');
    return saved ? JSON.parse(saved) : false;
  };

  const [isDarkMode, setIsDarkMode] = useState<boolean>(getInitialDarkMode);

  const toggleDarkMode = () => {
    setIsDarkMode(prev => !prev);
  };

  // Apply dark mode to document body
  useEffect(() => {
    localStorage.setItem('darkMode', JSON.stringify(isDarkMode));
    
    if (isDarkMode) {
      document.body.classList.add('dark-mode');
    } else {
      document.body.classList.remove('dark-mode');
    }
  }, [isDarkMode]);

  return (
    <DarkModeContext.Provider value={{ isDarkMode, toggleDarkMode }}>
      {children}
    </DarkModeContext.Provider>
  );
}; 