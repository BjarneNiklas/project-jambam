import 'package:flutter/foundation.dart';
import '../domain/ideation_methods.dart';
import '../domain/accessibility_system.dart';

@immutable
class PromptOptimizerAgent {
  const PromptOptimizerAgent({
    required this.id,
    required this.name,
    required this.expertise,
    this.optimizationHistory = const [],
    this.successMetrics = const {},
  });

  final String id;
  final String name;
  final PromptOptimizationExpertise expertise;
  final List<PromptOptimization> optimizationHistory;
  final Map<String, dynamic> successMetrics;

  // Core optimization method
  OptimizedPrompt optimizePrompt({
    required String originalPrompt,
    required IdeationMethod method,
    required AccessibilityProfile userProfile,
    required IdeationContext context,
  }) {
    // Analyze the original prompt
    final analysis = _analyzePrompt(originalPrompt, method, userProfile);
    
    // Generate optimization strategies
    final strategies = _generateOptimizationStrategies(analysis, context);
    
    // Apply optimizations
    final optimizedPrompt = _applyOptimizations(originalPrompt, strategies);
    
    // Create optimization record
    final optimization = PromptOptimization(
      id: 'opt-${DateTime.now().millisecondsSinceEpoch}',
      originalPrompt: originalPrompt,
      optimizedPrompt: optimizedPrompt,
      strategies: strategies,
      analysis: analysis,
      timestamp: DateTime.now(),
      method: method,
      userProfile: userProfile,
    );

    return OptimizedPrompt(
      prompt: optimizedPrompt,
      optimization: optimization,
      confidence: _calculateConfidence(optimization),
      expectedImprovement: _estimateImprovement(optimization),
    );
  }

  // Analyze prompt effectiveness
  PromptAnalysis _analyzePrompt(
    String prompt,
    IdeationMethod method,
    AccessibilityProfile userProfile,
  ) {
    final analysis = PromptAnalysis(
      clarity: _analyzeClarity(prompt),
      specificity: _analyzeSpecificity(prompt, method),
      accessibility: _analyzeAccessibility(prompt, userProfile),
      creativity: _analyzeCreativity(prompt),
      contextuality: _analyzeContextuality(prompt, method),
      length: _analyzeLength(prompt),
      structure: _analyzeStructure(prompt),
    );

    return analysis;
  }

  // Generate optimization strategies
  List<OptimizationStrategy> _generateOptimizationStrategies(
    PromptAnalysis analysis,
    IdeationContext context,
  ) {
    final strategies = <OptimizationStrategy>[];

    // Clarity improvements
    if (analysis.clarity < 0.7) {
      strategies.add(OptimizationStrategy(
        type: OptimizationType.clarity,
        description: 'Improve prompt clarity and readability',
        modifications: [
          'Use simpler language',
          'Break down complex concepts',
          'Add examples',
          'Remove jargon',
        ],
      ));
    }

    // Specificity improvements
    if (analysis.specificity < 0.6) {
      strategies.add(OptimizationStrategy(
        type: OptimizationType.specificity,
        description: 'Make prompt more specific to the method',
        modifications: [
          'Add method-specific instructions',
          'Include concrete examples',
          'Specify expected output format',
          'Add constraints and parameters',
        ],
      ));
    }

    // Accessibility improvements
    if (analysis.accessibility < 0.8) {
      strategies.add(OptimizationStrategy(
        type: OptimizationType.accessibility,
        description: 'Improve accessibility for user profile',
        modifications: [
          'Adjust language complexity',
          'Add visual descriptions',
          'Include alternative formats',
          'Consider learning style',
        ],
      ));
    }

    // Creativity enhancements
    if (analysis.creativity < 0.7) {
      strategies.add(OptimizationStrategy(
        type: OptimizationType.creativity,
        description: 'Enhance creative potential',
        modifications: [
          'Add divergent thinking cues',
          'Include unexpected elements',
          'Encourage experimentation',
          'Add inspiration triggers',
        ],
      ));
    }

    // Context improvements
    if (analysis.contextuality < 0.6) {
      strategies.add(OptimizationStrategy(
        type: OptimizationType.contextuality,
        description: 'Better integrate with current context',
        modifications: [
          'Reference previous ideas',
          'Include session context',
          'Add time constraints',
          'Consider team dynamics',
        ],
      ));
    }

    return strategies;
  }

  // Apply optimizations to prompt
  String _applyOptimizations(
    String originalPrompt,
    List<OptimizationStrategy> strategies,
  ) {
    String optimizedPrompt = originalPrompt;

    for (final strategy in strategies) {
      optimizedPrompt = _applyStrategy(optimizedPrompt, strategy);
    }

    return optimizedPrompt;
  }

