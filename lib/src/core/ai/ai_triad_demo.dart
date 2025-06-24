import 'dart:async';
import 'enhanced_ai_triad_system.dart';
import 'media_platform_ai_service.dart';

// AI Triad Demo - Practical Implementation Examples
// Shows how SLM + LLM + RAG work together in the media platform

class AITriadDemo {
  late final EnhancedAITriadOrchestrator _orchestrator;
  late final MediaPlatformAIService _mediaService;
  final StreamController<DemoEvent> _demoStream = StreamController.broadcast();

  AITriadDemo() {
    _initializeServices();
  }

  Stream<DemoEvent> get demoStream => _demoStream.stream;

  void _initializeServices() {
    // Initialize RAG system with German/European knowledge base
    final ragSystem = EnhancedRAGSystem(
      vectorDbEndpoint: 'https://api.local/vector-db',
      embeddingModel: 'sentence-transformers/all-MiniLM-L6-v2',
      knowledgeBases: {
        'game_development': [
          {
            'id': 'doc_1',
            'content': 'Unity ist eine beliebte Game Engine für 2D und 3D Spieleentwicklung.',
            'source': 'unity_docs_de',
            'similarity': 0.9,
            'metadata': {'type': 'documentation', 'language': 'de', 'category': 'game_engine'},
          },
          {
            'id': 'doc_2',
            'content': 'Game Jams sind Events wo Entwickler in kurzer Zeit Spiele erstellen.',
            'source': 'game_jam_guide_de',
            'similarity': 0.85,
            'metadata': {'type': 'guide', 'language': 'de', 'category': 'community'},
          },
        ],
        'community_building': [
          {
            'id': 'doc_3',
            'content': 'Erfolgreiche Communities brauchen klare Regeln und aktive Moderation.',
            'source': 'community_guide_de',
            'similarity': 0.88,
            'metadata': {'type': 'guide', 'language': 'de', 'category': 'community'},
          },
        ],
        'content_creation': [
          {
            'id': 'doc_4',
            'content': 'Gute Content-Erstellung folgt dem AIDA-Prinzip: Attention, Interest, Desire, Action.',
            'source': 'content_marketing_de',
            'similarity': 0.92,
            'metadata': {'type': 'marketing', 'language': 'de', 'category': 'content'},
          },
        ],
      },
    );

    // Initialize orchestrator
    _orchestrator = EnhancedAITriadOrchestrator(ragSystem: ragSystem);
    
    // Initialize media service
    _mediaService = MediaPlatformAIService(orchestrator: _orchestrator);
  }

