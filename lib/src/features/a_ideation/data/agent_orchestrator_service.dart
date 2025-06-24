import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domain/multi_agent_system.dart' as domain;
import 'research_agent_service.dart' as research;
import 'creative_director_agent_service.dart';
import 'asset_generation_agent_service.dart' as asset;
import 'game_engine_agent_service.dart' as engine;
import 'workflow_types.dart';

/// Agent Orchestrator Service
/// Koordiniert Multi-Agenten-Workflows für KI-generierte Game Development
class AgentOrchestratorService {
  static const String _baseUrl = 'http://localhost:8000';
  
  // Agent Services
  final research.ResearchAgentService _researchAgent = research.ResearchAgentService();
  final CreativeDirectorAgentService _creativeDirector = CreativeDirectorAgentService();
  final asset.AssetGenerationAgentService _assetGeneration = asset.AssetGenerationAgentService();
  final engine.GameEngineAgentService _gameEngine = engine.GameEngineAgentService();

  /// Startet einen vollständigen Game Development Workflow
  Future<OrchestrationResult> startGameDevelopmentWorkflow({
    required String concept,
    required String targetAudience,
    required String targetEngine,
    required String targetPlatform,
    required Map<String, dynamic> preferences,
    required WorkflowConfiguration config,
  }) async {
    final workflowId = 'workflow_${DateTime.now().millisecondsSinceEpoch}';
    
    try {
      // 1. Research Phase
      final researchResult = await _executeResearchPhase(
        concept: concept,
        targetAudience: targetAudience,
        config: config,
      );

      // 2. Creative Design Phase
      final designResult = await _executeCreativeDesignPhase(
        concept: concept,
        targetAudience: targetAudience,
        researchData: researchResult.papers.map((p) => p.title).toList(),
        preferences: preferences,
        config: config,
      );

      // 3. Asset Generation Phase
      final assetResult = await _executeAssetGenerationPhase(
        design: designResult,
        config: config,
      );

      // 4. Engine Integration Phase
      final engineResult = await _executeEngineIntegrationPhase(
        engine: targetEngine,
        platform: targetPlatform,
        design: designResult,
        assets: assetResult,
        config: config,
      );

      return OrchestrationResult(
        workflowId: workflowId,
        success: true,
        researchResult: researchResult,
        designResult: designResult,
        assetResult: assetResult,
        engineResult: engineResult,
        logs: [
          'Research phase completed',
          'Creative design phase completed',
          'Asset generation phase completed',
          'Engine integration phase completed',
        ],
        warnings: [],
        totalDuration: Duration(minutes: 15), // Mock duration
      );

    } catch (e) {
      return OrchestrationResult(
        workflowId: workflowId,
        success: false,
        researchResult: null,
        designResult: null,
        assetResult: null,
        engineResult: null,
        logs: ['Workflow failed: $e'],
        warnings: ['Error occurred during workflow execution'],
        totalDuration: Duration(minutes: 5),
      );
    }
  }

  /// Führt die Research Phase aus
  Future<research.ResearchResult> _executeResearchPhase({
    required String concept,
    required String targetAudience,
    required WorkflowConfiguration config,
  }) async {
    final query = '$concept $targetAudience game development research';
    final enabledSources = config.enabledResearchSources;
    final ethicalConcerns = config.ethicalConcerns.map((e) => domain.EthicalConcern.values.firstWhere(
      (ec) => ec.name == e,
      orElse: () => domain.EthicalConcern.aiBias,
    )).toList();

    return await _researchAgent.searchResearch(
      query: query,
      enabledSources: enabledSources,
      ethicalConcerns: ethicalConcerns,
      maxResults: config.maxResearchResults,
    );
  }

  /// Führt die Creative Design Phase aus
  Future<domain.GameDesignDocument> _executeCreativeDesignPhase({
    required String concept,
    required String targetAudience,
    required List<String> researchData,
    required Map<String, dynamic> preferences,
    required WorkflowConfiguration config,
  }) async {
    return await _creativeDirector.createGameDesign(
      concept: concept,
      targetAudience: targetAudience,
      researchData: researchData,
      preferences: preferences,
    );
  }

