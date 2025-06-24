import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/content_filter_service.dart';
import '../domain/content_filter_system.dart';

final contentFilterServiceProvider = Provider<ContentFilterService>((ref) {
  return ContentFilterService();
});

final contentFilterSystemProvider = Provider<ContentFilterSystem>((ref) {
  final service = ref.watch(contentFilterServiceProvider);
  return service.filterSystem;
});

final contentFilterTagsProvider = Provider<List<ContentTag>>((ref) {
  final system = ref.watch(contentFilterSystemProvider);
  return system.getAllTags();
});

final contentFilterCategoryStatsProvider = Provider<Map<TagCategory, int>>((ref) {
  final system = ref.watch(contentFilterSystemProvider);
  return system.getCategoryStats();
});

final contentFilterTagsByCategoryProvider = Provider.family<List<ContentTag>, TagCategory>((ref, category) {
  final system = ref.watch(contentFilterSystemProvider);
  return system.getTagsByCategory(category);
});

final contentFilterMostUsedTagsProvider = Provider<List<ContentTag>>((ref) {
  final system = ref.watch(contentFilterSystemProvider);
  return system.getMostUsedTags(limit: 10);
});

final contentFilterRecentlyUsedTagsProvider = Provider<List<ContentTag>>((ref) {
  final system = ref.watch(contentFilterSystemProvider);
  return system.getRecentlyUsedTags(limit: 10);
});

final contentFilterSettingsProvider = StateNotifierProvider<ContentFilterSettingsNotifier, ContentFilterSettings>((ref) {
  final service = ref.watch(contentFilterServiceProvider);
  return ContentFilterSettingsNotifier(service);
});

class ContentFilterSettings {
  final bool isEnabled;
  final double filterThreshold;
  final bool autoCategorizeResearch;
  final bool showUsageStats;

  const ContentFilterSettings({
    this.isEnabled = true,
    this.filterThreshold = 0.0,
    this.autoCategorizeResearch = true,
    this.showUsageStats = true,
  });

  ContentFilterSettings copyWith({
    bool? isEnabled,
    double? filterThreshold,
    bool? autoCategorizeResearch,
    bool? showUsageStats,
  }) {
    return ContentFilterSettings(
      isEnabled: isEnabled ?? this.isEnabled,
      filterThreshold: filterThreshold ?? this.filterThreshold,
      autoCategorizeResearch: autoCategorizeResearch ?? this.autoCategorizeResearch,
      showUsageStats: showUsageStats ?? this.showUsageStats,
    );
  }
}

class ContentFilterSettingsNotifier extends StateNotifier<ContentFilterSettings> {
  final ContentFilterService _service;

  ContentFilterSettingsNotifier(this._service) 
      : super(const ContentFilterSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    state = ContentFilterSettings(
      isEnabled: _service.isEnabled,
      filterThreshold: _service.filterThreshold,
      autoCategorizeResearch: _service.autoCategorizeResearch,
      showUsageStats: _service.showUsageStats,
    );
  }

  Future<void> updateSettings({
    bool? isEnabled,
    double? filterThreshold,
    bool? autoCategorizeResearch,
    bool? showUsageStats,
  }) async {
    await _service.updateSettings(
      isEnabled: isEnabled,
      filterThreshold: filterThreshold,
      autoCategorizeResearch: autoCategorizeResearch,
      showUsageStats: showUsageStats,
    );
    
    state = state.copyWith(
      isEnabled: isEnabled,
      filterThreshold: filterThreshold,
      autoCategorizeResearch: autoCategorizeResearch,
      showUsageStats: showUsageStats,
    );
  }
}

// Tag management providers
final contentFilterTagActionsProvider = Provider<ContentFilterTagActions>((ref) {
  final service = ref.watch(contentFilterServiceProvider);
  return ContentFilterTagActions(service, ref);
});

class ContentFilterTagActions {
  final ContentFilterService _service;
  final Ref _ref;

  ContentFilterTagActions(this._service, this._ref);

  Future<void> addTag(ContentTag tag) async {
    await _service.addTag(tag);
    _ref.invalidate(contentFilterTagsProvider);
    _ref.invalidate(contentFilterCategoryStatsProvider);
  }

