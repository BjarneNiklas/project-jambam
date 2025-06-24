import 'dart:async';
import 'dart:math';
import 'intelligent_router.dart';

abstract class AILayer {
  Future<AIResponse> process(UserRequest request, Map<String, dynamic> config);
  bool canHandle(UserRequest request, RequestAnalysis analysis);
  double getConfidence(UserRequest request, RequestAnalysis analysis);
}

class AIResponse {
  final String id;
  final String content;
  final AIApproach approach;
  final double confidence;
  final double cost;
  final int durationMs;
  final Map<String, dynamic> metadata;
  final List<String> sources;
  final bool success;
  final String? error;
  final String? agentName;
  final List<String> activeAgents;
  final List<String> failedAgents;

  AIResponse({
    required this.id,
    required this.content,
    required this.approach,
    required this.confidence,
    required this.cost,
    required this.durationMs,
    this.metadata = const {},
    this.sources = const [],
    this.success = true,
    this.error,
    this.agentName,
    this.activeAgents = const [],
    this.failedAgents = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'approach': approach.name,
      'confidence': confidence,
      'cost': cost,
      'durationMs': durationMs,
      'metadata': metadata,
      'sources': sources,
      'success': success,
      'error': error,
      'agentName': agentName,
      'activeAgents': activeAgents,
      'failedAgents': failedAgents,
    };
  }
}

// Tier 1: Rule-Based Foundation
class RuleBasedLayer implements AILayer {
  static const Map<String, Map<String, String>> _qaDatabase = {
    'game_development': {
      'what is unity': 'Unity is a cross-platform game engine developed by Unity Technologies.',
      'how to create a sprite': 'To create a sprite in Unity: 1. Import image file 2. Set Texture Type to Sprite 3. Drag to scene',
      'what is a game loop': 'A game loop is the main cycle that runs continuously during gameplay, handling input, updating game state, and rendering.',
      'how to add physics': 'To add physics: 1. Add Rigidbody component 2. Add Collider component 3. Configure physics properties',
    },
    'general': {
      'what is jamba': 'Jamba is a next-generation AI-powered platform for game development and creative projects.',
      'how to use ai': 'AI can help with ideation, asset generation, code writing, and problem solving.',
      'what are game jams': 'Game jams are events where developers create games in a short time period, often 48-72 hours.',
    },
  };

  @override
  Future<AIResponse> process(UserRequest request, Map<String, dynamic> config) async {
    final startTime = DateTime.now();
    
    try {
      String response = '';
      double confidence = 0.0;
      List<String> sources = [];

      // Check Q&A database
      final qaResponse = _checkQADatabase(request.content, config['domain'] ?? 'general');
      if (qaResponse != null) {
        response = qaResponse;
        confidence = 0.9;
        sources = ['rule_based_qa'];
      }

      // Validate input if needed
      if (response.isEmpty && request.content.contains('validate')) {
        response = _validateInput(request.content);
        confidence = 0.8;
        sources = ['validation_rules'];
      }

      // Route request if needed
      if (response.isEmpty && request.content.contains('route')) {
        response = _routeRequest(request.content);
        confidence = 0.7;
        sources = ['routing_logic'];
      }

      // Filter content if needed
      if (response.isEmpty && request.content.contains('filter')) {
        response = _filterContent(request.content);
        confidence = 0.6;
        sources = ['content_filter'];
      }

      // Default response if no rules match
      if (response.isEmpty) {
        response = 'I can help with basic questions about ${config['domain'] ?? 'general topics'}. Please ask something specific.';
        confidence = 0.3;
        sources = ['default_response'];
      }

      final duration = DateTime.now().difference(startTime).inMilliseconds;

      return AIResponse(
        id: request.id,
        content: response,
        approach: AIApproach.ruleBased,
        confidence: confidence,
        cost: 0.0,
        durationMs: duration,
        sources: sources,
        metadata: {
          'ruleMatched': confidence > 0.5,
          'domain': config['domain'],
        },
        agentName: 'Rule-Based',
      );
    } catch (e) {
      return AIResponse(
        id: request.id,
        content: 'Error processing request with rule-based system',
        approach: AIApproach.ruleBased,
        confidence: 0.0,
        cost: 0.0,
        durationMs: DateTime.now().difference(startTime).inMilliseconds,
        success: false,
        error: e.toString(),
        agentName: 'Rule-Based',
      );
    }
  }

