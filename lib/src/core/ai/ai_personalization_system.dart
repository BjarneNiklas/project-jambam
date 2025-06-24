import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'ai_architecture_system.dart';

// On-Device SLM Personalization System
class AIPersonalizationSystem {
  static const String _userModelKey = 'user_ai_model';
  static const String _userPreferencesKey = 'user_ai_preferences';
  static const String _trainingDataKey = 'user_training_data';
  
  // User-specific model adaptations
  Map<String, dynamic> _userModel = {};
  Map<String, dynamic> _userPreferences = {};
  List<Map<String, dynamic>> _trainingData = [];
  
  // Personalization metrics
  int _totalInteractions = 0;
  final Map<String, int> _taskTypeUsage = {};
  final Map<String, double> _userSatisfaction = {};
  
  // Initialize personalization
  Future<void> initialize() async {
    await _loadUserModel();
    await _loadUserPreferences();
    await _loadTrainingData();
  }
  
  // Personalize AI request based on user history
  Future<AIRequest> personalizeRequest(AIRequest request) async {
    final personalizedRequest = AIRequest(
      id: request.id,
      taskType: request.taskType,
      prompt: _enhancePromptWithUserContext(request.prompt),
      context: _enhanceContextWithUserData(request.context),
      preferredModel: _selectUserPreferredModel(request.taskType),
      parameters: _adjustParametersForUser(request.parameters),
    );
    
    // Record interaction for learning
    await _recordInteraction(request, personalizedRequest);
    
    return personalizedRequest;
  }
  
  // Enhance prompt with user context
  String _enhancePromptWithUserContext(String prompt) {
    if (_userPreferences.isEmpty) return prompt;
    
    final userContext = _buildUserContext();
    return '$prompt\n\nUser Context: $userContext';
  }
  
  // Enhance context with user data
  Map<String, dynamic> _enhanceContextWithUserData(Map<String, dynamic> context) {
    final enhancedContext = Map<String, dynamic>.from(context);
    
    // Add user preferences
    enhancedContext['user_preferences'] = _userPreferences;
    
    // Add user expertise level
    enhancedContext['user_expertise'] = _calculateUserExpertise();
    
    // Add user interaction history
    enhancedContext['interaction_history'] = _getRecentInteractions(5);
    
    return enhancedContext;
  }
  
  // Select user's preferred model based on history
  AIModelConfig? _selectUserPreferredModel(AITaskType taskType) {
    final taskName = taskType.name;
    final userModel = _userModel[taskName];
    
    if (userModel != null && userModel['preferred_model'] != null) {
      return AIModelRegistry.getModel(userModel['preferred_model']);
    }
    
    return null; // Use default selection
  }
  
  // Adjust parameters based on user preferences
  Map<String, dynamic> _adjustParametersForUser(Map<String, dynamic> parameters) {
    final adjustedParams = Map<String, dynamic>.from(parameters);
    
    // Adjust temperature based on user creativity preference
    if (_userPreferences.containsKey('creativity_level')) {
      final creativity = _userPreferences['creativity_level'] as double;
      adjustedParams['temperature'] = creativity;
    }
    
    // Adjust response length based on user preference
    if (_userPreferences.containsKey('response_length')) {
      final length = _userPreferences['response_length'] as String;
      switch (length) {
        case 'concise':
          adjustedParams['max_tokens'] = 500;
          break;
        case 'detailed':
          adjustedParams['max_tokens'] = 2000;
          break;
        case 'comprehensive':
          adjustedParams['max_tokens'] = 4000;
          break;
      }
    }
    
    return adjustedParams;
  }
  
  // Build user context string
  String _buildUserContext() {
    final contextParts = <String>[];
    
    if (_userPreferences.containsKey('expertise_level')) {
      contextParts.add('Expertise: ${_userPreferences['expertise_level']}');
    }
    
    if (_userPreferences.containsKey('preferred_genres')) {
      final genres = _userPreferences['preferred_genres'] as List;
      contextParts.add('Preferred genres: ${genres.join(', ')}');
    }
    
    if (_userPreferences.containsKey('development_goals')) {
      contextParts.add('Goals: ${_userPreferences['development_goals']}');
    }
    
    return contextParts.join(', ');
  }
  
