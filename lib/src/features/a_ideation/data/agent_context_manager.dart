import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Agent Context Manager
/// Verwaltet konfigurierbare Contexts für alle Agenten mit User-Editing-Funktionalität
class AgentContextManager {
  static const String _contextStorageKey = 'agent_contexts';
  static const String _defaultContextsKey = 'default_agent_contexts';
  static const String _languageKey = 'agent_language';
  
  // Default Contexts für alle Agenten - DEUTSCH
  static const Map<String, AgentContext> _defaultContextsDE = {
    'research': AgentContext(
      agentId: 'research',
      name: 'Research Agent',
      description: 'Wissenschaftliche und praktische Forschung',
      systemPrompt: '''Du bist ein Research Agent für Game Development. Deine Aufgabe ist es, relevante Informationen aus wissenschaftlichen und praktischen Quellen zu sammeln.

**Deine Fähigkeiten:**
- Wissenschaftliche Paper-Analyse
- Markt-Research und Trends
- Best Practices Recherche
- Community-Insights sammeln

**Deine Quellen:**
- ArXiv, PubMed, IEEE, ACM
- Steam, Twitch, Reddit, YouTube
- Game Development Blogs
- Community Foren

**Deine Ausgabe:**
- Strukturierte Zusammenfassungen
- Quellenangaben mit Links
- Praktische Anwendbarkeit
- Trend-Analysen''',
      userPrompt: 'Suche nach Informationen zu: {query}',
      parameters: {
        'maxResults': 10,
        'sources': ['academic', 'industry', 'community'],
        'includeTrends': true,
        'includeBestPractices': true,
      },
      examples: [
        'Suche nach aktuellen Game Development Trends',
        'Finde Best Practices für Unity Performance',
        'Analysiere erfolgreiche Indie Games',
      ],
    ),
    
    'creative_director': AgentContext(
      agentId: 'creative_director',
      name: 'Creative Director Agent',
      description: 'Game Design, Storytelling und kreative Richtung',
      systemPrompt: '''Du bist ein Creative Director Agent für Game Development. Deine Aufgabe ist es, innovative Game-Konzepte und kreative Lösungen zu entwickeln.

**Deine Fähigkeiten:**
- Game Design & Mechaniken
- Storytelling & Narrative
- UX/UI Design
- Kreative Problemlösung

**Deine Prinzipien:**
- Innovation vor Konvention
- User Experience im Fokus
- Emotionale Verbindung
- Spielerisches Engagement

**Deine Ausgabe:**
- Strukturierte Game-Konzepte
- Mechanik-Designs
- Story-Elemente
- UX-Richtlinien''',
      userPrompt: 'Erstelle ein Game-Konzept für: {concept}',
      parameters: {
        'genre': 'general',
        'targetAudience': 'general',
        'complexity': 'medium',
        'includeStory': true,
        'includeMechanics': true,
      },
      examples: [
        'Erstelle ein Platformer-Konzept',
        'Designe ein Puzzle-Spiel',
        'Entwickle eine Story für ein RPG',
      ],
    ),
    
    'asset_generation': AgentContext(
      agentId: 'asset_generation',
      name: 'Asset Generation Agent',
      description: '3D Models, Texturen, Animationen und Audio',
      systemPrompt: '''Du bist ein Asset Generation Agent für Game Development. Deine Aufgabe ist es, hochwertige Assets für Spiele zu generieren und zu optimieren.

**Deine Fähigkeiten:**
- 3D Model Generation
- Texture & Material Creation
- Animation Pipeline
- Audio Generation

**Deine Technologien:**
- AI-Generierung (BrickGPT, DreamFusion)
- Style Transfer
- Optimization Tools
- Quality Assurance

**Deine Ausgabe:**
- Optimierte 3D Models
- Konsistente Texturen
- Flüssige Animationen
- Immersive Audio''',
      userPrompt: 'Generiere Assets für: {prompt}',
      parameters: {
        'assetType': 'general',
        'style': 'modern',
        'quality': 'medium',
        'count': 3,
        'includeVariations': true,
      },
      examples: [
        'Generiere Sci-Fi Charaktere',
        'Erstelle Fantasy-Landschaften',
        'Designe UI-Elemente',
      ],
    ),
    
    'game_engine': AgentContext(
      agentId: 'game_engine',
      name: 'Game Engine Agent',
      description: 'Code-Generierung und Engine-Integration',
      systemPrompt: '''Du bist ein Game Engine Agent für Game Development. Deine Aufgabe ist es, hochwertigen Code für verschiedene Game Engines zu generieren.

**Deine Fähigkeiten:**
- Unity (C#) Development
- Godot (GDScript) Development
- Bevy (Rust) Development
- Unreal (C++) Development

**Deine Prinzipien:**
- Clean Code & Best Practices
- Performance Optimization
- Cross-Platform Compatibility
- Maintainable Architecture

**Deine Ausgabe:**
- Funktionaler Code
- Dokumentation
- Performance-Tipps
- Best Practices''',
      userPrompt: 'Generiere Code für {engine}: {feature}',
      parameters: {
        'engine': 'Unity',
        'language': 'csharp',
        'includeComments': true,
        'followBestPractices': true,
        'includeTests': false,
      },
      examples: [
        'Unity Player Movement',
        'Godot UI System',
        'Bevy ECS Setup',
      ],
    ),
    
    'project_master': AgentContext(
      agentId: 'project_master',
      name: 'Project Master Agent',
      description: 'Projekt-Management und Analyse',
      systemPrompt: '''Du bist ein Project Master Agent für Game Development. Deine Aufgabe ist es, Projekte zu analysieren und zu optimieren.

**Deine Fähigkeiten:**
- Projekt-Status Tracking
- Risk Assessment
- Performance Analysis
- Workflow Optimization

**Deine Tools:**
- Progress Monitoring
- Feedback Analysis
- Resource Management
- Timeline Planning

**Deine Ausgabe:**
- Projekt-Analysen
- Verbesserungsvorschläge
- Risk Reports
- Next Steps''',
      userPrompt: 'Analysiere das Projekt: {project}',
      parameters: {
        'includeMetrics': true,
        'includeRisks': true,
        'includeRecommendations': true,
        'timeframe': 'current',
      },
      examples: [
        'Analysiere mein aktuelles Projekt',
        'Bewerte die Projekt-Performance',
        'Identifiziere Risiken',
      ],
    ),
  };

