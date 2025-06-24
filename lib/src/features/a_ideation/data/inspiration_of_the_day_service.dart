import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

/// Inspiration of the Day Service
/// Generiert und verwaltet tägliche KI-Inspirationen für Game Development
class InspirationOfTheDayService {
  static const String _storageKey = 'inspiration_of_the_day';
  static const String _archiveKey = 'inspiration_archive';
  
  // Inspiration Templates für verschiedene Typen
  static const List<Map<String, dynamic>> _inspirationTemplates = [
    {
      'type': 'genre_mashup',
      'title': 'Genre Mashup',
      'description': 'Kombiniere zwei unerwartete Genres',
      'examples': [
        'RPG + Tower Defense = "Hero Defense"',
        'Puzzle + Racing = "Speed Brain"',
        'Simulation + Horror = "Haunted Farm"',
        'Strategy + Platformer = "Kingdom Jump"',
        'Adventure + Rhythm = "Musical Quest"',
      ],
    },
    {
      'type': 'mechanic_focus',
      'title': 'Core Mechanic',
      'description': 'Baue ein Spiel um eine einzigartige Mechanik',
      'examples': [
        'Gravity Manipulation',
        'Time Reversal',
        'Size Shifting',
        'Color-based Powers',
        'Sound as Weapon',
        'Memory as Resource',
      ],
    },
    {
      'type': 'theme_exploration',
      'title': 'Theme Exploration',
      'description': 'Erkunde ein ungewöhnliches Thema',
      'examples': [
        'Underwater Archaeology',
        'Dream Psychology',
        'Quantum Physics',
        'Ancient Mythology',
        'Future Retro',
        'Microscopic World',
      ],
    },
    {
      'type': 'constraint_challenge',
      'title': 'Design Constraint',
      'description': 'Erstelle mit einer spezifischen Einschränkung',
      'examples': [
        'Only One Button',
        'Black & White Only',
        'Silent Game',
        'One Screen Only',
        'No Text',
        'Single Color Palette',
      ],
    },
    {
      'type': 'emotion_driven',
      'title': 'Emotional Journey',
      'description': 'Fokussiere auf eine spezifische Emotion',
      'examples': [
        'Nostalgia',
        'Wonder',
        'Tension',
        'Joy',
        'Melancholy',
        'Excitement',
      ],
    },
  ];

  /// Generiert die Inspiration des Tages
  Future<DailyInspiration> generateTodaysInspiration() async {
    final today = DateTime.now();
    // final todayKey = _getDateKey(today); // Unused
    
    // Prüfe ob heute schon eine Inspiration generiert wurde
    final existing = await _loadTodaysInspiration();
    if (existing != null) {
      return existing;
    }
    
    // Generiere neue Inspiration
    final inspiration = _createRandomInspiration(today);
    
    // Speichere für heute
    await _saveTodaysInspiration(inspiration);
    
    // Füge zum Archiv hinzu
    await _addToArchive(inspiration);
    
    return inspiration;
  }

  /// Lädt die Inspiration des Tages
  Future<DailyInspiration?> loadTodaysInspiration() async {
    return await _loadTodaysInspiration();
  }

