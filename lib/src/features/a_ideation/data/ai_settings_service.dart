import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'ai_cost_calculation_service.dart';

/// AI Settings Service
/// Verwaltet User-spezifische API Keys und Modell-Auswahl
class AISettingsService {
  // Removed unused _storageKey
  static const String _apiKeysKey = 'user_api_keys';
  static const String _modelSettingsKey = 'model_settings';
  
  // Verfügbare AI-Modelle - Wissenschaftlich fundiert und strukturiert
  static const Map<String, AIModel> _availableModels = {
    // === GOOGLE MODELS ===
    'gemini-1.5-flash': AIModel(
      id: 'gemini-1.5-flash',
      name: 'Gemini 1.5 Flash',
      provider: 'Google',
      providerIcon: 'assets/icons/google.png',
      cost: 'Kostenlos',
      costDetails: '0€ pro 1M Tokens',
      speed: 'Sehr schnell',
      speedDetails: '~500ms Antwortzeit',
      quality: 'Gut',
      qualityDetails: '7B Parameter, optimiert für Geschwindigkeit',
      description: 'Schnell und kostenlos für Konzept-Generierung und Prototyping',
      maxTokens: 8192,
      useCases: ['Game Concept Generation', 'Rapid Prototyping', 'Live Demos'],
      scientificAccuracy: 'Gemini 1.5 Flash ist ein 7B-Parameter-Modell, optimiert für Geschwindigkeit bei guter Qualität',
      category: 'direct',
    ),
    'gemini-1.5-pro': AIModel(
      id: 'gemini-1.5-pro',
      name: 'Gemini 1.5 Pro',
      provider: 'Google',
      providerIcon: 'assets/icons/google.png',
      cost: 'Bezahlt',
      costDetails: '3.50€ pro 1M Input Tokens',
      speed: 'Mittel',
      speedDetails: '~2-3s Antwortzeit',
      quality: 'Sehr gut',
      qualityDetails: 'Gemini 1.5 Pro mit 32K Kontext',
      description: 'Bessere Qualität für komplexe Game Design Aufgaben',
      maxTokens: 32768,
      useCases: ['Complex Game Design', 'Story Development', 'Technical Specifications'],
      scientificAccuracy: 'Gemini 1.5 Pro bietet 32K Kontext und verbesserte Reasoning-Fähigkeiten',
      category: 'direct',
    ),
    'gemini-2.0-flash': AIModel(
      id: 'gemini-2.0-flash',
      name: 'Gemini 2.0 Flash',
      provider: 'Google',
      providerIcon: 'assets/icons/google.png',
      cost: 'Kostenlos',
      costDetails: '0€ pro 1M Tokens',
      speed: 'Extrem schnell',
      speedDetails: '~200ms Antwortzeit',
      quality: 'Sehr gut',
      qualityDetails: 'Neueste Generation, optimiert für Echtzeit',
      description: 'Neueste Generation für Echtzeit-Game-Design',
      maxTokens: 16384,
      useCases: ['Real-time Generation', 'Live Demos', 'Interactive Design'],
      scientificAccuracy: 'Gemini 2.0 Flash ist die neueste Generation mit verbesserter Geschwindigkeit und Qualität',
      category: 'direct',
    ),

    // === OPENAI MODELS ===
    'gpt-4': AIModel(
      id: 'gpt-4',
      name: 'GPT-4',
      provider: 'OpenAI',
      providerIcon: 'assets/icons/openai.png',
      cost: 'Bezahlt',
      costDetails: '30.00€ pro 1M Input Tokens',
      speed: 'Mittel',
      speedDetails: '~3-5s Antwortzeit',
      quality: 'Exzellent',
      qualityDetails: 'GPT-4 mit 8K Kontext',
      description: 'Höchste Qualität für komplexe Game Design und Analyse',
      maxTokens: 8192,
      useCases: ['Complex Game Design', 'Advanced Analysis', 'Final Concepts'],
      scientificAccuracy: 'GPT-4 ist ein Large Language Model mit 175B+ Parametern und exzellenten Reasoning-Fähigkeiten',
      category: 'cloud',
    ),
    'gpt-4-turbo': AIModel(
      id: 'gpt-4-turbo',
      name: 'GPT-4 Turbo',
      provider: 'OpenAI',
      providerIcon: 'assets/icons/openai.png',
      cost: 'Bezahlt',
      costDetails: '10.00€ pro 1M Input Tokens',
      speed: 'Schnell',
      speedDetails: '~1-2s Antwortzeit',
      quality: 'Exzellent',
      qualityDetails: 'GPT-4 Turbo mit 128K Kontext',
      description: 'Optimierte Version von GPT-4 für bessere Geschwindigkeit',
      maxTokens: 128000,
      useCases: ['Game Design', 'Long-form Content', 'Complex Analysis'],
      scientificAccuracy: 'GPT-4 Turbo bietet 128K Kontext und verbesserte Geschwindigkeit bei GPT-4 Qualität',
      category: 'cloud',
    ),
    'gpt-3.5-turbo': AIModel(
      id: 'gpt-3.5-turbo',
      name: 'GPT-3.5 Turbo',
      provider: 'OpenAI',
      providerIcon: 'assets/icons/openai.png',
      cost: 'Bezahlt',
      costDetails: '1.50€ pro 1M Input Tokens',
      speed: 'Schnell',
      speedDetails: '~1s Antwortzeit',
      quality: 'Gut',
      qualityDetails: 'GPT-3.5 Turbo mit 4K Kontext',
      description: 'Schnell und kostengünstig für Basis-Game-Design',
      maxTokens: 4096,
      useCases: ['Basic Game Design', 'Prototyping', 'Quick Concepts'],
      scientificAccuracy: 'GPT-3.5 Turbo ist ein 175B-Parameter-Modell mit guter Qualität und Geschwindigkeit',
      category: 'cloud',
    ),

    // === ANTHROPIC MODELS ===
    'claude-3-5-sonnet': AIModel(
      id: 'claude-3-5-sonnet',
      name: 'Claude 3.5 Sonnet',
      provider: 'Anthropic',
      providerIcon: 'assets/icons/anthropic.png',
      cost: 'Kostenlos',
      costDetails: '0€ (5 req/min Limit)',
      speed: 'Mittel',
      speedDetails: '~2-3s Antwortzeit',
      quality: 'Exzellent',
      qualityDetails: 'Claude 3.5 Sonnet mit 200K Kontext',
      description: 'Sehr gute Qualität, kostenlos verfügbar mit Limits',
      maxTokens: 16384,
      useCases: ['Creative Writing', 'Story Development', 'Character Design'],
      scientificAccuracy: 'Claude 3.5 Sonnet ist ein Large Language Model mit 200K Kontext und exzellenten kreativen Fähigkeiten',
    ),
    'claude-3-5-haiku': AIModel(
      id: 'claude-3-5-haiku',
      name: 'Claude 3.5 Haiku',
      provider: 'Anthropic',
      providerIcon: 'assets/icons/anthropic.png',
      cost: 'Bezahlt',
      costDetails: '0.25€ pro 1M Input Tokens',
      speed: 'Sehr schnell',
      speedDetails: '~500ms Antwortzeit',
      quality: 'Gut',
      qualityDetails: 'Claude 3.5 Haiku, optimiert für Geschwindigkeit',
      description: 'Schnelle Version von Claude für Echtzeit-Anwendungen',
      maxTokens: 8192,
      useCases: ['Quick Responses', 'Live Demos', 'Real-time Generation'],
      scientificAccuracy: 'Claude 3.5 Haiku ist eine schnellere, kleinere Version von Claude 3.5 mit guter Qualität',
    ),

    // === GROQ MODELS ===
    'groq-llama3-70b': AIModel(
      id: 'groq-llama3-70b',
      name: 'Groq Llama 3 70B',
      provider: 'Groq',
      providerIcon: 'assets/icons/groq.png',
      cost: 'Bezahlt',
      costDetails: '0.59€ pro 1M Input Tokens',
      speed: 'Extrem schnell',
      speedDetails: '~100-200ms Antwortzeit',
      quality: 'Sehr gut',
      qualityDetails: 'Llama 3 70B auf Groq Infrastruktur',
      description: 'Extrem schnell für Live-Demos und Echtzeit-Generierung',
      maxTokens: 8192,
      useCases: ['Live Demos', 'Real-time Generation', 'Bulk Processing'],
      scientificAccuracy: 'Groq bietet Llama 3 70B auf spezialisierter Hardware für extrem niedrige Latenz',
    ),
    'groq-llama3-8b': AIModel(
      id: 'groq-llama3-8b',
      name: 'Groq Llama 3 8B',
      provider: 'Groq',
      providerIcon: 'assets/icons/groq.png',
      cost: 'Bezahlt',
      costDetails: '0.05€ pro 1M Input Tokens',
      speed: 'Extrem schnell',
      speedDetails: '~50-100ms Antwortzeit',
      quality: 'Gut',
      qualityDetails: 'Llama 3 8B, optimiert für Geschwindigkeit',
      description: 'Schnellste Option für Prototyping und Live-Demos',
      maxTokens: 4096,
      useCases: ['Ultra-fast Prototyping', 'Live Demos', 'Bulk Generation'],
      scientificAccuracy: 'Groq Llama 3 8B bietet die schnellste verfügbare Antwortzeit für LLM-Generierung',
    ),
    'groq-mixtral-8x7b': AIModel(
      id: 'groq-mixtral-8x7b',
      name: 'Groq Mixtral 8x7B',
      provider: 'Groq',
      providerIcon: 'assets/icons/groq.png',
      cost: 'Bezahlt',
      costDetails: '0.24€ pro 1M Input Tokens',
      speed: 'Extrem schnell',
      speedDetails: '~150-300ms Antwortzeit',
      quality: 'Sehr gut',
      qualityDetails: 'Mixtral 8x7B mit MoE-Architektur',
      description: 'Ausgewogene Option zwischen Geschwindigkeit und Qualität',
      maxTokens: 32768,
      useCases: ['Balanced Generation', 'Live Demos', 'Quality Content'],
      scientificAccuracy: 'Mixtral 8x7B verwendet eine Mixture of Experts (MoE) Architektur für optimale Performance',
    ),

    // === OFFLINE MODELS ===
    'offline-gemma-7b': AIModel(
      id: 'offline-gemma-7b',
      name: 'Gemma 7B (Offline)',
      provider: 'Google',
      providerIcon: 'assets/icons/google.png',
      cost: 'Kostenlos',
      costDetails: '0€ (lokale Ausführung)',
      speed: 'Mittel',
      speedDetails: '~2-5s Antwortzeit',
      quality: 'Gut',
      qualityDetails: 'Gemma 7B, lokal ausgeführt',
      description: 'Lokale Ausführung für Offline-Nutzung und Datenschutz',
      maxTokens: 8192,
      useCases: ['Offline Usage', 'Privacy-sensitive Tasks', 'Mobile Apps'],
      scientificAccuracy: 'Gemma 7B ist ein 7B-Parameter-Modell von Google, optimiert für lokale Ausführung',
    ),
    'offline-mistral-7b': AIModel(
      id: 'offline-mistral-7b',
      name: 'Mistral 7B (Offline)',
      provider: 'Mistral AI',
      providerIcon: 'assets/icons/mistral.png',
      cost: 'Kostenlos',
      costDetails: '0€ (lokale Ausführung)',
      speed: 'Mittel',
      speedDetails: '~3-6s Antwortzeit',
      quality: 'Sehr gut',
      qualityDetails: 'Mistral 7B, lokal ausgeführt',
      description: 'Hochwertige lokale Ausführung für Offline-Nutzung',
      maxTokens: 8192,
      useCases: ['Offline Usage', 'High-quality Local Generation', 'Privacy'],
      scientificAccuracy: 'Mistral 7B ist ein 7B-Parameter-Modell mit exzellenter Qualität für seine Größe',
    ),
    'offline-llama3-8b': AIModel(
      id: 'offline-llama3-8b',
      name: 'Llama 3 8B (Offline)',
      provider: 'Meta',
      providerIcon: 'assets/icons/meta.png',
      cost: 'Kostenlos',
      costDetails: '0€ (lokale Ausführung)',
      speed: 'Schnell',
      speedDetails: '~1-3s Antwortzeit',
      quality: 'Gut',
      qualityDetails: 'Llama 3 8B, lokal ausgeführt',
      description: 'Schnelle lokale Ausführung für Mobile-Apps',
      maxTokens: 4096,
      useCases: ['Mobile Apps', 'Quick Offline Generation', 'Privacy'],
      scientificAccuracy: 'Llama 3 8B ist ein 8B-Parameter-Modell von Meta, optimiert für lokale Ausführung',
    ),

    // === MLC LLM MODELS ===
    'mlc-llama3-8b': AIModel(
      id: 'mlc-llama3-8b',
      name: 'Llama 3 8B (MLC LLM)',
      provider: 'MLC LLM',
      providerIcon: 'assets/icons/mlc.png',
      cost: 'Kostenlos',
      costDetails: '0€ (lokale Ausführung)',
      speed: 'Sehr schnell',
      speedDetails: '~500ms-1s Antwortzeit',
      quality: 'Sehr gut',
      qualityDetails: 'Llama 3 8B über MLC LLM Engine',
      description: 'Hochperformante lokale Ausführung mit MLC LLM',
      maxTokens: 8192,
      useCases: ['Cross-Platform', 'High Performance', 'Privacy'],
      scientificAccuracy: 'MLC LLM bietet Llama 3 8B mit optimierter GPU/CPU-Inferenz für alle Plattformen',
      category: 'offline',
    ),
    'mlc-mistral-7b': AIModel(
      id: 'mlc-mistral-7b',
      name: 'Mistral 7B (MLC LLM)',
      provider: 'MLC LLM',
      providerIcon: 'assets/icons/mlc.png',
      cost: 'Kostenlos',
      costDetails: '0€ (lokale Ausführung)',
      speed: 'Schnell',
      speedDetails: '~1-2s Antwortzeit',
      quality: 'Sehr gut',
      qualityDetails: 'Mistral 7B über MLC LLM Engine',
      description: 'Hochwertige lokale Ausführung mit großem Kontext',
      maxTokens: 32768,
      useCases: ['Long Context', 'High Quality', 'Cross-Platform'],
      scientificAccuracy: 'MLC LLM bietet Mistral 7B mit 32K Kontext und optimierter Performance',
      category: 'offline',
    ),
    'mlc-gemma-2b': AIModel(
      id: 'mlc-gemma-2b',
      name: 'Gemma 2B (MLC LLM)',
      provider: 'MLC LLM',
      providerIcon: 'assets/icons/mlc.png',
      cost: 'Kostenlos',
      costDetails: '0€ (lokale Ausführung)',
      speed: 'Extrem schnell',
      speedDetails: '~200-500ms Antwortzeit',
      quality: 'Gut',
      qualityDetails: 'Gemma 2B über MLC LLM Engine',
      description: 'Schnellste lokale Ausführung für Mobile und Web',
      maxTokens: 8192,
      useCases: ['Mobile Apps', 'Web Apps', 'Real-time Generation'],
      scientificAccuracy: 'MLC LLM bietet Gemma 2B mit extrem niedriger Latenz für Echtzeit-Anwendungen',
      category: 'offline',
    ),
    'mlc-phi-2': AIModel(
      id: 'mlc-phi-2',
      name: 'Phi-2 (MLC LLM)',
      provider: 'MLC LLM',
      providerIcon: 'assets/icons/mlc.png',
      cost: 'Kostenlos',
      costDetails: '0€ (lokale Ausführung)',
      speed: 'Sehr schnell',
      speedDetails: '~300-800ms Antwortzeit',
      quality: 'Sehr gut',
      qualityDetails: 'Phi-2 über MLC LLM Engine',
      description: 'Kleines, aber sehr gutes Modell für alle Plattformen',
      maxTokens: 2048,
      useCases: ['Quick Responses', 'Mobile Apps', 'Web Apps'],
      scientificAccuracy: 'MLC LLM bietet Phi-2 mit optimierter Performance für schnelle Antworten',
      category: 'offline',
    ),

    // === OPENROUTER MODELS ===
    'openrouter-gpt-4': AIModel(
      id: 'openrouter-gpt-4',
      name: 'GPT-4 (via OpenRouter)',
      provider: 'OpenRouter',
      providerIcon: 'assets/icons/openrouter.png',
      cost: 'Bezahlt',
      costDetails: '15.00€ pro 1M Input Tokens',
      speed: 'Mittel',
      speedDetails: '~3-5s Antwortzeit',
      quality: 'Exzellent',
      qualityDetails: 'GPT-4 über OpenRouter API',
      description: 'GPT-4 über OpenRouter - günstiger als direkt',
      maxTokens: 8192,
      useCases: ['Complex Game Design', 'Advanced Analysis', 'Final Concepts'],
      scientificAccuracy: 'OpenRouter bietet GPT-4 zu reduzierten Preisen mit vereinfachter API',
      category: 'cloud',
    ),
    'openrouter-claude-3-5-sonnet': AIModel(
      id: 'openrouter-claude-3-5-sonnet',
      name: 'Claude 3.5 Sonnet (via OpenRouter)',
      provider: 'OpenRouter',
      providerIcon: 'assets/icons/openrouter.png',
      cost: 'Bezahlt',
      costDetails: '3.00€ pro 1M Input Tokens',
      speed: 'Mittel',
      speedDetails: '~2-3s Antwortzeit',
      quality: 'Exzellent',
      qualityDetails: 'Claude 3.5 Sonnet über OpenRouter',
      description: 'Claude 3.5 Sonnet über OpenRouter - vereinfachter Zugang',
      maxTokens: 16384,
      useCases: ['Creative Writing', 'Story Development', 'Character Design'],
      scientificAccuracy: 'OpenRouter bietet Claude 3.5 Sonnet mit einheitlicher API und günstigeren Preisen',
      category: 'cloud',
    ),
    'openrouter-gemini-1-5-pro': AIModel(
      id: 'openrouter-gemini-1-5-pro',
      name: 'Gemini 1.5 Pro (via OpenRouter)',
      provider: 'OpenRouter',
      providerIcon: 'assets/icons/openrouter.png',
      cost: 'Bezahlt',
      costDetails: '2.50€ pro 1M Input Tokens',
      speed: 'Mittel',
      speedDetails: '~2-3s Antwortzeit',
      quality: 'Sehr gut',
      qualityDetails: 'Gemini 1.5 Pro über OpenRouter',
      description: 'Gemini 1.5 Pro über OpenRouter - günstiger als direkt',
      maxTokens: 32768,
      useCases: ['Complex Game Design', 'Story Development', 'Technical Specifications'],
      scientificAccuracy: 'OpenRouter bietet Gemini 1.5 Pro mit vereinfachter API und reduzierten Kosten',
      category: 'cloud',
    ),
    'openrouter-llama3-70b': AIModel(
      id: 'openrouter-llama3-70b',
      name: 'Llama 3 70B (via OpenRouter)',
      provider: 'OpenRouter',
      providerIcon: 'assets/icons/openrouter.png',
      cost: 'Bezahlt',
      costDetails: '0.80€ pro 1M Input Tokens',
      speed: 'Schnell',
      speedDetails: '~1-2s Antwortzeit',
      quality: 'Sehr gut',
      qualityDetails: 'Llama 3 70B über OpenRouter',
      description: 'Llama 3 70B über OpenRouter - Open Source Qualität',
      maxTokens: 8192,
      useCases: ['Game Design', 'Content Generation', 'Analysis'],
      scientificAccuracy: 'OpenRouter bietet Llama 3 70B mit professioneller Infrastruktur und günstigen Preisen',
      category: 'cloud',
    ),
  };

