import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domain/multi_agent_system.dart';

/// Creative Director Agent Service
/// Verantwortlich für Game Design, Storytelling und UX/UI Design
class CreativeDirectorAgentService {
  static const String _baseUrl = 'http://localhost:8000';
  
  /// Erstellt ein vollständiges Game Design Document
  Future<GameDesignDocument> createGameDesign({
    required String concept,
    required String targetAudience,
    required List<String> researchData,
    required Map<String, dynamic> preferences,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/creative-director/design'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'concept': concept,
          'target_audience': targetAudience,
          'research_data': researchData,
          'preferences': preferences,
          'include_mechanics': true,
          'include_narrative': true,
          'include_ux': true,
          'include_accessibility': true,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _parseGameDesignDocument(data);
      } else {
        throw Exception('Failed to create game design: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback: Mock implementation
      return _createMockGameDesign(concept, targetAudience);
    }
  }

  /// Generiert Game Mechanics basierend auf Research
  Future<List<GameMechanic>> generateMechanics({
    required String genre,
    required String targetAudience,
    required List<String> researchData,
    required double complexity,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/creative-director/mechanics'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'genre': genre,
          'target_audience': targetAudience,
          'research_data': researchData,
          'complexity': complexity,
          'include_core': true,
          'include_secondary': true,
          'include_accessibility': true,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _parseGameMechanics(data['mechanics']);
      } else {
        throw Exception('Failed to generate mechanics: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback: Mock implementation
      return _createMockMechanics(genre, complexity);
    }
  }

  /// Erstellt Narrative Structure
  Future<NarrativeStructure> createNarrative({
    required String theme,
    required String setting,
    required String targetAudience,
    required NarrativeStyle style,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/creative-director/narrative'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'theme': theme,
          'setting': setting,
          'target_audience': targetAudience,
          'style': style.toString().split('.').last,
          'include_characters': true,
          'include_story_beats': true,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _parseNarrativeStructure(data);
      } else {
        throw Exception('Failed to create narrative: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback: Mock implementation
      return _createMockNarrative(theme, setting, style);
    }
  }

  /// Generiert UX/UI Design
  Future<UXDesign> createUXDesign({
    required String targetPlatform,
    required String targetAudience,
    required List<String> userFlows,
    required AccessibilityLevel accessibility,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/creative-director/ux-design'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'target_platform': targetPlatform,
          'target_audience': targetAudience,
          'user_flows': userFlows,
          'accessibility_level': accessibility.toString().split('.').last,
          'include_patterns': true,
          'include_accessibility': true,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _parseUXDesign(data);
      } else {
        throw Exception('Failed to create UX design: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback: Mock implementation
      return _createMockUXDesign(targetPlatform, accessibility);
    }
  }

  /// Erstellt Accessibility Features
  Future<AccessibilityFeatures> createAccessibilityFeatures({
    required String targetAudience,
    required AccessibilityLevel level,
    required List<String> requirements,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/creative-director/accessibility'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'target_audience': targetAudience,
          'level': level.toString().split('.').last,
          'requirements': requirements,
          'include_screen_reader': true,
          'include_keyboard_nav': true,
          'include_color_blind': true,
          'include_hearing': true,
          'include_motor': true,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _parseAccessibilityFeatures(data);
      } else {
        throw Exception('Failed to create accessibility features: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback: Mock implementation
      return _createMockAccessibilityFeatures(level);
    }
  }

  // Mock Implementations für Fallback
  GameDesignDocument _createMockGameDesign(String concept, String targetAudience) {
    return GameDesignDocument(
      title: 'AI-Generated Game: $concept',
      genre: 'Adventure',
      targetAudience: targetAudience,
      mechanics: _createMockMechanics('Adventure', 0.7),
      narrative: _createMockNarrative('Exploration', 'Sci-Fi World', NarrativeStyle.linear),
      uxDesign: _createMockUXDesign('Mobile', AccessibilityLevel.intermediate),
      accessibility: _createMockAccessibilityFeatures(AccessibilityLevel.intermediate),
    );
  }

  List<GameMechanic> _createMockMechanics(String genre, double complexity) {
    return [
      GameMechanic(
        name: 'Exploration',
        description: 'Discover new areas and secrets',
        type: MechanicType.core,
        complexity: complexity,
        dependencies: [],
      ),
      GameMechanic(
        name: 'Puzzle Solving',
        description: 'Solve environmental puzzles',
        type: MechanicType.secondary,
        complexity: complexity * 0.8,
        dependencies: ['Exploration'],
      ),
      GameMechanic(
        name: 'Accessibility Controls',
        description: 'Customizable controls for different abilities',
        type: MechanicType.accessibility,
        complexity: 0.3,
        dependencies: [],
      ),
    ];
  }

  NarrativeStructure _createMockNarrative(String theme, String setting, NarrativeStyle style) {
    return NarrativeStructure(
      theme: theme,
      setting: setting,
      storyBeats: [
        StoryBeat(
          id: 'intro',
          description: 'Player discovers the mysterious world',
          order: 1,
          type: BeatType.introduction,
          triggers: ['game_start'],
        ),
        StoryBeat(
          id: 'conflict',
          description: 'Main challenge is revealed',
          order: 2,
          type: BeatType.conflict,
          triggers: ['exploration_50%'],
        ),
        StoryBeat(
          id: 'climax',
          description: 'Final confrontation',
          order: 3,
          type: BeatType.climax,
          triggers: ['exploration_90%'],
        ),
        StoryBeat(
          id: 'resolution',
          description: 'Story conclusion',
          order: 4,
          type: BeatType.resolution,
          triggers: ['final_puzzle_solved'],
        ),
      ],
      characters: [
        Character(
          name: 'Protagonist',
          description: 'The player character',
          role: CharacterRole.protagonist,
          traits: ['Curious', 'Determined', 'Adaptable'],
          arc: CharacterArc.positive,
        ),
        Character(
          name: 'Guide',
          description: 'Mysterious helper character',
          role: CharacterRole.supporting,
          traits: ['Wise', 'Mysterious', 'Helpful'],
          arc: CharacterArc.flat,
        ),
      ],
      style: style,
    );
  }

  UXDesign _createMockUXDesign(String targetPlatform, AccessibilityLevel accessibility) {
    return UXDesign(
      targetPlatform: targetPlatform,
      patterns: [UIPattern.card, UIPattern.navigation, UIPattern.modal],
      accessibility: accessibility,
      userFlows: [
        'Main Menu → Game Start',
        'In-Game → Pause Menu',
        'Settings → Accessibility Options',
      ],
    );
  }

  AccessibilityFeatures _createMockAccessibilityFeatures(AccessibilityLevel level) {
    return AccessibilityFeatures(
      screenReaderSupport: level != AccessibilityLevel.basic,
      keyboardNavigation: true,
      colorBlindSupport: level != AccessibilityLevel.basic,
      hearingImpairedSupport: level == AccessibilityLevel.advanced || level == AccessibilityLevel.expert,
      motorImpairedSupport: level == AccessibilityLevel.expert,
      customFeatures: level == AccessibilityLevel.expert ? ['Eye tracking', 'Voice control'] : [],
    );
  }

  // Parser Methods
  GameDesignDocument _parseGameDesignDocument(Map<String, dynamic> data) {
    return GameDesignDocument(
      title: data['title'] ?? 'Unknown Game',
      genre: data['genre'] ?? 'Adventure',
      targetAudience: data['target_audience'] ?? 'General',
      mechanics: _parseGameMechanics(data['mechanics'] ?? []),
      narrative: _parseNarrativeStructure(data['narrative'] ?? {}),
      uxDesign: _parseUXDesign(data['ux_design'] ?? {}),
      accessibility: _parseAccessibilityFeatures(data['accessibility'] ?? {}),
    );
  }

  List<GameMechanic> _parseGameMechanics(List<dynamic> mechanics) {
    return mechanics.map((m) => GameMechanic(
      name: m['name'] ?? 'Unknown',
      description: m['description'] ?? '',
      type: _parseMechanicType(m['type']),
      complexity: (m['complexity'] ?? 0.5).toDouble(),
      dependencies: List<String>.from(m['dependencies'] ?? []),
    )).toList();
  }

  MechanicType _parseMechanicType(String? type) {
    switch (type) {
      case 'core': return MechanicType.core;
      case 'secondary': return MechanicType.secondary;
      case 'optional': return MechanicType.optional;
      case 'accessibility': return MechanicType.accessibility;
      default: return MechanicType.secondary;
    }
  }

  NarrativeStructure _parseNarrativeStructure(Map<String, dynamic> data) {
    return NarrativeStructure(
      theme: data['theme'] ?? 'Unknown',
      setting: data['setting'] ?? 'Unknown',
      storyBeats: _parseStoryBeats(data['story_beats'] ?? []),
      characters: _parseCharacters(data['characters'] ?? []),
      style: _parseNarrativeStyle(data['style']),
    );
  }

  List<StoryBeat> _parseStoryBeats(List<dynamic> beats) {
    return beats.map((b) => StoryBeat(
      id: b['id'] ?? 'unknown',
      description: b['description'] ?? '',
      order: b['order'] ?? 0,
      type: _parseBeatType(b['type']),
      triggers: List<String>.from(b['triggers'] ?? []),
    )).toList();
  }

  BeatType _parseBeatType(String? type) {
    switch (type) {
      case 'introduction': return BeatType.introduction;
      case 'conflict': return BeatType.conflict;
      case 'climax': return BeatType.climax;
      case 'resolution': return BeatType.resolution;
      case 'optional': return BeatType.optional;
      default: return BeatType.introduction;
    }
  }

  List<Character> _parseCharacters(List<dynamic> characters) {
    return characters.map((c) => Character(
      name: c['name'] ?? 'Unknown',
      description: c['description'] ?? '',
      role: _parseCharacterRole(c['role']),
      traits: List<String>.from(c['traits'] ?? []),
      arc: _parseCharacterArc(c['arc']),
    )).toList();
  }

  CharacterRole _parseCharacterRole(String? role) {
    switch (role) {
      case 'protagonist': return CharacterRole.protagonist;
      case 'antagonist': return CharacterRole.antagonist;
      case 'supporting': return CharacterRole.supporting;
      case 'npc': return CharacterRole.npc;
      default: return CharacterRole.supporting;
    }
  }

  CharacterArc _parseCharacterArc(String? arc) {
    switch (arc) {
      case 'flat': return CharacterArc.flat;
      case 'positive': return CharacterArc.positive;
      case 'negative': return CharacterArc.negative;
      case 'complex': return CharacterArc.complex;
      default: return CharacterArc.flat;
    }
  }

  NarrativeStyle _parseNarrativeStyle(String? style) {
    switch (style) {
      case 'linear': return NarrativeStyle.linear;
      case 'branching': return NarrativeStyle.branching;
      case 'emergent': return NarrativeStyle.emergent;
      case 'environmental': return NarrativeStyle.environmental;
      default: return NarrativeStyle.linear;
    }
  }

  UXDesign _parseUXDesign(Map<String, dynamic> data) {
    return UXDesign(
      targetPlatform: data['target_platform'] ?? 'Unknown',
      patterns: _parseUIPatterns(data['patterns'] ?? []),
      accessibility: _parseAccessibilityLevel(data['accessibility_level']),
      userFlows: List<String>.from(data['user_flows'] ?? []),
    );
  }

  List<UIPattern> _parseUIPatterns(List<dynamic> patterns) {
    return patterns.map((p) {
      switch (p) {
        case 'card': return UIPattern.card;
        case 'list': return UIPattern.list;
        case 'grid': return UIPattern.grid;
        case 'modal': return UIPattern.modal;
        case 'navigation': return UIPattern.navigation;
        case 'form': return UIPattern.form;
        case 'dashboard': return UIPattern.dashboard;
        default: return UIPattern.card;
      }
    }).toList();
  }

  AccessibilityLevel _parseAccessibilityLevel(String? level) {
    switch (level) {
      case 'basic': return AccessibilityLevel.basic;
      case 'intermediate': return AccessibilityLevel.intermediate;
      case 'advanced': return AccessibilityLevel.advanced;
      case 'expert': return AccessibilityLevel.expert;
      default: return AccessibilityLevel.intermediate;
    }
  }

  AccessibilityFeatures _parseAccessibilityFeatures(Map<String, dynamic> data) {
    return AccessibilityFeatures(
      screenReaderSupport: data['screen_reader_support'] ?? false,
      keyboardNavigation: data['keyboard_navigation'] ?? true,
      colorBlindSupport: data['color_blind_support'] ?? false,
      hearingImpairedSupport: data['hearing_impaired_support'] ?? false,
      motorImpairedSupport: data['motor_impaired_support'] ?? false,
      customFeatures: List<String>.from(data['custom_features'] ?? []),
    );
  }
} 