  // Default Contexts für alle Agenten - ENGLISCH (bessere AI-Performance)
  static const Map<String, AgentContext> _defaultContextsEN = {
    'research': AgentContext(
      agentId: 'research',
      name: 'Research Agent',
      description: 'Scientific and practical research for game development',
      systemPrompt: '''You are a Research Agent for Game Development. Your task is to gather relevant information from scientific and practical sources.

**Your Capabilities:**
- Scientific paper analysis
- Market research and trends
- Best practices research
- Community insights gathering

**Your Sources:**
- ArXiv, PubMed, IEEE, ACM
- Steam, Twitch, Reddit, YouTube
- Game Development Blogs
- Community Forums

**Your Output:**
- Structured summaries
- Source citations with links
- Practical applicability
- Trend analysis''',
      userPrompt: 'Search for information about: {query}',
      parameters: {
        'maxResults': 10,
        'sources': ['academic', 'industry', 'community'],
        'includeTrends': true,
        'includeBestPractices': true,
      },
      examples: [
        'Search for current game development trends',
        'Find best practices for Unity performance',
        'Analyze successful indie games',
      ],
    ),
    
    'creative_director': AgentContext(
      agentId: 'creative_director',
      name: 'Creative Director Agent',
      description: 'Game design, storytelling and creative direction',
      systemPrompt: '''You are a Creative Director Agent for Game Development. Your task is to develop innovative game concepts and creative solutions.

**Your Capabilities:**
- Game Design & Mechanics
- Storytelling & Narrative
- UX/UI Design
- Creative Problem Solving

**Your Principles:**
- Innovation over convention
- User experience focus
- Emotional connection
- Engaging gameplay

**Your Output:**
- Structured game concepts
- Mechanics design
- Story elements
- UX guidelines''',
      userPrompt: 'Create a game concept for: {concept}',
      parameters: {
        'genre': 'general',
        'targetAudience': 'general',
        'complexity': 'medium',
        'includeStory': true,
        'includeMechanics': true,
      },
      examples: [
        'Create a platformer concept',
        'Design a puzzle game',
        'Develop a story for an RPG',
      ],
    ),
    
    'asset_generation': AgentContext(
      agentId: 'asset_generation',
      name: 'Asset Generation Agent',
      description: '3D models, textures, animations and audio',
      systemPrompt: '''You are an Asset Generation Agent for Game Development. Your task is to generate and optimize high-quality assets for games.

**Your Capabilities:**
- 3D Model Generation
- Texture & Material Creation
- Animation Pipeline
- Audio Generation

**Your Technologies:**
- AI Generation (BrickGPT, DreamFusion)
- Style Transfer
- Optimization Tools
- Quality Assurance

**Your Output:**
- Optimized 3D models
- Consistent textures
- Smooth animations
- Immersive audio''',
      userPrompt: 'Generate assets for: {prompt}',
      parameters: {
        'assetType': 'general',
        'style': 'modern',
        'quality': 'medium',
        'count': 3,
        'includeVariations': true,
      },
      examples: [
        'Generate sci-fi characters',
        'Create fantasy landscapes',
        'Design UI elements',
      ],
    ),
    
    'game_engine': AgentContext(
      agentId: 'game_engine',
      name: 'Game Engine Agent',
      description: 'Code generation and engine integration',
      systemPrompt: '''You are a Game Engine Agent for Game Development. Your task is to generate high-quality code for various game engines.

**Your Capabilities:**
- Unity (C#) Development
- Godot (GDScript) Development
- Bevy (Rust) Development
- Unreal (C++) Development

**Your Principles:**
- Clean Code & Best Practices
- Performance Optimization
- Cross-Platform Compatibility
- Maintainable Architecture

**Your Output:**
- Functional code
- Documentation
- Performance tips
- Best practices''',
      userPrompt: 'Generate code for {engine}: {feature}',
      parameters: {
        'engine': 'Unity',
        'language': 'csharp',
        'includeComments': true,
        'followBestPractices': true,
        'includeTests': false,
      },
      examples: [
        'Unity Player Movement',
        'Godot UI System',
        'Bevy ECS Setup',
      ],
    ),
    
    'project_master': AgentContext(
      agentId: 'project_master',
      name: 'Project Master Agent',
      description: 'Project management and analysis',
      systemPrompt: '''You are a Project Master Agent for Game Development. Your task is to analyze and optimize projects.

**Your Capabilities:**
- Project Status Tracking
- Risk Assessment
- Performance Analysis
- Workflow Optimization

**Your Tools:**
- Progress Monitoring
- Feedback Analysis
- Resource Management
- Timeline Planning

**Your Output:**
- Project analysis
- Improvement suggestions
- Risk reports
- Next steps''',
      userPrompt: 'Analyze the project: {project}',
      parameters: {
        'includeMetrics': true,
        'includeRisks': true,
        'includeRecommendations': true,
        'timeframe': 'current',
      },
      examples: [
        'Analyze my current project',
        'Evaluate project performance',
        'Identify risks',
      ],
    ),
  };

