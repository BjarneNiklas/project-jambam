import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

// Enhanced AI Triad System for Media Platform
// Optimized for: Community building, competition, teamwork, scalability, user engagement

// Core AI Approach Types
enum AIApproach {
  slm,        // Small Language Model - fast, efficient, specialized
  llm,        // Large Language Model - creative, complex reasoning  
  rag,        // Retrieval-Augmented Generation - knowledge-based
  hybrid,     // Combination of multiple approaches
  ruleBased,  // Rule-based system - deterministic, fast
}

// Request Complexity Levels
enum RequestComplexity {
  simple,     // Basic queries, classification, filtering
  moderate,   // Suggestions, basic analysis, content generation
  complex,    // Creative generation, deep analysis, problem solving
  expert,     // Multi-step reasoning, advanced synthesis
}

// Privacy Levels
enum PrivacyLevel {
  public,     // Can be processed externally
  private,    // Should be processed locally when possible
  sensitive,  // Must be processed locally
  critical,   // Never send to external services
}

// Media-Specific Task Types
enum MediaTaskType {
  // SLM Tasks - Fast & Efficient
  contentClassification,    // Classify media content type
  userIntentDetection,      // Detect user intent from query
  contentModeration,        // Moderate user-generated content
  sentimentAnalysis,        // Analyze sentiment of content
  languageDetection,        // Detect language of content
  entityExtraction,         // Extract entities from text
  
  // LLM Tasks - Creative & Complex
  creativeGeneration,       // Generate creative content
  storyDevelopment,         // Develop storylines and narratives
  characterDesign,          // Design characters and personalities
  gameMechanicsDesign,      // Design game mechanics
  codeGeneration,           // Generate code and scripts
  complexAnalysis,          // Complex reasoning and analysis
  
  // RAG Tasks - Knowledge-Based
  researchQuery,            // Research specific topics
  documentationLookup,      // Look up technical documentation
  bestPracticesRetrieval,   // Retrieve best practices
  communityKnowledge,       // Access community knowledge
  projectContext,           // Get project-specific context
  
  // Hybrid Tasks - Multi-Model
  contentEnhancement,       // Enhance content with multiple models
  comprehensiveAnalysis,    // Comprehensive analysis using multiple approaches
  adaptiveResponse,         // Adaptive response based on context
}

// Enhanced Request Analysis
class RequestAnalysis {
  final RequestComplexity complexity;
  final String domain;
  final PrivacyLevel privacyLevel;
  final double urgency;
  final double costSensitivity;
  final Map<String, dynamic> metadata;
  final List<String> detectedEntities;
  final String detectedLanguage;
  final double sentimentScore;

  const RequestAnalysis({
    required this.complexity,
    required this.domain,
    required this.privacyLevel,
    required this.urgency,
    required this.costSensitivity,
    this.metadata = const {},
    this.detectedEntities = const [],
    this.detectedLanguage = 'en',
    this.sentimentScore = 0.0,
  });

  Map<String, dynamic> toJson() => {
    'complexity': complexity.name,
    'domain': domain,
    'privacyLevel': privacyLevel.name,
    'urgency': urgency,
    'costSensitivity': costSensitivity,
    'metadata': metadata,
    'detectedEntities': detectedEntities,
    'detectedLanguage': detectedLanguage,
    'sentimentScore': sentimentScore,
  };
}

// Enhanced User Request
class UserRequest {
  final String id;
  final String content;
  final MediaTaskType taskType;
  final Map<String, dynamic> context;
  final AIApproach? preferredApproach;
  final RequestAnalysis? analysis;
  final DateTime timestamp;
  final String userId;
  final String sessionId;

  UserRequest({
    required this.id,
    required this.content,
    required this.taskType,
    this.context = const {},
    this.preferredApproach,
    this.analysis,
    required this.userId,
    required this.sessionId,
  }) : timestamp = DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'content': content,
    'taskType': taskType.name,
    'context': context,
    'preferredApproach': preferredApproach?.name,
    'analysis': analysis?.toJson(),
    'timestamp': timestamp.toIso8601String(),
    'userId': userId,
    'sessionId': sessionId,
  };
}

// Enhanced AI Response
class EnhancedAIResponse {
  final String id;
  final String content;
  final AIApproach usedApproach;
  final List<AIApproach> activeApproaches;
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
  final Map<String, dynamic> performanceMetrics;
  final String? fallbackReason;

