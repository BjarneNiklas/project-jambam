import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../domain/multi_agent_system.dart';
import 'agent_orchestrator_service.dart' as orchestrator;
import 'project_master_agent_service.dart';
import 'research_agent_service.dart';
import 'creative_director_agent_service.dart';
import 'asset_generation_agent_service.dart';
import 'game_engine_agent_service.dart';

part 'multi_agent_providers.g.dart';
part 'multi_agent_providers.freezed.dart';

// ============================================================================
// SERVICE PROVIDERS
// ============================================================================

@riverpod
orchestrator.AgentOrchestratorService agentOrchestratorService(Ref ref) {
  return orchestrator.AgentOrchestratorService();
}

@riverpod
ProjectMasterAgentService projectMasterAgentService(Ref ref) {
  return ProjectMasterAgentService();
}

@riverpod
ResearchAgentService researchAgentService(Ref ref) {
  return ResearchAgentService();
}

@riverpod
CreativeDirectorAgentService creativeDirectorAgentService(Ref ref) {
  return CreativeDirectorAgentService();
}

@riverpod
AssetGenerationAgentService assetGenerationAgentService(Ref ref) {
  return AssetGenerationAgentService();
}

@riverpod
GameEngineAgentService gameEngineAgentService(Ref ref) {
  return GameEngineAgentService();
}

// ============================================================================
// PROJECT STATE MANAGEMENT
// ============================================================================

@riverpod
class CurrentProject extends _$CurrentProject {
  @override
  FutureOr<ProjectMasterAgent?> build() async {
    // Load current project on initialization
    final service = ref.read(projectMasterAgentServiceProvider);
    return await service.loadProject('demo-project');
  }

  Future<void> loadProject(String projectId) async {
    state = const AsyncLoading();
    final service = ref.read(projectMasterAgentServiceProvider);
    state = await AsyncValue.guard(() => service.loadProject(projectId));
  }

  Future<void> saveProject(ProjectMasterAgent project) async {
    final service = ref.read(projectMasterAgentServiceProvider);
    await service.saveProject(project);
    state = AsyncValue.data(project);
  }

  Future<void> addPrototype(Prototype prototype) async {
    final currentProject = state.value;
    if (currentProject != null) {
      final service = ref.read(projectMasterAgentServiceProvider);
      await service.addPrototype(prototype);
      // Reload project to get updated state
      await loadProject(currentProject.id);
    }
  }

  Future<void> addPlaytest(PlaytestResult playtest) async {
    final currentProject = state.value;
    if (currentProject != null) {
      final service = ref.read(projectMasterAgentServiceProvider);
      await service.addPlaytest(playtest);
      await loadProject(currentProject.id);
    }
  }

  Future<void> addFeedback(FeedbackEntry feedback) async {
    final currentProject = state.value;
    if (currentProject != null) {
      final service = ref.read(projectMasterAgentServiceProvider);
      await service.addFeedback(feedback);
      await loadProject(currentProject.id);
    }
  }

  Future<void> addTeamMember(TeamMember member) async {
    final currentProject = state.value;
    if (currentProject != null) {
      final service = ref.read(projectMasterAgentServiceProvider);
      await service.addTeamMember(member);
      await loadProject(currentProject.id);
    }
  }

  Future<void> addDecision(ProjectDecision decision) async {
    final currentProject = state.value;
    if (currentProject != null) {
      final service = ref.read(projectMasterAgentServiceProvider);
      await service.addDecision(decision);
      await loadProject(currentProject.id);
    }
  }

  Future<void> addLesson(LessonLearned lesson) async {
    final currentProject = state.value;
    if (currentProject != null) {
      final service = ref.read(projectMasterAgentServiceProvider);
      await service.addLesson(lesson);
      await loadProject(currentProject.id);
    }
  }

  Future<void> setProjectStatus(ProjectStatus status) async {
    final currentProject = state.value;
    if (currentProject != null) {
      final service = ref.read(projectMasterAgentServiceProvider);
      await service.setStatus(status);
      await loadProject(currentProject.id);
    }
  }

  Future<Map<String, dynamic>?> exportProject() async {
    final service = ref.read(projectMasterAgentServiceProvider);
    return await service.exportProject();
  }
}

// ============================================================================
// WORKFLOW STATE MANAGEMENT
// ============================================================================

@riverpod
class ActiveWorkflows extends _$ActiveWorkflows {
  @override
  List<WorkflowStatus> build() {
    return [];
  }

