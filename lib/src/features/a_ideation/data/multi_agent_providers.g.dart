// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multi_agent_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$agentOrchestratorServiceHash() =>
    r'6964a9e7ff704f8a1ced386ac30f43ef5afb398a';

/// See also [agentOrchestratorService].
@ProviderFor(agentOrchestratorService)
final agentOrchestratorServiceProvider =
    AutoDisposeProvider<orchestrator.AgentOrchestratorService>.internal(
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
    AutoDisposeProviderRef<orchestrator.AgentOrchestratorService>;
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
String _$currentProjectHash() => r'5d220dfd7ab2a064fb4138e0396bd6db171c4183';

/// See also [CurrentProject].
@ProviderFor(CurrentProject)
final currentProjectProvider =
    AutoDisposeAsyncNotifierProvider<
      CurrentProject,
      domain.ProjectMasterAgent?
    >.internal(
      CurrentProject.new,
      name: r'currentProjectProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$currentProjectHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CurrentProject = AutoDisposeAsyncNotifier<domain.ProjectMasterAgent?>;
String _$activeWorkflowsHash() => r'5c0a1b84de8f406d91c4c00e97338bb00e43e034';

/// See also [ActiveWorkflows].
@ProviderFor(ActiveWorkflows)
final activeWorkflowsProvider =
    AutoDisposeNotifierProvider<
      ActiveWorkflows,
      List<domain.WorkflowStatus>
    >.internal(
      ActiveWorkflows.new,
      name: r'activeWorkflowsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$activeWorkflowsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ActiveWorkflows = AutoDisposeNotifier<List<domain.WorkflowStatus>>;
String _$agentStatusesHash() => r'3da06f6ec29bbba1e71c41907c33d8c4cc08dd37';

/// See also [AgentStatuses].
@ProviderFor(AgentStatuses)
final agentStatusesProvider =
    AutoDisposeNotifierProvider<
      AgentStatuses,
      Map<String, domain.AgentStatus>
    >.internal(
      AgentStatuses.new,
      name: r'agentStatusesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$agentStatusesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AgentStatuses = AutoDisposeNotifier<Map<String, domain.AgentStatus>>;
String _$aIInsightsHash() => r'fa0d4d5b189cb4c8158ec823e442e7e8dfdd1c75';

/// See also [AIInsights].
@ProviderFor(AIInsights)
final aIInsightsProvider =
    AutoDisposeNotifierProvider<AIInsights, List<domain.AIInsight>>.internal(
      AIInsights.new,
      name: r'aIInsightsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$aIInsightsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AIInsights = AutoDisposeNotifier<List<domain.AIInsight>>;
String _$automatedRetrospectivesHash() =>
    r'42899c6b3c1c69461b877eb9a3a3a0d77c581489';

/// See also [AutomatedRetrospectives].
@ProviderFor(AutomatedRetrospectives)
final automatedRetrospectivesProvider =
    AutoDisposeNotifierProvider<
      AutomatedRetrospectives,
      List<domain.RetrospectiveSession>
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
    AutoDisposeNotifier<List<domain.RetrospectiveSession>>;
String _$adaptiveWorkflowsHash() => r'803346cf0c9fb40e1b6046314d4db6741842e039';

/// See also [AdaptiveWorkflows].
@ProviderFor(AdaptiveWorkflows)
final adaptiveWorkflowsProvider =
    AutoDisposeNotifierProvider<
      AdaptiveWorkflows,
      domain.WorkflowConfiguration
    >.internal(
      AdaptiveWorkflows.new,
      name: r'adaptiveWorkflowsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$adaptiveWorkflowsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AdaptiveWorkflows = AutoDisposeNotifier<domain.WorkflowConfiguration>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