  @override
  bool canHandle(UserRequest request, RequestAnalysis analysis) {
    // Rule-based can handle simple requests in known domains
    return analysis.complexity == RequestComplexity.simple &&
           analysis.domain != 'research' &&
           analysis.privacyLevel != PrivacyLevel.critical;
  }

  @override
  double getConfidence(UserRequest request, RequestAnalysis analysis) {
    // Check if we have rules for this domain and content
    final domain = analysis.domain;
    final content = request.content.toLowerCase();
    
    if (_qaDatabase.containsKey(domain)) {
      for (final question in _qaDatabase[domain]!.keys) {
        if (content.contains(question.toLowerCase())) {
          return 0.9;
        }
      }
    }
    
    return 0.3; // Low confidence for unknown content
  }

  String? _checkQADatabase(String question, String domain) {
    final qaData = _qaDatabase[domain] ?? _qaDatabase['general']!;
    final questionLower = question.toLowerCase();
    
    for (final entry in qaData.entries) {
      if (questionLower.contains(entry.key.toLowerCase())) {
        return entry.value;
      }
    }
    
    return null;
  }

  String _validateInput(String content) {
    final validations = <String, bool>{};
    
    // Check for email
    if (content.contains('@')) {
      validations['email'] = RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(content);
    }
    
    // Check for URL
    if (content.contains('http')) {
      validations['url'] = RegExp(r'^https?://.+').hasMatch(content);
    }
    
    // Check for code blocks
    if (content.contains('```')) {
      validations['code'] = true;
    }
    
    final results = validations.entries.map((e) => '${e.key}: ${e.value ? 'valid' : 'invalid'}').join(', ');
    return 'Validation results: $results';
  }

  String _routeRequest(String content) {
    if (content.contains('game')) return 'Route: Game Development';
    if (content.contains('research')) return 'Route: Research';
    if (content.contains('asset')) return 'Route: Asset Generation';
    if (content.contains('code')) return 'Route: Code Generation';
    return 'Route: General';
  }

  String _filterContent(String content) {
    final inappropriateWords = ['spam', 'inappropriate', 'offensive'];
    for (final word in inappropriateWords) {
      if (content.toLowerCase().contains(word)) {
        return 'Content flagged for review: contains potentially inappropriate content';
      }
    }
    return 'Content passed filtering checks';
  }
}

