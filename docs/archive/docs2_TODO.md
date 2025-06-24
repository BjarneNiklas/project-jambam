# LUVY Engine – ToDo-Liste (Stand: 25.05.2025)

---

## [CORE]
- [x] Core-Modul anlegen und dokumentieren
- [x] API-Skelett (OpenAPI) für Core anlegen
- [x] EngineStatus-Klasse und Test implementieren
- [x] Plug-in-System als Architektur-Entwurf spezifizieren (Architektur-Dokument und Basis-Implementierung von IPlugin und PluginManager erstellt)
- [x] Dependency Injection (DI) Konzept und Beispiel implementieren (DependencyInjector-Klasse erstellt)
- [x] API-Registry für alle Module anlegen (ApiRegistry-Klasse erstellt)

---

## [ENGINES]
- [x] Engines-Modul anlegen und dokumentieren
- [x] API-Skelett (OpenAPI) für Engines anlegen
- [x] EnginesManager-Klasse und Test implementieren
- [x] Adapter-Architektur für Bevy, Godot, Unity, Broxel spezifizieren (Architektur-Dokument, IEngineAdapter und EnginesManager angepasst, Tests aktualisiert)
- [ ] Import/Export-Schnittstellen für Projekte/Assets zwischen Engines entwerfen
- [ ] Engines-Auswahl im UI mit echten Datenquellen verbinden

---

## [MINDFLOW (KI)]
- [x] Mindflow-Modul anlegen und dokumentieren
- [x] API-Skelett (OpenAPI) für Mindflow anlegen
- [x] AIAssistant-Klasse und Test implementieren
- [ ] KI-Adapter für OpenAI, HuggingFace, eigene Modelle entwerfen
- [ ] Prompt2World/Asset-Generierung spezifizieren
- [ ] Game Design Assistant (UI/Backend) konzipieren
- [ ] KI-Integration ins UI (z.B. Chat, Vorschläge) vorbereiten

---

## [GAMEJAM]
- [x] GameJam-Modul anlegen und dokumentieren
- [x] API-Skelett (OpenAPI) für GameJam anlegen
- [x] GameJamManager-Klasse und Test implementieren
- [x] Game Jam Generator (Themen, Teams, Bewertung, Submission) spezifizieren (Backend-Logik und API implementiert)
- [x] Community- und Zuschauer-Features (aktive & passive Teilnahme) entwerfen (Backend-Logik und API implementiert)
- [ ] Game Jam Management ins UI integrieren (Backend Manager stellt nun Daten bereit)

---

## [GAMELOGIC]
- [x] Gamelogic-Modul anlegen und dokumentieren
- [ ] API-Skelett (OpenAPI) für Gamelogic anlegen
- [ ] Beispiel-Logik für Genres, Simulationen, Robotik, Bauwesen etc. entwerfen
- [ ] Plug-in-System für Genres/Logik spezifizieren

---

## [DATA]
- [x] Data-Modul anlegen und dokumentieren
- [x] API-Skelett (OpenAPI) für Data anlegen
- [x] DatabaseStatus-Klasse und Test implementieren
- [ ] SQLite-Anbindung (offline-first) implementieren
- [ ] Supabase/PostgreSQL-Sync vorbereiten
- [ ] Repository Pattern für Datenzugriff umsetzen
- [ ] Migrationen und Security (Verschlüsselung, DSGVO) spezifizieren

---

## [UI]
- [x] UI-Modul anlegen und dokumentieren
- [x] Flutter-Projekt initialisieren (im ui/-Verzeichnis)
- [x] main.dart mit Listen für Engines, Game Jams, Plugins anlegen
- [ ] Manager-Klassen als echte Datenquelle ins UI einbinden (z.B. via Provider/Riverpod)
- [ ] Navigation (Tabs, Drawer, Detailseiten) ergänzen
- [ ] Theme-Switching und Accessibility-Features implementieren
- [ ] KI- und Game Jam-Features im UI sichtbar machen
- [ ] Onboarding, Tutorials und Community-Features ins UI integrieren

---

## [PLUGINS]
- [x] Plugins-Modul anlegen und dokumentieren
- [x] API-Skelett (OpenAPI) für Plugins anlegen
- [x] PluginsManager-Klasse und Test implementieren
- [ ] Plug-in-System für Engines, KI, ProcGen, Exporter/Importer spezifizieren
- [ ] Plug-in-Marktplatz (UI/Backend) konzipieren

---