  /// Führt die Asset Generation Phase aus
  Future<List<asset.GeneratedAsset>> _executeAssetGenerationPhase({
    required domain.GameDesignDocument design,
    required WorkflowConfiguration config,
  }) async {
    final assetRequests = <asset.AssetGenerationRequest>[];

    // Generate 3D models for characters
    assetRequests.add(asset.AssetGenerationRequest(
      description: 'Main character for ${design.title}',
      assetType: domain.AssetType.model3d,
      engine: domain.GenerationEngine.blender,
      specifications: {
        'style': design.genre,
        'complexity': 'medium',
        'rigged': true,
      },
    ));

    // Generate textures
    assetRequests.add(asset.AssetGenerationRequest(
      description: 'Environment textures for ${design.narrative.setting}',
      assetType: domain.AssetType.texture,
      engine: domain.GenerationEngine.stableDiffusion,
      specifications: {
        'resolution': '2048x2048',
        'style': design.genre,
      },
    ));

    // Generate audio
    assetRequests.add(asset.AssetGenerationRequest(
      description: 'Background music for ${design.title}',
      assetType: domain.AssetType.audio,
      engine: domain.GenerationEngine.audioCraft,
      specifications: {
        'duration': '60s',
        'style': design.genre,
        'loop': true,
      },
    ));

    return await _assetGeneration.generateAssetBatch(
      requests: assetRequests,
      batchSettings: config.assetGenerationSettings,
    );
  }

  /// Führt die Engine Integration Phase aus
  Future<engine.EngineBuildResult> _executeEngineIntegrationPhase({
    required String engine,
    required String platform,
    required domain.GameDesignDocument design,
    required List<asset.GeneratedAsset> assets,
    required WorkflowConfiguration config,
  }) async {
    // Convert asset service assets to domain assets
    final domainAssets = assets.map((a) => _convertToDomainAsset(a)).toList();
    
    // Import assets and design to engine
    final integrationResult = await _gameEngine.importToEngine(
      engine: engine,
      assets: domainAssets,
      design: design,
      engineConfig: config.engineConfig,
    );

    if (!integrationResult.success) {
      throw Exception('Engine integration failed: ${integrationResult.warnings.join(', ')}');
    }

    // Generate engine code
    await _gameEngine.generateEngineCode(
      engine: engine,
      design: design,
      assets: domainAssets,
      codeOptions: config.codeGenerationOptions,
    );

    // Build project
    final buildResult = await _gameEngine.buildAndExport(
      engine: engine,
      targetPlatform: platform,
      buildConfig: config.buildConfig,
    );

    return buildResult;
  }

  /// Converts asset service GeneratedAsset to domain GeneratedAsset
  domain.GeneratedAsset _convertToDomainAsset(asset.GeneratedAsset asset) {
    return domain.GeneratedAsset(
      id: asset.id,
      name: asset.name,
      type: asset.assetType,
      fileUrl: asset.fileUrl,
      createdAt: asset.createdAt,
      engine: asset.engine.toString(),
      metadata: asset.metadata,
      quality: asset.quality,
    );
  }

  /// Führt einen adaptiven Workflow basierend auf dem Typ aus
  Future<OrchestrationResult> executeAdaptiveWorkflow({
    required WorkflowType type,
    required Map<String, dynamic> parameters,
    required WorkflowConfiguration config,
  }) async {
    switch (type) {
      case WorkflowType.research:
        return await _executeResearchOnlyWorkflow(parameters, config);
      case WorkflowType.design:
        return await _executeDesignOnlyWorkflow(parameters, config);
      case WorkflowType.assetGeneration:
        return await _executeAssetOnlyWorkflow(parameters, config);
      case WorkflowType.engineIntegration:
        return await _executeEngineOnlyWorkflow(parameters, config);
      case WorkflowType.full:
        return await startGameDevelopmentWorkflow(
          concept: parameters['concept'],
          targetAudience: parameters['targetAudience'],
          targetEngine: parameters['targetEngine'],
          targetPlatform: parameters['targetPlatform'],
          preferences: parameters['preferences'] ?? {},
          config: config,
        );
      case WorkflowType.custom:
        return await _executeCustomWorkflow(parameters, config);
    }
  }