  /// Aktuelle Sprache
  String _currentLanguage = 'de';

  /// Konstruktor
  AgentContextManager() {
    _loadLanguage();
  }

  /// Lädt die gespeicherte Sprache
  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString(_languageKey) ?? 'de';
  }

  /// Speichert die aktuelle Sprache
  Future<void> _saveLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, _currentLanguage);
  }

  /// Wechselt die Sprache
  Future<void> switchLanguage(String language) async {
    if (language != 'de' && language != 'en') {
      throw Exception('Unsupported language: $language');
    }
    
    _currentLanguage = language;
    await _saveLanguage();
  }

  /// Gibt die aktuelle Sprache zurück
  String get currentLanguage => _currentLanguage;

  /// Gibt die Default Contexts für die aktuelle Sprache zurück
  Map<String, AgentContext> get _defaultContexts {
    return _currentLanguage == 'de' ? _defaultContextsDE : _defaultContextsEN;
  }

  /// Lädt alle Agent Contexts
  Future<Map<String, AgentContext>> loadAllContexts() async {
    final prefs = await SharedPreferences.getInstance();
    final contextsJson = prefs.getString(_contextStorageKey);
    
    if (contextsJson == null) {
      // Erste Ausführung: Speichere Default Contexts
      await _saveDefaultContexts();
      return _defaultContexts;
    }
    
    try {
      final Map<String, dynamic> contextsMap = jsonDecode(contextsJson);
      final contexts = <String, AgentContext>{};
      
      for (final entry in contextsMap.entries) {
        contexts[entry.key] = AgentContext.fromJson(entry.value);
      }
      
      return contexts;
    } catch (e) {
      // Bei Fehler: Verwende Defaults
      return _defaultContexts;
    }
  }

  /// Lädt einen spezifischen Agent Context
  Future<AgentContext?> loadContext(String agentId) async {
    final contexts = await loadAllContexts();
    return contexts[agentId];
  }

  /// Speichert einen Agent Context
  Future<void> saveContext(AgentContext context) async {
    final contexts = await loadAllContexts();
    contexts[context.agentId] = context;
    
    final prefs = await SharedPreferences.getInstance();
    final contextsMap = <String, dynamic>{};
    
    for (final entry in contexts.entries) {
      contextsMap[entry.key] = entry.value.toJson();
    }
    
    await prefs.setString(_contextStorageKey, jsonEncode(contextsMap));
  }

  /// Speichert alle Default Contexts
  Future<void> _saveDefaultContexts() async {
    final prefs = await SharedPreferences.getInstance();
    final contextsMap = <String, dynamic>{};
    
    for (final entry in _defaultContexts.entries) {
      contextsMap[entry.key] = entry.value.toJson();
    }
    
    await prefs.setString(_defaultContextsKey, jsonEncode(contextsMap));
  }

  /// Reset eines spezifischen Contexts auf Default
  Future<void> resetContext(String agentId) async {
    final defaultContext = _defaultContexts[agentId];
    if (defaultContext != null) {
      await saveContext(defaultContext);
    }
  }

  /// Reset aller Contexts auf Default
  Future<void> resetAllContexts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_contextStorageKey);
  }

  /// Lädt Default Contexts für eine spezifische Sprache
  Future<Map<String, AgentContext>> loadDefaultContextsForLanguage(String language) async {
    return language == 'de' ? _defaultContextsDE : _defaultContextsEN;
  }

  /// Exportiert alle Contexts
  Future<String> exportContexts() async {
    final contexts = await loadAllContexts();
    final exportData = <String, dynamic>{
      'language': _currentLanguage,
      'contexts': <String, dynamic>{},
    };
    
    for (final entry in contexts.entries) {
      exportData['contexts'][entry.key] = entry.value.toJson();
    }
    
    return jsonEncode(exportData);
  }

  /// Importiert Contexts
  Future<void> importContexts(String jsonData) async {
    try {
      final Map<String, dynamic> data = jsonDecode(jsonData);
      final contextsMap = data['contexts'] as Map<String, dynamic>;
      final contexts = <String, AgentContext>{};
      
      for (final entry in contextsMap.entries) {
        contexts[entry.key] = AgentContext.fromJson(entry.value);
      }
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_contextStorageKey, jsonEncode(contextsMap));
      
      // Setze Sprache falls angegeben
      if (data.containsKey('language')) {
        await switchLanguage(data['language']);
      }
    } catch (e) {
      throw Exception('Invalid context data: $e');
    }
  }

  /// Validiert einen Context
  bool validateContext(AgentContext context) {
    return context.agentId.isNotEmpty &&
           context.name.isNotEmpty &&
           context.systemPrompt.isNotEmpty &&
           context.userPrompt.isNotEmpty;
  }

  /// Erstellt einen neuen Context
  Future<AgentContext> createContext({
    required String agentId,
    required String name,
    required String description,
    required String systemPrompt,
    required String userPrompt,
    Map<String, dynamic>? parameters,
    List<String>? examples,
  }) async {
    final context = AgentContext(
      agentId: agentId,
      name: name,
      description: description,
      systemPrompt: systemPrompt,
      userPrompt: userPrompt,
      parameters: parameters ?? {},
      examples: examples ?? [],
    );
    
    if (validateContext(context)) {
      await saveContext(context);
      return context;
    } else {
      throw Exception('Invalid context data');
    }
  }

  /// Aktualisiert einen Context
  Future<void> updateContext(AgentContext context) async {
    if (validateContext(context)) {
      await saveContext(context);
    } else {
      throw Exception('Invalid context data');
    }
  }

  /// Löscht einen Context (setzt auf Default zurück)
  Future<void> deleteContext(String agentId) async {
    await resetContext(agentId);
  }

  /// Prüft ob ein Context modifiziert wurde
  Future<bool> isContextModified(String agentId) async {
    final currentContext = await loadContext(agentId);
    final defaultContext = _defaultContexts[agentId];
    
    if (currentContext == null || defaultContext == null) {
      return false;
    }
    
    return currentContext.systemPrompt != defaultContext.systemPrompt ||
           currentContext.userPrompt != defaultContext.userPrompt ||
           !_mapEquals(currentContext.parameters, defaultContext.parameters);
  }

  /// Vergleicht zwei Maps
  bool _mapEquals(Map<String, dynamic>? a, Map<String, dynamic>? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;
    
    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) {
        return false;
      }
    }
    
    return true;
  }

  /// Gibt Sprach-Informationen zurück
  Map<String, String> getLanguageInfo() {
    return {
      'de': 'Deutsch (Bessere Benutzerfreundlichkeit)',
      'en': 'English (Bessere AI-Performance)',
    };
  }

  /// Prüft ob die aktuelle Sprache Deutsch ist
  bool get isGerman => _currentLanguage == 'de';

  /// Prüft ob die aktuelle Sprache Englisch ist
  bool get isEnglish => _currentLanguage == 'en';
}

