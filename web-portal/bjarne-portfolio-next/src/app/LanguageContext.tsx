"use client";

import React, { createContext, useContext, useState } from 'react';
import deTranslations from './locales/de.json';
import enTranslations from './locales/en.json';

export type Language = 'de' | 'en';

type Translations = typeof deTranslations;

interface LanguageContextProps {
  lang: Language;
  setLang: (lang: Language) => void;
  t: (key: string) => string;
}

const LanguageContext = createContext<LanguageContextProps | undefined>(undefined);

export const useLanguage = () => {
  const context = useContext(LanguageContext);
  if (!context) throw new Error('useLanguage must be used within a LanguageProvider');
  return context;
};

const translations: Record<Language, Translations> = {
  de: deTranslations,
  en: enTranslations,
};

// Helper function to get nested object values by dot notation
const getNestedValue = (obj: unknown, path: string): string => {
  const keys = path.split('.');
  let current: unknown = obj;
  
  for (const key of keys) {
    if (current && typeof current === 'object' && key in current) {
      current = (current as Record<string, unknown>)[key];
    } else {
      return path;
    }
  }
  
  return typeof current === 'string' ? current : path;
};

export const LanguageProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [lang, setLang] = useState<Language>('de');

  const t = (key: string): string => {
    const message = getNestedValue(translations[lang], key) || getNestedValue(translations['en'], key) || key;
    return message;
  };

  return (
    <LanguageContext.Provider value={{ lang, setLang, t }}>
      {children}
    </LanguageContext.Provider>
  );
}; 