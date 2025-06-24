# LUVY Engine – Architektur (Stand: 2025, Optimiert)

## Optimierte Prinzipien & Modularer Aufbau
Die LUVY Engine ist nach Clean Architecture, API-First, Mobile-First und Offline-First-Prinzipien aufgebaut. Jedes Feature ist ein eigenständiges Modul/Package und kann unabhängig entwickelt, getestet und deployed werden. Alle Kernfunktionen sind offlinefähig, Cloud-Sync ist optional.

### Hauptmodule (Optimiert)
- **core/**: Orchestrierung, Plug-in-System, Dependency Injection, Engine-Registry, Security, Audit-Log
- **engines/**: Adapter für Bevy, Godot, Unity, Broxel (Voxel), O3DE, Hot-Reload, Sandbox, CLI/FFI/HTTP/gRPC (Engine Adapter Layer)
- **mindflow/**: KI-Module (KI-Bridge), Game Design Assistant, Prompt2World, ProcGen, lokale/Cloud-Modelle, Unified API, Offline-Queue
- **gamejam/**: Game Jam Features (Themen, Teams, Bewertung, Submission, Community, engine-unabhängig)
- **gamelogic/**: Genres, Simulationen, Robotik, Bauwesen, etc. als modular erweiterbare Logik-Bausteine
- **data/**: SQLite (offline), PostgreSQL/Supabase (Cloud, optional), Repository Pattern, Sync, Verschlüsselung, Versionierung (Asset Pool/Manager)
- **ui/**: Flutter UI, Material 3, Engine-Selector, KI-Chat, Tutorials, Mobile-First, Responsive, Accessibility
- **plugins/**: Erweiterungen für Engines, KI, ProcGen, Exporter/Importer, Community-Plugins

### Engine-Adapter (Optimiert)
Jede unterstützte Engine (Bevy, Godot, Unity, Broxel, O3DE) wird über einen eigenen, modularen Adapter angebunden. Import/Export-Schnittstellen ermöglichen den Austausch von Projekten und Assets zwischen den Engines. Adapter sind hot-reloadbar, sandboxed und folgen dem API-First-Prinzip.

### Game Jam Modul
Das Game Jam Modul ist engine-unabhängig und konzentriert sich auf die Organisation und Durchführung von Game Jams. Es unterstützt die Erstellung von **Jam-Blueprints** und die Verwaltung von **Jam-Events**.
- **Jam-Blueprint-Erstellung:** Unterstützung für Themen, Regeln, Zeitpläne (KI-gestützt)
- Team-Management
- Submission-System
- Bewertung/Scoring
- Community- und Zuschauer-Features (aktive & passive Teilnahme)
- *Hinweis:* Jam-spezifische Konzepte (Jam-Herausforderung, Jam-Leitfaden) enthalten keine expliziten Genres, da Game Jams themen- und einschränkungsbasiert sind.

### Mindflow Engine (KI, Optimiert)
Die Mindflow Engine ist das Herzstück des KI-Multi-Agenten-Systems und des **Ideen-Generators**.
- KI-Adapter (OpenAI, HuggingFace, eigene Modelle, Ollama, Stable Diffusion)
- **Ideen-Generator:** Erzeugt **Spiel-Keime** aus dem Inspirations-Pool oder Jam-Blueprints. Hier werden Genres für die Spiel-Keime festgelegt, und die KI kann neue Genre-Kombinationen vorschlagen.
- Prompt2World, Text2Asset, Game Design Assistant, Playtest-Analyse, Balancing
- Unified API, Offline-Queue, Templates, Preview/Edit
- **Asset-Generierung:** KI-generierte Asset-Vorschläge und Bauanleitungen werden in **Jam-Leitfäden** (für Jams) und **Entwicklungs-Blaupausen** (für langfristige Projekte) integriert.

### Data Layer (Optimiert)
- Offline-First mit SQLite/Hive, lokale Verschlüsselung
- Cloud-Sync mit Supabase/PostgreSQL (optional, user-controlled)
- Repository Pattern, Migrations, Security, Versionierung

### UI Layer (Optimiert)
- Flutter, Material 3 Expressive, Modular Widgets, Mobile-First, Responsive, Accessibility, Glassmorphism, Animations
- Engine-Selector, KI-Chat, Asset-Browser, Game Jam Tools, Onboarding, Fehlerfeedback

## Erweiterbarkeit & Best Practices (Optimiert)
- API-First, Mobile-First, Offline-First, Test-First
- Plug-in-System für Engines, KI, ProcGen, UI, Community-Driven Erweiterungen, Hot-Reload, Sandbox, API-First, Security-First
- TODO: Prüfen, ob alle bisherigen Features/Module übernommen wurden. Falls nicht, bitte Rückmeldung geben!

## Roadmap/Phasen (Optimiert)
- **Phase 1:** Modular, offline-first, Engine-Adapter, Asset-Manager, UI/UX-Prototyp, alle Kernfunktionen offline
- **Phase 2:** KI-Module, erweiterte Engine-Unterstützung, User-Customization, fortgeschrittene Asset/Scene-Features
- **Phase 3:** Performance/Security-Optimierung, Beta, Cloud-Sync, Launch
- **Phase 4:** Kontinuierliches Feedback, Updates, neue Engines/KI, Community-Features