## [DOKUMENTATION & COMMUNITY]
- [x] README.md, ARCHITECTURE.md, PRINCIPLES.md, COMMUNITY.md anlegen und befüllen
- [ ] API-Dokumentation (OpenAPI, Swagger UI) generieren und bereitstellen
- [ ] Tutorials und interaktive Guides erstellen
- [ ] Community-Events, Voting, Feedback-Mechanismen spezifizieren
- [ ] Mehrsprachigkeit und Barrierefreiheit dokumentieren

---

## [INFRASTRUKTUR & DX]
- [x] Test-First- und API-First-Struktur für alle Module anlegen
- [x] pubspec.yaml für Dart/Flutter und Tests einrichten
- [ ] CI/CD-Pipeline für Tests, Builds und Deployments aufsetzen
- [ ] Hot Reload, DevTools und Telemetrie (Opt-in) integrieren
- [ ] Security- und Privacy-Standards (OAuth2, JWT, DSGVO) umsetzen

---

## [ZUKUNFT / RESEARCH]
- [ ] Broxel Engine (eigene Voxel-Engine) als Forschungsprojekt weiterentwickeln
- [ ] Kooperationen mit Minetest/Luanti prüfen
- [ ] Hybride Genres, Game Jam Generator, KI-gestützte Genre-Mixes erforschen
- [ ] Asset Library, Modding, User-Generated Content ausbauen

---

## [MINIGAMES]
- [x] 30+ Minigames konzipiert und als Datenmodelle/Markdown dokumentiert
- [x] MinigamesPage mit Filter, Badges, Leaderboard-Platzhalter
- [ ] Minigames-Analytics, Leaderboards, Community-Voting integrieren
- [ ] Minigames als Testfeld für KI, Assetdaten und neue Features nutzen

---

## [ONBOARDING & COMMUNITY]
- [x] Interaktives Onboarding-Widget (Stepper/Carousel) mit LUVY-Werten, Minigame-Intro, Community-Events, Discord/Matrix-Links, Abschluss
- [x] Onboarding jederzeit über Drawer aufrufbar
- [x] Feedback-Button als FloatingActionButton im Onboarding und Haupt-UI
- [ ] Onboarding um Profilanlage, Interessenwahl, Tutorials erweitern
- [ ] Discord/Matrix-Integration weiter ausbauen (OAuth, Live-Widget)

---

## [TEAM-FINDER & PROJECT-BOARDS]
- [x] TeamFinderPage (MVP) mit Demo-Teams, Join-Button, Info-Dialog
- [x] ProjectBoardsPage (MVP) mit Demo-Projekten, Status, Owner, Join-Button
- [ ] Matching, Skill-Badges, Team-Chat, Kanban-Board, Aufgabenverwaltung

---

## [FEATURE VOTING]
- [x] FeatureVotingPage (MVP) mit Upvote, Status, Demo-Features
- [ ] Kommentare, Downvote, Feature-Status-Workflow, Integration in Project-Boards

---

## [ASSET-BROWSER & CREATOR-PROFILE]
- [ ] Asset-Browser mit 3D-Preview, Filter, Lizenzanzeige, Upload (MVP prüfen/ergänzen)
- [ ] Creator-Profile mit Portfolio, Social, Badges, Kollaborations-Features (MVP prüfen/ergänzen)

---

## [DONATION & SUPPORT]
- [ ] Moderne Donation-/Support-Seite: Plattform, Studio, Creator, Projekt; Einmalig, monatlich, Kauf, Community-Pool
- [ ] Transparenz, Community-Goals, Badges, Leaderboard, Zahlungsanbieter-Integration (Stripe, PayPal, Patreon, Steady)

---

## [BRANDING & VISION]
- [x] README und Branding-Doku aktualisiert (AURAX Plattform, LUVY Engine, Broxel, KI, Community)
- [x] LUVY-Buchstaben/Branding als Markdown dokumentiert
- [ ] Onboarding, Footer, About-Dialog mit Branding/Vision verknüpfen

---

## [ANALYTICS & KI]
- [ ] Analytics-Dashboard für Creator, Community, Plattform (Trends, Engagement, Top-Assets)
- [ ] KI-gestützte Empfehlungen, Tagging, Trend-Prognosen, Level-Generierung (LegoGPT, Broxel)
- [ ] Minigames und Games als Datenquelle für KI-Training nutzen

---

## [DOKUMENTATION & PITCHDECK]
- [x] README.md (DE/EN), docs/minigames_ideen.md, docs/luvy_buchstaben.md aktualisiert
- [x] Visuelle Übersicht (Mermaid-Diagramm) im README
- [ ] Pitchdeck, Onepager, Roadmap, Teamvorstellung weiter ausbauen

---

**Legende:**
- [x] = erledigt
- [ ] = offen