// Tier 2: Local SLM Processing
class LocalSLMLayer implements AILayer {
  @override
  Future<AIResponse> process(UserRequest request, Map<String, dynamic> config) async {
    final startTime = DateTime.now();
    
    try {
      final model = config['model'] ?? 'phi-3-mini';
      final maxTokens = config['maxTokens'] ?? 512;
      final temperature = config['temperature'] ?? 0.3;
      
      String response = '';
      double confidence = 0.0;
      List<String> sources = [];

      // Intent classification
      if (request.content.contains('classify') || request.content.contains('intent')) {
        response = _classifyIntent(request.content);
        confidence = 0.8;
        sources = ['intent_classification'];
      }

      // Entity extraction
      else if (request.content.contains('extract') || request.content.contains('entities')) {
        response = _extractEntities(request.content);
        confidence = 0.7;
        sources = ['entity_extraction'];
      }

      // Text summarization
      else if (request.content.contains('summarize') || request.content.length > 200) {
        response = _summarizeText(request.content);
        confidence = 0.6;
        sources = ['text_summarization'];
      }

      // Translation
      else if (request.content.contains('translate')) {
        response = _translateText(request.content, config['language'] ?? 'english');
        confidence = 0.7;
        sources = ['translation'];
      }

      // Real-time processing
      else if (config['realTime'] == true) {
        response = _processRealTime(request.content);
        confidence = 0.5;
        sources = ['real_time_processing'];
      }

      // Privacy-sensitive processing
      else if (request.content.contains('private') || request.content.contains('sensitive')) {
        response = _processPrivateData(request.content);
        confidence = 0.9;
        sources = ['private_processing'];
      }

      // Default local processing
      else {
        response = _processWithLocalModel(request.content, model, maxTokens, temperature);
        confidence = 0.4;
        sources = ['local_model_${model}'];
      }

      final duration = DateTime.now().difference(startTime).inMilliseconds;

      return AIResponse(
        id: request.id,
        content: response,
        approach: AIApproach.localSLM,
        confidence: confidence,
        cost: 0.01, // Minimal computational cost
        durationMs: duration,
        sources: sources,
        metadata: {
          'model': model,
          'maxTokens': maxTokens,
          'temperature': temperature,
          'localProcessing': true,
        },
        agentName: 'Local SLM',
      );
    } catch (e) {
      return AIResponse(
        id: request.id,
        content: 'Error processing with local SLM',
        approach: AIApproach.localSLM,
        confidence: 0.0,
        cost: 0.01,
        durationMs: DateTime.now().difference(startTime).inMilliseconds,
        success: false,
        error: e.toString(),
        agentName: 'Local SLM',
      );
    }
  }

  @override
  bool canHandle(UserRequest request, RequestAnalysis analysis) {
    // Local SLM can handle moderate complexity with privacy requirements
    return analysis.privacyLevel == PrivacyLevel.high ||
           analysis.privacyLevel == PrivacyLevel.critical ||
           (analysis.complexity == RequestComplexity.moderate && analysis.costSensitivity == CostSensitivity.high);
  }

  @override
  double getConfidence(UserRequest request, RequestAnalysis analysis) {
    // Higher confidence for privacy-sensitive tasks
    if (analysis.privacyLevel == PrivacyLevel.critical) return 0.9;
    if (analysis.privacyLevel == PrivacyLevel.high) return 0.8;
    return 0.5;
  }

  String _classifyIntent(String content) {
    final intents = {
      'question': ['what', 'how', 'why', 'when', 'where', 'who'],
      'command': ['create', 'generate', 'build', 'make', 'do'],
      'analysis': ['analyze', 'evaluate', 'compare', 'review'],
      'help': ['help', 'assist', 'support', 'guide'],
    };

    for (final entry in intents.entries) {
      for (final keyword in entry.value) {
        if (content.toLowerCase().contains(keyword)) {
          return 'Intent classified as: ${entry.key}';
        }
      }
    }
    
    return 'Intent classified as: general';
  }

  String _extractEntities(String content) {
    final entities = <String>[];
    
    // Extract game development entities
    if (content.contains('unity')) entities.add('Unity Engine');
    if (content.contains('unreal')) entities.add('Unreal Engine');
    if (content.contains('godot')) entities.add('Godot Engine');
    if (content.contains('bevy')) entities.add('Bevy Engine');
    
    // Extract programming languages
    if (content.contains('c#')) entities.add('C#');
    if (content.contains('python')) entities.add('Python');
    if (content.contains('javascript')) entities.add('JavaScript');
    
    return 'Extracted entities: ${entities.join(', ')}';
  }

  String _summarizeText(String content) {
    final words = content.split(' ');
    if (words.length <= 50) return content;
    
    final summary = words.take(50).join(' ');
    return '$summary... (summarized from $words.length words)';
  }

  String _translateText(String content, String targetLanguage) {
    // Mock translation - in real implementation, use actual translation model
    return 'Translated to $targetLanguage: $content';
  }

  String _processRealTime(String content) {
    return 'Real-time processed: $content';
  }

  String _processPrivateData(String content) {
    // Remove sensitive information
    final sanitized = content.replaceAll(RegExp(r'\b\d{4}[- ]?\d{4}[- ]?\d{4}[- ]?\d{4}\b'), '[CARD_NUMBER]');
    return 'Private data processed: $sanitized';
  }