  // Apply individual strategy
  String _applyStrategy(String prompt, OptimizationStrategy strategy) {
    switch (strategy.type) {
      case OptimizationType.clarity:
        return _applyClarityOptimization(prompt);
      case OptimizationType.specificity:
        return _applySpecificityOptimization(prompt);
      case OptimizationType.accessibility:
        return _applyAccessibilityOptimization(prompt);
      case OptimizationType.creativity:
        return _applyCreativityOptimization(prompt);
      case OptimizationType.contextuality:
        return _applyContextualityOptimization(prompt);
      case OptimizationType.length:
        return _applyLengthOptimization(prompt);
      case OptimizationType.structure:
        return _applyStructureOptimization(prompt);
    }
  }

  // Specific optimization methods
  String _applyClarityOptimization(String prompt) {
    // Replace complex words with simpler alternatives
    final clarityMap = {
      'utilize': 'use',
      'implement': 'create',
      'facilitate': 'help',
      'optimize': 'improve',
      'synthesize': 'combine',
      'elaborate': 'explain',
    };

    String optimized = prompt;
    for (final entry in clarityMap.entries) {
      optimized = optimized.replaceAll(entry.key, entry.value);
    }

    // Add examples where helpful
    if (optimized.contains('game concept') && !optimized.contains('example')) {
      optimized += '\n\nExample: A puzzle game where players control gravity direction.';
    }

    return optimized;
  }

  String _applySpecificityOptimization(String prompt) {
    // Add method-specific instructions
    if (prompt.contains('generate') && !prompt.contains('format')) {
      prompt += '\n\nPlease provide your response in a clear, structured format with:';
      prompt += '\n- Main concept';
      prompt += '\n- Core mechanics';
      prompt += '\n- Visual style';
      prompt += '\n- Target audience';
    }

    return prompt;
  }

  String _applyAccessibilityOptimization(String prompt) {
    // Add visual cues for visual learners
    if (!prompt.contains('imagine') && !prompt.contains('visualize')) {
      prompt = 'Imagine and visualize: $prompt';
    }

    // Add step-by-step structure
    if (!prompt.contains('step') && !prompt.contains('first')) {
      prompt += '\n\nTake this step by step:';
      prompt += '\n1. First, consider the core idea';
      prompt += '\n2. Then, think about the mechanics';
      prompt += '\n3. Finally, describe the experience';
    }

    return prompt;
  }

  String _applyCreativityOptimization(String prompt) {
    // Add divergent thinking cues
    if (!prompt.contains('unusual') && !prompt.contains('unexpected')) {
      prompt += '\n\nThink outside the box. Consider unusual or unexpected approaches.';
    }

    // Add inspiration triggers
    if (!prompt.contains('inspire') && !prompt.contains('inspiration')) {
      prompt += '\n\nLet this inspire you to create something unique and memorable.';
    }

    return prompt;
  }

  String _applyContextualityOptimization(String prompt) {
    // Add context awareness
    if (!prompt.contains('context') && !prompt.contains('consider')) {
      prompt += '\n\nConsider the current context and build upon previous ideas.';
    }

    return prompt;
  }

  String _applyLengthOptimization(String prompt) {
    // Optimize length based on complexity
    final wordCount = prompt.split(' ').length;
    
    if (wordCount > 100) {
      // Make it more concise
      final sentences = prompt.split('.');
      if (sentences.length > 3) {
        return "${sentences.take(3).join('.')}.";
      }
    } else if (wordCount < 20) {
      // Add more detail
      prompt += '\n\nPlease provide detailed, specific responses.';
    }

    return prompt;
  }

  String _applyStructureOptimization(String prompt) {
    // Add clear structure if missing
    if (!prompt.contains('\n') && prompt.length > 50) {
      final parts = prompt.split('.');
      if (parts.length > 2) {
        return parts.map((part) => part.trim()).join('.\n\n');
      }
    }

    return prompt;
  }

  // Analysis methods
  double _analyzeClarity(String prompt) {
    // Analyze sentence complexity, word choice, structure
    final complexWords = ['utilize', 'implement', 'facilitate', 'optimize', 'synthesize'];
    final complexWordCount = complexWords.where((word) => prompt.toLowerCase().contains(word)).length;
    
    return (1.0 - (complexWordCount / 10.0)).clamp(0.0, 1.0);
  }

  double _analyzeSpecificity(String prompt, IdeationMethod method) {
    // Check if prompt is specific to the method
    final methodKeywords = method.tags;
    final methodKeywordCount = methodKeywords.where((tag) => prompt.toLowerCase().contains(tag)).length;
    
    return (methodKeywordCount / methodKeywords.length).clamp(0.0, 1.0);
  }

