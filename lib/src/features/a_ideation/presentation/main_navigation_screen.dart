import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'jamba_ai_screen.dart';
import 'community_screen.dart';
import 'projects_screen.dart';
import 'academy_screen.dart';
import 'research_agent_screen.dart';
import 'game_engine_agent_screen.dart';
import 'agent_context_management_screen.dart';
import 'inspiration_of_the_day_screen.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  ConsumerState<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  int _currentIndex = 0;

  // Simple placeholder screens
  final List<Widget> _screens = [
    const _PlaceholderScreen(
      title: 'Home',
      icon: Icons.home,
      color: Colors.blue,
      description: 'Willkommen bei JambaM!',
    ),
    const _PlaceholderScreen(
      title: 'Explore',
      icon: Icons.explore,
      color: Colors.green,
      description: 'Entdecke Game Jams & Projekte',
    ),
    const ArenaScreen(),
    const ProjectsScreen(),
    const AcademyScreen(),
    const JambaAIScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
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
            icon: Icon(Icons.sports_esports),
            label: 'Arena',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Studio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Academy',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Y Chat',
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Header
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue[700],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 30, color: Colors.blue),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'JambaM',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'AI Game Development',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            
            // Profile & Settings
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profil'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to profile
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Einstellungen'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to settings
              },
            ),
            
            const Divider(),
            
            // AI Features
            const ListTile(
              leading: Icon(Icons.psychology),
              title: Text('AI Features', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            ListTile(
              leading: const Icon(Icons.science),
              title: const Text('Research Agent'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ResearchAgentScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.build),
              title: const Text('Game Engine Agent'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GameEngineAgentScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.tune),
              title: const Text('Agent Contexts'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AgentContextManagementScreen()),
                );
              },
            ),
            
            const Divider(),
            
            // Community
            const ListTile(
              leading: Icon(Icons.people),
              title: Text('Community', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            ListTile(
              leading: const Icon(Icons.lightbulb),
              title: const Text('Inspiration of the Day'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const InspirationOfTheDayScreen()),
                );
              },
            ),
            
            const Divider(),
            
            // Development
            const ListTile(
              leading: Icon(Icons.developer_mode),
              title: Text('Development', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            ListTile(
              leading: const Icon(Icons.science),
              title: const Text('Labs'),
              subtitle: const Text('Experimentieren & Lernen'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to labs
              },
            ),
            ListTile(
              leading: const Icon(Icons.analytics),
              title: const Text('Analytics'),
              subtitle: const Text('Projekt-Statistiken'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to analytics
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Simple placeholder screen
class _PlaceholderScreen extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String description;

  const _PlaceholderScreen({
    required this.title,
    required this.icon,
    required this.color,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: color),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
} 