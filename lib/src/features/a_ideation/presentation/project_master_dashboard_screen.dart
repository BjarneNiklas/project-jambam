import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/multi_agent_providers.dart';
import '../data/external_integration_service.dart';
import 'package:project_jambam/src/core/ai/enhanced_ai_providers.dart';
import 'package:project_jambam/src/features/a_ideation/domain/multi_agent_system.dart' as domain;

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

  IconData _getAgentIcon(domain.AgentStatus status) {
    switch (status) {
      case domain.AgentStatus.active:
        return Icons.play_circle;
      case domain.AgentStatus.idle:
        return Icons.pause_circle;
      case domain.AgentStatus.processing:
        return Icons.sync;
      case domain.AgentStatus.error:
        return Icons.error;
      case domain.AgentStatus.completed:
        return Icons.check_circle;
    }
  }

  Color _getAgentColor(domain.AgentStatus status) {
    switch (status) {
      case domain.AgentStatus.active:
        return Colors.green;
      case domain.AgentStatus.idle:
        return Colors.grey;
      case domain.AgentStatus.processing:
        return Colors.blue;
      case domain.AgentStatus.error:
        return Colors.red;
      case domain.AgentStatus.completed:
        return Colors.green;
    }
  }

  // ============================================================================
  // ACTION HANDLERS
  // ============================================================================

  Future<void> _refreshProject() async {
    final controller = ref.read(currentProjectProvider.notifier);
    await controller.loadProject('demo-project');
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Projekt exportieren'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.code),
              title: const Text('Als JSON'),
              onTap: () => _exportProject('json'),
            ),
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('Als Markdown'),
              onTap: () => _exportProject('markdown'),
            ),
            ListTile(
              leading: const Icon(Icons.account_balance),
              title: const Text('Für Förderantrag'),
              onTap: () => _exportProject('funding'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Abbrechen'),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Einstellungen'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Einstellungen werden hier implementiert...'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Schließen'),
          ),
        ],
      ),
    );
  }

  void _handlePrototypeAction(String action, domain.Prototype prototype) {
    switch (action) {
      case 'edit':
        // TODO: Implement edit prototype
        break;
      case 'test':
        // TODO: Implement test prototype
        break;
      case 'export':
        // TODO: Implement export prototype
        break;
    }
  }

  void _showPrototypeDetails(domain.Prototype prototype) {
    // TODO: Implement prototype details view
  }

  void _showPlaytestDetails(domain.PlaytestResult playtest) {
    // TODO: Implement playtest details view
  }

  void _handleInsightAction(domain.AIInsight insight, String action) {
    // TODO: Implement insight action handling
  }

  void _handleInsightMenu(String action, domain.AIInsight insight) {
    // TODO: Implement insight menu handling
  }

  Future<void> _stopWorkflow(String workflowId) async {
    // TODO: Implement workflow stopping
  }

  Future<void> _exportProject(String format) async {
    final projectAsync = ref.read(currentProjectProvider);
    final project = projectAsync.value;
    
    if (project == null) return;

    String filename;
    
    switch (format) {
      case 'json':
        filename = '${project.name}_export.json';
        break;
      case 'markdown':
        filename = '${project.name}_export.md';
        break;
      case 'funding':
        filename = '${project.name}_funding.md';
        break;
      default:
        return;
    }

    // TODO: Implement file download/save
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Export abgeschlossen: $filename')),
    );
  }

  Widget _buildNoProjectView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Kein Projekt geladen',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Lade ein Projekt oder erstelle ein neues',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _refreshProject(),
            child: const Text('Projekt laden'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error,
            size: 64,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Fehler beim Laden des Projekts',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _refreshProject(),
            child: const Text('Erneut versuchen'),
          ),
        ],
      ),
    );
  }
} 