  double _analyzeAccessibility(String prompt, AccessibilityProfile userProfile) {
    // Consider user's accessibility needs
    double score = 1.0;
    
    if (userProfile.accessibilityNeeds.contains(AccessibilityNeed.cognitiveImpairment)) {
      if (prompt.length > 200) score -= 0.3;
      if (prompt.split('.').length > 5) score -= 0.2;
    }
    
    if (userProfile.accessibilityNeeds.contains(AccessibilityNeed.visualImpairment)) {
      if (!prompt.contains('imagine') && !prompt.contains('visualize')) score -= 0.2;
    }
    
    return score.clamp(0.0, 1.0);
  }

  double _analyzeCreativity(String prompt) {
    // Check for creativity-inducing elements
    final creativityKeywords = ['imagine', 'creative', 'unique', 'unusual', 'experiment', 'explore'];
    final creativityCount = creativityKeywords.where((word) => prompt.toLowerCase().contains(word)).length;
    
    return (creativityCount / creativityKeywords.length).clamp(0.0, 1.0);
  }

  double _analyzeContextuality(String prompt, IdeationMethod method) {
    // Check if prompt considers context
    final contextKeywords = ['context', 'previous', 'session', 'team', 'time'];
    final contextCount = contextKeywords.where((word) => prompt.toLowerCase().contains(word)).length;
    
    return (contextCount / contextKeywords.length).clamp(0.0, 1.0);
  }

  double _analyzeLength(String prompt) {
    // Optimal length is 50-150 words
    final wordCount = prompt.split(' ').length;
    
    if (wordCount >= 50 && wordCount <= 150) return 1.0;
    if (wordCount < 30) return 0.5;
    if (wordCount > 200) return 0.3;
    
    return 0.8;
  }

  double _analyzeStructure(String prompt) {
    // Check for clear structure
    final hasParagraphs = prompt.contains('\n\n');
    final hasBulletPoints = prompt.contains('-') || prompt.contains('•');
    final hasNumbering = prompt.contains('1.') || prompt.contains('2.');
    
    double score = 0.5;
    if (hasParagraphs) score += 0.2;
    if (hasBulletPoints) score += 0.2;
    if (hasNumbering) score += 0.1;
    
    return score.clamp(0.0, 1.0);
  }

  // Confidence and improvement estimation
  double _calculateConfidence(PromptOptimization optimization) {
    // Calculate confidence based on optimization quality
    final strategyCount = optimization.strategies.length;
    final analysisScores = [
      optimization.analysis.clarity,
      optimization.analysis.specificity,
      optimization.analysis.accessibility,
      optimization.analysis.creativity,
      optimization.analysis.contextuality,
    ];
    
    final averageScore = analysisScores.reduce((a, b) => a + b) / analysisScores.length;
    final strategyBonus = (strategyCount * 0.1).clamp(0.0, 0.3);
    
    return (averageScore + strategyBonus).clamp(0.0, 1.0);
  }

  double _estimateImprovement(PromptOptimization optimization) {
    // Estimate expected improvement
    final originalScore = _calculatePromptScore(optimization.originalPrompt);
    final optimizedScore = _calculatePromptScore(optimization.optimizedPrompt);
    
    return (optimizedScore - originalScore).clamp(0.0, 1.0);
  }

  double _calculatePromptScore(String prompt) {
    // Simple scoring based on prompt characteristics
    double score = 0.5;
    
    // Length bonus
    final wordCount = prompt.split(' ').length;
    if (wordCount >= 50 && wordCount <= 150) score += 0.2;
    
    // Structure bonus
    if (prompt.contains('\n')) score += 0.1;
    if (prompt.contains('-') || prompt.contains('•')) score += 0.1;
    
    // Clarity bonus
    final complexWords = ['utilize', 'implement', 'facilitate'];
    final complexCount = complexWords.where((word) => prompt.toLowerCase().contains(word)).length;
    score += (1.0 - (complexCount * 0.1)).clamp(0.0, 0.2);
    
    return score.clamp(0.0, 1.0);
  }

  // Batch optimization for multiple prompts
  List<OptimizedPrompt> optimizePromptBatch({
    required List<String> prompts,
    required IdeationMethod method,
    required AccessibilityProfile userProfile,
    required IdeationContext context,
  }) {
    return prompts.map((prompt) => optimizePrompt(
      originalPrompt: prompt,
      method: method,
      userProfile: userProfile,
      context: context,
    )).toList();
  }

