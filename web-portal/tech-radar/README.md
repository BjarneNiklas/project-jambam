# JambaM Tech Radar

Eine interaktive Webanwendung zur Visualisierung und Verwaltung der Technologie-Strategie für das JambaM Projekt.

## 🎯 Überblick

Der Tech Radar ist ein strategisches Tool zur Bewertung und Planung von Technologien im JambaM Ökosystem. Er zeigt:

- **Aktuelle Technologie-Stack**: Was wir verwenden und empfehlen
- **Experimentelle Technologien**: Was wir testen und evaluieren
- **Strategische Richtung**: Wohin sich unsere Technologie-Entscheidungen entwickeln

## 🚀 Features

### Interaktive Visualisierung
- **D3.js Radar Chart**: Dynamische Visualisierung der Technologien
- **Hover-Effekte**: Detaillierte Informationen bei Mausberührung
- **Responsive Design**: Optimiert für verschiedene Bildschirmgrößen

### Filter & Suche
- **Quadrant-Filter**: Nach Technologie-Kategorien filtern
- **Ring-Filter**: Nach Bewertungsstufen filtern (ADOPT, TRIAL, ASSESS, HOLD)
- **Text-Suche**: Durch Namen, Beschreibungen und Kategorien suchen
- **Aktive Filter-Anzeige**: Übersicht der aktuellen Filter

### Moderne UI/UX
- **Material-UI**: Konsistentes Design-System
- **TypeScript**: Typsichere Entwicklung
- **Responsive Layout**: Mobile-first Ansatz

## 🏗️ Technologie-Stack

- **React 18**: Moderne React-Features und Hooks
- **TypeScript**: Typsicherheit und bessere Developer Experience
- **Material-UI**: Komponenten-Bibliothek für konsistentes Design
- **D3.js**: Datenvisualisierung und interaktive Charts
- **Vite**: Schnelle Build-Tools und Hot Reload

## 📦 Installation

```bash
# Abhängigkeiten installieren
npm install

# Entwicklungsserver starten
npm start

# Production Build erstellen
npm run build

# Tests ausführen
npm test
```

## 🎨 Verwendung

### Technologien hinzufügen/bearbeiten

Bearbeiten Sie die Datei `src/data/techRadarData.ts`:

```typescript
{
  name: "Neue Technologie",
  quadrant: "Tools", // oder "Platforms", "Languages & Frameworks", "Techniques"
  ring: "TRIAL", // oder "ADOPT", "ASSESS", "HOLD"
  description: "Beschreibung der Technologie und ihrer Verwendung"
}
```

### Radar-Konfiguration

Die Radar-Visualisierung kann in `src/components/RadarChart.tsx` angepasst werden:

- **Farben**: Ring- und Quadrant-Farben ändern
- **Größe**: Chart-Dimensionen anpassen
- **Layout**: Positionierung und Styling modifizieren

## 📊 Radar-Struktur

### Ringe (von innen nach außen)

1. **ADOPT** (Grün): Technologien, die wir aktiv verwenden und empfehlen
2. **TRIAL** (Orange): Technologien, die wir experimentell einsetzen
3. **ASSESS** (Blau): Technologien, die wir evaluieren
4. **HOLD** (Rot): Technologien, die wir ausphasen

### Quadranten

1. **Languages & Frameworks**: Programmiersprachen und Frameworks
2. **Platforms**: Datenbanken, Cloud-Plattformen, Infrastructure
3. **Tools**: Software, Libraries und Services
4. **Techniques**: Methodologien und Praktiken

## 🔧 Entwicklung

### Projekt-Struktur

```
src/
├── components/
│   ├── RadarChart.tsx      # D3.js Radar Visualisierung
│   └── TechnologyFilters.tsx # Filter-Komponenten
├── data/
│   └── techRadarData.ts    # Technologie-Daten
├── App.tsx                 # Haupt-App-Komponente
└── index.tsx              # App-Einstiegspunkt
```

### Neue Features hinzufügen

1. **Komponenten**: Neue React-Komponenten in `src/components/`
2. **Daten**: Erweiterte Datenstrukturen in `src/data/`
3. **Styling**: Material-UI Theme in `src/App.tsx` anpassen

## 🚀 Deployment

### Lokaler Build

```bash
npm run build
```

### Production Deployment

Die Anwendung kann auf verschiedenen Plattformen deployed werden:

- **Vercel**: Automatisches Deployment von GitHub
- **Netlify**: Drag & Drop Deployment
- **GitHub Pages**: Statisches Hosting
- **Docker**: Container-basiertes Deployment

## 🤝 Beitragen

1. Fork des Repositories
2. Feature-Branch erstellen (`git checkout -b feature/neue-funktion`)
3. Änderungen committen (`git commit -am 'Neue Funktion hinzugefügt'`)
4. Branch pushen (`git push origin feature/neue-funktion`)
5. Pull Request erstellen

## 📝 Lizenz

Dieses Projekt ist Teil des JambaM Ökosystems und unterliegt den Projekt-Lizenzbedingungen.

## 🔗 Links

- [JambaM Hauptprojekt](../..)
- [Flutter App](../../..)
- [API Dokumentation](../../../api)

---

**Entwickelt für das JambaM Team** 🚀
