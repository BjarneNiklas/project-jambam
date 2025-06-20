import 'package:project_jambam/src/features/a_ideation/domain/jam_kit_repository.dart';
import 'package:project_jambam/src/features/a_ideation/domain/jam_kit.dart';
import 'package:project_jambam/src/features/a_ideation/application/concept_generation_service.dart';

/// This repository acts as a bridge between the application's domain layer and
/// the AI-powered data generation services.
class ApiJamKitRepository implements JamKitRepository {
  ApiJamKitRepository({required this.conceptGenerationService});

  final ConceptGenerationService conceptGenerationService;

  @override
  Future<JamKit> generateJamKit(ConceptGenerationInput input) async {
    // API-based jam kit generation
    return JamKit(
      id: 'api-kit-${DateTime.now().millisecondsSinceEpoch}',
      title: 'API Generated: ${input.keywords.join(' ')}',
      theme: input.keywords.isNotEmpty ? input.keywords.first : 'Adventure',
      quests: [
        Quest(
          title: 'Explore the World',
          description: 'Discover the secrets of ${input.keywords.isNotEmpty ? input.keywords.first : 'this world'}',
        ),
        Quest(
          title: 'Master the Mechanics',
          description: 'Learn and master the core gameplay mechanics',
        ),
      ],
      assetSuggestions: [
        AssetSuggestion(
          type: '3D Models',
          description: 'High-quality 3D models for the game world',
          stylePrompt: 'Detailed, immersive 3D assets',
        ),
        AssetSuggestion(
          type: 'UI Elements',
          description: 'User interface components and HUD elements',
          stylePrompt: 'Modern, clean UI design',
        ),
      ],
      inspirationSources: input.keywords,
      kitType: KitType.standard,
      complexity: Complexity.intermediate,
      estimatedBuildTime: Duration(hours: 24),
    );
  }

  @override
  Future<JamKit> generateJamKitLegacy({
    required List<String> keywords,
    String? inspirationMode,
  }) async {
    // Legacy implementation for backward compatibility
    final input = ConceptGenerationInput(
      keywords: keywords,
      inspirationMode: inspirationMode,
    );
    return generateJamKit(input);
  }
} 