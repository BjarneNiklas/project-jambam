import 'package:logging/logging.dart' as logging;
import 'package:project_jambam/src/features/a_ideation/application/concept_generation_service.dart';
import 'package:project_jambam/src/features/a_ideation/application/concept_agent.dart' hide PromptOptimizerAgent;
import 'package:project_jambam/src/features/a_ideation/application/prompt_optimizer_agent.dart';
import 'package:project_jambam/src/features/a_ideation/domain/accessibility_system.dart';
import 'package:project_jambam/src/features/a_ideation/domain/ideation_methods.dart';
import 'package:project_jambam/src/features/a_ideation/domain/jam_kit.dart' as jam_kit;

/// Enhanced concept generation service that uses prompt optimization
class EnhancedConceptGenerationService implements ConceptGenerationService {
  EnhancedConceptGenerationService({
    this.accessibilityProfile = const AccessibilityProfile(
      id: 'default-profile',
      name: 'Default User',
      description: 'Default accessibility profile for concept generation',
      skillLevel: SkillLevel.intermediate,
      learningStyle: LearningStyle.visual,
    ),
    this.ideationContext = const IdeationContext(),
    this.enablePromptOptimization = true,
    this.optimizationLevel = OptimizationLevel.standard,
  });

  final AccessibilityProfile accessibilityProfile;
  final IdeationContext ideationContext;
  final bool enablePromptOptimization;
  final OptimizationLevel optimizationLevel;
  
  final logging.Logger _logger = logging.Logger('EnhancedConceptGenerationService');

  // Agent instances
  late final ResearchAgent _research = ResearchAgent();
  late final ThemeAgent _theme = ThemeAgent();
  late final WorldBuilderAgent _worldBuilder = WorldBuilderAgent();
  late final MechanicsAgent _mechanics = MechanicsAgent();
  late final ArtDirectionAgent _artDirection = ArtDirectionAgent();
  late final MonetizationAgent _monetization = MonetizationAgent();
  late final AssetAgent _asset = AssetAgent();
  late final CriticAgent _critic = CriticAgent();
  late final PromptOptimizerAgent _promptOptimizer = PromptOptimizerAgent(
    id: 'prompt-optimizer-agent',
    name: 'Prompt Optimizer Agent',
    expertise: PromptOptimizationExpertise.advanced,
  );

  @override
  Future<jam_kit.JamKit> generateConcept(ConceptGenerationInput input) async {
    _logger.info('Starting concept generation with ${input.keywords.length} keywords');
    
    // Optimize keywords if enabled
    List<String> optimizedKeywords = input.keywords;
    if (enablePromptOptimization) {
      optimizedKeywords = await _optimizeKeywords(input.keywords);
      _logger.info('Keywords optimized from ${input.keywords.length} to ${optimizedKeywords.length}');
    }

    // Create optimized input
    final optimizedInput = ConceptGenerationInput(
      keywords: optimizedKeywords,
      inspirationMode: input.inspirationMode,
      useMechanics: input.useMechanics,
      useMonetization: input.useMonetization,
      generationMode: GenerationMode.jamKit,
    );

    // Generate concept parts using the multi-agent system
    final parts = await _generateConceptParts(optimizedInput);
    
    // Assemble the final JamKit
    final jamKit = _assembleJamKit(parts, optimizedInput);
    
    _logger.info('Concept generation completed successfully');
    return jamKit;
  }

  @override
  Future<jam_kit.JamSeed> generateJamSeed(ConceptGenerationInput input) async {
    // For Jam Seeds, we use a more flexible approach
    final optimizedKeywords = await _optimizeKeywords(input.keywords);
    
    final optimizedInput = ConceptGenerationInput(
      keywords: optimizedKeywords,
      inspirationMode: input.inspirationMode,
      useMechanics: false, // Jam Seeds don't need specific mechanics
      useMonetization: false, // Jam Seeds don't need monetization
      generationMode: GenerationMode.jamSeed,
    );

    final parts = await _generateConceptParts(optimizedInput);
    final jamSeed = _assembleJamSeed(parts, optimizedInput);
    
    _logger.info('Jam Seed generation completed successfully');
    return jamSeed;
  }

