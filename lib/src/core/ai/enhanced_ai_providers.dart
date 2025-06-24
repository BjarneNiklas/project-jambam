import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ai_architecture_system.dart';
import 'ai_orchestrator_provider.dart';
import 'ai_personalization_system.dart';
import 'ai_multimodal_system.dart';
import 'ai_analytics_system.dart';
import 'ai_security_system.dart';
import 'dart:convert';

// Enhanced AI Providers - Integration of all AI systems

// Core AI Systems
final aiPersonalizationProvider = Provider<AIPersonalizationSystem>((ref) {
  return AIPersonalizationSystem();
});

final aiMultimodalProvider = Provider<MultiModalAISystem>((ref) {
  return MultiModalAISystem();
});

final aiAnalyticsProvider = Provider<AIAnalyticsSystem>((ref) {
  return AIAnalyticsSystem();
});

final aiSecurityProvider = Provider<AISecuritySystem>((ref) {
  return AISecuritySystem();
});

// Enhanced AI Orchestrator with all systems integrated
class EnhancedAIOrchestrator {
  final AIOrchestrator _baseOrchestrator;
  final AIPersonalizationSystem _personalization;
  final MultiModalAISystem _multimodal;
  final AIAnalyticsSystem _analytics;
  final AISecuritySystem _security;

  EnhancedAIOrchestrator({
    required AIOrchestrator baseOrchestrator,
    required AIPersonalizationSystem personalization,
    required MultiModalAISystem multimodal,
    required AIAnalyticsSystem analytics,
    required AISecuritySystem security,
  }) : _baseOrchestrator = baseOrchestrator,
       _personalization = personalization,
       _multimodal = multimodal,
       _analytics = analytics,
       _security = security;

  // Enhanced request processing with all systems
  Future<AIResponse> processRequest(AIRequest request) async {
    try {
      // 1. Security check and encryption
      final securedRequest = await _security.secureRequest(request);
      
      // 2. Personalization
      final personalizedRequest = await _personalization.personalizeRequest(securedRequest);
      
      // 3. Multi-modal processing if needed
      final processedRequest = await _processMultimodalRequest(personalizedRequest);
      
      // 4. Base AI processing
      final response = await _baseOrchestrator.processRequest(processedRequest);
      
      // 5. Security processing for response
      final securedResponse = await _security.secureResponse(response);
      
      // 6. Analytics recording
      await _analytics.recordAnalytics(
        requestId: request.id,
        taskType: request.taskType,
        modelType: response.usedModel.type,
        responseTime: DateTime.now().difference(request.timestamp).inMilliseconds.toDouble(),
        confidence: response.confidence,
        userSatisfaction: 0.0, // Will be updated when user provides feedback
        context: request.context,
      );
      
      return securedResponse;
    } catch (e) {
      // Record error in analytics
      await _analytics.recordAnalytics(
        requestId: request.id,
        taskType: request.taskType,
        modelType: AIModelType.slm,
        responseTime: 0.0,
        confidence: 0.0,
        userSatisfaction: 0.0,
        context: {'error': e.toString()},
      );
      
      rethrow;
    }
  }

  // Process multi-modal request
  Future<AIRequest> _processMultimodalRequest(AIRequest request) async {
    // Check if request contains media content
    if (request.context.containsKey('media_content')) {
      final mediaContent = request.context['media_content'] as List;
      
      if (mediaContent.isNotEmpty) {
        // Create multi-modal request
        final multimodalRequest = MultiModalRequest(
          id: request.id,
          textPrompt: request.prompt,
          mediaContent: mediaContent.map((m) => MediaContent.fromJson(m)).toList(),
          taskType: request.taskType,
          context: request.context,
          parameters: request.parameters,
        );
        
        // Process with multi-modal system
        final multimodalResponse = await _multimodal.processRequest(multimodalRequest);
        
        // Update request with multi-modal results
        final enhancedContext = Map<String, dynamic>.from(request.context);
        enhancedContext['multimodal_analysis'] = multimodalResponse.textResponse;
        
        return AIRequest(
          id: request.id,
          taskType: request.taskType,
          prompt: '${request.prompt}\n\nMulti-modal analysis: ${multimodalResponse.textResponse}',
          context: enhancedContext,
          preferredModel: request.preferredModel,
          parameters: request.parameters,
        );
      }
    }
    
    return request;
  }

