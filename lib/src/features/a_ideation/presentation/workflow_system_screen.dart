import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_jambam/src/core/logger.dart'; // Added Logger import

class WorkflowSystemScreen extends ConsumerStatefulWidget {
  const WorkflowSystemScreen({super.key});

  @override
  ConsumerState<WorkflowSystemScreen> createState() => _WorkflowSystemScreenState();
}

class _WorkflowSystemScreenState extends ConsumerState<WorkflowSystemScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final _logger = Logger('WorkflowSystemScreen'); // Logger instance

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Modern workflow actions management system
  Widget _buildWorkflowActionsPanel() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Workflow Actions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _showAddActionDialog,
                  tooltip: 'Add New Action',
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildWorkflowActionsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkflowActionsList() {
    return Column(
      children: [
        for (int i = 0; i < _workflowActions.length; i++)
          _buildWorkflowActionItem(_workflowActions[i], i),
      ],
    );
  }

  Widget _buildWorkflowActionItem(_WorkflowAction action, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getActionTypeColor(action.type),
          child: Icon(
            _getActionTypeIcon(action.type),
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          action.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(action.description),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getActionTypeColor(action.type).withAlpha(25),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    action.type.name.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      color: _getActionTypeColor(action.type),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.schedule,
                  size: 12,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  '${action.estimatedDuration}min',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: () => _showEditActionDialog(action, index),
              tooltip: 'Edit Action',
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 20),
              onPressed: () => _showDeleteActionDialog(index),
              tooltip: 'Delete Action',
            ),
            ReorderableDragStartListener(
              index: index,
              child: const Icon(Icons.drag_handle, size: 20),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddActionDialog() {
    showDialog(
      context: context,
      builder: (context) => _WorkflowActionDialog(
        onSave: (action) {
          setState(() {
            _workflowActions.add(action);
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showEditActionDialog(_WorkflowAction action, int index) {
    showDialog(
      context: context,
      builder: (context) => _WorkflowActionDialog(
        action: action,
        onSave: (updatedAction) {
          setState(() {
            _workflowActions[index] = updatedAction;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showDeleteActionDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Action'),
        content: Text('Are you sure you want to delete "${_workflowActions[index].name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _workflowActions.removeAt(index);
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Color _getActionTypeColor(ActionType type) {
    switch (type) {
      case ActionType.development:
        return Colors.blue;
      case ActionType.design:
        return Colors.purple;
      case ActionType.testing:
        return Colors.orange;
      case ActionType.deployment:
        return Colors.green;
      case ActionType.documentation:
        return Colors.teal;
    }
  }

  IconData _getActionTypeIcon(ActionType type) {
    switch (type) {
      case ActionType.development:
        return Icons.code;
      case ActionType.design:
        return Icons.design_services;
      case ActionType.testing:
        return Icons.bug_report;
      case ActionType.deployment:
        return Icons.rocket_launch;
      case ActionType.documentation:
        return Icons.description;
    }
  }

  // Workflow action data model
  final List<_WorkflowAction> _workflowActions = [
    _WorkflowAction(
      name: 'Code Review',
      description: 'Review pull requests and provide feedback',
      type: ActionType.development,
      estimatedDuration: 30,
      assignee: 'Team Lead',
      priority: 'High',
    ),
    _WorkflowAction(
      name: 'UI Design Review',
      description: 'Review and approve UI/UX designs',
      type: ActionType.design,
      estimatedDuration: 45,
      assignee: 'Design Lead',
      priority: 'Medium',
    ),
    _WorkflowAction(
      name: 'Integration Testing',
      description: 'Run integration tests for new features',
      type: ActionType.testing,
      estimatedDuration: 60,
      assignee: 'QA Engineer',
      priority: 'High',
    ),
    _WorkflowAction(
      name: 'Deploy to Staging',
      description: 'Deploy latest changes to staging environment',
      type: ActionType.deployment,
      estimatedDuration: 20,
      assignee: 'DevOps Engineer',
      priority: 'Medium',
    ),
    _WorkflowAction(
      name: 'Update Documentation',
      description: 'Update API and user documentation',
      type: ActionType.documentation,
      estimatedDuration: 40,
      assignee: 'Technical Writer',
      priority: 'Low',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workflow System'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _createNewWorkflow,
          ),
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: _navigateToWorkflowAnalytics,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'WORKFLOWS'),
            Tab(text: 'TASKS'),
            Tab(text: 'AUTOMATION'),
            Tab(text: 'ANALYTICS'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildWorkflowsTab(),
          _buildTasksTab(),
          _buildAutomationTab(),
          _buildAnalyticsTab(),
        ],
      ),
    );
  }

  Widget _buildWorkflowsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWorkflowsHeader(),
          const SizedBox(height: 16),
          _buildWorkflowActionsPanel(),
          const SizedBox(height: 16),
          _buildActiveWorkflowsCard(),
          const SizedBox(height: 16),
          _buildWorkflowTemplatesCard(),
          const SizedBox(height: 16),
          _buildWorkflowMetricsCard(),
        ],
      ),
    );
  }

  Widget _buildWorkflowsHeader() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.deepPurple[400]!, Colors.purple[600]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.work, color: Colors.indigo, size: 24),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Workflow System',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Streamline your development processes',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWorkflowStat('Active', '6', Colors.white),
                _buildWorkflowStat('Completed', '24', Colors.white),
                _buildWorkflowStat('Efficiency', '92%', Colors.white),
                _buildWorkflowStat('Team Members', '15', Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkflowStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: color.withAlpha(51),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildActiveWorkflowsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.play_circle, color: Colors.deepPurple),
                const SizedBox(width: 8),
                const Text(
                  'Active Workflows',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withAlpha((255 * 0.1).round()),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '6 running',
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildWorkflowItem(
              'Game Development Pipeline',
              'Complete game development workflow',
              'Development',
              Colors.blue,
              '75%',
              '12 tasks',
            ),
            _buildWorkflowItem(
              'AI Integration Process',
              'AI feature integration workflow',
              'Testing',
              Colors.green,
              '90%',
              '8 tasks',
            ),
            _buildWorkflowItem(
              'Asset Production Pipeline',
              '3D asset creation workflow',
              'Review',
              Colors.orange,
              '60%',
              '15 tasks',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkflowItem(String name, String description, String status, Color color, String progress, String tasks) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withAlpha((255 * 0.1).round()),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha((255 * 0.3).round())),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withAlpha((255 * 0.2).round()),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Progress',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      progress,
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tasks',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      tasks,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: int.parse(progress.replaceAll('%', '')) / 100,
            backgroundColor: Colors.grey.withAlpha((255 * 0.3).round()),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _viewWorkflow(name),
                  child: const Text('View'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _manageWorkflow(name),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Manage'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWorkflowTemplatesCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Workflow Templates',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTemplateCard(
                    'Agile Development',
                    'Sprint-based development',
                    Icons.timer,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTemplateCard(
                    'Waterfall',
                    'Sequential development',
                    Icons.waterfall_chart,
                    Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTemplateCard(
                    'Kanban',
                    'Visual task management',
                    Icons.view_column,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTemplateCard(
                    'Scrum',
                    'Iterative development',
                    Icons.groups,
                    Colors.purple,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemplateCard(String name, String description, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withAlpha((255 * 0.1).round()),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha((255 * 0.3).round())),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            description,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => _useWorkflowTemplate(name),
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text('Use'),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkflowMetricsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Workflow Metrics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem('Cycle Time', '5.2 days', Colors.blue),
                ),
                Expanded(
                  child: _buildMetricItem('Lead Time', '8.1 days', Colors.green),
                ),
                Expanded(
                  child: _buildMetricItem('Throughput', '12/week', Colors.orange),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem('Efficiency', '92%', Colors.purple),
                ),
                Expanded(
                  child: _buildMetricItem('Quality', '96%', Colors.teal),
                ),
                Expanded(
                  child: _buildMetricItem('Satisfaction', '4.8/5', Colors.indigo),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTasksTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildTasksHeader(),
        const SizedBox(height: 16),
        _buildTaskBoardCard(),
        const SizedBox(height: 16),
        _buildTaskFiltersCard(),
        const SizedBox(height: 16),
        _buildTaskAnalyticsCard(),
      ],
    );
  }

  Widget _buildTasksHeader() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.task, color: Colors.deepPurple, size: 24),
            const SizedBox(width: 12),
            const Text(
              'Task Management',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withAlpha((255 * 0.1).round()),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '35 tasks',
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskBoardCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Task Board',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTaskColumn('To Do', 8, Colors.grey),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildTaskColumn('In Progress', 12, Colors.blue),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildTaskColumn('Review', 6, Colors.orange),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildTaskColumn('Done', 9, Colors.green),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskColumn(String title, int count, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withAlpha((255 * 0.1).round()),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha((255 * 0.3).round())),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withAlpha(51),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$count tasks',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskFiltersCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Task Filters',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: 'All Tasks',
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'All Tasks', child: Text('All Tasks')),
                      DropdownMenuItem(value: 'To Do', child: Text('To Do')),
                      DropdownMenuItem(value: 'In Progress', child: Text('In Progress')),
                      DropdownMenuItem(value: 'Review', child: Text('Review')),
                      DropdownMenuItem(value: 'Done', child: Text('Done')),
                    ],
                    onChanged: _filterTasksByStatus,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: 'All Members',
                    decoration: const InputDecoration(
                      labelText: 'Assignee',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'All Members', child: Text('All Members')),
                      DropdownMenuItem(value: 'John D.', child: Text('John D.')),
                      DropdownMenuItem(value: 'Sarah M.', child: Text('Sarah M.')),
                      DropdownMenuItem(value: 'Mike R.', child: Text('Mike R.')),
                    ],
                    onChanged: _filterTasksByAssignee,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskAnalyticsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Task Analytics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTaskMetric('Completed', '9', Colors.green),
                ),
                Expanded(
                  child: _buildTaskMetric('In Progress', '12', Colors.blue),
                ),
                Expanded(
                  child: _buildTaskMetric('Overdue', '2', Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTaskMetric('Avg Duration', '3.2 days', Colors.orange),
                ),
                Expanded(
                  child: _buildTaskMetric('Completion Rate', '87%', Colors.purple),
                ),
                Expanded(
                  child: _buildTaskMetric('Team Velocity', '15/week', Colors.teal),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskMetric(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAutomationTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildAutomationHeader(),
        const SizedBox(height: 16),
        _buildAutomationRulesCard(),
        const SizedBox(height: 16),
        _buildAutomationTriggersCard(),
        const SizedBox(height: 16),
        _buildAutomationHistoryCard(),
      ],
    );
  }

  Widget _buildAutomationHeader() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.auto_awesome, color: Colors.deepPurple, size: 24),
            const SizedBox(width: 12),
            const Text(
              'Process Automation',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withAlpha((255 * 0.1).round()),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '8 automations',
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAutomationRulesCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Automation Rules',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildAutomationRule('Task Assignment', 'Auto-assign tasks based on skills', true, Colors.green),
            _buildAutomationRule('Status Updates', 'Auto-update task status', true, Colors.blue),
            _buildAutomationRule('Notifications', 'Send notifications on events', true, Colors.orange),
            _buildAutomationRule('Code Review', 'Auto-request code review', false, Colors.purple),
            _buildAutomationRule('Deployment', 'Auto-deploy on merge', false, Colors.teal),
          ],
        ),
      ),
    );
  }

  Widget _buildAutomationRule(String name, String description, bool enabled, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: enabled ? color.withAlpha((255 * 0.1).round()) : Colors.grey.withAlpha((255 * 0.05).round()),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: enabled ? color : Colors.grey.withAlpha((255 * 0.3).round()),
        ),
      ),
      child: Row(
        children: [
          Icon(
            enabled ? Icons.check_circle : Icons.cancel,
            color: enabled ? color : Colors.grey,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: enabled,
            onChanged: (value) => _toggleAutomationRule(name, value),
            activeThumbColor: color,
          ),
        ],
      ),
    );
  }

  Widget _buildAutomationTriggersCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Automation Triggers',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildTriggerItem('Task Created', 'When a new task is created', true, Colors.blue),
            _buildTriggerItem('Status Changed', 'When task status changes', true, Colors.green),
            _buildTriggerItem('Deadline Approaching', 'When deadline is near', true, Colors.orange),
            _buildTriggerItem('Code Committed', 'When code is committed', false, Colors.purple),
            _buildTriggerItem('Build Completed', 'When build finishes', false, Colors.teal),
          ],
        ),
      ),
    );
  }

  Widget _buildTriggerItem(String trigger, String description, bool enabled, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: enabled ? color.withAlpha((255 * 0.1).round()) : Colors.grey.withAlpha((255 * 0.05).round()),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: enabled ? color : Colors.grey.withAlpha((255 * 0.3).round()),
        ),
      ),
      child: Row(
        children: [
          Icon(
            enabled ? Icons.flash_on : Icons.flash_off,
            color: enabled ? color : Colors.grey,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trigger,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: enabled,
            onChanged: (value) => _toggleAutomationTrigger(trigger, value),
            activeThumbColor: color,
          ),
        ],
      ),
    );
  }

  Widget _buildAutomationHistoryCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Automation History',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildHistoryItem('Task assigned to John D.', '2 minutes ago', Colors.green),
            _buildHistoryItem('Status updated to In Progress', '5 minutes ago', Colors.blue),
            _buildHistoryItem('Notification sent to team', '10 minutes ago', Colors.orange),
            _buildHistoryItem('Code review requested', '1 hour ago', Colors.purple),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(String action, String time, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  action,
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildAnalyticsHeader(),
        const SizedBox(height: 16),
        _buildPerformanceMetricsCard(),
        const SizedBox(height: 16),
        _buildTeamAnalyticsCard(),
        const SizedBox(height: 16),
        _buildTrendsCard(),
      ],
    );
  }

  Widget _buildAnalyticsHeader() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.analytics, color: Colors.deepPurple, size: 24),
            const SizedBox(width: 12),
            const Text(
              'Advanced Analytics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withAlpha((255 * 0.1).round()),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Real-time',
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceMetricsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Performance Metrics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildAnalyticsMetric('Velocity', '15/week', '+12%', Colors.green),
                ),
                Expanded(
                  child: _buildAnalyticsMetric('Quality', '96%', '+3%', Colors.blue),
                ),
                Expanded(
                  child: _buildAnalyticsMetric('Efficiency', '92%', '+5%', Colors.orange),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildAnalyticsMetric('Satisfaction', '4.8/5', '+0.2', Colors.purple),
                ),
                Expanded(
                  child: _buildAnalyticsMetric('Innovation', '87%', '+8%', Colors.teal),
                ),
                Expanded(
                  child: _buildAnalyticsMetric('ROI', '320%', '+15%', Colors.indigo),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsMetric(String label, String value, String change, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
              color: color.withAlpha((255 * 0.1).round()),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            change,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTeamAnalyticsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Team Analytics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildTeamMemberAnalytics('John D.', '15 tasks', '92%', Colors.blue),
            _buildTeamMemberAnalytics('Sarah M.', '12 tasks', '88%', Colors.green),
            _buildTeamMemberAnalytics('Mike R.', '18 tasks', '95%', Colors.orange),
            _buildTeamMemberAnalytics('Lisa K.', '10 tasks', '85%', Colors.purple),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamMemberAnalytics(String name, String tasks, String completion, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withAlpha((255 * 0.1).round()),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha((255 * 0.3).round())),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: color,
            child: Text(
              name.split(' ').map((e) => e[0]).join(''),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  tasks,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            completion,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Trends & Insights',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildTrendItem('Productivity increased by 15%', 'Positive trend', Colors.green),
            _buildTrendItem('Quality metrics improving', 'Steady growth', Colors.blue),
            _buildTrendItem('Team collaboration enhanced', 'Strong performance', Colors.orange),
            _buildTrendItem('Innovation rate up 8%', 'Excellent progress', Colors.purple),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendItem(String trend, String status, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withAlpha((255 * 0.1).round()),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha((255 * 0.3).round())),
      ),
      child: Row(
        children: [
          Icon(
            Icons.trending_up,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trend,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  status,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Placeholder methods for existing functionality
  void _createNewWorkflow() {
    _logger.info('Create new workflow tapped. Navigate to CreateWorkflowScreen or show dialog.');
    // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => CreateWorkflowScreen()));
  }

  void _navigateToWorkflowAnalytics() {
    _logger.info('Workflow analytics tapped. Navigate to WorkflowAnalyticsScreen or switch to Analytics tab.');
    // Example: _tabController.animateTo(3); // Assuming Analytics is the 4th tab (index 3)
  }

  void _viewWorkflow(String workflowName) {
    _logger.info('View workflow tapped for "$workflowName". Navigate to WorkflowDetailScreen.');
    // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => WorkflowDetailScreen(workflowName: workflowName)));
  }

  void _manageWorkflow(String workflowName) {
    _logger.info('Manage workflow tapped for "$workflowName". Navigate to ManageWorkflowScreen.');
    // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => ManageWorkflowScreen(workflowName: workflowName)));
  }

  void _useWorkflowTemplate(String templateName) {
    _logger.info('Use template tapped for "$templateName". Create a new workflow using this template.');
    // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => CreateWorkflowScreen(template: templateName)));
  }

  void _filterTasksByStatus(String? status) {
    _logger.info('Filter tasks by status: $status');
    // Add actual filtering logic here
  }

  void _filterTasksByAssignee(String? assignee) {
    _logger.info('Filter tasks by assignee: $assignee');
    // Add actual filtering logic here
  }

  void _toggleAutomationRule(String ruleName, bool newValue) {
    _logger.info('Toggle automation rule "$ruleName" to $newValue.');
    // Add logic to update automation rule state
  }

  void _toggleAutomationTrigger(String triggerName, bool newValue) {
    _logger.info('Toggle automation trigger "$triggerName" to $newValue.');
    // Add logic to update automation trigger state
  }
}

// Workflow action data class
class _WorkflowAction {
  final String name;
  final String description;
  final ActionType type;
  final int estimatedDuration;
  final String assignee;
  final String priority;

  _WorkflowAction({
    required this.name,
    required this.description,
    required this.type,
    required this.estimatedDuration,
    required this.assignee,
    required this.priority,
  });
}

enum ActionType {
  development,
  design,
  testing,
  deployment,
  documentation,
}

// Workflow action dialog widget
class _WorkflowActionDialog extends StatefulWidget {
  final _WorkflowAction? action;
  final Function(_WorkflowAction) onSave;

  const _WorkflowActionDialog({
    this.action,
    required this.onSave,
  });

  @override
  State<_WorkflowActionDialog> createState() => _WorkflowActionDialogState();
}

class _WorkflowActionDialogState extends State<_WorkflowActionDialog> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _assigneeController;
  late TextEditingController _durationController;
  late ActionType _selectedType;
  late String _selectedPriority;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.action?.name ?? '');
    _descriptionController = TextEditingController(text: widget.action?.description ?? '');
    _assigneeController = TextEditingController(text: widget.action?.assignee ?? '');
    _durationController = TextEditingController(text: widget.action?.estimatedDuration.toString() ?? '');
    _selectedType = widget.action?.type ?? ActionType.development;
    _selectedPriority = widget.action?.priority ?? 'Medium';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _assigneeController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.action == null ? 'Add Action' : 'Edit Action'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Action Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<ActionType>(
              value: _selectedType,
              decoration: const InputDecoration(
                labelText: 'Action Type',
                border: OutlineInputBorder(),
              ),
              items: ActionType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.name.toUpperCase()),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _assigneeController,
              decoration: const InputDecoration(
                labelText: 'Assignee',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _durationController,
              decoration: const InputDecoration(
                labelText: 'Estimated Duration (minutes)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedPriority,
              decoration: const InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(),
              ),
              items: ['Low', 'Medium', 'High'].map((priority) {
                return DropdownMenuItem(
                  value: priority,
                  child: Text(priority),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPriority = value!;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveAction,
          child: Text(widget.action == null ? 'Add' : 'Save'),
        ),
      ],
    );
  }

  void _saveAction() {
    if (_nameController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    final action = _WorkflowAction(
      name: _nameController.text,
      description: _descriptionController.text,
      type: _selectedType,
      estimatedDuration: int.tryParse(_durationController.text) ?? 30,
      assignee: _assigneeController.text,
      priority: _selectedPriority,
    );

    widget.onSave(action);
  }
} 