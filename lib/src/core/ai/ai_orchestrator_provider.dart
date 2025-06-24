import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ai_architecture_system.dart';

// Core AI Orchestrator Provider
final aiOrchestratorProvider = Provider<AIOrchestrator>((ref) {
  final ragSystem = RAGSystem(
    vectorDbEndpoint: 'https://api.local/vector-db',
    embeddingModel: 'text-embedding-ada-002',
  );
  return AIOrchestrator(ragSystem: ragSystem);
});

// RAG System Provider
final ragSystemProvider = Provider<RAGSystem>((ref) {
  return RAGSystem(
    vectorDbEndpoint: 'https://api.local/vector-db',
    embeddingModel: 'text-embedding-ada-002',
  );
});

// AI Model Registry Provider
final aiModelRegistryProvider = Provider<AIModelRegistry>((ref) {
  return AIModelRegistry();
});

// Stream of AI Responses
final aiResponseStreamProvider = StreamProvider<AIResponse>((ref) {
  final orchestrator = ref.watch(aiOrchestratorProvider);
  return orchestrator.responseStream;
});

// AI Request State Notifier
class AIRequestNotifier extends StateNotifier<AsyncValue<AIResponse?>> {
  final AIOrchestrator _orchestrator;

  AIRequestNotifier(this._orchestrator) : super(const AsyncValue.data(null));