  // Update user satisfaction
  Future<void> updateSatisfaction(String requestId, double satisfaction) async {
    await _personalization.updateSatisfaction(requestId, satisfaction);
    await _analytics.recordAnalytics(
      requestId: requestId,
      taskType: AITaskType.analysis,
      modelType: AIModelType.slm,
      responseTime: 0.0,
      confidence: satisfaction,
      userSatisfaction: satisfaction,
      context: {'feedback': true},
    );
  }

  // Get user insights
  Map<String, dynamic> getUserInsights() {
    return _personalization.getUserInsights();
  }

  // Get analytics dashboard
  Map<String, dynamic> getAnalyticsDashboard() {
    return _analytics.getDashboardData();
  }

  // Get security report
  Map<String, dynamic> getSecurityReport() {
    return _security.getSecurityReport();
  }

  // Get recommendations
  List<Map<String, dynamic>> getRecommendations() {
    return _analytics.getRecommendations();
  }

  // Export user data
  Future<String> exportUserData() async {
    return await _personalization.exportUserData();
  }

  // Import user data
  Future<void> importUserData(String jsonData) async {
    await _personalization.importUserData(jsonData);
  }

  // Update security settings
  Future<void> updateSecuritySettings(Map<String, dynamic> settings) async {
    await _security.updateSecuritySettings(settings);
  }

  // Update privacy settings
  Future<void> updatePrivacySettings(Map<String, dynamic> settings) async {
    await _security.updatePrivacySettings(settings);
  }

  // Update user preferences
  Future<void> updateUserPreferences(Map<String, dynamic> preferences) async {
    await _personalization.updateUserPreferences(preferences);
  }

  // Get multi-modal capabilities
  List<String> getMultimodalCapabilities(String modelId) {
    return _multimodal.getModelCapabilities(modelId);
  }

  // Check if format is supported
  bool isFormatSupported(MediaType type, MediaFormat format) {
    return _multimodal.isFormatSupported(type, format);
  }

  // Voice recording methods
  Future<Map<String, dynamic>> startVoiceRecording() async {
    // Simulate voice recording
    await Future.delayed(const Duration(seconds: 2));
    return {
      'transcription': 'Simulated voice transcription',
      'duration': 2.0,
      'confidence': 0.95,
    };
  }

  Future<Map<String, dynamic>> pickImage() async {
    // Simulate image picking
    await Future.delayed(const Duration(seconds: 1));
    return {
      'description': 'Simulated image description',
      'path': '/path/to/image.jpg',
      'size': 1024,
    };
  }

  Future<Map<String, dynamic>> takePhoto() async {
    // Simulate photo capture
    await Future.delayed(const Duration(seconds: 1));
    return {
      'description': 'Simulated photo description',
      'path': '/path/to/photo.jpg',
      'size': 2048,
    };
  }

  Future<Map<String, dynamic>> pickVideo() async {
    // Simulate video picking
    await Future.delayed(const Duration(seconds: 1));
    return {
      'description': 'Simulated video description',
      'path': '/path/to/video.mp4',
      'duration': 30.0,
      'size': 10240,
    };
  }

  Future<Map<String, dynamic>> pickAudio() async {
    // Simulate audio picking
    await Future.delayed(const Duration(seconds: 1));
    return {
      'description': 'Simulated audio description',
      'path': '/path/to/audio.mp3',
      'duration': 15.0,
      'size': 5120,
    };
  }

  // Security methods
  Future<bool> validateInput(String input) async {
    // Basic input validation
    return input.trim().isNotEmpty && input.length < 10000;
  }

  Future<Map<String, dynamic>> auditConversation(List<Map<String, dynamic>> conversation) async {
    // Simulate conversation audit
    return {
      'flagged_content': [],
      'risk_score': 0.1,
      'recommendations': ['Continue normal operation'],
    };
  }

  // Analytics methods
  Future<Map<String, dynamic>> getUsageAnalytics() async {
    return {
      'total_requests': 150,
      'success_rate': 0.98,
      'average_response_time': 1.2,
      'popular_features': ['text_processing', 'image_analysis'],
    };
  }

  Future<void> logInteraction(String interactionType, Map<String, dynamic> data) async {
    // Log interaction for analytics
    // print('Interaction logged: $interactionType - $data'); // Removed due to avoid_print
  }
}

