import 'package:flutter/foundation.dart';

@immutable
class JamSeed {
  const JamSeed({
    required this.id,
    required this.title,
    required this.coreConcept,
    required this.inspirationElements,
    required this.creativeConstraints,
    this.communityContributions = const [],
    this.voteCount = 0,
    this.submitter = 'AI Assistant',
    this.createdAt,
    this.isCommunityDriven = false,
    this.evolvedJamKit, // Link to the evolved Jam Kit
    this.status = JamSeedStatus.brainstorming, // Current phase
    this.inspirator, // The person who originally had the idea
    this.contributors = const [], // People who contributed to development
    this.tags = const [], // For categorization and discovery
    this.labExperiments = const [], // Research experiments from Jam Lab
    this.integratedExperiments = const [], // Experiments integrated into this jam
    this.experimentalConstraints = const [], // Experimental constraints to test
  });

  final String id;
  final String title;
  final String coreConcept; // Flexible concept instead of rigid theme
  final List<String> inspirationElements; // Keywords, ideas, references
  final List<String> creativeConstraints; // Guidelines, not rules
  final List<CommunityContribution> communityContributions;
  final int voteCount;
  final String submitter;
  final DateTime? createdAt;
  final bool isCommunityDriven; // True if community-created, false if AI-generated
  final JamKit? evolvedJamKit; // The concrete Jam Kit this seed evolved into
  final JamSeedStatus status; // Current development phase
  final CommunityMember? inspirator; // The person who originally had the idea
  final List<CommunityMember> contributors; // People who contributed to development
  final List<String> tags; // For categorization and discovery
  final List<LabExperiment> labExperiments; // Research experiments from Jam Lab
  final List<IntegratedExperiment> integratedExperiments; // Experiments integrated into this jam
  final List<String> experimentalConstraints; // Experimental constraints to test
}

enum JamSeedStatus {
  brainstorming, // Community is brainstorming and voting
  refining, // Top seeds are being refined
  evolving, // Seed is being converted to Jam Kit
  concrete, // Jam Kit has been created
  completed, // Game Jam is finished
  researching, // Being researched in Jam Lab
}

enum CommunityRole {
  inspirator, // Original idea creator
  contributor, // Active contributor
  voter, // Community voter
  moderator, // Community moderator
  developer, // Game developer using the concept
  researcher, // Jam Lab researcher
  labScientist, // Advanced researcher in Jam Lab
}

@immutable
class CommunityMember {
  const CommunityMember({
    required this.id,
    required this.username,
    required this.displayName,
    this.avatar,
    this.role = CommunityRole.contributor,
    this.reputation = 0,
    this.badges = const [],
    this.createdAt,
    this.researchPoints = 0, // Points earned from Jam Lab research
  });

  final String id;
  final String username;
  final String displayName;
  final String? avatar;
  final CommunityRole role;
  final int reputation;
  final List<String> badges;
  final DateTime? createdAt;
  final int researchPoints; // Points earned from Jam Lab research
}

@immutable
class CommunityContribution {
  const CommunityContribution({
    required this.id,
    required this.contributor,
    required this.type, // 'mechanic', 'art_style', 'story_element', 'constraint'
    required this.content,
    required this.timestamp,
    this.voteCount = 0,
    this.isAccepted = false, // Whether this contribution was accepted into the final concept
  });

  final String id;
  final CommunityMember contributor;
  final String type;
  final String content;
  final DateTime timestamp;
  final int voteCount;
  final bool isAccepted; // Whether this contribution was accepted into the final concept
}

@immutable
class LabExperiment {
  const LabExperiment({
    required this.id,
    required this.title,
    required this.description,
    required this.researcher,
    required this.experimentType,
    required this.hypothesis,
    required this.methodology,
    this.results,
    this.conclusions,
    this.createdAt,
    this.completedAt,
    this.status = ExperimentStatus.inProgress,
    this.impactScore = 0, // How much this experiment influenced game design
    this.tags = const [],
  });

  final String id;
  final String title;
  final String description;
  final CommunityMember researcher;
  final ExperimentType experimentType;
  final String hypothesis; // What we're testing
  final String methodology; // How we're testing it
  final String? results; // What we found
  final String? conclusions; // What it means
  final DateTime? createdAt;
  final DateTime? completedAt;
  final ExperimentStatus status;
  final int impactScore; // How much this experiment influenced game design
  final List<String> tags;
}

