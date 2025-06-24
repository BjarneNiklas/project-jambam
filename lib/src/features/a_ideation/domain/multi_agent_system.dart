import 'package:freezed_annotation/freezed_annotation.dart';

part 'multi_agent_system.freezed.dart';
part 'multi_agent_system.g.dart';

/// Multi-Agenten System für KI-generierte Game Development
@freezed
class MultiAgentSystem with _$MultiAgentSystem {
  const factory MultiAgentSystem({
    required ResearchAgent researchAgent,
    required CreativeDirectorAgent creativeDirectorAgent,
    required AssetGenerationAgent assetGenerationAgent,
    required AgentOrchestrator orchestrator,
  }) = _MultiAgentSystem;

  factory MultiAgentSystem.fromJson(Map<String, dynamic> json) =>
      _$MultiAgentSystemFromJson(json);
}

/// Research Agent - Wissenschaftlich fundierte Forschung
@freezed
class ResearchAgent with _$ResearchAgent {
  const factory ResearchAgent({
    required String id,
    required String name,
    required AgentStatus status,
    required List<ResearchSource> activeSources,
    required List<EthicalConcern> ethicalControls,
    required ResearchMetrics metrics,
    required AgentCapabilities capabilities,
  }) = _ResearchAgent;

  factory ResearchAgent.fromJson(Map<String, dynamic> json) =>
      _$ResearchAgentFromJson(json);
}

/// Creative Director Agent - Game Design & Storytelling
@freezed
class CreativeDirectorAgent with _$CreativeDirectorAgent {
  const factory CreativeDirectorAgent({
    required String id,
    required String name,
    required AgentStatus status,
    required GameDesignDocument currentDesign,
    required List<CreativeDomain> domains,
    required CreativeMetrics metrics,
    required AgentCapabilities capabilities,
  }) = _CreativeDirectorAgent;

  factory CreativeDirectorAgent.fromJson(Map<String, dynamic> json) =>
      _$CreativeDirectorAgentFromJson(json);
}

/// Asset Generation Agent - 3D Assets & Media
@freezed
class AssetGenerationAgent with _$AssetGenerationAgent {
  const factory AssetGenerationAgent({
    required String id,
    required String name,
    required AgentStatus status,
    required List<AssetType> supportedTypes,
    required List<GenerationEngine> engines,
    required AssetMetrics metrics,
    required AgentCapabilities capabilities,
  }) = _AssetGenerationAgent;

  factory AssetGenerationAgent.fromJson(Map<String, dynamic> json) =>
      _$AssetGenerationAgentFromJson(json);
}

/// Agent Orchestrator - Koordination & Workflow
@freezed
class AgentOrchestrator with _$AgentOrchestrator {
  const factory AgentOrchestrator({
    required String id,
    required String name,
    required AgentStatus status,
    required WorkflowPipeline pipeline,
    required List<AgentCommunication> communications,
    required OrchestratorMetrics metrics,
    required AgentCapabilities capabilities,
  }) = _AgentOrchestrator;

  factory AgentOrchestrator.fromJson(Map<String, dynamic> json) =>
      _$AgentOrchestratorFromJson(json);
}

// Enums & Supporting Classes

enum AgentStatus {
  idle,
  active,
  processing,
  error,
  completed,
}

enum EthicalConcern {
  addictionResearch,
  communityManipulation,
  aiBias,
  commercialization,
  echoChambers,
}

enum CreativeDomain {
  gameMechanics,
  narrative,
  uxDesign,
  gamification,
  accessibility,
  culturalSensitivity,
}

enum AssetType {
  model3d,
  texture,
  animation,
  audio,
  shader,
  material,
  rig,
  particle,
}

enum GenerationEngine {
  blender,
  stableDiffusion,
  audioCraft,
  openUSD,
  brickGPT,
  custom,
}

@freezed
class ResearchSource with _$ResearchSource {
  const factory ResearchSource({
    required String id,
    required String name,
    required String category,
    required bool isEnabled,
    required List<EthicalConcern> ethicalConcerns,
    required int priority,
  }) = _ResearchSource;

  factory ResearchSource.fromJson(Map<String, dynamic> json) =>
      _$ResearchSourceFromJson(json);
}

@freezed
class GameDesignDocument with _$GameDesignDocument {
  const factory GameDesignDocument({
    required String title,
    required String genre,
    required String targetAudience,
    required List<GameMechanic> mechanics,
    required NarrativeStructure narrative,
    required UXDesign uxDesign,
    required AccessibilityFeatures accessibility,
  }) = _GameDesignDocument;

