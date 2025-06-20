import 'dart:convert';
import 'package:project_jambam/src/features/a_ideation/domain/jam_kit.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

/// Service that evolves Jam Seeds into concrete Jam Kits
/// by incorporating community feedback and making concepts more specific
class JamSeedEvolutionService {
  JamSeedEvolutionService({String? apiKey})
      : model = GenerativeModel(
          model: 'gemini-1.5-flash',
          apiKey: apiKey ?? const String.fromEnvironment('GEMINI_API_KEY'),
        );

  final GenerativeModel model;

  /// Evolves a Jam Seed into a concrete Jam Kit
  Future<JamKit> evolveSeedToKit(JamSeed seed) async {
    final prompt = _buildEvolutionPrompt(seed);
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);
    final responseText = response.text?.trim() ?? '';

    return _parseJamKitResponse(responseText, seed);
  }

  String _buildEvolutionPrompt(JamSeed seed) {
    final communityInsights = seed.communityContributions
        .map((c) => '${c.type}: ${c.content}')
        .join('\n');

    return '''
    You are an expert game designer tasked with evolving a "Jam Seed" into a concrete "Jam Kit".
    
    JAM SEED (Current State):
    Title: ${seed.title}
    Core Concept: ${seed.coreConcept}
    Inspiration Elements: ${seed.inspirationElements.join(', ')}
    Creative Constraints: ${seed.creativeConstraints.join(', ')}
    
    COMMUNITY CONTRIBUTIONS:
    ${communityInsights.isNotEmpty ? communityInsights : 'No community contributions yet.'}
    
    TASK: Transform this flexible seed into a concrete, actionable Jam Kit with:
    - Specific theme and setting
    - Clear quests/objectives
    - Detailed asset suggestions with style prompts
    
    Generate a Jam Kit JSON with this structure:
    {
      "id": "A unique identifier",
      "title": "A specific, actionable title",
      "theme": "A detailed theme description with specific setting and tone",
      "quests": [
        {
          "title": "Specific quest title",
          "description": "Detailed quest description with clear objectives"
        }
      ],
      "asset_suggestions": [
        {
          "type": "character | environment | obstacle | sfx",
          "description": "Specific asset description",
          "style_prompt": "Detailed style prompt for AI generation"
        }
      ]
    }
    
    Make the concept concrete and actionable while preserving the creative spirit of the original seed.
    ''';
  }

  JamKit _parseJamKitResponse(String responseText, JamSeed sourceSeed) {
    try {
      final cleanJson = responseText.replaceAll('```json', '').replaceAll('```', '').trim();
      final decoded = jsonDecode(cleanJson) as Map<String, dynamic>;

      return JamKit(
        id: decoded['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: decoded['title'] as String? ?? '${sourceSeed.title} - Evolved',
        theme: decoded['theme'] as String? ?? sourceSeed.coreConcept,
        quests: _parseQuests(decoded['quests']),
        assetSuggestions: _parseAssetSuggestions(decoded['asset_suggestions']),
        sourceJamSeed: sourceSeed,
      );
    } catch (e) {
      // Fallback if JSON parsing fails
      return JamKit(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: '${sourceSeed.title} - Evolved',
        theme: sourceSeed.coreConcept,
        quests: [
          const Quest(
            title: 'Explore the Concept',
            description: 'Develop the core concept into a playable experience',
          ),
        ],
        assetSuggestions: [
          AssetSuggestion(
            type: 'character',
            description: 'Main character inspired by: ${sourceSeed.inspirationElements.join(', ')}',
            stylePrompt: 'Modern game art style',
          ),
        ],
        sourceJamSeed: sourceSeed,
      );
    }
  }

  List<Quest> _parseQuests(dynamic questsData) {
    if (questsData is! List) return [];
    
    return questsData.map((questData) {
      if (questData is Map<String, dynamic>) {
        return Quest(
          title: questData['title'] as String? ?? 'Unknown Quest',
          description: questData['description'] as String? ?? 'No description',
        );
      }
      return const Quest(title: 'Unknown Quest', description: 'No description');
    }).toList();
  }

  List<AssetSuggestion> _parseAssetSuggestions(dynamic assetsData) {
    if (assetsData is! List) return [];
    
    return assetsData.map((assetData) {
      if (assetData is Map<String, dynamic>) {
        return AssetSuggestion(
          type: assetData['type'] as String? ?? 'unknown',
          description: assetData['description'] as String? ?? 'No description',
          stylePrompt: assetData['style_prompt'] as String? ?? 'Default style',
        );
      }
      return const AssetSuggestion(
        type: 'unknown',
        description: 'No description',
        stylePrompt: 'Default style',
      );
    }).toList();
  }
} 