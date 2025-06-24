import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'terminology_config.dart';

class ArenaScreen extends ConsumerStatefulWidget {
  const ArenaScreen({super.key});

  @override
  ConsumerState<ArenaScreen> createState() => _ArenaScreenState();
}

class _ArenaScreenState extends ConsumerState<ArenaScreen>
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
    final terminologyState = ref.watch(terminologyProvider);
    
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[600]!, Colors.purple[600]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.sports_esports, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Text(
                ref.read(terminologyProvider.notifier).getTerminology('arena').toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.blue),
            onPressed: () {
              // TODO: Show arena notifications
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.blue,
          indicatorWeight: 3,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: [
            Tab(icon: const Icon(Icons.games), text: ref.read(terminologyProvider.notifier).getTerminology('battles')),
            const Tab(icon: Icon(Icons.trending_up), text: 'TRENDING'),
            Tab(icon: const Icon(Icons.emoji_events), text: ref.read(terminologyProvider.notifier).getTerminology('champions')),
            const Tab(icon: Icon(Icons.forum), text: 'COMMUNITY'),
            Tab(icon: const Icon(Icons.shield), text: ref.read(terminologyProvider.notifier).getTerminology('legions')),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBattlesTab(),
          _buildTrendingTab(),
          _buildChampionsTab(),
          _buildCommunityTab(),
          _buildLegionsTab(),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildBattlesTab() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue[50]!,
            Colors.white,
          ],
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader(
            ref.read(terminologyProvider.notifier).getTerminology('ready_for_battle'),
            Icons.flash_on,
            Colors.orange,
          ),
          const SizedBox(height: 16),
          _buildBattleCard(
            'Unity Game Jam 2024',
            'Create the next viral mobile game',
            '3 days left',
            Colors.green,
            Icons.games,
          ),
          _buildBattleCard(
            'Flutter UI Challenge',
            'Design the most beautiful app interface',
            '1 week left',
            Colors.blue,
            Icons.phone_android,
          ),
          _buildBattleCard(
            'AI Art Competition',
            'Generate stunning artwork with AI',
            '5 days left',
            Colors.purple,
            Icons.auto_awesome,
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(
            ref.read(terminologyProvider.notifier).getTerminology('active_battles'),
            Icons.local_fire_department,
            Colors.red,
          ),
          const SizedBox(height: 16),
          _buildBattleCard(
            'Web3 Hackathon',
            'Build the future of decentralized apps',
            '2 days left',
            Colors.orange,
            Icons.block,
          ),
          _buildBattleCard(
            'VR Experience Contest',
            'Create immersive virtual reality worlds',
            '1 day left',
            Colors.indigo,
            Icons.view_in_ar,
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingTab() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.purple[50]!,
            Colors.white,
          ],
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader(
            ref.read(terminologyProvider.notifier).getTerminology('whats_hot'),
            Icons.trending_up,
            Colors.purple,
          ),
          const SizedBox(height: 16),
          _buildTrendingCard(
            'Flutter 3.0 Features',
            'Exploring the latest Flutter capabilities',
            '🔥 2.5k views',
            Colors.blue,
          ),
          _buildTrendingCard(
            'Unity vs Unreal Engine',
            'Which game engine should you choose?',
            '🔥 1.8k views',
            Colors.green,
          ),
          _buildTrendingCard(
            'AI in Game Development',
            'How AI is revolutionizing game creation',
            '🔥 3.2k views',
            Colors.orange,
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(
            ref.read(terminologyProvider.notifier).getTerminology('trending_champions'),
            Icons.star,
            Colors.amber,
          ),
          const SizedBox(height: 16),
          _buildChampionCard(
            'Alex Chen',
            'Flutter Expert',
            '15 projects',
            Colors.blue,
          ),
          _buildChampionCard(
            'Maria Garcia',
            'Unity Developer',
            '23 projects',
            Colors.green,
          ),
          _buildChampionCard(
            'David Kim',
            'AI Specialist',
            '8 projects',
            Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildChampionsTab() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.amber[50]!,
            Colors.white,
          ],
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader(
            ref.read(terminologyProvider.notifier).getTerminology('arena_champions'),
            Icons.emoji_events,
            Colors.amber,
          ),
          const SizedBox(height: 16),
          _buildChampionCard(
            'Sarah Johnson',
            'Flutter Champion',
            '🏆 3x Winner',
            Colors.blue,
            isChampion: true,
          ),
          _buildChampionCard(
            'Mike Rodriguez',
            'Unity Master',
            '🏆 5x Winner',
            Colors.green,
            isChampion: true,
          ),
          _buildChampionCard(
            'Emma Wilson',
            'AI Innovator',
            '🏆 2x Winner',
            Colors.purple,
            isChampion: true,
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(
            ref.read(terminologyProvider.notifier).getTerminology('best_players'),
            Icons.leaderboard,
            Colors.orange,
          ),
          const SizedBox(height: 16),
          _buildLeaderboardCard('1', 'Alex Chen', '2,450 points', Colors.amber),
          _buildLeaderboardCard('2', 'Maria Garcia', '2,120 points', Colors.grey),
          _buildLeaderboardCard('3', 'David Kim', '1,890 points', Colors.brown),
          _buildLeaderboardCard('4', 'Lisa Wang', '1,650 points', Colors.grey),
          _buildLeaderboardCard('5', 'Tom Brown', '1,420 points', Colors.grey),
        ],
      ),
    );
  }

  Widget _buildCommunityTab() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.green[50]!,
            Colors.white,
          ],
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader(
            ref.read(terminologyProvider.notifier).getTerminology('arena_community'),
            Icons.forum,
            Colors.green,
          ),
          const SizedBox(height: 16),
          _buildDiscussionCard(
            'Flutter Best Practices',
            'Share your Flutter development tips and tricks',
            '💬 45 replies',
            Colors.blue,
          ),
          _buildDiscussionCard(
            'Unity Performance Optimization',
            'How to optimize your Unity games for better performance',
            '💬 32 replies',
            Colors.green,
          ),
          _buildDiscussionCard(
            'AI Tools for Developers',
            'What AI tools are you using in your workflow?',
            '💬 28 replies',
            Colors.purple,
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(
            ref.read(terminologyProvider.notifier).getTerminology('discuss_with_champions'),
            Icons.chat_bubble,
            Colors.blue,
          ),
          const SizedBox(height: 16),
          _buildDiscussionCard(
            'New Project Ideas',
            'Let\'s brainstorm some exciting new project ideas',
            '💬 67 replies',
            Colors.orange,
          ),
          _buildDiscussionCard(
            'Learning Resources',
            'Share the best learning resources you\'ve found',
            '💬 89 replies',
            Colors.indigo,
          ),
        ],
      ),
    );
  }

  Widget _buildLegionsTab() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.indigo[50]!,
            Colors.white,
          ],
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader(
            ref.read(terminologyProvider.notifier).getTerminology('gaming_legions'),
            Icons.shield,
            Colors.indigo,
          ),
          const SizedBox(height: 16),
          _buildLegionCard(
            'Flutter Warriors',
            'Elite Flutter developers',
            '156 members',
            Colors.blue,
            isActive: true,
          ),
          _buildLegionCard(
            'Unity Masters',
            'Professional Unity developers',
            '89 members',
            Colors.green,
            isActive: true,
          ),
          _buildLegionCard(
            'AI Pioneers',
            'AI and ML enthusiasts',
            '234 members',
            Colors.purple,
            isActive: true,
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(
            ref.read(terminologyProvider.notifier).getTerminology('legion_rankings'),
            Icons.leaderboard,
            Colors.orange,
          ),
          const SizedBox(height: 16),
          _buildLegionRankingCard('1', 'Flutter Warriors', '15,420 points', Colors.amber),
          _buildLegionRankingCard('2', 'Unity Masters', '12,890 points', Colors.grey),
          _buildLegionRankingCard('3', 'AI Pioneers', '11,230 points', Colors.brown),
          _buildLegionRankingCard('4', 'Web3 Builders', '9,450 points', Colors.grey),
          _buildLegionRankingCard('5', 'VR Creators', '8,120 points', Colors.grey),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBattleCard(String title, String description, String timeLeft, Color color, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(description),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  timeLeft,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: () {
              // TODO: Navigate to battle details
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTrendingCard(String title, String description, String stats, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.trending_up, color: color, size: 24),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description),
            const SizedBox(height: 4),
            Text(stats, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () {
            // TODO: Navigate to trending content
          },
        ),
      ),
    );
  }

  Widget _buildChampionCard(String name, String title, String stats, Color color, {bool isChampion = false}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isChampion ? 6 : 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: isChampion ? BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.2), color.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ) : null,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: color,
            child: Text(
              name[0],
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          title: Row(
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              if (isChampion) ...[
                const SizedBox(width: 8),
                Icon(Icons.emoji_events, color: Colors.amber, size: 20),
              ],
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title),
              Text(stats, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: () {
              // TODO: Navigate to champion profile
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLeaderboardCard(String rank, String name, String points, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              rank,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text(points, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildDiscussionCard(String title, String description, String replies, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.forum, color: color, size: 24),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description),
            const SizedBox(height: 4),
            Text(replies, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () {
            // TODO: Navigate to discussion
          },
        ),
      ),
    );
  }

  Widget _buildLegionCard(String name, String description, String members, Color color, {bool isActive = false}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isActive ? 4 : 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: isActive ? BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ) : null,
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.shield, color: Colors.white, size: 24),
          ),
          title: Row(
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              if (isActive) ...[
                const SizedBox(width: 8),
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(description),
              Text(members, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: () {
              // TODO: Navigate to legion details
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLegionRankingCard(String rank, String name, String points, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              rank,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text(points, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        _showActionSheet();
      },
      backgroundColor: Colors.blue,
      icon: const Icon(Icons.add, color: Colors.white),
      label: Text(
        ref.read(terminologyProvider.notifier).getTerminology('start_new_battle'),
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showActionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.games, color: Colors.blue),
              title: Text(ref.read(terminologyProvider.notifier).getTerminology('create_new_jam')),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to create jam
              },
            ),
            ListTile(
              leading: const Icon(Icons.shield, color: Colors.indigo),
              title: Text(ref.read(terminologyProvider.notifier).getTerminology('join_legion_action')),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to join legion
              },
            ),
            ListTile(
              leading: const Icon(Icons.group, color: Colors.green),
              title: Text(ref.read(terminologyProvider.notifier).getTerminology('form_squad')),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to form squad
              },
            ),
            ListTile(
              leading: const Icon(Icons.forum, color: Colors.orange),
              title: Text(ref.read(terminologyProvider.notifier).getTerminology('start_new_discussion')),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to start discussion
              },
            ),
          ],
        ),
      ),
    );
  }
} 