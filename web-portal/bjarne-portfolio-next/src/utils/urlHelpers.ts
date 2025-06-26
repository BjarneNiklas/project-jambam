// Hilfsfunktionen für URL-Generierung mit Sprachunterstützung

export const createLocalizedUrl = (path: string, lang: string): string => {
  // Entferne führenden Slash falls vorhanden
  const cleanPath = path.startsWith('/') ? path.slice(1) : path;
  
  // Füge Sprachpräfix hinzu
  return `/${lang}/${cleanPath}`;
};

export const createLocalizedHashUrl = (hash: string, lang: string): string => {
  // Entferne führendes # falls vorhanden
  const cleanHash = hash.startsWith('#') ? hash.slice(1) : hash;
  
  // Erstelle URL mit Hash
  return `/${lang}#${cleanHash}`;
};

export const getCurrentLangFromPath = (pathname: string): string => {
  const segments = pathname.split('/');
  const lang = segments[1];
  
  // Prüfe ob es eine gültige Sprache ist
  if (lang === 'en' || lang === 'de') {
    return lang;
  }
  
  // Fallback auf Deutsch
  return 'de';
}; 