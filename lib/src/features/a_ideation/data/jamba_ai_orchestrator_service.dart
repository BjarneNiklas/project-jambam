import '../domain/multi_agent_system.dart';
import 'agent_orchestrator_service.dart';
import 'research_agent_service.dart' as research_data;
import 'creative_director_agent_service.dart';
import 'asset_generation_agent_service.dart' as asset_data;
import 'game_engine_agent_service.dart';
import 'project_master_agent_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'asset_generation_agent_service.dart' show AssetGenerationRequest;

/// Jamba AI Orchestrator Service
/// Zentrale KI-Schnittstelle, die das Multi-Agenten-System orchestriert
class JambaAIOrchestratorService {
  final AgentOrchestratorService _orchestrator;
  final research_data.ResearchAgentService _researchAgent;
  final CreativeDirectorAgentService _creativeDirector;
  final asset_data.AssetGenerationAgentService _assetAgent;
  final GameEngineAgentService _engineAgent;
  final ProjectMasterAgentService _projectMaster;

  JambaAIOrchestratorService()
      : _orchestrator = AgentOrchestratorService(),
        _researchAgent = research_data.ResearchAgentService(),
        _creativeDirector = CreativeDirectorAgentService(),
        _assetAgent = asset_data.AssetGenerationAgentService(),
        _engineAgent = GameEngineAgentService(),
        _projectMaster = ProjectMasterAgentService();

  /// Haupt-Methode für Jamba AI Anfragen
  Future<JambaAIResponse> processRequest(String userMessage) async {
    final request = _analyzeRequest(userMessage);
    final response = await _orchestrateAgents(request);
    return response;
  }

  /// Analysiert die User-Anfrage und bestimmt benötigte Agenten
  AIRequest _analyzeRequest(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();
    
    // Bestimme Request-Typ und benötigte Agenten
    if (lowerMessage.contains('konzept') || lowerMessage.contains('idee') || lowerMessage.contains('design')) {
      return AIRequest(
        type: AIRequestType.gameConcept,
        message: userMessage,
        requiredAgents: ['research', 'creative_director'],
        optionalAgents: ['asset_generation'],
      );
    }
    
    if (lowerMessage.contains('code') || lowerMessage.contains('unity') || lowerMessage.contains('godot') || lowerMessage.contains('bevy')) {
      return AIRequest(
        type: AIRequestType.codeGeneration,
        message: userMessage,
        requiredAgents: ['game_engine', 'research'],
        optionalAgents: ['asset_generation'],
      );
    }
    
    if (lowerMessage.contains('asset') || lowerMessage.contains('textur') || lowerMessage.contains('modell') || lowerMessage.contains('animation')) {
      return AIRequest(
        type: AIRequestType.assetGeneration,
        message: userMessage,
        requiredAgents: ['asset_generation', 'creative_director'],
        optionalAgents: ['research'],
      );
    }
    
    if (lowerMessage.contains('analyse') || lowerMessage.contains('bewertung') || lowerMessage.contains('feedback')) {
      return AIRequest(
        type: AIRequestType.projectAnalysis,
        message: userMessage,
        requiredAgents: ['project_master', 'research'],
        optionalAgents: ['creative_director'],
      );
    }
    
    if (lowerMessage.contains('inspiration') || lowerMessage.contains('trend') || lowerMessage.contains('forschung')) {
      return AIRequest(
        type: AIRequestType.research,
        message: userMessage,
        requiredAgents: ['research'],
        optionalAgents: ['creative_director'],
      );
    }
    
    // Default: General Help
    return AIRequest(
      type: AIRequestType.generalHelp,
      message: userMessage,
      requiredAgents: ['creative_director'],
      optionalAgents: ['research'],
    );
  }

