# Agent Context System

## Übersicht

Das **Agent Context System** ermöglicht es Benutzern, die Prompts und Konfigurationen aller AI-Agenten zu bearbeiten, zu speichern und zu verwalten. Es bietet eine intuitive Benutzeroberfläche für die Anpassung der Agent-Verhalten und unterstützt sowohl deutsche als auch englische Prompts für optimale AI-Performance.

## 🎯 Hauptfunktionen

### **🌍 Mehrsprachige Unterstützung**
- **Deutsche Prompts**: Bessere Benutzerfreundlichkeit für deutsche Nutzer
- **Englische Prompts**: Bessere AI-Performance und Genauigkeit
- **Dynamische Sprach-Umschaltung**: Sofortiger Wechsel zwischen Sprachen
- **Sprach-spezifische Defaults**: Optimierte Prompts für jede Sprache

### **✏️ Context-Bearbeitung**
- **Live-Editing**: Direkte Bearbeitung von System- und User-Prompts
- **Parameter-Konfiguration**: Anpassung von Agent-Parametern
- **Beispiel-Management**: Hinzufügen und Bearbeiten von Beispielen
- **Validierung**: Automatische Überprüfung der Eingaben

### **💾 Persistente Speicherung**
- **Local Storage**: Automatisches Speichern aller Änderungen
- **Export/Import**: Teilen und Sichern von Contexts
- **Versionierung**: Tracking von Modifikationen
- **Backup**: Wiederherstellung von Default-Werten

### **🔄 Workflow-Integration**
- **Multi-Agent-System**: Integration mit allen Agenten
- **Orchestrator**: Nahtlose Einbindung in Workflows
- **Real-time Updates**: Sofortige Anwendung von Änderungen
- **Performance-Optimierung**: Effiziente Context-Verwaltung

## 🏗️ Architektur

### **AgentContextManager**
```dart
class AgentContextManager {
  // Sprach-Management
  String currentLanguage;
  Future<void> switchLanguage(String language);
  
  // Context-Management
  Future<Map<String, AgentContext>> loadAllContexts();
  Future<void> saveContext(AgentContext context);
  Future<void> resetContext(String agentId);
  
  // Export/Import
  Future<String> exportContexts();
  Future<void> importContexts(String jsonData);
}
```

### **AgentContext Model**
```dart
class AgentContext {
  final String agentId;
  final String name;
  final String description;
  final String systemPrompt;
  final String userPrompt;
  final Map<String, dynamic> parameters;
  final List<String> examples;
}
```

## 🎨 Benutzeroberfläche

### **Haupt-Screen**
- **Sprach-Umschaltung**: Toggle zwischen Deutsch/Englisch
- **Context-Liste**: Übersicht aller verfügbaren Agenten
- **Modifikations-Indikator**: Zeigt geänderte Contexts an
- **Export/Import**: Buttons für Daten-Management

### **Context-Editor**
- **Expandable Cards**: Übersichtliche Darstellung
- **Live-Editing**: Direkte Bearbeitung von Prompts
- **Parameter-Anzeige**: Strukturierte Darstellung
- **Action-Buttons**: Reset, Duplicate, Export

### **Sprach-Info Banner**
- **Aktuelle Sprache**: Visueller Indikator
- **Performance-Hinweis**: Erklärung der Vorteile
- **Farbkodierung**: Blau für Deutsch, Grün für Englisch

## 🌍 Sprach-Unterstützung

### **Deutsche Prompts**
```dart
// Beispiel: Research Agent (Deutsch)
systemPrompt: '''Du bist ein Research Agent für Game Development. 
Deine Aufgabe ist es, relevante Informationen aus wissenschaftlichen 
und praktischen Quellen zu sammeln...'''
```

### **Englische Prompts**
```dart
// Beispiel: Research Agent (English)
systemPrompt: '''You are a Research Agent for Game Development. 
Your task is to gather relevant information from scientific and 
practical sources...'''
```

### **Sprach-Wechsel**
```dart
// Sprach-Umschaltung
await manager.switchLanguage('en');
ref.read(currentLanguageProvider.notifier).state = 'en';
ref.invalidate(agentContextsProvider);
```

## 🔧 Verwendung

### **Context laden**
```dart
final manager = AgentContextManager();
final contexts = await manager.loadAllContexts();
final researchContext = contexts['research'];
```