/// Datenmodell für Agent Contexts
class AgentContext {
  final String agentId;
  final String name;
  final String description;
  final String systemPrompt;
  final String userPrompt;
  final Map<String, dynamic> parameters;
  final List<String> examples;
  final DateTime? lastModified;

  const AgentContext({
    required this.agentId,
    required this.name,
    required this.description,
    required this.systemPrompt,
    required this.userPrompt,
    required this.parameters,
    required this.examples,
    this.lastModified,
  });

  Map<String, dynamic> toJson() {
    return {
      'agentId': agentId,
      'name': name,
      'description': description,
      'systemPrompt': systemPrompt,
      'userPrompt': userPrompt,
      'parameters': parameters,
      'examples': examples,
      'lastModified': lastModified?.toIso8601String(),
    };
  }

  factory AgentContext.fromJson(Map<String, dynamic> json) {
    return AgentContext(
      agentId: json['agentId'],
      name: json['name'],
      description: json['description'],
      systemPrompt: json['systemPrompt'],
      userPrompt: json['userPrompt'],
      parameters: Map<String, dynamic>.from(json['parameters'] ?? {}),
      examples: List<String>.from(json['examples'] ?? []),
      lastModified: json['lastModified'] != null 
          ? DateTime.parse(json['lastModified']) 
          : null,
    );
  }

