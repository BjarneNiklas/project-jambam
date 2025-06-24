import 'dart:async';
import 'package:flutter/foundation.dart';

enum AIApproach {
  ruleBased,
  localSLM,
  rag,
  llm,
  hybrid,
}

enum RequestComplexity {
  simple,
  moderate,
  complex,
  expert,
}

enum PrivacyLevel {
  low,
  medium,
  high,
  critical,
}

enum CostSensitivity {
  low,
  medium,
  high,
  critical,
}

class RequestAnalysis {
  final RequestComplexity complexity;
  final String domain;
  final bool isUrgent;
  final PrivacyLevel privacyLevel;
  final CostSensitivity costSensitivity;
  final Map<String, dynamic> metadata;

  RequestAnalysis({
    required this.complexity,
    required this.domain,
    required this.isUrgent,
    required this.privacyLevel,
    required this.costSensitivity,
    this.metadata = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      'complexity': complexity.name,
      'domain': domain,
      'isUrgent': isUrgent,
      'privacyLevel': privacyLevel.name,
      'costSensitivity': costSensitivity.name,
      'metadata': metadata,
    };
  }
}

class RouteSelection {
  final AIApproach approach;
  final String reasoning;
  final List<AIApproach> alternatives;
  final double estimatedCost;
  final int estimatedTimeMs;
  final Map<String, dynamic> configuration;

  RouteSelection({
    required this.approach,
    required this.reasoning,
    required this.alternatives,
    required this.estimatedCost,
    required this.estimatedTimeMs,
    this.configuration = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      'approach': approach.name,
      'reasoning': reasoning,
      'alternatives': alternatives.map((a) => a.name).toList(),
      'estimatedCost': estimatedCost,
      'estimatedTimeMs': estimatedTimeMs,
      'configuration': configuration,
    };
  }
}

class UserRequest {
  final String id;
  final String content;
  final String userId;
  final DateTime timestamp;
  final Map<String, dynamic> context;
  final bool requiresConfirmation;
  final Map<String, dynamic> preferences;

  UserRequest({
    required this.id,
    required this.content,
    required this.userId,
    required this.timestamp,
    this.context = const {},
    this.requiresConfirmation = false,
    this.preferences = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'userId': userId,
      'timestamp': timestamp.toIso8601String(),
      'context': context,
      'requiresConfirmation': requiresConfirmation,
      'preferences': preferences,
    };
  }
}

class IntelligentRouter {
  static const Map<String, List<String>> _domainKeywords = {
    'game_development': [
      'game', 'unity', 'unreal', 'godot', 'bevy', 'sprite', 'animation',
      'physics', 'collision', 'shader', 'script', 'level', 'character',
      'inventory', 'quest', 'dialogue', 'combat', 'rpg', 'fps', 'platformer'
    ],
    'research': [
      'research', 'paper', 'study', 'analysis', 'data', 'statistics',
      'survey', 'experiment', 'methodology', 'findings', 'conclusion',
      'academic', 'scientific', 'peer-reviewed', 'citation'
    ],
    'asset_generation': [
      'model', 'texture', 'animation', 'sound', 'music', '3d', 'mesh',
      'material', 'rigging', 'skeleton', 'blend', 'fbx', 'obj', 'gltf'
    ],
    'code_generation': [
      'code', 'function', 'class', 'method', 'algorithm', 'bug', 'error',
      'debug', 'optimize', 'refactor', 'test', 'documentation', 'api'
    ],
    'creative_design': [
      'design', 'concept', 'art', 'story', 'narrative', 'character',
      'world', 'theme', 'style', 'aesthetic', 'mood', 'atmosphere'
    ],
  };

  static const Map<String, List<String>> _complexityIndicators = {
    'simple': [
      'what is', 'how to', 'define', 'explain', 'list', 'show',
      'basic', 'simple', 'easy', 'quick', 'fast'
    ],
    'moderate': [
      'compare', 'analyze', 'evaluate', 'discuss', 'describe',
      'implement', 'create', 'build', 'develop', 'design'
    ],
    'complex': [
      'optimize', 'debug', 'refactor', 'architect', 'integrate',
      'advanced', 'complex', 'sophisticated', 'comprehensive'
    ],
    'expert': [
      'research', 'innovate', 'invent', 'breakthrough', 'cutting-edge',
      'experimental', 'theoretical', 'academic', 'scientific'
    ],
  };