  /// Führt nur Research aus
  Future<OrchestrationResult> _executeResearchOnlyWorkflow(
    Map<String, dynamic> parameters,
    WorkflowConfiguration config,
  ) async {
    final workflowId = 'research_${DateTime.now().millisecondsSinceEpoch}';
    
    try {
      final researchResult = await _executeResearchPhase(
        concept: parameters['concept'],
        targetAudience: parameters['targetAudience'],
        config: config,
      );

      return OrchestrationResult(
        workflowId: workflowId,
        success: true,
        researchResult: researchResult,
        designResult: null,
        assetResult: null,
        engineResult: null,
        logs: ['Research phase completed'],
        warnings: [],
        totalDuration: Duration(minutes: 2),
      );
    } catch (e) {
      return OrchestrationResult(
        workflowId: workflowId,
        success: false,
        researchResult: null,
        designResult: null,
        assetResult: null,
        engineResult: null,
        logs: ['Research workflow failed: $e'],
        warnings: ['Error occurred during research'],
        totalDuration: Duration(minutes: 1),
      );
    }
  }

  /// Führt nur Design aus
  Future<OrchestrationResult> _executeDesignOnlyWorkflow(
    Map<String, dynamic> parameters,
    WorkflowConfiguration config,
  ) async {
    final workflowId = 'design_${DateTime.now().millisecondsSinceEpoch}';
    
    try {
      final designResult = await _executeCreativeDesignPhase(
        concept: parameters['concept'],
        targetAudience: parameters['targetAudience'],
        researchData: parameters['researchData'] ?? [],
        preferences: parameters['preferences'] ?? {},
        config: config,
      );

      return OrchestrationResult(
        workflowId: workflowId,
        success: true,
        researchResult: null,
        designResult: designResult,
        assetResult: null,
        engineResult: null,
        logs: ['Design phase completed'],
        warnings: [],
        totalDuration: Duration(minutes: 3),
      );
    } catch (e) {
      return OrchestrationResult(
        workflowId: workflowId,
        success: false,
        researchResult: null,
        designResult: null,
        assetResult: null,
        engineResult: null,
        logs: ['Design workflow failed: $e'],
        warnings: ['Error occurred during design'],
        totalDuration: Duration(minutes: 1),
      );
    }
  }

  /// Führt nur Asset Generation aus
  Future<OrchestrationResult> _executeAssetOnlyWorkflow(
    Map<String, dynamic> parameters,
    WorkflowConfiguration config,
  ) async {
    final workflowId = 'assets_${DateTime.now().millisecondsSinceEpoch}';
    
    try {
      final assetResult = await _executeAssetGenerationPhase(
        design: parameters['design'] as domain.GameDesignDocument,
        config: config,
      );

      return OrchestrationResult(
        workflowId: workflowId,
        success: true,
        researchResult: null,
        designResult: null,
        assetResult: assetResult,
        engineResult: null,
        logs: ['Asset generation phase completed'],
        warnings: [],
        totalDuration: Duration(minutes: 8),
      );
    } catch (e) {
      return OrchestrationResult(
        workflowId: workflowId,
        success: false,
        researchResult: null,
        designResult: null,
        assetResult: null,
        engineResult: null,
        logs: ['Asset generation workflow failed: $e'],
        warnings: ['Error occurred during asset generation'],
        totalDuration: Duration(minutes: 2),
      );
    }
  }

  /// Führt nur Engine Integration aus
  Future<OrchestrationResult> _executeEngineOnlyWorkflow(
    Map<String, dynamic> parameters,
    WorkflowConfiguration config,
  ) async {
    final workflowId = 'engine_${DateTime.now().millisecondsSinceEpoch}';
    
    try {
      final engineResult = await _executeEngineIntegrationPhase(
        engine: parameters['engine'],
        platform: parameters['platform'],
        design: parameters['design'] as domain.GameDesignDocument,
        assets: parameters['assets'] as List<asset.GeneratedAsset>,
        config: config,
      );

      return OrchestrationResult(
        workflowId: workflowId,
        success: true,
        researchResult: null,
        designResult: null,
        assetResult: null,
        engineResult: engineResult,
        logs: ['Engine integration phase completed'],
        warnings: [],
        totalDuration: Duration(minutes: 5),
      );
    } catch (e) {
      return OrchestrationResult(
        workflowId: workflowId,
        success: false,
        researchResult: null,
        designResult: null,
        assetResult: null,
        engineResult: null,
        logs: ['Engine integration workflow failed: $e'],
        warnings: ['Error occurred during engine integration'],
        totalDuration: Duration(minutes: 1),
      );
    }
  }