enum ExperimentType {
  mechanics, // Testing new game mechanics
  psychology, // Player psychology and behavior
  accessibility, // Making games more accessible
  monetization, // Revenue models and pricing
  social, // Multiplayer and social features
  ai, // AI integration in games
  narrative, // Storytelling techniques
  visual, // Visual design and art styles
  audio, // Sound design and music
  performance, // Technical optimization
  crossPlatform, // Multi-platform development
  emergingTech, // VR, AR, blockchain, etc.
}

enum ExperimentStatus {
  planning, // Experiment is being planned
  inProgress, // Experiment is currently running
  analyzing, // Results are being analyzed
  completed, // Experiment is finished
  published, // Results are published
  failed, // Experiment failed
}

/// 🛠️ Jam Kit - Konkreter Leitfaden für Game Jam Events
/// 
/// Ein Jam Kit ist ein konkreter, umsetzbarer Leitfaden für Game Jam Events.
/// Er entwickelt sich aus Jam Seeds und ist für den Jam-Zeitrahmen optimiert.
/// 
/// Eigenschaften:
/// - Konkret: Spezifische Anweisungen und Ressourcen
/// - Umsetzbar: Direkt für Game Jam Entwicklung verwendbar
/// - Zeitlich begrenzt: Optimiert für Jam-Zeitrahmen
/// - Vereinfacht: Fokus auf Schnelligkeit und Umsetzbarkeit
/// - Genre-agnostisch: Enthält keine expliziten Genre-Felder
/// 
/// Verwendung: Wird direkt in Game Jam Events verwendet, um Spiele zu entwickeln.
@immutable
class JamKit {
  const JamKit({
    required this.id,
    required this.title,
    required this.theme, // Specific theme and setting for the jam
    required this.quests, // Clear objectives for the jam
    required this.assetSuggestions, // Asset suggestions with style prompts
    this.inspirationSources = const [],
    this.sourceJamSeed, // Link back to the original Jam Seed
    this.inspirator, // The original inspirator
    this.contributors = const [], // People who helped develop the kit
    this.researchInsights = const [], // Insights from Jam Lab research
    this.buildingComponents = const [], // Modular building components
    this.constructionGuides = const [], // Step-by-step construction guides (simplified for jam timeframe)
    this.kitType = KitType.standard, // Type of kit (standard, building, experimental)
    this.complexity = Complexity.intermediate, // Complexity level
    this.estimatedBuildTime = Duration.zero, // Estimated time to build (optimized for jam)
  });

  final String id;
  final String title;
  final String theme; // Specific theme and setting for the jam
  final List<Quest> quests; // Clear objectives for the jam
  final List<AssetSuggestion> assetSuggestions; // Asset suggestions with style prompts
  final List<String> inspirationSources;
  final JamSeed? sourceJamSeed; // The Jam Seed this Kit evolved from
  final CommunityMember? inspirator; // The original inspirator
  final List<CommunityMember> contributors; // People who helped develop the kit
  final List<LabExperiment> researchInsights; // Insights from Jam Lab research
  final List<BuildingComponent> buildingComponents; // Modular building components
  final List<ConstructionGuide> constructionGuides; // Step-by-step construction guides (simplified for jam timeframe)
  final KitType kitType; // Type of kit (standard, building, experimental)
  final Complexity complexity; // Complexity level
  final Duration estimatedBuildTime; // Estimated time to build (optimized for jam)
}

enum KitType {
  standard, // Traditional game concept kit
  building, // Modular building kit with components
  experimental, // Kit incorporating Jam Lab experiments
  hybrid, // Combination of multiple types
}

enum Complexity {
  beginner, // Easy to implement
  intermediate, // Moderate complexity
  advanced, // Complex implementation
  expert, // Expert-level development
}

@immutable
class BuildingComponent {
  const BuildingComponent({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.assets,
    this.dependencies = const [], // Other components this depends on
    this.alternatives = const [], // Alternative components
    this.customizationOptions = const [], // Ways to customize this component
    this.estimatedTime = Duration.zero, // Time to implement this component
  });

