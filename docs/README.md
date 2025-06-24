# LUVY Engine - Next-Generation Interactive Media Platform

Eine offene, modulare und mobile Plattform für die nächste Generation der Spieleentwicklung. Ziel ist es, Game Jams, Co-Creation und kreative Prozesse für alle zugänglich zu machen – unabhängig von Vorkenntnissen.

## 🎯 Vision

Die LUVY Engine ist eine community-driven, API-first, test-first und offline-first Plattform für die europäische und deutsche Gaming-Community. Sie fördert Community-Building, Wettbewerb, Teamwork, Skalierbarkeit, User-Engagement, Zuverlässigkeit, Gamification und exzellente Workflows (privat & geschäftlich).

## 🏗️ Architektur & Konzepte

### Kernbegriffe

Die Plattform basiert auf vier klar definierten Kernbegriffen:

- **🌱 Jam Seed:** Flexibler, inspirierender Ausgangspunkt für Game Jam Events (genre-agnostisch)
- **🛠️ Jam Kit:** Konkreter, umsetzbarer Leitfaden für Game Jam Events (genre-agnostisch)
- **🎮 Game Seed:** Konkrete, aber flexible Spielidee für langfristige Projekte (genre-spezifisch)
- **📋 Game Kit (Development Blueprint):** Umfassende, detaillierte Blaupause für langfristige Spielentwicklung (genre-spezifisch)

Für detaillierte Definitionen siehe [Terminologie und Konzepte](./core/terminology_and_concepts.md).

### Entwicklungswege

Die Plattform unterstützt zwei Hauptentwicklungswege:

1. **Game Jam Route (Community-getrieben):** Inspirations-Pool → Jam Seed → Jam Kit → Jam Event → Spiel-Prototyp
2. **Langfristige Entwicklung (KI-getrieben):** Inspirations-Pool → Game Seed → Game Kit → Spiel-Entwicklung → Veröffentlichtes Spiel

Für Details siehe [Konzeptioneller Rahmen](./core/conceptual_framework.md).

## 📚 Dokumentation

### Kern-Dokumentation
- [Projekt-Übersicht](./core/project_overview.md) - Allgemeine Projektinformationen
- [Architektur-Übersicht](./core/architecture_overview.md) - Technische Architektur
- [Konzeptioneller Rahmen](./core/conceptual_framework.md) - Konzepte und Entwicklungsprozesse
- [Terminologie und Konzepte](./core/terminology_and_concepts.md) - Klare Definitionen der Kernbegriffe
- [Vision und Workflow](./core/vision_and_workflow.md) - KI-Multi-Agenten-System für kreative Game Jam Organisation

### Feature-Dokumentation
- [AI-Features](./features/ai/) - KI-Integration und Multi-Agenten-System
- [Game Jam Features](./features/game_jams/) - Game Jam Organisation und Events
- [Engine-Integration](./features/engines/) - Unterstützte Engines und Adapter
- [Community-Features](./features/general/) - Community-Building und Kollaboration

### Entwickler-Dokumentation
- [Entwickler-Guide](./development/developer_guide.md) - Setup und Entwicklung
- [API-Dokumentation](./api/README.md) - API-Spezifikationen
- [Test-Guide](./development/testing_guide.md) - Testing-Strategien

## 🚀 Schnellstart

### Voraussetzungen
- Flutter SDK (latest stable)
- Dart SDK (latest stable)
- Android Studio / VS Code
- Git

### Installation
```bash
git clone https://github.com/your-org/project-jambam.git
cd project-jambam
flutter pub get
flutter run
```

### Erste Schritte
1. **Community Hub erkunden:** Entdecke Jam Seeds und beteilige dich an Diskussionen
2. **Game Seed generieren:** Nutze den KI-Ideen-Generator für langfristige Projekte
3. **Jam Kit erstellen:** Entwickle konkrete Leitfäden für Game Jam Events
4. **Development Blueprint:** Erstelle umfassende Blaupausen für professionelle Entwicklung

## 🏛️ Architektur-Prinzipien

- **API-First:** Jede Funktionalität ist über eine klar definierte, dokumentierte API zugänglich
- **Test-First:** Testgetriebene Entwicklung (TDD) und automatisierte Tests für alle Module
- **Offline-First:** Die Plattform funktioniert auch ohne Internetverbindung
- **Community-Driven:** Offene APIs, Plug-in-System, Modding, Tutorials, Voting, Feedback-Mechanismen
- **DX-First:** Hot Reload, gute Doku, CLI-Tools, Dev-Server, Plug-in-Marktplatz
- **Security-First:** Auth, Rate Limiting, DSGVO, Privacy by Design
- **Accessibility-First:** Barrierefreiheit, Mehrsprachigkeit, anpassbare UI

## 🔧 Module & Features

### Core Module
- **core/:** Orchestrierung, Plug-in-System, Registry, DI
- **engines/:** Adapter für Bevy, Godot, Unity, Broxel (Voxel), O3DE
- **mindflow/:** KI-Module, Ideen-Generator, Game Design Assistant, Prompt2World, ProcGen
- **gamejam/:** Game Jam Features (Jam Seeds, Jam Kits, Jam Events)
- **gamelogic/:** Genres, Simulationen, Robotik, Bauwesen, etc.
- **data/:** SQLite (offline), PostgreSQL/Supabase (Cloud), Repository Pattern, Sync
- **ui/:** Flutter UI, Material 3, Engine-Selector, KI-Chat, Tutorials
- **plugins/:** Erweiterungen für Engines, KI, ProcGen, Exporter/Importer

### KI-Integration
- **Ideen-Generator:** Erzeugt Game Seeds und Development Blueprints
- **Multi-Agenten-System:** Spezialisierte KI-Agenten für verschiedene Aspekte
- **Genre-Evolution:** Förderung neuer Genre-Kombinationen
- **Asset-Generierung:** KI-generierte Asset-Vorschläge und Bauanleitungen

### Community-Features
- **Community Hub:** Jam Seed Diskussion und Voting
- **Game Jam Events:** Organisation und Durchführung von Game Jams
- **Collaboration Tools:** Team-Management und Kollaboration
- **Feedback-System:** Community-Feedback und Iteration

## 🤝 Beitragen

Wir freuen uns über Beiträge! Siehe [CONTRIBUTING.md](../CONTRIBUTING.md) für Details.

### Entwicklung
1. Fork das Repository
2. Erstelle einen Feature-Branch
3. Implementiere deine Änderungen
4. Schreibe Tests
5. Erstelle einen Pull Request

### Community
- Beteilige dich an Diskussionen im Community Hub
- Erstelle und verfeinere Jam Seeds
- Teile deine Game Seeds und Development Blueprints
- Berichte Bugs und schlage Features vor

## 📄 Lizenz

Dieses Projekt ist unter der [MIT License](../LICENSE) lizenziert.

## 🔗 Links

- [Website](https://luvy-engine.com)
- [API-Dokumentation](./api/README.md)
- [Community Hub](https://community.luvy-engine.com)
- [Discord](https://discord.gg/luvy-engine)
- [Twitter](https://twitter.com/luvy_engine)

---

**LUVY Engine** - Die nächste Generation der interaktiven Medienplattform für Europa 🇪🇺
