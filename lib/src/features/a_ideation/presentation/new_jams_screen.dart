import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'placeholder_screen.dart';

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
            color: Theme.of(context).primaryColor.withAlpha(128),
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PlaceholderScreen(title: 'Create Jam')),
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PlaceholderScreen(title: 'Jam ${index + 1} Details')),
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PlaceholderScreen(title: 'My Jam ${index + 1} Details')),
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PlaceholderScreen(title: 'Participating Jam ${index + 1} Details')),
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PlaceholderScreen(title: 'Upcoming Jam ${index + 1} Details')),
              );
            },
          ),
        );
      },
    );
  }
} 