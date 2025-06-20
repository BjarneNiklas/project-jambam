import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_jambam/src/features/a_ideation/domain/jam_kit.dart';

class CommunityHubScreen extends ConsumerStatefulWidget {
  const CommunityHubScreen({super.key});

  @override
  ConsumerState<CommunityHubScreen> createState() => _CommunityHubScreenState();
}

class _CommunityHubScreenState extends ConsumerState<CommunityHubScreen> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Hub'),
        backgroundColor: colorScheme.primaryContainer,
        bottom: TabBar(
          onTap: (index) => setState(() => _selectedTabIndex = index),
          tabs: const [
            Tab(text: '🌱 Jam Seeds'),
            Tab(text: '🎯 Jam Kits'),
            Tab(text: '⭐ Inspirators'),
            Tab(text: '🏆 Leaderboard'),
          ],
        ),
      ),
      body: IndexedStack(
        index: _selectedTabIndex,
        children: [
          _buildJamSeedsTab(),
          _buildJamKitsTab(),
          _buildInspiratorsTab(),
          _buildLeaderboardTab(),
        ],
      ),
    );
  }

  Widget _buildJamSeedsTab() {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // Mock data for demonstration
    final jamSeeds = [
      JamSeed(
        id: '1',
        title: 'Time Travel Cooking',
        coreConcept: 'A cooking game where you travel through time to collect ingredients from different eras.',
        inspirationElements: ['time travel', 'cooking', 'history'],
        creativeConstraints: ['Must include at least 3 time periods', 'Focus on real historical recipes'],
        voteCount: 156,
        submitter: 'ChefTime',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        isCommunityDriven: true,
        inspirator: const CommunityMember(
          id: 'user1',
          username: 'ChefTime',
          displayName: 'Chef Time Traveler',
          role: CommunityRole.inspirator,
          reputation: 1250,
          badges: ['🥇 Top Inspirator', '👨‍🍳 Cooking Expert'],
        ),
        tags: ['cooking', 'time-travel', 'history', 'casual'],
      ),
      JamSeed(
        id: '2',
        title: 'Neon Noir Detective',
        coreConcept: 'A cyberpunk detective game with neon aesthetics and noir storytelling.',
        inspirationElements: ['cyberpunk', 'detective', 'neon', 'noir'],
        creativeConstraints: ['Must be in first-person', 'Include dialogue choices'],
        voteCount: 89,
        submitter: 'NeonDreamer',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        isCommunityDriven: true,
        inspirator: const CommunityMember(
          id: 'user2',
          username: 'NeonDreamer',
          displayName: 'Neon Dreamer',
          role: CommunityRole.inspirator,
          reputation: 890,
          badges: ['🎨 Art Director', '🕵️ Mystery Lover'],
        ),
        tags: ['cyberpunk', 'detective', 'noir', 'story-driven'],
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: jamSeeds.length,
      itemBuilder: (context, index) {
        final seed = jamSeeds[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with title and votes
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        seed.title,
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getStatusColor(seed.status, colorScheme),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        _getStatusText(seed.status),
                        style: textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Inspirator info
                if (seed.inspirator != null) ...[
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: colorScheme.primaryContainer,
                        child: Text(
                          seed.inspirator!.displayName[0],
                          style: textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'by ${seed.inspirator!.displayName}',
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '⭐ ${seed.inspirator!.reputation} reputation',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],

                // Core concept
                Text(
                  seed.coreConcept,
                  style: textTheme.bodyLarge,
                ),
                const SizedBox(height: 12),

                // Tags
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: seed.tags.map((tag) {
                    return Chip(
                      label: Text(tag),
                      backgroundColor: colorScheme.secondaryContainer,
                      labelStyle: textTheme.bodySmall,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // View details functionality
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('View details coming soon!')),
                          );
                        },
                        icon: const Icon(Icons.visibility),
                        label: const Text('View Details'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Vote functionality
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Vote functionality coming soon!')),
                          );
                        },
                        icon: const Icon(Icons.thumb_up),
                        label: Text('${seed.voteCount}'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildJamKitsTab() {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // Mock data for demonstration
    final jamKits = [
      JamKit(
        id: '1',
        title: 'Time Travel Chef: Culinary Adventures',
        theme: 'Embark on a culinary journey through time! Travel to ancient Rome, medieval Europe, and futuristic Mars to collect unique ingredients and master historical recipes.',
        quests: [
          const Quest(
            title: 'Master the Roman Feast',
            description: 'Travel to ancient Rome and learn to cook authentic Roman dishes using period-appropriate ingredients.',
          ),
          const Quest(
            title: 'Medieval Banquet Challenge',
            description: 'Create a grand medieval feast for a noble family using only ingredients available in the Middle Ages.',
          ),
        ],
        assetSuggestions: [
          const AssetSuggestion(
            type: 'character',
            description: 'Time-traveling chef with period-appropriate clothing',
            stylePrompt: 'Cartoon style, friendly expression, chef hat, time portal effects',
          ),
        ],
        inspirator: const CommunityMember(
          id: 'user1',
          username: 'ChefTime',
          displayName: 'Chef Time Traveler',
          role: CommunityRole.inspirator,
        ),
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: jamKits.length,
      itemBuilder: (context, index) {
        final kit = jamKits[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  kit.title,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (kit.inspirator != null) ...[
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: colorScheme.primaryContainer,
                        child: Text(
                          kit.inspirator!.displayName[0],
                          style: textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Inspired by ${kit.inspirator!.displayName}',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
                Text(
                  kit.theme,
                  style: textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                Text(
                  'Quests (${kit.quests.length})',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...kit.quests.take(2).map((quest) => ListTile(
                  leading: Icon(Icons.check_circle_outline, color: colorScheme.secondary),
                  title: Text(quest.title),
                  subtitle: Text(quest.description),
                  dense: true,
                )),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // View full kit functionality
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('View full kit coming soon!')),
                          );
                        },
                        icon: const Icon(Icons.visibility),
                        label: const Text('View Full Kit'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Start development functionality
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Start development coming soon!')),
                          );
                        },
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Start Dev'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInspiratorsTab() {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // Mock data for top inspirators
    final inspirators = [
      CommunityMember(
        id: 'user1',
        username: 'ChefTimeTraveler',
        displayName: 'Chef Time Traveler',
        role: CommunityRole.inspirator,
        reputation: 1250,
        badges: ['🥇 Top Inspirator', '👨‍🍳 Cooking Expert', '🌟 Community Star'],
        createdAt: DateTime(2024, 1, 15),
      ),
      CommunityMember(
        id: 'user2',
        username: 'NeonDreamer',
        displayName: 'Neon Dreamer',
        role: CommunityRole.inspirator,
        reputation: 890,
        badges: ['🎨 Art Director', '🕵️ Mystery Lover', '💡 Creative Genius'],
        createdAt: DateTime(2024, 2, 1),
      ),
      CommunityMember(
        id: 'user3',
        username: 'PixelWizard',
        displayName: 'Pixel Wizard',
        role: CommunityRole.inspirator,
        reputation: 756,
        badges: ['🎮 Game Designer', '🎯 Problem Solver'],
        createdAt: DateTime(2024, 1, 20),
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: inspirators.length,
      itemBuilder: (context, index) {
        final inspirator = inspirators[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: colorScheme.primaryContainer,
                      child: Text(
                        inspirator.displayName[0],
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            inspirator.displayName,
                            style: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '@${inspirator.username}',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '⭐ ${inspirator.reputation} reputation',
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.verified,
                      color: colorScheme.primary,
                      size: 24,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: inspirator.badges.map((badge) {
                    return Chip(
                      label: Text(badge),
                      backgroundColor: colorScheme.secondaryContainer,
                      labelStyle: textTheme.bodySmall,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // View profile functionality
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('View profile coming soon!')),
                          );
                        },
                        icon: const Icon(Icons.person),
                        label: const Text('View Profile'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Follow functionality
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Follow functionality coming soon!')),
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Follow'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLeaderboardTab() {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // Mock leaderboard data
    final leaderboard = [
      {'rank': 1, 'name': 'Chef Time Traveler', 'points': 1250, 'category': 'Top Inspirator'},
      {'rank': 2, 'name': 'Neon Dreamer', 'points': 890, 'category': 'Creative Genius'},
      {'rank': 3, 'name': 'Pixel Wizard', 'points': 756, 'category': 'Game Designer'},
      {'rank': 4, 'name': 'Story Weaver', 'points': 654, 'category': 'Narrative Expert'},
      {'rank': 5, 'name': 'Code Master', 'points': 543, 'category': 'Technical Lead'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: leaderboard.length,
      itemBuilder: (context, index) {
        final entry = leaderboard[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getRankColor(entry['rank'] as int, colorScheme),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  '${entry['rank']}',
                  style: textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            title: Text(
              entry['name'] as String,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(entry['category'] as String),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${entry['points']}',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                Text(
                  'points',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(JamSeedStatus status, ColorScheme colorScheme) {
    switch (status) {
      case JamSeedStatus.brainstorming:
        return colorScheme.primary;
      case JamSeedStatus.refining:
        return colorScheme.secondary;
      case JamSeedStatus.evolving:
        return colorScheme.tertiary;
      case JamSeedStatus.concrete:
        return Colors.green;
      case JamSeedStatus.completed:
        return Colors.grey;
      case JamSeedStatus.researching:
        return Colors.orange;
    }
  }

  String _getStatusText(JamSeedStatus status) {
    switch (status) {
      case JamSeedStatus.brainstorming:
        return '🌱 Brainstorming';
      case JamSeedStatus.refining:
        return '🔧 Refining';
      case JamSeedStatus.evolving:
        return '🚀 Evolving';
      case JamSeedStatus.concrete:
        return '🎯 Concrete';
      case JamSeedStatus.completed:
        return '✅ Completed';
      case JamSeedStatus.researching:
        return '🔬 Researching';
    }
  }

  Color _getRankColor(int rank, ColorScheme colorScheme) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey;
      case 3:
        return Colors.brown;
      default:
        return colorScheme.primary;
    }
  }
} 