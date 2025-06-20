import 'package:project_jambam/src/features/a_ideation/application/concept_generation_service.dart';
import 'package:project_jambam/src/features/a_ideation/data/llm_concept_generation_service.dart';
import 'package:project_jambam/src/features/a_ideation/application/prompt_optimizer_agent.dart';
import 'package:project_jambam/src/features/a_ideation/domain/accessibility_system.dart';
import 'package:project_jambam/src/features/a_ideation/domain/ideation_methods.dart';

/// Interface for a specialized agent that generates a specific part of a game concept.
abstract class ConceptAgent {
  /// Returns a text snippet (e.g. world description, mechanic, etc.) based on the input.
  Future<String> generatePart(ConceptGenerationInput input);
}

/// Agent: generates research insights and current trends for game concepts.
class ResearchAgent implements ConceptAgent {
  ResearchAgent({LlmConceptGenerationService? llm, this.promptConfig = const PromptConfig()})
      : llmService = llm ?? LlmConceptGenerationService();

  final LlmConceptGenerationService llmService;
  final PromptConfig promptConfig;

  @override
  Future<String> generatePart(ConceptGenerationInput input) async {
    final prompt = '''
    ${promptConfig.context.isNotEmpty ? '${promptConfig.context}\n' : ''}
    You are a research analyst and trend expert for interactive media.
    Based on the following keywords, provide insights on current trends, market analysis, and research findings relevant to game development and interactive media.
    Focus on data-driven insights, emerging technologies, and market opportunities.
    ${promptConfig.style.isNotEmpty ? 'Style: ${promptConfig.style}\n' : ''}
    Keywords: ${input.keywords.join(", ")}
    ${promptConfig.example.isNotEmpty ? 'Example: ${promptConfig.example}\n' : ''}
    
    Research Insights & Trends:
    ''';
    final response = await llmService.generateContent(prompt);
    return response.trim();
  }
}

/// Agent: generates media themes and storytelling concepts.
class ThemeAgent implements ConceptAgent {
  ThemeAgent({LlmConceptGenerationService? llm, this.promptConfig = const PromptConfig()})
      : llmService = llm ?? LlmConceptGenerationService();

  final LlmConceptGenerationService llmService;
  final PromptConfig promptConfig;

  @override
  Future<String> generatePart(ConceptGenerationInput input) async {
    final prompt = '''
    ${promptConfig.context.isNotEmpty ? '${promptConfig.context}\n' : ''}
    You are a creative media director and storytelling expert.
    Based on the following keywords, create compelling themes, narrative concepts, and storytelling approaches for interactive media experiences.
    Consider cross-media potential, emotional engagement, and innovative storytelling techniques.
    ${promptConfig.style.isNotEmpty ? 'Style: ${promptConfig.style}\n' : ''}
    Keywords: ${input.keywords.join(", ")}
    ${promptConfig.example.isNotEmpty ? 'Example: ${promptConfig.example}\n' : ''}
    
    Media Themes & Storytelling:
    ''';
    final response = await llmService.generateContent(prompt);
    return response.trim();
  }
}

/// Agent: generates asset suggestions and technical specifications.
class AssetAgent implements ConceptAgent {
  AssetAgent({LlmConceptGenerationService? llm, this.promptConfig = const PromptConfig()})
      : llmService = llm ?? LlmConceptGenerationService();

  final LlmConceptGenerationService llmService;
  final PromptConfig promptConfig;

  @override
  Future<String> generatePart(ConceptGenerationInput input) async {
    final prompt = '''
    ${promptConfig.context.isNotEmpty ? '${promptConfig.context}\n' : ''}
    You are a technical director and asset production expert for interactive media.
    Based on the following keywords, suggest specific assets, technical specifications, and production requirements for the game concept.
    Include 3D models, audio, video, UI elements, and interactive components with technical details.
    ${promptConfig.style.isNotEmpty ? 'Style: ${promptConfig.style}\n' : ''}
    Keywords: ${input.keywords.join(", ")}
    ${promptConfig.example.isNotEmpty ? 'Example: ${promptConfig.example}\n' : ''}
    
    Asset Specifications & Technical Requirements:
    ''';
    final response = await llmService.generateContent(prompt);
    return response.trim();
  }
}

/// Example agent: generates a world/setting description using the LLM.
class WorldBuilderAgent implements ConceptAgent {
  WorldBuilderAgent({LlmConceptGenerationService? llm, this.promptConfig = const PromptConfig()})
      : llmService = llm ?? LlmConceptGenerationService();

  final LlmConceptGenerationService llmService;
  final PromptConfig promptConfig;

