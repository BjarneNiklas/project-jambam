import 'package:project_jambam/src/features/a_ideation/application/concept_generation_service.dart';
import 'package:project_jambam/src/features/a_ideation/data/knowledge_retriever_service.dart';
import 'package:project_jambam/src/features/a_ideation/data/llm_concept_generation_service.dart';
import 'package:project_jambam/src/features/a_ideation/domain/jam_kit.dart';

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

    // 4. Return the final JamKit, now including the sources of inspiration
    return JamKit(
      id: generatedJamKit['id'] ?? 'rag-kit-${DateTime.now().millisecondsSinceEpoch}',
      title: generatedJamKit['title'] ?? 'RAG-Enhanced Game Concept',
      theme: generatedJamKit['content'] ?? 'A game concept enhanced with retrieved knowledge',
      quests: [
        Quest(title: 'Main Quest', description: 'Complete the core game loop'),
        Quest(title: 'Knowledge Quest', description: 'Explore the enhanced features'),
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
      inspirationSources: inspirationSnippets, // Attach the sources!
    );
  }

  @override
  Future<JamSeed> generateJamSeed(ConceptGenerationInput input) async {
    // RAG-based jam seed generation using knowledge retrieval
    final relevantKnowledge = await _retrieveRelevantKnowledge(input.keywords);
    final enhancedInput = _enhanceInputWithKnowledge(input, relevantKnowledge);
    
    return JamSeed(
      id: 'rag-seed-${DateTime.now().millisecondsSinceEpoch}',
      title: _generateTitleFromKnowledge(enhancedInput),
      coreConcept: _generateConceptFromKnowledge(enhancedInput),
      inspirationElements: enhancedInput.keywords,
      creativeConstraints: _extractConstraintsFromKnowledge(relevantKnowledge),
    );
  }
  
  Future<List<String>> _retrieveRelevantKnowledge(List<String> keywords) async {
    // Simulate knowledge retrieval from RAG system
    return [
      'Game design patterns for ${keywords.isNotEmpty ? keywords.first : 'adventure'} games',
      'Player engagement strategies',
      'Emergent gameplay mechanics',
    ];
  }
  
  ConceptGenerationInput _enhanceInputWithKnowledge(
    ConceptGenerationInput input,
    List<String> knowledge,
  ) {
    final enhancedKeywords = [...input.keywords, ...knowledge.take(2)];
    return ConceptGenerationInput(
      keywords: enhancedKeywords,
      inspirationMode: input.inspirationMode,
    );
  }
  
  String _generateTitleFromKnowledge(ConceptGenerationInput input) {
    return 'RAG-Enhanced: ${input.keywords.take(3).join(' ')}';
  }
  
  String _generateConceptFromKnowledge(ConceptGenerationInput input) {
    return 'A game concept enhanced with retrieved knowledge about ${input.keywords.join(', ')}';
  }
  
  List<String> _extractConstraintsFromKnowledge(List<String> knowledge) {
    return ['RAG-enhanced', 'Knowledge-driven'];
  }

  ConceptGenerationInput _augmentInput(
    ConceptGenerationInput originalInput,
    List<String> snippets,
  ) {
    if (snippets.isEmpty) {
      return originalInput;
    }
    
    // We create a new keyword list that includes the original keywords
    // and the retrieved snippets to create a richer context for the LLM.
    final augmentedKeywords = [
      ...originalInput.keywords,
      'Please take inspiration from the following concepts:',
      ...snippets,
    ];

    return ConceptGenerationInput(
      keywords: augmentedKeywords,
      inspirationMode: originalInput.inspirationMode,
    );
  }
} 