  EnhancedAIResponse({
    required this.id,
    required this.content,
    required this.usedApproach,
    this.activeApproaches = const [],
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
    this.performanceMetrics = const {},
    this.fallbackReason,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'content': content,
    'usedApproach': usedApproach.name,
    'activeApproaches': activeApproaches.map((a) => a.name).toList(),
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
    'performanceMetrics': performanceMetrics,
    'fallbackReason': fallbackReason,
  };
}

// Enhanced Model Configuration
class EnhancedModelConfig {
  final String modelId;
  final AIApproach approach;
  final String endpoint;
  final Map<String, dynamic> parameters;
  final bool isLocal;
  final int maxTokens;
  final double temperature;
  final List<String> capabilities;
  final double costPerToken;
  final int maxRequestsPerMinute;
  final Map<String, dynamic> performanceMetrics;

  const EnhancedModelConfig({
    required this.modelId,
    required this.approach,
    required this.endpoint,
    this.parameters = const {},
    this.isLocal = false,
    this.maxTokens = 2048,
    this.temperature = 0.7,
    this.capabilities = const [],
    this.costPerToken = 0.0,
    this.maxRequestsPerMinute = 60,
    this.performanceMetrics = const {},
  });

  Map<String, dynamic> toJson() => {
    'modelId': modelId,
    'approach': approach.name,
    'endpoint': endpoint,
    'parameters': parameters,
    'isLocal': isLocal,
    'maxTokens': maxTokens,
    'temperature': temperature,
    'capabilities': capabilities,
    'costPerToken': costPerToken,
    'maxRequestsPerMinute': maxRequestsPerMinute,
    'performanceMetrics': performanceMetrics,
  };
}

// Enhanced RAG System
class EnhancedRAGSystem {
  final String vectorDbEndpoint;
  final String embeddingModel;
  final Map<String, dynamic> config;
  final Map<String, List<Map<String, dynamic>>> knowledgeBases;

  EnhancedRAGSystem({
    required this.vectorDbEndpoint,
    required this.embeddingModel,
    this.config = const {},
    this.knowledgeBases = const {},
  });

  Future<List<Map<String, dynamic>>> retrieveRelevantDocuments(
    String query, {
    String knowledgeBase = 'general',
    int limit = 5,
    double similarityThreshold = 0.7,
    Map<String, dynamic> filters = const {},
  }) async {
    try {
      // Simulate RAG retrieval with enhanced capabilities
      await Future.delayed(const Duration(milliseconds: 100));
      
      final baseDocs = knowledgeBases[knowledgeBase] ?? [];
      final filteredDocs = _applyFilters(baseDocs, filters);
      
      return filteredDocs.take(limit).toList();
    } catch (e) {
      throw Exception('Enhanced RAG retrieval failed: $e');
    }
  }