  /// Lädt das Archiv aller Inspirationen
  Future<List<DailyInspiration>> loadArchive() async {
    final prefs = await SharedPreferences.getInstance();
    final archiveJson = prefs.getString(_archiveKey);
    
    if (archiveJson == null) return [];
    
    try {
      final List<dynamic> archiveList = jsonDecode(archiveJson);
      return archiveList
          .map((json) => DailyInspiration.fromJson(json))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Generiert eine zufällige Inspiration
  DailyInspiration _createRandomInspiration(DateTime date) {
    final random = Random();
    final template = _inspirationTemplates[random.nextInt(_inspirationTemplates.length)];
    final example = template['examples'][random.nextInt(template['examples'].length)];
    
    return DailyInspiration(
      id: _getDateKey(date),
      date: date,
      type: template['type'],
      title: template['title'],
      description: template['description'],
      inspiration: example,
      challenge: _generateChallenge(template['type'], example),
      tags: _generateTags(template['type'], example),
      difficulty: _getRandomDifficulty(),
      estimatedTime: _getRandomTime(),
    );
  }

  /// Generiert eine Challenge basierend auf der Inspiration
  String _generateChallenge(String type, String example) {
    final challenges = {
      'genre_mashup': 'Erstelle ein Prototyp in 48 Stunden',
      'mechanic_focus': 'Implementiere die Mechanik in 3 verschiedenen Kontexten',
      'theme_exploration': 'Erstelle eine visuelle Mood-Board',
      'constraint_challenge': 'Teste die Einschränkung mit 5 verschiedenen Ansätzen',
      'emotion_driven': 'Erstelle eine Audio-Visuelle Demo',
    };
    
    return challenges[type] ?? 'Erstelle einen Prototypen basierend auf dieser Inspiration';
  }

  /// Generiert Tags für die Inspiration
  List<String> _generateTags(String type, String example) {
    final baseTags = [type, 'inspiration', 'daily'];
    
    // Extrahiere Keywords aus dem Beispiel
    final keywords = example.toLowerCase()
        .split(' ')
        .where((word) => word.length > 3)
        .take(3)
        .toList();
    
    return [...baseTags, ...keywords];
  }

  /// Zufällige Schwierigkeit
  String _getRandomDifficulty() {
    final difficulties = ['Easy', 'Medium', 'Hard'];
    return difficulties[Random().nextInt(difficulties.length)];
  }

  /// Zufällige Entwicklungszeit
  String _getRandomTime() {
    final times = ['2-4 hours', '1-2 days', '3-5 days', '1 week'];
    return times[Random().nextInt(times.length)];
  }

  /// Date Key für Storage
  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Speichert die heutige Inspiration
  Future<void> _saveTodaysInspiration(DailyInspiration inspiration) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(inspiration.toJson()));
  }

  /// Lädt die heutige Inspiration
  Future<DailyInspiration?> _loadTodaysInspiration() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_storageKey);
    
    if (json == null) return null;
    
    try {
      final data = jsonDecode(json);
      final inspiration = DailyInspiration.fromJson(data);
      
      // Prüfe ob es von heute ist
      final today = DateTime.now();
      if (_getDateKey(inspiration.date) == _getDateKey(today)) {
        return inspiration;
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Fügt Inspiration zum Archiv hinzu
  Future<void> _addToArchive(DailyInspiration inspiration) async {
    final archive = await loadArchive();
    archive.add(inspiration);
    
    // Behalte nur die letzten 30 Einträge
    if (archive.length > 30) {
      archive.removeRange(0, archive.length - 30);
    }
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_archiveKey, jsonEncode(archive.map((i) => i.toJson()).toList()));
  }

  /// Generiert eine neue Inspiration manuell
  Future<DailyInspiration> generateNewInspiration() async {
    final today = DateTime.now();
    final inspiration = _createRandomInspiration(today);
    
    await _saveTodaysInspiration(inspiration);
    await _addToArchive(inspiration);
    
    return inspiration;
  }

  /// Löscht das Archiv
  Future<void> clearArchive() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_archiveKey);
  }
}

/// Datenmodell für tägliche Inspirationen
class DailyInspiration {
  final String id;
  final DateTime date;
  final String type;
  final String title;
  final String description;
  final String inspiration;
  final String challenge;
  final List<String> tags;
  final String difficulty;
  final String estimatedTime;

  const DailyInspiration({
    required this.id,
    required this.date,
    required this.type,
    required this.title,
    required this.description,
    required this.inspiration,
    required this.challenge,
    required this.tags,
    required this.difficulty,
    required this.estimatedTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'type': type,
      'title': title,
      'description': description,
      'inspiration': inspiration,
      'challenge': challenge,
      'tags': tags,
      'difficulty': difficulty,
      'estimatedTime': estimatedTime,
    };
  }

  factory DailyInspiration.fromJson(Map<String, dynamic> json) {
    return DailyInspiration(
      id: json['id'],
      date: DateTime.parse(json['date']),
      type: json['type'],
      title: json['title'],
      description: json['description'],
      inspiration: json['inspiration'],
      challenge: json['challenge'],
      tags: List<String>.from(json['tags']),
      difficulty: json['difficulty'],
      estimatedTime: json['estimatedTime'],
    );
  }

  String get formattedDate {
    return '${date.day}.${date.month}.${date.year}';
  }

  String get dayOfWeek {
    const days = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];
    return days[date.weekday - 1];
  }
} 