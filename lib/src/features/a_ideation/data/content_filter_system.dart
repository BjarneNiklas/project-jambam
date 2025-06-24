import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Intelligentes Content-Filter-System
/// Kombiniert Keyword-Filter, AI-Klassifizierung und User-Feedback
class ContentFilterSystem {
  static const String _filterSettingsKey = 'content_filter_settings';
  
  // Ethische Kategorien mit Keywords und Kontext
  static const Map<String, EthicalCategory> _ethicalCategories = {
    'addiction': EthicalCategory(
      name: 'Addiction Prevention',
      description: 'Filtert Inhalte die Suchtverhalten fördern könnten',
      keywords: [
        'gambling', 'loot boxes', 'microtransactions', 'pay-to-win',
        'compulsive', 'addictive', 'manipulation', 'psychological tricks',
        'daily rewards', 'streak bonuses', 'fear of missing out',
        'random rewards', 'variable reward schedule', 'dopamine manipulation'
      ],
      contextPatterns: [
        'encourages spending',
        'creates dependency',
        'exploits psychology',
        'manipulates behavior'
      ],
      severity: FilterSeverity.high,
    ),
    
    'ai_bias': EthicalCategory(
      name: 'AI Bias Prevention',
      description: 'Filtert Inhalte mit potenziellen AI-Bias',
      keywords: [
        'stereotypes', 'discrimination', 'bias', 'prejudice',
        'unfair', 'discriminatory', 'exclusionary', 'racist',
        'sexist', 'ageist', 'ableist', 'homophobic'
      ],
      contextPatterns: [
        'reinforces stereotypes',
        'discriminates against',
        'excludes certain groups',
        'promotes bias'
      ],
      severity: FilterSeverity.high,
    ),
    
    'community_manipulation': EthicalCategory(
      name: 'Community Manipulation',
      description: 'Filtert Inhalte die Communities manipulieren',
      keywords: [
        'echo chamber', 'filter bubble', 'manipulation', 'fake news',
        'misinformation', 'propaganda', 'social engineering',
        'astroturfing', 'bot farms', 'coordinated campaigns'
      ],
      contextPatterns: [
        'manipulates public opinion',
        'creates false consensus',
        'spreads misinformation',
        'coordinated manipulation'
      ],
      severity: FilterSeverity.medium,
    ),
    
    'commercialization': EthicalCategory(
      name: 'Excessive Commercialization',
      description: 'Filtert übermäßig kommerzialisierte Inhalte',
      keywords: [
        'excessive monetization', 'predatory pricing', 'exploitation',
        'paywall', 'freemium trap', 'subscription fatigue',
        'hidden costs', 'bait and switch', 'deceptive pricing'
      ],
      contextPatterns: [
        'exploits users financially',
        'deceptive business practices',
        'excessive monetization',
        'predatory pricing'
      ],
      severity: FilterSeverity.medium,
    ),
    
    'privacy_violation': EthicalCategory(
      name: 'Privacy Violation',
      description: 'Filtert Inhalte die Privatsphäre verletzen',
      keywords: [
        'data mining', 'surveillance', 'tracking', 'privacy violation',
        'personal data', 'user profiling', 'behavioral tracking',
        'unauthorized access', 'data breach', 'privacy invasion'
      ],
      contextPatterns: [
        'violates user privacy',
        'collects personal data',
        'tracks user behavior',
        'surveillance capitalism'
      ],
      severity: FilterSeverity.high,
    ),
    
    'misinformation': EthicalCategory(
      name: 'Misinformation',
      description: 'Filtert falsche oder irreführende Informationen',
      keywords: [
        'fake news', 'misinformation', 'disinformation', 'conspiracy',
        'unverified claims', 'false information', 'misleading',
        'factually incorrect', 'debunked', 'unreliable source'
      ],
      contextPatterns: [
        'spreads false information',
        'unverified claims',
        'misleading content',
        'factually incorrect'
      ],
      severity: FilterSeverity.high,
    ),
  };