  /// Optimize keywords using the prompt optimizer
  Future<List<String>> _optimizeKeywords(List<String> keywords) async {
    if (!enablePromptOptimization) return keywords;
    
    try {
      final optimizedPrompt = _promptOptimizer.optimizePrompt(
        originalPrompt: keywords.join(', '),
        method: _getDefaultMethod(),
        userProfile: accessibilityProfile,
        context: ideationContext,
      );
      
      // Split the optimized prompt back into keywords
      return optimizedPrompt.prompt.split(',').map((k) => k.trim()).toList();
    } catch (e) {
      _logger.warning('Failed to optimize keywords, using original', e);
      return keywords;
    }
  }

  /// Get a default ideation method for optimization
  IdeationMethod _getDefaultMethod() {
    return IdeationMethod(
      id: 'default-method',
      name: 'Default Method',
      description: 'Default method for prompt optimization',
      category: IdeationCategory.brainstorming,
      duration: Duration(minutes: 10),
      participants: ParticipantRange.solo,
      complexity: Complexity.simple,
      steps: [],
      tags: ['optimization', 'default'],
      aiSupport: true,
    );
  }

  /// Generate concept parts using the multi-agent system
  Future<Map<String, String>> _generateConceptParts(ConceptGenerationInput input) async {
    final parts = <String, String>{};

    // Generate research insights and trends
    parts['research'] = await _research.generatePart(input);
    
    // Generate media themes and storytelling
    parts['theme'] = await _theme.generatePart(input);
    
    // Generate world and art direction
    parts['world'] = await _worldBuilder.generatePart(input);
    parts['artDirection'] = await _artDirection.generatePart(input);

    // Generate asset specifications
    parts['assets'] = await _asset.generatePart(input);

    // Conditionally generate mechanics and monetization
    if (input.useMechanics) {
      parts['mechanics'] = await _mechanics.generatePart(input);
    }

    if (input.useMonetization) {
      parts['monetization'] = await _monetization.generatePart(input);
    }

    // Always run critic for feedback
    parts['critic'] = await _critic.generatePart(input);

    return parts;
  }

  /// Assemble a JamKit from concept parts
  jam_kit.JamKit _assembleJamKit(Map<String, String> parts, ConceptGenerationInput input) {
    final title = _generateTitle(input.keywords);
    final description = _assembleDescription(parts);
    
    return jam_kit.JamKit(
      id: 'jam-kit-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      theme: description,
      quests: _generateQuests(parts),
      assetSuggestions: _generateAssetSuggestions(parts),
      inspirationSources: input.keywords,
      kitType: _determineKitType(parts),
      complexity: _determineComplexity(parts),
      estimatedBuildTime: _estimateDevelopmentTime(parts),
    );
  }

  /// Generate quests from concept parts
  List<jam_kit.Quest> _generateQuests(Map<String, String> parts) {
    final quests = <jam_kit.Quest>[];
    
    // Create quests based on the concept parts
    if (parts['world'] != null) {
      quests.add(jam_kit.Quest(
        title: 'Explore the World',
        description: parts['world']!,
      ));
    }
    
    if (parts['mechanics'] != null) {
      quests.add(jam_kit.Quest(
        title: 'Master the Mechanics',
        description: parts['mechanics']!,
      ));
    }
    
    if (parts['artDirection'] != null) {
      quests.add(jam_kit.Quest(
        title: 'Create Visual Style',
        description: parts['artDirection']!,
      ));
    }
    
    return quests;
  }

  /// Generate asset suggestions from concept parts
  List<jam_kit.AssetSuggestion> _generateAssetSuggestions(Map<String, String> parts) {
    final suggestions = <jam_kit.AssetSuggestion>[];
    
    if (parts['assets'] != null) {
      suggestions.add(jam_kit.AssetSuggestion(
        type: '3D Models',
        description: parts['assets']!,
        stylePrompt: 'High quality, detailed 3D models',
      ));
    }
    
    return suggestions;
  }

  /// Determine kit type based on concept parts
  jam_kit.KitType _determineKitType(Map<String, String> parts) {
    if (parts['assets'] != null && parts['assets']!.contains('3D')) {
      return jam_kit.KitType.building;
    }
    return jam_kit.KitType.standard;
  }

  /// Assemble a JamSeed from concept parts
  jam_kit.JamSeed _assembleJamSeed(Map<String, String> parts, ConceptGenerationInput input) {
    final title = _generateTitle(input.keywords);
    
    return jam_kit.JamSeed(
      id: 'jam-seed-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      coreConcept: _assembleDescription(parts),
      inspirationElements: input.keywords,
      creativeConstraints: _generateConstraints(parts),
    );
  }