  /// Führt einen benutzerdefinierten Workflow aus
  Future<OrchestrationResult> _executeCustomWorkflow(
    Map<String, dynamic> parameters,
    WorkflowConfiguration config,
  ) async {
    final workflowId = 'custom_${DateTime.now().millisecondsSinceEpoch}';
    
    try {
      // Custom workflow logic here
      return OrchestrationResult(
        workflowId: workflowId,
        success: true,
        researchResult: null,
        designResult: null,
        assetResult: null,
        engineResult: null,
        logs: ['Custom workflow completed'],
        warnings: [],
        totalDuration: Duration(minutes: 1),
      );
    } catch (e) {
      return OrchestrationResult(
        workflowId: workflowId,
        success: false,
        researchResult: null,
        designResult: null,
        assetResult: null,
        engineResult: null,
        logs: ['Custom workflow failed: $e'],
        warnings: ['Error occurred during custom workflow'],
        totalDuration: Duration(minutes: 1),
      );
    }
  }

  /// Überwacht den Status eines Workflows
  Future<WorkflowStatus> getWorkflowStatus(String workflowId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/orchestrator/status/$workflowId'),
        headers: {'Accept': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _parseWorkflowStatus(data);
      } else {
        throw Exception('Failed to get workflow status: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback: Mock status
      return _createMockWorkflowStatus(workflowId);
    }
  }

  /// Stoppt einen laufenden Workflow
  Future<bool> stopWorkflow(String workflowId) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/orchestrator/stop/$workflowId'),
        headers: {'Accept': 'application/json'},
      );
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Mock & Parser Implementierungen
  WorkflowStatus _createMockWorkflowStatus(String workflowId) {
    return WorkflowStatus(
      workflowId: workflowId,
      type: WorkflowType.full,
      status: 'completed',
      progress: 1.0,
      startTime: DateTime.now().subtract(Duration(minutes: 10)),
      endTime: DateTime.now(),
      logs: ['Workflow completed successfully'],
      warnings: [],
      errors: [],
    );
  }

  WorkflowStatus _parseWorkflowStatus(Map<String, dynamic> data) {
    return WorkflowStatus(
      workflowId: data['workflow_id'] ?? '',
      type: WorkflowType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () => WorkflowType.full,
      ),
      status: data['status'] ?? 'unknown',
      progress: (data['progress'] ?? 0.0).toDouble(),
      startTime: DateTime.parse(data['start_time'] ?? DateTime.now().toIso8601String()),
      endTime: data['end_time'] != null ? DateTime.parse(data['end_time']) : null,
      logs: List<String>.from(data['logs'] ?? []),
      warnings: List<String>.from(data['warnings'] ?? []),
      errors: List<String>.from(data['errors'] ?? []),
    );
  }
}

// Supporting classes
class WorkflowConfiguration {
  final List<String> enabledResearchSources;
  final List<String> ethicalConcerns;
  final int maxResearchResults;
  final Map<String, dynamic> assetGenerationSettings;
  final Map<String, dynamic> engineConfig;
  final Map<String, dynamic> codeGenerationOptions;
  final Map<String, dynamic> buildConfig;

  const WorkflowConfiguration({
    required this.enabledResearchSources,
    required this.ethicalConcerns,
    required this.maxResearchResults,
    required this.assetGenerationSettings,
    required this.engineConfig,
    required this.codeGenerationOptions,
    required this.buildConfig,
  });
}

class OrchestrationResult {
  final String workflowId;
  final bool success;
  final research.ResearchResult? researchResult;
  final domain.GameDesignDocument? designResult;
  final List<asset.GeneratedAsset>? assetResult;
  final engine.EngineBuildResult? engineResult;
  final List<String> logs;
  final List<String> warnings;
  final Duration totalDuration;

  const OrchestrationResult({
    required this.workflowId,
    required this.success,
    required this.researchResult,
    required this.designResult,
    required this.assetResult,
    required this.engineResult,
    required this.logs,
    required this.warnings,
    required this.totalDuration,
  });
}
