import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// TODO: Implement or restore enhanced_chip.dart
import 'package:project_jambam/src/shared/enhanced_chip.dart';
import '../data/content_filter_service.dart';
import '../domain/content_filter_system.dart';

class EnhancedContentFilterScreen extends ConsumerStatefulWidget {
  const EnhancedContentFilterScreen({super.key});

  @override
  ConsumerState<EnhancedContentFilterScreen> createState() => _EnhancedContentFilterScreenState();
}

class _EnhancedContentFilterScreenState extends ConsumerState<EnhancedContentFilterScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final ContentFilterService _filterService = ContentFilterService();
  
  // UI State
  String _searchQuery = '';
  bool _showUsageStats = true;
  bool _showSourceIcons = true;
  bool _isEditing = false;
  Set<String> _selectedTags = {};
  
  // Quick add
  final TextEditingController _quickAddController = TextEditingController();
  TagCategory _quickAddCategory = TagCategory.interests;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _filterService.initialize();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _quickAddController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Content Filter System'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.done : Icons.edit),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
                if (!_isEditing) {
                  _selectedTags.clear();
                }
              });
            },
          ),
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.upload),
                    SizedBox(width: 8),
                    Text('Export'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'import',
                child: Row(
                  children: [
                    Icon(Icons.download),
                    SizedBox(width: 8),
                    Text('Import'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clear_all',
                child: Row(
                  children: [
                    Icon(Icons.clear_all),
                    SizedBox(width: 8),
                    Text('Clear All'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(width: 8),
                    Text('Settings'),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            _buildCategoryTab(TagCategory.interests, Icons.favorite, Colors.green),
            _buildCategoryTab(TagCategory.dislikes, Icons.thumb_down, Colors.red),
            _buildCategoryTab(TagCategory.neutral, Icons.help_outline, Colors.orange),
            _buildCategoryTab(TagCategory.favorites, Icons.star, Colors.blue),
          ],
        ),
      ),
      body: Column(
        children: [
          // Quick Add Section
          _buildQuickAddSection(),
          
          // Search Bar
          _buildSearchBar(),
          
          // Statistics Bar
          if (_showUsageStats) _buildStatisticsBar(),
          
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCategoryContent(TagCategory.interests),
                _buildCategoryContent(TagCategory.dislikes),
                _buildCategoryContent(TagCategory.neutral),
                _buildCategoryContent(TagCategory.favorites),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _isEditing ? _buildFloatingActionButtons() : null,
    );
  }

  Widget _buildCategoryTab(TagCategory category, IconData icon, Color color) {
    final tags = _filterService.filterSystem.getTagsByCategory(category);
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 4),
          Text('${tags.length}'),
        ],
      ),
    );
  }

  Widget _buildQuickAddSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Add Tag',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _quickAddController,
                  decoration: const InputDecoration(
                    hintText: 'Enter tag term...',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  onSubmitted: (value) => _quickAddTag(),
                ),
              ),
              const SizedBox(width: 8),
              DropdownButton<TagCategory>(
                value: _quickAddCategory,
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _quickAddCategory = value);
                  }
                },
                items: TagCategory.values.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_getCategoryIcon(category), 
                             color: _getCategoryColor(category), 
                             size: 16),
                        const SizedBox(width: 4),
                        Text(_getCategoryName(category)),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _quickAddTag,
                child: const Text('Add'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search tags...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          border: const OutlineInputBorder(),
        ),
        onChanged: (value) {
          setState(() => _searchQuery = value);
        },
      ),
    );
  }

  Widget _buildStatisticsBar() {
    final stats = _filterService.getCategoryStats();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: TagCategory.values.map((category) {
          final count = stats[category] ?? 0;
          return Column(
            children: [
              Icon(_getCategoryIcon(category), 
                   color: _getCategoryColor(category)),
              Text('$count', style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(_getCategoryName(category), 
                   style: const TextStyle(fontSize: 12)),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCategoryContent(TagCategory category) {
    List<ContentTag> tags = _filterService.filterSystem.getTagsByCategory(category);
    
    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      tags = tags.where((tag) => 
        tag.term.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    
    // Sort by usage count
    tags.sort((a, b) => b.usageCount.compareTo(a.usageCount));

    if (tags.isEmpty) {
      return _buildEmptyState(category);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tags.length,
      itemBuilder: (context, index) {
        final tag = tags[index];
        final isSelected = _selectedTags.contains(tag.id);
        
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: _buildTagIcon(tag),
            title: Text(tag.term),
            subtitle: _buildTagSubtitle(tag),
            trailing: _isEditing
                ? Checkbox(
                    value: isSelected,
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          _selectedTags.add(tag.id);
                        } else {
                          _selectedTags.remove(tag.id);
                        }
                      });
                    },
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_showUsageStats && tag.usageCount > 0)
                        Chip(
                          label: Text('${tag.usageCount}'),
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        ),
                      PopupMenuButton<String>(
                        onSelected: (value) => _handleTagAction(value, tag),
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'move',
                            child: Row(
                              children: [
                                Icon(Icons.drive_file_move),
                                SizedBox(width: 8),
                                Text('Move to...'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete),
                                SizedBox(width: 8),
                                Text('Delete'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
            onTap: _isEditing
                ? () {
                    setState(() {
                      if (isSelected) {
                        _selectedTags.remove(tag.id);
                      } else {
                        _selectedTags.add(tag.id);
                      }
                    });
                  }
                : null,
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(TagCategory category) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getCategoryIcon(category),
            size: 64,
            color: _getCategoryColor(category).withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No ${_getCategoryName(category)} tags yet',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Add some tags to get started!',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildTagIcon(ContentTag tag) {
    return CircleAvatar(
      backgroundColor: _getCategoryColor(tag.category).withOpacity(0.2),
      child: Icon(
        _getSourceIcon(tag.source),
        color: _getCategoryColor(tag.category),
        size: 20,
      ),
    );
  }

  Widget _buildTagSubtitle(ContentTag tag) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${_getCategoryName(tag.category)} • ${_getSourceName(tag.source)}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        if (tag.lastUsed != null)
          Text(
            'Last used: ${_formatDate(tag.lastUsed!)}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
      ],
    );
  }

  Widget? _buildFloatingActionButtons() {
    if (_selectedTags.isEmpty) return null;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          heroTag: 'move',
          onPressed: _showMoveDialog,
          child: const Icon(Icons.drive_file_move),
        ),
        const SizedBox(width: 16),
        FloatingActionButton(
          heroTag: 'delete',
          onPressed: _deleteSelectedTags,
          backgroundColor: Colors.red,
          child: const Icon(Icons.delete),
        ),
      ],
    );
  }

  // Helper Methods
  IconData _getCategoryIcon(TagCategory category) {
    switch (category) {
      case TagCategory.interests:
        return Icons.favorite;
      case TagCategory.dislikes:
        return Icons.thumb_down;
      case TagCategory.neutral:
        return Icons.help_outline;
      case TagCategory.favorites:
        return Icons.star;
    }
  }

  Color _getCategoryColor(TagCategory category) {
    switch (category) {
      case TagCategory.interests:
        return Colors.green;
      case TagCategory.dislikes:
        return Colors.red;
      case TagCategory.neutral:
        return Colors.orange;
      case TagCategory.favorites:
        return Colors.blue;
    }
  }

  String _getCategoryName(TagCategory category) {
    switch (category) {
      case TagCategory.interests:
        return 'Interests';
      case TagCategory.dislikes:
        return 'Dislikes';
      case TagCategory.neutral:
        return 'Neutral';
      case TagCategory.favorites:
        return 'Favorites';
    }
  }

  IconData _getSourceIcon(TagSource source) {
    switch (source) {
      case TagSource.user:
        return Icons.person;
      case TagSource.research:
        return Icons.science;
      case TagSource.popular:
        return Icons.trending_up;
      case TagSource.suggested:
        return Icons.auto_awesome;
      case TagSource.imported:
        return Icons.file_download;
    }
  }

  String _getSourceName(TagSource source) {
    switch (source) {
      case TagSource.user:
        return 'User';
      case TagSource.research:
        return 'Research';
      case TagSource.popular:
        return 'Popular';
      case TagSource.suggested:
        return 'Suggested';
      case TagSource.imported:
        return 'Imported';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  // Actions
  void _quickAddTag() {
    final term = _quickAddController.text.trim();
    if (term.isEmpty) return;
    
    _filterService.addUserTag(term, _quickAddCategory);
    _quickAddController.clear();
    setState(() {});
  }

  void _handleMenuAction(String action) async {
    switch (action) {
      case 'export':
        _exportData();
        break;
      case 'import':
        _importData();
        break;
      case 'clear_all':
        _showClearAllDialog();
        break;
      case 'settings':
        _showSettingsDialog();
        break;
    }
  }

  void _handleTagAction(String action, ContentTag tag) {
    switch (action) {
      case 'move':
        _showMoveDialog(selectedTags: [tag.id]);
        break;
      case 'delete':
        _showDeleteDialog([tag]);
        break;
    }
  }

  void _showMoveDialog({List<String>? selectedTags}) {
    final tagsToMove = selectedTags ?? _selectedTags.toList();
    if (tagsToMove.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Move Tags'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: TagCategory.values.map((category) {
            return ListTile(
              leading: Icon(_getCategoryIcon(category), 
                           color: _getCategoryColor(category)),
              title: Text(_getCategoryName(category)),
              onTap: () {
                Navigator.pop(context);
                _moveTags(tagsToMove, category);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _moveTags(List<String> tagIds, TagCategory category) async {
    await _filterService.moveTagsToCategory(tagIds, category);
    setState(() {
      _selectedTags.clear();
    });
  }

  void _deleteSelectedTags() {
    final tagsToDelete = _filterService.filterSystem.getAllTags()
        .where((tag) => _selectedTags.contains(tag.id))
        .toList();
    _showDeleteDialog(tagsToDelete);
  }

  void _showDeleteDialog(List<ContentTag> tags) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Tags'),
        content: Text('Are you sure you want to delete ${tags.length} tag(s)?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteTags(tags);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _deleteTags(List<ContentTag> tags) async {
    final tagIds = tags.map((tag) => tag.id).toList();
    await _filterService.removeTags(tagIds);
    setState(() {
      _selectedTags.clear();
    });
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Tags'),
        content: const Text('Are you sure you want to delete all tags? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _clearAllTags();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void _clearAllTags() async {
    await _filterService.clearAllTags();
    setState(() {});
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('Show Usage Statistics'),
              value: _showUsageStats,
              onChanged: (value) {
                setState(() => _showUsageStats = value);
              },
            ),
            SwitchListTile(
              title: const Text('Show Source Icons'),
              value: _showSourceIcons,
              onChanged: (value) {
                setState(() => _showSourceIcons = value);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _exportData() async {
    try {
      await _filterService.exportTags();
      // In a real app, you'd save this to a file or share it
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data exported successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export failed: $e')),
      );
    }
  }

  void _importData() async {
    // In a real app, you'd pick a file or get data from clipboard
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Import feature coming soon')),
    );
  }
} 