  /// Generate a title from keywords
  String _generateTitle(List<String> keywords) {
    if (keywords.isEmpty) return 'Untitled Game Concept';
    
    // Simple title generation - combine first few keywords
    final titleKeywords = keywords.take(3).toList();
    return titleKeywords.map((k) => k[0].toUpperCase() + k.substring(1)).join(' ');
  }

  /// Assemble description from concept parts
  String _assembleDescription(Map<String, String> parts) {
    final descriptions = <String>[];
    
    if (parts['research'] != null) {
      descriptions.add('**Research Insights:** ${parts['research']}');
    }
    
    if (parts['theme'] != null) {
      descriptions.add('**Media Themes:** ${parts['theme']}');
    }
    
    if (parts['world'] != null) {
      descriptions.add('**World:** ${parts['world']}');
    }
    
    if (parts['mechanics'] != null) {
      descriptions.add('**Mechanics:** ${parts['mechanics']}');
    }
    
    if (parts['artDirection'] != null) {
      descriptions.add('**Art Direction:** ${parts['artDirection']}');
    }
    
    if (parts['assets'] != null) {
      descriptions.add('**Assets:** ${parts['assets']}');
    }
    
    if (parts['monetization'] != null) {
      descriptions.add('**Monetization:** ${parts['monetization']}');
    }
    
    if (parts['critic'] != null) {
      descriptions.add('**Feedback:** ${parts['critic']}');
    }
    
    return descriptions.join('\n\n');
  }

  // Helper methods for JamKit assembly
  jam_kit.Complexity _determineComplexity(Map<String, String> parts) {
    // Simple complexity determination based on content length and keywords
    final totalLength = parts.values.fold(0, (sum, part) => sum + part.length);
    if (totalLength > 1000) return jam_kit.Complexity.expert;
    if (totalLength > 500) return jam_kit.Complexity.advanced;
    if (totalLength > 200) return jam_kit.Complexity.intermediate;
    return jam_kit.Complexity.beginner;
  }

  Duration _estimateDevelopmentTime(Map<String, String> parts) {
    final complexity = _determineComplexity(parts);
    switch (complexity) {
      case jam_kit.Complexity.beginner:
        return Duration(hours: 8);
      case jam_kit.Complexity.intermediate:
        return Duration(hours: 24);
      case jam_kit.Complexity.advanced:
        return Duration(hours: 48);
      case jam_kit.Complexity.expert:
        return Duration(hours: 72);
    }
  }

  // Helper methods for JamSeed assembly
  List<String> _generateConstraints(Map<String, String> parts) {
    final constraints = <String>[];
    
    if (parts['world'] != null) {
      constraints.add('World-building focused');
    }
    
    if (parts['mechanics'] != null) {
      constraints.add('Mechanics-driven');
    }
    
    if (parts['artDirection'] != null) {
      constraints.add('Visual style emphasis');
    }
    
    return constraints;
  }

  /// Provide feedback to improve future prompt optimizations
  void provideOptimizationFeedback({
    required PromptOptimization optimization,
    required double actualImprovement,
    required String feedback,
  }) {
    // Store feedback for future improvements
    // This would typically go to a database or learning system
    _logger.info('Optimization feedback received: ${(actualImprovement * 100).toStringAsFixed(1)}% improvement');
    _logger.info('Feedback: $feedback');
  }

  /// Provide feedback to improve future concept generation
  void provideConceptFeedback({
    required String conceptId,
    required double rating,
    required String feedback,
    required List<String> improvements,
  }) {
    // Store feedback for future improvements
    // This would typically go to a database or learning system
    _logger.info('Feedback received for concept $conceptId: ${rating.toStringAsFixed(1)}/10');
    _logger.info('Feedback: $feedback');
    _logger.info('Suggested improvements: ${improvements.join(', ')}');
  }

  /// Get optimization statistics
  Map<String, dynamic> getOptimizationStats() {
    // This would typically return actual statistics from the optimizer
    return {
      'totalOptimizations': 0,
      'averageImprovement': 0.0,
      'successRate': 0.0,
      'mostEffectiveStrategies': [],
    };
  }
}

/// Optimization levels for prompt optimization
enum OptimizationLevel {
  minimal, // Basic optimization only
  standard, // Balanced optimization
  aggressive, // Maximum optimization
  adaptive, // Adaptive based on context
} 