  /// Orchestriert die Agenten basierend auf der Anfrage mit intelligenter Priorisierung
  Future<JambaAIResponse> _orchestrateAgents(AIRequest request) async {
    final responses = <AgentResponse>[];
    
    // 1. PRIORITÄT 1: Kritische Agenten (müssen zuerst fertig sein)
    final criticalAgents = _getCriticalAgents(request);
    if (criticalAgents.isNotEmpty) {
      final criticalFutures = criticalAgents.map((agentId) async {
        try {
          return await _executeAgent(agentId, request);
        } catch (e) {
          return AgentResponse(
            agentId: agentId,
            success: false,
            content: 'Kritischer Fehler beim Agenten: $e',
            metadata: {'priority': 'critical', 'error': e.toString()},
          );
        }
      });
      
      final criticalResponses = await Future.wait(criticalFutures);
      responses.addAll(criticalResponses);
      
      // Prüfe ob kritische Agenten fehlgeschlagen sind
      final criticalFailures = criticalResponses.where((r) => !r.success).toList();
      if (criticalFailures.isNotEmpty) {
        return _createErrorResponse(request, criticalFailures);
      }
    }
    
    // 2. PRIORITÄT 2: Required Agents (parallel, aber nach kritischen)
    final requiredAgents = _getRequiredAgents(request);
    if (requiredAgents.isNotEmpty) {
      final requiredFutures = requiredAgents.map((agentId) async {
        try {
          return await _executeAgent(agentId, request);
        } catch (e) {
          return AgentResponse(
            agentId: agentId,
            success: false,
            content: 'Fehler beim Required Agenten: $e',
            metadata: {'priority': 'required', 'error': e.toString()},
          );
        }
      });
      
      final requiredResponses = await Future.wait(requiredFutures);
      responses.addAll(requiredResponses);
    }
    
    // 3. PRIORITÄT 3: Optional Agents (parallel, niedrigste Priorität)
    final optionalAgents = _getOptionalAgents(request);
    if (optionalAgents.isNotEmpty) {
      final optionalFutures = optionalAgents.map((agentId) async {
        try {
          return await _executeAgent(agentId, request);
        } catch (e) {
          // TODO: Replace with logging framework
          print('Optional agent $agentId failed: $e');
          return null; // Optional agents können fehlschlagen
        }
      });
      
      final optionalResponses = await Future.wait(optionalFutures);
      responses.addAll(optionalResponses.where((r) => r != null).cast<AgentResponse>());
    }
    
    // 4. Konsolidiere alle Antworten mit Prioritäts-Berücksichtigung
    return _consolidateResponsesWithPriority(request, responses);
  }

  /// Bestimmt kritische Agenten (müssen zuerst und erfolgreich sein)
  List<String> _getCriticalAgents(AIRequest request) {
    switch (request.type) {
      case AIRequestType.gameConcept:
        return ['creative_director']; // Design ist kritisch für Konzepte
      case AIRequestType.codeGeneration:
        return ['game_engine']; // Engine-Code ist kritisch
      case AIRequestType.assetGeneration:
        return ['asset_generation']; // Asset-Generierung ist kritisch
      case AIRequestType.projectAnalysis:
        return ['project_master']; // Projekt-Status ist kritisch
      case AIRequestType.research:
        return ['research']; // Forschung ist kritisch
      case AIRequestType.generalHelp:
        return ['creative_director']; // Kreative Hilfe ist kritisch
    }
  }

  /// Bestimmt required Agenten (wichtig, aber nicht kritisch)
  List<String> _getRequiredAgents(AIRequest request) {
    final allRequired = request.requiredAgents.toSet();
    final critical = _getCriticalAgents(request).toSet();
    return allRequired.difference(critical).toList();
  }

  /// Bestimmt optional Agenten (nice-to-have)
  List<String> _getOptionalAgents(AIRequest request) {
    return request.optionalAgents;
  }

  /// Erstellt eine Fehler-Antwort bei kritischen Fehlern
  JambaAIResponse _createErrorResponse(AIRequest request, List<AgentResponse> failures) {
    final failureNames = failures.map((f) => _getAgentDisplayName(f.agentId)).join(', ');
    
    return JambaAIResponse(
      content: '''❌ **Kritischer Fehler**

Die folgenden kritischen Agenten sind fehlgeschlagen:
$failureNames

**Was du tun kannst:**
• Überprüfe deine Internetverbindung
• Versuche es später erneut
• Formuliere deine Anfrage anders
• Kontaktiere den Support''',
      suggestions: [
        'Versuche es erneut',
        'Formuliere die Anfrage anders',
        'Kontaktiere den Support',
      ],
      usedAgents: [],
      failedAgents: failures.map((f) => f.agentId).toList(),
      metadata: {
        'requestType': request.type.name,
        'criticalFailure': true,
        'failureCount': failures.length,
      },
    );
  }

