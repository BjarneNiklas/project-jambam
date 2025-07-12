import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

/// Service für lokale AI-Modelle (Offline-Modus)
class OfflineAIService {
  static const String _modelsDir = 'offline_models';
  static const Map<String, String> _modelUrls = {
    'gemma-2b': 'https://huggingface.co/google/gemma-2b-it/resolve/main/model.safetensors',
    'mistral-7b': 'https://huggingface.co/mistralai/Mistral-7B-Instruct-v0.2/resolve/main/model.safetensors',
    'llama3-8b': 'https://huggingface.co/meta-llama/Llama-3-8B-Instruct/resolve/main/model.safetensors',
  };

  static const Map<String, Map<String, dynamic>> _modelConfigs = {
    'gemma-2b': {
      'name': 'Gemma 2B',
      'provider': 'Google',
      'parameters': '2B',
      'context_length': 8192,
      'download_size': '4.2 GB',
      'ram_required': '4 GB',
    },
    'mistral-7b': {
      'name': 'Mistral 7B',
      'provider': 'Mistral AI',
      'parameters': '7B',
      'context_length': 32768,
      'download_size': '14.2 GB',
      'ram_required': '8 GB',
    },
    'llama3-8b': {
      'name': 'Llama 3 8B',
      'provider': 'Meta',
      'parameters': '8B',
      'context_length': 8192,
      'download_size': '16.1 GB',
      'ram_required': '8 GB',
    },
  };

  /// Prüft ob ein Modell lokal verfügbar ist
  Future<bool> isModelAvailable(String modelId) async {
    try {
      await _getModelsDirectory();
      return true; // Simplified for now
    } catch (e) {
      debugPrint('Error checking model availability: $e');
      return false;
    }
  }

  /// Lädt ein Modell herunter
  Future<bool> downloadModel(String modelId) async {
    try {
      if (!_modelUrls.containsKey(modelId)) {
        throw Exception('Model $modelId not supported for offline use');
      }

      final dir = await _getModelsDirectory();
      final modelDir = Directory('${dir.path}/$modelId');
      await modelDir.create(recursive: true);

      final url = _modelUrls[modelId]!;
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final file = File('${modelDir.path}/model.safetensors');
        await file.writeAsBytes(response.bodyBytes);
        
        // Speichere Konfiguration
        final configFile = File('${modelDir.path}/config.json');
        await configFile.writeAsString(jsonEncode(_modelConfigs[modelId]));
        
        debugPrint('Model $modelId downloaded successfully');
        return true;
      } else {
        throw Exception('Failed to download model: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error downloading model $modelId: $e');
      return false;
    }
  }

  /// Generiert Text mit lokalem Modell
  Future<String> generateText({
    required String modelId,
    required String prompt,
    int maxTokens = 512,
    double temperature = 0.7,
  }) async {
    try {
      if (!await isModelAvailable(modelId)) {
        throw Exception('Model $modelId not available locally');
      }

      // Für jetzt: Simulierte lokale Generierung
      // In einer echten Implementierung würde hier die lokale AI-Engine verwendet
      await Future.delayed(Duration(milliseconds: 1000 + (prompt.length * 10)));
      
      return _simulateLocalGeneration(prompt, modelId);
    } catch (e) {
      debugPrint('Error generating text with local model: $e');
      rethrow;
    }
  }

  /// Simuliert lokale Text-Generierung (Platzhalter)
  String _simulateLocalGeneration(String prompt, String modelId) {
    final responses = {
      'gemma-2b': [
        'Basierend auf deiner Anfrage kann ich folgende Antwort generieren...',
        'Hier ist eine lokale Antwort von Gemma 2B...',
        'Gemma 2B lokal verarbeitet: ${prompt.substring(0, prompt.length > 50 ? 50 : prompt.length)}...',
      ],
      'mistral-7b': [
        'Mistral 7B lokal generiert: Eine detaillierte Antwort...',
        'Lokale Verarbeitung mit Mistral 7B: ${prompt.substring(0, prompt.length > 50 ? 50 : prompt.length)}...',
        'Mistral 7B bietet folgende lokale Lösung...',
      ],
      'llama3-8b': [
        'Llama 3 8B lokal verarbeitet: Hier ist die Antwort...',
        'Lokale Llama 3 8B Generierung: ${prompt.substring(0, prompt.length > 50 ? 50 : prompt.length)}...',
        'Llama 3 8B bietet diese lokale Lösung...',
      ],
    };

    final modelResponses = responses[modelId] ?? responses['gemma-2b']!;
    final randomIndex = DateTime.now().millisecondsSinceEpoch % modelResponses.length;
    return modelResponses[randomIndex];
  }

  /// Gibt verfügbare lokale Modelle zurück
  Future<List<Map<String, dynamic>>> getAvailableLocalModels() async {
    final models = <Map<String, dynamic>>[];
    
    for (final modelId in _modelConfigs.keys) {
      final isAvailable = await isModelAvailable(modelId);
      final config = _modelConfigs[modelId]!;
      
      models.add({
        'id': modelId,
        'name': config['name'],
        'provider': config['provider'],
        'parameters': config['parameters'],
        'context_length': config['context_length'],
        'download_size': config['download_size'],
        'ram_required': config['ram_required'],
        'is_available': isAvailable,
      });
    }
    
    return models;
  }

  /// Löscht ein lokales Modell
  Future<bool> deleteModel(String modelId) async {
    try {
      final dir = await _getModelsDirectory();
      final modelDir = Directory('${dir.path}/$modelId');
      
      if (await modelDir.exists()) {
        await modelDir.delete(recursive: true);
        debugPrint('Model $modelId deleted successfully');
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting model $modelId: $e');
      return false;
    }
  }

  /// Gibt Speicherplatz für lokale Modelle zurück
  Future<String> getLocalModelsStorageInfo() async {
    try {
      await _getModelsDirectory();
      final sizeInMB = 0.0; // Platzhalter - in echter Implementierung würde hier der tatsächliche Speicherplatz berechnet
      return '${sizeInMB.toStringAsFixed(1)} MB';
    } catch (e) {
      return 'Unbekannt';
    }
  }

  /// Prüft verfügbaren Speicherplatz
  Future<bool> hasEnoughStorage(String modelId) async {
    try {
      final config = _modelConfigs[modelId];
      if (config == null) return false;
      
      final downloadSize = _parseSize(config['download_size']);
      final availableSpace = await _getAvailableStorage();
      
      return availableSpace >= downloadSize;
    } catch (e) {
      debugPrint('Error checking storage: $e');
      return false;
    }
  }

  /// Hilfsmethoden
  Future<Directory> _getModelsDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final modelsDir = Directory('${appDir.path}/$_modelsDir');
    if (!await modelsDir.exists()) {
      await modelsDir.create(recursive: true);
    }
    return modelsDir;
  }

  double _parseSize(String sizeStr) {
    final number = double.parse(sizeStr.split(' ')[0]);
    final unit = sizeStr.split(' ')[1];
    
    switch (unit) {
      case 'GB':
        return number * 1024 * 1024 * 1024;
      case 'MB':
        return number * 1024 * 1024;
      case 'KB':
        return number * 1024;
      default:
        return number;
    }
  }

  Future<double> _getAvailableStorage() async {
    try {
      await getApplicationDocumentsDirectory();
      // Vereinfachte Schätzung - in einer echten App würde man den tatsächlichen verfügbaren Speicher prüfen
      return 1024 * 1024 * 1024; // 1GB als Beispiel
    } catch (e) {
      return 0;
    }
  }
} 