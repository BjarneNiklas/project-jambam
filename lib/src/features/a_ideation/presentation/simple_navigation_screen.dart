import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_jambam/src/features/a_ideation/presentation/home_screen.dart';
import 'package:project_jambam/src/features/a_ideation/presentation/jamba_ai_screen.dart';
import 'package:project_jambam/src/features/a_ideation/presentation/community_screen.dart';
import 'package:project_jambam/src/features/a_ideation/presentation/simple_projects_screen.dart';

class SimpleNavigationScreen extends ConsumerStatefulWidget {
  const SimpleNavigationScreen({super.key});

  @override
  ConsumerState<SimpleNavigationScreen> createState() => _SimpleNavigationScreenState();
}

class _SimpleNavigationScreenState extends ConsumerState<SimpleNavigationScreen> {
  int _selectedIndex = 0;

  // Bottom Navigation Screens
  static const List<Widget> _bottomNavScreens = [
    HomeScreen(),
    ExploreScreen(),
    ArenaScreen(),
    ProjectsScreen(),
    JambaAIScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JambaM'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      drawer: _buildDrawer(context),
      body: _bottomNavScreens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Studio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Y Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_esports),
            label: 'Arena',
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Drawer Header
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 30,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'User Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'user@example.com',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // Menu Items
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () => _showComingSoon(context, 'Dashboard'),
          ),
          ListTile(
            leading: const Icon(Icons.science),
            title: const Text('Research Agent'),
            onTap: () => _showComingSoon(context, 'Research Agent'),
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Community Hub'),
            onTap: () => _showComingSoon(context, 'Community Hub'),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () => _showComingSoon(context, 'Settings'),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    Navigator.of(context).pop(); // Close drawer
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Coming Soon: $feature')),
    );
  }
}

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Explore',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.people),
                title: const Text('Community Hub'),
                subtitle: const Text('Entdecke andere Entwickler und Projekte'),
                onTap: () => _showComingSoon(context),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.search),
                title: const Text('Research Agent'),
                subtitle: const Text('KI-gestützte Forschung und Inspiration'),
                onTap: () => _showComingSoon(context),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.trending_up),
                title: const Text('Trending Jams'),
                subtitle: const Text('Aktuelle Game Jams und Challenges'),
                onTap: () => _showComingSoon(context),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.analytics),
                title: const Text('Analytics & Predictions'),
                subtitle: const Text('Markt-Trends und Erfolgsprognosen'),
                onTap: () => _showComingSoon(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Coming Soon: Feature wird implementiert')),
    );
  }
} 