  @override
  Future<String> generatePart(ConceptGenerationInput input) async {
    final prompt = '''
    ${promptConfig.context.isNotEmpty ? '${promptConfig.context}\n' : ''}
    You are a world-building expert for video games.
    Based on the following keywords, describe a unique and inspiring game world/setting in 2-3 sentences.
    ${promptConfig.style.isNotEmpty ? 'Style: ${promptConfig.style}\n' : ''}
    Keywords: ${input.keywords.join(", ")}
    ${promptConfig.example.isNotEmpty ? 'Example: ${promptConfig.example}\n' : ''}
    World Description:
    ''';
    final response = await llmService.generateContent(prompt);
    return response.trim();
  }
}

/// Example agent: generates a core gameplay mechanic description.
class MechanicsAgent implements ConceptAgent {
  MechanicsAgent({LlmConceptGenerationService? llm, this.promptConfig = const PromptConfig()})
      : llmService = llm ?? LlmConceptGenerationService();

  final LlmConceptGenerationService llmService;
  final PromptConfig promptConfig;

  @override
  Future<String> generatePart(ConceptGenerationInput input) async {
    final prompt = '''
    ${promptConfig.context.isNotEmpty ? '${promptConfig.context}\n' : ''}
    You are a game mechanics expert.
    Based on the following keywords, describe a unique and engaging core gameplay mechanic in 2-3 sentences.
    ${promptConfig.style.isNotEmpty ? 'Style: ${promptConfig.style}\n' : ''}
    Keywords: ${input.keywords.join(", ")}
    ${promptConfig.example.isNotEmpty ? 'Example: ${promptConfig.example}\n' : ''}
    Core Mechanic:
    ''';
    final response = await llmService.generateContent(prompt);
    return response.trim();
  }
}

/// Example agent: generates an art direction/visual style suggestion.
class ArtDirectionAgent implements ConceptAgent {
  ArtDirectionAgent({LlmConceptGenerationService? llm, this.promptConfig = const PromptConfig()})
      : llmService = llm ?? LlmConceptGenerationService();

  final LlmConceptGenerationService llmService;
  final PromptConfig promptConfig;

  @override
  Future<String> generatePart(ConceptGenerationInput input) async {
    final prompt = '''
    ${promptConfig.context.isNotEmpty ? '${promptConfig.context}\n' : ''}
    You are an art director for video games.
    Based on the following keywords, describe the visual style, color palette, and artistic influences for the game in 2-3 sentences.
    ${promptConfig.style.isNotEmpty ? 'Style: ${promptConfig.style}\n' : ''}
    Keywords: ${input.keywords.join(", ")}
    ${promptConfig.example.isNotEmpty ? 'Example: ${promptConfig.example}\n' : ''}
    Art Direction:
    ''';
    final response = await llmService.generateContent(prompt);
    return response.trim();
  }
}

/// Example agent: generates a monetization strategy suggestion.
class MonetizationAgent implements ConceptAgent {
  MonetizationAgent({LlmConceptGenerationService? llm, this.promptConfig = const PromptConfig()})
      : llmService = llm ?? LlmConceptGenerationService();

  final LlmConceptGenerationService llmService;
  final PromptConfig promptConfig;

  @override
  Future<String> generatePart(ConceptGenerationInput input) async {
    final prompt = '''
    ${promptConfig.context.isNotEmpty ? '${promptConfig.context}\n' : ''}
    You are a game monetization expert.
    Based on the following keywords, suggest a suitable monetization strategy (e.g., in-app purchases, cosmetics, ads, premium version) and explain why it fits this game in 2-3 sentences.
    ${promptConfig.style.isNotEmpty ? 'Style: ${promptConfig.style}\n' : ''}
    Keywords: ${input.keywords.join(", ")}
    ${promptConfig.example.isNotEmpty ? 'Example: ${promptConfig.example}\n' : ''}
    Monetization Strategy:
    ''';
    final response = await llmService.generateContent(prompt);
    return response.trim();
  }
}

/// A specialized agent that provides critical feedback on a generated concept.
class CriticAgent implements ConceptAgent {
  CriticAgent({LlmConceptGenerationService? llm, this.promptConfig = const PromptConfig()})
      : llmService = llm ?? LlmConceptGenerationService();

  final LlmConceptGenerationService llmService;
  final PromptConfig promptConfig;

