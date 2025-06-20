import 'package:project_jambam/src/features/a_ideation/domain/jam_kit_repository.dart';
import 'package:project_jambam/src/features/a_ideation/domain/jam_kit.dart';
import 'package:project_jambam/src/features/a_ideation/application/concept_generation_service.dart';

/// A mock implementation of the JamKitRepository that returns hardcoded data.
/// This is useful for building and testing the UI without a live backend.
class MockJamKitRepository implements JamKitRepository {
  @override
  Future<JamKit> generateJamKit(ConceptGenerationInput input) async {
    // Mock implementation for testing
    return JamKit(
      id: 'mock-jam-kit-${DateTime.now().millisecondsSinceEpoch}',
      title: 'Mock Jam Kit: ${input.keywords.join(' ')}',
      theme: 'A mock jam kit generated for testing purposes based on keywords: ${input.keywords.join(', ')}',
      quests: [
        Quest(
          title: 'Mock Quest 1',
          description: 'This is a mock quest for testing purposes',
        ),
        Quest(
          title: 'Mock Quest 2',
          description: 'Another mock quest for testing',
        ),
      ],
      assetSuggestions: [
        AssetSuggestion(
          type: 'character',
          description: 'A mock character asset',
          stylePrompt: 'Mock style prompt',
        ),
      ],
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