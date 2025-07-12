import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:project_jambam/src/core/logger.dart';
import 'ai_settings_service.dart';

/// Chat-Nachricht
class ChatMessage {
  final String id;
  final String content;
  final String role; // 'user' oder 'assistant'
  final DateTime timestamp;
  final String? modelUsed;
  final String? providerUsed;

  ChatMessage({
    required this.id,
    required this.content,
    required this.role,
    required this.timestamp,
    this.modelUsed,
    this.providerUsed,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'role': role,
      'timestamp': timestamp.toIso8601String(),
      'modelUsed': modelUsed,
      'providerUsed': providerUsed,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      content: json['content'],
      role: json['role'],
      timestamp: DateTime.parse(json['timestamp']),
      modelUsed: json['modelUsed'],
      providerUsed: json['providerUsed'],
    );
  }
}

/// Chat-Session
class ChatSession {
  final String id;
  final String title;
  final List<ChatMessage> messages;
  final DateTime createdAt;
  final DateTime lastUpdated;
  final String category; // 'chat', 'concept_generation', 'research', 'code_generation'

  ChatSession({
    required this.id,
    required this.title,
    required this.messages,
    required this.createdAt,
    required this.lastUpdated,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'messages': messages.map((m) => m.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'lastUpdated': lastUpdated.toIso8601String(),
      'category': category,
    };
  }

  factory ChatSession.fromJson(Map<String, dynamic> json) {
    return ChatSession(
      id: json['id'],
      title: json['title'],
      messages: (json['messages'] as List)
          .map((m) => ChatMessage.fromJson(m))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      lastUpdated: DateTime.parse(json['lastUpdated']),
      category: json['category'],
    );
  }
}

/// Enhanced Chat Service
/// Nutzt User-spezifische API Keys und Modell-Auswahl
class EnhancedChatService {
  final Logger _logger = Logger('EnhancedChatService');
  final AISettingsService _aiSettings;

  EnhancedChatService(this._aiSettings);

  /// Sendet Nachricht und erhält Antwort
  Future<ChatMessage> sendMessage({
    required String message,
    required String sessionId,
    String? category,
  }) async {
    _logger.info('Sending message: $message');
    
    final chatCategory = category ?? 'chat';
    final modelId = _aiSettings.getModelForCategory(chatCategory);
    final modelInfo = _aiSettings.getModelInfoForCategory(chatCategory);
    
    if (!_aiSettings.isModelAvailable(modelId)) {
      throw Exception('Kein verfügbares Modell für Kategorie: $chatCategory');
    }

    final startTime = DateTime.now();
    int inputTokens = 0;
    int outputTokens = 0;
    double cost = 0.0;

    try {
      ChatMessage response;
      
      switch (modelInfo.provider.toLowerCase()) {
        case 'google':
          response = await _sendToGoogle(message, modelId, modelInfo);
          break;
        case 'openai':
          response = await _sendToOpenAI(message, modelId, modelInfo);
          break;
        case 'anthropic':
          response = await _sendToAnthropic(message, modelId, modelInfo);
          break;
        case 'groq':
          response = await _sendToGroq(message, modelId, modelInfo);
          break;
        default:
          throw Exception('Unbekannter Provider: ${modelInfo.provider}');
      }

      // Berechne Token und Kosten
      inputTokens = _aiSettings.costService.estimateTokens(message);
      outputTokens = _aiSettings.costService.estimateTokens(response.content);
      cost = _aiSettings.costService.calculateCost(
        modelId: modelId,
        inputTokens: inputTokens,
        outputTokens: outputTokens,
      );

      // Registriere die Anfrage
      final durationMs = DateTime.now().difference(startTime).inMilliseconds;
      await _aiSettings.recordRequest(
        category: chatCategory,
        requestType: 'chat',
        inputTokens: inputTokens,
        outputTokens: outputTokens,
        cost: cost,
        durationMs: durationMs,
      );

      _logger.info('Received response from ${modelInfo.provider}');
      return response;
      
    } catch (e) {
      _logger.error('Error sending message: $e');
      throw Exception('Fehler beim Senden der Nachricht: $e');
    }
  }

  /// Sendet an Google Gemini
  Future<ChatMessage> _sendToGoogle(String message, String modelId, AIModel modelInfo) async {
    final apiKey = _aiSettings.getApiKey('google');
    if (apiKey == null) {
      throw Exception('Kein Google API Key konfiguriert');
    }

    final generativeModel = GenerativeModel(
      model: modelId,
      apiKey: apiKey,
    );

    final content = [Content.text(message)];
    final response = await generativeModel.generateContent(content);
    final responseText = response.text?.trim() ?? 'Keine Antwort erhalten';

    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: responseText,
      role: 'assistant',
      timestamp: DateTime.now(),
      modelUsed: modelId,
      providerUsed: 'Google',
    );
  }

