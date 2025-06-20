import 'dart:convert';
import 'package:project_jambam/src/features/a_ideation/application/concept_generation_service.dart';
import 'package:project_jambam/src/features/a_ideation/domain/jam_kit.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

/// Service that generates flexible JamSeeds instead of rigid JamKits.
/// JamSeeds are designed to inspire community collaboration and creativity.
class JamSeedGenerationService {
  JamSeedGenerationService({String? apiKey})
      : model = GenerativeModel(
          model: 'gemini-1.5-flash',
          apiKey: apiKey ?? const String.fromEnvironment('GEMINI_API_KEY'),
        );

  final GenerativeModel model;

  Future<JamSeed> generateJamSeed(ConceptGenerationInput input) async {
    final prompt = _buildJamSeedPrompt(input);
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);
    final responseText = response.text?.trim() ?? '';

    return _parseJamSeedResponse(responseText, input);
  }

  String _buildJamSeedPrompt(ConceptGenerationInput input) {
    return '''
    You are a creative catalyst for game jams. Your role is to generate "Jam Seeds" - 
    inspiring starting points that encourage community collaboration and creativity.

    A Jam Seed should be:
    - INSPIRING but not prescriptive
    - FLEXIBLE enough for multiple interpretations
    - OPEN to community contributions
    - FOCUSED on a core concept that can be explored in many ways

    Generate a Jam Seed JSON with this structure:
    {
      "id": "A unique identifier",
      "title": "An evocative, open-ended title",
      "coreConcept": "A 2-3 sentence core idea that can be interpreted in multiple ways",
      "inspirationElements": [
        "keyword1",
        "keyword2", 
        "keyword3"
      ],
      "creativeConstraints": [
        "One interesting constraint or challenge",
        "Another creative guideline (not a rule)"
      ]
    }

    Keywords: ${input.keywords.join(', ')}
    ${input.inspirationMode != null ? 'Inspiration Mode: ${input.inspirationMode}' : ''}

    Focus on creating something that will spark discussion and multiple creative directions.
    ''';
  }

  JamSeed _parseJamSeedResponse(String responseText, ConceptGenerationInput input) {
    try {
      final cleanJson = responseText.replaceAll('```json', '').replaceAll('```', '').trim();
      final decoded = jsonDecode(cleanJson) as Map<String, dynamic>;

      return JamSeed(
        id: decoded['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: decoded['title'] as String? ?? 'Untitled Jam Seed',
        coreConcept: decoded['coreConcept'] as String? ?? '',
        inspirationElements: List<String>.from(decoded['inspirationElements'] ?? []),
        creativeConstraints: List<String>.from(decoded['creativeConstraints'] ?? []),
        createdAt: DateTime.now(),
        isCommunityDriven: false,
      );
    } catch (e) {
      // Fallback if JSON parsing fails
      return JamSeed(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Creative Jam Seed',
        coreConcept: 'A flexible game concept inspired by: ${input.keywords.join(', ')}',
        inspirationElements: input.keywords,
        creativeConstraints: ['Be creative!', 'Think outside the box'],
        createdAt: DateTime.now(),
        isCommunityDriven: false,
      );
    }
  }
} 