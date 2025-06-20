import 'package:flutter/foundation.dart';

@immutable
class IdeationMethod {
  const IdeationMethod({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.duration,
    required this.participants,
    required this.complexity,
    required this.steps,
    this.materials = const [],
    this.examples = const [],
    this.variations = const [],
    this.successRate = 0.0,
    this.tags = const [],
    this.aiSupport = false,
  });

  final String id;
  final String name;
  final String description;
  final IdeationCategory category;
  final Duration duration;
  final ParticipantRange participants;
  final Complexity complexity;
  final List<IdeationStep> steps;
  final List<String> materials;
  final List<IdeationExample> examples;
  final List<IdeationVariation> variations;
  final double successRate; // 0.0 to 1.0
  final List<String> tags;
  final bool aiSupport; // Whether AI can assist with this method
}

enum IdeationCategory {
  brainstorming, // Classic brainstorming techniques
  constraintBased, // Using constraints to spark creativity
  randomStimulation, // Random elements to trigger ideas
  analogy, // Using analogies and metaphors
  collaboration, // Team-based ideation
  research, // Research-driven ideation
  experimental, // Experimental and avant-garde methods
  gamification, // Game-like ideation processes
}

enum ParticipantRange {
  solo, // 1 person
  small, // 2-4 people
  medium, // 5-8 people
  large, // 9-15 people
  massive, // 15+ people
}

enum Complexity {
  simple, // Easy to understand and execute
  moderate, // Some complexity but manageable
  advanced, // Requires experience and preparation
  expert, // Complex method for experienced teams
}

@immutable
class IdeationStep {
  const IdeationStep({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.order,
    this.instructions = const [],
    this.tips = const [],
    this.warnings = const [],
    this.aiPrompts = const [], // AI prompts for this step
  });

  final String id;
  final String title;
  final String description;
  final Duration duration;
  final int order;
  final List<String> instructions;
  final List<String> tips;
  final List<String> warnings;
  final List<String> aiPrompts;
}

@immutable
class IdeationExample {
  const IdeationExample({
    required this.title,
    required this.description,
    required this.result,
    this.lessonsLearned = const [],
  });

  final String title;
  final String description;
  final String result;
  final List<String> lessonsLearned;
}

@immutable
class IdeationVariation {
  const IdeationVariation({
    required this.name,
    required this.description,
    required this.modifications,
    this.useCase,
  });

  final String name;
  final String description;
  final List<String> modifications;
  final String? useCase;
}

@immutable
class IdeationSession {
  const IdeationSession({
    required this.id,
    required this.method,
    required this.participants,
    required this.startTime,
    required this.duration,
    this.ideas = const [],
    this.notes = const [],
    this.outcomes = const [],
    this.followUp = const [],
  });

  final String id;
  final IdeationMethod method;
  final List<String> participants;
  final DateTime startTime;
  final Duration duration;
  final List<GeneratedIdea> ideas;
  final List<String> notes;
  final List<String> outcomes;
  final List<String> followUp;
}

@immutable
class GeneratedIdea {
  const GeneratedIdea({
    required this.id,
    required this.title,
    required this.description,
    required this.method,
    required this.participants,
    required this.timestamp,
    this.tags = const [],
    this.rating = 0,
    this.development = IdeaDevelopment.raw,
    this.feedback = const [],
    this.variations = const [],
  });

  final String id;
  final String title;
  final String description;
  final String method;
  final List<String> participants;
  final DateTime timestamp;
  final List<String> tags;
  final int rating; // 1-10 scale
  final IdeaDevelopment development;
  final List<String> feedback;
  final List<String> variations;
}

enum IdeaDevelopment {
  raw, // Just generated, needs refinement
  refined, // Basic refinement applied
  developed, // Well-developed concept
  prototyped, // Has working prototype
  completed, // Fully implemented
}

