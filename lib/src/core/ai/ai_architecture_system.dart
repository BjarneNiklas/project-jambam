import 'dart:async';
import 'package:flutter/foundation.dart';

// Core AI Architecture Types
enum AIModelType {
  slm,    // Small Language Model - fast, efficient, specialized
  llm,    // Large Language Model - creative, complex reasoning
  rag,    // Retrieval-Augmented Generation - knowledge-based
  hybrid, // Combination of multiple models
}

enum AITaskType {
  classification,    // SLM - fast categorization
  generation,        // LLM - creative content
  retrieval,         // RAG - knowledge lookup
  filtering,         // SLM - content moderation
  suggestion,        // SLM/LLM - recommendations
  analysis,          // LLM+RAG - complex insights
  orchestration,     // Hybrid - workflow management
}

// AI Model Configuration
class AIModelConfig {
  final String modelId;
  final AIModelType type;
  final String endpoint;
  final Map<String, dynamic> parameters;
  final bool isLocal;
  final int maxTokens;
  final double temperature;
  final List<String> capabilities;

  const AIModelConfig({
    required this.modelId,
    required this.type,
    required this.endpoint,
    this.parameters = const {},
    this.isLocal = false,
    this.maxTokens = 2048,
    this.temperature = 0.7,
    this.capabilities = const [],
  });

  Map<String, dynamic> toJson() => {
    'modelId': modelId,
    'type': type.name,
    'endpoint': endpoint,
    'parameters': parameters,
    'isLocal': isLocal,
    'maxTokens': maxTokens,
    'temperature': temperature,
    'capabilities': capabilities,
  };

  factory AIModelConfig.fromJson(Map<String, dynamic> json) => AIModelConfig(
    modelId: json['modelId'],
    type: AIModelType.values.firstWhere((e) => e.name == json['type']),
    endpoint: json['endpoint'],
    parameters: Map<String, dynamic>.from(json['parameters'] ?? {}),
    isLocal: json['isLocal'] ?? false,
    maxTokens: json['maxTokens'] ?? 2048,
    temperature: (json['temperature'] ?? 0.7).toDouble(),
    capabilities: List<String>.from(json['capabilities'] ?? []),
  );
}

// AI Request/Response
class AIRequest {
  final String id;
  final AITaskType taskType;
  final String prompt;
  final Map<String, dynamic> context;
  final AIModelConfig? preferredModel;
  final Map<String, dynamic> parameters;
  final DateTime timestamp;

  AIRequest({
    required this.id,
    required this.taskType,
    required this.prompt,
    this.context = const {},
    this.preferredModel,
    this.parameters = const {},
  }) : timestamp = DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'taskType': taskType.name,
    'prompt': prompt,
    'context': context,
    'preferredModel': preferredModel?.toJson(),
    'parameters': parameters,
    'timestamp': timestamp.toIso8601String(),
  };
}

class AIResponse {
  final String id;
  final String content;
  final AIModelConfig usedModel;
  final Map<String, dynamic> metadata;
  final double confidence;
  final List<String> sources;
  final DateTime timestamp;
  final bool isSuccess;
  final String? error;

  AIResponse({
    required this.id,
    required this.content,
    required this.usedModel,
    this.metadata = const {},
    this.confidence = 1.0,
    this.sources = const [],
    required this.isSuccess,
    this.error,
  }) : timestamp = DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'content': content,
    'usedModel': usedModel.toJson(),
    'metadata': metadata,
    'confidence': confidence,
    'sources': sources,
    'timestamp': timestamp.toIso8601String(),
    'isSuccess': isSuccess,
    'error': error,
  };
}

// RAG System
class RAGSystem {
  final String vectorDbEndpoint;
  final String embeddingModel;
  final Map<String, dynamic> config;

  RAGSystem({
    required this.vectorDbEndpoint,
    required this.embeddingModel,
    this.config = const {},
  });

  Future<List<Map<String, dynamic>>> retrieveRelevantDocuments(
    String query, {
    int limit = 5,
    double similarityThreshold = 0.7,
  }) async {
    try {
      // Simulate RAG retrieval
      await Future.delayed(const Duration(milliseconds: 100));
      
      return [
        {
          'id': 'doc_1',
          'content': 'Relevant document content for: $query',
          'source': 'project_docs',
          'similarity': 0.85,
          'metadata': {'type': 'documentation', 'category': 'game_design'},
        },
        {
          'id': 'doc_2',
          'content': 'Another relevant piece for: $query',
          'source': 'community_posts',
          'similarity': 0.78,
          'metadata': {'type': 'community', 'category': 'feedback'},
        },
      ];
    } catch (e) {
      throw Exception('RAG retrieval failed: $e');
    }
  }