// Enhanced AI Orchestrator Provider
final enhancedAIOrchestratorProvider = Provider<EnhancedAIOrchestrator>((ref) {
  final baseOrchestrator = ref.watch(aiOrchestratorProvider);
  final personalization = ref.watch(aiPersonalizationProvider);
  final multimodal = ref.watch(aiMultimodalProvider);
  final analytics = ref.watch(aiAnalyticsProvider);
  final security = ref.watch(aiSecurityProvider);
  
  return EnhancedAIOrchestrator(
    baseOrchestrator: baseOrchestrator,
    personalization: personalization,
    multimodal: multimodal,
    analytics: analytics,
    security: security,
  );
});

// Enhanced AI Service with all features
class EnhancedAIService {
  final EnhancedAIOrchestrator _orchestrator;

  EnhancedAIService(this._orchestrator);

  // Basic AI operations with all enhancements
  Future<String> classifyContent(String content) async {
    final request = AIRequest(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      taskType: AITaskType.classification,
      prompt: content,
    );
    
    final response = await _orchestrator.processRequest(request);
    return response.content;
  }

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

  // Multi-modal operations
  Future<String> analyzeImage(String imageData, String prompt) async {
    final request = AIRequest(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      taskType: AITaskType.analysis,
      prompt: prompt,
      context: {
        'media_content': [
          {
            'id': 'img_${DateTime.now().millisecondsSinceEpoch}',
            'type': 'image',
            'format': 'png',
            'data': imageData,
            'url': null,
            'metadata': {},
          }
        ],
      },
    );
    
    final response = await _orchestrator.processRequest(request);
    return response.content;
  }

  Future<String> analyzeAudio(String audioData, String prompt) async {
    final request = AIRequest(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      taskType: AITaskType.analysis,
      prompt: prompt,
      context: {
        'media_content': [
          {
            'id': 'audio_${DateTime.now().millisecondsSinceEpoch}',
            'type': 'audio',
            'format': 'mp3',
            'data': audioData,
            'url': null,
            'metadata': {},
          }
        ],
      },
    );
    
    final response = await _orchestrator.processRequest(request);
    return response.content;
  }

  // User feedback and personalization
  Future<void> provideFeedback(String requestId, double satisfaction) async {
    await _orchestrator.updateSatisfaction(requestId, satisfaction);
  }

  // Analytics and insights
  Map<String, dynamic> getUserInsights() {
    return _orchestrator.getUserInsights();
  }

  Map<String, dynamic> getAnalyticsDashboard() {
    return _orchestrator.getAnalyticsDashboard();
  }

  List<Map<String, dynamic>> getRecommendations() {
    return _orchestrator.getRecommendations();
  }

  // Security and privacy
  Map<String, dynamic> getSecurityReport() {
    return _orchestrator.getSecurityReport();
  }

  Future<void> updateSecuritySettings(Map<String, dynamic> settings) async {
    await _orchestrator.updateSecuritySettings(settings);
  }

  Future<void> updatePrivacySettings(Map<String, dynamic> settings) async {
    await _orchestrator.updatePrivacySettings(settings);
  }

  // User preferences
  Future<void> updateUserPreferences(Map<String, dynamic> preferences) async {
    await _orchestrator.updateUserPreferences(preferences);
  }

  // Data export/import
  Future<String> exportUserData() async {
    return await _orchestrator.exportUserData();
  }

  Future<void> importUserData(String jsonData) async {
    await _orchestrator.importUserData(jsonData);
  }

  // Multi-modal capabilities
  List<String> getMultimodalCapabilities(String modelId) {
    return _orchestrator.getMultimodalCapabilities(modelId);
  }

  bool isFormatSupported(MediaType type, MediaFormat format) {
    return _orchestrator.isFormatSupported(type, format);
  }

  // Missing methods for presentation screens
  Future<String> processMultimodalInput(String input, {Map<String, dynamic>? context}) async {
    final request = AIRequest(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      taskType: AITaskType.analysis,
      prompt: input,
      context: context ?? {},
    );
    
    final response = await _orchestrator.processRequest(request);
    return response.content;
  }

  Future<void> startVoiceRecording() async {
    // Placeholder implementation
    await Future.delayed(const Duration(milliseconds: 100));
  }