  /// Filter-Einstellungen
  FilterSettings _settings = FilterSettings();
  
  /// Konstruktor
  ContentFilterSystem() {
    _loadSettings();
  }

  /// Lädt Filter-Einstellungen
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString(_filterSettingsKey);
    
    if (settingsJson != null) {
      try {
        final settingsMap = jsonDecode(settingsJson);
        _settings = FilterSettings.fromJson(settingsMap);
      } catch (e) {
        // Verwende Default-Einstellungen bei Fehler
        _settings = FilterSettings();
      }
    }
  }

  /// Speichert Filter-Einstellungen
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_filterSettingsKey, jsonEncode(_settings.toJson()));
  }

  /// Gibt alle verfügbaren ethischen Kategorien zurück
  Map<String, EthicalCategory> get availableCategories => _ethicalCategories;

  /// Gibt aktuelle Filter-Einstellungen zurück
  FilterSettings get settings => _settings;

  /// Aktualisiert Filter-Einstellungen
  Future<void> updateSettings(FilterSettings newSettings) async {
    _settings = newSettings;
    await _saveSettings();
  }

  /// Filtert einen Text basierend auf den aktuellen Einstellungen
  Future<FilterResult> filterContent(String content) async {
    if (!_settings.enabled) {
      return FilterResult(shouldFilter: false, confidence: 1.0);
    }

    final enabledConcerns = _settings.enabledConcerns;
    if (enabledConcerns.isEmpty) {
      return FilterResult(shouldFilter: false, confidence: 1.0);
    }

    // 1. Keyword-basierte Filterung
    if (_settings.useKeywordFilter) {
      final keywordResult = _performKeywordFiltering(content, enabledConcerns);
      if (keywordResult.shouldFilter) {
        return keywordResult;
      }
    }

    // 2. Kontext-basierte Filterung
    if (_settings.useContextFilter) {
      final contextResult = _performContextFiltering(content, enabledConcerns);
      if (contextResult.shouldFilter) {
        return contextResult;
      }
    }

    // 3. AI-Klassifizierung (falls verfügbar)
    if (_settings.useAIClassification) {
      final aiResult = await _performAIClassification(content, enabledConcerns);
      if (aiResult.shouldFilter) {
        return aiResult;
      }
    }

    // 4. User-Feedback-basierte Filterung
    if (_settings.useUserFeedback) {
      final feedbackResult = await _performUserFeedbackFiltering(content);
      if (feedbackResult.shouldFilter) {
        return feedbackResult;
      }
    }

    return FilterResult(shouldFilter: false, confidence: 1.0);
  }

  /// Keyword-basierte Filterung
  FilterResult _performKeywordFiltering(String content, List<String> enabledConcerns) {
    final contentLower = content.toLowerCase();
    // final words = contentLower.split(RegExp(r'\s+')); // Unused
    
    for (final concern in enabledConcerns) {
      final category = _ethicalCategories[concern];
      if (category == null) continue;

      int keywordMatches = 0;
      final matchedKeywords = <String>[];

      for (final keyword in category.keywords) {
        if (contentLower.contains(keyword.toLowerCase())) {
          keywordMatches++;
          matchedKeywords.add(keyword);
        }
      }

      // Wenn genügend Keywords gefunden wurden
      if (keywordMatches >= _settings.minKeywordMatches) {
        return FilterResult(
          shouldFilter: true,
          reason: 'keyword_match',
          confidence: (keywordMatches / category.keywords.length).clamp(0.0, 1.0),
          details: {
            'category': concern,
            'matched_keywords': matchedKeywords,
            'total_matches': keywordMatches,
          },
        );
      }
    }

    return FilterResult(shouldFilter: false, confidence: 1.0);
  }

  /// Kontext-basierte Filterung
  FilterResult _performContextFiltering(String content, List<String> enabledConcerns) {
    final contentLower = content.toLowerCase();
    // final sentences = contentLower.split(RegExp(r'[.!?]+')); // Unused

    for (final concern in enabledConcerns) {
      final category = _ethicalCategories[concern];
      if (category == null) continue;

      for (final pattern in category.contextPatterns) {
        if (contentLower.contains(pattern.toLowerCase())) {
          return FilterResult(
            shouldFilter: true,
            reason: 'context_match',
            confidence: 0.8,
            details: {
              'category': concern,
              'matched_pattern': pattern,
            },
          );
        }
      }
    }

    return FilterResult(shouldFilter: false, confidence: 1.0);
  }

  /// AI-Klassifizierung (Mock-Implementation)
  Future<FilterResult> _performAIClassification(String content, List<String> enabledConcerns) async {
    // Hier würde eine echte AI-Klassifizierung stattfinden
    // Für jetzt: Mock-Implementation
    
    await Future.delayed(const Duration(milliseconds: 100)); // Simuliere AI-Verarbeitung
    
    // Simuliere AI-Risiko-Bewertung
    final risks = <String, double>{};
    for (final concern in enabledConcerns) {
      risks[concern] = _simulateAIRisk(content, concern);
    }

    // Finde höchstes Risiko
    String? highestRiskCategory;
    double highestRisk = 0.0;

    for (final entry in risks.entries) {
      if (entry.value > highestRisk && entry.value > _settings.aiThreshold) {
        highestRisk = entry.value;
        highestRiskCategory = entry.key;
      }
    }

    if (highestRiskCategory != null) {
      return FilterResult(
        shouldFilter: true,
        reason: 'ai_classification',
        confidence: highestRisk,
        details: {
          'category': highestRiskCategory,
          'risk_score': highestRisk,
          'all_risks': risks,
        },
      );
    }

    return FilterResult(shouldFilter: false, confidence: 1.0);
  }

  /// Simuliert AI-Risiko-Bewertung
  double _simulateAIRisk(String content, String concern) {
    // Einfache Heuristik basierend auf Keyword-Dichte
    final category = _ethicalCategories[concern];
    if (category == null) return 0.0;

    final contentLower = content.toLowerCase();
    int matches = 0;

    for (final keyword in category.keywords) {
      if (contentLower.contains(keyword.toLowerCase())) {
        matches++;
      }
    }

    // Normalisiere basierend auf Textlänge und Keyword-Anzahl
    final density = matches / (content.length / 100); // Matches per 100 characters
    return (density * 0.3).clamp(0.0, 1.0); // Max 30% risk per keyword
  }

  /// User-Feedback-basierte Filterung
  Future<FilterResult> _performUserFeedbackFiltering(String content) async {
    // Hier würde User-Feedback-Analyse stattfinden
    // Für jetzt: Mock-Implementation
    
    // Simuliere User-Feedback-Datenbank
    final feedbackScore = _simulateUserFeedback(content);
    
    if (feedbackScore > _settings.userFeedbackThreshold) {
      return FilterResult(
        shouldFilter: true,
        reason: 'user_feedback',
        confidence: feedbackScore,
        details: {
          'feedback_score': feedbackScore,
          'user_reports': _simulateUserReports(content),
        },
      );
    }

    return FilterResult(shouldFilter: false, confidence: 1.0);
  }

  /// Simuliert User-Feedback
  double _simulateUserFeedback(String content) {
    // Einfache Heuristik basierend auf problematischen Wörtern
    final problematicWords = [
      'scam', 'fake', 'spam', 'malware', 'virus', 'hack',
      'cheat', 'exploit', 'bug', 'glitch', 'broken'
    ];

    final contentLower = content.toLowerCase();
    int matches = 0;

    for (final word in problematicWords) {
      if (contentLower.contains(word)) {
        matches++;
      }
    }

    return (matches * 0.2).clamp(0.0, 1.0);
  }

  /// Simuliert User-Reports
  int _simulateUserReports(String content) {
    // Mock-Implementation
    return content.length > 1000 ? 3 : 0;
  }

  /// Analysiert Content ohne zu filtern
  Future<ContentAnalysis> analyzeContent(String content) async {
    final analysis = ContentAnalysis();
    
    for (final entry in _ethicalCategories.entries) {
      final concern = entry.key;
      final category = entry.value;
      
      // Keyword-Analyse
      final keywordMatches = <String>[];
      final contentLower = content.toLowerCase();
      
      for (final keyword in category.keywords) {
        if (contentLower.contains(keyword.toLowerCase())) {
          keywordMatches.add(keyword);
        }
      }
      
      // Kontext-Analyse
      final contextMatches = <String>[];
      for (final pattern in category.contextPatterns) {
        if (contentLower.contains(pattern.toLowerCase())) {
          contextMatches.add(pattern);
        }
      }
      
      // AI-Risiko (simuliert)
      final aiRisk = _simulateAIRisk(content, concern);
      
      analysis.addConcernAnalysis(concern, ConcernAnalysis(
        category: category,
        keywordMatches: keywordMatches,
        contextMatches: contextMatches,
        aiRisk: aiRisk,
        overallRisk: _calculateOverallRisk(keywordMatches.length, contextMatches.length, aiRisk),
      ));
    }
    
    return analysis;
  }

  /// Berechnet Gesamtrisiko
  double _calculateOverallRisk(int keywordMatches, int contextMatches, double aiRisk) {
    final keywordRisk = (keywordMatches * 0.1).clamp(0.0, 0.5);
    final contextRisk = (contextMatches * 0.2).clamp(0.0, 0.3);
    final combinedRisk = keywordRisk + contextRisk + aiRisk;
    
    return combinedRisk.clamp(0.0, 1.0);
  }

  /// Fügt User-Feedback hinzu
  Future<void> addUserFeedback(String content, String concern, bool isProblematic) async {
    // Hier würde User-Feedback gespeichert werden
    // Für jetzt: Mock-Implementation
    
    if (isProblematic) {
      // Speichere problematischen Content
      await _saveProblematicContent(content, concern);
    }
  }

  /// Speichert problematischen Content
  Future<void> _saveProblematicContent(String content, String concern) async {
    // Mock-Implementation
    // In der echten Implementation würde dies in einer Datenbank gespeichert
  }

  /// Exportiert Filter-Einstellungen
  Future<String> exportSettings() async {
    return jsonEncode(_settings.toJson());
  }

  /// Importiert Filter-Einstellungen
  Future<void> importSettings(String jsonData) async {
    try {
      final settingsMap = jsonDecode(jsonData);
      final newSettings = FilterSettings.fromJson(settingsMap);
      await updateSettings(newSettings);
    } catch (e) {
      throw Exception('Invalid settings data: $e');
    }
  }
}

