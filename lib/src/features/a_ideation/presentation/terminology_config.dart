import 'package:flutter_riverpod/flutter_riverpod.dart';

// Professional terminology configuration
class TerminologyConfig {
  static const String defaultType = 'gaming';
  static const String defaultLanguage = 'de';
  
  // Supported terminology types
  static const List<String> supportedTypes = ['gaming', 'business'];
  
  // Supported languages
  static const List<String> supportedLanguages = ['de', 'en'];
  
  // Terminology mapping with proper structure
  static const Map<String, Map<String, Map<String, String>>> _terminologyMap = {
    'gaming': {
      'de': {
        'arena': 'Arena',
        'battles': 'BATTLES',
        'champions': 'CHAMPIONS',
        'legions': 'LEGIONS',
        'squads': 'Squads',
        'champions_single': 'Champions',
        'gaming_arena': 'Gaming Arena',
        'ready_for_battle': 'Bereit für den Kampf?',
        'active_battles': 'Aktive Battles',
        'upcoming_challenges': 'Kommende Challenges',
        'hall_of_fame': 'Hall of Fame',
        'arena_stats': 'Arena Stats',
        'whats_hot': 'Was ist gerade heiß?',
        'trending_champions': 'Trending Champions',
        'arena_champions': 'Arena Champions',
        'best_players': 'Die besten Spieler der Woche',
        'arena_community': 'Arena Community',
        'discuss_with_champions': 'Diskutiere mit anderen Champions',
        'gaming_legions': 'Gaming Legions',
        'join_legion': 'Schließe dich einer Legion an',
        'active_legions': 'Active Legions',
        'legion_rankings': 'Legion Rankings',
        'create_legion': 'Create Legion',
        'found_legion': 'Gründe deine Legion',
        'lead_champions': 'Erstelle eine neue Gaming-Legion und führe Champions an',
        'start_new_battle': 'Start New Battle',
        'create_new_jam': 'Erstelle einen neuen Game Jam',
        'join_legion_action': 'Join Legion',
        'join_gaming_legion': 'Tritt einer Gaming-Legion bei',
        'form_squad': 'Form Squad',
        'found_project_squad': 'Gründe ein Projekt-Squad',
        'arena_discussion': 'Arena Discussion',
        'start_new_discussion': 'Starte eine neue Diskussion',
      },
      'en': {
        'arena': 'Arena',
        'battles': 'BATTLES',
        'champions': 'CHAMPIONS',
        'legions': 'LEGIONS',
        'squads': 'Squads',
        'champions_single': 'Champions',
        'gaming_arena': 'Gaming Arena',
        'ready_for_battle': 'Ready for battle?',
        'active_battles': 'Active Battles',
        'upcoming_challenges': 'Upcoming Challenges',
        'hall_of_fame': 'Hall of Fame',
        'arena_stats': 'Arena Stats',
        'whats_hot': 'What\'s hot right now?',
        'trending_champions': 'Trending Champions',
        'arena_champions': 'Arena Champions',
        'best_players': 'Best players of the week',
        'arena_community': 'Arena Community',
        'discuss_with_champions': 'Discuss with other champions',
        'gaming_legions': 'Gaming Legions',
        'join_legion': 'Join a legion',
        'active_legions': 'Active Legions',
        'legion_rankings': 'Legion Rankings',
        'create_legion': 'Create Legion',
        'found_legion': 'Found your legion',
        'lead_champions': 'Create a new gaming legion and lead champions',
        'start_new_battle': 'Start New Battle',
        'create_new_jam': 'Create a new game jam',
        'join_legion_action': 'Join Legion',
        'join_gaming_legion': 'Join a gaming legion',
        'form_squad': 'Form Squad',
        'found_project_squad': 'Found a project squad',
        'arena_discussion': 'Arena Discussion',
        'start_new_discussion': 'Start a new discussion',
      },
    },
    'business': {
      'de': {
        'arena': 'Hub',
        'battles': 'PROJECTS',
        'champions': 'DEVELOPERS',
        'legions': 'TEAMS',
        'squads': 'Squads',
        'champions_single': 'Developers',
        'gaming_arena': 'Development Hub',
        'ready_for_battle': 'Bereit für neue Projekte?',
        'active_battles': 'Aktive Projekte',
        'upcoming_challenges': 'Kommende Projekte',
        'hall_of_fame': 'Erfolgreiche Projekte',
        'arena_stats': 'Hub Statistiken',
        'whats_hot': 'Was ist gerade gefragt?',
        'trending_champions': 'Trending Entwickler',
        'arena_champions': 'Top Entwickler',
        'best_players': 'Die besten Entwickler der Woche',
        'arena_community': 'Developer Community',
        'discuss_with_champions': 'Diskutiere mit anderen Entwicklern',
        'gaming_legions': 'Development Teams',
        'join_legion': 'Schließe dich einem Team an',
        'active_legions': 'Aktive Teams',
        'legion_rankings': 'Team Rankings',
        'create_legion': 'Team erstellen',
        'found_legion': 'Gründe dein Team',
        'lead_champions': 'Erstelle ein neues Development-Team und führe Entwickler an',
        'start_new_battle': 'Neues Projekt',
        'create_new_jam': 'Erstelle ein neues Projekt',
        'join_legion_action': 'Team beitreten',
        'join_gaming_legion': 'Tritt einem Development-Team bei',
        'form_squad': 'Squad bilden',
        'found_project_squad': 'Bilde ein Projekt-Squad',
        'arena_discussion': 'Community Diskussion',
        'start_new_discussion': 'Starte eine neue Diskussion',
      },
      'en': {
        'arena': 'Hub',
        'battles': 'PROJECTS',
        'champions': 'DEVELOPERS',
        'legions': 'TEAMS',
        'squads': 'Squads',
        'champions_single': 'Developers',
        'gaming_arena': 'Development Hub',
        'ready_for_battle': 'Ready for new projects?',
        'active_battles': 'Active Projects',
        'upcoming_challenges': 'Upcoming Projects',
        'hall_of_fame': 'Successful Projects',
        'arena_stats': 'Hub Statistics',
        'whats_hot': 'What\'s in demand?',
        'trending_champions': 'Trending Developers',
        'arena_champions': 'Top Developers',
        'best_players': 'Best developers of the week',
        'arena_community': 'Developer Community',
        'discuss_with_champions': 'Discuss with other developers',
        'gaming_legions': 'Development Teams',
        'join_legion': 'Join a team',
        'active_legions': 'Active Teams',
        'legion_rankings': 'Team Rankings',
        'create_legion': 'Create Team',
        'found_legion': 'Found your team',
        'lead_champions': 'Create a new development team and lead developers',
        'start_new_battle': 'New Project',
        'create_new_jam': 'Create a new project',
        'join_legion_action': 'Join Team',
        'join_gaming_legion': 'Join a development team',
        'form_squad': 'Form Squad',
        'found_project_squad': 'Form a project squad',
        'arena_discussion': 'Community Discussion',
        'start_new_discussion': 'Start a new discussion',
      },
    },
  };