// Predefined ideation methods for game jams
class GameJamIdeationMethods {
  static const List<IdeationMethod> methods = [
    // BRAINSTORMING METHODS
    IdeationMethod(
      id: 'crazy-8s',
      name: 'Crazy 8s',
      description: 'Rapid sketching method to generate 8 game concepts in 8 minutes',
      category: IdeationCategory.brainstorming,
      duration: Duration(minutes: 8),
      participants: ParticipantRange.small,
      complexity: Complexity.simple,
      successRate: 0.85,
      tags: ['rapid', 'sketching', 'visual', 'quick'],
      aiSupport: true,
      steps: [
        IdeationStep(
          id: 'setup',
          title: 'Setup',
          description: 'Prepare paper and pens for each participant',
          duration: Duration(minutes: 1),
          order: 1,
          instructions: [
            'Fold paper into 8 sections',
            'Set timer for 8 minutes',
            'Each person gets one paper'
          ],
        ),
        IdeationStep(
          id: 'sketch',
          title: 'Rapid Sketching',
          description: 'Sketch 8 different game concepts, one per section',
          duration: Duration(minutes: 8),
          order: 2,
          instructions: [
            'Draw one game concept per section',
            'Focus on core gameplay',
            'Don\'t worry about art quality',
            'Keep moving quickly'
          ],
          aiPrompts: [
            'Generate 8 unique game concepts for rapid sketching',
            'Create simple gameplay mechanics for each concept',
            'Suggest visual elements for each game idea'
          ],
        ),
      ],
      examples: [
        IdeationExample(
          title: 'Puzzle Platformer',
          description: 'Generated 8 different puzzle mechanics',
          result: 'Created "Gravity Shift" - a platformer where players control gravity direction',
          lessonsLearned: ['Simple mechanics work best', 'Visual clarity is key'],
        ),
      ],
    ),

    // CONSTRAINT-BASED METHODS
    IdeationMethod(
      id: 'constraint-challenge',
      name: 'Constraint Challenge',
      description: 'Use specific constraints to force creative solutions',
      category: IdeationCategory.constraintBased,
      duration: Duration(minutes: 15),
      participants: ParticipantRange.medium,
      complexity: Complexity.moderate,
      successRate: 0.78,
      tags: ['constraints', 'creative', 'problem-solving'],
      aiSupport: true,
      steps: [
        IdeationStep(
          id: 'constraints',
          title: 'Define Constraints',
          description: 'Select 3-5 challenging constraints',
          duration: Duration(minutes: 3),
          order: 1,
          instructions: [
            'Choose technical constraints (e.g., "only use circles")',
            'Add gameplay constraints (e.g., "no jumping")',
            'Include theme constraints (e.g., "must be underwater")'
          ],
          aiPrompts: [
            'Generate creative constraints for game development',
            'Suggest technical limitations that spark creativity',
            'Create theme-based constraints for game jams'
          ],
        ),
        IdeationStep(
          id: 'ideate',
          title: 'Ideate Within Constraints',
          description: 'Generate ideas that work within all constraints',
          duration: Duration(minutes: 12),
          order: 2,
          instructions: [
            'List all constraints clearly',
            'Brainstorm solutions for each constraint',
            'Combine solutions into coherent concepts',
            'Focus on how constraints create opportunities'
          ],
        ),
      ],
    ),

    // RANDOM STIMULATION METHODS
    IdeationMethod(
      id: 'random-word-generator',
      name: 'Random Word Generator',
      description: 'Use random words to trigger unexpected game concepts',
      category: IdeationCategory.randomStimulation,
      duration: Duration(minutes: 10),
      participants: ParticipantRange.solo,
      complexity: Complexity.simple,
      successRate: 0.72,
      tags: ['random', 'unexpected', 'creative'],
      aiSupport: true,
      steps: [
        IdeationStep(
          id: 'generate',
          title: 'Generate Random Words',
          description: 'Get 3-5 random words to work with',
          duration: Duration(minutes: 1),
          order: 1,
          instructions: [
            'Use random word generator',
            'Select 3-5 diverse words',
            'Include nouns, verbs, and adjectives'
          ],
          aiPrompts: [
            'Generate random words for game ideation',
            'Create diverse word combinations for creativity',
            'Suggest thematic word sets for game concepts'
          ],
        ),
        IdeationStep(
          id: 'connect',
          title: 'Connect Words to Game Concepts',
          description: 'Create game ideas that incorporate all words',
          duration: Duration(minutes: 9),
          order: 2,
          instructions: [
            'Write down all words',
            'Think of how they could relate to gameplay',
            'Create mechanics around word meanings',
            'Develop a coherent concept using all words'
          ],
        ),
      ],
    ),

    // ANALOGY METHODS
    IdeationMethod(
      id: 'mechanical-analogies',
      name: 'Mechanical Analogies',
      description: 'Use real-world mechanics as analogies for game systems',
      category: IdeationCategory.analogy,
      duration: Duration(minutes: 20),
      participants: ParticipantRange.medium,
      complexity: Complexity.moderate,
      successRate: 0.81,
      tags: ['analogy', 'mechanics', 'real-world'],
      aiSupport: true,
      steps: [
        IdeationStep(
          id: 'observe',
          title: 'Observe Real-World Mechanics',
          description: 'Identify interesting real-world systems',
          duration: Duration(minutes: 5),
          order: 1,
          instructions: [
            'Think about everyday objects and systems',
            'Consider natural phenomena',
            'Look at machines and processes',
            'Identify what makes them interesting'
          ],
          aiPrompts: [
            'Suggest real-world mechanics for game analogies',
            'Identify interesting systems from nature',
            'Find mechanical processes that could inspire games'
          ],
        ),
        IdeationStep(
          id: 'translate',
          title: 'Translate to Game Mechanics',
          description: 'Convert real-world mechanics into game systems',
          duration: Duration(minutes: 15),
          order: 2,
          instructions: [
            'Break down the real-world system',
            'Identify core principles',
            'Design game mechanics that mirror these principles',
            'Add game-specific elements'
          ],
        ),
      ],
    ),

    // COLLABORATION METHODS
    IdeationMethod(
      id: 'idea-snowball',
      name: 'Idea Snowball',
      description: 'Build on each other\'s ideas in a collaborative chain',
      category: IdeationCategory.collaboration,
      duration: Duration(minutes: 15),
      participants: ParticipantRange.medium,
      complexity: Complexity.simple,
      successRate: 0.88,
      tags: ['collaboration', 'building', 'chain'],
      aiSupport: false,
      steps: [
        IdeationStep(
          id: 'start',
          title: 'Start with One Idea',
          description: 'Begin with a simple game concept',
          duration: Duration(minutes: 2),
          order: 1,
          instructions: [
            'One person starts with a basic idea',
            'Keep it simple and open-ended',
            'Write it down clearly'
          ],
        ),
        IdeationStep(
          id: 'build',
          title: 'Build on Each Idea',
          description: 'Each person adds to the previous idea',
          duration: Duration(minutes: 13),
          order: 2,
          instructions: [
            'Pass the idea to the next person',
            'Add one significant element',
            'Don\'t criticize, only build',
            'Keep the chain going'
          ],
        ),
      ],
    ),

    // RESEARCH METHODS
    IdeationMethod(
      id: 'trend-analysis',
      name: 'Trend Analysis',
      description: 'Research current trends to inspire game concepts',
      category: IdeationCategory.research,
      duration: Duration(minutes: 25),
      participants: ParticipantRange.small,
      complexity: Complexity.advanced,
      successRate: 0.75,
      tags: ['research', 'trends', 'market'],
      aiSupport: true,
      steps: [
        IdeationStep(
          id: 'research',
          title: 'Research Current Trends',
          description: 'Identify relevant trends in gaming and technology',
          duration: Duration(minutes: 10),
          order: 1,
          instructions: [
            'Look at current game releases',
            'Research emerging technologies',
            'Check social media trends',
            'Analyze market data'
          ],
          aiPrompts: [
            'Analyze current gaming trends',
            'Identify emerging technologies for games',
            'Research popular game mechanics'
          ],
        ),
        IdeationStep(
          id: 'synthesize',
          title: 'Synthesize Trends into Ideas',
          description: 'Combine trends into innovative game concepts',
          duration: Duration(minutes: 15),
          order: 2,
          instructions: [
            'Identify trend combinations',
            'Look for gaps in the market',
            'Consider how trends could interact',
            'Create unique value propositions'
          ],
        ),
      ],
    ),

    // EXPERIMENTAL METHODS
    IdeationMethod(
      id: 'reverse-design',
      name: 'Reverse Design',
      description: 'Start with the end result and work backwards',
      category: IdeationCategory.experimental,
      duration: Duration(minutes: 20),
      participants: ParticipantRange.small,
      complexity: Complexity.advanced,
      successRate: 0.68,
      tags: ['experimental', 'reverse', 'backwards'],
      aiSupport: true,
      steps: [
        IdeationStep(
          id: 'define-end',
          title: 'Define the End Result',
          description: 'Describe what the final game experience should be',
          duration: Duration(minutes: 5),
          order: 1,
          instructions: [
            'Describe the player\'s final experience',
            'Define the emotional impact',
            'Specify the core feeling',
            'Detail the memorable moments'
          ],
          aiPrompts: [
            'Generate emotional game experiences',
            'Create memorable game moments',
            'Define impactful player experiences'
          ],
        ),
        IdeationStep(
          id: 'work-backwards',
          title: 'Work Backwards',
          description: 'Design mechanics that lead to the desired end result',
          duration: Duration(minutes: 15),
          order: 2,
          instructions: [
            'Identify what leads to the end result',
            'Design mechanics that build towards it',
            'Create progression systems',
            'Ensure coherence in the journey'
          ],
        ),
      ],
    ),

    // GAMIFICATION METHODS
    IdeationMethod(
      id: 'ideation-game',
      name: 'Ideation Game',
      description: 'Turn ideation into a competitive game',
      category: IdeationCategory.gamification,
      duration: Duration(minutes: 30),
      participants: ParticipantRange.large,
      complexity: Complexity.moderate,
      successRate: 0.82,
      tags: ['gamification', 'competitive', 'fun'],
      aiSupport: false,
      steps: [
        IdeationStep(
          id: 'setup-game',
          title: 'Setup the Game',
          description: 'Create rules and scoring system',
          duration: Duration(minutes: 5),
          order: 1,
          instructions: [
            'Define scoring criteria',
            'Set time limits',
            'Create teams',
            'Establish rules'
          ],
        ),
        IdeationStep(
          id: 'play',
          title: 'Play the Ideation Game',
          description: 'Generate ideas competitively',
          duration: Duration(minutes: 20),
          order: 2,
          instructions: [
            'Teams compete for points',
            'Present ideas to judges',
            'Get feedback and scores',
            'Iterate and improve'
          ],
        ),
        IdeationStep(
          id: 'results',
          title: 'Review Results',
          description: 'Evaluate and select best ideas',
          duration: Duration(minutes: 5),
          order: 3,
          instructions: [
            'Announce winners',
            'Discuss best ideas',
            'Plan next steps',
            'Celebrate creativity'
          ],
        ),
      ],
    ),
  ];

