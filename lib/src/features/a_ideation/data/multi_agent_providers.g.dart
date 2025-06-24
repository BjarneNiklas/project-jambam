// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multi_agent_providers.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AIInsightImpl _$$AIInsightImplFromJson(Map<String, dynamic> json) =>
    _$AIInsightImpl(
      id: json['id'] as String,
      type: $enumDecode(_$AIInsightTypeEnumMap, json['type']),
      title: json['title'] as String,
      description: json['description'] as String,
      priority: $enumDecode(_$InsightPriorityEnumMap, json['priority']),
      suggestedActions: (json['suggestedActions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      resolved: json['resolved'] as bool? ?? false,
    );

Map<String, dynamic> _$$AIInsightImplToJson(_$AIInsightImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$AIInsightTypeEnumMap[instance.type]!,
      'title': instance.title,
      'description': instance.description,
      'priority': _$InsightPriorityEnumMap[instance.priority]!,
      'suggestedActions': instance.suggestedActions,
      'resolved': instance.resolved,
    };

const _$AIInsightTypeEnumMap = {
  AIInsightType.info: 'info',
  AIInsightType.suggestion: 'suggestion',
  AIInsightType.warning: 'warning',
  AIInsightType.error: 'error',
};

const _$InsightPriorityEnumMap = {
  InsightPriority.low: 'low',
  InsightPriority.medium: 'medium',
  InsightPriority.high: 'high',
  InsightPriority.critical: 'critical',
};

_$RetrospectiveSessionImpl _$$RetrospectiveSessionImplFromJson(
  Map<String, dynamic> json,
) => _$RetrospectiveSessionImpl(
  id: json['id'] as String,
  projectId: json['projectId'] as String,
  date: DateTime.parse(json['date'] as String),
  insights: (json['insights'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  recommendations: (json['recommendations'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  actionItems: (json['actionItems'] as List<dynamic>)
      .map((e) => ActionItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$RetrospectiveSessionImplToJson(
  _$RetrospectiveSessionImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'projectId': instance.projectId,
  'date': instance.date.toIso8601String(),
  'insights': instance.insights,
  'recommendations': instance.recommendations,
  'actionItems': instance.actionItems,
};

_$ActionItemImpl _$$ActionItemImplFromJson(Map<String, dynamic> json) =>
    _$ActionItemImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      assignee: json['assignee'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      priority: $enumDecode(_$ActionPriorityEnumMap, json['priority']),
      completed: json['completed'] as bool? ?? false,
    );

Map<String, dynamic> _$$ActionItemImplToJson(_$ActionItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'assignee': instance.assignee,
      'dueDate': instance.dueDate.toIso8601String(),
      'priority': _$ActionPriorityEnumMap[instance.priority]!,
      'completed': instance.completed,
    };

const _$ActionPriorityEnumMap = {
  ActionPriority.low: 'low',
  ActionPriority.medium: 'medium',
  ActionPriority.high: 'high',
  ActionPriority.urgent: 'urgent',
};

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$agentOrchestratorServiceHash() =>
    r'e6242bcb25a47e94ef50c74d38ae48522207ae78';

/// See also [agentOrchestratorService].
@ProviderFor(agentOrchestratorService)
final agentOrchestratorServiceProvider =
    AutoDisposeProvider<AgentOrchestratorService>.internal(
      agentOrchestratorService,
      name: r'agentOrchestratorServiceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$agentOrchestratorServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AgentOrchestratorServiceRef =
    AutoDisposeProviderRef<AgentOrchestratorService>;
String _$projectMasterAgentServiceHash() =>
    r'846d9edbf300a619f2345ff7162842c951e01483';

/// See also [projectMasterAgentService].
@ProviderFor(projectMasterAgentService)
final projectMasterAgentServiceProvider =
    AutoDisposeProvider<ProjectMasterAgentService>.internal(
      projectMasterAgentService,
      name: r'projectMasterAgentServiceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$projectMasterAgentServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProjectMasterAgentServiceRef =
    AutoDisposeProviderRef<ProjectMasterAgentService>;
String _$researchAgentServiceHash() =>
    r'ce516e7e7414e1ac60ae3a0fd595d8c2eff54138';

/// See also [researchAgentService].
@ProviderFor(researchAgentService)
final researchAgentServiceProvider =
    AutoDisposeProvider<ResearchAgentService>.internal(
      researchAgentService,
      name: r'researchAgentServiceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$researchAgentServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ResearchAgentServiceRef = AutoDisposeProviderRef<ResearchAgentService>;
String _$creativeDirectorAgentServiceHash() =>
    r'13e7163c82a1093ecbe558bcbb9df820f181412d';

/// See also [creativeDirectorAgentService].
@ProviderFor(creativeDirectorAgentService)
final creativeDirectorAgentServiceProvider =
    AutoDisposeProvider<CreativeDirectorAgentService>.internal(
      creativeDirectorAgentService,
      name: r'creativeDirectorAgentServiceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$creativeDirectorAgentServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CreativeDirectorAgentServiceRef =
    AutoDisposeProviderRef<CreativeDirectorAgentService>;
String _$assetGenerationAgentServiceHash() =>
    r'adc85385ee166067059e8562f4131f55e0671584';

/// See also [assetGenerationAgentService].
@ProviderFor(assetGenerationAgentService)
final assetGenerationAgentServiceProvider =
    AutoDisposeProvider<AssetGenerationAgentService>.internal(
      assetGenerationAgentService,
      name: r'assetGenerationAgentServiceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$assetGenerationAgentServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AssetGenerationAgentServiceRef =
    AutoDisposeProviderRef<AssetGenerationAgentService>;
String _$gameEngineAgentServiceHash() =>
    r'c17ccbaccad22306fe46e7143f5bcf80d66041e7';

/// See also [gameEngineAgentService].
@ProviderFor(gameEngineAgentService)
final gameEngineAgentServiceProvider =
    AutoDisposeProvider<GameEngineAgentService>.internal(
      gameEngineAgentService,
      name: r'gameEngineAgentServiceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$gameEngineAgentServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GameEngineAgentServiceRef =
    AutoDisposeProviderRef<GameEngineAgentService>;
String _$currentProjectHash() => r'a9e74d26b36912749814ac691d0656b4482bd453';

/// See also [CurrentProject].
@ProviderFor(CurrentProject)
final currentProjectProvider =
    AutoDisposeAsyncNotifierProvider<
      CurrentProject,
      ProjectMasterAgent?
    >.internal(
      CurrentProject.new,
      name: r'currentProjectProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$currentProjectHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CurrentProject = AutoDisposeAsyncNotifier<ProjectMasterAgent?>;
String _$activeWorkflowsHash() => r'0643ffbbdb6b127717da3f4df07dc84a8dc03095';

/// See also [ActiveWorkflows].
@ProviderFor(ActiveWorkflows)
final activeWorkflowsProvider =
    AutoDisposeNotifierProvider<ActiveWorkflows, List<WorkflowStatus>>.internal(
      ActiveWorkflows.new,
      name: r'activeWorkflowsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$activeWorkflowsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ActiveWorkflows = AutoDisposeNotifier<List<WorkflowStatus>>;
String _$agentStatusesHash() => r'bea1f1b133e268d56afb483dc8e05cac242417f1';

/// See also [AgentStatuses].
@ProviderFor(AgentStatuses)
final agentStatusesProvider =
    AutoDisposeNotifierProvider<
      AgentStatuses,
      Map<String, AgentStatus>
    >.internal(
      AgentStatuses.new,
      name: r'agentStatusesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$agentStatusesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AgentStatuses = AutoDisposeNotifier<Map<String, AgentStatus>>;
String _$aIInsightsHash() => r'727b79a2e3efd3a7d00128f7511a154c4ccad96c';

/// See also [AIInsights].
@ProviderFor(AIInsights)
final aIInsightsProvider =
    AutoDisposeNotifierProvider<AIInsights, List<AIInsight>>.internal(
      AIInsights.new,
      name: r'aIInsightsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$aIInsightsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AIInsights = AutoDisposeNotifier<List<AIInsight>>;
String _$automatedRetrospectivesHash() =>
    r'1b6023f01b8eae38323975def1c156bfeb02b9cc';

/// See also [AutomatedRetrospectives].
@ProviderFor(AutomatedRetrospectives)
final automatedRetrospectivesProvider =
    AutoDisposeNotifierProvider<
      AutomatedRetrospectives,
      List<RetrospectiveSession>
    >.internal(
      AutomatedRetrospectives.new,
      name: r'automatedRetrospectivesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$automatedRetrospectivesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AutomatedRetrospectives =
    AutoDisposeNotifier<List<RetrospectiveSession>>;
String _$adaptiveWorkflowsHash() => r'b342a41076229c35c952168e490ee109b9979762';

/// See also [AdaptiveWorkflows].
@ProviderFor(AdaptiveWorkflows)
final adaptiveWorkflowsProvider =
    AutoDisposeNotifierProvider<
      AdaptiveWorkflows,
      WorkflowConfiguration
    >.internal(
      AdaptiveWorkflows.new,
      name: r'adaptiveWorkflowsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$adaptiveWorkflowsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AdaptiveWorkflows = AutoDisposeNotifier<WorkflowConfiguration>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
