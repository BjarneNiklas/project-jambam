import 'package:project_jambam/src/features/a_ideation/domain/jam_kit.dart';
import 'package:project_jambam/src/features/a_ideation/domain/game_seed.dart';
import 'package:project_jambam/src/features/a_ideation/domain/development_blueprint.dart';

/// Defines the input parameters for the concept generation process.
class ConceptGenerationInput {
  ConceptGenerationInput({
    required this.keywords,
    this.genres, // List of genres for Game Seeds and Development Blueprints
    this.inspirationMode,
    this.useMechanics = true,
    this.useMonetization = true,
    this.generationMode = GenerationMode.jamSeed, // Default to Jam Seed for community-driven approach
  });

  final List<String> keywords;
  final List<String>? genres; // e.g., ['Action-Adventure', 'Sandbox'] - relevant for Game Seeds and Development Blueprints
  final String? inspirationMode; // e.g., 'trending', 'surprising'
  final bool useMechanics;
  final bool useMonetization;
  final GenerationMode generationMode;
}

enum GenerationMode {
  jamSeed, // 🌱 Flexible, community-driven seed for Game Jam Events (genre-agnostic)
  jamKit, // 🛠️ Concrete, actionable kit for Game Jam Events (genre-agnostic)
  gameSeed, // 🎮 Flexible game idea for long-term projects (genre-specific)
  developmentBlueprint, // 📋 Comprehensive blueprint for professional development (genre-specific)
}

/// Abstract interface for a service that can generate different types of concepts
/// from a given [ConceptGenerationInput].
///
/// This is the core abstraction for our AI features, allowing us to swap out
/// the entire generation logic (e.g., from a simple LLM call to a complex
/// RAG system) without changing the rest of the application.
///
/// The service supports four different generation modes:
/// - Jam Seed: Flexible, community-driven seeds for Game Jam Events
/// - Jam Kit: Concrete, actionable kits for Game Jam Events
/// - Game Seed: Flexible game ideas for long-term projects
/// - Development Blueprint: Comprehensive blueprints for professional development
abstract class ConceptGenerationService {
  /// Generates a Jam Seed - flexible, community-driven seed for Game Jam Events
  /// Genre-agnostic, focuses on community creativity and flexibility
  Future<JamSeed> generateJamSeed(ConceptGenerationInput input);
  
  /// Generates a Jam Kit - concrete, actionable kit for Game Jam Events
  /// Genre-agnostic, optimized for jam timeframe, includes simplified resources
  Future<JamKit> generateJamKit(ConceptGenerationInput input);
  
  /// Generates a Game Seed - flexible game idea for long-term projects
  /// Genre-specific, contains explicit genre assignments
  Future<GameSeed> generateGameSeed(ConceptGenerationInput input);
  
  /// Generates a Development Blueprint - comprehensive blueprint for professional development
  /// Genre-specific, contains detailed specifications and resources
  Future<DevelopmentBlueprint> generateDevelopmentBlueprint(ConceptGenerationInput input);
  
  /// Legacy method for backward compatibility
  /// @deprecated Use generateJamKit instead
  @Deprecated('Use generateJamKit instead')
  Future<JamKit> generateConcept(ConceptGenerationInput input) => generateJamKit(input);
}
