import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JamsScreen extends ConsumerStatefulWidget {
  const JamsScreen({super.key});

  @override
  ConsumerState<JamsScreen> createState() => _JamsScreenState();
}

class _JamsScreenState extends ConsumerState<JamsScreen>
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
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            child: TabBar(
              controller: _tabController,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Theme.of(context).primaryColor,
              tabs: const [
                Tab(text: 'All'),
                Tab(text: 'My'),
                Tab(text: 'Participating'),
                Tab(text: 'Upcoming'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                AllJamsTab(),
                MyJamsTab(),
                ParticipatingJamsTab(),
                UpcomingJamsTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to create jam screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Create Jam - Coming Soon!')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AllJamsTab extends StatelessWidget {
  const AllJamsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.primaries[index % Colors.primaries.length],
              child: Text('${index + 1}'),
            ),
            title: Text('Game Jam ${index + 1}'),
            subtitle: Text('A fantastic game jam experience'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // TODO: Navigate to jam details
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Jam ${index + 1} Details - Coming Soon!')),
              );
            },
          ),
        );
      },
    );
  }
}

class MyJamsTab extends StatelessWidget {
  const MyJamsTab({super.key});

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
              backgroundColor: Colors.green,
              child: Icon(
                index == 0 ? Icons.edit : Icons.play_arrow,
                color: Colors.white,
              ),
            ),
            title: Text('My Game Jam ${index + 1}'),
            subtitle: Text(index == 0 ? 'In Progress' : 'Completed'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // TODO: Navigate to my jam details
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('My Jam ${index + 1} Details - Coming Soon!')),
              );
            },
          ),
        );
      },
    );
  }
}

class ParticipatingJamsTab extends StatelessWidget {
  const ParticipatingJamsTab({super.key});

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
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.group,
                color: Colors.white,
              ),
            ),
            title: Text('Participating Jam ${index + 1}'),
            subtitle: Text('Team: Awesome Squad ${index + 1}'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // TODO: Navigate to participating jam details
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Participating Jam ${index + 1} Details - Coming Soon!')),
              );
            },
          ),
        );
      },
    );
  }
}

class UpcomingJamsTab extends StatelessWidget {
  const UpcomingJamsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.orange,
              child: Icon(
                Icons.schedule,
                color: Colors.white,
              ),
            ),
            title: Text('Upcoming Jam ${index + 1}'),
            subtitle: Text('Starts in ${(index + 1) * 7} days'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // TODO: Navigate to upcoming jam details
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Upcoming Jam ${index + 1} Details - Coming Soon!')),
              );
            },
          ),
        );
      },
    );
  }
} 