/// Ethische Kategorie
class EthicalCategory {
  final String name;
  final String description;
  final List<String> keywords;
  final List<String> contextPatterns;
  final FilterSeverity severity;

  const EthicalCategory({
    required this.name,
    required this.description,
    required this.keywords,
    required this.contextPatterns,
    required this.severity,
  });
}

/// Filter-Schweregrad
enum FilterSeverity {
  low,
  medium,
  high,
  critical,
}

/// Filter-Einstellungen
class FilterSettings {
  bool enabled;
  List<String> enabledConcerns;
  bool useKeywordFilter;
  bool useContextFilter;
  bool useAIClassification;
  bool useUserFeedback;
  int minKeywordMatches;
  double aiThreshold;
  double userFeedbackThreshold;

  FilterSettings({
    this.enabled = true,
    this.enabledConcerns = const ['addiction', 'ai_bias'],
    this.useKeywordFilter = true,
    this.useContextFilter = true,
    this.useAIClassification = false,
    this.useUserFeedback = false,
    this.minKeywordMatches = 2,
    this.aiThreshold = 0.7,
    this.userFeedbackThreshold = 0.8,
  });

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'enabledConcerns': enabledConcerns,
      'useKeywordFilter': useKeywordFilter,
      'useContextFilter': useContextFilter,
      'useAIClassification': useAIClassification,
      'useUserFeedback': useUserFeedback,
      'minKeywordMatches': minKeywordMatches,
      'aiThreshold': aiThreshold,
      'userFeedbackThreshold': userFeedbackThreshold,
    };
  }

  factory FilterSettings.fromJson(Map<String, dynamic> json) {
    return FilterSettings(
      enabled: json['enabled'] ?? true,
      enabledConcerns: List<String>.from(json['enabledConcerns'] ?? ['addiction', 'ai_bias']),
      useKeywordFilter: json['useKeywordFilter'] ?? true,
      useContextFilter: json['useContextFilter'] ?? true,
      useAIClassification: json['useAIClassification'] ?? false,
      useUserFeedback: json['useUserFeedback'] ?? false,
      minKeywordMatches: json['minKeywordMatches'] ?? 2,
      aiThreshold: json['aiThreshold']?.toDouble() ?? 0.7,
      userFeedbackThreshold: json['userFeedbackThreshold']?.toDouble() ?? 0.8,
    );
  }

  FilterSettings copyWith({
    bool? enabled,
    List<String>? enabledConcerns,
    bool? useKeywordFilter,
    bool? useContextFilter,
    bool? useAIClassification,
    bool? useUserFeedback,
    int? minKeywordMatches,
    double? aiThreshold,
    double? userFeedbackThreshold,
  }) {
    return FilterSettings(
      enabled: enabled ?? this.enabled,
      enabledConcerns: enabledConcerns ?? this.enabledConcerns,
      useKeywordFilter: useKeywordFilter ?? this.useKeywordFilter,
      useContextFilter: useContextFilter ?? this.useContextFilter,
      useAIClassification: useAIClassification ?? this.useAIClassification,
      useUserFeedback: useUserFeedback ?? this.useUserFeedback,
      minKeywordMatches: minKeywordMatches ?? this.minKeywordMatches,
      aiThreshold: aiThreshold ?? this.aiThreshold,
      userFeedbackThreshold: userFeedbackThreshold ?? this.userFeedbackThreshold,
    );
  }
}