  Future<void> processRequest(AIRequest request) async {
    state = const AsyncValue.loading();
    
    try {
      final response = await _orchestrator.processRequest(request);
      state = AsyncValue.data(response);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void clearResponse() {
    state = const AsyncValue.data(null);
  }
}

final aiRequestProvider = StateNotifierProvider<AIRequestNotifier, AsyncValue<AIResponse?>>((ref) {
  final orchestrator = ref.watch(aiOrchestratorProvider);
  return AIRequestNotifier(orchestrator);
});

// AI Service Provider - High-level interface
class AIService {
  final AIOrchestrator _orchestrator;
  final RAGSystem _ragSystem;

  AIService(this._orchestrator, this._ragSystem);

  // Quick classification with SLM
  Future<String> classifyContent(String content) async {
    final request = AIRequest(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      taskType: AITaskType.classification,
      prompt: content,
    );
    
    final response = await _orchestrator.processRequest(request);
    return response.content;
  }

  // Content filtering with SLM
  Future<bool> isContentAppropriate(String content) async {
    final request = AIRequest(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      taskType: AITaskType.filtering,
      prompt: content,
    );
    
    final response = await _orchestrator.processRequest(request);
    return response.content == 'appropriate';
  }

  // Creative generation with LLM
  Future<String> generateCreativeContent(String prompt, {Map<String, dynamic>? context}) async {
    final request = AIRequest(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      taskType: AITaskType.generation,
      prompt: prompt,
      context: context ?? {},
    );
    
    final response = await _orchestrator.processRequest(request);
    return response.content;
  }

  // Knowledge retrieval with RAG
  Future<String> retrieveKnowledge(String query) async {
    final request = AIRequest(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      taskType: AITaskType.retrieval,
      prompt: query,
    );
    
    final response = await _orchestrator.processRequest(request);
    return response.content;
  }

  // Complex analysis with LLM + RAG
  Future<String> analyzeComplex(String prompt, {Map<String, dynamic>? context}) async {
    final request = AIRequest(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      taskType: AITaskType.analysis,
      prompt: prompt,
      context: context ?? {},
    );
    
    final response = await _orchestrator.processRequest(request);
    return response.content;
  }

  // Suggestions with SLM
  Future<List<String>> getSuggestions(String context) async {
    final request = AIRequest(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      taskType: AITaskType.suggestion,
      prompt: context,
    );
    
    final response = await _orchestrator.processRequest(request);
    return response.content.split('\n').where((s) => s.isNotEmpty).toList();
  }

  // Add to knowledge base
  Future<void> addToKnowledgeBase(String content, Map<String, dynamic> metadata) async {
    await _ragSystem.addDocument(content, metadata);
  }

  // Get cached response
  AIResponse? getCachedResponse(String requestId) {
    return _orchestrator.getCachedResponse(requestId);
  }

  // Clear cache
  void clearCache() {
    _orchestrator.clearCache();
  }
}

final aiServiceProvider = Provider<AIService>((ref) {
  final orchestrator = ref.watch(aiOrchestratorProvider);
  final ragSystem = ref.watch(ragSystemProvider);
  return AIService(orchestrator, ragSystem);
});

// Specialized AI Services for different domains
class ContentFilterAIService {
  final AIService _aiService;

  ContentFilterAIService(this._aiService);

  Future<bool> isContentAppropriate(String content) async {
    return await _aiService.isContentAppropriate(content);
  }

  Future<String> classifyContent(String content) async {
    return await _aiService.classifyContent(content);
  }

  Future<List<String>> getContentSuggestions(String context) async {
    return await _aiService.getSuggestions(context);
  }
}

final contentFilterAIServiceProvider = Provider<ContentFilterAIService>((ref) {
  final aiService = ref.watch(aiServiceProvider);
  return ContentFilterAIService(aiService);
});

class CreativeAIService {
  final AIService _aiService;

  CreativeAIService(this._aiService);

  Future<String> generateGameIdea(String theme) async {
    return await _aiService.generateCreativeContent(
      'Generate a unique game idea based on the theme: $theme',
      context: {'type': 'game_idea', 'theme': theme},
    );
  }

  Future<String> generateStory(String context) async {
    return await _aiService.generateCreativeContent(
      'Generate a compelling story based on: $context',
      context: {'type': 'story', 'context': context},
    );
  }

  Future<String> generateCharacter(String description) async {
    return await _aiService.generateCreativeContent(
      'Generate a character description for: $description',
      context: {'type': 'character', 'description': description},
    );
  }
}

final creativeAIServiceProvider = Provider<CreativeAIService>((ref) {
  final aiService = ref.watch(aiServiceProvider);
  return CreativeAIService(aiService);
});

class ResearchAIService {
  final AIService _aiService;

  ResearchAIService(this._aiService);

  Future<String> researchTopic(String topic) async {
    return await _aiService.retrieveKnowledge(topic);
  }

  Future<String> analyzeResearch(String researchData) async {
    return await _aiService.analyzeComplex(
      'Analyze this research data and provide insights: $researchData',
      context: {'type': 'research_analysis'},
    );
  }

  Future<void> addResearchToKnowledgeBase(String content, String source) async {
    await _aiService.addToKnowledgeBase(content, {
      'type': 'research',
      'source': source,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
}

final researchAIServiceProvider = Provider<ResearchAIService>((ref) {
  final aiService = ref.watch(aiServiceProvider);
  return ResearchAIService(aiService);
});

class ProjectAIService {
  final AIService _aiService;

  ProjectAIService(this._aiService);

  Future<String> analyzeProjectStatus(String projectData) async {
    return await _aiService.analyzeComplex(
      'Analyze this project status and provide recommendations: $projectData',
      context: {'type': 'project_analysis'},
    );
  }

  Future<String> generateProjectInsights(String projectContext) async {
    return await _aiService.generateCreativeContent(
      'Generate insights and next steps for this project: $projectContext',
      context: {'type': 'project_insights'},
    );
  }

  Future<void> addProjectToKnowledgeBase(String content, String projectId) async {
    await _aiService.addToKnowledgeBase(content, {
      'type': 'project',
      'projectId': projectId,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
}

final projectAIServiceProvider = Provider<ProjectAIService>((ref) {
  final aiService = ref.watch(aiServiceProvider);
  return ProjectAIService(aiService);
});

// AI Performance Monitoring
class AIPerformanceMetrics {
  final Map<String, int> _requestCounts = {};
  final Map<String, double> _averageResponseTimes = {};
  final Map<String, int> _errorCounts = {};

  void recordRequest(AITaskType taskType, Duration responseTime, bool isSuccess) {
    final taskName = taskType.name;
    
    _requestCounts[taskName] = (_requestCounts[taskName] ?? 0) + 1;
    
    final currentAvg = _averageResponseTimes[taskName] ?? 0.0;
    final currentCount = _requestCounts[taskName] ?? 1;
    _averageResponseTimes[taskName] = (currentAvg * (currentCount - 1) + responseTime.inMilliseconds) / currentCount;
    
    if (!isSuccess) {
      _errorCounts[taskName] = (_errorCounts[taskName] ?? 0) + 1;
    }
  }

  Map<String, dynamic> getMetrics() {
    return {
      'requestCounts': Map<String, int>.from(_requestCounts),
      'averageResponseTimes': Map<String, double>.from(_averageResponseTimes),
      'errorCounts': Map<String, int>.from(_errorCounts),
      'successRates': _requestCounts.map((task, count) => MapEntry(
        task, 
        ((count - (_errorCounts[task] ?? 0)) / count * 100).toStringAsFixed(1)
      )),
    };
  }

  void reset() {
    _requestCounts.clear();
    _averageResponseTimes.clear();
    _errorCounts.clear();
  }
}

final aiPerformanceMetricsProvider = StateNotifierProvider<AIPerformanceNotifier, AIPerformanceMetrics>((ref) {
  return AIPerformanceNotifier();
});

class AIPerformanceNotifier extends StateNotifier<AIPerformanceMetrics> {
  AIPerformanceNotifier() : super(AIPerformanceMetrics());

  void recordRequest(AITaskType taskType, Duration responseTime, bool isSuccess) {
    state.recordRequest(taskType, responseTime, isSuccess);
    state = state; // Trigger rebuild
  }

  void reset() {
    state.reset();
    state = state; // Trigger rebuild
  }
} 