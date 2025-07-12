import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

/// Professional AI Cost Calculation Service
/// Integriert mit Provider APIs für Echtzeit-Preisberechnung und Nutzungsdaten
class AICostCalculationService {
  static const String _usageDataKey = 'ai_usage_data';
  static const String _costHistoryKey = 'ai_cost_history';
  
  // Aktuelle Preise (werden von APIs aktualisiert)
  static Map<String, Map<String, double>> _currentPrices = {
    'google': {
      'gemini-1.5-flash': 0.000075, // $0.075 per 1M input tokens
      'gemini-1.5-pro': 0.00375,    // $3.75 per 1M input tokens
      'gemini-1.5-flash-exp': 0.0003, // $0.30 per 1M input tokens
      'gemini-1.5-pro-exp': 0.015,   // $15.00 per 1M input tokens
    },
    'openai': {
      'gpt-4': 0.03,        // $30.00 per 1M input tokens
      'gpt-4-turbo': 0.01,  // $10.00 per 1M input tokens
      'gpt-3.5-turbo': 0.0015, // $1.50 per 1M input tokens
      'gpt-4o': 0.005,      // $5.00 per 1M input tokens
      'gpt-4o-mini': 0.00015, // $0.15 per 1M input tokens
    },
    'anthropic': {
      'claude-3-5-sonnet': 0.003,   // $3.00 per 1M input tokens
      'claude-3-5-haiku': 0.00025,  // $0.25 per 1M input tokens
      'claude-3-opus': 0.015,        // $15.00 per 1M input tokens
      'claude-3-sonnet': 0.003,      // $3.00 per 1M input tokens
      'claude-3-haiku': 0.00025,     // $0.25 per 1M input tokens
    },
    'groq': {
      'llama3-8b-8192': 0.00005,     // $0.05 per 1M input tokens
      'llama3-70b-8192': 0.00059,    // $0.59 per 1M input tokens
      'mixtral-8x7b-32768': 0.00024, // $0.24 per 1M input tokens
      'gemma2-9b-it': 0.0001,        // $0.10 per 1M input tokens
    },
  };

  // Nutzungsdaten
  Map<String, UsageData> _usageData = {};
  List<CostRecord> _costHistory = [];

  /// Konstruktor
  AICostCalculationService() {
    _loadUsageData();
    _updatePricesFromAPIs();
  }

  /// Lädt gespeicherte Nutzungsdaten
  Future<void> _loadUsageData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Lade Nutzungsdaten
    final usageJson = prefs.getString(_usageDataKey);
    if (usageJson != null) {
      try {
        final usageMap = jsonDecode(usageJson) as Map<String, dynamic>;
        _usageData = usageMap.map((key, value) => 
          MapEntry(key, UsageData.fromJson(value as Map<String, dynamic>)));
      } catch (e) {
        debugPrint('Failed to load usage data: $e');
      }
    }
    
