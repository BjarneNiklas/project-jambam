import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrototypeManagementScreen extends ConsumerStatefulWidget {
  const PrototypeManagementScreen({super.key});

  @override
  ConsumerState<PrototypeManagementScreen> createState() => _PrototypeManagementScreenState();
}

class _PrototypeManagementScreenState extends ConsumerState<PrototypeManagementScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prototype Management'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Create new prototype
            },
          ),
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: () {
              // TODO: Prototype analytics
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'PROTOTYPES'),
            Tab(text: 'VERSIONS'),
            Tab(text: 'COLLABORATION'),
            Tab(text: 'WORKFLOW'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPrototypesTab(),
          _buildVersionsTab(),
          _buildCollaborationTab(),
          _buildWorkflowTab(),
        ],
      ),
    );
  }

  Widget _buildPrototypesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPrototypesHeader(),
          const SizedBox(height: 16),
          _buildActivePrototypesCard(),
          const SizedBox(height: 16),
          _buildPrototypeCategoriesCard(),
          const SizedBox(height: 16),
          _buildPrototypeMetricsCard(),
        ],
      ),
    );
  }

  Widget _buildPrototypesHeader() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.indigo[400]!, Colors.purple[600]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.work, color: Colors.indigo, size: 32),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Prototype Management',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Manage and track your prototypes',
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
                _buildPrototypeStat('Active', '8', Colors.white),
                _buildPrototypeStat('Completed', '15', Colors.white),
                _buildPrototypeStat('Team Members', '12', Colors.white),
                _buildPrototypeStat('Success Rate', '87%', Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrototypeStat(String label, String value, Color color) {
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
            color: color.withAlpha((255 * 0.8).round()),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildActivePrototypesCard() {
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
                Icon(Icons.work, color: Colors.indigo),
                const SizedBox(width: 8),
                const Text(
                  'Active Prototypes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.indigo.withAlpha((255 * 0.1).round()),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '8 active',
                    style: TextStyle(
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildPrototypeItem(
              'AI Game Generator v2.1',
              'Advanced AI-powered game generation',
              'Development',
              Colors.blue,
              '75%',
              'John D.',
            ),
            _buildPrototypeItem(
              'Neural Style Transfer',
              'Real-time style transfer for games',
              'Testing',
              Colors.green,
              '90%',
              'Sarah M.',
            ),
            _buildPrototypeItem(
              'Procedural World Builder',
              'Infinite world generation system',
              'Review',
              Colors.orange,
              '60%',
              'Mike R.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrototypeItem(String name, String description, String status, Color color, String progress, String owner) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withAlpha(51),
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
                      'Owner',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      owner,
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
                  onPressed: () {
                    // TODO: View prototype
                  },
                  child: const Text('View'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Edit prototype
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Edit'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrototypeCategoriesCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Prototype Categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildCategoryCard(
                    'AI/ML',
                    '5 prototypes',
                    Icons.psychology,
                    Colors.purple,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildCategoryCard(
                    'Graphics',
                    '3 prototypes',
                    Icons.brush,
                    Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildCategoryCard(
                    'Audio',
                    '2 prototypes',
                    Icons.music_note,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildCategoryCard(
                    'Gameplay',
                    '4 prototypes',
                    Icons.sports_esports,
                    Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String category, String count, IconData icon, Color color) {
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
            category,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Text(
            count,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrototypeMetricsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Prototype Metrics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem('Success Rate', '87%', Colors.green),
                ),
                Expanded(
                  child: _buildMetricItem('Avg Duration', '3.2 weeks', Colors.blue),
                ),
                Expanded(
                  child: _buildMetricItem('Team Size', '4.5 members', Colors.orange),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem('Iterations', '5.8 avg', Colors.purple),
                ),
                Expanded(
                  child: _buildMetricItem('Feedback Score', '4.2/5', Colors.teal),
                ),
                Expanded(
                  child: _buildMetricItem('Cost Efficiency', '92%', Colors.indigo),
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

  Widget _buildVersionsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildVersionsHeader(),
        const SizedBox(height: 16),
        _buildVersionHistoryCard(),
        const SizedBox(height: 16),
        _buildVersionComparisonCard(),
        const SizedBox(height: 16),
        _buildVersionControlCard(),
      ],
    );
  }

  Widget _buildVersionsHeader() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.history, color: Colors.indigo, size: 24),
            const SizedBox(width: 12),
            const Text(
              'Version Control',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.indigo.withAlpha((255 * 0.1).round()),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Git integration',
                style: TextStyle(
                  color: Colors.indigo,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVersionHistoryCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Version History',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildVersionItem('v2.1.0', 'AI improvements', '2 hours ago', 'John D.', Colors.green),
            _buildVersionItem('v2.0.5', 'Bug fixes', '1 day ago', 'Sarah M.', Colors.blue),
            _buildVersionItem('v2.0.0', 'Major release', '1 week ago', 'Mike R.', Colors.purple),
            _buildVersionItem('v1.9.2', 'Performance optimization', '2 weeks ago', 'Lisa K.', Colors.orange),
            _buildVersionItem('v1.9.0', 'Feature update', '3 weeks ago', 'Tom B.', Colors.teal),
          ],
        ),
      ),
    );
  }

  Widget _buildVersionItem(String version, String description, String time, String author, Color color) {
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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withAlpha(51),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              version,
              style: TextStyle(
                color: color,
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
                  description,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '$time by $author',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // TODO: Download version
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVersionComparisonCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Version Comparison',
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
                    value: 'v2.1.0',
                    decoration: const InputDecoration(
                      labelText: 'From Version',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'v2.1.0', child: Text('v2.1.0')),
                      DropdownMenuItem(value: 'v2.0.5', child: Text('v2.0.5')),
                      DropdownMenuItem(value: 'v2.0.0', child: Text('v2.0.0')),
                    ],
                    onChanged: (value) {
                      // TODO: Update from version
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: 'v2.0.5',
                    decoration: const InputDecoration(
                      labelText: 'To Version',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'v2.1.0', child: Text('v2.1.0')),
                      DropdownMenuItem(value: 'v2.0.5', child: Text('v2.0.5')),
                      DropdownMenuItem(value: 'v2.0.0', child: Text('v2.0.0')),
                    ],
                    onChanged: (value) {
                      // TODO: Update to version
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: Compare versions
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
              ),
              child: const Text('Compare Versions'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVersionControlCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Version Control Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Auto Versioning'),
              subtitle: const Text('Automatically create versions'),
              value: true,
              onChanged: (value) {
                // TODO: Update setting
              },
              secondary: const Icon(Icons.auto_awesome),
            ),
            SwitchListTile(
              title: const Text('Branch Protection'),
              subtitle: const Text('Protect main branch'),
              value: true,
              onChanged: (value) {
                // TODO: Update setting
              },
              secondary: const Icon(Icons.security),
            ),
            SwitchListTile(
              title: const Text('Code Review'),
              subtitle: const Text('Require code review'),
              value: true,
              onChanged: (value) {
                // TODO: Update setting
              },
              secondary: const Icon(Icons.rate_review),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollaborationTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildCollaborationHeader(),
        const SizedBox(height: 16),
        _buildTeamMembersCard(),
        const SizedBox(height: 16),
        _buildCollaborationToolsCard(),
        const SizedBox(height: 16),
        _buildCommunicationCard(),
      ],
    );
  }

  Widget _buildCollaborationHeader() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.people, color: Colors.indigo, size: 24),
            const SizedBox(width: 12),
            const Text(
              'Team Collaboration',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.indigo.withAlpha((255 * 0.1).round()),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '12 members',
                style: TextStyle(
                  color: Colors.indigo,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamMembersCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Team Members',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildTeamMemberItem('John Developer', 'Lead Developer', 'Online', Colors.green),
            _buildTeamMemberItem('Sarah Manager', 'Project Manager', 'Online', Colors.green),
            _buildTeamMemberItem('Mike Designer', 'UI/UX Designer', 'Away', Colors.orange),
            _buildTeamMemberItem('Lisa Tester', 'QA Engineer', 'Offline', Colors.grey),
            _buildTeamMemberItem('Tom Artist', '3D Artist', 'Online', Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamMemberItem(String name, String role, String status, Color color) {
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
            radius: 20,
            backgroundColor: color,
            child: Text(
              name.split(' ').map((e) => e[0]).join(''),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
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
                  role,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color.withAlpha((255 * 0.2).round()),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollaborationToolsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Collaboration Tools',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildToolItem('Slack', 'Team communication', true, Colors.purple),
            _buildToolItem('Discord', 'Voice chat', true, Colors.indigo),
            _buildToolItem('Trello', 'Task management', true, Colors.blue),
            _buildToolItem('Figma', 'Design collaboration', false, Colors.orange),
            _buildToolItem('Zoom', 'Video meetings', true, Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildToolItem(String tool, String description, bool connected, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: connected ? color.withAlpha((255 * 0.1).round()) : Colors.grey.withAlpha((255 * 0.05).round()),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: connected ? color : Colors.grey.withAlpha((255 * 0.3).round()),
        ),
      ),
      child: Row(
        children: [
          Icon(
            connected ? Icons.check_circle : Icons.cancel,
            color: connected ? color : Colors.grey,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tool,
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
          if (connected)
            ElevatedButton(
              onPressed: () {
                // TODO: Open tool
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text('Open'),
            ),
        ],
      ),
    );
  }

  Widget _buildCommunicationCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Communication',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Start meeting
                    },
                    icon: const Icon(Icons.video_call),
                    label: const Text('Start Meeting'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Create channel
                    },
                    icon: const Icon(Icons.chat),
                    label: const Text('New Channel'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkflowTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildWorkflowHeader(),
        const SizedBox(height: 16),
        _buildWorkflowStagesCard(),
        const SizedBox(height: 16),
        _buildWorkflowAutomationCard(),
        const SizedBox(height: 16),
        _buildWorkflowAnalyticsCard(),
      ],
    );
  }

  Widget _buildWorkflowHeader() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.work, color: Colors.indigo, size: 24),
            const SizedBox(width: 12),
            const Text(
              'Workflow Management',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.indigo.withAlpha((255 * 0.1).round()),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Agile workflow',
                style: TextStyle(
                  color: Colors.indigo,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkflowStagesCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Workflow Stages',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildStageItem('Planning', 3, Colors.blue),
            _buildStageItem('Development', 5, Colors.green),
            _buildStageItem('Testing', 2, Colors.orange),
            _buildStageItem('Review', 1, Colors.purple),
            _buildStageItem('Deployment', 1, Colors.teal),
          ],
        ),
      ),
    );
  }

  Widget _buildStageItem(String stage, int count, Color color) {
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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withAlpha((255 * 0.2).round()),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.work, color: Colors.indigo),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              stage,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
                color: color.withAlpha((255 * 0.2).round()),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$count items',
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

  Widget _buildWorkflowAutomationCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Workflow Automation',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Auto Testing'),
              subtitle: const Text('Run tests automatically'),
              value: true,
              onChanged: (value) {
                // TODO: Update setting
              },
              secondary: const Icon(Icons.auto_awesome),
            ),
            SwitchListTile(
              title: const Text('Auto Deployment'),
              subtitle: const Text('Deploy on successful build'),
              value: false,
              onChanged: (value) {
                // TODO: Update setting
              },
              secondary: const Icon(Icons.rocket_launch),
            ),
            SwitchListTile(
              title: const Text('Notifications'),
              subtitle: const Text('Send workflow notifications'),
              value: true,
              onChanged: (value) {
                // TODO: Update setting
              },
              secondary: const Icon(Icons.notifications),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkflowAnalyticsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Workflow Analytics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildWorkflowMetric('Cycle Time', '5.2 days', Colors.blue),
                ),
                Expanded(
                  child: _buildWorkflowMetric('Lead Time', '8.1 days', Colors.green),
                ),
                Expanded(
                  child: _buildWorkflowMetric('Throughput', '12/week', Colors.orange),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildWorkflowMetric('Efficiency', '87%', Colors.purple),
                ),
                Expanded(
                  child: _buildWorkflowMetric('Quality', '94%', Colors.teal),
                ),
                Expanded(
                  child: _buildWorkflowMetric('Satisfaction', '4.6/5', Colors.indigo),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkflowMetric(String label, String value, Color color) {
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
} 