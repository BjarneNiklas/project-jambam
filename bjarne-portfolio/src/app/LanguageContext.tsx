import React, { createContext, useContext, useState, ReactNode } from 'react';
import deTranslations from './locales/de.json';
import enTranslations from './locales/en.json';

export type Language = 'de' | 'en';

type Translations = typeof deTranslations;

interface LanguageContextProps {
  lang: Language;
  setLang: (lang: Language) => void;
  t: (key: keyof Translations, components?: ReactNode[]) => ReactNode;
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

export const LanguageProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [lang, setLang] = useState<Language>('de');

  const t = (key: keyof Translations, components?: ReactNode[]): ReactNode => {
    const message = translations[lang][key] || translations['en'][key]; // Fallback to English
    if (components && components.length > 0) {
      const parts = message.split(/<(\d+)>(.*?)<\/\1>/g);
      return parts.map((part, index) => {
        if (index % 3 === 1) { // This is the tag number, e.g., "0" from "<0>"
          return components[parseInt(part, 10)];
        }
        if (index % 3 === 2) { // This is the content within the tags
          // We return this along with the component in the next iteration if needed,
          // or it's handled if components[parseInt(parts[index-1], 10)] is a simple wrapper
          return part;
        }
        return part; // This is regular text
      }).filter(Boolean);
    }
    return message;
  };

  return (
    <LanguageContext.Provider value={{ lang, setLang, t }}>
      {children}
    </LanguageContext.Provider>
  );
};