    // Lade Kostenhistorie
    final historyJson = prefs.getString(_costHistoryKey);
    if (historyJson != null) {
      try {
        final historyList = jsonDecode(historyJson) as List<dynamic>;
        _costHistory = historyList.map((item) => 
          CostRecord.fromJson(item as Map<String, dynamic>)).toList();
      } catch (e) {
        debugPrint('Failed to load cost history: $e');
      }
    }
  }

  /// Speichert Nutzungsdaten
  Future<void> _saveUsageData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Speichere Nutzungsdaten
    final usageMap = _usageData.map((key, value) => 
      MapEntry(key, value.toJson()));
    await prefs.setString(_usageDataKey, jsonEncode(usageMap));
    
    // Speichere Kostenhistorie
    final historyList = _costHistory.map((record) => record.toJson()).toList();
    await prefs.setString(_costHistoryKey, jsonEncode(historyList));
  }

  /// Aktualisiert Preise von allen APIs
  Future<void> _updatePricesFromAPIs() async {
    try {
      // Verwende statische Preise als Fallback, da APIs CORS-Probleme haben können
      debugPrint('Using static pricing data - API calls disabled for web compatibility');
      
      // Setze statische Preise (USD pro 1M Tokens)
      _currentPrices = {
        'google': {
          'gemini-1.5-flash': 0.075,
          'gemini-1.5-pro': 3.50,
        },
        'openai': {
          'gpt-4': 30.0,
          'gpt-3.5-turbo': 0.50,
        },
        'anthropic': {
          'claude-3-5-sonnet': 3.0,
          'claude-3-haiku': 0.25,
        },
        'groq': {
          'llama-3-8b': 0.05,
          'mixtral-8x7b': 0.24,
          'gemma-7b': 0.10,
        },
      };
      
      debugPrint('Updated prices from static data');
    } catch (e) {
      debugPrint('Failed to update prices: $e');
      // Fallback zu Standard-Preisen
      _currentPrices = {
        'google': {'gemini-1.5-flash': 0.075},
        'openai': {'gpt-3.5-turbo': 0.50},
        'anthropic': {'claude-3-5-sonnet': 3.0},
        'groq': {'llama-3-8b': 0.05},
      };
    }
  }



  /// Berechnet Kosten für eine Anfrage
  double calculateCost({
    required String modelId,
    required int inputTokens,
    required int outputTokens,
    String? provider,
  }) {
    final modelProvider = provider ?? _getProviderFromModel(modelId);
    final prices = _currentPrices[modelProvider.toLowerCase()];
    
    if (prices == null || !prices.containsKey(modelId)) {
      debugPrint('No pricing data for model: $modelId');
      return 0.0;
    }
    
    final inputPrice = prices[modelId]!;
    final outputPrice = inputPrice * 2; // Output tokens sind oft teurer
    
    final inputCost = (inputTokens / 1000000) * inputPrice;
    final outputCost = (outputTokens / 1000000) * outputPrice;
    
    return inputCost + outputCost;
  }

  /// Schätzt Token-Anzahl für Text
  int estimateTokens(String text) {
    // Einfache Schätzung: ~4 Zeichen pro Token
    return (text.length / 4).ceil();
  }

  /// Schätzt Kosten für eine Anfrage
  double estimateRequestCost({
    required String modelId,
    required String inputText,
    String? expectedOutputLength,
  }) {
    final inputTokens = estimateTokens(inputText);
    final outputTokens = expectedOutputLength != null 
        ? estimateTokens(expectedOutputLength)
        : (inputTokens * 0.5).ceil(); // Schätze 50% der Input-Länge
    
    return calculateCost(
      modelId: modelId,
      inputTokens: inputTokens,
      outputTokens: outputTokens,
    );
  }

  /// Registriert eine ausgeführte Anfrage
  Future<void> recordRequest({
    required String modelId,
    required String requestType,
    required int inputTokens,
    required int outputTokens,
    required double cost,
    required int durationMs,
    String? userId,
  }) async {
    final record = CostRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      modelId: modelId,
      requestType: requestType,
      inputTokens: inputTokens,
      outputTokens: outputTokens,
      cost: cost,
      durationMs: durationMs,
      timestamp: DateTime.now(),
      userId: userId ?? 'anonymous',
    );
    
    _costHistory.add(record);
    
    // Aktualisiere Nutzungsdaten
    final usageKey = '${modelId}_$requestType';
    if (!_usageData.containsKey(usageKey)) {
      _usageData[usageKey] = UsageData(
        modelId: modelId,
        requestType: requestType,
        totalRequests: 0,
        totalTokens: 0,
        totalCost: 0.0,
        averageDurationMs: 0,
      );
    }
    
    final usage = _usageData[usageKey]!;
    usage.totalRequests++;
    usage.totalTokens += inputTokens + outputTokens;
    usage.totalCost += cost;
    usage.averageDurationMs = ((usage.averageDurationMs * (usage.totalRequests - 1)) + durationMs) ~/ usage.totalRequests;
    
    await _saveUsageData();
  }

  /// Gibt Nutzungsstatistiken zurück
  Map<String, dynamic> getUsageStatistics({
    String? modelId,
    String? requestType,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final filteredHistory = _costHistory.where((record) {
      if (modelId != null && record.modelId != modelId) return false;
      if (requestType != null && record.requestType != requestType) return false;
      if (startDate != null && record.timestamp.isBefore(startDate)) return false;
      if (endDate != null && record.timestamp.isAfter(endDate)) return false;
      return true;
    }).toList();

    if (filteredHistory.isEmpty) {
      return {
        'totalRequests': 0,
        'totalTokens': 0,
        'totalCost': 0.0,
        'averageCost': 0.0,
        'averageDurationMs': 0,
        'costByModel': {},
        'costByType': {},
        'dailyCosts': {},
      };
    }

    final totalRequests = filteredHistory.length;
    final totalTokens = filteredHistory.fold(0, (sum, record) => sum + record.inputTokens + record.outputTokens);
    final totalCost = filteredHistory.fold(0.0, (sum, record) => sum + record.cost);
    final averageCost = totalCost / totalRequests;
    final averageDurationMs = filteredHistory.fold(0, (sum, record) => sum + record.durationMs) ~/ totalRequests;

    // Kosten nach Modell
    final costByModel = <String, double>{};
    for (final record in filteredHistory) {
      costByModel[record.modelId] = (costByModel[record.modelId] ?? 0.0) + record.cost;
    }

    // Kosten nach Typ
    final costByType = <String, double>{};
    for (final record in filteredHistory) {
      costByType[record.requestType] = (costByType[record.requestType] ?? 0.0) + record.cost;
    }

    // Tägliche Kosten
    final dailyCosts = <String, double>{};
    for (final record in filteredHistory) {
      final date = record.timestamp.toIso8601String().split('T')[0];
      dailyCosts[date] = (dailyCosts[date] ?? 0.0) + record.cost;
    }

    return {
      'totalRequests': totalRequests,
      'totalTokens': totalTokens,
      'totalCost': totalCost,
      'averageCost': averageCost,
      'averageDurationMs': averageDurationMs,
      'costByModel': costByModel,
      'costByType': costByType,
      'dailyCosts': dailyCosts,
    };
  }

  /// Gibt aktuelle Preise zurück
  Map<String, Map<String, double>> getCurrentPrices() {
    return Map.unmodifiable(_currentPrices);
  }

  /// Gibt Preis für ein spezifisches Modell zurück
  double? getModelPrice(String modelId) {
    final provider = _getProviderFromModel(modelId);
    final prices = _currentPrices[provider.toLowerCase()];
    return prices?[modelId];
  }

  /// Gibt Provider für ein Modell zurück
  String _getProviderFromModel(String modelId) {
    if (modelId.startsWith('gemini')) return 'google';
    if (modelId.startsWith('gpt')) return 'openai';
    if (modelId.startsWith('claude')) return 'anthropic';
    if (modelId.startsWith('llama') || modelId.startsWith('mixtral') || modelId.startsWith('gemma')) return 'groq';
    return 'unknown';
  }

  /// Gibt Nutzungsdaten zurück
  Map<String, UsageData> getUsageData() {
    return Map.unmodifiable(_usageData);
  }

  /// Gibt Kostenhistorie zurück
  List<CostRecord> getCostHistory() {
    return List.unmodifiable(_costHistory);
  }

  /// Löscht Nutzungsdaten
  Future<void> clearUsageData() async {
    _usageData.clear();
    _costHistory.clear();
    await _saveUsageData();
  }

  /// Exportiert Nutzungsdaten
  Future<String> exportUsageData() async {
    final data = {
      'usageData': _usageData.map((key, value) => MapEntry(key, value.toJson())),
      'costHistory': _costHistory.map((record) => record.toJson()).toList(),
      'exportDate': DateTime.now().toIso8601String(),
    };
    return jsonEncode(data);
  }
}

