# JambaM Web Portal

Das Web Portal für die JambaM Organisation - eine Sammlung von React-basierten Webseiten für verschiedene Geschäftsbereiche.

## 🏗️ Architektur

Das Web Portal folgt einer **Hybrid-Architektur**:

- **Flutter App**: Hauptanwendung mit AI-Agenten, 3D/Game Engine Integration
- **React Webseiten**: Unternehmenspräsenz, Marketing, Dokumentation

## 📁 Projekt-Struktur

```
web-portal/
├── tech-radar/           # 🎯 Tech Radar (AKTUELL)
│   ├── src/
│   │   ├── components/   # React-Komponenten
│   │   ├── data/         # Tech Radar Daten
│   │   └── App.tsx       # Haupt-App
│   ├── package.json
│   └── README.md
├── corporate-website/    # 🏢 Unternehmenswebseite (GEPLANT)
├── ai-agent-hub/        # 🤖 AI Agent Hub (GEPLANT)
├── documentation/       # 📚 Dokumentation (GEPLANT)
└── README.md           # Diese Datei
```

## 🎯 Aktuelle Projekte

### 1. Tech Radar ✅
**Status**: Implementiert und funktionsfähig

- **Zweck**: Technologie-Strategie und -Bewertung
- **Features**: Interaktive D3.js Visualisierung, Filter, Suche
- **Technologien**: React, TypeScript, Material-UI, D3.js

**Starten**:
```bash
cd tech-radar
npm install
npm start
```

## 🚀 Geplante Projekte

### 2. Unternehmenswebseite (Corporate Website)
**Status**: Geplant

- **Zweck**: Unternehmenspräsenz, Marketing, Kundenakquise
- **Features**: 
  - Hero-Sektion mit JambaM Vision
  - Über uns / Team
  - Services / Produkte
  - Kontakt / Support
  - Blog / News
- **Technologien**: React, TypeScript, Material-UI, SEO-optimiert

### 3. AI Agent Hub
**Status**: Geplant

- **Zweck**: Web-basierte AI-Agent-Interaktion
- **Features**:
  - Agent-Auswahl und -Konfiguration
  - Echtzeit-Chat mit AI-Agenten
  - Agent-Metriken und -Performance
  - Kollaborations-Tools
- **Technologien**: React, TypeScript, LangChain.js, OpenAI SDK

### 4. Dokumentation
**Status**: Geplant

- **Zweck**: Entwickler-Dokumentation und Guides
- **Features**:
  - Markdown-basierte Dokumentation
  - Interaktive Code-Beispiele
  - API-Dokumentation
  - Tutorials und Guides
- **Technologien**: React, TypeScript, MDX, Prism.js

## 🔗 Integration

### Shared Infrastructure
- **API**: Gemeinsame Backend-API mit Flutter App
- **Authentication**: Einheitliche Authentifizierung
- **Data Sync**: Echtzeit-Synchronisation
- **Analytics**: Gemeinsame Metriken

### Navigation
- **Deep Links**: Von Webseiten zur Flutter App
- **Web-to-App**: Nahtlose Übergänge
- **Shared State**: Konsistente Benutzerdaten

## 🛠️ Entwicklung

### Neue Webseite hinzufügen

1. **Projekt erstellen**:
```bash
cd web-portal
npx create-react-app neue-webseite --template typescript
cd neue-webseite
npm install @mui/material @emotion/react @emotion/styled
```

2. **Struktur anpassen**:
   - Komponenten in `src/components/`
   - Daten in `src/data/`
   - Styling mit Material-UI

3. **Integration**:
   - Shared Components verwenden
   - API-Integration implementieren
   - Navigation einrichten

### Best Practices

- **TypeScript**: Alle Projekte verwenden TypeScript
- **Material-UI**: Konsistentes Design-System
- **Responsive**: Mobile-first Ansatz
- **SEO**: Suchmaschinen-optimiert
- **Performance**: Optimierte Builds und Lazy Loading

## 🚀 Deployment

### Lokale Entwicklung
```bash
# Tech Radar
cd tech-radar && npm start

# Weitere Projekte (wenn verfügbar)
cd corporate-website && npm start
cd ai-agent-hub && npm start
cd documentation && npm start
```

### Production Deployment

Jede Webseite kann unabhängig deployed werden:

- **Vercel**: Automatisches Deployment
- **Netlify**: Drag & Drop
- **GitHub Pages**: Statisches Hosting
- **Docker**: Container-basiert

## 📊 Monitoring & Analytics

- **Google Analytics**: Website-Traffic und -Performance
- **Hotjar**: User Experience und Heatmaps
- **Error Tracking**: Sentry für Fehler-Monitoring
- **Performance**: Lighthouse Scores

## 🤝 Team-Workflow

1. **Feature-Entwicklung**: In separaten Branches
2. **Code Review**: Pull Request Workflow
3. **Testing**: Automatisierte Tests
4. **Deployment**: Staging → Production Pipeline

## 🔗 Links

- [JambaM Hauptprojekt](../..)
- [Flutter App](../../..)
- [API Dokumentation](../../../api)
- [Tech Radar](./tech-radar)

---

**JambaM Web Portal Team** 🌐 