  String _processWithLocalModel(String content, String model, int maxTokens, double temperature) {
    return 'Processed with $model (maxTokens: $maxTokens, temp: $temperature): $content';
  }
}

// Tier 3: RAG for Knowledge Retrieval
class RAGLayer implements AILayer {
  static const Map<String, List<String>> _knowledgeBases = {
    'game_development': [
      'Unity Documentation',
      'Unreal Engine Guides',
      'Game Development Best Practices',
      'Game Design Principles',
    ],
    'research': [
      'Academic Papers',
      'Research Studies',
      'Technical Documentation',
      'Industry Reports',
    ],
    'asset_generation': [
      '3D Modeling Guides',
      'Texture Creation Tutorials',
      'Animation Principles',
      'Asset Optimization',
    ],
  };

  @override
  Future<AIResponse> process(UserRequest request, Map<String, dynamic> config) async {
    final startTime = DateTime.now();
    
    try {
      final knowledgeBase = config['knowledgeBase'] ?? 'general';
      final maxResults = config['maxResults'] ?? 5;
      final similarityThreshold = config['similarityThreshold'] ?? 0.7;
      
      // Search knowledge base
      final relevantDocs = await _searchKnowledgeBase(request.content, knowledgeBase, maxResults);
      
      if (relevantDocs.isEmpty) {
        return AIResponse(
          id: request.id,
          content: 'No relevant information found in knowledge base.',
          approach: AIApproach.rag,
          confidence: 0.0,
          cost: 0.05,
          durationMs: DateTime.now().difference(startTime).inMilliseconds,
          success: false,
          error: 'No relevant documents found',
          agentName: 'RAG',
        );
      }

      // Generate response with context
      final response = await _generateWithContext(request.content, relevantDocs);
      final confidence = _calculateConfidence(relevantDocs, similarityThreshold);
      
      final duration = DateTime.now().difference(startTime).inMilliseconds;

      return AIResponse(
        id: request.id,
        content: response,
        approach: AIApproach.rag,
        confidence: confidence,
        cost: 0.05,
        durationMs: duration,
        sources: relevantDocs.map((doc) => doc['source'] as String).toList(),
        metadata: {
          'knowledgeBase': knowledgeBase,
          'maxResults': maxResults,
          'similarityThreshold': similarityThreshold,
          'documentsFound': relevantDocs.length,
        },
        agentName: 'RAG',
      );
    } catch (e) {
      return AIResponse(
        id: request.id,
        content: 'Error processing with RAG system',
        approach: AIApproach.rag,
        confidence: 0.0,
        cost: 0.05,
        durationMs: DateTime.now().difference(startTime).inMilliseconds,
        success: false,
        error: e.toString(),
        agentName: 'RAG',
      );
    }
  }

  @override
  bool canHandle(UserRequest request, RequestAnalysis analysis) {
    // RAG is best for research and domain-specific queries
    return analysis.domain == 'research' ||
           analysis.complexity == RequestComplexity.expert ||
           (analysis.domain != 'general' && analysis.complexity == RequestComplexity.complex);
  }

  @override
  double getConfidence(UserRequest request, RequestAnalysis analysis) {
    // Higher confidence for research and domain-specific queries
    if (analysis.domain == 'research') return 0.9;
    if (analysis.complexity == RequestComplexity.expert) return 0.8;
    return 0.6;
  }

  Future<List<Map<String, dynamic>>> _searchKnowledgeBase(String query, String knowledgeBase, int maxResults) async {
    // Mock knowledge base search
    final base = _knowledgeBases[knowledgeBase] ?? _knowledgeBases['game_development']!;
    final results = <Map<String, dynamic>>[];
    
    for (final doc in base) {
      final similarity = _calculateSimilarity(query, doc);
      if (similarity > 0.3) {
        results.add({
          'source': doc,
          'content': 'Relevant content from $doc about $query',
          'similarity': similarity,
        });
      }
    }
    
    results.sort((a, b) => (b['similarity'] as double).compareTo(a['similarity'] as double));
    return results.take(maxResults).toList();
  }