  // 🎯 Demo 1: Content Recommendation (SLM + RAG + LLM)
  Future<void> demoContentRecommendation() async {
    _demoStream.add(DemoEvent(
      type: DemoEventType.started,
      title: 'Content Recommendation Demo',
      description: 'SLM classifies user intent → RAG retrieves relevant content → LLM generates personalized recommendations',
    ));

    try {
      // Simulate user query
      const userQuery = 'Ich suche nach Unity Tutorials für Anfänger';
      const userId = 'user_123';

      _demoStream.add(DemoEvent(
        type: DemoEventType.step,
        title: 'Step 1: SLM Classification',
        description: 'Classifying user intent and content type...',
        data: {'query': userQuery},
      ));

      // SLM processes the query (fast, local)
      final slmRequest = UserRequest(
        id: 'demo_slm_1',
        content: userQuery,
        taskType: MediaTaskType.contentClassification,
        userId: userId,
        sessionId: 'demo_session',
      );

      final slmResponse = await _orchestrator.processRequest(slmRequest);

      _demoStream.add(DemoEvent(
        type: DemoEventType.step,
        title: 'SLM Result',
        description: 'Intent classified as: ${slmResponse.content}',
        data: {
          'approach': slmResponse.usedApproach.name,
          'confidence': slmResponse.confidence,
          'duration': '${slmResponse.durationMs}ms',
          'cost': '\$${slmResponse.cost.toStringAsFixed(4)}',
        },
      ));

      _demoStream.add(DemoEvent(
        type: DemoEventType.step,
        title: 'Step 2: RAG Knowledge Retrieval',
        description: 'Retrieving relevant content from knowledge base...',
      ));

      // RAG retrieves relevant knowledge
      final ragRequest = UserRequest(
        id: 'demo_rag_1',
        content: 'Unity tutorials for beginners',
        taskType: MediaTaskType.researchQuery,
        userId: userId,
        sessionId: 'demo_session',
        context: {'knowledgeBase': 'game_development'},
      );

      final ragResponse = await _orchestrator.processRequest(ragRequest);

      _demoStream.add(DemoEvent(
        type: DemoEventType.step,
        title: 'RAG Result',
        description: 'Retrieved ${ragResponse.sources.length} relevant sources',
        data: {
          'approach': ragResponse.usedApproach.name,
          'confidence': ragResponse.confidence,
          'duration': '${ragResponse.durationMs}ms',
          'cost': '\$${ragResponse.cost.toStringAsFixed(4)}',
          'sources': ragResponse.sources,
        },
      ));

      _demoStream.add(DemoEvent(
        type: DemoEventType.step,
        title: 'Step 3: LLM Personalization',
        description: 'Generating personalized recommendations...',
      ));

      // LLM generates personalized recommendations
      final llmRequest = UserRequest(
        id: 'demo_llm_1',
        content: '''
Generate personalized Unity tutorial recommendations for a German beginner:

User Query: $userQuery
SLM Classification: ${slmResponse.content}
RAG Context: ${ragResponse.content}

User Profile: German speaker, beginner level, interested in game development
''',
        taskType: MediaTaskType.creativeGeneration,
        userId: userId,
        sessionId: 'demo_session',
      );

      final llmResponse = await _orchestrator.processRequest(llmRequest);

      _demoStream.add(DemoEvent(
        type: DemoEventType.step,
        title: 'LLM Result',
        description: 'Generated personalized recommendations',
        data: {
          'approach': llmResponse.usedApproach.name,
          'confidence': llmResponse.confidence,
          'duration': '${llmResponse.durationMs}ms',
          'cost': '\$${llmResponse.cost.toStringAsFixed(4)}',
          'content': llmResponse.content,
        },
      ));

      _demoStream.add(DemoEvent(
        type: DemoEventType.completed,
        title: 'Content Recommendation Complete',
        description: 'Successfully generated personalized recommendations using SLM + RAG + LLM triad',
        data: {
          'totalCost': '\$${(slmResponse.cost + ragResponse.cost + llmResponse.cost).toStringAsFixed(4)}',
          'totalDuration': '${slmResponse.durationMs + ragResponse.durationMs + llmResponse.durationMs}ms',
          'approaches': [slmResponse.usedApproach.name, ragResponse.usedApproach.name, llmResponse.usedApproach.name],
        },
      ));

    } catch (e) {
      _demoStream.add(DemoEvent(
        type: DemoEventType.error,
        title: 'Demo Error',
        description: 'Error during content recommendation demo: $e',
      ));
    }
  }