  /// Konsolidiert Antworten mit Prioritäts-Berücksichtigung
  JambaAIResponse _consolidateResponsesWithPriority(AIRequest request, List<AgentResponse> responses) {
    final successfulResponses = responses.where((r) => r.success).toList();
    final failedResponses = responses.where((r) => !r.success).toList();
    
    // Sortiere nach Priorität für bessere Konsolidierung
    successfulResponses.sort((a, b) {
      final priorityA = _getAgentPriority(a.agentId);
      final priorityB = _getAgentPriority(b.agentId);
      return priorityA.compareTo(priorityB);
    });
    
    // Erstelle konsolidierte Antwort basierend auf Request-Typ
    String mainContent;
    List<String> suggestions = [];
    
    switch (request.type) {
      case AIRequestType.gameConcept:
        mainContent = _consolidateGameConceptWithPriority(successfulResponses);
        suggestions = [
          'Erstelle ein detailliertes Design-Dokument',
          'Generiere erste Prototypen',
          'Suche nach ähnlichen Spielen',
          'Plane das Level-Design',
        ];
        break;
        
      case AIRequestType.codeGeneration:
        mainContent = _consolidateCodeGenerationWithPriority(successfulResponses);
        suggestions = [
          'Teste den Code in der Engine',
          'Erweitere um weitere Features',
          'Optimiere die Performance',
          'Dokumentiere den Code',
        ];
        break;
        
      case AIRequestType.assetGeneration:
        mainContent = _consolidateAssetGenerationWithPriority(successfulResponses);
        suggestions = [
          'Generiere weitere Assets',
          'Erstelle Animationen',
          'Optimiere die Texturen',
          'Integriere in das Projekt',
        ];
        break;
        
      case AIRequestType.projectAnalysis:
        mainContent = _consolidateProjectAnalysisWithPriority(successfulResponses);
        suggestions = [
          'Implementiere die Verbesserungen',
          'Plane die nächsten Schritte',
          'Führe Playtests durch',
          'Aktualisiere das Design',
        ];
        break;
        
      case AIRequestType.research:
        mainContent = _consolidateResearchWithPriority(successfulResponses);
        suggestions = [
          'Vertiefe die Forschung',
          'Analysiere die Trends',
          'Erstelle ein Konzept',
          'Teile die Erkenntnisse',
        ];
        break;
        
      default:
        mainContent = _consolidateGeneralHelpWithPriority(successfulResponses);
        suggestions = [
          'Erstelle ein neues Projekt',
          'Suche nach Inspiration',
          'Lerne neue Techniken',
          'Verbinde dich mit der Community',
        ];
    }
    
    return JambaAIResponse(
      content: mainContent,
      suggestions: suggestions,
      usedAgents: successfulResponses.map((r) => r.agentId).toList(),
      failedAgents: failedResponses.map((r) => r.agentId).toList(),
      metadata: {
        'requestType': request.type.name,
        'totalAgents': responses.length,
        'successfulAgents': successfulResponses.length,
        'failedAgents': failedResponses.length,
        'executionOrder': successfulResponses.map((r) => r.agentId).toList(),
      },
    );
  }

  /// Prioritäts-Level für Agenten (niedrigere Zahl = höhere Priorität)
  int _getAgentPriority(String agentId) {
    switch (agentId) {
      case 'creative_director': return 1; // Höchste Priorität
      case 'game_engine': return 2;
      case 'asset_generation': return 3;
      case 'project_master': return 4;
      case 'research': return 5; // Niedrigste Priorität
      default: return 6;
    }
  }

  /// Display-Name für Agenten
  String _getAgentDisplayName(String agentId) {
    switch (agentId) {
      case 'creative_director': return 'Creative Director';
      case 'game_engine': return 'Game Engine';
      case 'asset_generation': return 'Asset Generation';
      case 'project_master': return 'Project Master';
      case 'research': return 'Research';
      default: return agentId;
    }
  }

  // Priorisierte Konsolidierungs-Methoden
  String _consolidateGameConceptWithPriority(List<AgentResponse> responses) {
    final design = responses.where((r) => r.agentId == 'creative_director').firstOrNull;
    final research = responses.where((r) => r.agentId == 'research').firstOrNull;
    final assets = responses.where((r) => r.agentId == 'asset_generation').firstOrNull;
    
    final buffer = StringBuffer();
    buffer.writeln('🎮 **Game Concept Analysis**\n');
    
    // Priorität 1: Design (kritisch)
    if (design != null) {
      buffer.writeln('🎭 **Kern-Design (Priorität 1):**');
      buffer.writeln(design.content);
      buffer.writeln();
    }
    
    // Priorität 2: Research (wichtig)
    if (research != null) {
      buffer.writeln('📚 **Markt-Research (Priorität 2):**');
      buffer.writeln(research.content);
      buffer.writeln();
    }
    
    // Priorität 3: Assets (optional)
    if (assets != null) {
      buffer.writeln('🎨 **Asset-Vorschläge (Priorität 3):**');
      buffer.writeln(assets.content);
    }
    
    return buffer.toString();
  }