  // User API Keys
  Map<String, String> _userApiKeys = {};
  
  // Modell-Einstellungen
  Map<String, String> _modelSettings = {
    'chat': 'gemini-1.5-flash',
    'concept_generation': 'gemini-1.5-flash',
    'research': 'claude-3-5-sonnet',
    'code_generation': 'gpt-4',
  };

  // Cost Calculation Service
  final AICostCalculationService _costService = AICostCalculationService();

  // Getters
  Map<String, AIModel> get availableModels => _availableModels;
  Map<String, String> get userApiKeys => _userApiKeys;
  Map<String, String> get modelSettings => _modelSettings;

  /// Privater Konstruktor, um direkte Instanziierung zu verhindern.
  AISettingsService._internal();

  /// Asynchrone Factory-Methode zur Erstellung und Initialisierung des Service.
  /// Stellt sicher, dass die Einstellungen geladen sind, bevor der Service verwendet wird.
  static Future<AISettingsService> create() async {
    try {
      final service = AISettingsService._internal();
      await service.loadSettings();
      return service;
    } catch (e) {
      debugPrint('Error creating AISettingsService: $e');
      // Return a service with default settings if initialization fails
      final service = AISettingsService._internal();
      // Don't call loadSettings() again to avoid infinite recursion
      return service;
    }
  }

