import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'terminology_config.dart';

class AcademyScreen extends ConsumerStatefulWidget {
  const AcademyScreen({super.key});

  @override
  ConsumerState<AcademyScreen> createState() => _AcademyScreenState();
}

class _AcademyScreenState extends ConsumerState<AcademyScreen>
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple[600]!, Colors.indigo[600]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.school, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              const Text(
                'ACADEMY',
                style: TextStyle(
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
            icon: const Icon(Icons.notifications, color: Colors.purple),
            onPressed: () {
              // TODO: Show academy notifications
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.purple,
          indicatorWeight: 3,
          labelColor: Colors.purple,
          unselectedLabelColor: Colors.grey,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(icon: Icon(Icons.workspace_premium), text: 'WORKSHOPS'),
            Tab(icon: Icon(Icons.school), text: 'COURSES'),
            Tab(icon: Icon(Icons.emoji_events), text: 'CHALLENGES'),
            Tab(icon: Icon(Icons.library_books), text: 'RESOURCES'),
            Tab(icon: Icon(Icons.trending_up), text: 'PROGRESS'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildWorkshopsTab(),
          _buildCoursesTab(),
          _buildChallengesTab(),
          _buildResourcesTab(),
          _buildProgressTab(),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildWorkshopsTab() {
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
            'Quick Start Workshops',
            'Learn new skills in 15-30 minutes',
            Icons.flash_on,
            Colors.orange,
          ),
          const SizedBox(height: 16),
          _buildWorkshopCard(
            'Flutter Widgets in 20 Minutes',
            'Master the basics of Flutter UI components',
            '20 min',
            'Beginner',
            Colors.blue,
            Icons.phone_android,
            progress: 0.0,
          ),
          _buildWorkshopCard(
            'Unity C# Basics',
            'Learn the fundamentals of C# programming in Unity',
            '25 min',
            'Beginner',
            Colors.green,
            Icons.games,
            progress: 0.0,
          ),
          _buildWorkshopCard(
            'AI Prompt Engineering',
            'Create effective prompts for AI tools',
            '15 min',
            'Intermediate',
            Colors.purple,
            Icons.auto_awesome,
            progress: 0.0,
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(
            'Deep Dive Workshops',
            'Master advanced topics in 1-2 hours',
            Icons.psychology,
            Colors.indigo,
          ),
          const SizedBox(height: 16),
          _buildWorkshopCard(
            'State Management in Flutter',
            'Riverpod, Bloc, and Provider patterns',
            '90 min',
            'Intermediate',
            Colors.blue,
            Icons.settings,
            progress: 0.0,
          ),
          _buildWorkshopCard(
            'Unity 2D Game Development',
            'Create a complete 2D platformer game',
            '120 min',
            'Intermediate',
            Colors.green,
            Icons.view_in_ar,
            progress: 0.0,
          ),
          _buildWorkshopCard(
            'AI Integration in Games',
            'Add AI features to your games',
            '75 min',
            'Advanced',
            Colors.purple,
            Icons.smart_toy,
            progress: 0.0,
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesTab() {
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
            'Complete Learning Paths',
            'Master entire technologies from start to finish',
            Icons.route,
            Colors.indigo,
          ),
          const SizedBox(height: 16),
          _buildCourseCard(
            'Complete Game Development',
            'Learn Unity, C#, and game design principles',
            '8 weeks',
            'Beginner to Advanced',
            Colors.green,
            Icons.games,
            progress: 0.0,
            modules: 24,
          ),
          _buildCourseCard(
            'Full-Stack App Development',
            'Flutter, Firebase, and backend development',
            '10 weeks',
            'Intermediate',
            Colors.blue,
            Icons.phone_android,
            progress: 0.0,
            modules: 30,
          ),
          _buildCourseCard(
            'AI Integration Masterclass',
            'Machine learning and AI in applications',
            '6 weeks',
            'Advanced',
            Colors.purple,
            Icons.psychology,
            progress: 0.0,
            modules: 18,
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(
            'Specialized Tracks',
            'Focus on specific areas of expertise',
            Icons.track_changes,
            Colors.teal,
          ),
          const SizedBox(height: 16),
          _buildCourseCard(
            'Professional Asset Creation',
            '3D modeling, texturing, and animation',
            '4 weeks',
            'Intermediate',
            Colors.orange,
            Icons.brush,
            progress: 0.0,
            modules: 12,
          ),
          _buildCourseCard(
            'Web3 Development',
            'Blockchain, smart contracts, and dApps',
            '5 weeks',
            'Advanced',
            Colors.amber,
            Icons.block,
            progress: 0.0,
            modules: 15,
          ),
        ],
      ),
    );
  }

  Widget _buildChallengesTab() {
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
            'Daily Challenges',
            'Quick exercises to keep your skills sharp',
            Icons.calendar_today,
            Colors.amber,
          ),
          const SizedBox(height: 16),
          _buildChallengeCard(
            'Flutter Animation Challenge',
            'Create a smooth loading animation',
            '15 min',
            'Beginner',
            Colors.blue,
            Icons.animation,
            reward: '50 XP',
          ),
          _buildChallengeCard(
            'Unity Physics Challenge',
            'Build a realistic bouncing ball system',
            '20 min',
            'Intermediate',
            Colors.green,
            Icons.science,
            reward: '75 XP',
          ),
          _buildChallengeCard(
            'AI Art Challenge',
            'Generate 5 unique AI artworks',
            '10 min',
            'All Levels',
            Colors.purple,
            Icons.auto_awesome,
            reward: '30 XP',
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(
            'Weekly Projects',
            'Build complete projects in a week',
            Icons.weekend,
            Colors.orange,
          ),
          const SizedBox(height: 16),
          _buildChallengeCard(
            'Mobile App MVP',
            'Create a complete mobile app from scratch',
            '1 week',
            'Intermediate',
            Colors.blue,
            Icons.phone_android,
            reward: '500 XP + Badge',
          ),
          _buildChallengeCard(
            'Game Prototype',
            'Develop a playable game prototype',
            '1 week',
            'Intermediate',
            Colors.green,
            Icons.games,
            reward: '500 XP + Badge',
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(
            'Monthly Competitions',
            'Compete with other learners',
            Icons.emoji_events,
            Colors.red,
          ),
          const SizedBox(height: 16),
          _buildChallengeCard(
            'Innovation Challenge',
            'Create the most innovative app feature',
            '1 month',
            'All Levels',
            Colors.purple,
            Icons.lightbulb,
            reward: '1000 XP + Certificate',
          ),
        ],
      ),
    );
  }

  Widget _buildResourcesTab() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.teal[50]!,
            Colors.white,
          ],
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader(
            'Documentation',
            'Comprehensive guides and references',
            Icons.description,
            Colors.teal,
          ),
          const SizedBox(height: 16),
          _buildResourceCard(
            'Flutter Documentation',
            'Official Flutter guides and API reference',
            'Documentation',
            Colors.blue,
            Icons.phone_android,
          ),
          _buildResourceCard(
            'Unity Manual',
            'Complete Unity development manual',
            'Documentation',
            Colors.green,
            Icons.games,
          ),
          _buildResourceCard(
            'AI Tools Guide',
            'Comprehensive guide to AI development tools',
            'Documentation',
            Colors.purple,
            Icons.psychology,
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(
            'Templates & Examples',
            'Ready-to-use code and project templates',
            Icons.content_copy,
            Colors.indigo,
          ),
          const SizedBox(height: 16),
          _buildResourceCard(
            'Flutter App Templates',
            'Pre-built app templates for common use cases',
            'Templates',
            Colors.blue,
            Icons.phone_android,
          ),
          _buildResourceCard(
            'Unity Game Templates',
            'Game templates for different genres',
            'Templates',
            Colors.green,
            Icons.games,
          ),
          _buildResourceCard(
            'AI Integration Examples',
            'Code examples for AI integration',
            'Examples',
            Colors.purple,
            Icons.code,
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(
            'Video Library',
            'Video tutorials and presentations',
            Icons.video_library,
            Colors.red,
          ),
          const SizedBox(height: 16),
          _buildResourceCard(
            'Flutter Video Tutorials',
            'Step-by-step video guides',
            'Videos',
            Colors.blue,
            Icons.play_circle,
          ),
          _buildResourceCard(
            'Unity Masterclass Series',
            'Advanced Unity development videos',
            'Videos',
            Colors.green,
            Icons.play_circle,
          ),
          _buildResourceCard(
            'AI Development Webinars',
            'Live webinars on AI integration',
            'Videos',
            Colors.purple,
            Icons.play_circle,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressTab() {
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
            'Learning Progress',
            'Track your journey to mastery',
            Icons.trending_up,
            Colors.green,
          ),
          const SizedBox(height: 16),
          _buildProgressCard(
            'Overall Progress',
            'Your learning journey so far',
            '25%',
            0.25,
            Colors.blue,
            Icons.school,
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(
            'Skill Tree',
            'Your mastered and learning skills',
            Icons.account_tree,
            Colors.orange,
          ),
          const SizedBox(height: 16),
          _buildSkillCard('Flutter Development', 0.8, Colors.blue),
          _buildSkillCard('Unity Game Development', 0.6, Colors.green),
          _buildSkillCard('AI Integration', 0.3, Colors.purple),
          _buildSkillCard('3D Modeling', 0.1, Colors.orange),
          const SizedBox(height: 24),
          _buildSectionHeader(
            'Achievements',
            'Milestones and accomplishments',
            Icons.emoji_events,
            Colors.amber,
          ),
          const SizedBox(height: 16),
          _buildAchievementCard(
            'First Workshop',
            'Completed your first workshop',
            Icons.workspace_premium,
            Colors.blue,
            unlocked: true,
          ),
          _buildAchievementCard(
            'Course Master',
            'Completed a full course',
            Icons.school,
            Colors.green,
            unlocked: false,
          ),
          _buildAchievementCard(
            'Challenge Champion',
            'Won a monthly competition',
            Icons.emoji_events,
            Colors.amber,
            unlocked: false,
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(
            'Learning Stats',
            'Your learning statistics',
            Icons.analytics,
            Colors.purple,
          ),
          const SizedBox(height: 16),
          _buildStatsCard(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle, IconData icon, Color color) {
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: color.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkshopCard(String title, String description, String duration, String level, Color color, IconData icon, {double progress = 0.0}) {
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
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      duration,
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      level,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              if (progress > 0) ...[
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
                Text(
                  '${(progress * 100).toInt()}% Complete',
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: () {
              // TODO: Navigate to workshop details
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCourseCard(String title, String description, String duration, String level, Color color, IconData icon, {double progress = 0.0, int modules = 0}) {
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
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      duration,
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$modules modules',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              if (progress > 0) ...[
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
                Text(
                  '${(progress * 100).toInt()}% Complete',
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: () {
              // TODO: Navigate to course details
            },
          ),
        ),
      ),
    );
  }

  Widget _buildChallengeCard(String title, String description, String duration, String level, Color color, IconData icon, {String reward = ''}) {
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
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      duration,
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (reward.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        reward,
                        style: const TextStyle(
                          color: Colors.amber,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: () {
              // TODO: Navigate to challenge details
            },
          ),
        ),
      ),
    );
  }

  Widget _buildResourceCard(String title, String description, String type, Color color, IconData icon) {
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
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
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
                type,
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
            // TODO: Navigate to resource
          },
        ),
      ),
    );
  }

  Widget _buildProgressCard(String title, String description, String percentage, double progress, Color color, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 28),
                const SizedBox(width: 12),
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
                        description,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  percentage,
                  style: TextStyle(
                    color: color,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillCard(String skill, double progress, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(Icons.star, color: color, size: 20),
        ),
        title: Text(skill, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey.withOpacity(0.3),
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
        trailing: Text(
          '${(progress * 100).toInt()}%',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementCard(String title, String description, IconData icon, Color color, {bool unlocked = false}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: unlocked ? color : Colors.grey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            icon,
            color: unlocked ? Colors.white : Colors.grey,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: unlocked ? null : Colors.grey,
          ),
        ),
        subtitle: Text(
          description,
          style: TextStyle(
            color: unlocked ? Colors.grey[600] : Colors.grey,
          ),
        ),
        trailing: unlocked
            ? Icon(Icons.check_circle, color: color, size: 20)
            : Icon(Icons.lock, color: Colors.grey, size: 20),
      ),
    );
  }

  Widget _buildStatsCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Learning Statistics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildStatRow('Workshops Completed', '3', Colors.blue),
            _buildStatRow('Courses Enrolled', '2', Colors.green),
            _buildStatRow('Challenges Won', '5', Colors.amber),
            _buildStatRow('Total Learning Time', '12h 30m', Colors.purple),
            _buildStatRow('Current Streak', '7 days', Colors.red),
            _buildStatRow('XP Earned', '1,250', Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        _showActionSheet();
      },
      backgroundColor: Colors.purple,
      icon: const Icon(Icons.add, color: Colors.white),
      label: const Text(
        'Start Learning',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
              leading: const Icon(Icons.workspace_premium, color: Colors.blue),
              title: const Text('Start Workshop'),
              subtitle: const Text('Begin a quick learning session'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to workshop selection
              },
            ),
            ListTile(
              leading: const Icon(Icons.school, color: Colors.green),
              title: const Text('Enroll in Course'),
              subtitle: const Text('Join a comprehensive learning path'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to course selection
              },
            ),
            ListTile(
              leading: const Icon(Icons.emoji_events, color: Colors.amber),
              title: const Text('Take Challenge'),
              subtitle: const Text('Test your skills with a challenge'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to challenge selection
              },
            ),
            ListTile(
              leading: const Icon(Icons.library_books, color: Colors.purple),
              title: const Text('Browse Resources'),
              subtitle: const Text('Explore learning materials'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to resources
              },
            ),
          ],
        ),
      ),
    );
  }
} 