  Future<void> addDocument(String content, Map<String, dynamic> metadata) async {
    // Simulate adding document to vector database
    await Future.delayed(const Duration(milliseconds: 50));
  }

  Future<List<double>> getEmbedding(String text) async {
    // Simulate embedding generation
    await Future.delayed(const Duration(milliseconds: 30));
    return List.generate(384, (index) => (index % 100) / 100.0);
  }
}

// AI Model Registry
class AIModelRegistry {
  static final Map<String, AIModelConfig> _models = {
    // SLM Models - Fast, Efficient, Specialized
    'slm_classifier': AIModelConfig(
      modelId: 'slm_classifier',
      type: AIModelType.slm,
      endpoint: 'https://api.local/slm/classify',
      isLocal: true,
      maxTokens: 512,
      temperature: 0.1,
      capabilities: ['classification', 'filtering', 'tagging'],
    ),
    'slm_moderator': AIModelConfig(
      modelId: 'slm_moderator',
      type: AIModelType.slm,
      endpoint: 'https://api.local/slm/moderate',
      isLocal: true,
      maxTokens: 256,
      temperature: 0.0,
      capabilities: ['moderation', 'toxicity_detection'],
    ),
    'slm_suggestions': AIModelConfig(
      modelId: 'slm_suggestions',
      type: AIModelType.slm,
      endpoint: 'https://api.local/slm/suggest',
      isLocal: true,
      maxTokens: 1024,
      temperature: 0.3,
      capabilities: ['suggestions', 'autocomplete'],
    ),

    // LLM Models - Creative, Complex Reasoning
    'llm_creative': AIModelConfig(
      modelId: 'llm_creative',
      type: AIModelType.llm,
      endpoint: 'https://api.openai.com/v1/chat/completions',
      maxTokens: 4096,
      temperature: 0.8,
      capabilities: ['generation', 'creative_writing', 'game_design'],
    ),
    'llm_analysis': AIModelConfig(
      modelId: 'llm_analysis',
      type: AIModelType.llm,
      endpoint: 'https://api.anthropic.com/v1/messages',
      maxTokens: 8192,
      temperature: 0.2,
      capabilities: ['analysis', 'reasoning', 'insights'],
    ),

    // RAG Models - Knowledge-Based
    'rag_research': AIModelConfig(
      modelId: 'rag_research',
      type: AIModelType.rag,
      endpoint: 'https://api.local/rag/research',
      maxTokens: 2048,
      temperature: 0.3,
      capabilities: ['research', 'knowledge_retrieval'],
    ),
    'rag_project': AIModelConfig(
      modelId: 'rag_project',
      type: AIModelType.rag,
      endpoint: 'https://api.local/rag/project',
      maxTokens: 2048,
      temperature: 0.2,
      capabilities: ['project_knowledge', 'context_awareness'],
    ),
  };

  static AIModelConfig? getModel(String modelId) => _models[modelId];
  
  static List<AIModelConfig> getModelsByType(AIModelType type) {
    return _models.values.where((model) => model.type == type).toList();
  }
  
  static List<AIModelConfig> getModelsByCapability(String capability) {
    return _models.values
        .where((model) => model.capabilities.contains(capability))
        .toList();
  }

  static void registerModel(AIModelConfig config) {
    _models[config.modelId] = config;
  }
}

// AI Orchestrator - Main System
class AIOrchestrator {
  final RAGSystem _ragSystem;
  final Map<String, dynamic> _cache = {};
  final StreamController<AIResponse> _responseStream = StreamController.broadcast();

  AIOrchestrator({required RAGSystem ragSystem}) : _ragSystem = ragSystem;

  Stream<AIResponse> get responseStream => _responseStream.stream;

  // Main orchestration method
  Future<AIResponse> processRequest(AIRequest request) async {
    try {
      // 1. Determine optimal model based on task type
      final modelConfig = _selectOptimalModel(request);
      final model = modelConfig;
      
      // 2. Enhance context with RAG if needed
      final enhancedContext = await _enhanceContext(request, model);
      
      // 3. Process with selected model
      final response = await _processWithModel(request, model, enhancedContext);
      
      // 4. Post-process and validate
      final finalResponse = await _postProcessResponse(response, request);
      
      // 5. Cache and stream result
      _cache[request.id] = finalResponse;
      _responseStream.add(finalResponse);
      
      return finalResponse;
    } catch (e) {
      final errorResponse = AIResponse(
        id: request.id,
        content: '',
        usedModel: request.preferredModel ?? AIModelRegistry.getModel('slm_classifier')!,
        isSuccess: false,
        error: e.toString(),
      );
      _responseStream.add(errorResponse);
      return errorResponse;
    }
  }