  factory GameDesignDocument.fromJson(Map<String, dynamic> json) =>
      _$GameDesignDocumentFromJson(json);
}

@freezed
class GameMechanic with _$GameMechanic {
  const factory GameMechanic({
    required String name,
    required String description,
    required MechanicType type,
    required double complexity,
    required List<String> dependencies,
  }) = _GameMechanic;

  factory GameMechanic.fromJson(Map<String, dynamic> json) =>
      _$GameMechanicFromJson(json);
}

enum MechanicType {
  core,
  secondary,
  optional,
  accessibility,
}

@freezed
class NarrativeStructure with _$NarrativeStructure {
  const factory NarrativeStructure({
    required String theme,
    required String setting,
    required List<StoryBeat> storyBeats,
    required List<Character> characters,
    required NarrativeStyle style,
  }) = _NarrativeStructure;

  factory NarrativeStructure.fromJson(Map<String, dynamic> json) =>
      _$NarrativeStructureFromJson(json);
}

@freezed
class StoryBeat with _$StoryBeat {
  const factory StoryBeat({
    required String id,
    required String description,
    required int order,
    required BeatType type,
    required List<String> triggers,
  }) = _StoryBeat;

  factory StoryBeat.fromJson(Map<String, dynamic> json) =>
      _$StoryBeatFromJson(json);
}

enum BeatType {
  introduction,
  conflict,
  climax,
  resolution,
  optional,
}

@freezed
class Character with _$Character {
  const factory Character({
    required String name,
    required String description,
    required CharacterRole role,
    required List<String> traits,
    required CharacterArc arc,
  }) = _Character;

  factory Character.fromJson(Map<String, dynamic> json) =>
      _$CharacterFromJson(json);
}

enum CharacterRole {
  protagonist,
  antagonist,
  supporting,
  npc,
}

enum CharacterArc {
  flat,
  positive,
  negative,
  complex,
}

enum NarrativeStyle {
  linear,
  branching,
  emergent,
  environmental,
}

@freezed
class UXDesign with _$UXDesign {
  const factory UXDesign({
    required String targetPlatform,
    required List<UIPattern> patterns,
    required AccessibilityLevel accessibility,
    required List<String> userFlows,
  }) = _UXDesign;

  factory UXDesign.fromJson(Map<String, dynamic> json) =>
      _$UXDesignFromJson(json);
}

enum UIPattern {
  card,
  list,
  grid,
  modal,
  navigation,
  form,
  dashboard,
}

enum AccessibilityLevel {
  basic,
  intermediate,
  advanced,
  expert,
}

@freezed
class AccessibilityFeatures with _$AccessibilityFeatures {
  const factory AccessibilityFeatures({
    required bool screenReaderSupport,
    required bool keyboardNavigation,
    required bool colorBlindSupport,
    required bool hearingImpairedSupport,
    required bool motorImpairedSupport,
    required List<String> customFeatures,
  }) = _AccessibilityFeatures;

  factory AccessibilityFeatures.fromJson(Map<String, dynamic> json) =>
      _$AccessibilityFeaturesFromJson(json);
}

@freezed
class WorkflowPipeline with _$WorkflowPipeline {
  const factory WorkflowPipeline({
    required List<WorkflowStep> steps,
    required Map<String, dynamic> configuration,
    required PipelineStatus status,
  }) = _WorkflowPipeline;

  factory WorkflowPipeline.fromJson(Map<String, dynamic> json) =>
      _$WorkflowPipelineFromJson(json);
}

@freezed
class WorkflowStep with _$WorkflowStep {
  const factory WorkflowStep({
    required String id,
    required String name,
    required AgentType agent,
    required StepStatus status,
    required Map<String, dynamic> input,
    required Map<String, dynamic> output,
  }) = _WorkflowStep;

  factory WorkflowStep.fromJson(Map<String, dynamic> json) =>
      _$WorkflowStepFromJson(json);
}

enum AgentType {
  research,
  creativeDirector,
  assetGeneration,
  orchestrator,
}

enum StepStatus {
  pending,
  running,
  completed,
  failed,
  skipped,
}

enum PipelineStatus {
  idle,
  running,
  completed,
  error,
  paused,
}

@freezed
class AgentCommunication with _$AgentCommunication {
  const factory AgentCommunication({
    required String fromAgent,
    required String toAgent,
    required CommunicationType type,
    required Map<String, dynamic> data,
    required DateTime timestamp,
  }) = _AgentCommunication;

  factory AgentCommunication.fromJson(Map<String, dynamic> json) =>
      _$AgentCommunicationFromJson(json);
}

