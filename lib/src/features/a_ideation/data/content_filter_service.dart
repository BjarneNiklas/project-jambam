import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/content_filter_system.dart';

class ContentFilterService {
  static const String _storageKey = 'content_filter_system';
  static const String _settingsKey = 'content_filter_settings';
  
  final ContentFilterSystem _filterSystem = ContentFilterSystem();
  
  // Settings
  bool _isEnabled = true;
  double _filterThreshold = 0.0;
  bool _autoCategorizeResearch = true;
  bool _showUsageStats = true;

  // Getters
  ContentFilterSystem get filterSystem => _filterSystem;
  bool get isEnabled => _isEnabled;
  double get filterThreshold => _filterThreshold;
  bool get autoCategorizeResearch => _autoCategorizeResearch;
  bool get showUsageStats => _showUsageStats;

  // Initialize
  Future<void> initialize() async {
    await _loadSettings();
    await _loadTags();
  }

  // Tag Management
  Future<void> addTag(ContentTag tag) async {
    _filterSystem.addTag(tag);
    await _saveTags();
  }

  Future<void> updateTagCategory(String tagId, TagCategory newCategory) async {
    _filterSystem.updateTagCategory(tagId, newCategory);
    await _saveTags();
  }

  Future<void> removeTag(String tagId) async {
    _filterSystem.removeTag(tagId);
    await _saveTags();
  }

  Future<void> addTags(List<ContentTag> tags) async {
    _filterSystem.addTags(tags);
    await _saveTags();
  }

  Future<void> moveTagsToCategory(List<String> tagIds, TagCategory category) async {
    _filterSystem.moveTagsToCategory(tagIds, category);
    await _saveTags();
  }

  Future<void> removeTags(List<String> tagIds) async {
    _filterSystem.removeTags(tagIds);
    await _saveTags();
  }

  // Smart Operations
  Future<void> addResearchTags(List<String> terms) async {
    _filterSystem.addResearchTags(terms);
    await _saveTags();
  }

  Future<void> addPopularTags(List<String> terms) async {
    _filterSystem.addPopularTags(terms);
    await _saveTags();
  }

  Future<void> addUserTag(String term, TagCategory category) async {
    final tag = ContentTag(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      term: term,
      category: category,
      source: TagSource.user,
      createdAt: DateTime.now(),
    );
    await addTag(tag);
  }

  // Quick Actions
  Future<void> addToInterests(String term) async {
    await addUserTag(term, TagCategory.interests);
  }

  Future<void> addToDislikes(String term) async {
    await addUserTag(term, TagCategory.dislikes);
  }

  Future<void> addToFavorites(String term) async {
    await addUserTag(term, TagCategory.favorites);
  }

  Future<void> addToNeutral(String term) async {
    await addUserTag(term, TagCategory.neutral);
  }

  // Batch Operations
  Future<void> addAllToCategory(List<String> terms, TagCategory category) async {
    final tags = terms.map((term) => ContentTag(
      id: DateTime.now().millisecondsSinceEpoch.toString() + term.hashCode.toString(),
      term: term,
      category: category,
      source: TagSource.user,
      createdAt: DateTime.now(),
    )).toList();
    await addTags(tags);
  }

  Future<void> clearCategory(TagCategory category) async {
    final tagIds = _filterSystem.getTagsByCategory(category)
        .map((tag) => tag.id)
        .toList();
    await removeTags(tagIds);
  }

  Future<void> clearAllTags() async {
    final allTagIds = _filterSystem.getAllTags()
        .map((tag) => tag.id)
        .toList();
    await removeTags(allTagIds);
  }

  // Content Filtering
  bool shouldIncludeContent(String content) {
    if (!_isEnabled) return true;
    return _filterSystem.shouldIncludeContent(content);
  }

  double getContentScore(String content) {
    if (!_isEnabled) return 0.0;
    return _filterSystem.getContentScore(content);
  }

  List<String> filterContentList(List<String> contentList) {
    if (!_isEnabled) return contentList;
    return contentList.where((content) => shouldIncludeContent(content)).toList();
  }

  List<String> sortContentByRelevance(List<String> contentList) {
    if (!_isEnabled) return contentList;
    
    final scoredContent = contentList.map((content) => MapEntry(
      content,
      getContentScore(content),
    )).toList();
    
    scoredContent.sort((a, b) => b.value.compareTo(a.value));
    return scoredContent.map((entry) => entry.key).toList();
  }

  // Settings Management
  Future<void> updateSettings({
    bool? isEnabled,
    double? filterThreshold,
    bool? autoCategorizeResearch,
    bool? showUsageStats,
  }) async {
    _isEnabled = isEnabled ?? _isEnabled;
    _filterThreshold = filterThreshold ?? _filterThreshold;
    _autoCategorizeResearch = autoCategorizeResearch ?? _autoCategorizeResearch;
    _showUsageStats = showUsageStats ?? _showUsageStats;
    await _saveSettings();
  }

