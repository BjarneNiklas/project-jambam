import 'package:project_jambam/src/features/a_ideation/application/concept_generation_service.dart';
import 'package:project_jambam/src/features/a_ideation/data/knowledge_retriever_service.dart';
import 'package:project_jambam/src/features/a_ideation/data/llm_concept_generation_service.dart';
import 'package:project_jambam/src/features/a_ideation/domain/jam_kit.dart';
import 'package:project_jambam/src/features/a_ideation/domain/game_seed.dart';
import 'package:project_jambam/src/features/a_ideation/domain/development_blueprint.dart';

/// A more advanced implementation of [ConceptGenerationService] that uses a
/// Retrieval-Augmented Generation (RAG) approach.
class RagConceptGenerationService implements ConceptGenerationService {
  RagConceptGenerationService({
    required this.knowledgeRetriever,
    required this.llmService,
  });

  final KnowledgeRetrieverService knowledgeRetriever;
  final LlmConceptGenerationService llmService;

  @override
  Future<JamKit> generateConcept(ConceptGenerationInput input) async {
    // 1. Retrieve relevant knowledge snippets based on keywords
    final inspirationSnippets = knowledgeRetriever.retrieveRelevantSnippets(input.keywords);

    // 2. Augment the input for the LLM service by creating a new, more detailed prompt
    final augmentedInput = _augmentInput(input, inspirationSnippets);

    // 3. Call the underlying LLM service with the augmented input
    final generatedJamKit = await llmService.generateConcept(
      prompt: augmentedInput.keywords.join(', '),
      category: 'game-design',
      style: 'rag-enhanced',
    );

    // 4. Parse and return the result
    return _parseJamKitResponse(generatedJamKit);
  }

  @override
  Future<JamSeed> generateJamSeed(ConceptGenerationInput input) async {
    // 1. Retrieve relevant knowledge snippets based on keywords
    final inspirationSnippets = knowledgeRetriever.retrieveRelevantSnippets(input.keywords);

    // 2. Augment the input for the LLM service
    final augmentedInput = _augmentInput(input, inspirationSnippets);

    // 3. Call the underlying LLM service with the augmented input
    final generatedJamSeed = await llmService.generateJamSeed(
      prompt: augmentedInput.keywords.join(', '),
      category: 'game-design',
      style: 'rag-enhanced',
    );

    // 4. Parse and return the result
    return _parseJamSeedResponse(generatedJamSeed);
  }

  @override
  Future<JamKit> generateJamKit(ConceptGenerationInput input) async {
    // 1. Retrieve relevant knowledge snippets based on keywords
    final inspirationSnippets = knowledgeRetriever.retrieveRelevantSnippets(input.keywords);

    // 2. Augment the input for the LLM service
    final augmentedInput = _augmentInput(input, inspirationSnippets);

    // 3. Call the underlying LLM service with the augmented input
    final generatedJamKit = await llmService.generateJamKit(
      seed: {'title': 'RAG Enhanced Jam Kit', 'keywords': augmentedInput.keywords.join(', ')},
      complexity: 'intermediate',
      targetPlatform: 'multi-platform',
    );

    // 4. Parse and return the result
    return _parseJamKitResponse(generatedJamKit);
  }

  @override
  Future<GameSeed> generateGameSeed(ConceptGenerationInput input) async {
    // 1. Retrieve relevant knowledge snippets based on keywords and genres
    final allKeywords = [...input.keywords, ...(input.genres ?? [])];
    final inspirationSnippets = knowledgeRetriever.retrieveRelevantSnippets(allKeywords);

    // 2. Augment the input for the LLM service
    final augmentedInput = _augmentInput(input, inspirationSnippets);

    // 3. Call the underlying LLM service with the augmented input
    final generatedGameSeed = await llmService.generateJamSeed(
      prompt: augmentedInput.keywords.join(', '),
      category: 'game-design',
      style: 'rag-enhanced-genre',
    );

    // 4. Parse and return the result
    return _parseGameSeedResponse(generatedGameSeed, input);
  }

  @override
  Future<DevelopmentBlueprint> generateDevelopmentBlueprint(ConceptGenerationInput input) async {
    // 1. Retrieve relevant knowledge snippets based on keywords and genres
    final allKeywords = [...input.keywords, ...(input.genres ?? [])];
    final inspirationSnippets = knowledgeRetriever.retrieveRelevantSnippets(allKeywords);

    // 2. Augment the input for the LLM service
    final augmentedInput = _augmentInput(input, inspirationSnippets);

    // 3. Call the underlying LLM service with the augmented input
    final generatedBlueprint = await llmService.generateJamKit(
      seed: {'title': 'RAG Enhanced Development Blueprint', 'keywords': augmentedInput.keywords.join(', ')},
      complexity: 'advanced',
      targetPlatform: 'multi-platform',
    );

    // 4. Parse and return the result
    return _parseDevelopmentBlueprintResponse(generatedBlueprint, input);
  }

