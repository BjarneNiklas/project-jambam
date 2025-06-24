import '../domain/multi_agent_system.dart' as domain;
import 'research_agent_service.dart' as research;
import 'asset_generation_agent_service.dart' as asset;
import 'game_engine_agent_service.dart' as engine;

/// Workflow Configuration for orchestrating multi-agent workflows
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

/// Workflow Status for tracking workflow execution
class WorkflowStatus {
  final String workflowId;
  final WorkflowType type;
  final String status;
  final double progress;
  final DateTime startTime;
  final DateTime? endTime;
  final List<String> logs;
  final List<String> warnings;
  final List<String> errors;

  const WorkflowStatus({
    required this.workflowId,
    required this.type,
    required this.status,
    required this.progress,
    required this.startTime,
    this.endTime,
    required this.logs,
    required this.warnings,
    required this.errors,
  });
}

/// Workflow Type enumeration
enum WorkflowType {
  research,
  design,
  assetGeneration,
  engineIntegration,
  full,
  custom,
}

/// Engine Build Result for game engine integration
class EngineBuildResult {
  final bool success;
  final String engine;
  final String platform;
  final String buildUrl;
  final DateTime buildTime;
  final List<String> warnings;
  final List<String> errors;
  final Map<String, dynamic> metadata;

  const EngineBuildResult({
    required this.success,
    required this.engine,
    required this.platform,
    required this.buildUrl,
    required this.buildTime,
    required this.warnings,
    required this.errors,
    required this.metadata,
  });
}

/// Orchestration Result for complete workflow execution
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