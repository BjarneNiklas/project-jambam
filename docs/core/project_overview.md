# LUVY Engine – Projektdokumentation

## Vision
Die LUVY Engine ist eine offene, modulare und mobile Plattform für die nächste Generation der Spieleentwicklung. Ziel ist es, Game Jams, Co-Creation und kreative Prozesse für alle zugänglich zu machen – unabhängig von Vorkenntnissen. Die Engine ist community-driven, API-first, test-first und offline-first.

## Leitprinzipien
- **API-First:** Jede Funktionalität ist über eine klar definierte, dokumentierte API zugänglich.
- **Test-First:** Testgetriebene Entwicklung (TDD) und automatisierte Tests für alle Module.
- **Offline-First:** Die Plattform funktioniert auch ohne Internetverbindung (lokale Datenhaltung, später Sync mit Supabase/PostgreSQL).
- **Community-Driven:** Offene APIs, Plug-in-System, Modding, Tutorials, Voting, Feedback-Mechanismen.
- **DX-First:** Hot Reload, gute Doku, CLI-Tools, Dev-Server, Plug-in-Marktplatz.
- **Security-First:** Auth, Rate Limiting, DSGVO, Privacy by Design.
- **Accessibility-First:** Barrierefreiheit, Mehrsprachigkeit, anpassbare UI.

