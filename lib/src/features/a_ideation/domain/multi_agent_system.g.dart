// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multi_agent_system.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MultiAgentSystemImpl _$$MultiAgentSystemImplFromJson(
  Map<String, dynamic> json,
) => _$MultiAgentSystemImpl(
  researchAgent: ResearchAgent.fromJson(
    json['researchAgent'] as Map<String, dynamic>,
  ),
  creativeDirectorAgent: CreativeDirectorAgent.fromJson(
    json['creativeDirectorAgent'] as Map<String, dynamic>,
  ),
  assetGenerationAgent: AssetGenerationAgent.fromJson(
    json['assetGenerationAgent'] as Map<String, dynamic>,
  ),
  orchestrator: AgentOrchestrator.fromJson(
    json['orchestrator'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$$MultiAgentSystemImplToJson(
  _$MultiAgentSystemImpl instance,
) => <String, dynamic>{
  'researchAgent': instance.researchAgent,
  'creativeDirectorAgent': instance.creativeDirectorAgent,
  'assetGenerationAgent': instance.assetGenerationAgent,
  'orchestrator': instance.orchestrator,
};

_$ResearchAgentImpl _$$ResearchAgentImplFromJson(Map<String, dynamic> json) =>
    _$ResearchAgentImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      status: $enumDecode(_$AgentStatusEnumMap, json['status']),
      activeSources: (json['activeSources'] as List<dynamic>)
          .map((e) => ResearchSource.fromJson(e as Map<String, dynamic>))
          .toList(),
      ethicalControls: (json['ethicalControls'] as List<dynamic>)
          .map((e) => $enumDecode(_$EthicalConcernEnumMap, e))
          .toList(),
      metrics: ResearchMetrics.fromJson(
        json['metrics'] as Map<String, dynamic>,
      ),
      capabilities: AgentCapabilities.fromJson(
        json['capabilities'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$$ResearchAgentImplToJson(_$ResearchAgentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'status': _$AgentStatusEnumMap[instance.status]!,
      'activeSources': instance.activeSources,
      'ethicalControls': instance.ethicalControls
          .map((e) => _$EthicalConcernEnumMap[e]!)
          .toList(),
      'metrics': instance.metrics,
      'capabilities': instance.capabilities,
    };

const _$AgentStatusEnumMap = {
  AgentStatus.idle: 'idle',
  AgentStatus.active: 'active',
  AgentStatus.processing: 'processing',
  AgentStatus.error: 'error',
  AgentStatus.completed: 'completed',
};

const _$EthicalConcernEnumMap = {
  EthicalConcern.addictionResearch: 'addictionResearch',
  EthicalConcern.communityManipulation: 'communityManipulation',
  EthicalConcern.aiBias: 'aiBias',
  EthicalConcern.commercialization: 'commercialization',
  EthicalConcern.echoChambers: 'echoChambers',
};

_$CreativeDirectorAgentImpl _$$CreativeDirectorAgentImplFromJson(
  Map<String, dynamic> json,
) => _$CreativeDirectorAgentImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  status: $enumDecode(_$AgentStatusEnumMap, json['status']),
  currentDesign: GameDesignDocument.fromJson(
    json['currentDesign'] as Map<String, dynamic>,
  ),
  domains: (json['domains'] as List<dynamic>)
      .map((e) => $enumDecode(_$CreativeDomainEnumMap, e))
      .toList(),
  metrics: CreativeMetrics.fromJson(json['metrics'] as Map<String, dynamic>),
  capabilities: AgentCapabilities.fromJson(
    json['capabilities'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$$CreativeDirectorAgentImplToJson(
  _$CreativeDirectorAgentImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'status': _$AgentStatusEnumMap[instance.status]!,
  'currentDesign': instance.currentDesign,
  'domains': instance.domains.map((e) => _$CreativeDomainEnumMap[e]!).toList(),
  'metrics': instance.metrics,
  'capabilities': instance.capabilities,
};

const _$CreativeDomainEnumMap = {
  CreativeDomain.gameMechanics: 'gameMechanics',
  CreativeDomain.narrative: 'narrative',
  CreativeDomain.uxDesign: 'uxDesign',
  CreativeDomain.gamification: 'gamification',
  CreativeDomain.accessibility: 'accessibility',
  CreativeDomain.culturalSensitivity: 'culturalSensitivity',
};

_$AssetGenerationAgentImpl _$$AssetGenerationAgentImplFromJson(
  Map<String, dynamic> json,
) => _$AssetGenerationAgentImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  status: $enumDecode(_$AgentStatusEnumMap, json['status']),
  supportedTypes: (json['supportedTypes'] as List<dynamic>)
      .map((e) => $enumDecode(_$AssetTypeEnumMap, e))
      .toList(),
  engines: (json['engines'] as List<dynamic>)
      .map((e) => $enumDecode(_$GenerationEngineEnumMap, e))
      .toList(),
  metrics: AssetMetrics.fromJson(json['metrics'] as Map<String, dynamic>),
  capabilities: AgentCapabilities.fromJson(
    json['capabilities'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$$AssetGenerationAgentImplToJson(
  _$AssetGenerationAgentImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'status': _$AgentStatusEnumMap[instance.status]!,
  'supportedTypes': instance.supportedTypes
      .map((e) => _$AssetTypeEnumMap[e]!)
      .toList(),
  'engines': instance.engines
      .map((e) => _$GenerationEngineEnumMap[e]!)
      .toList(),
  'metrics': instance.metrics,
  'capabilities': instance.capabilities,
};

const _$AssetTypeEnumMap = {
  AssetType.model3d: 'model3d',
  AssetType.texture: 'texture',
  AssetType.animation: 'animation',
  AssetType.audio: 'audio',
  AssetType.shader: 'shader',
  AssetType.material: 'material',
  AssetType.rig: 'rig',
  AssetType.particle: 'particle',
};

const _$GenerationEngineEnumMap = {
  GenerationEngine.blender: 'blender',
  GenerationEngine.stableDiffusion: 'stableDiffusion',
  GenerationEngine.audioCraft: 'audioCraft',
  GenerationEngine.openUSD: 'openUSD',
  GenerationEngine.brickGPT: 'brickGPT',
  GenerationEngine.custom: 'custom',
};

_$AgentOrchestratorImpl _$$AgentOrchestratorImplFromJson(
  Map<String, dynamic> json,
) => _$AgentOrchestratorImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  status: $enumDecode(_$AgentStatusEnumMap, json['status']),
  pipeline: WorkflowPipeline.fromJson(json['pipeline'] as Map<String, dynamic>),
  communications: (json['communications'] as List<dynamic>)
      .map((e) => AgentCommunication.fromJson(e as Map<String, dynamic>))
      .toList(),
  metrics: OrchestratorMetrics.fromJson(
    json['metrics'] as Map<String, dynamic>,
  ),
  capabilities: AgentCapabilities.fromJson(
    json['capabilities'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$$AgentOrchestratorImplToJson(
  _$AgentOrchestratorImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'status': _$AgentStatusEnumMap[instance.status]!,
  'pipeline': instance.pipeline,
  'communications': instance.communications,
  'metrics': instance.metrics,
  'capabilities': instance.capabilities,
};

_$ResearchSourceImpl _$$ResearchSourceImplFromJson(Map<String, dynamic> json) =>
    _$ResearchSourceImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      isEnabled: json['isEnabled'] as bool,
      ethicalConcerns: (json['ethicalConcerns'] as List<dynamic>)
          .map((e) => $enumDecode(_$EthicalConcernEnumMap, e))
          .toList(),
      priority: (json['priority'] as num).toInt(),
    );

Map<String, dynamic> _$$ResearchSourceImplToJson(
  _$ResearchSourceImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'category': instance.category,
  'isEnabled': instance.isEnabled,
  'ethicalConcerns': instance.ethicalConcerns
      .map((e) => _$EthicalConcernEnumMap[e]!)
      .toList(),
  'priority': instance.priority,
};

_$GameDesignDocumentImpl _$$GameDesignDocumentImplFromJson(
  Map<String, dynamic> json,
) => _$GameDesignDocumentImpl(
  title: json['title'] as String,
  genre: json['genre'] as String,
  targetAudience: json['targetAudience'] as String,
  mechanics: (json['mechanics'] as List<dynamic>)
      .map((e) => GameMechanic.fromJson(e as Map<String, dynamic>))
      .toList(),
  narrative: NarrativeStructure.fromJson(
    json['narrative'] as Map<String, dynamic>,
  ),
  uxDesign: UXDesign.fromJson(json['uxDesign'] as Map<String, dynamic>),
  accessibility: AccessibilityFeatures.fromJson(
    json['accessibility'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$$GameDesignDocumentImplToJson(
  _$GameDesignDocumentImpl instance,
) => <String, dynamic>{
  'title': instance.title,
  'genre': instance.genre,
  'targetAudience': instance.targetAudience,
  'mechanics': instance.mechanics,
  'narrative': instance.narrative,
  'uxDesign': instance.uxDesign,
  'accessibility': instance.accessibility,
};

_$GameMechanicImpl _$$GameMechanicImplFromJson(Map<String, dynamic> json) =>
    _$GameMechanicImpl(
      name: json['name'] as String,
      description: json['description'] as String,
      type: $enumDecode(_$MechanicTypeEnumMap, json['type']),
      complexity: (json['complexity'] as num).toDouble(),
      dependencies: (json['dependencies'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$GameMechanicImplToJson(_$GameMechanicImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'type': _$MechanicTypeEnumMap[instance.type]!,
      'complexity': instance.complexity,
      'dependencies': instance.dependencies,
    };

const _$MechanicTypeEnumMap = {
  MechanicType.core: 'core',
  MechanicType.secondary: 'secondary',
  MechanicType.optional: 'optional',
  MechanicType.accessibility: 'accessibility',
};

_$NarrativeStructureImpl _$$NarrativeStructureImplFromJson(
  Map<String, dynamic> json,
) => _$NarrativeStructureImpl(
  theme: json['theme'] as String,
  setting: json['setting'] as String,
  storyBeats: (json['storyBeats'] as List<dynamic>)
      .map((e) => StoryBeat.fromJson(e as Map<String, dynamic>))
      .toList(),
  characters: (json['characters'] as List<dynamic>)
      .map((e) => Character.fromJson(e as Map<String, dynamic>))
      .toList(),
  style: $enumDecode(_$NarrativeStyleEnumMap, json['style']),
);

Map<String, dynamic> _$$NarrativeStructureImplToJson(
  _$NarrativeStructureImpl instance,
) => <String, dynamic>{
  'theme': instance.theme,
  'setting': instance.setting,
  'storyBeats': instance.storyBeats,
  'characters': instance.characters,
  'style': _$NarrativeStyleEnumMap[instance.style]!,
};

const _$NarrativeStyleEnumMap = {
  NarrativeStyle.linear: 'linear',
  NarrativeStyle.branching: 'branching',
  NarrativeStyle.emergent: 'emergent',
  NarrativeStyle.environmental: 'environmental',
};

_$StoryBeatImpl _$$StoryBeatImplFromJson(Map<String, dynamic> json) =>
    _$StoryBeatImpl(
      id: json['id'] as String,
      description: json['description'] as String,
      order: (json['order'] as num).toInt(),
      type: $enumDecode(_$BeatTypeEnumMap, json['type']),
      triggers: (json['triggers'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$StoryBeatImplToJson(_$StoryBeatImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'order': instance.order,
      'type': _$BeatTypeEnumMap[instance.type]!,
      'triggers': instance.triggers,
    };

const _$BeatTypeEnumMap = {
  BeatType.introduction: 'introduction',
  BeatType.conflict: 'conflict',
  BeatType.climax: 'climax',
  BeatType.resolution: 'resolution',
  BeatType.optional: 'optional',
};

_$CharacterImpl _$$CharacterImplFromJson(Map<String, dynamic> json) =>
    _$CharacterImpl(
      name: json['name'] as String,
      description: json['description'] as String,
      role: $enumDecode(_$CharacterRoleEnumMap, json['role']),
      traits: (json['traits'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      arc: $enumDecode(_$CharacterArcEnumMap, json['arc']),
    );

Map<String, dynamic> _$$CharacterImplToJson(_$CharacterImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'role': _$CharacterRoleEnumMap[instance.role]!,
      'traits': instance.traits,
      'arc': _$CharacterArcEnumMap[instance.arc]!,
    };

const _$CharacterRoleEnumMap = {
  CharacterRole.protagonist: 'protagonist',
  CharacterRole.antagonist: 'antagonist',
  CharacterRole.supporting: 'supporting',
  CharacterRole.npc: 'npc',
};

const _$CharacterArcEnumMap = {
  CharacterArc.flat: 'flat',
  CharacterArc.positive: 'positive',
  CharacterArc.negative: 'negative',
  CharacterArc.complex: 'complex',
};

_$UXDesignImpl _$$UXDesignImplFromJson(Map<String, dynamic> json) =>
    _$UXDesignImpl(
      targetPlatform: json['targetPlatform'] as String,
      patterns: (json['patterns'] as List<dynamic>)
          .map((e) => $enumDecode(_$UIPatternEnumMap, e))
          .toList(),
      accessibility: $enumDecode(
        _$AccessibilityLevelEnumMap,
        json['accessibility'],
      ),
      userFlows: (json['userFlows'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$UXDesignImplToJson(_$UXDesignImpl instance) =>
    <String, dynamic>{
      'targetPlatform': instance.targetPlatform,
      'patterns': instance.patterns.map((e) => _$UIPatternEnumMap[e]!).toList(),
      'accessibility': _$AccessibilityLevelEnumMap[instance.accessibility]!,
      'userFlows': instance.userFlows,
    };

const _$UIPatternEnumMap = {
  UIPattern.card: 'card',
  UIPattern.list: 'list',
  UIPattern.grid: 'grid',
  UIPattern.modal: 'modal',
  UIPattern.navigation: 'navigation',
  UIPattern.form: 'form',
  UIPattern.dashboard: 'dashboard',
};

const _$AccessibilityLevelEnumMap = {
  AccessibilityLevel.basic: 'basic',
  AccessibilityLevel.intermediate: 'intermediate',
  AccessibilityLevel.advanced: 'advanced',
  AccessibilityLevel.expert: 'expert',
};

_$AccessibilityFeaturesImpl _$$AccessibilityFeaturesImplFromJson(
  Map<String, dynamic> json,
) => _$AccessibilityFeaturesImpl(
  screenReaderSupport: json['screenReaderSupport'] as bool,
  keyboardNavigation: json['keyboardNavigation'] as bool,
  colorBlindSupport: json['colorBlindSupport'] as bool,
  hearingImpairedSupport: json['hearingImpairedSupport'] as bool,
  motorImpairedSupport: json['motorImpairedSupport'] as bool,
  customFeatures: (json['customFeatures'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$$AccessibilityFeaturesImplToJson(
  _$AccessibilityFeaturesImpl instance,
) => <String, dynamic>{
  'screenReaderSupport': instance.screenReaderSupport,
  'keyboardNavigation': instance.keyboardNavigation,
  'colorBlindSupport': instance.colorBlindSupport,
  'hearingImpairedSupport': instance.hearingImpairedSupport,
  'motorImpairedSupport': instance.motorImpairedSupport,
  'customFeatures': instance.customFeatures,
};

_$WorkflowPipelineImpl _$$WorkflowPipelineImplFromJson(
  Map<String, dynamic> json,
) => _$WorkflowPipelineImpl(
  steps: (json['steps'] as List<dynamic>)
      .map((e) => WorkflowStep.fromJson(e as Map<String, dynamic>))
      .toList(),
  configuration: json['configuration'] as Map<String, dynamic>,
  status: $enumDecode(_$PipelineStatusEnumMap, json['status']),
);

Map<String, dynamic> _$$WorkflowPipelineImplToJson(
  _$WorkflowPipelineImpl instance,
) => <String, dynamic>{
  'steps': instance.steps,
  'configuration': instance.configuration,
  'status': _$PipelineStatusEnumMap[instance.status]!,
};

const _$PipelineStatusEnumMap = {
  PipelineStatus.idle: 'idle',
  PipelineStatus.running: 'running',
  PipelineStatus.completed: 'completed',
  PipelineStatus.error: 'error',
  PipelineStatus.paused: 'paused',
};

_$WorkflowStepImpl _$$WorkflowStepImplFromJson(Map<String, dynamic> json) =>
    _$WorkflowStepImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      agent: $enumDecode(_$AgentTypeEnumMap, json['agent']),
      status: $enumDecode(_$StepStatusEnumMap, json['status']),
      input: json['input'] as Map<String, dynamic>,
      output: json['output'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$$WorkflowStepImplToJson(_$WorkflowStepImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'agent': _$AgentTypeEnumMap[instance.agent]!,
      'status': _$StepStatusEnumMap[instance.status]!,
      'input': instance.input,
      'output': instance.output,
    };

const _$AgentTypeEnumMap = {
  AgentType.research: 'research',
  AgentType.creativeDirector: 'creativeDirector',
  AgentType.assetGeneration: 'assetGeneration',
  AgentType.orchestrator: 'orchestrator',
};

const _$StepStatusEnumMap = {
  StepStatus.pending: 'pending',
  StepStatus.running: 'running',
  StepStatus.completed: 'completed',
  StepStatus.failed: 'failed',
  StepStatus.skipped: 'skipped',
};

_$AgentCommunicationImpl _$$AgentCommunicationImplFromJson(
  Map<String, dynamic> json,
) => _$AgentCommunicationImpl(
  fromAgent: json['fromAgent'] as String,
  toAgent: json['toAgent'] as String,
  type: $enumDecode(_$CommunicationTypeEnumMap, json['type']),
  data: json['data'] as Map<String, dynamic>,
  timestamp: DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$$AgentCommunicationImplToJson(
  _$AgentCommunicationImpl instance,
) => <String, dynamic>{
  'fromAgent': instance.fromAgent,
  'toAgent': instance.toAgent,
  'type': _$CommunicationTypeEnumMap[instance.type]!,
  'data': instance.data,
  'timestamp': instance.timestamp.toIso8601String(),
};

const _$CommunicationTypeEnumMap = {
  CommunicationType.request: 'request',
  CommunicationType.response: 'response',
  CommunicationType.notification: 'notification',
  CommunicationType.error: 'error',
  CommunicationType.status: 'status',
};

_$AgentCapabilitiesImpl _$$AgentCapabilitiesImplFromJson(
  Map<String, dynamic> json,
) => _$AgentCapabilitiesImpl(
  supportedInputs: (json['supportedInputs'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  supportedOutputs: (json['supportedOutputs'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  configuration: json['configuration'] as Map<String, dynamic>,
  limitations: (json['limitations'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$$AgentCapabilitiesImplToJson(
  _$AgentCapabilitiesImpl instance,
) => <String, dynamic>{
  'supportedInputs': instance.supportedInputs,
  'supportedOutputs': instance.supportedOutputs,
  'configuration': instance.configuration,
  'limitations': instance.limitations,
};

_$ResearchMetricsImpl _$$ResearchMetricsImplFromJson(
  Map<String, dynamic> json,
) => _$ResearchMetricsImpl(
  totalSources: (json['totalSources'] as num).toInt(),
  activeSources: (json['activeSources'] as num).toInt(),
  queriesProcessed: (json['queriesProcessed'] as num).toInt(),
  averageResponseTime: (json['averageResponseTime'] as num).toDouble(),
  topSources: (json['topSources'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$$ResearchMetricsImplToJson(
  _$ResearchMetricsImpl instance,
) => <String, dynamic>{
  'totalSources': instance.totalSources,
  'activeSources': instance.activeSources,
  'queriesProcessed': instance.queriesProcessed,
  'averageResponseTime': instance.averageResponseTime,
  'topSources': instance.topSources,
};

_$CreativeMetricsImpl _$$CreativeMetricsImplFromJson(
  Map<String, dynamic> json,
) => _$CreativeMetricsImpl(
  designsCreated: (json['designsCreated'] as num).toInt(),
  mechanicsGenerated: (json['mechanicsGenerated'] as num).toInt(),
  narrativesWritten: (json['narrativesWritten'] as num).toInt(),
  creativityScore: (json['creativityScore'] as num).toDouble(),
  popularGenres: (json['popularGenres'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$$CreativeMetricsImplToJson(
  _$CreativeMetricsImpl instance,
) => <String, dynamic>{
  'designsCreated': instance.designsCreated,
  'mechanicsGenerated': instance.mechanicsGenerated,
  'narrativesWritten': instance.narrativesWritten,
  'creativityScore': instance.creativityScore,
  'popularGenres': instance.popularGenres,
};

_$AssetMetricsImpl _$$AssetMetricsImplFromJson(Map<String, dynamic> json) =>
    _$AssetMetricsImpl(
      assetsGenerated: (json['assetsGenerated'] as num).toInt(),
      assetsByType: (json['assetsByType'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry($enumDecode(_$AssetTypeEnumMap, k), (e as num).toInt()),
      ),
      averageGenerationTime: (json['averageGenerationTime'] as num).toDouble(),
      qualityScore: (json['qualityScore'] as num).toDouble(),
      topEngines: (json['topEngines'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$AssetMetricsImplToJson(_$AssetMetricsImpl instance) =>
    <String, dynamic>{
      'assetsGenerated': instance.assetsGenerated,
      'assetsByType': instance.assetsByType.map(
        (k, e) => MapEntry(_$AssetTypeEnumMap[k]!, e),
      ),
      'averageGenerationTime': instance.averageGenerationTime,
      'qualityScore': instance.qualityScore,
      'topEngines': instance.topEngines,
    };

_$OrchestratorMetricsImpl _$$OrchestratorMetricsImplFromJson(
  Map<String, dynamic> json,
) => _$OrchestratorMetricsImpl(
  workflowsCompleted: (json['workflowsCompleted'] as num).toInt(),
  totalSteps: (json['totalSteps'] as num).toInt(),
  successRate: (json['successRate'] as num).toDouble(),
  averageWorkflowTime: (json['averageWorkflowTime'] as num).toDouble(),
  commonErrors: (json['commonErrors'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$$OrchestratorMetricsImplToJson(
  _$OrchestratorMetricsImpl instance,
) => <String, dynamic>{
  'workflowsCompleted': instance.workflowsCompleted,
  'totalSteps': instance.totalSteps,
  'successRate': instance.successRate,
  'averageWorkflowTime': instance.averageWorkflowTime,
  'commonErrors': instance.commonErrors,
};

_$ResearchResultImpl _$$ResearchResultImplFromJson(Map<String, dynamic> json) =>
    _$ResearchResultImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      source: json['source'] as String,
      date: DateTime.parse(json['date'] as String),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      url: json['url'] as String,
      relevance: (json['relevance'] as num).toDouble(),
    );

Map<String, dynamic> _$$ResearchResultImplToJson(
  _$ResearchResultImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'source': instance.source,
  'date': instance.date.toIso8601String(),
  'tags': instance.tags,
  'url': instance.url,
  'relevance': instance.relevance,
};

_$GeneratedAssetImpl _$$GeneratedAssetImplFromJson(Map<String, dynamic> json) =>
    _$GeneratedAssetImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$AssetTypeEnumMap, json['type']),
      fileUrl: json['fileUrl'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      engine: json['engine'] as String,
      metadata: json['metadata'] as Map<String, dynamic>,
      quality: (json['quality'] as num).toDouble(),
    );

Map<String, dynamic> _$$GeneratedAssetImplToJson(
  _$GeneratedAssetImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'type': _$AssetTypeEnumMap[instance.type]!,
  'fileUrl': instance.fileUrl,
  'createdAt': instance.createdAt.toIso8601String(),
  'engine': instance.engine,
  'metadata': instance.metadata,
  'quality': instance.quality,
};

_$ProjectMasterAgentImpl _$$ProjectMasterAgentImplFromJson(
  Map<String, dynamic> json,
) => _$ProjectMasterAgentImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  type: $enumDecode(_$AgentTypeEnumMap, json['type']),
  status: $enumDecode(_$AgentStatusEnumMap, json['status']),
  capabilities: json['capabilities'] as Map<String, dynamic>,
  skills: (json['skills'] as List<dynamic>).map((e) => e as String).toList(),
  preferences: json['preferences'] as Map<String, dynamic>,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  prototypes: (json['prototypes'] as List<dynamic>)
      .map((e) => Prototype.fromJson(e as Map<String, dynamic>))
      .toList(),
  playtests: (json['playtests'] as List<dynamic>)
      .map((e) => PlaytestResult.fromJson(e as Map<String, dynamic>))
      .toList(),
  team: (json['team'] as List<dynamic>)
      .map((e) => TeamMember.fromJson(e as Map<String, dynamic>))
      .toList(),
  assets: (json['assets'] as List<dynamic>)
      .map((e) => GeneratedAsset.fromJson(e as Map<String, dynamic>))
      .toList(),
  decisions: (json['decisions'] as List<dynamic>)
      .map((e) => ProjectDecision.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$ProjectMasterAgentImplToJson(
  _$ProjectMasterAgentImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'type': _$AgentTypeEnumMap[instance.type]!,
  'status': _$AgentStatusEnumMap[instance.status]!,
  'capabilities': instance.capabilities,
  'skills': instance.skills,
  'preferences': instance.preferences,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'prototypes': instance.prototypes,
  'playtests': instance.playtests,
  'team': instance.team,
  'assets': instance.assets,
  'decisions': instance.decisions,
};

_$PrototypeImpl _$$PrototypeImplFromJson(Map<String, dynamic> json) =>
    _$PrototypeImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      version: json['version'] as String,
      features: (json['features'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      status: json['status'] as String,
      fileUrl: json['fileUrl'] as String,
    );

Map<String, dynamic> _$$PrototypeImplToJson(_$PrototypeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'createdAt': instance.createdAt.toIso8601String(),
      'version': instance.version,
      'features': instance.features,
      'status': instance.status,
      'fileUrl': instance.fileUrl,
    };

_$PlaytestResultImpl _$$PlaytestResultImplFromJson(Map<String, dynamic> json) =>
    _$PlaytestResultImpl(
      id: json['id'] as String,
      prototypeId: json['prototypeId'] as String,
      date: DateTime.parse(json['date'] as String),
      feedback: (json['feedback'] as List<dynamic>)
          .map((e) => FeedbackEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      summary: json['summary'] as String,
      issues: (json['issues'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      improvements: (json['improvements'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      title: json['title'] as String,
      description: json['description'] as String,
      rating: (json['rating'] as num).toDouble(),
      metrics: json['metrics'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$$PlaytestResultImplToJson(
  _$PlaytestResultImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'prototypeId': instance.prototypeId,
  'date': instance.date.toIso8601String(),
  'feedback': instance.feedback,
  'summary': instance.summary,
  'issues': instance.issues,
  'improvements': instance.improvements,
  'title': instance.title,
  'description': instance.description,
  'rating': instance.rating,
  'metrics': instance.metrics,
};

_$FeedbackEntryImpl _$$FeedbackEntryImplFromJson(Map<String, dynamic> json) =>
    _$FeedbackEntryImpl(
      id: json['id'] as String,
      author: json['author'] as String,
      content: json['content'] as String,
      date: DateTime.parse(json['date'] as String),
      type: $enumDecode(_$FeedbackTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$$FeedbackEntryImplToJson(_$FeedbackEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'author': instance.author,
      'content': instance.content,
      'date': instance.date.toIso8601String(),
      'type': _$FeedbackTypeEnumMap[instance.type]!,
    };

const _$FeedbackTypeEnumMap = {
  FeedbackType.bug: 'bug',
  FeedbackType.suggestion: 'suggestion',
  FeedbackType.praise: 'praise',
  FeedbackType.question: 'question',
  FeedbackType.other: 'other',
};

_$TeamMemberImpl _$$TeamMemberImplFromJson(Map<String, dynamic> json) =>
    _$TeamMemberImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      contact: json['contact'] as String,
      isActive: json['isActive'] as bool,
      expertise: json['expertise'] as String,
      skills: (json['skills'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      availability: (json['availability'] as num).toDouble(),
      preferences: json['preferences'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$$TeamMemberImplToJson(_$TeamMemberImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'role': instance.role,
      'contact': instance.contact,
      'isActive': instance.isActive,
      'expertise': instance.expertise,
      'skills': instance.skills,
      'availability': instance.availability,
      'preferences': instance.preferences,
    };

_$ProjectDecisionImpl _$$ProjectDecisionImplFromJson(
  Map<String, dynamic> json,
) => _$ProjectDecisionImpl(
  id: json['id'] as String,
  description: json['description'] as String,
  date: DateTime.parse(json['date'] as String),
  author: json['author'] as String,
  reasons: (json['reasons'] as List<dynamic>).map((e) => e as String).toList(),
  consequences: (json['consequences'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$$ProjectDecisionImplToJson(
  _$ProjectDecisionImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'description': instance.description,
  'date': instance.date.toIso8601String(),
  'author': instance.author,
  'reasons': instance.reasons,
  'consequences': instance.consequences,
};

_$LessonLearnedImpl _$$LessonLearnedImplFromJson(Map<String, dynamic> json) =>
    _$LessonLearnedImpl(
      id: json['id'] as String,
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
      author: json['author'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$LessonLearnedImplToJson(_$LessonLearnedImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'date': instance.date.toIso8601String(),
      'author': instance.author,
      'tags': instance.tags,
    };

_$WorkflowConfigurationImpl _$$WorkflowConfigurationImplFromJson(
  Map<String, dynamic> json,
) => _$WorkflowConfigurationImpl(
  enabledResearchSources: (json['enabledResearchSources'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  ethicalConcerns: (json['ethicalConcerns'] as List<dynamic>)
      .map((e) => $enumDecode(_$EthicalConcernEnumMap, e))
      .toList(),
  maxResearchResults: (json['maxResearchResults'] as num).toInt(),
  assetGenerationSettings:
      json['assetGenerationSettings'] as Map<String, dynamic>,
  engineConfig: json['engineConfig'] as Map<String, dynamic>,
  codeGenerationOptions: json['codeGenerationOptions'] as Map<String, dynamic>,
  buildConfig: json['buildConfig'] as Map<String, dynamic>,
);

Map<String, dynamic> _$$WorkflowConfigurationImplToJson(
  _$WorkflowConfigurationImpl instance,
) => <String, dynamic>{
  'enabledResearchSources': instance.enabledResearchSources,
  'ethicalConcerns': instance.ethicalConcerns
      .map((e) => _$EthicalConcernEnumMap[e]!)
      .toList(),
  'maxResearchResults': instance.maxResearchResults,
  'assetGenerationSettings': instance.assetGenerationSettings,
  'engineConfig': instance.engineConfig,
  'codeGenerationOptions': instance.codeGenerationOptions,
  'buildConfig': instance.buildConfig,
};

_$WorkflowStatusImpl _$$WorkflowStatusImplFromJson(
  Map<String, dynamic> json,
) => _$WorkflowStatusImpl(
  workflowId: json['workflowId'] as String,
  type: $enumDecode(_$WorkflowTypeEnumMap, json['type']),
  status: json['status'] as String,
  progress: (json['progress'] as num).toDouble(),
  startTime: DateTime.parse(json['startTime'] as String),
  endTime: json['endTime'] == null
      ? null
      : DateTime.parse(json['endTime'] as String),
  logs: (json['logs'] as List<dynamic>).map((e) => e as String).toList(),
  warnings: (json['warnings'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  errors: (json['errors'] as List<dynamic>).map((e) => e as String).toList(),
  currentStep: json['currentStep'] as String?,
  estimatedTimeRemaining: json['estimatedTimeRemaining'] == null
      ? null
      : Duration(microseconds: (json['estimatedTimeRemaining'] as num).toInt()),
);

Map<String, dynamic> _$$WorkflowStatusImplToJson(
  _$WorkflowStatusImpl instance,
) => <String, dynamic>{
  'workflowId': instance.workflowId,
  'type': _$WorkflowTypeEnumMap[instance.type]!,
  'status': instance.status,
  'progress': instance.progress,
  'startTime': instance.startTime.toIso8601String(),
  'endTime': instance.endTime?.toIso8601String(),
  'logs': instance.logs,
  'warnings': instance.warnings,
  'errors': instance.errors,
  'currentStep': instance.currentStep,
  'estimatedTimeRemaining': instance.estimatedTimeRemaining?.inMicroseconds,
};

const _$WorkflowTypeEnumMap = {
  WorkflowType.research: 'research',
  WorkflowType.design: 'design',
  WorkflowType.assetGeneration: 'assetGeneration',
  WorkflowType.engineIntegration: 'engineIntegration',
  WorkflowType.full: 'full',
  WorkflowType.custom: 'custom',
};

_$EngineBuildResultImpl _$$EngineBuildResultImplFromJson(
  Map<String, dynamic> json,
) => _$EngineBuildResultImpl(
  success: json['success'] as bool,
  engine: json['engine'] as String,
  platform: json['platform'] as String,
  buildUrl: json['buildUrl'] as String,
  buildTime: DateTime.parse(json['buildTime'] as String),
  warnings: (json['warnings'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  errors: (json['errors'] as List<dynamic>).map((e) => e as String).toList(),
  metadata: json['metadata'] as Map<String, dynamic>,
);

Map<String, dynamic> _$$EngineBuildResultImplToJson(
  _$EngineBuildResultImpl instance,
) => <String, dynamic>{
  'success': instance.success,
  'engine': instance.engine,
  'platform': instance.platform,
  'buildUrl': instance.buildUrl,
  'buildTime': instance.buildTime.toIso8601String(),
  'warnings': instance.warnings,
  'errors': instance.errors,
  'metadata': instance.metadata,
};

_$OrchestrationResultImpl _$$OrchestrationResultImplFromJson(
  Map<String, dynamic> json,
) => _$OrchestrationResultImpl(
  workflowId: json['workflowId'] as String,
  success: json['success'] as bool,
  researchResult: json['researchResult'] == null
      ? null
      : ResearchResult.fromJson(json['researchResult'] as Map<String, dynamic>),
  designResult: json['designResult'] == null
      ? null
      : GameDesignDocument.fromJson(
          json['designResult'] as Map<String, dynamic>,
        ),
  assetResult: (json['assetResult'] as List<dynamic>?)
      ?.map((e) => GeneratedAsset.fromJson(e as Map<String, dynamic>))
      .toList(),
  engineResult: json['engineResult'] == null
      ? null
      : EngineBuildResult.fromJson(
          json['engineResult'] as Map<String, dynamic>,
        ),
  logs: (json['logs'] as List<dynamic>).map((e) => e as String).toList(),
  warnings: (json['warnings'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  totalDuration: Duration(microseconds: (json['totalDuration'] as num).toInt()),
);

Map<String, dynamic> _$$OrchestrationResultImplToJson(
  _$OrchestrationResultImpl instance,
) => <String, dynamic>{
  'workflowId': instance.workflowId,
  'success': instance.success,
  'researchResult': instance.researchResult,
  'designResult': instance.designResult,
  'assetResult': instance.assetResult,
  'engineResult': instance.engineResult,
  'logs': instance.logs,
  'warnings': instance.warnings,
  'totalDuration': instance.totalDuration.inMicroseconds,
};