  // Get methods by category
  static List<IdeationMethod> getByCategory(IdeationCategory category) {
    return methods.where((method) => method.category == category).toList();
  }

  // Get methods by complexity
  static List<IdeationMethod> getByComplexity(Complexity complexity) {
    return methods.where((method) => method.complexity == complexity).toList();
  }

  // Get methods by duration
  static List<IdeationMethod> getByDuration(Duration maxDuration) {
    return methods.where((method) => method.duration <= maxDuration).toList();
  }

  // Get AI-supported methods
  static List<IdeationMethod> getAISupported() {
    return methods.where((method) => method.aiSupport).toList();
  }

  // Get methods by tags
  static List<IdeationMethod> getByTags(List<String> tags) {
    return methods.where((method) => 
      tags.any((tag) => method.tags.contains(tag))
    ).toList();
  }
}

// AI-powered ideation assistance
@immutable
class AIIdeationAssistant {
  const AIIdeationAssistant({
    required this.method,
    required this.prompts,
    this.context = const {},
  });

  final IdeationMethod method;
  final List<String> prompts;
  final Map<String, dynamic> context;

  // Generate AI prompts for a specific method step
  List<String> getPromptsForStep(String stepId) {
    final step = method.steps.firstWhere((s) => s.id == stepId);
    return step.aiPrompts;
  }