  /// Lädt gespeicherte Einstellungen. Sollte nur intern aufgerufen werden.
  @visibleForTesting
  Future<void> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Lade API Keys
      final apiKeysJson = prefs.getString(_apiKeysKey);
      if (apiKeysJson != null) {
        try {
          final apiKeysMap = jsonDecode(apiKeysJson) as Map<String, dynamic>;
          _userApiKeys = Map<String, String>.from(apiKeysMap);
        } catch (e) {
          debugPrint('Failed to load API keys: $e');
          _userApiKeys = {}; // Reset to empty if parsing fails
        }
      }
      
      // Lade Modell-Einstellungen
      final modelSettingsJson = prefs.getString(_modelSettingsKey);
      if (modelSettingsJson != null) {
        try {
          final modelSettingsMap = jsonDecode(modelSettingsJson) as Map<String, dynamic>;
          _modelSettings = Map<String, String>.from(modelSettingsMap);
        } catch (e) {
          debugPrint('Failed to load model settings: $e');
          // Reset to defaults if parsing fails
          _modelSettings = {
            'chat': 'gemini-1.5-flash',
            'concept_generation': 'gemini-1.5-flash',
            'research': 'claude-3-5-sonnet',
            'code_generation': 'gpt-4',
          };
        }
      }
    } catch (e) {
      debugPrint('Error loading settings: $e');
      // Ensure we have default values even if loading fails
      _userApiKeys = {};
      _modelSettings = {
        'chat': 'gemini-1.5-flash',
        'concept_generation': 'gemini-1.5-flash',
        'research': 'claude-3-5-sonnet',
        'code_generation': 'gpt-4',
      };
    }
  }

  /// Speichert Einstellungen
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Speichere API Keys
    await prefs.setString(_apiKeysKey, jsonEncode(_userApiKeys));
    
    // Speichere Modell-Einstellungen
    await prefs.setString(_modelSettingsKey, jsonEncode(_modelSettings));
  }

  /// Setzt API Key für einen Provider
  Future<void> setApiKey(String provider, String apiKey) async {
    _userApiKeys[provider] = apiKey;
    await _saveSettings();
  }

  /// Entfernt API Key für einen Provider
  Future<void> removeApiKey(String provider) async {
    _userApiKeys.remove(provider);
    await _saveSettings();
  }

  /// Prüft ob API Key für Provider verfügbar ist
  bool hasApiKey(String provider) {
    final key = _userApiKeys[provider];
    return key != null && key.isNotEmpty;
  }

  /// Gibt API Key für Provider zurück
  String? getApiKey(String provider) {
    return _userApiKeys[provider];
  }

  /// Setzt Modell für eine Kategorie
  Future<void> setModelForCategory(String category, String modelId) async {
    if (!_availableModels.containsKey(modelId)) {
      throw ArgumentError('Unknown model: $modelId');
    }
    
    _modelSettings[category] = modelId;
    await _saveSettings();
  }

  /// Gibt Modell für Kategorie zurück
  String getModelForCategory(String category) {
    return _modelSettings[category] ?? 'gemini-1.5-flash';
  }

  /// Gibt Modell-Info für Kategorie zurück
  AIModel getModelInfoForCategory(String category) {
    final modelId = getModelForCategory(category);
    return _availableModels[modelId] ?? _availableModels['gemini-1.5-flash']!;
  }

  /// Gibt Cost Calculation Service zurück
  AICostCalculationService get costService => _costService;

  /// Schätzt Kosten für eine Anfrage
  double estimateRequestCost({
    required String category,
    required String inputText,
    String? expectedOutputLength,
  }) {
    final modelId = getModelForCategory(category);
    return _costService.estimateRequestCost(
      modelId: modelId,
      inputText: inputText,
      expectedOutputLength: expectedOutputLength,
    );
  }

  /// Registriert eine ausgeführte Anfrage
  Future<void> recordRequest({
    required String category,
    required String requestType,
    required int inputTokens,
    required int outputTokens,
    required double cost,
    required int durationMs,
    String? userId,
  }) async {
    final modelId = getModelForCategory(category);
    await _costService.recordRequest(
      modelId: modelId,
      requestType: requestType,
      inputTokens: inputTokens,
      outputTokens: outputTokens,
      cost: cost,
      durationMs: durationMs,
      userId: userId,
    );
  }

  /// Prüft ob Modell für Kategorie verfügbar ist
  bool isModelAvailable(String modelId) {
    final model = _availableModels[modelId];
    if (model == null) return false;
    
    // Prüfe ob API Key für Provider verfügbar ist
    return hasApiKey(model.provider.toLowerCase());
  }

  /// Gibt verfügbare Modelle für Kategorie zurück
  List<AIModel> getAvailableModelsForCategory(String category) {
    return _availableModels.values.where((model) => isModelAvailable(model.id)).toList();
  }

  /// Exportiert Einstellungen
  Future<String> exportSettings() async {
    final settings = {
      'apiKeys': _userApiKeys,
      'modelSettings': _modelSettings,
      'exportDate': DateTime.now().toIso8601String(),
    };
    return jsonEncode(settings);
  }

  /// Importiert Einstellungen
  Future<void> importSettings(String jsonData) async {
    try {
      final data = jsonDecode(jsonData) as Map<String, dynamic>;
      
      if (data['apiKeys'] != null) {
        final apiKeysMap = data['apiKeys'] as Map<String, dynamic>;
        _userApiKeys = Map<String, String>.from(apiKeysMap);
      }
      
      if (data['modelSettings'] != null) {
        final modelSettingsMap = data['modelSettings'] as Map<String, dynamic>;
        _modelSettings = Map<String, String>.from(modelSettingsMap);
      }
      
      await _saveSettings();
    } catch (e) {
      throw Exception('Invalid settings data: $e');
    }
  }

  /// Setzt Einstellungen zurück
  Future<void> resetSettings() async {
    _userApiKeys.clear();
    _modelSettings = {
      'chat': 'gemini-1.5-flash',
      'concept_generation': 'gemini-1.5-flash',
      'research': 'claude-3-5-sonnet',
      'code_generation': 'gpt-4',
    };
    await _saveSettings();
  }
}