  Future<String?> pickImage() async {
    // Placeholder implementation
    return null;
  }

  Future<String?> takePhoto() async {
    // Placeholder implementation
    return null;
  }

  Future<String?> pickVideo() async {
    // Placeholder implementation
    return null;
  }

  Future<String?> pickAudio() async {
    // Placeholder implementation
    return null;
  }

  Future<String?> pickDocument() async {
    // Placeholder implementation
    return null;
  }

  Future<String> exportConversation() async {
    // Placeholder implementation
    return '{"conversation": []}';
  }

  // Personalization methods
  Future<Map<String, dynamic>> getPersonalizationSettings() async {
    return _orchestrator.getUserInsights();
  }

  Future<void> updatePersonalizationSettings(Map<String, dynamic> settings) async {
    await _orchestrator.updateUserPreferences(settings);
  }

  Future<void> savePersonalizationSettings(Map<String, dynamic> settings) async {
    await _orchestrator.updateUserPreferences(settings);
  }

  Future<void> resetPersonalizationSettings() async {
    await _orchestrator.updateUserPreferences({});
  }

  // Security methods
  Future<void> updateDataRetentionSettings(Map<String, dynamic> settings) async {
    await _orchestrator.updateSecuritySettings(settings);
  }

  Future<void> deleteUserData() async {
    // Placeholder implementation
    await Future.delayed(const Duration(milliseconds: 100));
  }

  Future<String> exportSecurityReport() async {
    final report = _orchestrator.getSecurityReport();
    return jsonEncode(report);
  }
}

// Enhanced AI Service Provider
final enhancedAIServiceProvider = Provider<EnhancedAIService>((ref) {
  final orchestrator = ref.watch(enhancedAIOrchestratorProvider);
  return EnhancedAIService(orchestrator);
});

// State providers for UI
final userInsightsProvider = Provider<Map<String, dynamic>>((ref) {
  final service = ref.watch(enhancedAIServiceProvider);
  return service.getUserInsights();
});

final analyticsDashboardProvider = Provider<Map<String, dynamic>>((ref) {
  final service = ref.watch(enhancedAIServiceProvider);
  return service.getAnalyticsDashboard();
});

final securityReportProvider = Provider<Map<String, dynamic>>((ref) {
  final service = ref.watch(enhancedAIServiceProvider);
  return service.getSecurityReport();
});

final recommendationsProvider = Provider<List<Map<String, dynamic>>>((ref) {
  final service = ref.watch(enhancedAIServiceProvider);
  return service.getRecommendations();
});

// Settings providers
final aiSettingsProvider = StateNotifierProvider<AISettingsNotifier, AISettings>((ref) {
  return AISettingsNotifier(ref);
});

class AISettings {
  final Map<String, dynamic> securitySettings;
  final Map<String, dynamic> privacySettings;
  final Map<String, dynamic> userPreferences;

  const AISettings({
    this.securitySettings = const {},
    this.privacySettings = const {},
    this.userPreferences = const {},
  });

  AISettings copyWith({
    Map<String, dynamic>? securitySettings,
    Map<String, dynamic>? privacySettings,
    Map<String, dynamic>? userPreferences,
  }) {
    return AISettings(
      securitySettings: securitySettings ?? this.securitySettings,
      privacySettings: privacySettings ?? this.privacySettings,
      userPreferences: userPreferences ?? this.userPreferences,
    );
  }
}

class AISettingsNotifier extends StateNotifier<AISettings> {
  final Ref _ref;

  AISettingsNotifier(this._ref) : super(const AISettings());

  Future<void> updateSecuritySettings(Map<String, dynamic> settings) async {
    final service = _ref.read(enhancedAIServiceProvider);
    await service.updateSecuritySettings(settings);
    
    state = state.copyWith(securitySettings: settings);
  }

  Future<void> updatePrivacySettings(Map<String, dynamic> settings) async {
    final service = _ref.read(enhancedAIServiceProvider);
    await service.updatePrivacySettings(settings);
    
    state = state.copyWith(privacySettings: settings);
  }

  Future<void> updateUserPreferences(Map<String, dynamic> preferences) async {
    final service = _ref.read(enhancedAIServiceProvider);
    await service.updateUserPreferences(preferences);
    
    state = state.copyWith(userPreferences: preferences);
  }
} 