  // 🎯 Demo 2: Community Moderation (SLM + LLM)
  Future<void> demoCommunityModeration() async {
    _demoStream.add(DemoEvent(
      type: DemoEventType.started,
      title: 'Community Moderation Demo',
      description: 'SLM for fast content filtering → LLM for detailed analysis when needed',
    ));

    try {
      // Test case 1: Appropriate content
      const appropriateMessage = 'Hallo! Ich habe ein tolles Unity Tutorial gefunden.';
      const userId = 'user_456';

      _demoStream.add(DemoEvent(
        type: DemoEventType.step,
        title: 'Testing Appropriate Content',
        description: 'Message: "$appropriateMessage"',
      ));

      final moderationResponse = await _mediaService.moderateContent(
        userId: userId,
        content: appropriateMessage,
      );

      _demoStream.add(DemoEvent(
        type: DemoEventType.step,
        title: 'SLM Moderation Result',
        description: 'Content ${moderationResponse.isAppropriate ? 'approved' : 'flagged'}',
        data: {
          'isAppropriate': moderationResponse.isAppropriate,
          'reason': moderationResponse.reason,
          'approach': moderationResponse.approach,
          'requiresReview': moderationResponse.requiresReview,
        },
      ));

      // Test case 2: Potentially inappropriate content
      const inappropriateMessage = 'Das ist ein schrecklicher Beitrag, ich hasse es!';
      
      _demoStream.add(DemoEvent(
        type: DemoEventType.step,
        title: 'Testing Potentially Inappropriate Content',
        description: 'Message: "$inappropriateMessage"',
      ));

      final inappropriateResponse = await _mediaService.moderateContent(
        userId: userId,
        content: inappropriateMessage,
      );

      _demoStream.add(DemoEvent(
        type: DemoEventType.step,
        title: 'SLM + LLM Moderation Result',
        description: 'Content ${inappropriateResponse.isAppropriate ? 'approved' : 'flagged'}',
        data: {
          'isAppropriate': inappropriateResponse.isAppropriate,
          'reason': inappropriateResponse.reason,
          'approach': inappropriateResponse.approach,
          'requiresReview': inappropriateResponse.requiresReview,
        },
      ));

      _demoStream.add(DemoEvent(
        type: DemoEventType.completed,
        title: 'Community Moderation Complete',
        description: 'Successfully demonstrated two-tier moderation system',
        data: {
          'appropriateContent': 'SLM only (fast, cheap)',
          'inappropriateContent': 'SLM + LLM (detailed analysis)',
        },
      ));

    } catch (e) {
      _demoStream.add(DemoEvent(
        type: DemoEventType.error,
        title: 'Demo Error',
        description: 'Error during community moderation demo: $e',
      ));
    }
  }

  // 🎯 Demo 3: Content Creation Assistant (RAG + LLM)
  Future<void> demoContentCreation() async {
    _demoStream.add(DemoEvent(
      type: DemoEventType.started,
      title: 'Content Creation Assistant Demo',
      description: 'RAG retrieves best practices → LLM generates creative content',
    ));

    try {
      const contentBrief = 'Erstelle einen Blog-Post über Game Development Trends 2024';
      const userId = 'user_789';

      _demoStream.add(DemoEvent(
        type: DemoEventType.step,
        title: 'Content Creation Request',
        description: 'Brief: "$contentBrief"',
      ));

      final creationResponse = await _mediaService.assistContentCreation(
        userId: userId,
        contentBrief: contentBrief,
        contentType: 'article',
      );

      _demoStream.add(DemoEvent(
        type: DemoEventType.step,
        title: 'RAG Best Practices',
        description: 'Retrieved content creation best practices',
        data: {
          'bestPractices': creationResponse.bestPractices,
          'approach': creationResponse.approach,
        },
      ));

      _demoStream.add(DemoEvent(
        type: DemoEventType.step,
        title: 'LLM Generated Content',
        description: 'Generated creative content based on best practices',
        data: {
          'content': creationResponse.content,
          'contentType': creationResponse.contentType,
          'confidence': creationResponse.confidence,
        },
      ));

      _demoStream.add(DemoEvent(
        type: DemoEventType.completed,
        title: 'Content Creation Complete',
        description: 'Successfully generated content using RAG + LLM',
        data: {
          'approach': creationResponse.approach,
          'contentType': creationResponse.contentType,
        },
      ));

    } catch (e) {
      _demoStream.add(DemoEvent(
        type: DemoEventType.error,
        title: 'Demo Error',
        description: 'Error during content creation demo: $e',
      ));
    }
  }