enum CommunicationType {
  request,
  response,
  notification,
  error,
  status,
}

@freezed
class AgentCapabilities with _$AgentCapabilities {
  const factory AgentCapabilities({
    required List<String> supportedInputs,
    required List<String> supportedOutputs,
    required Map<String, dynamic> configuration,
    required List<String> limitations,
  }) = _AgentCapabilities;

  factory AgentCapabilities.fromJson(Map<String, dynamic> json) =>
      _$AgentCapabilitiesFromJson(json);
}

// Metrics Classes
@freezed
class ResearchMetrics with _$ResearchMetrics {
  const factory ResearchMetrics({
    required int totalSources,
    required int activeSources,
    required int queriesProcessed,
    required double averageResponseTime,
    required List<String> topSources,
  }) = _ResearchMetrics;

  factory ResearchMetrics.fromJson(Map<String, dynamic> json) =>
      _$ResearchMetricsFromJson(json);
}

@freezed
class CreativeMetrics with _$CreativeMetrics {
  const factory CreativeMetrics({
    required int designsCreated,
    required int mechanicsGenerated,
    required int narrativesWritten,
    required double creativityScore,
    required List<String> popularGenres,
  }) = _CreativeMetrics;

  factory CreativeMetrics.fromJson(Map<String, dynamic> json) =>
      _$CreativeMetricsFromJson(json);
}

@freezed
class AssetMetrics with _$AssetMetrics {
  const factory AssetMetrics({
    required int assetsGenerated,
    required Map<AssetType, int> assetsByType,
    required double averageGenerationTime,
    required double qualityScore,
    required List<String> topEngines,
  }) = _AssetMetrics;

  factory AssetMetrics.fromJson(Map<String, dynamic> json) =>
      _$AssetMetricsFromJson(json);
}

@freezed
class OrchestratorMetrics with _$OrchestratorMetrics {
  const factory OrchestratorMetrics({
    required int workflowsCompleted,
    required int totalSteps,
    required double successRate,
    required double averageWorkflowTime,
    required List<String> commonErrors,
  }) = _OrchestratorMetrics;

  factory OrchestratorMetrics.fromJson(Map<String, dynamic> json) =>
      _$OrchestratorMetricsFromJson(json);
}

@freezed
class ResearchResult with _$ResearchResult {
  const factory ResearchResult({
    required String id,
    required String title,
    required String description,
    required String source,
    required DateTime date,
    required List<String> tags,
    required String url,
    required double relevance,
  }) = _ResearchResult;

  factory ResearchResult.fromJson(Map<String, dynamic> json) => _$ResearchResultFromJson(json);
}

@freezed
class GeneratedAsset with _$GeneratedAsset {
  const factory GeneratedAsset({
    required String id,
    required String name,
    required AssetType type,
    required String fileUrl,
    required DateTime createdAt,
    required String engine,
    required Map<String, dynamic> metadata,
    required double quality,
  }) = _GeneratedAsset;

  factory GeneratedAsset.fromJson(Map<String, dynamic> json) => _$GeneratedAssetFromJson(json);
}

@freezed
class ProjectMasterAgent with _$ProjectMasterAgent {
  const factory ProjectMasterAgent({
    required String id,
    required String name,
    required String description,
    required AgentType type,
    required AgentStatus status,
    required Map<String, dynamic> capabilities,
    required List<String> skills,
    required Map<String, dynamic> preferences,
    required DateTime createdAt,
    required DateTime updatedAt,
    required List<Prototype> prototypes,
    required List<PlaytestResult> playtests,
    required List<TeamMember> team,
    required List<GeneratedAsset> assets,
    required List<ProjectDecision> decisions,
  }) = _ProjectMasterAgent;

  factory ProjectMasterAgent.fromJson(Map<String, dynamic> json) => _$ProjectMasterAgentFromJson(json);
}

@freezed
class Prototype with _$Prototype {
  const factory Prototype({
    required String id,
    required String name,
    required String description,
    required DateTime createdAt,
    required String version,
    required List<String> features,
    required String status,
    required String fileUrl,
  }) = _Prototype;

  factory Prototype.fromJson(Map<String, dynamic> json) => _$PrototypeFromJson(json);
}

@freezed
class PlaytestResult with _$PlaytestResult {
  const factory PlaytestResult({
    required String id,
    required String prototypeId,
    required DateTime date,
    required List<FeedbackEntry> feedback,
    required String summary,
    required List<String> issues,
    required List<String> improvements,
    required String title,
    required String description,
    required double rating,
    required Map<String, dynamic> metrics,
  }) = _PlaytestResult;