  @override
  Future<String> generatePart(ConceptGenerationInput input) async {
    final prompt = '''
    ${promptConfig.context.isNotEmpty ? '${promptConfig.context}\n' : ''}
    You are an expert game design critic and producer.
    Your task is to analyze a game concept based on several expert perspectives (world, mechanics, art, monetization).
    Provide concise, actionable feedback. Focus on potential weaknesses, inconsistencies, risks, and suggest concrete improvements.
    The goal is to refine the concept, not to discard it.

    ${promptConfig.style.isNotEmpty ? 'Style: ${promptConfig.style}\n' : ''}
    Concept Snippets:
    ${input.keywords.join("\n- ")}
    ${promptConfig.example.isNotEmpty ? 'Example: ${promptConfig.example}\n' : ''}
    
    Critical Feedback (strengths, weaknesses, suggestions):
    ''';
    final response = await llmService.generateContent(prompt);
    return response.trim();
  }
}

/// A specialized agent that optimizes prompts for better AI generation results.
class PromptOptimizerAgent implements ConceptAgent {
  PromptOptimizerAgent({
    this.promptConfig = const PromptConfig(),
    this.accessibilityProfile = const AccessibilityProfile(
      id: 'default-profile',
      name: 'Default Profile',
      description: 'Default accessibility profile for prompt optimization',
      skillLevel: SkillLevel.intermediate,
      learningStyle: LearningStyle.visual,
    ),
    this.ideationContext = const IdeationContext(),
  });

  final PromptConfig promptConfig;
  final AccessibilityProfile accessibilityProfile;
  final IdeationContext ideationContext;

  @override
  Future<String> generatePart(ConceptGenerationInput input) async {
    // Create a mock ideation method for optimization
    final mockMethod = IdeationMethod(
      id: 'prompt-optimization',
      name: 'Prompt Optimization',
      description: 'Optimize prompts for better AI generation',
      category: IdeationCategory.experimental,
      duration: Duration(minutes: 5),
      participants: ParticipantRange.solo,
      complexity: Complexity.simple,
      steps: [],
      tags: ['prompt', 'optimization', 'ai', 'generation'],
      aiSupport: true,
    );

    // Optimize the prompt using the prompt optimizer
    final optimizedPrompt = PromptOptimizationService.optimizePrompt(
      originalPrompt: input.keywords.join(' '),
      method: mockMethod,
      userProfile: accessibilityProfile,
      context: ideationContext,
    );

    return '''
    **Prompt Optimization Results:**
    
    **Original Prompt:** ${input.keywords.join(' ')}
    
    **Optimized Prompt:** ${optimizedPrompt.prompt}
    
    **Optimization Confidence:** ${(optimizedPrompt.confidence * 100).toStringAsFixed(1)}%
    **Expected Improvement:** ${(optimizedPrompt.expectedImprovement * 100).toStringAsFixed(1)}%
    
    **Applied Strategies:**
    ${optimizedPrompt.optimization.strategies.map((s) => '• ${s.description}').join('\n')}
    
    **Analysis Scores:**
    • Clarity: ${(optimizedPrompt.optimization.analysis.clarity * 100).toStringAsFixed(1)}%
    • Specificity: ${(optimizedPrompt.optimization.analysis.specificity * 100).toStringAsFixed(1)}%
    • Accessibility: ${(optimizedPrompt.optimization.analysis.accessibility * 100).toStringAsFixed(1)}%
    • Creativity: ${(optimizedPrompt.optimization.analysis.creativity * 100).toStringAsFixed(1)}%
    • Contextuality: ${(optimizedPrompt.optimization.analysis.contextuality * 100).toStringAsFixed(1)}%
    ''';
  }

  /// Optimize a specific prompt for a given ideation method
  Future<OptimizedPrompt> optimizePromptForMethod({
    required String originalPrompt,
    required IdeationMethod method,
  }) async {
    return PromptOptimizationService.optimizePrompt(
      originalPrompt: originalPrompt,
      method: method,
      userProfile: accessibilityProfile,
      context: ideationContext,
    );
  }

  /// Batch optimize multiple prompts
  Future<List<OptimizedPrompt>> optimizePromptBatch({
    required List<String> prompts,
    required IdeationMethod method,
  }) async {
    return PromptOptimizationService.optimizePromptBatch(
      prompts: prompts,
      method: method,
      userProfile: accessibilityProfile,
      context: ideationContext,
    );
  }

  /// Provide feedback to improve future optimizations
  void provideFeedback({
    required PromptOptimization optimization,
    required double actualImprovement,
    required String feedback,
  }) {
    PromptOptimizationService.provideFeedback(
      optimization: optimization,
      actualImprovement: actualImprovement,
      feedback: feedback,
    );
  }
}

/// Configuration for customizing agent prompts.
class PromptConfig {
  final String context;
  final String example;
  final String style;

  const PromptConfig({
    this.context = '',
    this.example = '',
    this.style = '',
  });
} 