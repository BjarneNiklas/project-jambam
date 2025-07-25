import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_jambam/src/features/a_ideation/presentation/create_project_screen.dart';
import 'package:project_jambam/src/features/a_ideation/presentation/project_details_screen.dart';

class ProjectsScreen extends ConsumerStatefulWidget {
  const ProjectsScreen({super.key});

  @override
  ConsumerState<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends ConsumerState<ProjectsScreen>
    with SingleTickerProviderStateMixin {
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
      body: Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor.withAlpha(25),
            child: TabBar(
              controller: _tabController,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Theme.of(context).primaryColor,
              tabs: const [
                Tab(text: 'All'),
                Tab(text: 'My'),
                Tab(text: 'Collaborating'),
                Tab(text: 'Archived'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                AllProjectsTab(),
                MyProjectsTab(),
                CollaboratingProjectsTab(),
                ArchivedProjectsTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateProjectScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AllProjectsTab extends StatelessWidget {
  const AllProjectsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.primaries[index % Colors.primaries.length],
              child: Icon(
                _getProjectIcon(index),
                color: Colors.white,
              ),
            ),
            title: Text('Project ${index + 1}'),
            subtitle: Text(_getProjectDescription(index)),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProjectDetailsScreen(projectId: 'project_${index + 1}'),
                ),
              );
            },
          ),
        );
      },
    );
  }

  IconData _getProjectIcon(int index) {
    final icons = [
      Icons.games,
      Icons.architecture,
      Icons.movie,
      Icons.science,
      Icons.business,
      Icons.school,
      Icons.health_and_safety,
      Icons.psychology,
    ];
    return icons[index % icons.length];
  }

  String _getProjectDescription(int index) {
    final descriptions = [
      'Game Development',
      '3D Architecture',
      'Film Production',
      'Scientific Simulation',
      'Business Application',
      'Educational Tool',
      'Health & Safety',
      'Psychology Research',
    ];
    return descriptions[index % descriptions.length];
  }
}

class MyProjectsTab extends StatelessWidget {
  const MyProjectsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(
                _getStatusIcon(index),
                color: Colors.white,
              ),
            ),
            title: Text('My Project ${index + 1}'),
            subtitle: Text(_getStatusText(index)),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProjectDetailsScreen(projectId: 'my_project_${index + 1}'),
                ),
              );
            },
          ),
        );
      },
    );
  }

  IconData _getStatusIcon(int index) {
    final icons = [
      Icons.play_arrow,
      Icons.pause,
      Icons.check_circle,
      Icons.schedule,
    ];
    return icons[index % icons.length];
  }

  String _getStatusText(int index) {
    final statuses = [
      'Active Development',
      'On Hold',
      'Completed',
      'Planning Phase',
    ];
    return statuses[index % statuses.length];
  }
}

class CollaboratingProjectsTab extends StatelessWidget {
  const CollaboratingProjectsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.group,
                color: Colors.white,
              ),
            ),
            title: Text('Collaborating Project ${index + 1}'),
            subtitle: Text('Team: Innovation Squad ${index + 1}'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProjectDetailsScreen(projectId: 'collab_project_${index + 1}'),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class ArchivedProjectsTab extends StatelessWidget {
  const ArchivedProjectsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 2,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.archive,
                color: Colors.white,
              ),
            ),
            title: Text('Archived Project ${index + 1}'),
            subtitle: Text('Completed ${(index + 1) * 30} days ago'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProjectDetailsScreen(projectId: 'archive_project_${index + 1}'),
                ),
              );
            },
          ),
        );
      },
    );
  }
} 