  Future<void> updateTagCategory(String tagId, TagCategory newCategory) async {
    await _service.updateTagCategory(tagId, newCategory);
    _ref.invalidate(contentFilterTagsProvider);
    _ref.invalidate(contentFilterCategoryStatsProvider);
  }

  Future<void> removeTag(String tagId) async {
    await _service.removeTag(tagId);
    _ref.invalidate(contentFilterTagsProvider);
    _ref.invalidate(contentFilterCategoryStatsProvider);
  }

  Future<void> addTags(List<ContentTag> tags) async {
    await _service.addTags(tags);
    _ref.invalidate(contentFilterTagsProvider);
    _ref.invalidate(contentFilterCategoryStatsProvider);
  }

  Future<void> moveTagsToCategory(List<String> tagIds, TagCategory category) async {
    await _service.moveTagsToCategory(tagIds, category);
    _ref.invalidate(contentFilterTagsProvider);
    _ref.invalidate(contentFilterCategoryStatsProvider);
  }

  Future<void> removeTags(List<String> tagIds) async {
    await _service.removeTags(tagIds);
    _ref.invalidate(contentFilterTagsProvider);
    _ref.invalidate(contentFilterCategoryStatsProvider);
  }

  Future<void> addResearchTags(List<String> terms) async {
    await _service.addResearchTags(terms);
    _ref.invalidate(contentFilterTagsProvider);
    _ref.invalidate(contentFilterCategoryStatsProvider);
  }

  Future<void> addPopularTags(List<String> terms) async {
    await _service.addPopularTags(terms);
    _ref.invalidate(contentFilterTagsProvider);
    _ref.invalidate(contentFilterCategoryStatsProvider);
  }

  Future<void> addUserTag(String term, TagCategory category) async {
    await _service.addUserTag(term, category);
    _ref.invalidate(contentFilterTagsProvider);
    _ref.invalidate(contentFilterCategoryStatsProvider);
  }

  Future<void> clearCategory(TagCategory category) async {
    await _service.clearCategory(category);
    _ref.invalidate(contentFilterTagsProvider);
    _ref.invalidate(contentFilterCategoryStatsProvider);
  }

  Future<void> clearAllTags() async {
    await _service.clearAllTags();
    _ref.invalidate(contentFilterTagsProvider);
    _ref.invalidate(contentFilterCategoryStatsProvider);
  }

  // Quick actions
  Future<void> addToInterests(String term) async {
    await _service.addToInterests(term);
    _ref.invalidate(contentFilterTagsProvider);
    _ref.invalidate(contentFilterCategoryStatsProvider);
  }

  Future<void> addToDislikes(String term) async {
    await _service.addToDislikes(term);
    _ref.invalidate(contentFilterTagsProvider);
    _ref.invalidate(contentFilterCategoryStatsProvider);
  }

  Future<void> addToFavorites(String term) async {
    await _service.addToFavorites(term);
    _ref.invalidate(contentFilterTagsProvider);
    _ref.invalidate(contentFilterCategoryStatsProvider);
  }

  Future<void> addToNeutral(String term) async {
    await _service.addToNeutral(term);
    _ref.invalidate(contentFilterTagsProvider);
    _ref.invalidate(contentFilterCategoryStatsProvider);
  }

  // Content filtering
  bool shouldIncludeContent(String content) {
    return _service.shouldIncludeContent(content);
  }

  double getContentScore(String content) {
    return _service.getContentScore(content);
  }

  List<String> filterContentList(List<String> contentList) {
    return _service.filterContentList(contentList);
  }

  List<String> sortContentByRelevance(List<String> contentList) {
    return _service.sortContentByRelevance(contentList);
  }

  // Search and suggestions
  List<ContentTag> searchTags(String query) {
    return _service.searchTags(query);
  }

  List<String> getSuggestions(String partial) {
    return _service.getSuggestions(partial);
  }

  // Export/Import
  Future<String> exportTags() async {
    return _service.exportTags();
  }

  Future<void> importTags(String jsonData) async {
    await _service.importTags(jsonData);
    _ref.invalidate(contentFilterTagsProvider);
    _ref.invalidate(contentFilterCategoryStatsProvider);
  }

  Future<String> exportSettings() async {
    return _service.exportSettings();
  }

  Future<void> importSettings(String jsonData) async {
    await _service.importSettings(jsonData);
    _ref.invalidate(contentFilterSettingsProvider);
  }
} 