  Future<String> _generateWithContext(String query, List<Map<String, dynamic>> docs) async {
    final context = docs.map((doc) => doc['content']).join('\n\n');
    return 'Based on the retrieved information:\n\n$context\n\nAnswer: This is a comprehensive response based on the available knowledge base documents.';
  }

  double _calculateSimilarity(String query, String document) {
    // Simple similarity calculation (in real implementation, use proper embeddings)
    final queryWords = query.toLowerCase().split(' ');
    final docWords = document.toLowerCase().split(' ');
    final intersection = queryWords.where((word) => docWords.contains(word)).length;
    return intersection / queryWords.length;
  }

  double _calculateConfidence(List<Map<String, dynamic>> docs, double threshold) {
    if (docs.isEmpty) return 0.0;
    
    final avgSimilarity = docs.map((doc) => doc['similarity'] as double).reduce((a, b) => a + b) / docs.length;
    return avgSimilarity > threshold ? avgSimilarity : 0.3;
  }
}

// Tier 4: LLM for Complex Tasks
class LLMLayer implements AILayer {
  @override
  Future<AIResponse> process(UserRequest request, Map<String, dynamic> config) async {
    final startTime = DateTime.now();
    
    try {
      final provider = config['provider'] ?? 'openai';
      final model = config['model'] ?? 'gpt-4';
      final maxTokens = config['maxTokens'] ?? 2048;
      final temperature = config['temperature'] ?? 0.7;
      
      String response = '';
      double confidence = 0.0;
      List<String> sources = [];

      // Creative generation
      if (request.content.contains('create') || request.content.contains('generate')) {
        response = await _generateCreativeContent(request.content, provider, model, temperature);
        confidence = 0.8;
        sources = ['creative_generation'];
      }

      // Complex reasoning
      else if (request.content.contains('solve') || request.content.contains('analyze')) {
        response = await _solveComplexProblem(request.content, provider, model, temperature);
        confidence = 0.7;
        sources = ['complex_reasoning'];
      }

      // Code generation
      else if (request.content.contains('code') || request.content.contains('function')) {
        response = await _generateCode(request.content, provider, model, temperature);
        confidence = 0.6;
        sources = ['code_generation'];
      }

      // Multimodal processing
      else if (request.content.contains('image') || request.content.contains('visual')) {
        response = await _processMultimodal(request.content, provider, model);
        confidence = 0.5;
        sources = ['multimodal_processing'];
      }

      // Default LLM processing
      else {
        response = await _processWithLLM(request.content, provider, model, maxTokens, temperature);
        confidence = 0.4;
        sources = ['llm_${provider}_${model}'];
      }

      final duration = DateTime.now().difference(startTime).inMilliseconds;

      return AIResponse(
        id: request.id,
        content: response,
        approach: AIApproach.llm,
        confidence: confidence,
        cost: 0.15, // Standard LLM cost
        durationMs: duration,
        sources: sources,
        metadata: {
          'provider': provider,
          'model': model,
          'maxTokens': maxTokens,
          'temperature': temperature,
        },
        agentName: 'LLM',
      );
    } catch (e) {
      return AIResponse(
        id: request.id,
        content: 'Error processing with LLM',
        approach: AIApproach.llm,
        confidence: 0.0,
        cost: 0.15,
        durationMs: DateTime.now().difference(startTime).inMilliseconds,
        success: false,
        error: e.toString(),
        agentName: 'LLM',
      );
    }
  }

  @override
  bool canHandle(UserRequest request, RequestAnalysis analysis) {
    // LLM is best for complex and creative tasks
    return analysis.complexity == RequestComplexity.complex ||
           analysis.complexity == RequestComplexity.expert ||
           analysis.domain == 'creative_design';
  }

  @override
  double getConfidence(UserRequest request, RequestAnalysis analysis) {
    // Higher confidence for complex and creative tasks
    if (analysis.complexity == RequestComplexity.expert) return 0.9;
    if (analysis.complexity == RequestComplexity.complex) return 0.8;
    if (analysis.domain == 'creative_design') return 0.7;
    return 0.5;
  }

