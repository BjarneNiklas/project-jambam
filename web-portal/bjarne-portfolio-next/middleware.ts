import { NextRequest, NextResponse } from 'next/server';

// Definiere die unterstützten Sprachen
const locales = ['de', 'en'];
const defaultLocale = 'de';

// Funktion zum Extrahieren der Sprache aus der URL
function getLocale(request: NextRequest): string {
  const pathname = request.nextUrl.pathname;
  
  // Prüfe ob die URL bereits eine Sprache enthält
  const pathnameHasLocale = locales.some(
    (locale) => pathname.startsWith(`/${locale}/`) || pathname === `/${locale}`
  );

  if (pathnameHasLocale) return pathname.split('/')[1];
  
  // Prüfe Accept-Language Header
  const acceptLanguage = request.headers.get('accept-language');
  if (acceptLanguage) {
    const preferredLocale = acceptLanguage
      .split(',')
      .map(lang => lang.split(';')[0].trim())
      .find(lang => locales.includes(lang.substring(0, 2)));
    
    if (preferredLocale) {
      return preferredLocale.substring(0, 2);
    }
  }
  
  return defaultLocale;
}

// Funktion zum Erstellen der neuen URL
function createLocalizedUrl(request: NextRequest, locale: string): URL {
  const url = request.nextUrl.clone();
  const pathname = url.pathname;
  
  // Entferne vorhandene Sprachpräfixe
  const pathnameWithoutLocale = pathname.replace(/^\/[a-z]{2}/, '');
  
  // Füge die neue Sprache hinzu
  url.pathname = `/${locale}${pathnameWithoutLocale}`;
  
  return url;
}

export function middleware(request: NextRequest) {
  const pathname = request.nextUrl.pathname;
  
  // Überspringe statische Dateien und API-Routen
  if (
    pathname.startsWith('/_next') ||
    pathname.startsWith('/api') ||
    pathname.startsWith('/static') ||
    pathname.includes('.')
  ) {
    return NextResponse.next();
  }

  // Prüfe ob die URL bereits eine gültige Sprache enthält
  const pathnameHasValidLocale = locales.some(
    (locale) => pathname.startsWith(`/${locale}/`) || pathname === `/${locale}`
  );

  if (pathnameHasValidLocale) {
    return NextResponse.next();
  }

  // Hole die bevorzugte Sprache
  const locale = getLocale(request);
  
  // Erstelle die lokalisierte URL
  const localizedUrl = createLocalizedUrl(request, locale);
  
  // Weiterleitung zur lokalisierte URL
  return NextResponse.redirect(localizedUrl);
}

export const config = {
  matcher: [
    // Überspringe alle internen Pfade (_next)
    '/((?!_next|api|static|.*\\..*).*)',
  ],
}; 