  // Learn from feedback
  void learnFromFeedback({
    required PromptOptimization optimization,
    required double actualImprovement,
    required String feedback,
  }) {
    // Update success metrics
    final currentMetrics = Map<String, dynamic>.from(successMetrics);
    final strategyType = optimization.strategies.first.type.toString();
    
    if (!currentMetrics.containsKey(strategyType)) {
      currentMetrics[strategyType] = {
        'count': 0,
        'totalImprovement': 0.0,
        'averageImprovement': 0.0,
      };
    }
    
    final metrics = currentMetrics[strategyType] as Map<String, dynamic>;
    metrics['count'] = (metrics['count'] as int) + 1;
    metrics['totalImprovement'] = (metrics['totalImprovement'] as double) + actualImprovement;
    metrics['averageImprovement'] = (metrics['totalImprovement'] as double) / (metrics['count'] as int);
    
    // Store feedback for future improvements
    // This would typically go to a database or learning system
  }
}

// Supporting classes
@immutable
class OptimizedPrompt {
  const OptimizedPrompt({
    required this.prompt,
    required this.optimization,
    required this.confidence,
    required this.expectedImprovement,
  });

  final String prompt;
  final PromptOptimization optimization;
  final double confidence; // 0.0 to 1.0
  final double expectedImprovement; // 0.0 to 1.0
}

@immutable
class PromptOptimization {
  const PromptOptimization({
    required this.id,
    required this.originalPrompt,
    required this.optimizedPrompt,
    required this.strategies,
    required this.analysis,
    required this.timestamp,
    required this.method,
    required this.userProfile,
  });

  final String id;
  final String originalPrompt;
  final String optimizedPrompt;
  final List<OptimizationStrategy> strategies;
  final PromptAnalysis analysis;
  final DateTime timestamp;
  final IdeationMethod method;
  final AccessibilityProfile userProfile;
}

@immutable
class OptimizationStrategy {
  const OptimizationStrategy({
    required this.type,
    required this.description,
    required this.modifications,
  });

  final OptimizationType type;
  final String description;
  final List<String> modifications;
}

enum OptimizationType {
  clarity, // Improve readability and understanding
  specificity, // Make more specific to method/context
  accessibility, // Improve for user's accessibility needs
  creativity, // Enhance creative potential
  contextuality, // Better integrate with current context
  length, // Optimize prompt length
  structure, // Improve prompt structure
}

@immutable
class PromptAnalysis {
  const PromptAnalysis({
    required this.clarity,
    required this.specificity,
    required this.accessibility,
    required this.creativity,
    required this.contextuality,
    required this.length,
    required this.structure,
  });

  final double clarity; // 0.0 to 1.0
  final double specificity; // 0.0 to 1.0
  final double accessibility; // 0.0 to 1.0
  final double creativity; // 0.0 to 1.0
  final double contextuality; // 0.0 to 1.0
  final double length; // 0.0 to 1.0
  final double structure; // 0.0 to 1.0
}

@immutable
class IdeationContext {
  const IdeationContext({
    this.previousIdeas = const [],
    this.sessionNotes = const [],
    this.timeRemaining,
    this.teamSize = 1,
    this.jamTheme,
    this.technicalConstraints = const [],
  });

  final List<String> previousIdeas;
  final List<String> sessionNotes;
  final Duration? timeRemaining;
  final int teamSize;
  final String? jamTheme;
  final List<String> technicalConstraints;
}

enum PromptOptimizationExpertise {
  beginner, // Basic optimization skills
  intermediate, // Good understanding of prompt engineering
  advanced, // Expert-level optimization
  expert, // Master of prompt optimization
}

// Prompt optimization service
class PromptOptimizationService {
  static final PromptOptimizerAgent _agent = PromptOptimizerAgent(
    id: 'prompt-optimizer-001',
    name: 'JambaM Prompt Optimizer',
    expertise: PromptOptimizationExpertise.advanced,
  );

  static OptimizedPrompt optimizePrompt({
    required String originalPrompt,
    required IdeationMethod method,
    required AccessibilityProfile userProfile,
    required IdeationContext context,
  }) {
    return _agent.optimizePrompt(
      originalPrompt: originalPrompt,
      method: method,
      userProfile: userProfile,
      context: context,
    );
  }

  static List<OptimizedPrompt> optimizePromptBatch({
    required List<String> prompts,
    required IdeationMethod method,
    required AccessibilityProfile userProfile,
    required IdeationContext context,
  }) {
    return _agent.optimizePromptBatch(
      prompts: prompts,
      method: method,
      userProfile: userProfile,
      context: context,
    );
  }

  static void provideFeedback({
    required PromptOptimization optimization,
    required double actualImprovement,
    required String feedback,
  }) {
    _agent.learnFromFeedback(
      optimization: optimization,
      actualImprovement: actualImprovement,
      feedback: feedback,
    );
  }
} 