  Future<String> _generateCreativeContent(String prompt, String provider, String model, double temperature) async {
    // Mock creative generation
    await Future.delayed(Duration(milliseconds: 500 + Random().nextInt(1000)));
    return 'Creative content generated with $provider/$model: $prompt\n\nThis is an innovative and creative response that demonstrates the model\'s creative capabilities.';
  }

  Future<String> _solveComplexProblem(String problem, String provider, String model, double temperature) async {
    // Mock complex problem solving
    await Future.delayed(Duration(milliseconds: 800 + Random().nextInt(1500)));
    return 'Complex problem solved with $provider/$model:\n\nProblem: $problem\n\nSolution: This is a detailed, step-by-step solution that demonstrates advanced reasoning and problem-solving capabilities.';
  }

  Future<String> _generateCode(String requirements, String provider, String model, double temperature) async {
    // Mock code generation
    await Future.delayed(Duration(milliseconds: 600 + Random().nextInt(1200)));
    return 'Code generated with $provider/$model:\n\nRequirements: $requirements\n\n```dart\n// Generated code based on requirements\nvoid main() {\n  print("Hello from generated code!");\n}\n```';
  }

  Future<String> _processMultimodal(String content, String provider, String model) async {
    // Mock multimodal processing
    await Future.delayed(Duration(milliseconds: 1000 + Random().nextInt(2000)));
    return 'Multimodal content processed with $provider/$model:\n\nContent: $content\n\nThis response demonstrates the model\'s ability to process and understand multiple types of content including text, images, and other media.';
  }

  Future<String> _processWithLLM(String content, String provider, String model, int maxTokens, double temperature) async {
    // Mock LLM processing
    await Future.delayed(Duration(milliseconds: 400 + Random().nextInt(800)));
    return 'Processed with $provider/$model (maxTokens: $maxTokens, temp: $temperature):\n\n$content\n\nThis is a comprehensive response generated by the language model based on the input provided.';
  }
}

// Multi-Tier AI Stack
class MultiTierAIStack {
  final IntelligentRouter router;
  final RuleBasedLayer ruleLayer;
  final LocalSLMLayer slmLayer;
  final RAGLayer ragLayer;
  final LLMLayer llmLayer;

  MultiTierAIStack({
    required this.router,
    required this.ruleLayer,
    required this.slmLayer,
    required this.ragLayer,
    required this.llmLayer,
  });

  Future<AIResponse> processRequest(UserRequest request) async {
    // Analyze request
    final analysis = router.analyzeRequest(request);
    
    // Select optimal route
    final route = router.selectOptimalRoute(analysis);
    
    // Process with selected approach
    switch (route.approach) {
      case AIApproach.ruleBased:
        return await ruleLayer.process(request, route.configuration);
      case AIApproach.localSLM:
        return await slmLayer.process(request, route.configuration);
      case AIApproach.rag:
        return await ragLayer.process(request, route.configuration);
      case AIApproach.llm:
        return await llmLayer.process(request, route.configuration);
      case AIApproach.hybrid:
        // Combine multiple approaches
        final responses = await Future.wait([
          ruleLayer.process(request, route.configuration),
          slmLayer.process(request, route.configuration),
          ragLayer.process(request, route.configuration),
        ]);
        
        // Combine responses (simplified)
        final combinedContent = responses.map((r) => r.content).join('\n\n');
        
        return AIResponse(
          id: request.id,
          content: combinedContent,
          approach: AIApproach.hybrid,
          confidence: 0.9,
          cost: 0.1,
          durationMs: 1500,
          sources: responses.expand((r) => r.sources).toSet().toList(),
          metadata: responses.map((r) => r.metadata).reduce((a, b) => {...a, ...b}),
          agentName: 'Hybrid',
          activeAgents: responses.map((r) => r.agentName ?? '').where((n) => n.isNotEmpty).toList(),
        );
    }
  }
} 