  static const Map<String, List<String>> _privacyIndicators = {
    'low': [
      'public', 'general', 'common', 'standard', 'basic'
    ],
    'medium': [
      'personal', 'user', 'preference', 'setting', 'configuration'
    ],
    'high': [
      'private', 'sensitive', 'confidential', 'personal data',
      'user data', 'profile', 'account'
    ],
    'critical': [
      'password', 'token', 'key', 'secret', 'credential',
      'authentication', 'authorization', 'security'
    ],
  };

  static const Map<String, List<String>> _costIndicators = {
    'low': [
      'free', 'cheap', 'inexpensive', 'budget', 'simple'
    ],
    'medium': [
      'reasonable', 'moderate', 'standard', 'normal'
    ],
    'high': [
      'expensive', 'premium', 'advanced', 'complex', 'comprehensive'
    ],
    'critical': [
      'unlimited', 'maximum', 'best', 'optimal', 'perfect'
    ],
  };

  // Request Analysis
  RequestAnalysis analyzeRequest(UserRequest request) {
    final content = request.content.toLowerCase();
    final context = request.context;
    final preferences = request.preferences;

    // Analyze complexity
    final complexity = _analyzeComplexity(content, context);

    // Identify domain
    final domain = _identifyDomain(content, context);

    // Determine urgency
    final isUrgent = _determineUrgency(content, context, preferences);

    // Assess privacy needs
    final privacyLevel = _assessPrivacyNeeds(content, context, preferences);

    // Evaluate cost constraints
    final costSensitivity = _evaluateCostConstraints(content, context, preferences);

    return RequestAnalysis(
      complexity: complexity,
      domain: domain,
      isUrgent: isUrgent,
      privacyLevel: privacyLevel,
      costSensitivity: costSensitivity,
      metadata: {
        'wordCount': content.split(' ').length,
        'hasCode': content.contains('```') || content.contains('{'),
        'hasUrls': content.contains('http'),
        'hasEmails': content.contains('@'),
        'language': _detectLanguage(content),
      },
    );
  }

  RequestComplexity _analyzeComplexity(String content, Map<String, dynamic> context) {
    int complexityScore = 0;
    
    // Check for complexity indicators
    for (final entry in _complexityIndicators.entries) {
      for (final indicator in entry.value) {
        if (content.contains(indicator)) {
          switch (entry.key) {
            case 'simple':
              complexityScore += 1;
              break;
            case 'moderate':
              complexityScore += 2;
              break;
            case 'complex':
              complexityScore += 3;
              break;
            case 'expert':
              complexityScore += 4;
              break;
          }
        }
      }
    }

    // Check word count
    final wordCount = content.split(' ').length;
    if (wordCount > 100) complexityScore += 2;
    if (wordCount > 200) complexityScore += 2;

    // Check for code blocks
    if (content.contains('```')) complexityScore += 2;

    // Check context complexity
    if (context['previousComplexity'] != null) {
      complexityScore += context['previousComplexity'] as int;
    }

    // Determine complexity level
    if (complexityScore <= 2) return RequestComplexity.simple;
    if (complexityScore <= 4) return RequestComplexity.moderate;
    if (complexityScore <= 6) return RequestComplexity.complex;
    return RequestComplexity.expert;
  }

  String _identifyDomain(String content, Map<String, dynamic> context) {
    final domainScores = <String, int>{};

    // Check domain keywords
    for (final entry in _domainKeywords.entries) {
      for (final keyword in entry.value) {
        if (content.contains(keyword)) {
          domainScores[entry.key] = (domainScores[entry.key] ?? 0) + 1;
        }
      }
    }

    // Check context for domain hints
    if (context['currentProject'] != null) {
      final project = context['currentProject'] as Map<String, dynamic>;
      if (project['type'] == 'game') {
        domainScores['game_development'] = (domainScores['game_development'] ?? 0) + 2;
      }
    }

    // Return domain with highest score, or 'general' if none found
    if (domainScores.isEmpty) return 'general';
    
    final sortedDomains = domainScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sortedDomains.first.key;
  }

  bool _determineUrgency(String content, Map<String, dynamic> context, Map<String, dynamic> preferences) {
    // Check for urgency indicators
    final urgencyKeywords = [
      'urgent', 'asap', 'quick', 'fast', 'immediate', 'now',
      'emergency', 'critical', 'deadline', 'time-sensitive'
    ];

    for (final keyword in urgencyKeywords) {
      if (content.contains(keyword)) return true;
    }

    // Check context for urgency
    if (context['deadline'] != null) {
      final deadline = DateTime.parse(context['deadline']);
      final now = DateTime.now();
      final difference = deadline.difference(now).inHours;
      if (difference < 24) return true;
    }

    // Check user preferences
    if (preferences['preferFastResponses'] == true) return true;

    return false;
  }

