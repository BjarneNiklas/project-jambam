import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'research_agent_config.freezed.dart';
part 'research_agent_config.g.dart';

/// Konfigurierbare Research Agent Einstellungen
/// Ermöglicht ethische Kontrolle und User Preferences
class ResearchAgentConfig {
  // Singleton Pattern
  static final ResearchAgentConfig _instance = ResearchAgentConfig._internal();
  factory ResearchAgentConfig() => _instance;
  ResearchAgentConfig._internal();

  // API Konfiguration
  final Map<ResearchSourceType, SourceConfig> _sourceConfigs = {
    // Wissenschaftliche APIs (12)
    ResearchSourceType.arxiv: SourceConfig(
      name: 'ArXiv',
      category: SourceCategory.scientific,
      ethicalConcerns: [],
      isEnabled: true,
      priority: 1,
      description: 'Preprints für Game AI, Computer Graphics, HCI',
    ),
    ResearchSourceType.pubmed: SourceConfig(
      name: 'PubMed',
      category: SourceCategory.scientific,
      ethicalConcerns: [EthicalConcern.addictionResearch],
      isEnabled: true,
      priority: 2,
      description: 'Medizinische Forschung für Gaming Psychology',
    ),
    ResearchSourceType.doj: SourceConfig(
      name: 'DOAJ',
      category: SourceCategory.scientific,
      ethicalConcerns: [],
      isEnabled: true,
      priority: 3,
      description: 'Open Access Journals für Game Studies',
    ),
    ResearchSourceType.crossref: SourceConfig(
      name: 'Crossref',
      category: SourceCategory.scientific,
      ethicalConcerns: [],
      isEnabled: true,
      priority: 1,
      description: 'DOI-Metadaten für alle wissenschaftlichen Papers',
    ),
    ResearchSourceType.semanticScholar: SourceConfig(
      name: 'Semantic Scholar',
      category: SourceCategory.scientific,
      ethicalConcerns: [],
      isEnabled: true,
      priority: 1,
      description: 'AI-powered wissenschaftliche Suche',
    ),
    ResearchSourceType.ieee: SourceConfig(
      name: 'IEEE',
      category: SourceCategory.scientific,
      ethicalConcerns: [],
      isEnabled: true,
      priority: 2,
      description: 'Game Engineering, VR/AR, Computer Graphics',
    ),
    ResearchSourceType.acm: SourceConfig(
      name: 'ACM',
      category: SourceCategory.scientific,
      ethicalConcerns: [],
      isEnabled: true,
      priority: 2,
      description: 'CHI, SIGGRAPH, Game Design Patterns',
    ),
    ResearchSourceType.openAlex: SourceConfig(
      name: 'OpenAlex',
      category: SourceCategory.scientific,
      ethicalConcerns: [],
      isEnabled: true,
      priority: 1,
      description: 'Umfassender wissenschaftlicher Katalog',
    ),
    ResearchSourceType.dblp: SourceConfig(
      name: 'DBLP',
      category: SourceCategory.scientific,
      ethicalConcerns: [],
      isEnabled: true,
      priority: 3,
      description: 'Computer Science Bibliography',
    ),
    ResearchSourceType.core: SourceConfig(
      name: 'CORE',
      category: SourceCategory.scientific,
      ethicalConcerns: [],
      isEnabled: true,
      priority: 3,
      description: 'Open Access Aggregator',
    ),
    ResearchSourceType.springer: SourceConfig(
      name: 'Springer',
      category: SourceCategory.scientific,
      ethicalConcerns: [EthicalConcern.addictionResearch],
      isEnabled: true,
      priority: 3,
      description: 'Interdisziplinäre Forschung',
    ),
    ResearchSourceType.elsevier: SourceConfig(
      name: 'Elsevier',
      category: SourceCategory.scientific,
      ethicalConcerns: [EthicalConcern.addictionResearch],
      isEnabled: true,
      priority: 3,
      description: 'Computer Science, Psychology, Media Studies',
    ),

    // Praktische APIs (6)
    ResearchSourceType.steam: SourceConfig(
      name: 'Steam',
      category: SourceCategory.practical,
      ethicalConcerns: [EthicalConcern.addictionResearch, EthicalConcern.marketManipulation],
      isEnabled: true,
      priority: 1,
      description: 'Game Platform Data für Market Trends',
    ),
    ResearchSourceType.twitch: SourceConfig(
      name: 'Twitch',
      category: SourceCategory.practical,
      ethicalConcerns: [EthicalConcern.addictionResearch, EthicalConcern.communityManipulation],
      isEnabled: true,
      priority: 1,
      description: 'Streaming Platform Data für Popularität',
    ),
    ResearchSourceType.reddit: SourceConfig(
      name: 'Reddit',
      category: SourceCategory.practical,
      ethicalConcerns: [EthicalConcern.communityManipulation, EthicalConcern.echoChambers],
      isEnabled: true,
      priority: 2,
      description: 'Community Discussions für Developer Insights',
    ),
    ResearchSourceType.youtube: SourceConfig(
      name: 'YouTube',
      category: SourceCategory.practical,
      ethicalConcerns: [EthicalConcern.addictionResearch, EthicalConcern.algorithmManipulation],
      isEnabled: true,
      priority: 2,
      description: 'Video Content für Tutorials und Reviews',
    ),
    ResearchSourceType.itchio: SourceConfig(
      name: 'Itch.io',
      category: SourceCategory.practical,
      ethicalConcerns: [],
      isEnabled: true,
      priority: 2,
      description: 'Indie Game Platform für experimentelle Designs',
    ),
    ResearchSourceType.gameDevBlogs: SourceConfig(
      name: 'Game Dev Blogs',
      category: SourceCategory.practical,
      ethicalConcerns: [],
      isEnabled: true,
      priority: 3,
      description: 'Industry Articles für Post-mortems und Tutorials',
    ),
  };

