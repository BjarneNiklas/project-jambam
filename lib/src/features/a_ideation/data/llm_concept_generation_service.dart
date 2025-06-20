import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project_jambam/src/core/logger.dart';
import 'package:project_jambam/src/core/environment.dart';

class LlmConceptGenerationService {
  final Logger _logger = Logger('LlmConceptGenerationService');
  final Environment _env = Environment();
  
  // Model getter for compatibility with agent classes
  String get model => 'gpt-4';
  
  Future<Map<String, dynamic>> generateConcept({
    required String prompt,
    String? category,
    String? style,
  }) async {
    _logger.info('Generating concept with prompt: $prompt');
    
    try {
      final apiKey = _env.get('OPENAI_API_KEY');
      if (apiKey == null || apiKey.isEmpty) {
        // Return mock data if no API key
        return {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'title': 'Mock Concept: $prompt',
          'content': 'A creative concept based on $prompt in the ${category ?? 'general'} category.',
          'inspirationElements': [prompt, category ?? 'general', style ?? 'mixed'],
          'createdAt': DateTime.now().toIso8601String(),
          'status': 'generated',
        };
      }

      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': model,
          'messages': [
            {
              'role': 'system',
              'content': 'You are a creative concept generator. Generate innovative and engaging concepts based on the user\'s prompt.',
            },
            {
              'role': 'user',
              'content': 'Create a concept for: $prompt\nCategory: ${category ?? "general"}\nStyle: ${style ?? "any"}',
            },
          ],
          'max_tokens': 400,
          'temperature': 0.8,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        
        return {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'title': _extractTitle(content),
          'content': content,
          'inspirationElements': [prompt, category ?? 'general', style ?? 'mixed'],
          'createdAt': DateTime.now().toIso8601String(),
          'status': 'generated',
        };
      } else {
        throw Exception('Failed to generate concept: ${response.statusCode}');
      }
    } catch (e) {
      _logger.error('Error generating concept: $e');
      // Return mock data on error
      return {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'title': 'Error Fallback: $prompt',
        'content': 'A fallback concept due to API error.',
        'inspirationElements': [prompt, category ?? 'general', style ?? 'mixed'],
        'createdAt': DateTime.now().toIso8601String(),
        'status': 'error',
      };
    }
  }

  Future<Map<String, dynamic>> generateJamSeed({
    required String prompt,
    required String category,
    String? style,
  }) async {
    _logger.info('Generating Jam Seed with prompt: $prompt');
    
    try {
      final apiKey = _env.get('OPENAI_API_KEY');
      if (apiKey == null || apiKey.isEmpty) {
        // Return mock data if no API key
        return {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'title': 'Mock Game Concept: $prompt',
          'coreConcept': 'A creative game concept based on $prompt in the $category category.',
          'inspirationElements': [prompt, category, style ?? 'mixed'],
          'creativeConstraints': ['Time limit', 'Theme-based'],
          'createdAt': DateTime.now().toIso8601String(),
          'status': 'brainstorming',
        };
      }

      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4',
          'messages': [
            {
              'role': 'system',
              'content': 'You are a creative game designer. Generate a concise, innovative game concept based on the user\'s prompt.',
            },
            {
              'role': 'user',
              'content': 'Create a game concept for: $prompt\nCategory: $category\nStyle: ${style ?? "any"}',
            },
          ],
          'max_tokens': 300,
          'temperature': 0.8,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        
        return {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'title': _extractTitle(content),
          'coreConcept': content,
          'inspirationElements': [prompt, category, style ?? 'mixed'],
          'creativeConstraints': ['Time limit', 'Theme-based'],
          'createdAt': DateTime.now().toIso8601String(),
          'status': 'brainstorming',
        };
      } else {
        throw Exception('Failed to generate concept: ${response.statusCode}');
      }
    } catch (e) {
      _logger.error('Error generating Jam Seed: $e');
      // Return mock data on error
      return {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'title': 'Error Fallback: $prompt',
        'coreConcept': 'A fallback game concept due to API error.',
        'inspirationElements': [prompt, category, style ?? 'mixed'],
        'creativeConstraints': ['Time limit', 'Theme-based'],
        'createdAt': DateTime.now().toIso8601String(),
        'status': 'brainstorming',
      };
    }
  }

  Future<Map<String, dynamic>> generateJamKit({
    required Map<String, dynamic> seed,
    required String complexity,
    String? targetPlatform,
  }) async {
    _logger.info('Generating Jam Kit from seed: ${seed['title']}');
    
    try {
      final apiKey = _env.get('OPENAI_API_KEY');
      if (apiKey == null || apiKey.isEmpty) {
        // Return mock data if no API key
        return {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'title': '${seed['title']} - Development Kit',
          'theme': 'A comprehensive game development kit based on ${seed['title']}',
          'quests': [
            {'title': 'Main Objective', 'description': 'Complete the core game loop'},
            {'title': 'Bonus Challenge', 'description': 'Add an innovative feature'},
          ],
          'assetSuggestions': [
            {
              'type': 'character',
              'description': 'Main character design',
              'stylePrompt': 'Modern, appealing character design',
            },
            {
              'type': 'environment',
              'description': 'Game world environment',
              'stylePrompt': 'Immersive, detailed environment',
            },
          ],
          'sourceJamSeed': seed,
          'complexity': complexity,
          'targetPlatform': targetPlatform ?? 'multi-platform',
        };
      }

      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4',
          'messages': [
            {
              'role': 'system',
              'content': 'You are a professional game developer. Create a comprehensive game development kit based on the provided seed concept.',
            },
            {
              'role': 'user',
              'content': 'Create a game development kit for: ${seed['title']}\nConcept: ${seed['coreConcept']}\nComplexity: $complexity\nPlatform: ${targetPlatform ?? "multi-platform"}',
            },
          ],
          'max_tokens': 500,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        
        return {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'title': '${seed['title']} - Development Kit',
          'theme': content,
          'quests': [
            {'title': 'Main Objective', 'description': 'Complete the core game loop'},
            {'title': 'Bonus Challenge', 'description': 'Add an innovative feature'},
          ],
          'assetSuggestions': [
            {
              'type': 'character',
              'description': 'Main character design',
              'stylePrompt': 'Modern, appealing character design',
            },
            {
              'type': 'environment',
              'description': 'Game world environment',
              'stylePrompt': 'Immersive, detailed environment',
            },
          ],
          'sourceJamSeed': seed,
          'complexity': complexity,
          'targetPlatform': targetPlatform ?? 'multi-platform',
        };
      } else {
        throw Exception('Failed to generate kit: ${response.statusCode}');
      }
    } catch (e) {
      _logger.error('Error generating Jam Kit: $e');
      // Return mock data on error
      return {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'title': '${seed['title']} - Development Kit (Fallback)',
        'theme': 'A fallback development kit due to API error.',
        'quests': [
          {'title': 'Main Objective', 'description': 'Complete the core game loop'},
          {'title': 'Bonus Challenge', 'description': 'Add an innovative feature'},
        ],
        'assetSuggestions': [
          {
            'type': 'character',
            'description': 'Main character design',
            'stylePrompt': 'Modern, appealing character design',
          },
          {
            'type': 'environment',
            'description': 'Game world environment',
            'stylePrompt': 'Immersive, detailed environment',
          },
        ],
        'sourceJamSeed': seed,
        'complexity': complexity,
        'targetPlatform': targetPlatform ?? 'multi-platform',
      };
    }
  }

  /// Generate content using the LLM service (for use by concept agents)
  Future<String> generateContent(String prompt) async {
    _logger.info('Generating content with prompt: ${prompt.substring(0, prompt.length > 100 ? 100 : prompt.length)}...');
    
    try {
      final apiKey = _env.get('OPENAI_API_KEY');
      if (apiKey == null || apiKey.isEmpty) {
        // Return mock data if no API key
        return 'Mock content generated for: ${prompt.substring(0, prompt.length > 50 ? 50 : prompt.length)}...';
      }

      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': model,
          'messages': [
            {
              'role': 'system',
              'content': 'You are a creative AI assistant specialized in game design and interactive media concepts.',
            },
            {
              'role': 'user',
              'content': prompt,
            },
          ],
          'max_tokens': 500,
          'temperature': 0.8,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        return content;
      } else {
        throw Exception('Failed to generate content: ${response.statusCode}');
      }
    } catch (e) {
      _logger.error('Error generating content: $e');
      // Return mock data on error
      return 'Error generating content. Please try again.';
    }
  }

  String _extractTitle(String content) {
    // Simple title extraction - take first line or first sentence
    final lines = content.split('\n');
    final firstLine = lines.first.trim();
    if (firstLine.length > 50) {
      return '${firstLine.substring(0, 50)}...';
    }
    return firstLine;
  }
} 