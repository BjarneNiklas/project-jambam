import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/multi_agent_system.dart' as domain;
import '../data/agent_orchestrator_service.dart';
import '../data/project_master_agent_service.dart';
import '../data/workflow_types.dart';

/// Modernes Agenten-Dashboard für Multi-Agenten-Interaktion
class AgentDashboardScreen extends ConsumerStatefulWidget {
  const AgentDashboardScreen({super.key});

  @override
  ConsumerState<AgentDashboardScreen> createState() => _AgentDashboardScreenState();
}

class _AgentDashboardScreenState extends ConsumerState<AgentDashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _slideController;
  
  final AgentOrchestratorService _orchestrator = AgentOrchestratorService();
  final ProjectMasterAgentService _projectMaster = ProjectMasterAgentService();
  
  String? _currentWorkflowId;
  WorkflowStatus? _workflowStatus;
  domain.ProjectMasterAgent? _currentProject;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _loadCurrentProject();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentProject() async {
    final project = await _projectMaster.loadProject('demo-project');
    setState(() {
      _currentProject = project;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('🤖 Agenten-Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showAgentSettings(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProjectOverview(),
            const SizedBox(height: 24),
            _buildAgentGrid(),
            const SizedBox(height: 24),
            _buildWorkflowSection(),
            const SizedBox(height: 24),
            _buildRecentActivity(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showWorkflowDialog(context),
        icon: const Icon(Icons.play_arrow),
        label: const Text('Workflow starten'),
      ),
    );
  }

  Widget _buildProjectOverview() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: const Icon(Icons.games, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currentProject?.name ?? 'Lade Projekt...',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        'Status: ${_currentProject?.status.name ?? 'Unbekannt'}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(_currentProject?.status ?? domain.ProjectStatus.planning),
              ],
            ),
            const SizedBox(height: 16),
            _buildProjectStats(),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem('Prototypen', '${_currentProject?.prototypes.length ?? 0}'),
        _buildStatItem('Playtests', '${_currentProject?.playtests.length ?? 0}'),
        _buildStatItem('Team', '${_currentProject?.team.length ?? 0}'),
        _buildStatItem('Assets', '${_currentProject?.assets.length ?? 0}'),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildAgentGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '🤖 Verfügbare Agenten',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
          children: [
            _buildAgentCard(
              'Research Agent',
              'Wissenschaftliche Forschung',
              Icons.science,
              Colors.blue,
              domain.AgentStatus.active,
              () => _showAgentDetails(context, 'research'),
            ),
            _buildAgentCard(
              'Creative Director',
              'Game Design & Storytelling',
              Icons.brush,
              Colors.purple,
              domain.AgentStatus.active,
              () => _showAgentDetails(context, 'creative'),
            ),
            _buildAgentCard(
              'Asset Generation',
              '3D Assets & Media',
              Icons.photo_library,
              Colors.green,
              domain.AgentStatus.active,
              () => _showAgentDetails(context, 'assets'),
            ),
            _buildAgentCard(
              'Game Engine',
              'Engine Integration',
              Icons.games,
              Colors.orange,
              domain.AgentStatus.active,
              () => _showAgentDetails(context, 'engine'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAgentCard(
    String title,
    String description,
    IconData icon,
    Color color,
    domain.AgentStatus status,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    icon,
                    size: 32,
                    color: color,
                  ),
                  if (status == domain.AgentStatus.active)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green.withOpacity(0.3),
                                  blurRadius: 8 * _pulseController.value,
                                  spreadRadius: 2 * _pulseController.value,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              _buildStatusChip(status),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWorkflowSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '⚡ Aktive Workflows',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        if (_currentWorkflowId != null && _workflowStatus != null)
          _buildWorkflowCard()
        else
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(
                    Icons.play_circle_outline,
                    size: 48,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Kein aktiver Workflow',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Starte einen neuen Workflow, um zu beginnen',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildWorkflowCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.sync,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Workflow #${_currentWorkflowId}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _workflowStatus?.status ?? 'Unbekannt',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.stop),
                  onPressed: _stopWorkflow,
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: (_workflowStatus?.progress ?? 0) / 100,
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${_workflowStatus?.progress.toStringAsFixed(1)}% abgeschlossen',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '📊 Letzte Aktivitäten',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        Card(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: _getActivityColor(index),
                  child: Icon(_getActivityIcon(index), color: Colors.white),
                ),
                title: Text(_getActivityTitle(index)),
                subtitle: Text(_getActivityDescription(index)),
                trailing: Text(
                  'vor ${index + 1}h',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(dynamic status) {
    Color color;
    String text;
    
    if (status is domain.AgentStatus) {
      switch (status) {
        case domain.AgentStatus.active:
          color = Colors.green;
          text = 'Aktiv';
          break;
        case domain.AgentStatus.idle:
          color = Colors.orange;
          text = 'Bereit';
          break;
        case domain.AgentStatus.error:
          color = Colors.red;
          text = 'Fehler';
          break;
        default:
          color = Colors.grey;
          text = 'Unbekannt';
      }
    } else if (status is domain.ProjectStatus) {
      switch (status) {
        case domain.ProjectStatus.planning:
          color = Colors.blue;
          text = 'Planung';
          break;
        case domain.ProjectStatus.prototyping:
          color = Colors.orange;
          text = 'Prototyping';
          break;
        case domain.ProjectStatus.playtesting:
          color = Colors.purple;
          text = 'Playtesting';
          break;
        case domain.ProjectStatus.production:
          color = Colors.green;
          text = 'Produktion';
          break;
        case domain.ProjectStatus.released:
          color = Colors.green;
          text = 'Veröffentlicht';
          break;
        case domain.ProjectStatus.archived:
          color = Colors.grey;
          text = 'Archiviert';
          break;
        default:
          color = Colors.grey;
          text = 'Unbekannt';
      }
    } else {
      color = Colors.grey;
      text = 'Unbekannt';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // Helper methods for activity feed
  Color _getActivityColor(int index) {
    final colors = [Colors.blue, Colors.green, Colors.orange, Colors.purple, Colors.red];
    return colors[index % colors.length];
  }

  IconData _getActivityIcon(int index) {
    final icons = [Icons.science, Icons.brush, Icons.view_in_ar, Icons.code, Icons.check];
    return icons[index % icons.length];
  }

  String _getActivityTitle(int index) {
    final titles = [
      'Research abgeschlossen',
      'Design erstellt',
      'Assets generiert',
      'Code kompiliert',
      'Workflow beendet',
    ];
    return titles[index % titles.length];
  }

  String _getActivityDescription(int index) {
    final descriptions = [
      '15 wissenschaftliche Quellen gefunden',
      'Game Design Document erstellt',
      '3D-Modelle und Texturen generiert',
      'Bevy-Code erfolgreich kompiliert',
      'Alle Phasen erfolgreich abgeschlossen',
    ];
    return descriptions[index % descriptions.length];
  }

  // Action methods
  void _showAgentSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Agenten-Einstellungen'),
        content: const Text('Einstellungen für Agenten-Konfiguration'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Schließen'),
          ),
        ],
      ),
    );
  }

  void _showAgentDetails(BuildContext context, String agentType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$agentType Agent Details'),
        content: Text('Details für $agentType Agent'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Schließen'),
          ),
        ],
      ),
    );
  }

  void _showWorkflowDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Workflow starten'),
        content: const Text('Workflow-Konfiguration'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _startWorkflow();
            },
            child: const Text('Starten'),
          ),
        ],
      ),
    );
  }

  Future<void> _startWorkflow() async {
    // TODO: Implement workflow start
    setState(() {
      _currentWorkflowId = 'workflow_${DateTime.now().millisecondsSinceEpoch}';
      _workflowStatus = WorkflowStatus(
        workflowId: _currentWorkflowId!,
        type: WorkflowType.full,
        status: 'running',
        progress: 0.0,
        startTime: DateTime.now(),
        logs: ['Workflow started'],
        warnings: [],
        errors: [],
      );
    });
  }

  Future<void> _stopWorkflow() async {
    if (_currentWorkflowId != null) {
      await _orchestrator.stopWorkflow(_currentWorkflowId!);
      setState(() {
        _currentWorkflowId = null;
        _workflowStatus = null;
      });
    }
  }
}
