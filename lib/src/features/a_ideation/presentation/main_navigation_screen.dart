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
import 'placeholder_screen.dart';
import 'y_chat_screen.dart';

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
      color: Colors.teal,
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
    const YChatScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.teal[300]),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          border: Border(
            top: BorderSide(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.transparent,
          selectedItemColor: Colors.teal[300],
          unselectedItemColor: Colors.grey[400],
          elevation: 0,
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
              icon: Icon(Icons.chat),
              label: 'Y Chat',
            ),
          ],
        ),
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFF1A1A1A),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Header
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal[600]!, Colors.teal[400]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                    ),
                    child: const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.transparent,
                      child: Icon(Icons.person, size: 30, color: Colors.white),
                    ),
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
            
            Divider(color: Colors.white.withValues(alpha: 0.2)),
            
            // Main Sections
            ListTile(
              leading: Icon(Icons.home, color: Colors.teal[300]),
              title: const Text('Home', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _currentIndex = 0;
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.explore, color: Colors.teal[300]),
              title: const Text('Explore', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _currentIndex = 1;
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.sports_esports, color: Colors.teal[300]),
              title: const Text('Arena', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _currentIndex = 2;
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.work, color: Colors.teal[300]),
              title: const Text('Studio', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _currentIndex = 3;
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.school, color: Colors.teal[300]),
              title: const Text('Academy', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                // Academy is in drawer only
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AcademyScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.chat, color: Colors.teal[300]),
              title: const Text('Y Chat', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _currentIndex = 4;
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.psychology, color: Colors.teal[300]),
              title: const Text('JambaAI', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const JambaAIScreen()),
                );
              },
            ),
            
            Divider(color: Colors.white.withValues(alpha: 0.2)),
            
            // AI Features
            ListTile(
              leading: Icon(Icons.psychology, color: Colors.teal[300]),
              title: const Text('AI Features', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            ),
            ListTile(
              leading: Icon(Icons.science, color: Colors.teal[300]),
              title: const Text('Research Agent', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ResearchAgentScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.build, color: Colors.teal[300]),
              title: const Text('Game Engine Agent', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GameEngineAgentScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.tune, color: Colors.teal[300]),
              title: const Text('Agent Contexts', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AgentContextManagementScreen()),
                );
              },
            ),
            
            Divider(color: Colors.white.withValues(alpha: 0.2)),
            
            // Community
            ListTile(
              leading: Icon(Icons.people, color: Colors.teal[300]),
              title: const Text('Community', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            ),
            ListTile(
              leading: Icon(Icons.lightbulb, color: Colors.teal[300]),
              title: const Text('Inspiration of the Day', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const InspirationOfTheDayScreen()),
                );
              },
            ),
            
            Divider(color: Colors.white.withValues(alpha: 0.2)),
            
            // Development
            ListTile(
              leading: Icon(Icons.developer_mode, color: Colors.teal[300]),
              title: const Text('Development', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            ),
            ListTile(
              leading: Icon(Icons.science, color: Colors.teal[300]),
              title: const Text('Labs', style: TextStyle(color: Colors.white)),
              subtitle: const Text('Experimentieren & Lernen', style: TextStyle(color: Colors.grey)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PlaceholderScreen(title: 'Labs')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.analytics, color: Colors.teal[300]),
              title: const Text('Analytics', style: TextStyle(color: Colors.white)),
              subtitle: const Text('Projekt-Statistiken', style: TextStyle(color: Colors.grey)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PlaceholderScreen(title: 'Analytics')),
                );
              },
            ),
            
            Divider(color: Colors.white.withValues(alpha: 0.2)),
            
            // Profile & Settings
            ListTile(
              leading: Icon(Icons.person, color: Colors.teal[300]),
              title: const Text('Profil', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PlaceholderScreen(title: 'Profile')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.teal[300]),
              title: const Text('Einstellungen', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PlaceholderScreen(title: 'Settings')),
                );
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