/// Filter-Ergebnis
class FilterResult {
  final bool shouldFilter;
  final String reason;
  final double confidence;
  final Map<String, dynamic>? details;

  FilterResult({
    required this.shouldFilter,
    required this.confidence,
    this.reason = 'unknown',
    this.details,
  });
}

/// Content-Analyse
class ContentAnalysis {
  final Map<String, ConcernAnalysis> _concernAnalyses = {};

  void addConcernAnalysis(String concern, ConcernAnalysis analysis) {
    _concernAnalyses[concern] = analysis;
  }

  Map<String, ConcernAnalysis> get concernAnalyses => _concernAnalyses;

  double get overallRisk {
    if (_concernAnalyses.isEmpty) return 0.0;
    
    final risks = _concernAnalyses.values.map((a) => a.overallRisk).toList();
    return risks.reduce((a, b) => a + b) / risks.length;
  }

  List<String> get highRiskConcerns {
    return _concernAnalyses.entries
        .where((entry) => entry.value.overallRisk > 0.7)
        .map((entry) => entry.key)
        .toList();
  }
}

/// Concern-Analyse
class ConcernAnalysis {
  final EthicalCategory category;
  final List<String> keywordMatches;
  final List<String> contextMatches;
  final double aiRisk;
  final double overallRisk;

  ConcernAnalysis({
    required this.category,
    required this.keywordMatches,
    required this.contextMatches,
    required this.aiRisk,
    required this.overallRisk,
  });
} 