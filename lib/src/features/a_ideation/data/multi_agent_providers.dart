import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/multi_agent_system.dart' as domain;
import 'project_master_agent_service.dart';
import 'research_agent_service.dart';
import 'creative_director_agent_service.dart';
import 'asset_generation_agent_service.dart';
import 'game_engine_agent_service.dart';
import 'agent_orchestrator_service.dart' as orchestrator;

part 'multi_agent_providers.g.dart';
// part 'multi_agent_providers.freezed.dart'; // Commented out if file does not exist

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
  FutureOr<domain.ProjectMasterAgent?> build() async {
    // Load current project on initialization
    final service = ref.read(projectMasterAgentServiceProvider);
    return await service.loadProject('demo-project');
  }

  Future<void> loadProject(String projectId) async {
    state = const AsyncLoading();
    final service = ref.read(projectMasterAgentServiceProvider);
    state = await AsyncValue.guard(() => service.loadProject(projectId));
  }

  Future<void> saveProject(domain.ProjectMasterAgent project) async {
    final service = ref.read(projectMasterAgentServiceProvider);
    await service.saveProject(project);
    state = AsyncValue.data(project);
  }

  Future<void> addPrototype(domain.Prototype prototype) async {
    final currentProject = state.value;
    if (currentProject != null) {
      final service = ref.read(projectMasterAgentServiceProvider);
      await service.addPrototype(prototype);
      // Reload project to get updated state
      await loadProject(currentProject.id);
    }
  }

  Future<void> addPlaytest(domain.PlaytestResult playtest) async {
    final currentProject = state.value;
    if (currentProject != null) {
      final service = ref.read(projectMasterAgentServiceProvider);
      await service.addPlaytest(playtest);
      await loadProject(currentProject.id);
    }
  }

  Future<void> addFeedback(domain.FeedbackEntry feedback) async {
    final currentProject = state.value;
    if (currentProject != null) {
      final service = ref.read(projectMasterAgentServiceProvider);
      await service.addFeedback(feedback);
      await loadProject(currentProject.id);
    }
  }

  Future<void> addTeamMember(domain.TeamMember member) async {
    final currentProject = state.value;
    if (currentProject != null) {
      final service = ref.read(projectMasterAgentServiceProvider);
      await service.addTeamMember(member);
      await loadProject(currentProject.id);
    }
  }

  Future<void> addDecision(domain.ProjectDecision decision) async {
    final currentProject = state.value;
    if (currentProject != null) {
      final service = ref.read(projectMasterAgentServiceProvider);
      await service.addDecision(decision);
      await loadProject(currentProject.id);
    }
  }

  Future<void> addLesson(domain.LessonLearned lesson) async {
    final currentProject = state.value;
    if (currentProject != null) {
      final service = ref.read(projectMasterAgentServiceProvider);
      await service.addLesson(lesson);
      await loadProject(currentProject.id);
    }
  }

  Future<void> setProjectStatus(domain.ProjectStatus status) async {
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
  List<domain.WorkflowStatus> build() {
    return [];
  }

  Future<void> startWorkflow({
    required domain.WorkflowType type,
    required Map<String, dynamic> parameters,
    required domain.WorkflowConfiguration config,
  }) async {
    final orchestratorService = ref.read(agentOrchestratorServiceProvider);
    final result = await orchestratorService.executeAdaptiveWorkflow(
      type: type,
      parameters: parameters,
      config: config,
    );

    if (result.success) {
      // Add to active workflows
      final workflowStatus = domain.WorkflowStatus(
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
  Map<String, domain.AgentStatus> build() {
    return {
      'research': domain.AgentStatus.active,
      'creative_director': domain.AgentStatus.active,
      'asset_generation': domain.AgentStatus.idle,
      'game_engine': domain.AgentStatus.idle,
      'project_master': domain.AgentStatus.active,
    };
  }

  void updateAgentStatus(String agentId, domain.AgentStatus status) {
    state = {...state, agentId: status};
  }

  void setAllAgentsIdle() {
    state = {
      for (var entry in state.entries)
        entry.key: domain.AgentStatus.idle
    };
  }

  void setAgentActive(String agentId) {
    updateAgentStatus(agentId, domain.AgentStatus.active);
  }

  void setAgentError(String agentId) {
    updateAgentStatus(agentId, domain.AgentStatus.error);
  }
}

// ============================================================================
// KI-INTEGRATION & INSIGHTS
// ============================================================================

@riverpod
class AIInsights extends _$AIInsights {
  @override
  List<domain.AIInsight> build() {
    return [];
  }

  Future<void> generateInsights(domain.ProjectMasterAgent project) async {
    final insights = <domain.AIInsight>[];

    // Analyze project status and generate insights
    if (project.prototypes.isEmpty) {
      insights.add(domain.AIInsight(
        id: 'no-prototypes',
        type: domain.AIInsightType.warning,
        title: 'Keine Prototypen vorhanden',
        description: 'Erstelle einen ersten Prototypen, um das Konzept zu testen.',
        priority: domain.InsightPriority.high,
        suggestedActions: ['Prototyp erstellen', 'Design verfeinern'],
      ));
    }

    if (project.playtests.isEmpty) {
      insights.add(domain.AIInsight(
        id: 'no-playtests',
        type: domain.AIInsightType.suggestion,
        title: 'Playtests empfohlen',
        description: 'Führe Playtests durch, um Feedback zu sammeln.',
        priority: domain.InsightPriority.medium,
        suggestedActions: ['Playtest planen', 'Testgruppe finden'],
      ));
    }

    if (project.team.length < 2) {
      insights.add(domain.AIInsight(
        id: 'small-team',
        type: domain.AIInsightType.info,
        title: 'Kleines Team',
        description: 'Erwäge, weitere Teammitglieder hinzuzufügen.',
        priority: domain.InsightPriority.low,
        suggestedActions: ['Team erweitern', 'Rollen definieren'],
      ));
    }

    state = insights;
  }

  void addInsight(domain.AIInsight insight) {
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
  List<domain.RetrospectiveSession> build() {
    return [];
  }

  Future<void> generateRetrospective(domain.ProjectMasterAgent project) async {
    final session = domain.RetrospectiveSession(
      id: 'retro_${DateTime.now().millisecondsSinceEpoch}',
      projectId: project.id,
      date: DateTime.now(),
      insights: _analyzeProjectInsights(project),
      recommendations: _generateRecommendations(project),
      actionItems: _createActionItems(project),
    );

    state = [...state, session];
  }

  List<String> _analyzeProjectInsights(domain.ProjectMasterAgent project) {
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

  List<String> _generateRecommendations(domain.ProjectMasterAgent project) {
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

  List<domain.ActionItem> _createActionItems(domain.ProjectMasterAgent project) {
    return [
      domain.ActionItem(
        id: 'action_1',
        title: 'Nächsten Prototypen planen',
        description: 'Basierend auf Feedback den nächsten Prototypen entwickeln',
        assignee: project.team.isNotEmpty ? project.team.first.name : 'Team',
        dueDate: DateTime.now().add(const Duration(days: 7)),
        priority: domain.ActionPriority.high,
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
  domain.WorkflowConfiguration build() {
    return domain.WorkflowConfiguration(
      enabledResearchSources: const ['arxiv'],
      ethicalConcerns: const [domain.EthicalConcern.addictionResearch],
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
      state = domain.WorkflowConfiguration(
        enabledResearchSources: const ['arxiv', 'pubmed'],
        ethicalConcerns: const [domain.EthicalConcern.addictionResearch],
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
      state = domain.WorkflowConfiguration(
        enabledResearchSources: const ['arxiv', 'pubmed', 'ieee', 'acm'],
        ethicalConcerns: const [domain.EthicalConcern.addictionResearch],
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
      state = domain.WorkflowConfiguration(
        enabledResearchSources: const ['arxiv', 'pubmed', 'ieee', 'acm'],
        ethicalConcerns: const [domain.EthicalConcern.addictionResearch],
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
      state = domain.WorkflowConfiguration(
        enabledResearchSources: const ['arxiv'],
        ethicalConcerns: const [domain.EthicalConcern.addictionResearch],
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
      state = domain.WorkflowConfiguration(
        enabledResearchSources: const ['arxiv', 'pubmed', 'ieee'],
        ethicalConcerns: const [domain.EthicalConcern.addictionResearch],
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
      state = domain.WorkflowConfiguration(
        enabledResearchSources: const ['arxiv', 'pubmed', 'ieee', 'acm'],
        ethicalConcerns: const [domain.EthicalConcern.addictionResearch],
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