/// AI Modell Information - Wissenschaftlich fundiert und strukturiert
class AIModel {
  final String id;
  final String name;
  final String provider;
  final String providerIcon;
  final String cost;
  final String costDetails;
  final String speed;
  final String speedDetails;
  final String quality;
  final String qualityDetails;
  final String description;
  final int maxTokens;
  final List<String> useCases;
  final String scientificAccuracy;
  final String category; // 'offline', 'cloud', 'direct'

  const AIModel({
    required this.id,
    required this.name,
    required this.provider,
    required this.providerIcon,
    required this.cost,
    required this.costDetails,
    required this.speed,
    required this.speedDetails,
    required this.quality,
    required this.qualityDetails,
    required this.description,
    required this.maxTokens,
    required this.useCases,
    required this.scientificAccuracy,
    this.category = 'direct', // Default to direct for backward compatibility
  });

  // Helper methods for category management
  bool get isOffline => category == 'offline';
  bool get isCloud => category == 'cloud';
  bool get isDirect => category == 'direct';
  
  String get categoryDisplayName {
    switch (category) {
      case 'offline':
        return 'Offline (MLC LLM)';
      case 'cloud':
        return 'Cloud (OpenRouter)';
      case 'direct':
        return 'Direct (Gemini)';
      default:
        return 'Unknown';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'provider': provider,
      'providerIcon': providerIcon,
      'cost': cost,
      'costDetails': costDetails,
      'speed': speed,
      'speedDetails': speedDetails,
      'quality': quality,
      'qualityDetails': qualityDetails,
      'description': description,
      'maxTokens': maxTokens,
      'useCases': useCases,
      'scientificAccuracy': scientificAccuracy,
    };
  }

  factory AIModel.fromJson(Map<String, dynamic> json) {
    return AIModel(
      id: json['id'],
      name: json['name'],
      provider: json['provider'],
      providerIcon: json['providerIcon'],
      cost: json['cost'],
      costDetails: json['costDetails'],
      speed: json['speed'],
      speedDetails: json['speedDetails'],
      quality: json['quality'],
      qualityDetails: json['qualityDetails'],
      description: json['description'],
      maxTokens: json['maxTokens'],
      useCases: List<String>.from(json['useCases']),
      scientificAccuracy: json['scientificAccuracy'],
    );
  }
} 