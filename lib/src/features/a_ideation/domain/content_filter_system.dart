enum TagCategory {
  interests,   // Green - things user likes
  dislikes,    // Red - things user dislikes
  neutral,     // Yellow - neutral/undecided
  favorites,   // Blue - user's favorites
}

enum TagSource {
  user,           // Manually added by user
  research,       // From research results
  popular,        // Trending/popular terms
  suggested,      // AI suggested
  imported,       // Imported from external source
}

class ContentTag {
  final String id;
  final String term;
  final TagCategory category;
  final TagSource source;
  final DateTime createdAt;
  final DateTime? lastUsed;
  final int usageCount;
  final Map<String, dynamic> metadata;

  ContentTag({
    required this.id,
    required this.term,
    required this.category,
    required this.source,
    required this.createdAt,
    this.lastUsed,
    this.usageCount = 0,
    this.metadata = const {},
  });

  ContentTag copyWith({
    String? id,
    String? term,
    TagCategory? category,
    TagSource? source,
    DateTime? createdAt,
    DateTime? lastUsed,
    int? usageCount,
    Map<String, dynamic>? metadata,
  }) {
    return ContentTag(
      id: id ?? this.id,
      term: term ?? this.term,
      category: category ?? this.category,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
      lastUsed: lastUsed ?? this.lastUsed,
      usageCount: usageCount ?? this.usageCount,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'term': term,
      'category': category.name,
      'source': source.name,
      'createdAt': createdAt.toIso8601String(),
      'lastUsed': lastUsed?.toIso8601String(),
      'usageCount': usageCount,
      'metadata': metadata,
    };
  }

  factory ContentTag.fromJson(Map<String, dynamic> json) {
    return ContentTag(
      id: json['id'],
      term: json['term'],
      category: TagCategory.values.firstWhere(
        (e) => e.name == json['category'],
      ),
      source: TagSource.values.firstWhere(
        (e) => e.name == json['source'],
      ),
      createdAt: DateTime.parse(json['createdAt']),
      lastUsed: json['lastUsed'] != null 
        ? DateTime.parse(json['lastUsed']) 
        : null,
      usageCount: json['usageCount'] ?? 0,
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }
}

class ContentFilterSystem {
  final Map<String, ContentTag> _tags = {};
  final Map<TagCategory, List<String>> _categoryTags = {
    TagCategory.interests: [],
    TagCategory.dislikes: [],
    TagCategory.neutral: [],
    TagCategory.favorites: [],
  };

  // Getters
  Map<String, ContentTag> get tags => Map.unmodifiable(_tags);
  
  List<ContentTag> getTagsByCategory(TagCategory category) {
    return _categoryTags[category]!
        .map((id) => _tags[id]!)
        .toList();
  }

  List<ContentTag> getAllTags() {
    return _tags.values.toList();
  }

  // Tag Management
  void addTag(ContentTag tag) {
    _tags[tag.id] = tag;
    _categoryTags[tag.category]!.add(tag.id);
  }

  void updateTagCategory(String tagId, TagCategory newCategory) {
    final tag = _tags[tagId];
    if (tag == null) return;

    // Remove from old category
    _categoryTags[tag.category]!.remove(tagId);
    
    // Add to new category
    _categoryTags[newCategory]!.add(tagId);
    
    // Update tag
    _tags[tagId] = tag.copyWith(category: newCategory);
  }

  void removeTag(String tagId) {
    final tag = _tags[tagId];
    if (tag == null) return;

    _categoryTags[tag.category]!.remove(tagId);
    _tags.remove(tagId);
  }

  void incrementUsage(String tagId) {
    final tag = _tags[tagId];
    if (tag == null) return;

    _tags[tagId] = tag.copyWith(
      lastUsed: DateTime.now(),
      usageCount: tag.usageCount + 1,
    );
  }

  // Batch Operations
  void addTags(List<ContentTag> tags) {
    for (final tag in tags) {
      addTag(tag);
    }
  }

