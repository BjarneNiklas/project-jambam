import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _DiscussionData {
  final String title;
  final String author;
  final String category;
  final String time;
  final int likes;
  final int replies;
  final int views;
  final bool isPinned;
  bool isLiked; // Keep the property but remove from constructor

  _DiscussionData({
    required this.title,
    required this.author,
    required this.category,
    required this.time,
    required this.likes,
    required this.replies,
    required this.views,
    required this.isPinned,
  }) : isLiked = false; // Set default value in initializer list
}

class _MyTopicData {
  String title;
  String category;
  final String time; // Assuming time is fixed
  final int replies; // Assuming replies are fixed for this scope
  final int views;   // Assuming views are fixed for this scope
  String status;
  String content; // Added for editing

  _MyTopicData({
    required this.title,
    required this.category,
    required this.time,
    required this.replies,
    required this.views,
    required this.status,
    required this.content,
  });
}

class DiscussionScreen extends ConsumerStatefulWidget {
  const DiscussionScreen({super.key});

  @override
  ConsumerState<DiscussionScreen> createState() => _DiscussionScreenState();
}

class _DiscussionScreenState extends ConsumerState<DiscussionScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'All';
  String _sortBy = 'Latest';

  // Search state
  bool _isSearching = false;
  String _searchQuery = '';
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  // Data for discussions
  final List<_DiscussionData> _allDiscussions = [
    _DiscussionData(title: 'What AI tools are you using for game development?', author: 'John Doe', category: 'General', time: '2 hours ago', likes: 15, replies: 8, views: 125, isPinned: true),
    _DiscussionData(title: 'Unity vs Unreal for AI integration - which is better?', author: 'Jane Smith', category: 'Game Development', time: '4 hours ago', likes: 23, replies: 12, views: 89, isPinned: false),
    _DiscussionData(title: 'Flutter game development tips and tricks', author: 'Bob Johnson', category: 'Flutter', time: '6 hours ago', likes: 8, replies: 5, views: 67, isPinned: false),
    _DiscussionData(title: 'Showcase: My AI-powered adventure game', author: 'Alice Brown', category: 'Showcase', time: '1 day ago', likes: 45, replies: 18, views: 234, isPinned: true),
    _DiscussionData(title: 'Help needed with 3D model optimization', author: 'Charlie Wilson', category: '3D Modeling', time: '1 day ago', likes: 12, replies: 6, views: 78, isPinned: false),
    _DiscussionData(title: 'Best practices for AI NPCs in games', author: 'Diana Miller', category: 'AI & Machine Learning', time: '2 days ago', likes: 31, replies: 14, views: 156, isPinned: false),
  ];

  List<_DiscussionData> _filteredDiscussions = [];

  // Data for My Topics
  final List<_MyTopicData> _myTopics = [
    _MyTopicData(title: 'How to integrate AI in Unity games?', category: 'General', time: '2 days ago', replies: 12, views: 5, status: 'Active', content: 'Looking for best practices and examples for AI integration in Unity. Specifically interested in behavior trees and pathfinding.'),
    _MyTopicData(title: 'Flutter game performance optimization', category: 'Flutter', time: '1 week ago', replies: 8, views: 3, status: 'Resolved', content: 'What are the key areas to focus on for optimizing Flutter game performance? Any specific packages or techniques?'),
    _MyTopicData(title: 'Showcase: My first AI game', category: 'Showcase', time: '2 weeks ago', replies: 25, views: 12, status: 'Active', content: 'Just finished my first game featuring simple AI enemies. Would love feedback!'),
  ];
  String? _editingTopicCategory; // For create/edit dialog

  final List<String> _categories = [
    'All',
    'General',
    'Game Development',
    'AI & Machine Learning',
    'Unity',
    'Flutter',
    '3D Modeling',
    'Help & Support',
    'Showcase',
    'Off Topic',
  ];

  final List<String> _sortOptions = [
    'Latest',
    'Most Popular',
    'Most Replies',
    'Most Views',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _filteredDiscussions = _allDiscussions;
    _searchController.addListener(() {
      _filterDiscussions();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _filterDiscussions() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _searchQuery = query;
      _filteredDiscussions = _allDiscussions.where((discussion) {
        return discussion.title.toLowerCase().contains(query) ||
               discussion.author.toLowerCase().contains(query) ||
               discussion.category.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search discussions...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white.withAlpha(200)),
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: (query) {
                  setState(() {
                    _searchQuery = query;
                  });
                },
              )
            : const Text('Community Forum'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: _isSearching
            ? [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _isSearching = false;
                      _searchQuery = '';
                      _searchController.clear();
                    });
                  },
                ),
              ]
            : [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _isSearching = true;
                    });
                    _searchFocusNode.requestFocus();
                  },
                ),
                IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notifications feature coming soon!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'DISCUSSIONS'),
            Tab(text: 'CATEGORIES'),
            Tab(text: 'MY TOPICS'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDiscussionsTab(),
          _buildCategoriesTab(),
          _buildMyTopicsTab(),
        ],
      ),
      floatingActionButton: _isSearching
          ? null
          : FloatingActionButton(
              onPressed: () {
                _showCreateTopicDialog();
              },
              backgroundColor: Colors.green,
              child: const Icon(Icons.add, color: Colors.white),
            ),
    );
  }

  Widget _buildDiscussionsTab() {
    // Apply category filter first
    List<_DiscussionData> discussionsToDisplay = _selectedCategory == 'All'
        ? _filteredDiscussions
        : _filteredDiscussions
            .where((d) => d.category == _selectedCategory)
            .toList();

    // Then apply sorting (basic example, can be expanded)
    if (_sortBy == 'Most Popular') {
      discussionsToDisplay.sort((a, b) => b.views.compareTo(a.views));
    } else if (_sortBy == 'Most Replies') {
      discussionsToDisplay.sort((a, b) => b.replies.compareTo(a.replies));
    } else { // Default to Latest (assuming current order is somewhat latest)
      // For a true 'Latest' sort, you'd need a timestamp.
      // For now, pinned items go first.
      discussionsToDisplay.sort((a, b) {
        if (a.isPinned && !b.isPinned) return -1;
        if (!a.isPinned && b.isPinned) return 1;
        // Add time-based sorting here if available
        return 0;
      });
    }

    if (discussionsToDisplay.isEmpty && _searchQuery.isNotEmpty) {
      return Center(
        child: Text(
          'No discussions found for "$_searchQuery".',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      );
    }

    if (discussionsToDisplay.isEmpty && _selectedCategory != 'All') {
       return Center(
        child: Text(
          'No discussions in $_selectedCategory yet.',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      );
    }


    return Column(
      children: [
        _buildFilterBar(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: discussionsToDisplay.length,
            itemBuilder: (context, index) {
              final discussion = discussionsToDisplay[index];
              return _buildDiscussionCard(
                discussion.title,
                discussion.author,
                discussion.category,
                discussion.time,
                discussion.likes,
                discussion.replies,
                discussion.views,
                discussion.isPinned,
                () { // Callback for liking
                  setState(() {
                    discussion.isLiked = !discussion.isLiked;
                    if (discussion.isLiked) {
                      // In a real app, you might increment a counter if not already liked
                      // discussion.likes++;
                    } else {
                      // discussion.likes--;
                    }
                  });
                }
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(25),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            fit: FlexFit.loose,
            child: DropdownButtonFormField<String>(
              value: _sortBy,
              decoration: const InputDecoration(
                labelText: 'Sort by',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: _sortOptions.map((option) {
                return DropdownMenuItem(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _sortBy = value!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteTopicConfirmationDialog(_MyTopicData topic) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Topic'),
        content: Text('Are you sure you want to delete the topic "${topic.title}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () {
              setState(() {
                _myTopics.remove(topic);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Topic "${topic.title}" deleted.')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscussionCard(String title, String author, String category, String time, int likes, int replies, int views, bool isPinned, VoidCallback onLikePressed) {
    // The 'likes' count will come directly from the discussion data.
    // The 'isLiked' state will control the icon.
    // Actual increment/decrement of 'likes' would be a backend operation.

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (isPinned)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber.withAlpha(25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'PINNED',
                      style: TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                if (isPinned) const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(category).withAlpha(25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      color: _getCategoryColor(category),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.green,
                  child: Text(
                    author[0],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  author,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.thumb_up,
                    size: 20,
                    color: Colors.grey[600],
                  ),
                  onPressed: onLikePressed,
                ),
                Text('$likes'), // Now using likes directly
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.reply, size: 20),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Reply feature coming soon!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
                Text('$replies'),
                const SizedBox(width: 16),
                Icon(Icons.visibility, size: 20, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '$views',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, size: 20),
                  onSelected: (value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('$value option selected. Coming soon!'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'Edit',
                      child: Text('Edit Discussion'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Delete',
                      child: Text('Delete Discussion'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Report',
                      child: Text('Report Discussion'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'General':
        return Colors.blue;
      case 'Game Development':
        return Colors.green;
      case 'AI & Machine Learning':
        return Colors.purple;
      case 'Unity':
        return Colors.orange;
      case 'Flutter':
        return Colors.indigo;
      case '3D Modeling':
        return Colors.teal;
      case 'Help & Support':
        return Colors.red;
      case 'Showcase':
        return Colors.amber;
      case 'Off Topic':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  Widget _buildCategoriesTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildCategoryCard('General', 'General discussions about game development', 156, Colors.blue),
        _buildCategoryCard('Game Development', 'Game development techniques and tips', 234, Colors.green),
        _buildCategoryCard('AI & Machine Learning', 'AI integration in games', 89, Colors.purple),
        _buildCategoryCard('Unity', 'Unity-specific discussions', 178, Colors.orange),
        _buildCategoryCard('Flutter', 'Flutter game development', 67, Colors.indigo),
        _buildCategoryCard('3D Modeling', '3D modeling and asset creation', 45, Colors.teal),
        _buildCategoryCard('Help & Support', 'Get help with your projects', 123, Colors.red),
        _buildCategoryCard('Showcase', 'Show off your projects', 89, Colors.amber),
        _buildCategoryCard('Off Topic', 'Non-game development discussions', 34, Colors.grey),
      ],
    );
  }

  Widget _buildCategoryCard(String name, String description, int topics, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withAlpha(25),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(_getCategoryIcon(name), color: color, size: 24),
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description),
            const SizedBox(height: 4),
            Text(
              '$topics topics',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          setState(() {
            _selectedCategory = name; // 'name' is the category name from _buildCategoryCard
            _tabController.animateTo(0); // Animate to the Discussions tab (index 0)
          });
        },
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'General':
        return Icons.forum;
      case 'Game Development':
        return Icons.games;
      case 'AI & Machine Learning':
        return Icons.psychology;
      case 'Unity':
        return Icons.view_in_ar;
      case 'Flutter':
        return Icons.phone_android;
      case '3D Modeling':
        return Icons.view_in_ar;
      case 'Help & Support':
        return Icons.help;
      case 'Showcase':
        return Icons.emoji_events;
      case 'Off Topic':
        return Icons.chat_bubble_outline;
      default:
        return Icons.forum;
    }
  }

  Widget _buildMyTopicsTab() {
    if (_myTopics.isEmpty) {
      return const Center(
        child: Text(
          'You have not created any topics yet.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _myTopics.length,
      itemBuilder: (context, index) {
        final topic = _myTopics[index];
        return _buildMyTopicCard(topic);
      },
    );
  }

  Widget _buildMyTopicCard(_MyTopicData topic) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(topic.category).withAlpha(25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    topic.category,
                    style: TextStyle(
                      color: _getCategoryColor(topic.category),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: topic.status == 'Active' ? Colors.green.withAlpha(25) : Colors.grey.withAlpha(25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    topic.status,
                    style: TextStyle(
                      color: topic.status == 'Active' ? Colors.green : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              topic.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  topic.time,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.reply, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${topic.replies} replies',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.visibility, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${topic.views} views',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                    onPressed: () {
                      _showEditTopicDialog(topic);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete'),
                    onPressed: () {
                      _showDeleteTopicConfirmationDialog(topic);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateTopicDialog() {
    final formKey = GlobalKey<FormState>(); // For validation
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    // Ensure _editingTopicCategory is initialized for the create dialog
    // Default to the first actual category, or null if no categories exist (besides 'All')
    _editingTopicCategory = _categories.length > 1 ? _categories[1] : null;


    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Topic'),
        content: Form( // Wrap content in a Form
          key: formKey,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setStateDialog) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    value: _editingTopicCategory,
                    items: _categories.skip(1).map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setStateDialog(() {
                          _editingTopicCategory = value;
                        });
                      }
                    },
                    validator: (value) => value == null ? 'Please select a category' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Please enter a title' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: contentController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Content',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Please enter content' : null,
                  ),
                ],
              );
            }
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                if (_editingTopicCategory == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select a category first.')),
                  );
                  return;
                }
                final newTopic = _MyTopicData(
                  title: titleController.text,
                  category: _editingTopicCategory!,
                  time: 'Just now',
                  replies: 0,
                  views: 0,
                  status: 'Active',
                  content: contentController.text,
                );
                setState(() {
                  _myTopics.insert(0, newTopic);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Topic "${newTopic.title}" created!')),
                );
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showEditTopicDialog(_MyTopicData topic) {
    _editingTopicCategory = topic.category;
    final titleController = TextEditingController(text: topic.title);
    final contentController = TextEditingController(text: topic.content);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Topic'),
        content: StatefulBuilder( // Use StatefulBuilder to update dialog state for dropdown
          builder: (BuildContext context, StateSetter setStateDialog) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  value: _editingTopicCategory,
                  items: _categories.skip(1).map((category) { // Skip 'All'
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setStateDialog(() { // Use setState from StatefulBuilder
                        _editingTopicCategory = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: contentController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Content',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                ),
              ],
            );
          }
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                topic.title = titleController.text;
                topic.content = contentController.text;
                topic.category = _editingTopicCategory ?? topic.category; // Fallback if null
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Topic updated locally! (Not saved permanently)')),
              );
            },
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }
} 