  Future<void> startWorkflow({
    required WorkflowType type,
    required Map<String, dynamic> parameters,
    required WorkflowConfiguration config,
  }) async {
    final orchestratorService = ref.read(agentOrchestratorServiceProvider);
    final result = await orchestratorService.executeAdaptiveWorkflow(
      type: type,
      parameters: parameters,
      config: config,
    );

    if (result.success) {
      // Add to active workflows
      final workflowStatus = WorkflowStatus(
        workflowId: result.workflowId,
        type: type,
        status: 'running',
        progress: 0.0,
        startTime: DateTime.now(),
        logs: result.logs,
        warnings: [],
        errors: [],
        currentStep: 'Started',
        estimatedTimeRemaining: result.totalDuration,
      );
      state = [...state, workflowStatus];
    }
  }

  Future<void> stopWorkflow(String workflowId) async {
    final orchestratorService = ref.read(agentOrchestratorServiceProvider);
    final success = await orchestratorService.stopWorkflow(workflowId);
    
    if (success) {
      state = state.where((workflow) => workflow.workflowId != workflowId).toList();
    }
  }

  Future<void> updateWorkflowStatus(String workflowId) async {
    final orchestratorService = ref.read(agentOrchestratorServiceProvider);
    final status = await orchestratorService.getWorkflowStatus(workflowId);
    
    state = state.map((workflow) {
      if (workflow.workflowId == workflowId) {
        return status;
      }
      return workflow;
    }).toList();
  }

  void removeCompletedWorkflow(String workflowId) {
    state = state.where((workflow) => workflow.workflowId != workflowId).toList();
  }
}

// ============================================================================
// AGENT STATUS MANAGEMENT
// ============================================================================

@riverpod
class AgentStatuses extends _$AgentStatuses {
  @override
  Map<String, AgentStatus> build() {
    return {
      'research': AgentStatus.active,
      'creative_director': AgentStatus.active,
      'asset_generation': AgentStatus.idle,
      'game_engine': AgentStatus.idle,
      'project_master': AgentStatus.active,
    };
  }

  void updateAgentStatus(String agentId, AgentStatus status) {
    state = {...state, agentId: status};
  }

  void setAllAgentsIdle() {
    state = {
      for (var entry in state.entries)
        entry.key: AgentStatus.idle
    };
  }

  void setAgentActive(String agentId) {
    updateAgentStatus(agentId, AgentStatus.active);
  }

  void setAgentError(String agentId) {
    updateAgentStatus(agentId, AgentStatus.error);
  }
}

// ============================================================================
// KI-INTEGRATION & INSIGHTS
// ============================================================================

@riverpod
class AIInsights extends _$AIInsights {
  @override
  List<AIInsight> build() {
    return [];
  }

  Future<void> generateInsights(ProjectMasterAgent project) async {
    final insights = <AIInsight>[];

    // Analyze project status and generate insights
    if (project.prototypes.isEmpty) {
      insights.add(AIInsight(
        id: 'no-prototypes',
        type: AIInsightType.warning,
        title: 'Keine Prototypen vorhanden',
        description: 'Erstelle einen ersten Prototypen, um das Konzept zu testen.',
        priority: InsightPriority.high,
        suggestedActions: ['Prototyp erstellen', 'Design verfeinern'],
      ));
    }

    if (project.playtests.isEmpty) {
      insights.add(AIInsight(
        id: 'no-playtests',
        type: AIInsightType.suggestion,
        title: 'Playtests empfohlen',
        description: 'Führe Playtests durch, um Feedback zu sammeln.',
        priority: InsightPriority.medium,
        suggestedActions: ['Playtest planen', 'Testgruppe finden'],
      ));
    }

    if (project.team.length < 2) {
      insights.add(AIInsight(
        id: 'small-team',
        type: AIInsightType.info,
        title: 'Kleines Team',
        description: 'Erwäge, weitere Teammitglieder hinzuzufügen.',
        priority: InsightPriority.low,
        suggestedActions: ['Team erweitern', 'Rollen definieren'],
      ));
    }

    state = insights;
  }

  void addInsight(AIInsight insight) {
    state = [...state, insight];
  }

  void removeInsight(String insightId) {
    state = state.where((insight) => insight.id != insightId).toList();
  }

  void markInsightResolved(String insightId) {
    state = state.map((insight) {
      if (insight.id == insightId) {
        return insight.copyWith(resolved: true);
      }
      return insight;
    }).toList();
  }
}