  void moveTagsToCategory(List<String> tagIds, TagCategory category) {
    for (final tagId in tagIds) {
      updateTagCategory(tagId, category);
    }
  }

  void removeTags(List<String> tagIds) {
    for (final tagId in tagIds) {
      removeTag(tagId);
    }
  }

  // Smart Operations
  void addResearchTags(List<String> terms) {
    for (final term in terms) {
      final tag = ContentTag(
        id: _generateId(),
        term: term,
        category: TagCategory.neutral, // Default to neutral
        source: TagSource.research,
        createdAt: DateTime.now(),
      );
      addTag(tag);
    }
  }

  void addPopularTags(List<String> terms) {
    for (final term in terms) {
      final tag = ContentTag(
        id: _generateId(),
        term: term,
        category: TagCategory.neutral, // Default to neutral
        source: TagSource.popular,
        createdAt: DateTime.now(),
      );
      addTag(tag);
    }
  }

  // Content Filtering
  bool shouldIncludeContent(String content) {
    final contentLower = content.toLowerCase();
    
    // Check dislikes first - if any match, exclude
    for (final tag in getTagsByCategory(TagCategory.dislikes)) {
      if (contentLower.contains(tag.term.toLowerCase())) {
        return false;
      }
    }

    // Check interests - if any match, include
    for (final tag in getTagsByCategory(TagCategory.interests)) {
      if (contentLower.contains(tag.term.toLowerCase())) {
        incrementUsage(tag.id);
        return true;
      }
    }

    // Check favorites - if any match, include
    for (final tag in getTagsByCategory(TagCategory.favorites)) {
      if (contentLower.contains(tag.term.toLowerCase())) {
        incrementUsage(tag.id);
        return true;
      }
    }

    // For neutral tags, don't filter based on them
    return true;
  }

  double getContentScore(String content) {
    final contentLower = content.toLowerCase();
    double score = 0.0;
    
    // Positive points for interests and favorites
    for (final tag in getTagsByCategory(TagCategory.interests)) {
      if (contentLower.contains(tag.term.toLowerCase())) {
        score += 1.0;
        incrementUsage(tag.id);
      }
    }
    
    for (final tag in getTagsByCategory(TagCategory.favorites)) {
      if (contentLower.contains(tag.term.toLowerCase())) {
        score += 2.0; // Favorites get higher weight
        incrementUsage(tag.id);
      }
    }

    // Negative points for dislikes
    for (final tag in getTagsByCategory(TagCategory.dislikes)) {
      if (contentLower.contains(tag.term.toLowerCase())) {
        score -= 2.0; // Strong negative weight
      }
    }

    return score;
  }

  // Export/Import
  Map<String, dynamic> toJson() {
    return {
      'tags': _tags.values.map((tag) => tag.toJson()).toList(),
      'categoryTags': _categoryTags.map(
        (key, value) => MapEntry(key.name, value),
      ),
    };
  }

  void fromJson(Map<String, dynamic> json) {
    _tags.clear();
    _categoryTags.forEach((key, value) => value.clear());

    final tagsJson = json['tags'] as List<dynamic>;
    for (final tagJson in tagsJson) {
      final tag = ContentTag.fromJson(tagJson);
      addTag(tag);
    }
  }

  // Utility
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  // Statistics
  Map<TagCategory, int> getCategoryStats() {
    return _categoryTags.map(
      (category, tagIds) => MapEntry(category, tagIds.length),
    );
  }

  List<ContentTag> getMostUsedTags({int limit = 10}) {
    final allTags = getAllTags();
    allTags.sort((a, b) => b.usageCount.compareTo(a.usageCount));
    return allTags.take(limit).toList();
  }

  List<ContentTag> getRecentlyUsedTags({int limit = 10}) {
    final allTags = getAllTags()
        .where((tag) => tag.lastUsed != null)
        .toList();
    allTags.sort((a, b) => b.lastUsed!.compareTo(a.lastUsed!));
    return allTags.take(limit).toList();
  }
} 