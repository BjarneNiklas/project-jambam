import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/multi_agent_providers.dart';
import 'package:project_jambam/src/core/ai/enhanced_ai_providers.dart';

/// Modernes ProjectMasterAgent Dashboard
class ProjectMasterDashboardScreen extends ConsumerStatefulWidget {
  const ProjectMasterDashboardScreen({super.key});

  @override
  ConsumerState<ProjectMasterDashboardScreen> createState() => _ProjectMasterDashboardScreenState();
}

class _ProjectMasterDashboardScreenState extends ConsumerState<ProjectMasterDashboardScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final aiService = ref.watch(enhancedAIServiceProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Master Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: Future.value(aiService.getUserInsights()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          final aiInsights = snapshot.data ?? {};
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildProjectOverview(),
                const SizedBox(height: 24),
                _buildAgentStatus(),
                const SizedBox(height: 24),
                _buildAnalytics(aiInsights),
                const SizedBox(height: 24),
                _buildRecentActivity(),
              ],
            ),
          );
        },
      ),
    );
  }

  // ============================================================================
  // MISSING METHOD IMPLEMENTATIONS
  // ============================================================================

  Widget _buildHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.dashboard,
              size: 32,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Project Master Dashboard',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(
                    'AI-powered project management',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => _refreshProject(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectOverview() {
    final projectAsync = ref.watch(currentProjectProvider);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Project Overview',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            projectAsync.when(
              data: (project) {
                if (project == null) {
                  return const Text('No project loaded');
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name: ${project.name}'),
                    Text('Description: ${project.description}'),
                    Text('Status: ${project.status.name}'),
                  ],
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => Text('Error: $error'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAgentStatus() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Agent Status',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            const Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.smart_toy,
                    color: Colors.green,
                  ),
                  title: Text('Research Agent'),
                  subtitle: Text('Active'),
                ),
                ListTile(
                  leading: Icon(
                    Icons.brush,
                    color: Colors.blue,
                  ),
                  title: Text('Creative Director'),
                  subtitle: Text('Processing'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalytics(Map<String, dynamic> aiInsights) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Analytics & Insights',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Text('AI Insights: ${aiInsights.length} items'),
            // Add more analytics widgets here
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activity',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            const Text('No recent activity'),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  // ============================================================================
  // ACTION HANDLERS
  // ============================================================================

  void _refreshProject() async {
    // TODO: Implement project refresh
  }
} 