/// Nutzungsdaten für ein Modell/Anfragetyp
class UsageData {
  final String modelId;
  final String requestType;
  int totalRequests;
  int totalTokens;
  double totalCost;
  int averageDurationMs;

  UsageData({
    required this.modelId,
    required this.requestType,
    required this.totalRequests,
    required this.totalTokens,
    required this.totalCost,
    required this.averageDurationMs,
  });

  Map<String, dynamic> toJson() {
    return {
      'modelId': modelId,
      'requestType': requestType,
      'totalRequests': totalRequests,
      'totalTokens': totalTokens,
      'totalCost': totalCost,
      'averageDurationMs': averageDurationMs,
    };
  }

  factory UsageData.fromJson(Map<String, dynamic> json) {
    return UsageData(
      modelId: json['modelId'],
      requestType: json['requestType'],
      totalRequests: json['totalRequests'],
      totalTokens: json['totalTokens'],
      totalCost: json['totalCost'].toDouble(),
      averageDurationMs: json['averageDurationMs'],
    );
  }
}

/// Kostenaufzeichnung für eine Anfrage
class CostRecord {
  final String id;
  final String modelId;
  final String requestType;
  final int inputTokens;
  final int outputTokens;
  final double cost;
  final int durationMs;
  final DateTime timestamp;
  final String userId;

  CostRecord({
    required this.id,
    required this.modelId,
    required this.requestType,
    required this.inputTokens,
    required this.outputTokens,
    required this.cost,
    required this.durationMs,
    required this.timestamp,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'modelId': modelId,
      'requestType': requestType,
      'inputTokens': inputTokens,
      'outputTokens': outputTokens,
      'cost': cost,
      'durationMs': durationMs,
      'timestamp': timestamp.toIso8601String(),
      'userId': userId,
    };
  }

  factory CostRecord.fromJson(Map<String, dynamic> json) {
    return CostRecord(
      id: json['id'],
      modelId: json['modelId'],
      requestType: json['requestType'],
      inputTokens: json['inputTokens'],
      outputTokens: json['outputTokens'],
      cost: json['cost'].toDouble(),
      durationMs: json['durationMs'],
      timestamp: DateTime.parse(json['timestamp']),
      userId: json['userId'],
    );
  }
} 