  // Export/Import
  Future<String> exportTags() async {
    return jsonEncode(_filterSystem.toJson());
  }

  Future<void> importTags(String jsonData) async {
    try {
      final data = jsonDecode(jsonData) as Map<String, dynamic>;
      _filterSystem.fromJson(data);
      await _saveTags();
    } catch (e) {
      throw Exception('Invalid import data: $e');
    }
  }

  Future<String> exportSettings() async {
    final settings = {
      'isEnabled': _isEnabled,
      'filterThreshold': _filterThreshold,
      'autoCategorizeResearch': _autoCategorizeResearch,
      'showUsageStats': _showUsageStats,
    };
    return jsonEncode(settings);
  }

  Future<void> importSettings(String jsonData) async {
    try {
      final data = jsonDecode(jsonData) as Map<String, dynamic>;
      await updateSettings(
        isEnabled: data['isEnabled'],
        filterThreshold: data['filterThreshold']?.toDouble(),
        autoCategorizeResearch: data['autoCategorizeResearch'],
        showUsageStats: data['showUsageStats'],
      );
    } catch (e) {
      throw Exception('Invalid settings data: $e');
    }
  }

  // Statistics
  Map<TagCategory, int> getCategoryStats() {
    return _filterSystem.getCategoryStats();
  }

  List<ContentTag> getMostUsedTags({int limit = 10}) {
    return _filterSystem.getMostUsedTags(limit: limit);
  }

  List<ContentTag> getRecentlyUsedTags({int limit = 10}) {
    return _filterSystem.getRecentlyUsedTags(limit: limit);
  }

  // Search and Suggestions
  List<ContentTag> searchTags(String query) {
    if (query.isEmpty) return _filterSystem.getAllTags();
    
    final queryLower = query.toLowerCase();
    return _filterSystem.getAllTags()
        .where((tag) => tag.term.toLowerCase().contains(queryLower))
        .toList();
  }

  List<String> getSuggestions(String partial) {
    if (partial.isEmpty) return [];
    
    final partialLower = partial.toLowerCase();
    final suggestions = <String>{};
    
    // Get suggestions from existing tags
    for (final tag in _filterSystem.getAllTags()) {
      if (tag.term.toLowerCase().contains(partialLower)) {
        suggestions.add(tag.term);
      }
    }
    
    // Add common game development terms
    final commonTerms = [
      'procedural generation',
      'AI',
      'machine learning',
      '3D modeling',
      'texture',
      'animation',
      'sound design',
      'game mechanics',
      'user interface',
      'virtual reality',
      'augmented reality',
      'multiplayer',
      'single player',
      'puzzle',
      'action',
      'adventure',
      'strategy',
      'simulation',
      'rpg',
      'fps',
      'platformer',
      'roguelike',
      'metroidvania',
      'open world',
      'linear',
      'story-driven',
      'sandbox',
      'competitive',
      'cooperative',
      'casual',
      'hardcore',
    ];
    
    for (final term in commonTerms) {
      if (term.toLowerCase().contains(partialLower)) {
        suggestions.add(term);
      }
    }
    
    return suggestions.toList()..sort();
  }

  // Persistence
  Future<void> _saveTags() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = jsonEncode(_filterSystem.toJson());
    await prefs.setString(_storageKey, jsonData);
  }

  Future<void> _loadTags() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = prefs.getString(_storageKey);
    if (jsonData != null) {
      try {
        final data = jsonDecode(jsonData) as Map<String, dynamic>;
        _filterSystem.fromJson(data);
      } catch (e) {
        // If loading fails, start with empty system
        print('Failed to load content filter tags: $e');
      }
    }
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settings = {
      'isEnabled': _isEnabled,
      'filterThreshold': _filterThreshold,
      'autoCategorizeResearch': _autoCategorizeResearch,
      'showUsageStats': _showUsageStats,
    };
    final jsonData = jsonEncode(settings);
    await prefs.setString(_settingsKey, jsonData);
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = prefs.getString(_settingsKey);
    if (jsonData != null) {
      try {
        final data = jsonDecode(jsonData) as Map<String, dynamic>;
        _isEnabled = data['isEnabled'] ?? true;
        _filterThreshold = (data['filterThreshold'] ?? 0.0).toDouble();
        _autoCategorizeResearch = data['autoCategorizeResearch'] ?? true;
        _showUsageStats = data['showUsageStats'] ?? true;
      } catch (e) {
        print('Failed to load content filter settings: $e');
      }
    }
  }
} 