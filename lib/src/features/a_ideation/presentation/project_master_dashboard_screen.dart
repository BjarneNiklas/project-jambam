import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/multi_agent_providers.dart';
import '../data/external_integration_service.dart';
import '../domain/multi_agent_system.dart';
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
  final ExternalIntegrationService _integrationService = ExternalIntegrationService();
  
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
    final projectAsync = ref.watch(currentProjectProvider);
    final workflows = ref.watch(activeWorkflowsProvider);
    final agentStatuses = ref.watch(agentStatusesProvider);
    final aiService = ref.watch(enhancedAIServiceProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Master Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: aiService.getUserInsights(),
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
                _buildHeader(context),
                const SizedBox(height: 24),
                _buildProjectOverview(context),
                const SizedBox(height: 24),
                _buildAgentStatus(context),
                const SizedBox(height: 24),
                _buildAnalytics(context, aiInsights),
                const SizedBox(height: 24),
                _buildRecentActivity(context),
              ],
            ),
          );
        },
      ),
    );
  }

  // ============================================================================
  // TAB VIEWS
  // ============================================================================

  Widget _buildOverviewTab(
    ProjectMasterAgent project,
    List<WorkflowStatus> workflows,
    Map<String, AgentStatus> agentStatuses,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Project Header
          _buildProjectHeader(project),
          const SizedBox(height: 24),

          // Quick Stats
          _buildQuickStats(project),
          const SizedBox(height: 24),

          // Active Workflows
          if (workflows.isNotEmpty) ...[
            _buildActiveWorkflows(workflows),
            const SizedBox(height: 24),
          ],

          // Team Overview
          _buildTeamOverview(project),
          const SizedBox(height: 24),

          // Recent Activity
          _buildRecentActivity(project),
        ],
      ),
    );
  }

  Widget _buildPrototypesTab(ProjectMasterAgent project) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: project.prototypes.length,
      itemBuilder: (context, index) {
        final prototype = project.prototypes[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getPrototypeColor(prototype.status),
              child: Icon(
                _getPrototypeIcon(prototype.status),
                color: Colors.white,
              ),
            ),
            title: Text(prototype.name),
            subtitle: Text(prototype.description),
            trailing: PopupMenuButton<String>(
              onSelected: (value) => _handlePrototypeAction(value, prototype),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 8),
                      Text('Bearbeiten'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'test',
                  child: Row(
                    children: [
                      Icon(Icons.play_arrow),
                      SizedBox(width: 8),
                      Text('Testen'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'export',
                  child: Row(
                    children: [
                      Icon(Icons.download),
                      SizedBox(width: 8),
                      Text('Exportieren'),
                    ],
                  ),
                ),
              ],
            ),
            onTap: () => _showPrototypeDetails(prototype),
          ),
        );
      },
    );
  }

  Widget _buildPlaytestsTab(ProjectMasterAgent project) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: project.playtests.length,
      itemBuilder: (context, index) {
        final playtest = project.playtests[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getPlaytestColor(playtest.rating),
              child: Text(
                playtest.rating.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text('Playtest ${index + 1}'),
            subtitle: Text(playtest.summary),
            trailing: Text(
              _formatDate(playtest.date),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            onTap: () => _showPlaytestDetails(playtest),
          ),
        );
      },
    );
  }

  Widget _buildAgentsTab(
    Map<String, AgentStatus> agentStatuses,
    List<WorkflowStatus> workflows,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Agent Status Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: agentStatuses.entries.map((entry) {
              return _buildAgentStatusCard(entry.key, entry.value);
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Workflow Controls
          if (workflows.isNotEmpty) _buildWorkflowControls(workflows),
        ],
      ),
    );
  }

  Widget _buildInsightsTab(List<AIInsight> insights) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: insights.length,
      itemBuilder: (context, index) {
        final insight = insights[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getInsightColor(insight.type),
              child: Icon(
                _getInsightIcon(insight.type),
                color: Colors.white,
              ),
            ),
            title: Text(insight.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(insight.description),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: insight.suggestedActions.map((action) {
                    return ActionChip(
                      label: Text(action),
                      onPressed: () => _handleInsightAction(insight, action),
                    );
                  }).toList(),
                ),
              ],
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) => _handleInsightMenu(value, insight),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'resolve',
                  child: Row(
                    children: [
                      Icon(Icons.check),
                      SizedBox(width: 8),
                      Text('Als erledigt markieren'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'dismiss',
                  child: Row(
                    children: [
                      Icon(Icons.close),
                      SizedBox(width: 8),
                      Text('Verwerfen'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================================
  // WIDGET BUILDERS
  // ============================================================================

  Widget _buildProjectHeader(ProjectMasterAgent project) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    project.name.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        project.description,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildStatusChip(project.status),
                          const SizedBox(width: 8),
                          Text(
                            'Erstellt: ${_formatDate(project.createdAt)}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(ProjectMasterAgent project) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Prototypen',
            project.prototypes.length.toString(),
            Icons.science,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Playtests',
            project.playtests.length.toString(),
            Icons.games,
            Colors.green,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Team',
            project.team.length.toString(),
            Icons.people,
            Colors.orange,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Entscheidungen',
            project.decisions.length.toString(),
            Icons.gavel,
            Colors.purple,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveWorkflows(List<WorkflowStatus> workflows) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Aktive Workflows',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...workflows.map((workflow) => _buildWorkflowItem(workflow)),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkflowItem(WorkflowStatus workflow) {
    return ListTile(
      leading: CircularProgressIndicator(
        value: workflow.progress / 100,
        backgroundColor: Colors.grey[300],
      ),
      title: Text('Workflow #${workflow.workflowId}'),
      subtitle: Text(workflow.currentStep),
      trailing: Text('${workflow.progress.toStringAsFixed(1)}%'),
    );
  }

  Widget _buildTeamOverview(ProjectMasterAgent project) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Team',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...project.team.map((member) => ListTile(
              leading: CircleAvatar(
                child: Text(member.name.substring(0, 1)),
              ),
              title: Text(member.name),
              subtitle: Text(member.role),
              trailing: Text(member.expertise),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity(ProjectMasterAgent project) {
    final activities = <Map<String, dynamic>>[];

    // Add recent prototypes
    for (final prototype in project.prototypes.take(3)) {
      activities.add({
        'type': 'prototype',
        'title': 'Prototyp erstellt: ${prototype.name}',
        'date': prototype.createdAt,
        'icon': Icons.science,
        'color': Colors.blue,
      });
    }

    // Add recent playtests
    for (final playtest in project.playtests.take(3)) {
      activities.add({
        'type': 'playtest',
        'title': 'Playtest durchgeführt',
        'date': playtest.date,
        'icon': Icons.games,
        'color': Colors.green,
      });
    }

    // Sort by date
    activities.sort((a, b) => b['date'].compareTo(a['date']));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Letzte Aktivitäten',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...activities.take(5).map((activity) => ListTile(
              leading: CircleAvatar(
                backgroundColor: activity['color'],
                child: Icon(activity['icon'], color: Colors.white),
              ),
              title: Text(activity['title']),
              subtitle: Text(_formatDate(activity['date'])),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildAgentStatusCard(String agentId, AgentStatus status) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              _getAgentIcon(agentId),
              size: 32,
              color: _getAgentStatusColor(status),
            ),
            const SizedBox(height: 8),
            Text(
              _getAgentDisplayName(agentId),
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            _buildStatusChip(status.name),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkflowControls(List<WorkflowStatus> workflows) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Workflow Steuerung',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...workflows.map((workflow) => ListTile(
              title: Text('Workflow #${workflow.workflowId}'),
              subtitle: Text(workflow.currentStep),
              trailing: IconButton(
                icon: const Icon(Icons.stop),
                onPressed: () => _stopWorkflow(workflow.workflowId),
                tooltip: 'Workflow stoppen',
              ),
            )),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  Widget _buildStatusChip(dynamic status) {
    final statusText = status.toString().split('.').last;
    Color color;
    
    switch (statusText.toLowerCase()) {
      case 'active':
      case 'running':
        color = Colors.green;
        break;
      case 'idle':
        color = Colors.grey;
        break;
      case 'error':
        color = Colors.red;
        break;
      case 'completed':
        color = Colors.blue;
        break;
      default:
        color = Colors.orange;
    }

    return Chip(
      label: Text(
        statusText,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
    );
  }

  Color _getPrototypeColor(PrototypeStatus status) {
    switch (status) {
      case PrototypeStatus.inProgress:
        return Colors.orange;
      case PrototypeStatus.completed:
        return Colors.green;
      case PrototypeStatus.failed:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getPrototypeIcon(PrototypeStatus status) {
    switch (status) {
      case PrototypeStatus.inProgress:
        return Icons.build;
      case PrototypeStatus.completed:
        return Icons.check;
      case PrototypeStatus.failed:
        return Icons.error;
      default:
        return Icons.brush;
    }
  }

  Color _getPlaytestColor(int rating) {
    if (rating >= 8) return Colors.green;
    if (rating >= 6) return Colors.orange;
    return Colors.red;
  }

  Color _getInsightColor(AIInsightType type) {
    switch (type) {
      case AIInsightType.info:
        return Colors.blue;
      case AIInsightType.suggestion:
        return Colors.green;
      case AIInsightType.warning:
        return Colors.orange;
      case AIInsightType.error:
        return Colors.red;
    }
  }

  IconData _getInsightIcon(AIInsightType type) {
    switch (type) {
      case AIInsightType.info:
        return Icons.info;
      case AIInsightType.suggestion:
        return Icons.lightbulb;
      case AIInsightType.warning:
        return Icons.warning;
      case AIInsightType.error:
        return Icons.error;
    }
  }

  Color _getAgentStatusColor(AgentStatus status) {
    switch (status) {
      case AgentStatus.active:
        return Colors.green;
      case AgentStatus.idle:
        return Colors.grey;
      case AgentStatus.error:
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  IconData _getAgentIcon(String agentId) {
    switch (agentId) {
      case 'research':
        return Icons.search;
      case 'creative_director':
        return Icons.brush;
      case 'asset_generation':
        return Icons.view_in_ar;
      case 'game_engine':
        return Icons.code;
      case 'project_master':
        return Icons.dashboard;
      default:
        return Icons.smart_toy;
    }
  }

  String _getAgentDisplayName(String agentId) {
    switch (agentId) {
      case 'research':
        return 'Research Agent';
      case 'creative_director':
        return 'Creative Director';
      case 'asset_generation':
        return 'Asset Generation';
      case 'game_engine':
        return 'Game Engine';
      case 'project_master':
        return 'Project Master';
      default:
        return agentId;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
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

  void _handlePrototypeAction(String action, Prototype prototype) {
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

  void _showPrototypeDetails(Prototype prototype) {
    // TODO: Implement prototype details view
  }

  void _showPlaytestDetails(PlaytestResult playtest) {
    // TODO: Implement playtest details view
  }

  void _handleInsightAction(AIInsight insight, String action) {
    // TODO: Implement insight action handling
  }

  void _handleInsightMenu(String action, AIInsight insight) {
    final controller = ref.read(userInsightsProvider.notifier);
    switch (action) {
      case 'resolve':
        controller.markInsightResolved(insight.id);
        break;
      case 'dismiss':
        controller.removeInsight(insight.id);
        break;
    }
  }

  Future<void> _stopWorkflow(String workflowId) async {
    final controller = ref.read(activeWorkflowsProvider.notifier);
    await controller.stopWorkflow(workflowId);
  }

  Future<void> _exportProject(String format) async {
    final projectAsync = ref.read(currentProjectProvider);
    final project = projectAsync.value;
    
    if (project == null) return;

    String content;
    String filename;
    
    switch (format) {
      case 'json':
        content = await _integrationService.exportProjectAsJson(project.toJson());
        filename = '${project.name}_export.json';
        break;
      case 'markdown':
        content = await _integrationService.exportProjectAsMarkdown(project.toJson());
        filename = '${project.name}_export.md';
        break;
      case 'funding':
        content = await _integrationService.exportForFunding(project.toJson());
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