# Exposé zur Masterthesis

## Arbeitstitel:
**Konzeption und prototypische Implementierung eines gamifizierten Multi-Agenten-Systems zur kollaborativen Ideengenerierung für Game Jams**

## Wissenschaftliche Keywords:
*   Human-AI Co-Creation
*   Game Ideation Networks
*   Generative AI in Game Design
*   Multi-Agent Systems
*   Gamification

---

### 1. Problemstellung und Motivation

Game Jams sind hochdynamische, zeitkritische Events, die als Katalysator für Innovation in der Spieleindustrie dienen. Der Erfolg eines Projekts wird jedoch maßgeblich in der initialen Ideenfindungsphase (Ideation) bestimmt, die oft unter hohem Druck stattfindet und zu suboptimalen oder wenig innovativen Konzepten führen kann. Bestehende Kreativitätstechniken sind oft analog und schlecht in digitale Workflows integriert. Gleichzeitig bieten moderne KI-Modelle (LLMs, RAG, SLMs) ein enormes Potenzial zur Unterstützung kreativer Prozesse, das jedoch bisher kaum in Form von integrierten, community-getriebenen Systemen für den Game-Design-Kontext erschlossen wurde.

Diese Arbeit adressiert diese Lücke durch die Entwicklung eines neuartigen Systems, das die kollaborative Ideenfindung zwischen Mensch und KI systematisiert und fördert.

### 2. Zentrale Forschungsfrage

**Wie können Large Language Models (LLMs) durch den Einsatz spezifischer Prompting-Strategien und die Integration externer Wissensdatenbanken (RAG) dazu befähigt werden, kreative, diverse und wissenschaftlich fundierte Game-Jam-Themen zu generieren?**

Diese übergeordnete Frage gliedert sich in drei untergeordnete Untersuchungsbereiche:

1.  **Kreativität & Diversität:** Welche Prompt-Engineering-Techniken (z.B. Chain-of-Thought, Tree-of-Thought) und welche Kombination von unkonventionellen Wissensdomänen (z.B. Philosophie, Biologie, Kunstgeschichte) führen zur Generierung von thematisch divergenten und inspirierenden Game-Jam-Themen, die über triviale Kombinationen hinausgehen?
2.  **Wissenschaftliche Fundierung:** Wie kann die RAG-Methode (Retrieval-Augmented Generation) genutzt werden, um die generierten Themen mit zitierfähigen, wissenschaftlichen Quellen anzureichern und somit die Erstellung von Serious Games oder forschungsbasierten Projekten zu fördern?
3.  **System-Implementierung:** Wie muss eine Systemarchitektur gestaltet sein, die diesen komplexen Generierungsprozess in einem interaktiven, für Endnutzer zugänglichen Prototyp abbildet und eine iterative Verfeinerung der Themen durch Nutzerfeedback ermöglicht?

### 3. Vorgehen und Methode

#### 3.1. Literaturrecherche und Analyse
*   Analyse bestehender Ideation-Methoden und deren Potenzial für KI-Automatisierung.
*   Recherche aktueller Forschungstrends im Game Design und KI-gestützter Kreativität.
*   Identifikation von Metadaten und Tags (z.B. aus Steam, itch.io) zur Differenzierung und Klassifizierung von Spielkonzepten.

#### 3.2. Konzeption der Systemarchitektur
*   **API-First-Design:** Entwurf einer umfangreichen API, die alle Interaktionen zwischen Frontend, Backend und den KI-Diensten definiert.
*   **Multi-Agenten-System:** Konzeption einer Backend-Architektur, in der spezialisierte KI-Agenten Aufgaben übernehmen:
    *   **Trend-Agent:** Analysiert externe Datenquellen (Reddit, Steam etc.) auf Trends.
    *   **Themen-Agent:** Generiert Kernthemen, auch mit wissenschaftlichem Kontext.
    *   **Quest-Agent:** Formuliert auf Basis des Themas konkrete Aufgaben und Ziele.
    *   **Asset-Agent:** Erstellt Beschreibungen für kontextbezogene 3D-Assets.
*   **Cross-Platform-Ansatz:** Nutzung von Flutter für eine einheitliche Mobile-, Web- und Desktop-UX.
*   **Offline-First-Prinzip:** Gewährleistung der Kernfunktionalität auch ohne aktive Internetverbindung.

#### 3.3. KI-Modell-Integration
*   Evaluation und Integration einer Kombination aus verschiedenen KI-Technologien:
    *   **LLMs (Large Language Models):** Für die Generierung von Texten (Beschreibungen, Quests).
    *   **RAG (Retrieval-Augmented Generation):** Zur Anreicherung der Ideen mit spezifischem Wissen (z.B. wissenschaftliche Paper).
    *   **SLMs (Small Language Models):** Für spezifische, schnelle Aufgaben direkt auf dem Endgerät.
    *   **Domänenspezifische Modelle:** Untersuchung des Potenzials von Modellen wie BrickGPT für spezifische Asset-Typen.

#### 3.4. Gamification-Konzept
*   Entwicklung eines umfassenden Gamification-Systems zur Steigerung des Engagements und der Datenqualität.
*   **Elemente:** Punktevergabe für Vorschläge und Bewertungen, Level-System für Nutzer, Badges für besondere Leistungen, Leaderboards und Team-Funktionen.

#### 3.5. Prototypische Implementierung
*   Entwicklung eines funktionalen Prototyps, der den Kern-Workflow abbildet:
    1.  **Innovationsassistent:** Ein schrittweiser, interaktiver Prozess, bei dem Nutzer durch Auswahl von vorgeschlagenen Begriffen (Genre, Thema, Stil) einen "Jam Seed" generieren.
    2.  **Asset-Generierung:** Basierend auf dem "Jam Seed" werden kontextbezogene 3D-Modelle vorgeschlagen und zur Auswahl gestellt.
    3.  **Community-Hub:** Nutzer können generierte Ideen durchstöbern, bewerten und für eigene Projekte weiterentwickeln.

### 4. Vorläufige Gliederung der Arbeit

1.  **Einleitung**
    *   Motivation und Problemstellung
    *   Forschungsfragen und Zielsetzung
2.  **Grundlagen und Stand der Technik**
    *   2.1 Kreativitätstechniken und Ideengenerierung
    *   2.2 Ablauf und Herausforderungen von Game Jams
    *   2.3 KI-Modelle für kreative Domänen (LLMs, RAG, etc.)
    *   2.4 Gamification als Methode zur Motivationssteigerung
3.  **Konzeption des Multi-Agenten-Systems "Jambam"**
    *   3.1 System- und Softwarearchitektur (API-First, Offline-First)
    *   3.2 Design der einzelnen KI-Agenten und deren Interaktion
    *   3.3 Das "Jam Seed" und "Jam Kit" Datenmodell
    *   3.4 Gamification-Konzept zur Förderung der Human-AI Co-Creation
4.  **Prototypische Implementierung**
    *   4.1 Technologiestack (Flutter, FastAPI, Python/Rust)
    *   4.2 Implementierung des Innovationsassistenten
    *   4.3 Anbindung der KI-Dienste und 3D-Modell-Generierung
5.  **Evaluation**
    *   Durchführung und Auswertung einer qualitativen Nutzerstudie mit der Zielgruppe.
6.  **Zusammenfassung und Ausblick**
    *   Beantwortung der Forschungsfragen
    *   Reflexion und Limitationen
    *   **Ausblick:** Roadmap zur vollwertigen Multi-Engine-Plattform, 3D-Marketplace (OpenUSD) und der Vision der vollständig KI-generierten Entwicklung von 3D-Anwendungen.