  // Model selection logic
  AIModelConfig _selectOptimalModel(AIRequest request) {
    // Use preferred model if specified
    if (request.preferredModel != null) {
      return request.preferredModel!;
    }

    // Select based on task type
    switch (request.taskType) {
      case AITaskType.classification:
      case AITaskType.filtering:
        return AIModelRegistry.getModel('slm_classifier')!;
      
      case AITaskType.suggestion:
        return AIModelRegistry.getModel('slm_suggestions')!;
      
      case AITaskType.generation:
        return AIModelRegistry.getModel('llm_creative')!;
      
      case AITaskType.analysis:
        return AIModelRegistry.getModel('llm_analysis')!;
      
      case AITaskType.retrieval:
        return AIModelRegistry.getModel('rag_research')!;
      
      case AITaskType.orchestration:
        // Use hybrid approach for complex orchestration
        return AIModelRegistry.getModel('llm_analysis')!;
    }
  }

  // Context enhancement with RAG
  Future<Map<String, dynamic>> _enhanceContext(
    AIRequest request, 
    AIModelConfig model,
  ) async {
    final enhancedContext = Map<String, dynamic>.from(request.context);
    
    // Add RAG context for LLM and RAG models
    if (model.type == AIModelType.llm || model.type == AIModelType.rag) {
      try {
        final relevantDocs = await _ragSystem.retrieveRelevantDocuments(
          request.prompt,
          limit: 3,
        );
        
        if (relevantDocs.isNotEmpty) {
          enhancedContext['rag_context'] = relevantDocs;
          enhancedContext['knowledge_sources'] = relevantDocs
              .map((doc) => doc['source'])
              .toList();
        }
      } catch (e) {
        // Continue without RAG if it fails
        debugPrint('RAG enhancement failed: $e');
      }
    }
    
    return enhancedContext;
  }

  // Process with specific model
  Future<AIResponse> _processWithModel(
    AIRequest request,
    AIModelConfig model,
    Map<String, dynamic> context,
  ) async {
    switch (model.type) {
      case AIModelType.slm:
        return await _processWithSLM(request, model, context);
      
      case AIModelType.llm:
        return await _processWithLLM(request, model, context);
      
      case AIModelType.rag:
        return await _processWithRAG(request, model, context);
      
      case AIModelType.hybrid:
        return await _processWithHybrid(request, model, context);
    }
  }

  // SLM Processing - Fast, Efficient
  Future<AIResponse> _processWithSLM(
    AIRequest request,
    AIModelConfig model,
    Map<String, dynamic> context,
  ) async {
    try {
      // Simulate SLM processing
      await Future.delayed(const Duration(milliseconds: 50));
      
      String content = '';
      double confidence = 0.9;
      
      switch (request.taskType) {
        case AITaskType.classification:
          content = _classifyContent(request.prompt);
          break;
        case AITaskType.filtering:
          content = _filterContent(request.prompt);
          break;
        case AITaskType.suggestion:
          content = _generateSuggestions(request.prompt);
          break;
        default:
          content = 'SLM processed: ${request.prompt}';
      }
      
      return AIResponse(
        id: request.id,
        content: content,
        usedModel: model,
        confidence: confidence,
        isSuccess: true,
      );
    } catch (e) {
      return AIResponse(
        id: request.id,
        content: '',
        usedModel: model,
        isSuccess: false,
        error: e.toString(),
      );
    }
  }

  // LLM Processing - Creative, Complex
  Future<AIResponse> _processWithLLM(
    AIRequest request,
    AIModelConfig model,
    Map<String, dynamic> context,
  ) async {
    try {
      // Simulate LLM API call
      await Future.delayed(const Duration(milliseconds: 2000));
      
      String content = '';
      List<String> sources = [];
      
      // Use RAG context if available
      if (context.containsKey('rag_context')) {
        final ragDocs = context['rag_context'] as List;
        sources = ragDocs.map((doc) => doc['source'].toString()).toList();
        content = 'LLM response with RAG context: ${request.prompt}\n\nBased on: ${sources.join(', ')}';
      } else {
        content = 'LLM creative response: ${request.prompt}';
      }
      
      return AIResponse(
        id: request.id,
        content: content,
        usedModel: model,
        confidence: 0.85,
        sources: sources,
        isSuccess: true,
      );
    } catch (e) {
      return AIResponse(
        id: request.id,
        content: '',
        usedModel: model,
        isSuccess: false,
        error: e.toString(),
      );
    }
  }