  PrivacyLevel _assessPrivacyNeeds(String content, Map<String, dynamic> context, Map<String, dynamic> preferences) {
    // Check for privacy indicators
    for (final entry in _privacyIndicators.entries) {
      for (final indicator in entry.value) {
        if (content.contains(indicator)) {
          switch (entry.key) {
            case 'low':
              return PrivacyLevel.low;
            case 'medium':
              return PrivacyLevel.medium;
            case 'high':
              return PrivacyLevel.high;
            case 'critical':
              return PrivacyLevel.critical;
          }
        }
      }
    }

    // Check user preferences
    if (preferences['privacyLevel'] != null) {
      return PrivacyLevel.values.firstWhere(
        (level) => level.name == preferences['privacyLevel'],
        orElse: () => PrivacyLevel.medium,
      );
    }

    // Default to medium privacy
    return PrivacyLevel.medium;
  }

  CostSensitivity _evaluateCostConstraints(String content, Map<String, dynamic> context, Map<String, dynamic> preferences) {
    // Check for cost indicators
    for (final entry in _costIndicators.entries) {
      for (final indicator in entry.value) {
        if (content.contains(indicator)) {
          switch (entry.key) {
            case 'low':
              return CostSensitivity.low;
            case 'medium':
              return CostSensitivity.medium;
            case 'high':
              return CostSensitivity.high;
            case 'critical':
              return CostSensitivity.critical;
          }
        }
      }
    }

    // Check user preferences
    if (preferences['costSensitivity'] != null) {
      return CostSensitivity.values.firstWhere(
        (level) => level.name == preferences['costSensitivity'],
        orElse: () => CostSensitivity.medium,
      );
    }

    // Default to medium cost sensitivity
    return CostSensitivity.medium;
  }

  String _detectLanguage(String content) {
    // Simple language detection based on common words
    final germanWords = ['der', 'die', 'das', 'und', 'oder', 'aber', 'für', 'mit', 'von', 'zu'];
    final englishWords = ['the', 'and', 'or', 'but', 'for', 'with', 'from', 'to', 'in', 'on'];

    int germanCount = 0;
    int englishCount = 0;

    for (final word in content.split(' ')) {
      if (germanWords.contains(word)) germanCount++;
      if (englishWords.contains(word)) englishCount++;
    }

    if (germanCount > englishCount) return 'german';
    if (englishCount > germanCount) return 'english';
    return 'mixed';
  }

  // Route Selection
  RouteSelection selectOptimalRoute(RequestAnalysis analysis) {
    AIApproach approach;
    String reasoning;
    List<AIApproach> alternatives = [];

    // Decision logic based on analysis
    if (analysis.complexity == RequestComplexity.simple && 
        analysis.domain != 'research' && 
        analysis.privacyLevel != PrivacyLevel.critical) {
      approach = AIApproach.ruleBased;
      reasoning = 'Simple request in known domain - using rule-based system for fast, cost-effective response';
      alternatives = [AIApproach.localSLM, AIApproach.rag];
    } else if (analysis.privacyLevel == PrivacyLevel.critical || 
               analysis.privacyLevel == PrivacyLevel.high) {
      approach = AIApproach.localSLM;
      reasoning = 'High privacy requirement - using local SLM to keep data private';
      alternatives = [AIApproach.ruleBased, AIApproach.hybrid];
    } else if (analysis.domain == 'research' || 
               analysis.complexity == RequestComplexity.expert) {
      approach = AIApproach.rag;
      reasoning = 'Research or expert-level request - using RAG for accurate, sourced information';
      alternatives = [AIApproach.llm, AIApproach.hybrid];
    } else if (analysis.complexity == RequestComplexity.complex || 
               analysis.complexity == RequestComplexity.expert) {
      approach = AIApproach.llm;
      reasoning = 'Complex request requiring advanced reasoning - using LLM for best quality';
      alternatives = [AIApproach.rag, AIApproach.hybrid];
    } else if (analysis.costSensitivity == CostSensitivity.critical) {
      approach = AIApproach.ruleBased;
      reasoning = 'Cost-critical request - using rule-based system to minimize costs';
      alternatives = [AIApproach.localSLM, AIApproach.rag];
    } else {
      approach = AIApproach.hybrid;
      reasoning = 'Balanced approach - combining multiple AI methods for optimal results';
      alternatives = [AIApproach.llm, AIApproach.rag, AIApproach.localSLM];
    }

    // Calculate estimated cost and time
    final estimatedCost = _calculateEstimatedCost(approach, analysis);
    final estimatedTimeMs = _calculateEstimatedTime(approach, analysis);

    return RouteSelection(
      approach: approach,
      reasoning: reasoning,
      alternatives: alternatives,
      estimatedCost: estimatedCost,
      estimatedTimeMs: estimatedTimeMs,
      configuration: _getConfiguration(approach, analysis),
    );
  }