// ============================================================================
// AUTOMATED RETROSPECTIVES & LESSONS LEARNED
// ============================================================================

@riverpod
class AutomatedRetrospectives extends _$AutomatedRetrospectives {
  @override
  List<RetrospectiveSession> build() {
    return [];
  }

  Future<void> generateRetrospective(ProjectMasterAgent project) async {
    final session = RetrospectiveSession(
      id: 'retro_${DateTime.now().millisecondsSinceEpoch}',
      projectId: project.id,
      date: DateTime.now(),
      insights: _analyzeProjectInsights(project),
      recommendations: _generateRecommendations(project),
      actionItems: _createActionItems(project),
    );

    state = [...state, session];
  }

  List<String> _analyzeProjectInsights(ProjectMasterAgent project) {
    final insights = <String>[];

    // Analyze prototypes
    if (project.prototypes.isNotEmpty) {
      insights.add('${project.prototypes.length} Prototypen erstellt');
    }

    // Analyze playtests
    if (project.playtests.isNotEmpty) {
      insights.add('${project.playtests.length} Playtests durchgeführt');
    }

    // Analyze team
    insights.add('Team-Größe: ${project.team.length} Mitglieder');

    // Analyze decisions
    if (project.decisions.isNotEmpty) {
      insights.add('${project.decisions.length} wichtige Entscheidungen getroffen');
    }

    return insights;
  }

  List<String> _generateRecommendations(ProjectMasterAgent project) {
    final recommendations = <String>[];

    if (project.prototypes.isEmpty) {
      recommendations.add('Erstelle einen ersten Prototypen');
    }

    if (project.playtests.isEmpty) {
      recommendations.add('Führe Playtests durch');
    }

    if (project.team.length < 2) {
      recommendations.add('Erwäge Team-Erweiterung');
    }

    return recommendations;
  }

  List<ActionItem> _createActionItems(ProjectMasterAgent project) {
    return [
      ActionItem(
        id: 'action_1',
        title: 'Nächsten Prototypen planen',
        description: 'Basierend auf Feedback den nächsten Prototypen entwickeln',
        assignee: project.team.isNotEmpty ? project.team.first.name : 'Team',
        dueDate: DateTime.now().add(const Duration(days: 7)),
        priority: ActionPriority.high,
      ),
    ];
  }
}

// ============================================================================
// ADAPTIVE WORKFLOWS
// ============================================================================

@riverpod
class AdaptiveWorkflows extends _$AdaptiveWorkflows {
  @override
  WorkflowConfiguration build() {
    return WorkflowConfiguration(
      enabledResearchSources: const ['arxiv'],
      ethicalConcerns: const [EthicalConcern.addictionResearch],
      maxResearchResults: 5,
      assetGenerationSettings: const {
        'quality': 'medium',
        'parallel_processing': false,
      },
      engineConfig: const {
        'optimization_level': 'basic',
        'debug_mode': true,
      },
      codeGenerationOptions: const {
        'include_comments': true,
        'follow_best_practices': true,
      },
      buildConfig: const {
        'optimization': 'debug',
        'compression': false,
      },
    );
  }

  void adaptToTeamSize(int teamSize) {
    if (teamSize <= 2) {
      // Small team: Simplified workflow
      state = WorkflowConfiguration(
        enabledResearchSources: const ['arxiv', 'pubmed'],
        ethicalConcerns: const [EthicalConcern.addictionResearch],
        maxResearchResults: 10,
        assetGenerationSettings: {
          'quality': 'medium',
          'parallel_processing': false,
        },
        engineConfig: {
          'optimization_level': 'basic',
          'debug_mode': true,
        },
        codeGenerationOptions: {
          'include_comments': true,
          'follow_best_practices': true,
        },
        buildConfig: {
          'optimization': 'debug',
          'compression': false,
        },
      );
    } else if (teamSize <= 5) {
      // Medium team: Balanced workflow
      state = WorkflowConfiguration(
        enabledResearchSources: const ['arxiv', 'pubmed', 'ieee', 'acm'],
        ethicalConcerns: const [EthicalConcern.addictionResearch],
        maxResearchResults: 20,
        assetGenerationSettings: {
          'quality': 'high',
          'parallel_processing': true,
        },
        engineConfig: {
          'optimization_level': 'balanced',
          'debug_mode': false,
        },
        codeGenerationOptions: {
          'include_comments': true,
          'follow_best_practices': true,
        },
        buildConfig: {
          'optimization': 'release',
          'compression': true,
        },
      );
    } else {
      // Large team: Advanced workflow
      state = WorkflowConfiguration(
        enabledResearchSources: const ['arxiv', 'pubmed', 'ieee', 'acm'],
        ethicalConcerns: const [EthicalConcern.addictionResearch],
        maxResearchResults: 30,
        assetGenerationSettings: {
          'quality': 'ultra',
          'parallel_processing': true,
        },
        engineConfig: {
          'optimization_level': 'advanced',
          'debug_mode': false,
        },
        codeGenerationOptions: {
          'include_comments': true,
          'follow_best_practices': true,
        },
        buildConfig: {
          'optimization': 'release',
          'compression': true,
        },
      );
    }
  }

