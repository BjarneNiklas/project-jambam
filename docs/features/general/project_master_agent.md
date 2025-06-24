# ProjectMasterAgent (Meta-Agent für Game Jams & Spielprojekte)

## Konzept
Der **ProjectMasterAgent** ist der zentrale Meta-Agent, der alle relevanten Informationen, Prototypen, Playtests, Feedback, Forschung, Assets, Teammitglieder, Entscheidungen und Lessons Learned für ein individuelles Spielprojekt oder einen Game Jam aggregiert. Er ist das Gedächtnis, die Steuerzentrale und der Orchestrator für den gesamten Entwicklungsprozess.

## Vorteile
- **Single Source of Truth** für alle Projektdaten
- Kontext-Awareness für alle Agenten und Teammitglieder
- Automatisierte Dokumentation und Nachvollziehbarkeit
- Effiziente Orchestrierung von Multi-Agenten-Workflows
- Personalisierte Vorschläge und adaptive Workflows
- Einfache Integration mit externen Tools (Git, Discord, Miro, Jira, etc.)

## Architektur
- **Domain-Modell:** Aggregiert GameDesignDocument, Prototypen, Playtests, Feedback, Research, Assets, Team, Entscheidungen, Lessons Learned, Status, Versionen
- **Service-Layer:** Methoden zum Laden, Speichern, Aktualisieren, Versionieren, Exportieren, Synchronisieren
- **State Management:** Reaktives State-Management für UI/UX und Agenten
- **API/Mock:** Unterstützt lokale und serverseitige Speicherung sowie externe Synchronisation

## Use Cases
- **Projektstart:** Neues Projekt/Jam anlegen, Team zusammenstellen, Ziele definieren
- **Prototyping:** Prototypen und Versionen verwalten, Playtests dokumentieren
- **Feedback & Playtests:** Feedback sammeln, auswerten und Lessons Learned ableiten
- **Forschung & Assets:** Forschungsergebnisse und generierte Assets zentral speichern
- **Entscheidungen & Retrospektiven:** Entscheidungen und deren Gründe dokumentieren, Lessons Learned festhalten
- **Export & Integration:** Export als JSON, Synchronisation mit externen Tools

## Beispiel-Workflow
1. Projekt/Jam anlegen und initialisieren
2. GameDesignDocument und Team definieren
3. Prototypen entwickeln und Playtests durchführen
4. Feedback und Forschungsergebnisse einpflegen
5. Entscheidungen und Lessons Learned dokumentieren
6. Statuswechsel (z.B. von Prototyping zu Playtesting)
7. Export und Synchronisation mit externen Tools

## Integrationsmöglichkeiten
- **Git:** Versionierung und Backup
- **Discord:** Teamkommunikation und Feedback
- **Miro:** Visuelle Planung und Ideation
- **Jira/Trello:** Aufgabenmanagement
- **Open Source:** Automatisierte Dokumentation und Community-Integration

---

Der ProjectMasterAgent ist der Schlüssel zu einer zukunftssicheren, transparenten und effizienten Game Jam- und Spielentwicklung im Multi-Agenten-System. 