  // Calculate user expertise level
  String _calculateUserExpertise() {
    final totalInteractions = _totalInteractions;
    final satisfaction = _userSatisfaction.values.isEmpty 
        ? 0.0 
        : _userSatisfaction.values.reduce((a, b) => a + b) / _userSatisfaction.length;
    
    if (totalInteractions > 100 && satisfaction > 0.8) return 'expert';
    if (totalInteractions > 50 && satisfaction > 0.6) return 'intermediate';
    if (totalInteractions > 10) return 'beginner';
    return 'new';
  }
  
  // Get recent interactions
  List<Map<String, dynamic>> _getRecentInteractions(int count) {
    return _trainingData
        .take(count)
        .map((data) => {
          'task_type': data['task_type'],
          'prompt': data['prompt'],
          'satisfaction': data['satisfaction'],
          'timestamp': data['timestamp'],
        })
        .toList();
  }
  
  // Record interaction for learning
  Future<void> _recordInteraction(AIRequest original, AIRequest personalized) async {
    _totalInteractions++;
    
    // Record task type usage
    final taskType = original.taskType.name;
    _taskTypeUsage[taskType] = (_taskTypeUsage[taskType] ?? 0) + 1;
    
    // Add to training data
    _trainingData.add({
      'task_type': taskType,
      'prompt': original.prompt,
      'personalized_prompt': personalized.prompt,
      'model_used': personalized.preferredModel?.modelId,
      'timestamp': DateTime.now().toIso8601String(),
      'satisfaction': 0.0, // Will be updated when user provides feedback
    });
    
    // Keep only recent training data
    if (_trainingData.length > 1000) {
      _trainingData = _trainingData.skip(500).toList();
    }
    
    await _saveTrainingData();
  }
  
  // Update user satisfaction
  Future<void> updateSatisfaction(String requestId, double satisfaction) async {
    final trainingData = _trainingData.where((data) => 
        data['request_id'] == requestId).toList();
    
    if (trainingData.isNotEmpty) {
      trainingData.first['satisfaction'] = satisfaction;
      
      // Update user satisfaction metrics
      final taskType = trainingData.first['task_type'] as String;
      _userSatisfaction[taskType] = satisfaction;
      
      await _saveTrainingData();
      await _updateUserModel();
    }
  }
  
  // Update user model based on feedback
  Future<void> _updateUserModel() async {
    // Analyze user patterns
    final taskTypePreferences = _analyzeTaskTypePreferences();
    final modelPreferences = _analyzeModelPreferences();
    final promptPatterns = _analyzePromptPatterns();
    
    // Update user model
    _userModel = {
      'task_type_preferences': taskTypePreferences,
      'model_preferences': modelPreferences,
      'prompt_patterns': promptPatterns,
      'expertise_level': _calculateUserExpertise(),
      'total_interactions': _totalInteractions,
      'average_satisfaction': _calculateAverageSatisfaction(),
    };
    
    await _saveUserModel();
  }
  
  // Analyze task type preferences
  Map<String, double> _analyzeTaskTypePreferences() {
    final total = _taskTypeUsage.values.reduce((a, b) => a + b);
    return _taskTypeUsage.map((task, count) => 
        MapEntry(task, count / total));
  }
  
  // Analyze model preferences
  Map<String, String> _analyzeModelPreferences() {
    final modelUsage = <String, int>{};
    
    for (final data in _trainingData) {
      final model = data['model_used'] as String?;
      if (model != null) {
        modelUsage[model] = (modelUsage[model] ?? 0) + 1;
      }
    }
    
    return modelUsage.map((model, count) => MapEntry(model, model));
  }
  
  // Analyze prompt patterns
  Map<String, dynamic> _analyzePromptPatterns() {
    final patterns = <String, dynamic>{};
    
    // Analyze common keywords
    final keywords = <String, int>{};
    for (final data in _trainingData) {
      final prompt = data['prompt'] as String;
      final words = prompt.toLowerCase().split(' ');
      for (final word in words) {
        if (word.length > 3) {
          keywords[word] = (keywords[word] ?? 0) + 1;
        }
      }
    }
    
    patterns['common_keywords'] = keywords.entries
        .where((e) => e.value > 2)
        .map((e) => e.key)
        .toList();
    
    // Analyze prompt length preferences
    final lengths = _trainingData.map((data) => 
        (data['prompt'] as String).length).toList();
    patterns['average_prompt_length'] = lengths.isEmpty 
        ? 0 
        : lengths.reduce((a, b) => a + b) / lengths.length;
    
    return patterns;
  }
  