  final String id;
  final String name;
  final String description;
  final ComponentType type;
  final List<AssetSuggestion> assets;
  final List<String> dependencies; // Other components this depends on
  final List<String> alternatives; // Alternative components
  final List<CustomizationOption> customizationOptions; // Ways to customize this component
  final Duration estimatedTime; // Time to implement this component
}

enum ComponentType {
  core, // Essential game systems
  mechanics, // Gameplay mechanics
  ui, // User interface elements
  audio, // Sound and music
  visual, // Visual effects and art
  ai, // Artificial intelligence
  networking, // Multiplayer/networking
  data, // Data management
  tools, // Development tools
}

@immutable
class CustomizationOption {
  const CustomizationOption({
    required this.name,
    required this.description,
    required this.type,
    this.defaultValue,
    this.options = const [],
  });

  final String name;
  final String description;
  final CustomizationType type;
  final String? defaultValue;
  final List<String> options; // Available options for choice-based customization
}

enum CustomizationType {
  boolean, // On/off toggle
  choice, // Multiple choice selection
  range, // Numeric range (e.g., difficulty 1-10)
  text, // Free text input
  color, // Color selection
  file, // File upload
}

@immutable
class ConstructionGuide {
  const ConstructionGuide({
    required this.id,
    required this.title,
    required this.description,
    required this.steps,
    this.prerequisites = const [], // Required knowledge/skills
    this.tools = const [], // Required tools/software
    this.tips = const [], // Helpful tips
    this.troubleshooting = const [], // Common issues and solutions
  });

  final String id;
  final String title;
  final String description;
  final List<ConstructionStep> steps;
  final List<String> prerequisites; // Required knowledge/skills
  final List<String> tools; // Required tools/software
  final List<String> tips; // Helpful tips
  final List<TroubleshootingItem> troubleshooting; // Common issues and solutions
}

@immutable
class ConstructionStep {
  const ConstructionStep({
    required this.id,
    required this.title,
    required this.description,
    required this.order,
    this.estimatedTime = Duration.zero,
    this.components = const [], // Components involved in this step
    this.codeSnippets = const [], // Code examples
    this.screenshots = const [], // Visual references
  });

  final String id;
  final String title;
  final String description;
  final int order;
  final Duration estimatedTime;
  final List<String> components; // Components involved in this step
  final List<CodeSnippet> codeSnippets; // Code examples
  final List<String> screenshots; // Visual references
}

@immutable
class CodeSnippet {
  const CodeSnippet({
    required this.title,
    required this.code,
    required this.language,
    this.description,
  });

  final String title;
  final String code;
  final String language;
  final String? description;
}

@immutable
class TroubleshootingItem {
  const TroubleshootingItem({
    required this.problem,
    required this.solution,
    this.cause,
  });

  final String problem;
  final String solution;
  final String? cause;
}

@immutable
class Quest {
  const Quest({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;
}

@immutable
class AssetSuggestion {
  const AssetSuggestion({
    required this.type,
    required this.description,
    required this.stylePrompt,
  });

  final String type;
  final String description;
  final String stylePrompt;
}

@immutable
class IntegratedExperiment {
  const IntegratedExperiment({
    required this.experiment,
    required this.integrationType,
    required this.implementationNotes,
    this.successMetrics = const [], // How to measure success
    this.expectedOutcomes = const [], // Expected results
    this.riskLevel = RiskLevel.low, // Risk level of this experiment
  });

  final LabExperiment experiment;
  final ExperimentIntegrationType integrationType;
  final String implementationNotes;
  final List<String> successMetrics; // How to measure success
  final List<String> expectedOutcomes; // Expected results
  final RiskLevel riskLevel; // Risk level of this experiment
}

enum ExperimentIntegrationType {
  core, // Experiment is core to the game concept
  optional, // Experiment can be optionally implemented
  alternative, // Experiment provides alternative approach
  enhancement, // Experiment enhances existing features
}

enum RiskLevel {
  low, // Low risk, safe to implement
  medium, // Moderate risk, some uncertainty
  high, // High risk, experimental approach
  extreme, // Very high risk, cutting-edge research
}