  // Get contextual prompts based on current session
  List<String> getContextualPrompts(IdeationSession session) {
    final basePrompts = prompts;
    final contextualPrompts = <String>[];
    
    // Add context-specific prompts
    if (session.ideas.isNotEmpty) {
      contextualPrompts.add('Based on previous ideas: ${session.ideas.map((i) => i.title).join(', ')}, generate new variations');
    }
    
    if (session.notes.isNotEmpty) {
      contextualPrompts.add('Consider these notes: ${session.notes.join(', ')}');
    }
    
    return [...basePrompts, ...contextualPrompts];
  }
}

// Ideation session management
@immutable
class IdeationSessionManager {
  const IdeationSessionManager();

  // Create a new ideation session
  IdeationSession createSession({
    required IdeationMethod method,
    required List<String> participants,
    required DateTime startTime,
  }) {
    return IdeationSession(
      id: 'session-${DateTime.now().millisecondsSinceEpoch}',
      method: method,
      participants: participants,
      startTime: startTime,
      duration: method.duration,
    );
  }

  // Add an idea to a session
  IdeationSession addIdea(IdeationSession session, GeneratedIdea idea) {
    return IdeationSession(
      id: session.id,
      method: session.method,
      participants: session.participants,
      startTime: session.startTime,
      duration: session.duration,
      ideas: [...session.ideas, idea],
      notes: session.notes,
      outcomes: session.outcomes,
      followUp: session.followUp,
    );
  }

  // Get session statistics
  Map<String, dynamic> getSessionStats(IdeationSession session) {
    return {
      'totalIdeas': session.ideas.length,
      'averageRating': session.ideas.isEmpty ? 0 : 
        session.ideas.map((i) => i.rating).reduce((a, b) => a + b) / session.ideas.length,
      'developmentBreakdown': _getDevelopmentBreakdown(session.ideas),
      'topTags': _getTopTags(session.ideas),
    };
  }

  Map<IdeaDevelopment, int> _getDevelopmentBreakdown(List<GeneratedIdea> ideas) {
    final breakdown = <IdeaDevelopment, int>{};
    for (final idea in ideas) {
      breakdown[idea.development] = (breakdown[idea.development] ?? 0) + 1;
    }
    return breakdown;
  }

  List<String> _getTopTags(List<GeneratedIdea> ideas) {
    final tagCounts = <String, int>{};
    for (final idea in ideas) {
      for (final tag in idea.tags) {
        tagCounts[tag] = (tagCounts[tag] ?? 0) + 1;
      }
    }
    final sortedEntries = tagCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sortedEntries
        .take(5)
        .map((e) => e.key)
        .toList();
  }
} 