  // 🎯 Demo 4: German Market Localization (SLM + RAG + LLM)
  Future<void> demoGermanLocalization() async {
    _demoStream.add(DemoEvent(
      type: DemoEventType.started,
      title: 'German Market Localization Demo',
      description: 'SLM detects language → RAG gets cultural context → LLM localizes content',
    ));

    try {
      const englishContent = 'Welcome to our amazing game development platform! Join our community and start creating today.';
      const userId = 'user_101';

      _demoStream.add(DemoEvent(
        type: DemoEventType.step,
        title: 'Original Content',
        description: 'English content to localize',
        data: {'content': englishContent},
      ));

      final localizationResponse = await _mediaService.localizeForGermanMarket(
        userId: userId,
        content: englishContent,
        targetLanguage: 'de',
      );

      _demoStream.add(DemoEvent(
        type: DemoEventType.step,
        title: 'SLM Language Detection',
        description: 'Detected original language',
        data: {
          'originalLanguage': localizationResponse.originalLanguage,
        },
      ));

      _demoStream.add(DemoEvent(
        type: DemoEventType.step,
        title: 'RAG Cultural Context',
        description: 'Retrieved German market cultural context',
        data: {
          'culturalContext': localizationResponse.culturalContext,
        },
      ));

      _demoStream.add(DemoEvent(
        type: DemoEventType.step,
        title: 'LLM Localized Content',
        description: 'Generated German-localized content',
        data: {
          'localizedContent': localizationResponse.localizedContent,
          'targetLanguage': localizationResponse.targetLanguage,
          'confidence': localizationResponse.confidence,
        },
      ));

      _demoStream.add(DemoEvent(
        type: DemoEventType.completed,
        title: 'Localization Complete',
        description: 'Successfully localized content for German market',
        data: {
          'approach': localizationResponse.approach,
          'targetLanguage': localizationResponse.targetLanguage,
        },
      ));

    } catch (e) {
      _demoStream.add(DemoEvent(
        type: DemoEventType.error,
        title: 'Demo Error',
        description: 'Error during localization demo: $e',
      ));
    }
  }

  // 🎯 Demo 5: Performance Comparison
  Future<void> demoPerformanceComparison() async {
    _demoStream.add(DemoEvent(
      type: DemoEventType.started,
      title: 'Performance Comparison Demo',
      description: 'Comparing SLM vs LLM vs RAG performance for different tasks',
    ));

    try {
      const testQuery = 'Was ist Unity?';
      const userId = 'user_perf';

      // Test SLM performance
      _demoStream.add(DemoEvent(
        type: DemoEventType.step,
        title: 'Testing SLM Performance',
        description: 'Fast, local processing',
      ));

      final slmStart = DateTime.now();
      final slmResponse = await _orchestrator.processRequest(UserRequest(
        id: 'perf_slm',
        content: testQuery,
        taskType: MediaTaskType.contentClassification,
        userId: userId,
        sessionId: 'perf_test',
      ));
      final slmDuration = DateTime.now().difference(slmStart);

      _demoStream.add(DemoEvent(
        type: DemoEventType.step,
        title: 'SLM Results',
        description: 'Fast classification completed',
        data: {
          'duration': '${slmDuration.inMilliseconds}ms',
          'cost': '\$${slmResponse.cost.toStringAsFixed(4)}',
          'confidence': slmResponse.confidence,
          'approach': slmResponse.usedApproach.name,
        },
      ));

      // Test RAG performance
      _demoStream.add(DemoEvent(
        type: DemoEventType.step,
        title: 'Testing RAG Performance',
        description: 'Knowledge retrieval',
      ));

      final ragStart = DateTime.now();
      final ragResponse = await _orchestrator.processRequest(UserRequest(
        id: 'perf_rag',
        content: testQuery,
        taskType: MediaTaskType.researchQuery,
        userId: userId,
        sessionId: 'perf_test',
      ));
      final ragDuration = DateTime.now().difference(ragStart);

      _demoStream.add(DemoEvent(
        type: DemoEventType.step,
        title: 'RAG Results',
        description: 'Knowledge retrieval completed',
        data: {
          'duration': '${ragDuration.inMilliseconds}ms',
          'cost': '\$${ragResponse.cost.toStringAsFixed(4)}',
          'confidence': ragResponse.confidence,
          'approach': ragResponse.usedApproach.name,
          'sources': ragResponse.sources.length,
        },
      ));

      // Test LLM performance
      _demoStream.add(DemoEvent(
        type: DemoEventType.step,
        title: 'Testing LLM Performance',
        description: 'Creative generation',
      ));

      final llmStart = DateTime.now();
      final llmResponse = await _orchestrator.processRequest(UserRequest(
        id: 'perf_llm',
        content: testQuery,
        taskType: MediaTaskType.creativeGeneration,
        userId: userId,
        sessionId: 'perf_test',
      ));
      final llmDuration = DateTime.now().difference(llmStart);

      _demoStream.add(DemoEvent(
        type: DemoEventType.step,
        title: 'LLM Results',
        description: 'Creative generation completed',
        data: {
          'duration': '${llmDuration.inMilliseconds}ms',
          'cost': '\$${llmResponse.cost.toStringAsFixed(4)}',
          'confidence': llmResponse.confidence,
          'approach': llmResponse.usedApproach.name,
        },
      ));

      // Performance summary
      _demoStream.add(DemoEvent(
        type: DemoEventType.completed,
        title: 'Performance Comparison Complete',
        description: 'Performance comparison results',
        data: {
          'slm': {
            'duration': '${slmDuration.inMilliseconds}ms',
            'cost': '\$${slmResponse.cost.toStringAsFixed(4)}',
            'approach': 'Fast, local, cheap',
          },
          'rag': {
            'duration': '${ragDuration.inMilliseconds}ms',
            'cost': '\$${ragResponse.cost.toStringAsFixed(4)}',
            'approach': 'Knowledge-based, medium cost',
          },
          'llm': {
            'duration': '${llmDuration.inMilliseconds}ms',
            'cost': '\$${llmResponse.cost.toStringAsFixed(4)}',
            'approach': 'Creative, powerful, expensive',
          },
          'recommendation': 'Use SLM for simple tasks, RAG for knowledge, LLM for creativity',
        },
      ));

    } catch (e) {
      _demoStream.add(DemoEvent(
        type: DemoEventType.error,
        title: 'Demo Error',
        description: 'Error during performance comparison: $e',
      ));
    }
  }

