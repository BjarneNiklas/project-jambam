import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_jambam/src/features/a_ideation/presentation/jam_lab_screen.dart';
import 'package:project_jambam/src/features/a_ideation/presentation/ideation_methods_screen.dart';
import 'package:project_jambam/src/features/a_ideation/presentation/community_hub_screen.dart';
import 'package:project_jambam/src/features/a_ideation/presentation/accessibility_onboarding_screen.dart';
import '../../../shared/offline_status_widget.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  ConsumerState<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    JamLabScreen(),
    CommunityHubScreen(),
    IdeationMethodsScreen(),
    AccessibilityOnboardingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JambaM'),
        actions: [
          // Add offline status widget to app bar
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: OfflineStatusWidget(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Add offline banner at the top
          const OfflineBanner(),
          // Add sync progress indicator
          const SyncProgressIndicator(),
          // Main content
          Expanded(
            child: _screens[_selectedIndex],
          ),
        ],
      ),
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
            icon: Icon(Icons.science),
            label: 'Jam Lab',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb),
            label: 'Ideation',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.accessibility),
            label: 'Accessibility',
          ),
        ],
      ),
    );
  }
} 