  List<Map<String, dynamic>> _applyFilters(
    List<Map<String, dynamic>> docs,
    Map<String, dynamic> filters,
  ) {
    if (filters.isEmpty) return docs;
    
    return docs.where((doc) {
      for (final entry in filters.entries) {
        if (doc[entry.key] != entry.value) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  Future<void> addDocument(
    String content,
    Map<String, dynamic> metadata, {
    String knowledgeBase = 'general',
  }) async {
    // Simulate adding document to vector database
    await Future.delayed(const Duration(milliseconds: 50));
  }

  Future<List<double>> getEmbedding(String text) async {
    // Simulate embedding generation
    await Future.delayed(const Duration(milliseconds: 30));
    return List.generate(384, (index) => (index % 100) / 100.0);
  }

  Future<Map<String, dynamic>> getKnowledgeBaseStats() async {
    final stats = <String, int>{};
    for (final entry in knowledgeBases.entries) {
      stats[entry.key] = entry.value.length;
    }
    return stats;
  }
}

// Enhanced Model Registry
class EnhancedModelRegistry {
  static final Map<String, EnhancedModelConfig> _models = {
    // SLM Models - Fast, Efficient, Specialized
    'slm_classifier': EnhancedModelConfig(
      modelId: 'slm_classifier',
      approach: AIApproach.slm,
      endpoint: 'https://api.local/slm/classify',
      isLocal: true,
      maxTokens: 512,
      temperature: 0.1,
      capabilities: ['classification', 'filtering', 'tagging'],
      costPerToken: 0.0001,
      maxRequestsPerMinute: 1000,
    ),
    'slm_moderator': EnhancedModelConfig(
      modelId: 'slm_moderator',
      approach: AIApproach.slm,
      endpoint: 'https://api.local/slm/moderate',
      isLocal: true,
      maxTokens: 256,
      temperature: 0.0,
      capabilities: ['moderation', 'toxicity_detection'],
      costPerToken: 0.0001,
      maxRequestsPerMinute: 1000,
    ),
    'slm_sentiment': EnhancedModelConfig(
      modelId: 'slm_sentiment',
      approach: AIApproach.slm,
      endpoint: 'https://api.local/slm/sentiment',
      isLocal: true,
      maxTokens: 128,
      temperature: 0.0,
      capabilities: ['sentiment_analysis', 'emotion_detection'],
      costPerToken: 0.0001,
      maxRequestsPerMinute: 1000,
    ),
    'slm_entities': EnhancedModelConfig(
      modelId: 'slm_entities',
      approach: AIApproach.slm,
      endpoint: 'https://api.local/slm/entities',
      isLocal: true,
      maxTokens: 256,
      temperature: 0.0,
      capabilities: ['entity_extraction', 'named_entity_recognition'],
      costPerToken: 0.0001,
      maxRequestsPerMinute: 1000,
    ),

    // LLM Models - Creative, Complex Reasoning
    'llm_creative': EnhancedModelConfig(
      modelId: 'llm_creative',
      approach: AIApproach.llm,
      endpoint: 'https://api.openai.com/v1/chat/completions',
      maxTokens: 4096,
      temperature: 0.8,
      capabilities: ['generation', 'creative_writing', 'game_design'],
      costPerToken: 0.03,
      maxRequestsPerMinute: 60,
    ),
    'llm_analysis': EnhancedModelConfig(
      modelId: 'llm_analysis',
      approach: AIApproach.llm,
      endpoint: 'https://api.anthropic.com/v1/messages',
      maxTokens: 8192,
      temperature: 0.2,
      capabilities: ['analysis', 'reasoning', 'insights'],
      costPerToken: 0.015,
      maxRequestsPerMinute: 60,
    ),
    'llm_code': EnhancedModelConfig(
      modelId: 'llm_code',
      approach: AIApproach.llm,
      endpoint: 'https://api.openai.com/v1/chat/completions',
      maxTokens: 4096,
      temperature: 0.1,
      capabilities: ['code_generation', 'code_review', 'debugging'],
      costPerToken: 0.03,
      maxRequestsPerMinute: 60,
    ),

    // RAG Models - Knowledge-Based
    'rag_research': EnhancedModelConfig(
      modelId: 'rag_research',
      approach: AIApproach.rag,
      endpoint: 'https://api.local/rag/research',
      maxTokens: 2048,
      temperature: 0.3,
      capabilities: ['research', 'knowledge_retrieval'],
      costPerToken: 0.001,
      maxRequestsPerMinute: 200,
    ),
    'rag_project': EnhancedModelConfig(
      modelId: 'rag_project',
      approach: AIApproach.rag,
      endpoint: 'https://api.local/rag/project',
      maxTokens: 2048,
      temperature: 0.2,
      capabilities: ['project_knowledge', 'context_awareness'],
      costPerToken: 0.001,
      maxRequestsPerMinute: 200,
    ),
    'rag_community': EnhancedModelConfig(
      modelId: 'rag_community',
      approach: AIApproach.rag,
      endpoint: 'https://api.local/rag/community',
      maxTokens: 2048,
      temperature: 0.3,
      capabilities: ['community_knowledge', 'user_generated_content'],
      costPerToken: 0.001,
      maxRequestsPerMinute: 200,
    ),
  };

  static EnhancedModelConfig? getModel(String modelId) => _models[modelId];
  
  static List<EnhancedModelConfig> getModelsByApproach(AIApproach approach) {
    return _models.values.where((model) => model.approach == approach).toList();
  }
  
  static List<EnhancedModelConfig> getModelsByCapability(String capability) {
    return _models.values
        .where((model) => model.capabilities.contains(capability))
        .toList();
  }

  static void registerModel(EnhancedModelConfig config) {
    _models[config.modelId] = config;
  }

  static Map<String, dynamic> getRegistryStats() {
    final stats = <String, dynamic>{};
    for (final approach in AIApproach.values) {
      final models = getModelsByApproach(approach);
      stats[approach.name] = {
        'count': models.length,
        'models': models.map((m) => m.modelId).toList(),
      };
    }
    return stats;
  }
}

// Enhanced AI Triad Orchestrator
class EnhancedAITriadOrchestrator {
  final EnhancedRAGSystem _ragSystem;
  final Map<String, dynamic> _cache = {};
  final StreamController<EnhancedAIResponse> _responseStream = StreamController.broadcast();
  final Map<String, dynamic> _performanceMetrics = {};
  final Map<String, int> _requestCounts = {};

  EnhancedAITriadOrchestrator({required EnhancedRAGSystem ragSystem}) 
      : _ragSystem = ragSystem;

  Stream<EnhancedAIResponse> get responseStream => _responseStream.stream;

  // Main orchestration method with enhanced routing
  Future<EnhancedAIResponse> processRequest(UserRequest request) async {
    final startTime = DateTime.now();
    
    try {
      // 1. Analyze request if not provided
      final analysis = request.analysis ?? await _analyzeRequest(request);
      
      // 2. Select optimal approach based on analysis
      final approach = _selectOptimalApproach(request, analysis);
      
      // 3. Get appropriate model for the approach
      final model = _selectModelForApproach(approach, request, analysis);
      
      // 4. Enhance context with RAG if beneficial
      final enhancedContext = await _enhanceContext(request, model, analysis);
      
      // 5. Process with selected model
      final response = await _processWithModel(request, model, enhancedContext, startTime);
      
      // 6. Post-process and validate
      final finalResponse = await _postProcessResponse(response, request, analysis);
      
      // 7. Update metrics and cache
      _updateMetrics(request, finalResponse, startTime);
      _cache[request.id] = finalResponse;
      _responseStream.add(finalResponse);
      
      return finalResponse;
    } catch (e) {
      final errorResponse = EnhancedAIResponse(
        id: request.id,
        content: '',
        usedApproach: AIApproach.slm,
        confidence: 0.0,
        cost: 0.0,
        durationMs: DateTime.now().difference(startTime).inMilliseconds,
        success: false,
        error: e.toString(),
        agentName: 'Orchestrator',
      );
      _responseStream.add(errorResponse);
      return errorResponse;
    }
  }

  // Enhanced request analysis
  Future<RequestAnalysis> _analyzeRequest(UserRequest request) async {
    // Use SLM for fast analysis
    final slmModel = EnhancedModelRegistry.getModel('slm_classifier')!;
    
    // Analyze complexity, domain, privacy needs, etc.
    final complexity = _analyzeComplexity(request.content);
    final domain = _detectDomain(request.content);
    final privacyLevel = _assessPrivacyNeeds(request);
    final urgency = _assessUrgency(request);
    final costSensitivity = _assessCostSensitivity(request);
    
    return RequestAnalysis(
      complexity: complexity,
      domain: domain,
      privacyLevel: privacyLevel,
      urgency: urgency,
      costSensitivity: costSensitivity,
      metadata: {
        'taskType': request.taskType.name,
        'userId': request.userId,
        'sessionId': request.sessionId,
      },
    );
  }

  RequestComplexity _analyzeComplexity(String content) {
    final wordCount = content.split(' ').length;
    final hasComplexKeywords = content.toLowerCase().contains(RegExp(
      r'\b(analyze|design|create|develop|implement|optimize|integrate|architect)\b'
    ));
    
    if (wordCount < 10 && !hasComplexKeywords) return RequestComplexity.simple;
    if (wordCount < 50 && !hasComplexKeywords) return RequestComplexity.moderate;
    if (wordCount < 200) return RequestComplexity.complex;
    return RequestComplexity.expert;
  }

  String _detectDomain(String content) {
    final lowerContent = content.toLowerCase();
    
    if (lowerContent.contains('game') || lowerContent.contains('unity') || 
        lowerContent.contains('unreal') || lowerContent.contains('sprite')) {
      return 'game_development';
    }
    if (lowerContent.contains('art') || lowerContent.contains('design') || 
        lowerContent.contains('visual') || lowerContent.contains('creative')) {
      return 'creative_design';
    }
    if (lowerContent.contains('code') || lowerContent.contains('programming') || 
        lowerContent.contains('script') || lowerContent.contains('api')) {
      return 'technical';
    }
    if (lowerContent.contains('community') || lowerContent.contains('user') || 
        lowerContent.contains('social') || lowerContent.contains('collaboration')) {
      return 'community';
    }
    
    return 'general';
  }

  PrivacyLevel _assessPrivacyNeeds(UserRequest request) {
    // Assess based on content and user preferences
    if (request.content.toLowerCase().contains('private') || 
        request.content.toLowerCase().contains('personal')) {
      return PrivacyLevel.private;
    }
    if (request.content.toLowerCase().contains('sensitive') || 
        request.content.toLowerCase().contains('confidential')) {
      return PrivacyLevel.sensitive;
    }
    return PrivacyLevel.public;
  }

  double _assessUrgency(UserRequest request) {
    // Assess urgency based on content and context
    if (request.content.toLowerCase().contains('urgent') || 
        request.content.toLowerCase().contains('asap') ||
        request.content.toLowerCase().contains('emergency')) {
      return 0.9;
    }
    if (request.content.toLowerCase().contains('quick') || 
        request.content.toLowerCase().contains('fast')) {
      return 0.7;
    }
    return 0.3;
  }

  double _assessCostSensitivity(UserRequest request) {
    // Assess cost sensitivity based on user tier and request type
    // This could be enhanced with user subscription data
    return 0.5; // Default moderate sensitivity
  }

  // Enhanced approach selection
  AIApproach _selectOptimalApproach(UserRequest request, RequestAnalysis analysis) {
    // Use preferred approach if specified
    if (request.preferredApproach != null) {
      return request.preferredApproach!;
    }

    // Select based on analysis
    if (analysis.privacyLevel == PrivacyLevel.critical) {
      return AIApproach.slm; // Must use local processing
    }
    
    if (analysis.complexity == RequestComplexity.simple && 
        analysis.domain != 'research') {
      return AIApproach.slm; // Fast, efficient processing
    }
    
    if (analysis.domain == 'research' || 
        request.taskType == MediaTaskType.researchQuery) {
      return AIApproach.rag; // Knowledge-based retrieval
    }
    
    if (analysis.complexity == RequestComplexity.expert || 
        request.taskType == MediaTaskType.creativeGeneration) {
      return AIApproach.llm; // Creative, complex reasoning
    }
    
    if (analysis.complexity == RequestComplexity.complex) {
      return AIApproach.hybrid; // Multi-model approach
    }
    
    return AIApproach.slm; // Default to SLM for efficiency
  }

  // Enhanced model selection
  EnhancedModelConfig _selectModelForApproach(
    AIApproach approach,
    UserRequest request,
    RequestAnalysis analysis,
  ) {
    final availableModels = EnhancedModelRegistry.getModelsByApproach(approach);
    
    if (availableModels.isEmpty) {
      throw Exception('No models available for approach: ${approach.name}');
    }
    
    // Select based on capabilities and constraints
    for (final model in availableModels) {
      if (_canHandleTask(model, request.taskType) && 
          _meetsPrivacyRequirements(model, analysis.privacyLevel)) {
        return model;
      }
    }
    
    // Fallback to first available model
    return availableModels.first;
  }

  bool _canHandleTask(EnhancedModelConfig model, MediaTaskType taskType) {
    switch (taskType) {
      case MediaTaskType.contentClassification:
      case MediaTaskType.contentModeration:
        return model.capabilities.contains('classification') || 
               model.capabilities.contains('moderation');
      case MediaTaskType.sentimentAnalysis:
        return model.capabilities.contains('sentiment_analysis');
      case MediaTaskType.entityExtraction:
        return model.capabilities.contains('entity_extraction');
      case MediaTaskType.creativeGeneration:
        return model.capabilities.contains('generation') || 
               model.capabilities.contains('creative_writing');
      case MediaTaskType.codeGeneration:
        return model.capabilities.contains('code_generation');
      case MediaTaskType.researchQuery:
        return model.capabilities.contains('research') || 
               model.capabilities.contains('knowledge_retrieval');
      default:
        return true; // Default to allowing any model
    }
  }

  bool _meetsPrivacyRequirements(EnhancedModelConfig model, PrivacyLevel privacyLevel) {
    if (privacyLevel == PrivacyLevel.critical) {
      return model.isLocal;
    }
    if (privacyLevel == PrivacyLevel.sensitive) {
      return model.isLocal || model.approach == AIApproach.rag;
    }
    return true; // Public and private can use any model
  }

  // Enhanced context enhancement
  Future<Map<String, dynamic>> _enhanceContext(
    UserRequest request,
    EnhancedModelConfig model,
    RequestAnalysis analysis,
  ) async {
    final enhancedContext = Map<String, dynamic>.from(request.context);
    
    // Add RAG context for LLM and RAG models
    if (model.approach == AIApproach.llm || model.approach == AIApproach.rag) {
      try {
        final relevantDocs = await _ragSystem.retrieveRelevantDocuments(
          request.content,
          knowledgeBase: analysis.domain,
          limit: 3,
        );
        
        if (relevantDocs.isNotEmpty) {
          enhancedContext['rag_context'] = relevantDocs;
          enhancedContext['knowledge_sources'] = relevantDocs
              .map((doc) => doc['source'])
              .toList();
        }
      } catch (e) {
        print('RAG enhancement failed: $e');
      }
    }
    
    // Add analysis context
    enhancedContext['analysis'] = analysis.toJson();
    enhancedContext['user_id'] = request.userId;
    enhancedContext['session_id'] = request.sessionId;
    
    return enhancedContext;
  }

  // Enhanced model processing
  Future<EnhancedAIResponse> _processWithModel(
    UserRequest request,
    EnhancedModelConfig model,
    Map<String, dynamic> context,
    DateTime startTime,
  ) async {
    switch (model.approach) {
      case AIApproach.slm:
        return await _processWithSLM(request, model, context, startTime);
      case AIApproach.llm:
        return await _processWithLLM(request, model, context, startTime);
      case AIApproach.rag:
        return await _processWithRAG(request, model, context, startTime);
      case AIApproach.hybrid:
        return await _processWithHybrid(request, model, context, startTime);
      case AIApproach.ruleBased:
        return await _processWithRuleBased(request, model, context, startTime);
    }
  }

  // Enhanced SLM Processing
  Future<EnhancedAIResponse> _processWithSLM(
    UserRequest request,
    EnhancedModelConfig model,
    Map<String, dynamic> context,
    DateTime startTime,
  ) async {
    try {
      // Simulate SLM processing with enhanced capabilities
      await Future.delayed(const Duration(milliseconds: 50));
      
      String content = '';
      double confidence = 0.9;
      List<String> sources = ['slm_${model.modelId}'];
      
      switch (request.taskType) {
        case MediaTaskType.contentClassification:
          content = _classifyContent(request.content);
          break;
        case MediaTaskType.contentModeration:
          content = _moderateContent(request.content);
          break;
        case MediaTaskType.sentimentAnalysis:
          content = _analyzeSentiment(request.content);
          break;
        case MediaTaskType.entityExtraction:
          content = _extractEntities(request.content);
          break;
        default:
          content = 'SLM processed: ${request.content}';
      }
      
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      final cost = _calculateCost(model, content.length);
      
      return EnhancedAIResponse(
        id: request.id,
        content: content,
        usedApproach: AIApproach.slm,
        activeApproaches: [AIApproach.slm],
        confidence: confidence,
        cost: cost,
        durationMs: duration,
        sources: sources,
        agentName: model.modelId,
        activeAgents: [model.modelId],
        performanceMetrics: {
          'modelId': model.modelId,
          'approach': model.approach.name,
          'isLocal': model.isLocal,
        },
      );
    } catch (e) {
      return _createErrorResponse(request, model, startTime, e.toString());
    }
  }

  // Enhanced LLM Processing
  Future<EnhancedAIResponse> _processWithLLM(
    UserRequest request,
    EnhancedModelConfig model,
    Map<String, dynamic> context,
    DateTime startTime,
  ) async {
    try {
      // Simulate LLM API call with enhanced capabilities
      await Future.delayed(const Duration(milliseconds: 2000));
      
      String content = '';
      List<String> sources = ['llm_${model.modelId}'];
      
      // Use RAG context if available
      if (context.containsKey('rag_context')) {
        final ragDocs = context['rag_context'] as List;
        sources.addAll(ragDocs.map((doc) => doc['source'].toString()));
        content = 'LLM response with RAG context: ${request.content}\n\nBased on: ${sources.join(', ')}';
      } else {
        content = 'LLM creative response: ${request.content}';
      }
      
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      final cost = _calculateCost(model, content.length);
      
      return EnhancedAIResponse(
        id: request.id,
        content: content,
        usedApproach: AIApproach.llm,
        activeApproaches: [AIApproach.llm],
        confidence: 0.85,
        cost: cost,
        durationMs: duration,
        sources: sources,
        agentName: model.modelId,
        activeAgents: [model.modelId],
        performanceMetrics: {
          'modelId': model.modelId,
          'approach': model.approach.name,
          'hasRagContext': context.containsKey('rag_context'),
        },
      );
    } catch (e) {
      return _createErrorResponse(request, model, startTime, e.toString());
    }
  }

  // Enhanced RAG Processing
  Future<EnhancedAIResponse> _processWithRAG(
    UserRequest request,
    EnhancedModelConfig model,
    Map<String, dynamic> context,
    DateTime startTime,
  ) async {
    try {
      // Retrieve relevant documents
      final documents = await _ragSystem.retrieveRelevantDocuments(request.content);
      
      if (documents.isEmpty) {
        return EnhancedAIResponse(
          id: request.id,
          content: 'No relevant information found for: ${request.content}',
          usedApproach: AIApproach.rag,
          activeApproaches: [AIApproach.rag],
          confidence: 0.0,
          cost: _calculateCost(model, 0),
          durationMs: DateTime.now().difference(startTime).inMilliseconds,
          success: false,
          error: 'No relevant documents found',
          agentName: model.modelId,
          activeAgents: [model.modelId],
        );
      }
      
      // Generate response based on retrieved documents
      final sources = documents.map((doc) => doc['source'].toString()).toList();
      final content = 'RAG response based on ${documents.length} sources:\n\n' +
          documents.map((doc) => '- ${doc['content']}').join('\n');
      
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      final cost = _calculateCost(model, content.length);
      
      return EnhancedAIResponse(
        id: request.id,
        content: content,
        usedApproach: AIApproach.rag,
        activeApproaches: [AIApproach.rag],
        confidence: 0.9,
        cost: cost,
        durationMs: duration,
        sources: sources,
        agentName: model.modelId,
        activeAgents: [model.modelId],
        performanceMetrics: {
          'modelId': model.modelId,
          'approach': model.approach.name,
          'documentsRetrieved': documents.length,
        },
      );
    } catch (e) {
      return _createErrorResponse(request, model, startTime, e.toString());
    }
  }

  // Enhanced Hybrid Processing
  Future<EnhancedAIResponse> _processWithHybrid(
    UserRequest request,
    EnhancedModelConfig model,
    Map<String, dynamic> context,
    DateTime startTime,
  ) async {
    try {
      final activeAgents = <String>[];
      final failedAgents = <String>[];
      final allSources = <String>[];
      double totalCost = 0.0;
      
      // Use SLM for initial classification
      final slmModel = EnhancedModelRegistry.getModel('slm_classifier')!;
      final slmResponse = await _processWithSLM(
        UserRequest(
          id: '${request.id}_slm',
          content: request.content,
          taskType: MediaTaskType.contentClassification,
          userId: request.userId,
          sessionId: request.sessionId,
        ),
        slmModel,
        context,
        startTime,
      );
      
      if (slmResponse.success) {
        activeAgents.add(slmModel.modelId);
        allSources.addAll(slmResponse.sources);
        totalCost += slmResponse.cost;
      } else {
        failedAgents.add(slmModel.modelId);
      }
      
      // Use LLM for detailed analysis
      final llmModel = EnhancedModelRegistry.getModel('llm_analysis')!;
      final llmResponse = await _processWithLLM(
        UserRequest(
          id: '${request.id}_llm',
          content: '${request.content}\n\nSLM Classification: ${slmResponse.content}',
          taskType: MediaTaskType.complexAnalysis,
          userId: request.userId,
          sessionId: request.sessionId,
        ),
        llmModel,
        context,
        startTime,
      );
      
      if (llmResponse.success) {
        activeAgents.add(llmModel.modelId);
        allSources.addAll(llmResponse.sources);
        totalCost += llmResponse.cost;
      } else {
        failedAgents.add(llmModel.modelId);
      }
      
      // Combine responses
      final combinedContent = '''
SLM Classification: ${slmResponse.content}

LLM Analysis: ${llmResponse.content}
''';
      
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      final confidence = (slmResponse.confidence + llmResponse.confidence) / 2;
      
      return EnhancedAIResponse(
        id: request.id,
        content: combinedContent,
        usedApproach: AIApproach.hybrid,
        activeApproaches: [AIApproach.slm, AIApproach.llm],
        confidence: confidence,
        cost: totalCost,
        durationMs: duration,
        sources: allSources,
        agentName: 'Hybrid',
        activeAgents: activeAgents,
        failedAgents: failedAgents,
        performanceMetrics: {
          'slmModel': slmModel.modelId,
          'llmModel': llmModel.modelId,
          'slmSuccess': slmResponse.success,
          'llmSuccess': llmResponse.success,
        },
      );
    } catch (e) {
      return _createErrorResponse(request, model, startTime, e.toString());
    }
  }

  // Enhanced Rule-Based Processing
  Future<EnhancedAIResponse> _processWithRuleBased(
    UserRequest request,
    EnhancedModelConfig model,
    Map<String, dynamic> context,
    DateTime startTime,
  ) async {
    try {
      // Simulate rule-based processing
      await Future.delayed(const Duration(milliseconds: 10));
      
      String content = '';
      double confidence = 0.8;
      
      // Apply rule-based logic
      if (request.content.toLowerCase().contains('what is')) {
        content = 'Rule-based answer for: ${request.content}';
      } else if (request.content.toLowerCase().contains('how to')) {
        content = 'Rule-based instructions for: ${request.content}';
      } else {
        content = 'Rule-based response: ${request.content}';
      }
      
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      
      return EnhancedAIResponse(
        id: request.id,
        content: content,
        usedApproach: AIApproach.ruleBased,
        activeApproaches: [AIApproach.ruleBased],
        confidence: confidence,
        cost: 0.0,
        durationMs: duration,
        sources: ['rule_based'],
        agentName: 'Rule-Based',
        activeAgents: ['rule_based'],
        performanceMetrics: {
          'approach': 'rule_based',
          'isLocal': true,
        },
      );
    } catch (e) {
      return _createErrorResponse(request, model, startTime, e.toString());
    }
  }

  // Helper methods
  String _classifyContent(String content) {
    final lowerContent = content.toLowerCase();
    if (lowerContent.contains('game') || lowerContent.contains('play')) {
      return 'GAME_DEVELOPMENT';
    } else if (lowerContent.contains('art') || lowerContent.contains('design')) {
      return 'CREATIVE_DESIGN';
    } else if (lowerContent.contains('code') || lowerContent.contains('programming')) {
      return 'TECHNICAL';
    } else if (lowerContent.contains('community') || lowerContent.contains('social')) {
      return 'COMMUNITY';
    } else {
      return 'GENERAL';
    }
  }

  String _moderateContent(String content) {
    final lowerContent = content.toLowerCase();
    final inappropriateWords = ['hate', 'violence', 'spam', 'inappropriate'];
    
    for (final word in inappropriateWords) {
      if (lowerContent.contains(word)) {
        return 'inappropriate';
      }
    }
    return 'appropriate';
  }

  String _analyzeSentiment(String content) {
    final positiveWords = ['good', 'great', 'excellent', 'amazing', 'love', 'like'];
    final negativeWords = ['bad', 'terrible', 'awful', 'hate', 'dislike', 'poor'];
    
    final lowerContent = content.toLowerCase();
    int positiveCount = 0;
    int negativeCount = 0;
    
    for (final word in positiveWords) {
      if (lowerContent.contains(word)) positiveCount++;
    }
    for (final word in negativeWords) {
      if (lowerContent.contains(word)) negativeCount++;
    }
    
    if (positiveCount > negativeCount) return 'positive';
    if (negativeCount > positiveCount) return 'negative';
    return 'neutral';
  }

  String _extractEntities(String content) {
    final entities = <String>[];
    final words = content.split(' ');
    
    for (final word in words) {
      if (word.length > 3 && word[0] == word[0].toUpperCase()) {
        entities.add(word);
      }
    }
    
    return entities.join(', ');
  }

  double _calculateCost(EnhancedModelConfig model, int tokenCount) {
    return model.costPerToken * tokenCount;
  }

  EnhancedAIResponse _createErrorResponse(
    UserRequest request,
    EnhancedModelConfig model,
    DateTime startTime,
    String error,
  ) {
    return EnhancedAIResponse(
      id: request.id,
      content: '',
      usedApproach: model.approach,
      confidence: 0.0,
      cost: 0.0,
      durationMs: DateTime.now().difference(startTime).inMilliseconds,
      success: false,
      error: error,
      agentName: model.modelId,
      failedAgents: [model.modelId],
    );
  }

  // Post-processing and validation
  Future<EnhancedAIResponse> _postProcessResponse(
    EnhancedAIResponse response,
    UserRequest request,
    RequestAnalysis analysis,
  ) async {
    if (!response.success) return response;
    
    // Apply content filtering if needed
    if (request.taskType == MediaTaskType.creativeGeneration) {
      final filterResponse = await _processWithSLM(
        UserRequest(
          id: '${request.id}_filter',
          content: response.content,
          taskType: MediaTaskType.contentModeration,
          userId: request.userId,
          sessionId: request.sessionId,
        ),
        EnhancedModelRegistry.getModel('slm_moderator')!,
        {},
        DateTime.now(),
      );
      
      if (filterResponse.content.contains('inappropriate')) {
        return EnhancedAIResponse(
          id: response.id,
          content: 'Content filtered for inappropriate content',
          usedApproach: response.usedApproach,
          confidence: 0.0,
          cost: response.cost,
          durationMs: response.durationMs,
          success: false,
          error: 'Content moderation failed',
          agentName: response.agentName,
          fallbackReason: 'content_moderation',
        );
      }
    }
    
    return response;
  }

  // Performance tracking
  void _updateMetrics(
    UserRequest request,
    EnhancedAIResponse response,
    DateTime startTime,
  ) {
    final modelId = response.agentName ?? 'unknown';
    _requestCounts[modelId] = (_requestCounts[modelId] ?? 0) + 1;
    
    _performanceMetrics[modelId] = {
      'totalRequests': _requestCounts[modelId],
      'successRate': response.success ? 1.0 : 0.0,
      'averageCost': response.cost,
      'averageDuration': response.durationMs,
      'lastUpdated': DateTime.now().toIso8601String(),
    };
  }

  // Utility methods
  void dispose() {
    _responseStream.close();
  }

  Map<String, dynamic> getPerformanceMetrics() => Map.from(_performanceMetrics);
  
  Map<String, int> getRequestCounts() => Map.from(_requestCounts);

  Future<void> addToKnowledgeBase(
    String content,
    Map<String, dynamic> metadata, {
    String knowledgeBase = 'general',
  }) async {
    await _ragSystem.addDocument(content, metadata, knowledgeBase: knowledgeBase);
  }

  EnhancedAIResponse? getCachedResponse(String requestId) {
    return _cache[requestId];
  }

  void clearCache() {
    _cache.clear();
  }

  Future<Map<String, dynamic>> getSystemStats() async {
    return {
      'performanceMetrics': getPerformanceMetrics(),
      'requestCounts': getRequestCounts(),
      'modelRegistry': EnhancedModelRegistry.getRegistryStats(),
      'knowledgeBaseStats': await _ragSystem.getKnowledgeBaseStats(),
      'cacheSize': _cache.length,
    };
  }
} 