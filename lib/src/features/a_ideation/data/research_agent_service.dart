import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domain/multi_agent_system.dart';

/// Research Agent Service
/// Verantwortlich für wissenschaftliche Recherche, Quellenmanagement und Ethik
class ResearchAgentService {
  static const String _baseUrl = 'http://localhost:8000';

  /// Führt eine wissenschaftliche Recherche durch
  Future<ResearchResult> searchResearch({
    required String query,
    required List<String> enabledSources,
    List<EthicalConcern> ethicalConcerns = const [],
    int maxResults = 20,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/research-agent/search'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode({
          'query': query,
          'sources': enabledSources,
          'ethical_concerns': ethicalConcerns.map((e) => e.toString().split('.').last).toList(),
          'max_results': maxResults,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _parseResearchResult(data);
      } else {
        throw Exception('Failed to search research: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback: Mock
      return _createMockResearchResult(query, enabledSources);
    }
  }

  /// Liefert Details zu einer bestimmten Quelle
  Future<ResearchSourceDetail> getSourceDetail(String sourceId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/research-agent/source/$sourceId'),
        headers: {'Accept': 'application/json'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _parseSourceDetail(data);
      } else {
        throw Exception('Failed to get source detail: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback: Mock
      return _createMockSourceDetail(sourceId);
    }
  }

  /// Exportiert Suchergebnisse als BibTeX, CSV, JSON etc.
  Future<String> exportResults({
    required List<ResearchPaper> papers,
    required String format, // 'bibtex', 'csv', 'json'
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/research-agent/export'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode({
          'papers': papers.map((p) => p.toJson()).toList(),
          'format': format,
        }),
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to export results: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback: Mock
      return _createMockExport(papers, format);
    }
  }

  // --- Mock & Parser Implementierungen ---

  ResearchResult _createMockResearchResult(String query, List<String> sources) {
    return ResearchResult(
      query: query,
      totalResults: 2,
      papers: [
        ResearchPaper(
          id: 'arxiv:1234.5678',
          title: 'Procedural Generation in Game Jams',
          authors: ['A. Researcher', 'B. Dev'],
          source: 'arxiv',
          year: 2023,
          url: 'https://arxiv.org/abs/1234.5678',
          abstractText: 'A study on procedural content generation for rapid prototyping.',
          score: 0.92,
          tags: ['procedural', 'game jam', 'ai'],
        ),
        ResearchPaper(
          id: 'pubmed:987654',
          title: 'Gamification and Community Engagement',
          authors: ['C. Scientist'],
          source: 'pubmed',
          year: 2022,
          url: 'https://pubmed.ncbi.nlm.nih.gov/987654/',
          abstractText: 'Effects of gamification on online communities.',
          score: 0.88,
          tags: ['gamification', 'community'],
        ),
      ],
      usedSources: sources,
      ethicalConcerns: [],
      logs: ['Mock search completed'],
    );
  }

  ResearchResult _parseResearchResult(Map<String, dynamic> data) {
    return ResearchResult(
      query: data['query'] ?? '',
      totalResults: data['total_results'] ?? 0,
      papers: (data['papers'] as List<dynamic>? ?? []).map((p) => ResearchPaper.fromJson(p)).toList(),
      usedSources: List<String>.from(data['used_sources'] ?? []),
      ethicalConcerns: (data['ethical_concerns'] as List<dynamic>? ?? []).map((e) => _parseEthicalConcern(e)).toList(),
      logs: List<String>.from(data['logs'] ?? []),
    );
  }

  EthicalConcern _parseEthicalConcern(String? e) {
    switch (e) {
      case 'addictionResearch': return EthicalConcern.addictionResearch;
      case 'communityManipulation': return EthicalConcern.communityManipulation;
      case 'aiBias': return EthicalConcern.aiBias;
      case 'commercialization': return EthicalConcern.commercialization;
      case 'echoChambers': return EthicalConcern.echoChambers;
      default: return EthicalConcern.addictionResearch;
    }
  }

  ResearchSourceDetail _createMockSourceDetail(String sourceId) {
    return ResearchSourceDetail(
      id: sourceId,
      name: sourceId.toUpperCase(),
      description: 'Mock description for $sourceId',
      url: 'https://example.com/$sourceId',
      categories: ['scientific'],
      enabled: true,
      ethicalConcerns: [],
    );
  }

  ResearchSourceDetail _parseSourceDetail(Map<String, dynamic> data) {
    return ResearchSourceDetail(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      url: data['url'] ?? '',
      categories: List<String>.from(data['categories'] ?? []),
      enabled: data['enabled'] ?? true,
      ethicalConcerns: (data['ethical_concerns'] as List<dynamic>? ?? []).map((e) => _parseEthicalConcern(e)).toList(),
    );
  }

  String _createMockExport(List<ResearchPaper> papers, String format) {
    if (format == 'bibtex') {
      return papers.map((p) => '@article{${p.id},\n  title={${p.title}},\n  author={${p.authors.join(' and ')}},\n  year={${p.year}},\n  url={${p.url}}\n}').join('\n\n');
    }
    if (format == 'csv') {
      final header = 'id,title,authors,source,year,url,score';
      final rows = papers.map((p) => '"${p.id}","${p.title}","${p.authors.join('; ')}",${p.source},${p.year},${p.url},${p.score}').join('\n');
      return '$header\n$rows';
    }
    // Default: JSON
    return jsonEncode(papers.map((p) => p.toJson()).toList());
  }
}

/// Ergebnis einer Recherche
class ResearchResult {
  final String query;
  final int totalResults;
  final List<ResearchPaper> papers;
  final List<String> usedSources;
  final List<EthicalConcern> ethicalConcerns;
  final List<String> logs;

  ResearchResult({
    required this.query,
    required this.totalResults,
    required this.papers,
    required this.usedSources,
    required this.ethicalConcerns,
    required this.logs,
  });
}

/// Paper/Artikel aus einer Quelle
class ResearchPaper {
  final String id;
  final String title;
  final List<String> authors;
  final String source;
  final int year;
  final String url;
  final String abstractText;
  final double score;
  final List<String> tags;

  ResearchPaper({
    required this.id,
    required this.title,
    required this.authors,
    required this.source,
    required this.year,
    required this.url,
    required this.abstractText,
    required this.score,
    required this.tags,
  });

  factory ResearchPaper.fromJson(Map<String, dynamic> json) {
    return ResearchPaper(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      authors: List<String>.from(json['authors'] ?? []),
      source: json['source'] ?? '',
      year: json['year'] ?? 0,
      url: json['url'] ?? '',
      abstractText: json['abstract'] ?? '',
      score: (json['score'] ?? 0.0).toDouble(),
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'authors': authors,
      'source': source,
      'year': year,
      'url': url,
      'abstract': abstractText,
      'score': score,
      'tags': tags,
    };
  }
}

/// Detail einer Quelle
class ResearchSourceDetail {
  final String id;
  final String name;
  final String description;
  final String url;
  final List<String> categories;
  final bool enabled;
  final List<EthicalConcern> ethicalConcerns;

  ResearchSourceDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.url,
    required this.categories,
    required this.enabled,
    required this.ethicalConcerns,
  });
} 