### **Context bearbeiten**
```dart
final updatedContext = researchContext.copyWith(
  systemPrompt: 'Neuer System Prompt...',
  userPrompt: 'Neuer User Prompt...',
);
await manager.saveContext(updatedContext);
```

### **Context zurücksetzen**
```dart
await manager.resetContext('research');
```

### **Contexts exportieren**
```dart
final exportData = await manager.exportContexts();
// JSON-String mit allen Contexts und Sprach-Info
```

## 📊 Agent-Typen

### **1. Research Agent**
- **Zweck**: Wissenschaftliche und praktische Forschung
- **Quellen**: ArXiv, PubMed, Steam, Twitch, etc.
- **Ausgabe**: Strukturierte Zusammenfassungen mit Quellen

### **2. Creative Director Agent**
- **Zweck**: Game Design und kreative Richtung
- **Fokus**: Storytelling, UX/UI, Mechaniken
- **Ausgabe**: Game-Konzepte und Design-Richtlinien

### **3. Asset Generation Agent**
- **Zweck**: 3D Models, Texturen, Animationen
- **Technologien**: AI-Generierung, Style Transfer
- **Ausgabe**: Optimierte Assets für Spiele

### **4. Game Engine Agent**
- **Zweck**: Code-Generierung für verschiedene Engines
- **Engines**: Unity, Godot, Bevy, Unreal
- **Ausgabe**: Funktionaler Code mit Best Practices

### **5. Project Master Agent**
- **Zweck**: Projekt-Management und Analyse
- **Tools**: Progress Monitoring, Risk Assessment
- **Ausgabe**: Projekt-Analysen und Empfehlungen

## 🚀 Vorteile

### **Für Entwickler**
- **Flexibilität**: Vollständige Kontrolle über Agent-Verhalten
- **Optimierung**: Sprach-spezifische Performance-Verbesserung
- **Wartbarkeit**: Zentrale Verwaltung aller Prompts
- **Skalierbarkeit**: Einfaches Hinzufügen neuer Agenten

### **Für Benutzer**
- **Benutzerfreundlichkeit**: Intuitive Bearbeitung
- **Transparenz**: Sichtbarkeit aller Agent-Konfigurationen
- **Anpassung**: Personalisierung für spezifische Bedürfnisse
- **Effizienz**: Schnelle Anpassung ohne Code-Änderungen

### **Für das System**
- **Performance**: Optimierte Prompts für bessere AI-Antworten
- **Konsistenz**: Einheitliche Context-Verwaltung
- **Integration**: Nahtlose Einbindung in Multi-Agent-Workflows
- **Zukunftssicherheit**: Erweiterbare Architektur

## 🔮 Zukünftige Erweiterungen

### **Geplante Features**
- **Template-System**: Vorgefertigte Context-Templates
- **Versionierung**: Detaillierte Änderungsverfolgung
- **Collaboration**: Teilen von Contexts zwischen Nutzern
- **AI-Optimierung**: Automatische Prompt-Optimierung

### **Integrationen**
- **Cloud-Sync**: Synchronisation zwischen Geräten
- **Community-Sharing**: Öffentliche Context-Bibliothek
- **Analytics**: Nutzungsstatistiken für Contexts
- **Backup-System**: Automatische Sicherungen

## 📝 Best Practices

### **Prompt-Design**
- **Klare Struktur**: Verwende Markdown für bessere Lesbarkeit
- **Spezifische Anweisungen**: Definiere klare Rollen und Aufgaben
- **Beispiele**: Füge praktische Beispiele hinzu
- **Parameter**: Nutze dynamische Parameter für Flexibilität

### **Sprach-Auswahl**
- **Deutsch**: Für deutsche Nutzer und lokale Projekte
- **Englisch**: Für internationale Projekte und bessere AI-Performance
- **Konsistenz**: Verwende eine Sprache pro Projekt
- **Testing**: Teste Prompts in beiden Sprachen

### **Context-Management**
- **Regelmäßige Backups**: Exportiere wichtige Contexts
- **Versionierung**: Dokumentiere wichtige Änderungen
- **Testing**: Teste Contexts vor Produktiv-Einsatz
- **Optimierung**: Passe Prompts basierend auf Ergebnissen an

---

Das Agent Context System bildet das Fundament für eine flexible, benutzerfreundliche und leistungsstarke Multi-Agent-Plattform, die sowohl deutsche als auch internationale Nutzer optimal unterstützt. 