  // RAG Processing - Knowledge-Based
  Future<AIResponse> _processWithRAG(
    AIRequest request,
    AIModelConfig model,
    Map<String, dynamic> context,
  ) async {
    try {
      // Retrieve relevant documents
      final documents = await _ragSystem.retrieveRelevantDocuments(request.prompt);
      
      if (documents.isEmpty) {
        return AIResponse(
          id: request.id,
          content: 'No relevant information found for: ${request.prompt}',
          usedModel: model,
          confidence: 0.0,
          isSuccess: true,
        );
      }
      
      // Generate response based on retrieved documents
      final sources = documents.map((doc) => doc['source'].toString()).toList();
      final content = 'RAG response based on ${documents.length} sources:\n\n${documents.map((doc) => '- ${doc['content']}').join('\n')}';
      
      return AIResponse(
        id: request.id,
        content: content,
        usedModel: model,
        confidence: 0.9,
        sources: sources,
        isSuccess: true,
      );
    } catch (e) {
      return AIResponse(
        id: request.id,
        content: '',
        usedModel: model,
        isSuccess: false,
        error: e.toString(),
      );
    }
  }

  // Hybrid Processing - Multiple Models
  Future<AIResponse> _processWithHybrid(
    AIRequest request,
    AIModelConfig model,
    Map<String, dynamic> context,
  ) async {
    try {
      // Use SLM for initial classification
      final slmResponse = await _processWithSLM(
        AIRequest(
          id: '${request.id}_slm',
          taskType: AITaskType.classification,
          prompt: request.prompt,
        ),
        AIModelRegistry.getModel('slm_classifier')!,
        context,
      );
      
      // Use LLM for detailed analysis
      final llmResponse = await _processWithLLM(
        AIRequest(
          id: '${request.id}_llm',
          taskType: AITaskType.analysis,
          prompt: '${request.prompt}\n\nSLM Classification: ${slmResponse.content}',
        ),
        AIModelRegistry.getModel('llm_analysis')!,
        context,
      );
      
      // Combine responses
      final combinedContent = '''
SLM Classification: ${slmResponse.content}

LLM Analysis: ${llmResponse.content}
''';
      
      return AIResponse(
        id: request.id,
        content: combinedContent,
        usedModel: model,
        confidence: (slmResponse.confidence + llmResponse.confidence) / 2,
        sources: llmResponse.sources,
        isSuccess: true,
      );
    } catch (e) {
      return AIResponse(
        id: request.id,
        content: '',
        usedModel: model,
        isSuccess: false,
        error: e.toString(),
      );
    }
  }

  // Post-processing and validation
  Future<AIResponse> _postProcessResponse(
    AIResponse response,
    AIRequest request,
  ) async {
    if (!response.isSuccess) return response;
    
    // Apply content filtering if needed
    if (request.taskType == AITaskType.generation) {
      final filterResponse = await _processWithSLM(
        AIRequest(
          id: '${request.id}_filter',
          taskType: AITaskType.filtering,
          prompt: response.content,
        ),
        AIModelRegistry.getModel('slm_moderator')!,
        {},
      );
      
      if (filterResponse.content.contains('inappropriate')) {
        return AIResponse(
          id: response.id,
          content: 'Content filtered for inappropriate content',
          usedModel: response.usedModel,
          confidence: 0.0,
          isSuccess: false,
          error: 'Content moderation failed',
        );
      }
    }
    
    return response;
  }

  // Helper methods for SLM processing
  String _classifyContent(String prompt) {
    final lowerPrompt = prompt.toLowerCase();
    if (lowerPrompt.contains('game') || lowerPrompt.contains('play')) {
      return 'GAME_DEVELOPMENT';
    } else if (lowerPrompt.contains('art') || lowerPrompt.contains('design')) {
      return 'CREATIVE_DESIGN';
    } else if (lowerPrompt.contains('code') || lowerPrompt.contains('programming')) {
      return 'TECHNICAL';
    } else {
      return 'GENERAL';
    }
  }

  String _filterContent(String prompt) {
    final lowerPrompt = prompt.toLowerCase();
    final inappropriateWords = ['hate', 'violence', 'spam'];
    
    for (final word in inappropriateWords) {
      if (lowerPrompt.contains(word)) {
        return 'inappropriate';
      }
    }
    return 'appropriate';
  }

  String _generateSuggestions(String prompt) {
    final suggestions = [
      'Try adding more visual elements',
      'Consider user feedback',
      'Test with different audiences',
      'Iterate on the core mechanic',
    ];
    return suggestions.join('\n');
  }

  // Utility methods
  void dispose() {
    _responseStream.close();
  }

  Future<void> addToKnowledgeBase(String content, Map<String, dynamic> metadata) async {
    await _ragSystem.addDocument(content, metadata);
  }

  AIResponse? getCachedResponse(String requestId) {
    return _cache[requestId];
  }

  void clearCache() {
    _cache.clear();
  }
} 