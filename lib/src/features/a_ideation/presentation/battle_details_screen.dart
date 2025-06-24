import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

class BattleDetailsScreen extends ConsumerStatefulWidget {
  final String battleId;
  final String battleTitle;

  const BattleDetailsScreen({
    super.key,
    required this.battleId,
    required this.battleTitle,
  });

  @override
  ConsumerState<BattleDetailsScreen> createState() => _BattleDetailsScreenState();
}

class _BattleDetailsScreenState extends ConsumerState<BattleDetailsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isJoined = false;
  bool _isSubscribed = false;

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
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.battleTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(offset: Offset(0, 1), blurRadius: 3)],
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple[600]!, Colors.indigo[600]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -50,
                      top: -50,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      left: -30,
                      bottom: -30,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  _isSubscribed ? Icons.notifications_active : Icons.notifications_outlined,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _isSubscribed = !_isSubscribed;
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: () {
                  _shareBattle();
                },
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: const [
                Tab(text: 'OVERVIEW'),
                Tab(text: 'PARTICIPANTS'),
                Tab(text: 'SUBMISSIONS'),
                Tab(text: 'DISCUSSION'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewTab(),
            _buildParticipantsTab(),
            _buildSubmissionsTab(),
            _buildDiscussionTab(),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusCard(),
          const SizedBox(height: 16),
          _buildInfoCard(),
          const SizedBox(height: 16),
          _buildRulesCard(),
          const SizedBox(height: 16),
          _buildPrizesCard(),
          const SizedBox(height: 16),
          _buildTimelineCard(),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.green[400]!, Colors.green[600]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.play_circle, color: Colors.white, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ACTIVE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Battle is running',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '3 days left',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Battle Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Theme', 'AI-Powered Adventure Games'),
            _buildInfoRow('Category', 'Game Development'),
            _buildInfoRow('Difficulty', 'Intermediate'),
            _buildInfoRow('Team Size', 'Squad (1-4 members)'),
            _buildInfoRow('Platform', 'Unity, Flutter, Web'),
            _buildInfoRow('Duration', '7 days'),
            const SizedBox(height: 12),
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Create an innovative adventure game that leverages AI to generate dynamic content, adaptive storytelling, and intelligent NPCs. Your game should demonstrate cutting-edge AI integration while maintaining engaging gameplay mechanics.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRulesCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rules & Requirements',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildRuleItem('Original work only - no plagiarism'),
            _buildRuleItem('AI tools are encouraged and required'),
            _buildRuleItem('Submit playable prototype or demo'),
            _buildRuleItem('Include source code and documentation'),
            _buildRuleItem('Present your project in 3-minute pitch'),
            _buildRuleItem('Follow community guidelines'),
          ],
        ),
      ),
    );
  }

  Widget _buildRuleItem(String rule) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              rule,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrizesCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Prizes & Rewards',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildPrizeItem('🥇 1st Place', '1000 XP + Premium Badge + \$500', Colors.amber),
            _buildPrizeItem('🥈 2nd Place', '750 XP + Silver Badge + \$300', Colors.grey),
            _buildPrizeItem('🥉 3rd Place', '500 XP + Bronze Badge + \$200', Colors.orange),
            _buildPrizeItem('🏆 Innovation', '250 XP + Innovation Badge + \$100', Colors.purple),
            _buildPrizeItem('👥 Community', '100 XP + Community Badge', Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildPrizeItem(String place, String reward, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              place,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              reward,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Timeline',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildTimelineItem('Registration Open', 'Dec 1, 2024', true),
            _buildTimelineItem('Battle Starts', 'Dec 8, 2024', true),
            _buildTimelineItem('Submission Deadline', 'Dec 15, 2024', false),
            _buildTimelineItem('Judging Period', 'Dec 16-18, 2024', false),
            _buildTimelineItem('Results Announced', 'Dec 19, 2024', false),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(String event, String date, bool completed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            completed ? Icons.check_circle : Icons.radio_button_unchecked,
            color: completed ? Colors.green : Colors.grey,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              event,
              style: TextStyle(
                fontWeight: completed ? FontWeight.bold : FontWeight.normal,
                color: completed ? Colors.black : Colors.grey,
              ),
            ),
          ),
          Text(
            date,
            style: TextStyle(
              color: completed ? Colors.green : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildParticipantsHeader(),
        const SizedBox(height: 16),
        _buildParticipantCard('Team Alpha', 'John Doe', 4, 'Unity', true),
        _buildParticipantCard('Code Warriors', 'Jane Smith', 3, 'Flutter', false),
        _buildParticipantCard('AI Masters', 'Bob Johnson', 2, 'Web', false),
        _buildParticipantCard('Game Dev Pros', 'Alice Brown', 1, 'Unity', false),
        _buildParticipantCard('Innovation Squad', 'Charlie Wilson', 4, 'Mixed', false),
      ],
    );
  }

  Widget _buildParticipantsHeader() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.people, color: Colors.blue, size: 24),
            const SizedBox(width: 12),
            const Text(
              'Participants',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '5 teams',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantCard(String teamName, String leader, int members, String platform, bool isLeading) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isLeading ? Colors.amber : Colors.blue,
          child: Text(
            teamName[0],
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Row(
          children: [
            Text(
              teamName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            if (isLeading) ...[
              const SizedBox(width: 8),
              const Icon(Icons.star, color: Colors.amber, size: 16),
            ],
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Leader: $leader'),
            Row(
              children: [
                Icon(Icons.people, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text('$members members'),
                const SizedBox(width: 16),
                Icon(Icons.computer, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(platform),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () {
            _navigateToTeamDetails(teamName);
          },
        ),
      ),
    );
  }

  Widget _buildSubmissionsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSubmissionsHeader(),
        const SizedBox(height: 16),
        _buildSubmissionCard(
          'Team Alpha',
          'AI Adventure Quest',
          'An innovative adventure game with AI-generated quests and dynamic storytelling.',
          'Unity',
          4.8,
          true,
        ),
        _buildSubmissionCard(
          'Code Warriors',
          'Flutter RPG',
          'A mobile RPG built with Flutter featuring AI-powered NPCs.',
          'Flutter',
          4.5,
          false,
        ),
        _buildSubmissionCard(
          'AI Masters',
          'Web Adventure',
          'A web-based adventure game with real-time AI content generation.',
          'Web',
          4.2,
          false,
        ),
      ],
    );
  }

  Widget _buildSubmissionsHeader() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.emoji_events, color: Colors.amber, size: 24),
            const SizedBox(width: 12),
            const Text(
              'Submissions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '3 submitted',
                style: TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmissionCard(String team, String title, String description, String platform, double rating, bool isTop) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'by $team',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isTop)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'TOP',
                      style: TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    platform,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      rating.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Play Demo'),
                    onPressed: () {
                      _launchDemo(title, team);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.info),
                    label: const Text('Details'),
                    onPressed: () {
                      _showSubmissionDetails(title, team, description, platform, rating);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscussionTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildDiscussionHeader(),
        const SizedBox(height: 16),
        _buildDiscussionCard(
          'John Doe',
          'Team Alpha',
          'What AI tools are you using for content generation?',
          '2 hours ago',
          5,
          3,
        ),
        _buildDiscussionCard(
          'Jane Smith',
          'Code Warriors',
          'Tips for integrating AI NPCs in Flutter games?',
          '4 hours ago',
          3,
          1,
        ),
        _buildDiscussionCard(
          'Bob Johnson',
          'AI Masters',
          'How to handle real-time AI generation without lag?',
          '6 hours ago',
          8,
          4,
        ),
      ],
    );
  }

  Widget _buildDiscussionHeader() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.forum, color: Colors.green, size: 24),
            const SizedBox(width: 12),
            const Text(
              'Discussion',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '3 topics',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscussionCard(String author, String team, String message, String time, int likes, int replies) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.blue,
                  child: Text(
                    author[0],
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
                        author,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        team,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.thumb_up_outlined, size: 20),
                  onPressed: () {
                    _likePost(author, message);
                  },
                ),
                Text('$likes'),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.reply, size: 20),
                  onPressed: () {
                    _replyToPost(author, message);
                  },
                ),
                Text('$replies'),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.more_vert, size: 20),
                  onPressed: () {
                    _showPostOptions(author, message);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    if (_isJoined) {
      return FloatingActionButton.extended(
        onPressed: () {
          _submitProject();
        },
        backgroundColor: Colors.green,
        icon: const Icon(Icons.upload, color: Colors.white),
        label: const Text(
          'Submit Project',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      );
    } else {
      return FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            _isJoined = true;
          });
        },
        backgroundColor: Colors.purple,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Join Battle',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      );
    }
  }

  void _shareBattle() {
    final battleTitle = 'AI-Powered Adventure Games Battle';
    final battleDescription = 'Join this exciting game development battle! Create innovative adventure games with AI integration.';
    final battleUrl = 'https://jambam.com/battles/ai-adventure-games';
    
    final shareText = '$battleTitle\n\n$battleDescription\n\nJoin now: $battleUrl';
    
    Share.share(
      shareText,
      subject: battleTitle,
    );
  }

  void _navigateToTeamDetails(String teamName) {
    // Navigate to team details screen
    Navigator.pushNamed(
      context,
      '/team-details',
      arguments: {'teamName': teamName},
    );
  }

  void _launchDemo(String title, String team) {
    // Launch demo URL or open in browser
    final demoUrl = 'https://jambam.com/demos/${title.toLowerCase().replaceAll(' ', '-')}';
    
    // You can use url_launcher package here
    debugPrint('Launching demo: $demoUrl for $team');
    
    // For now, show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Launching demo for $title by $team'),
        action: SnackBarAction(
          label: 'Open',
          onPressed: () {
            // Implement actual URL launch
          },
        ),
      ),
    );
  }

  void _showSubmissionDetails(String title, String team, String description, String platform, double rating) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Team: $team'),
            const SizedBox(height: 8),
            Text('Platform: $platform'),
            const SizedBox(height: 8),
            Text('Rating: ${rating.toStringAsFixed(1)}/5.0'),
            const SizedBox(height: 8),
            const Text('Description:'),
            Text(description),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _launchDemo(title, team);
            },
            child: const Text('Play Demo'),
          ),
        ],
      ),
    );
  }

  void _likePost(String author, String message) {
    // Toggle like state and update UI
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Liked post by $author'),
        duration: const Duration(seconds: 1),
      ),
    );
    
    // Here you would typically:
    // 1. Call API to like the post
    // 2. Update local state
    // 3. Refresh the UI
  }

  void _replyToPost(String author, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reply to $author'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Original: $message'),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Write your reply...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Reply posted!')),
              );
            },
            child: const Text('Post Reply'),
          ),
        ],
      ),
    );
  }

  void _showPostOptions(String author, String message) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.flag),
            title: const Text('Report'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Post reported')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.copy),
            title: const Text('Copy text'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Text copied to clipboard')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share'),
            onTap: () {
              Navigator.pop(context);
              Share.share('Check out this post: $message');
            },
          ),
        ],
      ),
    );
  }

  void _submitProject() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Project'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Upload your project files and provide details:'),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Project Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () {
                // Implement file picker
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('File picker would open here')),
                );
              },
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload Files'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Project submitted successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
} 