  /// Sendet an OpenAI
  Future<ChatMessage> _sendToOpenAI(String message, String modelId, AIModel modelInfo) async {
    final apiKey = _aiSettings.getApiKey('openai');
    if (apiKey == null) {
      throw Exception('Kein OpenAI API Key konfiguriert');
    }

    final url = Uri.parse('https://api.openai.com/v1/chat/completions');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    final body = {
      'model': modelId,
      'messages': [
        {'role': 'user', 'content': message}
      ],
      'max_tokens': modelInfo.maxTokens,
      'temperature': 0.7,
    };

    final response = await http.post(url, headers: headers, body: jsonEncode(body));
    
    if (response.statusCode != 200) {
      throw Exception('OpenAI API Fehler: ${response.statusCode}');
    }

    final responseData = jsonDecode(response.body);
    final responseText = responseData['choices'][0]['message']['content'] ?? 'Keine Antwort erhalten';

    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: responseText,
      role: 'assistant',
      timestamp: DateTime.now(),
      modelUsed: modelId,
      providerUsed: 'OpenAI',
    );
  }

  /// Sendet an Anthropic Claude
  Future<ChatMessage> _sendToAnthropic(String message, String modelId, AIModel modelInfo) async {
    final apiKey = _aiSettings.getApiKey('anthropic');
    if (apiKey == null) {
      throw Exception('Kein Anthropic API Key konfiguriert');
    }

    final url = Uri.parse('https://api.anthropic.com/v1/messages');
    final headers = {
      'Content-Type': 'application/json',
      'x-api-key': apiKey,
      'anthropic-version': '2023-06-01',
    };

    final body = {
      'model': modelId,
      'max_tokens': modelInfo.maxTokens,
      'messages': [
        {'role': 'user', 'content': message}
      ],
    };

    final response = await http.post(url, headers: headers, body: jsonEncode(body));
    
    if (response.statusCode != 200) {
      throw Exception('Anthropic API Fehler: ${response.statusCode}');
    }

    final responseData = jsonDecode(response.body);
    final responseText = responseData['content'][0]['text'] ?? 'Keine Antwort erhalten';

    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: responseText,
      role: 'assistant',
      timestamp: DateTime.now(),
      modelUsed: modelId,
      providerUsed: 'Anthropic',
    );
  }

  /// Sendet an Groq
  Future<ChatMessage> _sendToGroq(String message, String modelId, AIModel modelInfo) async {
    final apiKey = _aiSettings.getApiKey('groq');
    if (apiKey == null) {
      throw Exception('Kein Groq API Key konfiguriert');
    }

    final url = Uri.parse('https://api.groq.com/openai/v1/chat/completions');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    final body = {
      'model': modelId,
      'messages': [
        {'role': 'user', 'content': message}
      ],
      'max_tokens': modelInfo.maxTokens,
      'temperature': 0.7,
    };

    final response = await http.post(url, headers: headers, body: jsonEncode(body));
    
    if (response.statusCode != 200) {
      throw Exception('Groq API Fehler: ${response.statusCode}');
    }

    final responseData = jsonDecode(response.body);
    final responseText = responseData['choices'][0]['message']['content'] ?? 'Keine Antwort erhalten';

    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: responseText,
      role: 'assistant',
      timestamp: DateTime.now(),
      modelUsed: modelId,
      providerUsed: 'Groq',
    );
  }

  /// Erstellt neue Chat-Session
  ChatSession createSession({
    required String title,
    required String category,
  }) {
    return ChatSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      messages: [],
      createdAt: DateTime.now(),
      lastUpdated: DateTime.now(),
      category: category,
    );
  }

  /// Fügt Nachricht zu Session hinzu
  ChatSession addMessageToSession(ChatSession session, ChatMessage message) {
    final updatedMessages = List<ChatMessage>.from(session.messages)..add(message);
    
    return ChatSession(
      id: session.id,
      title: session.title,
      messages: updatedMessages,
      createdAt: session.createdAt,
      lastUpdated: DateTime.now(),
      category: session.category,
    );
  }

  /// Gibt verfügbare Modelle für Kategorie zurück
  List<AIModel> getAvailableModelsForCategory(String category) {
    return _aiSettings.getAvailableModelsForCategory(category);
  }

  /// Prüft ob Modell für Kategorie verfügbar ist
  bool isModelAvailable(String modelId) {
    return _aiSettings.isModelAvailable(modelId);
  }

  /// Gibt aktuelle Modell-Info für Kategorie zurück
  AIModel getCurrentModelInfo(String category) {
    return _aiSettings.getModelInfoForCategory(category);
  }
} 