  // 🎯 Demo 6: Hybrid Approach (SLM + RAG + LLM)
  Future<void> demoHybridApproach() async {
    _demoStream.add(DemoEvent(
      type: DemoEventType.started,
      title: 'Hybrid Approach Demo',
      description: 'Combining all three approaches for complex tasks',
    ));

    try {
      const complexQuery = 'Ich möchte ein 2D Platformer Spiel in Unity erstellen, aber ich bin Anfänger. Kannst du mir helfen?';
      const userId = 'user_hybrid';

      _demoStream.add(DemoEvent(
        type: DemoEventType.step,
        title: 'Complex User Query',
        description: 'Query requiring multiple AI approaches',
        data: {'query': complexQuery},
      ));

      // Step 1: SLM for intent classification
      _demoStream.add(DemoEvent(
        type: DemoEventType.step,
        title: 'Step 1: SLM Intent Classification',
        description: 'Classifying user intent and skill level',
      ));

      final slmResponse = await _orchestrator.processRequest(UserRequest(
        id: 'hybrid_slm',
        content: complexQuery,
        taskType: MediaTaskType.contentClassification,
        userId: userId,
        sessionId: 'hybrid_demo',
      ));

      _demoStream.add(DemoEvent(
        type: DemoEventType.step,
        title: 'SLM Classification Result',
        description: 'Intent and skill level identified',
        data: {
          'classification': slmResponse.content,
          'duration': '${slmResponse.durationMs}ms',
          'cost': '\$${slmResponse.cost.toStringAsFixed(4)}',
        },
      ));

      // Step 2: RAG for relevant knowledge
      _demoStream.add(DemoEvent(
        type: DemoEventType.step,
        title: 'Step 2: RAG Knowledge Retrieval',
        description: 'Retrieving relevant tutorials and best practices',
      ));

      final ragResponse = await _orchestrator.processRequest(UserRequest(
        id: 'hybrid_rag',
        content: 'Unity 2D platformer tutorial beginner',
        taskType: MediaTaskType.researchQuery,
        userId: userId,
        sessionId: 'hybrid_demo',
        context: {'knowledgeBase': 'game_development'},
      ));

      _demoStream.add(DemoEvent(
        type: DemoEventType.step,
        title: 'RAG Knowledge Result',
        description: 'Retrieved relevant knowledge',
        data: {
          'sources': ragResponse.sources.length,
          'duration': '${ragResponse.durationMs}ms',
          'cost': '\$${ragResponse.cost.toStringAsFixed(4)}',
        },
      ));

      // Step 3: LLM for comprehensive response
      _demoStream.add(DemoEvent(
        type: DemoEventType.step,
        title: 'Step 3: LLM Comprehensive Response',
        description: 'Generating comprehensive, personalized response',
      ));

      final llmResponse = await _orchestrator.processRequest(UserRequest(
        id: 'hybrid_llm',
        content: '''
Generate a comprehensive response for a beginner wanting to create a 2D platformer in Unity:

User Query: $complexQuery
SLM Classification: ${slmResponse.content}
RAG Knowledge: ${ragResponse.content}

Provide:
1. Step-by-step guidance
2. Recommended resources
3. Common pitfalls to avoid
4. Estimated timeline
5. Next steps
''',
        taskType: MediaTaskType.comprehensiveAnalysis,
        userId: userId,
        sessionId: 'hybrid_demo',
      ));

      _demoStream.add(DemoEvent(
        type: DemoEventType.step,
        title: 'LLM Comprehensive Result',
        description: 'Generated comprehensive response',
        data: {
          'response': llmResponse.content,
          'duration': '${llmResponse.durationMs}ms',
          'cost': '\$${llmResponse.cost.toStringAsFixed(4)}',
        },
      ));

      // Final summary
      final totalCost = slmResponse.cost + ragResponse.cost + llmResponse.cost;
      final totalDuration = slmResponse.durationMs + ragResponse.durationMs + llmResponse.durationMs;

      _demoStream.add(DemoEvent(
        type: DemoEventType.completed,
        title: 'Hybrid Approach Complete',
        description: 'Successfully combined SLM + RAG + LLM for complex task',
        data: {
          'totalCost': '\$${totalCost.toStringAsFixed(4)}',
          'totalDuration': '${totalDuration}ms',
          'approaches': [
            'SLM: Fast classification',
            'RAG: Knowledge retrieval',
            'LLM: Comprehensive response',
          ],
          'benefits': [
            'Fast initial processing (SLM)',
            'Accurate knowledge (RAG)',
            'Creative, personalized response (LLM)',
            'Cost-effective compared to LLM-only',
          ],
        },
      ));

    } catch (e) {
      _demoStream.add(DemoEvent(
        type: DemoEventType.error,
        title: 'Demo Error',
        description: 'Error during hybrid approach demo: $e',
      ));
    }
  }

  // Utility methods
  Future<Map<String, dynamic>> getDemoStats() async {
    final platformStats = await _mediaService.getPlatformInsights();
    final orchestratorStats = await _orchestrator.getSystemStats();
    
    return {
      'platform': platformStats,
      'orchestrator': orchestratorStats,
      'demoInfo': {
        'totalDemos': 6,
        'demosAvailable': [
          'Content Recommendation (SLM + RAG + LLM)',
          'Community Moderation (SLM + LLM)',
          'Content Creation (RAG + LLM)',
          'German Localization (SLM + RAG + LLM)',
          'Performance Comparison',
          'Hybrid Approach (All Three)',
        ],
      },
    };
  }

  void dispose() {
    _demoStream.close();
    _mediaService.dispose();
    _orchestrator.dispose();
  }
}

// Demo Event System
enum DemoEventType {
  started,
  step,
  completed,
  error,
}

class DemoEvent {
  final DemoEventType type;
  final String title;
  final String description;
  final Map<String, dynamic>? data;
  final DateTime timestamp;

  DemoEvent({
    required this.type,
    required this.title,
    required this.description,
    this.data,
  }) : timestamp = DateTime.now();
} 