  double _calculateEstimatedCost(AIApproach approach, RequestAnalysis analysis) {
    switch (approach) {
      case AIApproach.ruleBased:
        return 0.0; // No API costs
      case AIApproach.localSLM:
        return 0.01; // Minimal computational cost
      case AIApproach.rag:
        return 0.05; // Low cost with reduced LLM usage
      case AIApproach.llm:
        return 0.15; // Standard LLM cost
      case AIApproach.hybrid:
        return 0.10; // Moderate cost for combined approach
    }
  }

  int _calculateEstimatedTime(AIApproach approach, RequestAnalysis analysis) {
    switch (approach) {
      case AIApproach.ruleBased:
        return 50; // Instant
      case AIApproach.localSLM:
        return 200; // Fast local processing
      case AIApproach.rag:
        return 1000; // Moderate with retrieval
      case AIApproach.llm:
        return 2000; // Network dependent
      case AIApproach.hybrid:
        return 1500; // Combined processing time
    }
  }

  Map<String, dynamic> _getConfiguration(AIApproach approach, RequestAnalysis analysis) {
    final baseConfig = {
      'language': analysis.metadata['language'] ?? 'english',
      'domain': analysis.domain,
      'complexity': analysis.complexity.name,
    };

    switch (approach) {
      case AIApproach.ruleBased:
        return {
          ...baseConfig,
          'ruleSet': 'game_development',
          'fallbackToLLM': false,
        };
      case AIApproach.localSLM:
        return {
          ...baseConfig,
          'model': 'phi-3-mini',
          'maxTokens': 512,
          'temperature': 0.3,
        };
      case AIApproach.rag:
        return {
          ...baseConfig,
          'knowledgeBase': analysis.domain,
          'maxResults': 5,
          'similarityThreshold': 0.7,
        };
      case AIApproach.llm:
        return {
          ...baseConfig,
          'provider': 'openai',
          'model': 'gpt-4',
          'maxTokens': 2048,
          'temperature': 0.7,
        };
      case AIApproach.hybrid:
        return {
          ...baseConfig,
          'primaryApproach': 'rag',
          'fallbackApproach': 'llm',
          'confidenceThreshold': 0.8,
        };
    }
  }

  // User Confirmation
  Future<RouteSelection> requestUserConfirmation(
    RouteSelection route, 
    RequestAnalysis analysis,
    {bool autoConfirm = false}
  ) async {
    if (autoConfirm) return route;

    // In a real implementation, this would show a UI dialog
    // For now, we'll simulate the confirmation process
    await Future.delayed(const Duration(milliseconds: 100));
    
    return route;
  }

  // Performance Tracking
  void trackPerformance(
    AIApproach approach,
    UserRequest request,
    RequestAnalysis analysis,
    RouteSelection route,
    Map<String, dynamic> response,
    Map<String, dynamic> userFeedback,
  ) {
    // Track performance metrics
    final performance = {
      'approach': approach.name,
      'requestId': request.id,
      'userId': request.userId,
      'timestamp': DateTime.now().toIso8601String(),
      'actualCost': response['cost'] ?? 0.0,
      'actualTimeMs': response['duration'] ?? 0,
      'userSatisfaction': userFeedback['satisfaction'] ?? 0,
      'success': userFeedback['success'] ?? true,
      'analysis': analysis.toJson(),
      'route': route.toJson(),
    };

    // Store performance data (in real implementation, save to database)
    if (kDebugMode) {
      print('Performance tracked: $performance');
    }
  }

  // Route Optimization
  void optimizeRoutes(Map<String, dynamic> performanceData) {
    // Analyze performance data and adjust routing logic
    // This would involve machine learning to optimize route selection
    if (kDebugMode) {
      print('Optimizing routes based on performance data');
    }
  }
} 