  String _consolidateCodeGenerationWithPriority(List<AgentResponse> responses) {
    final engine = responses.where((r) => r.agentId == 'game_engine').firstOrNull;
    final research = responses.where((r) => r.agentId == 'research').firstOrNull;
    
    final buffer = StringBuffer();
    buffer.writeln('💻 **Code Generation**\n');
    
    // Priorität 1: Engine Code (kritisch)
    if (engine != null) {
      buffer.writeln('⚡ **Engine Code (Priorität 1):**');
      buffer.writeln(engine.content);
      buffer.writeln();
    }
    
    // Priorität 2: Best Practices (wichtig)
    if (research != null) {
      buffer.writeln('📖 **Best Practices (Priorität 2):**');
      buffer.writeln(research.content);
    }
    
    return buffer.toString();
  }

  String _consolidateAssetGenerationWithPriority(List<AgentResponse> responses) {
    final assets = responses.where((r) => r.agentId == 'asset_generation').firstOrNull;
    final design = responses.where((r) => r.agentId == 'creative_director').firstOrNull;
    
    final buffer = StringBuffer();
    buffer.writeln('🎨 **Asset Generation**\n');
    
    // Priorität 1: Assets (kritisch)
    if (assets != null) {
      buffer.writeln('🎨 **Generierte Assets (Priorität 1):**');
      buffer.writeln(assets.content);
      buffer.writeln();
    }
    
    // Priorität 2: Design Guidelines (wichtig)
    if (design != null) {
      buffer.writeln('🎭 **Design Guidelines (Priorität 2):**');
      buffer.writeln(design.content);
    }
    
    return buffer.toString();
  }

  String _consolidateProjectAnalysisWithPriority(List<AgentResponse> responses) {
    final project = responses.where((r) => r.agentId == 'project_master').firstOrNull;
    final research = responses.where((r) => r.agentId == 'research').firstOrNull;
    
    final buffer = StringBuffer();
    buffer.writeln('📊 **Project Analysis**\n');
    
    // Priorität 1: Projekt-Status (kritisch)
    if (project != null) {
      buffer.writeln('📊 **Projekt-Status (Priorität 1):**');
      buffer.writeln(project.content);
      buffer.writeln();
    }
    
    // Priorität 2: Markt-Research (wichtig)
    if (research != null) {
      buffer.writeln('🔍 **Markt-Vergleich (Priorität 2):**');
      buffer.writeln(research.content);
    }
    
    return buffer.toString();
  }

  String _consolidateResearchWithPriority(List<AgentResponse> responses) {
    final research = responses.where((r) => r.agentId == 'research').firstOrNull;
    final design = responses.where((r) => r.agentId == 'creative_director').firstOrNull;
    
    final buffer = StringBuffer();
    buffer.writeln('🔬 **Research Results**\n');
    
    // Priorität 1: Research (kritisch)
    if (research != null) {
      buffer.writeln('🔬 **Forschungsergebnisse (Priorität 1):**');
      buffer.writeln(research.content);
      buffer.writeln();
    }
    
    // Priorität 2: Kreative Insights (wichtig)
    if (design != null) {
      buffer.writeln('💡 **Kreative Insights (Priorität 2):**');
      buffer.writeln(design.content);
    }
    
    return buffer.toString();
  }

  String _consolidateGeneralHelpWithPriority(List<AgentResponse> responses) {
    final design = responses.where((r) => r.agentId == 'creative_director').firstOrNull;
    final research = responses.where((r) => r.agentId == 'research').firstOrNull;
    
    final buffer = StringBuffer();
    buffer.writeln('🤖 **Jamba AI Help**\n');
    
    // Priorität 1: Kreative Hilfe (kritisch)
    if (design != null) {
      buffer.writeln('🎭 **Kreative Hilfe (Priorität 1):**');
      buffer.writeln(design.content);
      buffer.writeln();
    }
    
    // Priorität 2: Zusätzliche Ressourcen (wichtig)
    if (research != null) {
      buffer.writeln('📚 **Zusätzliche Ressourcen (Priorität 2):**');
      buffer.writeln(research.content);
    }
    
    return buffer.toString();
  }