  // Professional getter method with validation
  static String get(String key, Map<String, String> settings) {
    final type = settings['type'] ?? defaultType;
    final language = settings['language'] ?? defaultLanguage;
    
    // Validate inputs
    if (!supportedTypes.contains(type)) {
      throw ArgumentError('Unsupported terminology type: $type');
    }
    if (!supportedLanguages.contains(language)) {
      throw ArgumentError('Unsupported language: $language');
    }
    
    // Get terminology with fallback
    final terminology = _terminologyMap[type]?[language]?[key];
    if (terminology == null) {
      // Fallback to default
      final fallback = _terminologyMap[defaultType]?[defaultLanguage]?[key];
      if (fallback == null) {
        throw ArgumentError('Terminology key not found: $key');
      }
      return fallback;
    }
    
    return terminology;
  }

  // Get all available keys for a specific type and language
  static List<String> getAvailableKeys(String type, String language) {
    return _terminologyMap[type]?[language]?.keys.toList() ?? [];
  }

  // Check if a key exists
  static bool hasKey(String key, String type, String language) {
    return _terminologyMap[type]?[language]?.containsKey(key) ?? false;
  }

  // Get terminology info
  static Map<String, dynamic> getTerminologyInfo() {
    return {
      'supportedTypes': supportedTypes,
      'supportedLanguages': supportedLanguages,
      'defaultType': defaultType,
      'defaultLanguage': defaultLanguage,
    };
  }
}

// Professional state management with type safety
class TerminologyState {
  final String type;
  final String language;
  final DateTime lastUpdated;

  const TerminologyState({
    required this.type,
    required this.language,
    required this.lastUpdated,
  });

  TerminologyState copyWith({
    String? type,
    String? language,
    DateTime? lastUpdated,
  }) {
    return TerminologyState(
      type: type ?? this.type,
      language: language ?? this.language,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  Map<String, String> toSettings() {
    return {
      'type': type,
      'language': language,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TerminologyState &&
        other.type == type &&
        other.language == language;
  }

  @override
  int get hashCode => type.hashCode ^ language.hashCode;

  @override
  String toString() {
    return 'TerminologyState(type: $type, language: $language, lastUpdated: $lastUpdated)';
  }
}

// Professional provider with validation and error handling
class TerminologyNotifier extends StateNotifier<TerminologyState> {
  TerminologyNotifier() : super(TerminologyState(
    type: TerminologyConfig.defaultType,
    language: TerminologyConfig.defaultLanguage,
    lastUpdated: DateTime.now(),
  ));

  void setTerminology(String type) {
    if (!TerminologyConfig.supportedTypes.contains(type)) {
      throw ArgumentError('Unsupported terminology type: $type');
    }
    
    state = state.copyWith(
      type: type,
      lastUpdated: DateTime.now(),
    );
  }

  void setLanguage(String language) {
    if (!TerminologyConfig.supportedLanguages.contains(language)) {
      throw ArgumentError('Unsupported language: $language');
    }
    
    state = state.copyWith(
      language: language,
      lastUpdated: DateTime.now(),
    );
  }

  void setTerminologyAndLanguage(String type, String language) {
    if (!TerminologyConfig.supportedTypes.contains(type)) {
      throw ArgumentError('Unsupported terminology type: $type');
    }
    if (!TerminologyConfig.supportedLanguages.contains(language)) {
      throw ArgumentError('Unsupported language: $language');
    }
    
    state = state.copyWith(
      type: type,
      language: language,
      lastUpdated: DateTime.now(),
    );
  }

  String getTerminology(String key) {
    return TerminologyConfig.get(key, state.toSettings());
  }

  Map<String, dynamic> getInfo() {
    return TerminologyConfig.getTerminologyInfo();
  }
}

// Professional provider
final terminologyProvider = StateNotifierProvider<TerminologyNotifier, TerminologyState>((ref) {
  return TerminologyNotifier();
});

// Convenience providers for easy access
final terminologyTypeProvider = Provider<String>((ref) {
  return ref.watch(terminologyProvider).type;
});

final terminologyLanguageProvider = Provider<String>((ref) {
  return ref.watch(terminologyProvider).language;
});

final terminologySettingsProvider = Provider<Map<String, String>>((ref) {
  return ref.watch(terminologyProvider).toSettings();
}); 