  factory PlaytestResult.fromJson(Map<String, dynamic> json) => _$PlaytestResultFromJson(json);
}

@freezed
class FeedbackEntry with _$FeedbackEntry {
  const factory FeedbackEntry({
    required String id,
    required String author,
    required String content,
    required DateTime date,
    required FeedbackType type,
  }) = _FeedbackEntry;

  factory FeedbackEntry.fromJson(Map<String, dynamic> json) => _$FeedbackEntryFromJson(json);
}

enum FeedbackType {
  bug,
  suggestion,
  praise,
  question,
  other,
}

@freezed
class TeamMember with _$TeamMember {
  const factory TeamMember({
    required String id,
    required String name,
    required String role,
    required String contact,
    required bool isActive,
    required String expertise,
    required List<String> skills,
    required double availability,
    required Map<String, dynamic> preferences,
  }) = _TeamMember;

  factory TeamMember.fromJson(Map<String, dynamic> json) => _$TeamMemberFromJson(json);
}

@freezed
class ProjectDecision with _$ProjectDecision {
  const factory ProjectDecision({
    required String id,
    required String description,
    required DateTime date,
    required String author,
    required List<String> reasons,
    required List<String> consequences,
  }) = _ProjectDecision;

  factory ProjectDecision.fromJson(Map<String, dynamic> json) => _$ProjectDecisionFromJson(json);
}

@freezed
class LessonLearned with _$LessonLearned {
  const factory LessonLearned({
    required String id,
    required String description,
    required DateTime date,
    required String author,
    required List<String> tags,
  }) = _LessonLearned;

  factory LessonLearned.fromJson(Map<String, dynamic> json) => _$LessonLearnedFromJson(json);
}

enum ProjectStatus {
  planning,
  prototyping,
  playtesting,
  production,
  released,
  archived,
}

// Workflow Configuration
@freezed
class WorkflowConfiguration with _$WorkflowConfiguration {
  const factory WorkflowConfiguration({
    required List<String> enabledResearchSources,
    required List<EthicalConcern> ethicalConcerns,
    required int maxResearchResults,
    required Map<String, dynamic> assetGenerationSettings,
    required Map<String, dynamic> engineConfig,
    required Map<String, dynamic> codeGenerationOptions,
    required Map<String, dynamic> buildConfig,
  }) = _WorkflowConfiguration;

  factory WorkflowConfiguration.fromJson(Map<String, dynamic> json) =>
      _$WorkflowConfigurationFromJson(json);
}

// Workflow Status
@freezed
class WorkflowStatus with _$WorkflowStatus {
  const factory WorkflowStatus({
    required String workflowId,
    required WorkflowType type,
    required String status,
    required double progress,
    required DateTime startTime,
    DateTime? endTime,
    required List<String> logs,
    required List<String> warnings,
    required List<String> errors,
    String? currentStep,
    Duration? estimatedTimeRemaining,
  }) = _WorkflowStatus;

  factory WorkflowStatus.fromJson(Map<String, dynamic> json) =>
      _$WorkflowStatusFromJson(json);
}

// Workflow Type
enum WorkflowType {
  research,
  design,
  assetGeneration,
  engineIntegration,
  full,
  custom,
}

// Engine Build Result
@freezed
class EngineBuildResult with _$EngineBuildResult {
  const factory EngineBuildResult({
    required bool success,
    required String engine,
    required String platform,
    required String buildUrl,
    required DateTime buildTime,
    required List<String> warnings,
    required List<String> errors,
    required Map<String, dynamic> metadata,
  }) = _EngineBuildResult;

  factory EngineBuildResult.fromJson(Map<String, dynamic> json) =>
      _$EngineBuildResultFromJson(json);
}

// Orchestration Result
@freezed
class OrchestrationResult with _$OrchestrationResult {
  const factory OrchestrationResult({
    required String workflowId,
    required bool success,
    required ResearchResult? researchResult,
    required GameDesignDocument? designResult,
    required List<GeneratedAsset>? assetResult,
    required EngineBuildResult? engineResult,
    required List<String> logs,
    required List<String> warnings,
    required Duration totalDuration,
  }) = _OrchestrationResult;

  factory OrchestrationResult.fromJson(Map<String, dynamic> json) =>
      _$OrchestrationResultFromJson(json);
}

enum PrototypeStatus {
  planning,
  development,
  testing,
  review,
  deployed,
  archived,
  inProgress,
  completed,
  failed,
}

// ============================================================================
// DATA MODELS FOR INSIGHTS, RETROSPECTIVES, ACTIONS
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