  /// Führt einen spezifischen Agenten aus
  Future<AgentResponse> _executeAgent(String agentId, AIRequest request) async {
    switch (agentId) {
      case 'research':
        return await _executeResearchAgent(request);
      case 'creative_director':
        return await _executeCreativeDirectorAgent(request);
      case 'asset_generation':
        return await _executeAssetGenerationAgent(request);
      case 'game_engine':
        return await _executeGameEngineAgent(request);
      case 'project_master':
        return await _executeProjectMasterAgent(request);
      default:
        throw Exception('Unbekannter Agent: $agentId');
    }
  }

  Future<AgentResponse> _executeResearchAgent(AIRequest request) async {
    final researchResults = await _researchAgent.searchResearch(
      query: request.message,
      enabledSources: ['academic', 'industry', 'community'],
      ethicalConcerns: [],
      maxResults: 5,
    );
    
    return AgentResponse(
      agentId: 'research',
      success: true,
      content: _formatResearchResults(researchResults),
      metadata: {
        'sources': researchResults.papers.length,
        'query': request.message,
      },
    );
  }

  Future<AgentResponse> _executeCreativeDirectorAgent(AIRequest request) async {
    final design = await _creativeDirector.createGameDesign(
      concept: request.message,
      targetAudience: 'general',
      researchData: [],
      preferences: {'genre': _extractGenre(request.message)},
    );
    
    return AgentResponse(
      agentId: 'creative_director',
      success: true,
      content: _formatGameDesign(design),
      metadata: {
        'genre': design.genre,
        'complexity': 'medium',
      },
    );
  }

  Future<AgentResponse> _executeAssetGenerationAgent(AIRequest request) async {
    final assetRequests = [
      AssetGenerationRequest(
        description: request.message,
        assetType: _extractAssetType(request.message) == 'texture' ? AssetType.texture : AssetType.model3d,
        engine: GenerationEngine.stableDiffusion,
        specifications: {
          'style': 'modern',
          'count': 3,
        },
      ),
    ];
    
    final assets = await _assetAgent.generateAssetBatch(
      requests: assetRequests,
      batchSettings: {},
    );
    
    return AgentResponse(
      agentId: 'asset_generation',
      success: true,
      content: _formatAssetSuggestions(assets),
      metadata: {
        'assetCount': assets.length,
        'assetType': _extractAssetType(request.message),
      },
    );
  }

  Future<AgentResponse> _executeGameEngineAgent(AIRequest request) async {
    final engine = _extractEngine(request.message);
    // Use the engine adapter to get features and create a mock response
    final features = _engineAgent.getEngineFeatures(engine);
    
    final code = '''
**$engine Code für: ${request.message}**

```${_getLanguageForEngine(engine)}
// $engine Implementation
public class ${request.message.replaceAll(' ', '')} {
    // Implementation details would go here
    // This is a placeholder for the actual code generation
}
```

**Verfügbare Features:**
${features.map((f) => '• $f').join('\n')}
''';
    
    return AgentResponse(
      agentId: 'game_engine',
      success: true,
      content: _formatCodeGeneration(code, engine),
      metadata: {
        'engine': engine,
        'language': _getLanguageForEngine(engine),
        'features': features,
      },
    );
  }

  Future<AgentResponse> _executeProjectMasterAgent(AIRequest request) async {
    final project = await _projectMaster.loadProject('current');
    
    final analysis = '''
**Projekt-Analyse: ${project.name}**

**Status:** ${project.status.name}

**Prototypen:** ${project.prototypes.length}
**Playtests:** ${project.playtests.length}
**Team-Mitglieder:** ${project.team.length}

**Nächste Schritte:**
• Prototypen weiterentwickeln
• Playtests durchführen
• Feedback sammeln und analysieren
• Team erweitern falls nötig
''';
    
    return AgentResponse(
      agentId: 'project_master',
      success: true,
      content: _formatProjectAnalysis(analysis),
      metadata: {
        'projectStatus': project.status.name,
        'prototypeCount': project.prototypes.length,
        'projectName': project.name,
      },
    );
  }

