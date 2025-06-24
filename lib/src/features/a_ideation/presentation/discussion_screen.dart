import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Forum'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Search discussions
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // TODO: Show notifications
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateTopicDialog();
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildDiscussionsTab() {
    return Column(
      children: [
        _buildFilterBar(),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildDiscussionCard(
                'What AI tools are you using for game development?',
                'John Doe',
                'General',
                '2 hours ago',
                15,
                8,
                125,
                true,
              ),
              _buildDiscussionCard(
                'Unity vs Unreal for AI integration - which is better?',
                'Jane Smith',
                'Game Development',
                '4 hours ago',
                23,
                12,
                89,
                false,
              ),
              _buildDiscussionCard(
                'Flutter game development tips and tricks',
                'Bob Johnson',
                'Flutter',
                '6 hours ago',
                8,
                5,
                67,
                false,
              ),
              _buildDiscussionCard(
                'Showcase: My AI-powered adventure game',
                'Alice Brown',
                'Showcase',
                '1 day ago',
                45,
                18,
                234,
                true,
              ),
              _buildDiscussionCard(
                'Help needed with 3D model optimization',
                'Charlie Wilson',
                '3D Modeling',
                '1 day ago',
                12,
                6,
                78,
                false,
              ),
              _buildDiscussionCard(
                'Best practices for AI NPCs in games',
                'Diana Miller',
                'AI & Machine Learning',
                '2 days ago',
                31,
                14,
                156,
                false,
              ),
            ],
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
            color: Colors.grey.withAlpha((0.1 * 255).round()),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
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
          Expanded(
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

  Widget _buildDiscussionCard(String title, String author, String category, String time, int likes, int replies, int views, bool isPinned) {
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
                      color: Colors.amber.withAlpha((0.1 * 255).round()),
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
                    color: _getCategoryColor(category).withAlpha((0.1 * 255).round()),
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
                  icon: const Icon(Icons.thumb_up_outlined, size: 20),
                  onPressed: () {
                    // TODO: Like discussion
                  },
                ),
                Text('$likes'),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.reply, size: 20),
                  onPressed: () {
                    // TODO: Reply to discussion
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
                IconButton(
                  icon: const Icon(Icons.more_vert, size: 20),
                  onPressed: () {
                    // TODO: Show options
                  },
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
            color: color.withAlpha((0.1 * 255).round()),
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
          // TODO: Navigate to category
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
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildMyTopicCard(
          'How to integrate AI in Unity games?',
          'General',
          '2 days ago',
          12,
          5,
          'Active',
        ),
        _buildMyTopicCard(
          'Flutter game performance optimization',
          'Flutter',
          '1 week ago',
          8,
          3,
          'Resolved',
        ),
        _buildMyTopicCard(
          'Showcase: My first AI game',
          'Showcase',
          '2 weeks ago',
          25,
          12,
          'Active',
        ),
      ],
    );
  }

  Widget _buildMyTopicCard(String title, String category, String time, int replies, int views, String status) {
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
                    color: _getCategoryColor(category).withAlpha((0.1 * 255).round()),
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
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: status == 'Active' ? Colors.green.withAlpha((0.1 * 255).round()) : Colors.grey.withAlpha((0.1 * 255).round()),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: status == 'Active' ? Colors.green : Colors.grey,
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
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.reply, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '$replies replies',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.visibility, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '$views views',
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
                      // TODO: Edit topic
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete'),
                    onPressed: () {
                      // TODO: Delete topic
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Topic'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: _categories.skip(1).map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                // TODO: Handle category selection
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
          ],
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
              // TODO: Create topic
              Navigator.pop(context);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
} 