  // Getter für Source Configs
  Map<ResearchSourceType, SourceConfig> get sourceConfigs => Map.unmodifiable(_sourceConfigs);

  // Source Config für spezifische Quelle
  SourceConfig? getSourceConfig(ResearchSourceType source) {
    return _sourceConfigs[source];
  }

  // Alle aktivierten Quellen
  List<ResearchSourceType> get enabledSources {
    return _sourceConfigs.entries
        .where((entry) => entry.value.isEnabled)
        .map((entry) => entry.key)
        .toList();
  }

  // Quellen nach Kategorie
  List<ResearchSourceType> getSourcesByCategory(SourceCategory category) {
    return _sourceConfigs.entries
        .where((entry) => entry.value.category == category && entry.value.isEnabled)
        .map((entry) => entry.key)
        .toList();
  }

  // Quellen nach Priorität sortiert
  List<ResearchSourceType> getSourcesByPriority() {
    final sortedEntries = _sourceConfigs.entries.toList()
      ..sort((a, b) => a.value.priority.compareTo(b.value.priority));
    return sortedEntries
        .where((entry) => entry.value.isEnabled)
        .map((entry) => entry.key)
        .toList();
  }

  // Ethische Bedenken für alle aktivierten Quellen
  Set<EthicalConcern> getActiveEthicalConcerns() {
    final concerns = <EthicalConcern>{};
    for (final entry in _sourceConfigs.entries) {
      if (entry.value.isEnabled) {
        concerns.addAll(entry.value.ethicalConcerns);
      }
    }
    return concerns;
  }

  // Quellen mit spezifischen ethischen Bedenken
  List<ResearchSourceType> getSourcesWithConcern(EthicalConcern concern) {
    return _sourceConfigs.entries
        .where((entry) => entry.value.isEnabled && entry.value.ethicalConcerns.contains(concern))
        .map((entry) => entry.key)
        .toList();
  }

  // Konfiguration aktualisieren
  void updateSourceConfig(ResearchSourceType source, SourceConfig config) {
    _sourceConfigs[source] = config;
  }

  // Quelle aktivieren/deaktivieren
  void setSourceEnabled(ResearchSourceType source, bool enabled) {
    final config = _sourceConfigs[source];
    if (config != null) {
      _sourceConfigs[source] = config.copyWith(isEnabled: enabled);
    }
  }

  // Priorität einer Quelle ändern
  void setSourcePriority(ResearchSourceType source, int priority) {
    final config = _sourceConfigs[source];
    if (config != null) {
      _sourceConfigs[source] = config.copyWith(priority: priority);
    }
  }

  // Ethische Bedenken für Quelle hinzufügen/entfernen
  void updateEthicalConcerns(ResearchSourceType source, List<EthicalConcern> concerns) {
    final config = _sourceConfigs[source];
    if (config != null) {
      _sourceConfigs[source] = config.copyWith(ethicalConcerns: concerns);
    }
  }

  // Konfiguration zurücksetzen
  void resetToDefaults() {
    // Hier würde die Standard-Konfiguration wiederhergestellt werden
    // Für jetzt lassen wir die aktuelle Konfiguration
  }

  // Konfiguration exportieren
  Map<String, dynamic> exportConfig() {
    return {
      'sources': _sourceConfigs.map((key, value) => MapEntry(key.name, value.toJson())),
      'enabledSources': enabledSources.map((s) => s.name).toList(),
      'ethicalConcerns': getActiveEthicalConcerns().map((c) => c.name).toList(),
    };
  }

  // Konfiguration importieren
  void importConfig(Map<String, dynamic> config) {
    // Hier würde die Konfiguration aus dem JSON wiederhergestellt werden
    // Für jetzt lassen wir die aktuelle Konfiguration
  }
}

/// Konfiguration für eine einzelne Forschungsquelle
@freezed
class SourceConfig with _$SourceConfig {
  const factory SourceConfig({
    required String name,
    required SourceCategory category,
    required List<EthicalConcern> ethicalConcerns,
    required bool isEnabled,
    required int priority,
    required String description,
  }) = _SourceConfig;

  factory SourceConfig.fromJson(Map<String, dynamic> json) => _$SourceConfigFromJson(json);
}

/// Kategorien für Forschungsquellen
enum SourceCategory {
  scientific,
  practical,
  ai,
  community,
  industry,
}

/// Ethische Bedenken für Forschungsquellen
enum EthicalConcern {
  addictionResearch,
  marketManipulation,
  communityManipulation,
  echoChambers,
  algorithmManipulation,
  aiBias,
  modelMisuse,
  commercialization,
  dataPrivacy,
  userExploitation,
  contentModeration,
  accessibility,
  diversity,
  sustainability,
}

/// Erweiterte Research Source Types für Konfiguration
enum ResearchSourceType {
  arxiv,
  pubmed,
  doj,
  crossref,
  semanticScholar,
  ieee,
  acm,
  openAlex,
  dblp,
  core,
  springer,
  elsevier,
  steam,
  twitch,
  reddit,
  youtube,
  itchio,
  gameDevBlogs,
} 