  AgentContext copyWith({
    String? agentId,
    String? name,
    String? description,
    String? systemPrompt,
    String? userPrompt,
    Map<String, dynamic>? parameters,
    List<String>? examples,
    DateTime? lastModified,
  }) {
    return AgentContext(
      agentId: agentId ?? this.agentId,
      name: name ?? this.name,
      description: description ?? this.description,
      systemPrompt: systemPrompt ?? this.systemPrompt,
      userPrompt: userPrompt ?? this.userPrompt,
      parameters: parameters ?? this.parameters,
      examples: examples ?? this.examples,
      lastModified: lastModified ?? DateTime.now(),
    );
  }

  /// Formatiert den User Prompt mit Parametern
  String formatUserPrompt(Map<String, dynamic> parameters) {
    String prompt = userPrompt;
    
    for (final entry in parameters.entries) {
      prompt = prompt.replaceAll('{${entry.key}}', entry.value.toString());
    }
    
    return prompt;
  }

  /// Prüft ob der Context modifiziert wurde
  bool get isModified {
    return lastModified != null;
  }

  /// Zeigt an wann der Context zuletzt modifiziert wurde
  String get lastModifiedText {
    if (lastModified == null) return 'Default';
    return 'Modifiziert: ${lastModified!.day}.${lastModified!.month}.${lastModified!.year}';
  }
} 