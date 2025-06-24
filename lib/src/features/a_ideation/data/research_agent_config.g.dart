// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'research_agent_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SourceConfigImpl _$$SourceConfigImplFromJson(Map<String, dynamic> json) =>
    _$SourceConfigImpl(
      name: json['name'] as String,
      category: $enumDecode(_$SourceCategoryEnumMap, json['category']),
      ethicalConcerns: (json['ethicalConcerns'] as List<dynamic>)
          .map((e) => $enumDecode(_$EthicalConcernEnumMap, e))
          .toList(),
      isEnabled: json['isEnabled'] as bool,
      priority: (json['priority'] as num).toInt(),
      description: json['description'] as String,
    );

Map<String, dynamic> _$$SourceConfigImplToJson(_$SourceConfigImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'category': _$SourceCategoryEnumMap[instance.category]!,
      'ethicalConcerns': instance.ethicalConcerns
          .map((e) => _$EthicalConcernEnumMap[e]!)
          .toList(),
      'isEnabled': instance.isEnabled,
      'priority': instance.priority,
      'description': instance.description,
    };

const _$SourceCategoryEnumMap = {
  SourceCategory.scientific: 'scientific',
  SourceCategory.practical: 'practical',
  SourceCategory.ai: 'ai',
  SourceCategory.community: 'community',
  SourceCategory.industry: 'industry',
};

const _$EthicalConcernEnumMap = {
  EthicalConcern.addictionResearch: 'addictionResearch',
  EthicalConcern.marketManipulation: 'marketManipulation',
  EthicalConcern.communityManipulation: 'communityManipulation',
  EthicalConcern.echoChambers: 'echoChambers',
  EthicalConcern.algorithmManipulation: 'algorithmManipulation',
  EthicalConcern.aiBias: 'aiBias',
  EthicalConcern.modelMisuse: 'modelMisuse',
  EthicalConcern.commercialization: 'commercialization',
  EthicalConcern.dataPrivacy: 'dataPrivacy',
  EthicalConcern.userExploitation: 'userExploitation',
  EthicalConcern.contentModeration: 'contentModeration',
  EthicalConcern.accessibility: 'accessibility',
  EthicalConcern.diversity: 'diversity',
  EthicalConcern.sustainability: 'sustainability',
};