  // Helper-Methoden für Formatierung
  String _formatResearchResults(research_data.ResearchResult results) {
    if (results.papers.isEmpty) return 'Keine Forschungsergebnisse gefunden.';
    
    final buffer = StringBuffer();
    buffer.writeln('**Forschungsergebnisse für: ${results.query}**\n');
    
    for (int i = 0; i < results.papers.length && i < 3; i++) {
      final paper = results.papers[i];
      buffer.writeln('**${paper.title}**');
      buffer.writeln('Autoren: ${paper.authors.join(', ')}');
      buffer.writeln('Quelle: ${paper.source} (${paper.year})');
      buffer.writeln('Score: ${paper.score}');
      buffer.writeln('Abstract: ${paper.abstractText}');
      buffer.writeln('URL: ${paper.url}');
      buffer.writeln();
    }
    
    buffer.writeln('**Verwendete Quellen:** ${results.usedSources.join(', ')}');
    return buffer.toString();
  }

  String _formatGameDesign(GameDesignDocument design) {
    return '''**${design.title}**
Genre: ${design.genre}
Zielgruppe: ${design.targetAudience}

**Narrative:**
Thema: ${design.narrative.theme}
Setting: ${design.narrative.setting}
Stil: ${design.narrative.style.name}

**UX Design:**
Plattform: ${design.uxDesign.targetPlatform}
Accessibility: ${design.uxDesign.accessibility.name}

**Mechaniken:** ${design.mechanics.length} definiert''';
  }

  String _formatAssetSuggestions(List<asset_data.GeneratedAsset> assets) {
    if (assets.isEmpty) return 'Keine Asset-Vorschläge verfügbar.';
    
    final buffer = StringBuffer();
    buffer.writeln('**Asset-Vorschläge:**\n');
    
    for (final asset in assets) {
      buffer.writeln('• **${asset.assetType.name}**: ${asset.description}');
      buffer.writeln('  Engine: ${asset.engine.name}');
      buffer.writeln('  Qualität: ${(asset.quality * 100).round()}%');
      if (asset.fileUrl.isNotEmpty) {
        buffer.writeln('  URL: ${asset.fileUrl}');
      }
      buffer.writeln();
    }
    
    return buffer.toString();
  }

  String _formatCodeGeneration(String code, String engine) {
    return '''**$engine Code:**
$code''';
  }

  String _formatProjectAnalysis(String analysis) {
    return analysis;
  }

  // Helper-Methoden für Extraktion
  String _extractGenre(String message) {
    final genres = ['platformer', 'rpg', 'puzzle', 'shooter', 'simulation', 'adventure'];
    for (final genre in genres) {
      if (message.toLowerCase().contains(genre)) return genre;
    }
    return 'general';
  }

  String _extractAssetType(String message) {
    if (message.contains('textur')) return 'texture';
    if (message.contains('modell')) return '3d_model';
    if (message.contains('animation')) return 'animation';
    if (message.contains('sound')) return 'audio';
    return 'general';
  }

  String _extractEngine(String message) {
    if (message.contains('unity')) return 'Unity';
    if (message.contains('godot')) return 'Godot';
    if (message.contains('bevy')) return 'Bevy';
    if (message.contains('unreal')) return 'Unreal';
    return 'Unity'; // Default
  }

  String _getLanguageForEngine(String engine) {
    switch (engine.toLowerCase()) {
      case 'unity':
        return 'csharp';
      case 'godot':
        return 'gdscript';
      case 'bevy':
        return 'rust';
      case 'unreal':
        return 'cpp';
      default:
        return 'csharp';
    }
  }
}

// ============================================================================
// DATA MODELS
// ============================================================================

enum AIRequestType {
  gameConcept,
  codeGeneration,
  assetGeneration,
  projectAnalysis,
  research,
  generalHelp,
}

class AIRequest {
  final AIRequestType type;
  final String message;
  final List<String> requiredAgents;
  final List<String> optionalAgents;

  AIRequest({
    required this.type,
    required this.message,
    required this.requiredAgents,
    required this.optionalAgents,
  });
}

class AgentResponse {
  final String agentId;
  final bool success;
  final String content;
  final Map<String, dynamic> metadata;

  AgentResponse({
    required this.agentId,
    required this.success,
    required this.content,
    required this.metadata,
  });
}

class JambaAIResponse {
  final String content;
  final List<String> suggestions;
  final List<String> usedAgents;
  final List<String> failedAgents;
  final Map<String, dynamic> metadata;

  JambaAIResponse({
    required this.content,
    required this.suggestions,
    required this.usedAgents,
    required this.failedAgents,
    required this.metadata,
  });
}

// ============================================================================
// PROVIDERS
// ============================================================================

final jambaAIOrchestratorServiceProvider = Provider<JambaAIOrchestratorService>((ref) {
  return JambaAIOrchestratorService();
}); 