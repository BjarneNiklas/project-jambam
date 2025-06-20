import 'package:project_jambam/src/features/a_ideation/domain/jam_kit.dart';

/// Defines the input parameters for the concept generation process.
class ConceptGenerationInput {
  ConceptGenerationInput({
    required this.keywords,
    this.inspirationMode,
    this.useMechanics = true,
    this.useMonetization = true,
    this.generationMode = GenerationMode.jamKit, // Default to legacy mode
  });

  final List<String> keywords;
  final String? inspirationMode; // e.g., 'trending', 'surprising'
  final bool useMechanics;
  final bool useMonetization;
  final GenerationMode generationMode;
}

enum GenerationMode {
  jamKit, // Legacy: concrete, complete concept
  jamSeed, // New: flexible, community-driven seed
}

/// Abstract interface for a service that can generate a complete [JamKit]
/// from a given [ConceptGenerationInput].
///
/// This is the core abstraction for our AI features, allowing us to swap out
/// the entire generation logic (e.g., from a simple LLM call to a complex
/// RAG system) without changing the rest of the application.
abstract class ConceptGenerationService {
  Future<JamKit> generateConcept(ConceptGenerationInput input);
  Future<JamSeed> generateJamSeed(ConceptGenerationInput input);
} 