  /// Augment the input with retrieved knowledge snippets
  ConceptGenerationInput _augmentInput(ConceptGenerationInput input, List<String> inspirationSnippets) {
    final augmentedKeywords = [
      ...input.keywords,
      '--- RAG ENHANCED CONTEXT ---',
      ...inspirationSnippets,
    ];

    return ConceptGenerationInput(
      keywords: augmentedKeywords,
      genres: input.genres,
      inspirationMode: input.inspirationMode,
      useMechanics: input.useMechanics,
      useMonetization: input.useMonetization,
      generationMode: input.generationMode,
    );
  }

  /// Parse the LLM response into a JamKit
  JamKit _parseJamKitResponse(Map<String, dynamic> response) {
    return JamKit(
      id: response['id'] ?? 'rag-jam-kit-${DateTime.now().millisecondsSinceEpoch}',
      title: response['title'] ?? 'RAG Enhanced Jam Kit',
      theme: response['theme'] ?? 'A RAG-enhanced game concept',
      quests: [
        Quest(title: 'Main Quest', description: 'Complete the core game loop'),
        Quest(title: 'RAG Quest', description: 'Explore the RAG-enhanced features'),
      ],
      assetSuggestions: [
        AssetSuggestion(
          type: 'character',
          description: 'Main character design',
          stylePrompt: 'Modern, appealing character design',
        ),
        AssetSuggestion(
          type: 'environment',
          description: 'Game world environment',
          stylePrompt: 'Immersive, detailed environment',
        ),
      ],
      inspirationSources: response['inspirationSources'] ?? [],
    );
  }

  /// Parse the LLM response into a JamSeed
  JamSeed _parseJamSeedResponse(Map<String, dynamic> response) {
    return JamSeed(
      id: response['id'] ?? 'rag-jam-seed-${DateTime.now().millisecondsSinceEpoch}',
      title: response['title'] ?? 'RAG Enhanced Jam Seed',
      coreConcept: response['coreConcept'] ?? 'A RAG-enhanced flexible game concept',
      inspirationElements: response['inspirationElements'] ?? [],
      creativeConstraints: response['creativeConstraints'] ?? ['RAG-enhanced'],
    );
  }

  /// Parse the LLM response into a GameSeed
  GameSeed _parseGameSeedResponse(Map<String, dynamic> response, ConceptGenerationInput input) {
    return GameSeed(
      id: response['id'] ?? 'rag-game-seed-${DateTime.now().millisecondsSinceEpoch}',
      title: response['title'] ?? 'RAG Enhanced Game Seed',
      coreConcept: response['coreConcept'] ?? 'A RAG-enhanced game seed for long-term development',
      suggestedMechanics: response['suggestedMechanics'] ?? [],
      roughStoryIdea: response['roughStoryIdea'] ?? 'A rough story idea enhanced by RAG.',
      genres: input.genres ?? [],
      inspirationElements: response['inspirationElements'] ?? input.keywords,
      creativeConstraints: response['creativeConstraints'] ?? ['RAG-enhanced'],
      suggestedArtStyle: response['suggestedArtStyle'],
      targetAudience: response['targetAudience'],
      monetizationStrategy: response['monetizationStrategy'],
      aiGenerated: true,
      createdAt: DateTime.now(),
    );
  }

  /// Parse the LLM response into a Development Blueprint
  DevelopmentBlueprint _parseDevelopmentBlueprintResponse(Map<String, dynamic> response, ConceptGenerationInput input) {
    return DevelopmentBlueprint(
      id: response['id'] ?? 'rag-development-blueprint-${DateTime.now().millisecondsSinceEpoch}',
      title: response['title'] ?? 'RAG Enhanced Development Blueprint',
      coreConcept: response['coreConcept'] ?? 'A comprehensive RAG-enhanced development blueprint',
      genres: input.genres ?? [],
      quests: [
        Quest(title: 'Core Development', description: 'Develop the core game concept'),
        Quest(title: 'RAG Features', description: 'Implement RAG-enhanced features'),
      ],
      assetSpecifications: [
        AssetSpecification(
          type: 'character_model',
          description: 'Main character models',
          styleGuide: 'High quality, detailed character models',
        ),
      ],
      constructionGuides: [],
      technicalSpecifications: response['technicalSpecifications'],
      monetizationStrategy: response['monetizationStrategy'],
      targetPlatforms: ['PC', 'Mobile', 'Web'],
      estimatedDevelopmentTime: Duration(hours: 48),
      createdAt: DateTime.now(),
    );
  }
}