  // Calculate average satisfaction
  double _calculateAverageSatisfaction() {
    final satisfactions = _trainingData
        .where((data) => data['satisfaction'] != null)
        .map((data) => data['satisfaction'] as double)
        .toList();
    
    return satisfactions.isEmpty 
        ? 0.0 
        : satisfactions.reduce((a, b) => a + b) / satisfactions.length;
  }
  
  // Update user preferences
  Future<void> updateUserPreferences(Map<String, dynamic> preferences) async {
    _userPreferences.addAll(preferences);
    await _saveUserPreferences();
    await _updateUserModel();
  }
  
  // Get user insights
  Map<String, dynamic> getUserInsights() {
    return {
      'expertise_level': _calculateUserExpertise(),
      'total_interactions': _totalInteractions,
      'task_type_preferences': _analyzeTaskTypePreferences(),
      'average_satisfaction': _calculateAverageSatisfaction(),
      'common_keywords': _analyzePromptPatterns()['common_keywords'] ?? [],
      'preferences': _userPreferences,
    };
  }
  
  // Export user data
  Future<String> exportUserData() async {
    final data = {
      'user_model': _userModel,
      'user_preferences': _userPreferences,
      'training_data': _trainingData,
      'insights': getUserInsights(),
    };
    
    return jsonEncode(data);
  }
  
  // Import user data
  Future<void> importUserData(String jsonData) async {
    try {
      final data = jsonDecode(jsonData) as Map<String, dynamic>;
      
      _userModel = Map<String, dynamic>.from(data['user_model'] ?? {});
      _userPreferences = Map<String, dynamic>.from(data['user_preferences'] ?? {});
      _trainingData = List<Map<String, dynamic>>.from(data['training_data'] ?? []);
      
      await _saveUserModel();
      await _saveUserPreferences();
      await _saveTrainingData();
    } catch (e) {
      throw Exception('Failed to import user data: $e');
    }
  }
  
  // Reset user data
  Future<void> resetUserData() async {
    _userModel.clear();
    _userPreferences.clear();
    _trainingData.clear();
    _totalInteractions = 0;
    _taskTypeUsage.clear();
    _userSatisfaction.clear();
    
    await _saveUserModel();
    await _saveUserPreferences();
    await _saveTrainingData();
  }
  
  // Persistence methods
  Future<void> _saveUserModel() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userModelKey, jsonEncode(_userModel));
  }
  
  Future<void> _loadUserModel() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = prefs.getString(_userModelKey);
    if (jsonData != null) {
      _userModel = Map<String, dynamic>.from(jsonDecode(jsonData));
    }
  }
  
  Future<void> _saveUserPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userPreferencesKey, jsonEncode(_userPreferences));
    await prefs.setString(_trainingDataKey, jsonEncode(_trainingData));
  }
  
  Future<void> _loadUserPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = prefs.getString(_userPreferencesKey);
    if (jsonData != null) {
      _userPreferences = Map<String, dynamic>.from(jsonDecode(jsonData));
    }
  }
  
  Future<void> _saveTrainingData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_trainingDataKey, jsonEncode(_trainingData));
  }
  
  Future<void> _loadTrainingData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = prefs.getString(_trainingDataKey);
    if (jsonData != null) {
      _trainingData = List<Map<String, dynamic>>.from(jsonDecode(jsonData));
    }
  }
}

// Federated Learning System (Future Enhancement)
class FederatedLearningSystem {
  // This would implement federated learning for collaborative model improvement
  // without sharing raw user data
  
  Future<void> contributeToGlobalModel(Map<String, dynamic> localUpdates) async {
    // Send model updates (not raw data) to global model
    // This is a placeholder for future implementation
  }
  
  Future<void> receiveGlobalModelUpdates(Map<String, dynamic> globalUpdates) async {
    // Receive and apply global model improvements
    // This is a placeholder for future implementation
  }
} 