## Architektur-Überblick
- **core/**: Orchestrierung, Plug-in-System, Registry, DI
- **engines/**: Adapter für Bevy, Godot, Unity, Broxel (Voxel), ggf. Minetest
- **mindflow/**: KI-Module, **Ideen-Generator**, Game Design Assistant, Prompt2World, ProcGen
- **gamejam/**: Game Jam Features (Organisation von **Jam-Blueprints** und **Jam-Events**). Siehe [Konzeptioneller Rahmen](./architecture/conceptual_framework.md) für Details zu Jam-Konzepten.
- **gamelogic/**: Genres, Simulationen, Robotik, Bauwesen, etc.
- **data/**: SQLite (offline), PostgreSQL/Supabase (Cloud), Repository Pattern, Sync
- **ui/**: Flutter UI, Material 3, Engine-Selector, KI-Chat, Tutorials
- **plugins/**: Erweiterungen für Engines, KI, ProcGen, Exporter/Importer
- **docs/**: Zentrale Dokumentation, Architektur, API, Tutorials, Changelog, ToDo

## Workflows
- **API-First:** Jede Funktionalität wird zuerst als API spezifiziert (OpenAPI YAML), dann implementiert.
- **Test-First:** Für jede Funktionalität werden zuerst Tests geschrieben, dann die Implementierung.
- **Changelog-Automatisierung:**
  - Erledigte Aufgaben in TODO.md werden mit [x] markiert und mit Keywords (added, improved, fixed, removed) versehen.
  - Das Skript `changelog_generator.dart` generiert daraus einen farbcodierten Changelog in CHANGELOG.md.
  - Die Farbcodes werden zentral in `changelog_colors.json` gepflegt.
  - GitHub Actions Workflow `.github/workflows/changelog.yml` aktualisiert den Changelog bei jedem Push/Merge automatisch.

## Module & Features
- **Broxel Engine:** Eigene Voxel-Engine für prozedurale Blockwelten (ProcGen), Game Jam Support.
- **Mindflow Engine:** KI-Integration (OpenAI, HuggingFace, LegoGPT, eigene Modelle), **Ideen-Generator** (erzeugt **Spiel-Keime**), Game Design Assistant, Prompt2World.
- **Game Jam Modul:** Engine-unabhängige Features für Game Jams. Unterstützt die Erstellung von **Jam-Blueprints** und die Durchführung von **Jam-Events**.
  - Siehe unseren aktuellen [Konzeptionellen Rahmen](./architecture/conceptual_framework.md) für die Definition von Jam-Herausforderungen und Jam-Leitfäden.
- **Engines Adapter:** Unterstützung für Bevy, Godot, Unity, Broxel, ggf. Luanty (prev. Minetest).
- **Data Layer:** SQLite (offline), Supabase/PostgreSQL (Cloud), Repository Pattern, Sync, Security.
- **UI Layer:** Flutter, Material 3 Expressive, modular, barrierefrei, Engine-Selector, KI-Chat, Tutorials.
- **Plug-in-System:** Erweiterungen für Engines, KI, ProcGen, Exporter/Importer, Plug-in-Marktplatz.
- **Lab System:** Facilitates experimental research, data collection, and innovative projects. The LegoGPT Lab (detailed in the Labs Overview) is one such example, now enhanced to support selection of multiple generated models for use in procedural world generation in Unity, and including a voxel-block conversion view for individual designs. See the [Labs Overview](labs_overview.md) for more details.
- **Feature Ideas:** [High-level feature concepts and ideas (see `docs/feature_ideas.md`)](docs/feature_ideas.md)

## Community & Innovation
- **Community-Driven Development:** Jeder kann aktiv oder passiv teilnehmen, eigene Spiele, Assets, Tutorials, Übersetzungen, Events beitragen.
- **Game Jam Experience:** Aktive und passive Teilnahme, Teams unterstützen, Voting, Challenges, Community-Events.
  - Durchsuchen und beitragen zu unseren [Community Game Jam Entries](./gamejam/entries.md).
- **Onboarding & Tutorials:** Interaktive, KI-gestützte Tutorials, Mentoren-Programme, Community-Support.
- **Hybride Genres & Zukunft:** KI-gestützte Genre-Mixes, **Ideen-Generator**, Asset Library, Modding, User-Generated Content. Das Ökosystem fördert die Entstehung neuer Genres durch die Kombination von **Inspirations-Pool**-Elementen und der Flexibilität von **Spiel-Keimen**.

## Best Practices
- **Modularität:** Jedes Feature als eigenständiges Modul/Package.
- **Klare Schnittstellen:** API-first, OpenAPI, Events, Plug-in-System.
- **Automatisierung:** Tests, Changelog, CI/CD, Doku-Generierung.
- **Security & Privacy:** DSGVO, Auth, Rate Limiting, Privacy by Design.

## Einstieg & Weiterentwicklung
- Lies die TODO.md für aktuelle Aufgaben und Roadmap.
- Pflege die Dokumentation im docs/-Ordner.
- Nutze das Changelog-System für transparente Entwicklung.
- Beteilige dich an der Community und bringe eigene Ideen ein!

## Automatisiertes Lizenz- und Credits-System

- **Automatische Lizenz-Erkennung & Nennung:**
  - Jedes Asset, Plugin, Spiel und jede Ressource wird mit einer Lizenz versehen (z.B. MIT, CC0, Apache 2.0, kommerziell, etc.).
  - Das System erkennt und zeigt die Lizenz automatisch an – sowohl im Marketplace als auch in der AURAX LIB.
  - Lizenz- und Urheberrechtsinformationen werden in allen relevanten UIs (Asset-Detail, GameCard, PluginCard, etc.) klar und transparent angezeigt.

- **Automatisierte Credits & Verlinkung:**
  - Credits (z.B. Creator, Mitwirkende, verwendete Libraries/Assets) werden automatisch generiert und angezeigt.
  - Jeder Creator, Contributor oder Team kann direkt aus den Credits heraus auf sein Profil verlinkt werden.
  - Credits sind ein fester Bestandteil jeder Asset-, Game- und Plugin-Seite.

- **API & UI:**
  - Die Lizenz- und Credit-Informationen sind über die API abrufbar und können in externe Tools, Engines oder Webseiten integriert werden.
  - Im UI gibt es einen eigenen Bereich für Credits und Lizenzdetails, inkl. direkter Links zu Creator-Profilen.

- **Vorteile:**
  - Rechtssicherheit, Transparenz und Wertschätzung für alle Beteiligten.
  - Förderung von Open Source und Creative Commons.
  - Einfache Nachverfolgung und Community-Building durch verlinkte Profile.