  void adaptToTimeframe(Duration timeframe) {
    if (timeframe.inHours <= 48) {
      // Game Jam: Fast workflow
      state = WorkflowConfiguration(
        enabledResearchSources: const ['arxiv'],
        ethicalConcerns: const [EthicalConcern.addictionResearch],
        maxResearchResults: 5,
        assetGenerationSettings: {
          'quality': 'fast',
          'parallel_processing': true,
        },
        engineConfig: {
          'optimization_level': 'basic',
          'debug_mode': true,
        },
        codeGenerationOptions: {
          'include_comments': false,
          'follow_best_practices': false,
        },
        buildConfig: {
          'optimization': 'debug',
          'compression': false,
        },
      );
    } else if (timeframe.inDays <= 30) {
      // Short project: Balanced workflow
      state = WorkflowConfiguration(
        enabledResearchSources: const ['arxiv', 'pubmed', 'ieee'],
        ethicalConcerns: const [EthicalConcern.addictionResearch],
        maxResearchResults: 15,
        assetGenerationSettings: {
          'quality': 'medium',
          'parallel_processing': true,
        },
        engineConfig: {
          'optimization_level': 'balanced',
          'debug_mode': false,
        },
        codeGenerationOptions: {
          'include_comments': true,
          'follow_best_practices': true,
        },
        buildConfig: {
          'optimization': 'release',
          'compression': true,
        },
      );
    } else {
      // Long project: Quality workflow
      state = WorkflowConfiguration(
        enabledResearchSources: const ['arxiv', 'pubmed', 'ieee', 'acm'],
        ethicalConcerns: const [EthicalConcern.addictionResearch],
        maxResearchResults: 25,
        assetGenerationSettings: {
          'quality': 'high',
          'parallel_processing': true,
        },
        engineConfig: {
          'optimization_level': 'advanced',
          'debug_mode': false,
        },
        codeGenerationOptions: {
          'include_comments': true,
          'follow_best_practices': true,
        },
        buildConfig: {
          'optimization': 'release',
          'compression': true,
        },
      );
    }
  }
}

// ============================================================================
// DATA MODELS FOR NEW FEATURES
// ============================================================================

@freezed
class AIInsight with _$AIInsight {
  const factory AIInsight({
    required String id,
    required AIInsightType type,
    required String title,
    required String description,
    required InsightPriority priority,
    required List<String> suggestedActions,
    @Default(false) bool resolved,
  }) = _AIInsight;

  factory AIInsight.fromJson(Map<String, dynamic> json) => _$AIInsightFromJson(json);
}

enum AIInsightType {
  info,
  suggestion,
  warning,
  error,
}

enum InsightPriority {
  low,
  medium,
  high,
  critical,
}

@freezed
class RetrospectiveSession with _$RetrospectiveSession {
  const factory RetrospectiveSession({
    required String id,
    required String projectId,
    required DateTime date,
    required List<String> insights,
    required List<String> recommendations,
    required List<ActionItem> actionItems,
  }) = _RetrospectiveSession;

  factory RetrospectiveSession.fromJson(Map<String, dynamic> json) => _$RetrospectiveSessionFromJson(json);
}

@freezed
class ActionItem with _$ActionItem {
  const factory ActionItem({
    required String id,
    required String title,
    required String description,
    required String assignee,
    required DateTime dueDate,
    required ActionPriority priority,
    @Default(false) bool completed,
  }) = _ActionItem;

  factory ActionItem.fromJson(Map<String, dynamic> json) => _$ActionItemFromJson(json);
}

enum ActionPriority {
  low,
  medium,
  high,
  urgent,
} 