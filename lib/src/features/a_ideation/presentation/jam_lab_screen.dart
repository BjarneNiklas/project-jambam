import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_jambam/src/features/a_ideation/domain/jam_seed.dart';

class JamLabScreen extends ConsumerStatefulWidget {
  const JamLabScreen({super.key});

  @override
  ConsumerState<JamLabScreen> createState() => _JamLabScreenState();
}

class _JamLabScreenState extends ConsumerState<JamLabScreen> {
  int _selectedTabIndex = 0;

  // Mock experiments data
  final List<LabExperiment> experiments = [
    const LabExperiment(
      id: 'exp1',
      title: 'AI Narrative Generation Impact',
      description: 'Testing how AI-generated narratives affect player engagement and story completion rates.',
      researcher: CommunityMember(
        id: 'researcher1',
        username: 'NarrativeAI',
        displayName: 'Dr. Story Weaver',
        role: CommunityRole.labScientist,
        researchPoints: 2500,
        badges: ['🧪 Lab Scientist', '📚 Narrative Expert', '🤖 AI Researcher'],
      ),
      experimentType: ExperimentType.ai,
      hypothesis: 'AI-generated narratives with meaningful player choices will increase story completion rates by 40%.',
      methodology: 'A/B testing with 1000 players across 3 different narrative generation approaches.',
      results: 'Story completion rates increased by 35% with AI-generated narratives featuring meaningful choices.',
      conclusions: 'AI narrative generation shows promise but requires careful design of choice systems.',
      status: ExperimentStatus.completed,
      impactScore: 8,
      tags: ['AI', 'Narrative', 'Player Choice'],
    ),
    const LabExperiment(
      id: 'exp2',
      title: 'Accessibility Design Impact',
      description: 'Measuring the effect of accessibility-first design on player retention and satisfaction.',
      researcher: CommunityMember(
        id: 'researcher2',
        username: 'AccessGamer',
        displayName: 'Accessibility Advocate',
        role: CommunityRole.researcher,
        researchPoints: 1800,
        badges: ['♿ Accessibility Expert', '🎮 UX Researcher'],
      ),
      experimentType: ExperimentType.accessibility,
      hypothesis: 'Games designed with accessibility in mind from the start will have 23% higher player retention.',
      methodology: 'Comparative analysis of 50 games with and without accessibility features.',
      results: 'Player retention increased by 25% in games with comprehensive accessibility features.',
      conclusions: 'Accessibility-first design significantly improves player engagement and retention.',
      status: ExperimentStatus.published,
      impactScore: 9,
      tags: ['Accessibility', 'UX', 'Retention'],
    ),
    const LabExperiment(
      id: 'exp3',
      title: 'Emergent Gameplay Mechanics',
      description: 'Exploring how simple mechanics create complex emergent gameplay patterns.',
      researcher: CommunityMember(
        id: 'researcher3',
        username: 'EmergentDev',
        displayName: 'Emergence Expert',
        role: CommunityRole.labScientist,
        researchPoints: 3200,
        badges: ['🧪 Lab Scientist', '🎯 Mechanics Expert', '🔬 Research Lead'],
      ),
      experimentType: ExperimentType.mechanics,
      hypothesis: 'Simple mechanics with clear feedback loops create the most engaging emergent gameplay.',
      methodology: 'Analysis of 100+ games to identify patterns in emergent gameplay creation.',
      results: 'Games with 3-5 simple, well-defined mechanics showed highest emergent gameplay scores.',
      conclusions: 'Complexity should emerge from player interaction, not from complex individual mechanics.',
      status: ExperimentStatus.analyzing,
      impactScore: 7,
      tags: ['Mechanics', 'Emergence', 'Gameplay'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🧪 Jam Lab'),
        backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
        bottom: TabBar(
          onTap: (index) => setState(() => _selectedTabIndex = index),
          tabs: const [
            Tab(text: '🔬 Experiments'),
            Tab(text: '📊 Research'),
            Tab(text: '🎯 Insights'),
            Tab(text: '👨‍🔬 Researchers'),
          ],
        ),
      ),
      body: IndexedStack(
        index: _selectedTabIndex,
        children: [
          _buildExperimentsTab(),
          _buildResearchTab(),
          _buildInsightsTab(),
          _buildResearchersTab(),
        ],
      ),
    );
  }

  Widget _buildExperimentsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: experiments.length,
      itemBuilder: (context, index) {
        final experiment = experiments[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _getExperimentTypeColor(experiment.experimentType, Theme.of(context).colorScheme),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getExperimentTypeIcon(experiment.experimentType),
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            experiment.title,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            experiment.description,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(experiment.status, Theme.of(context).colorScheme),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getStatusText(experiment.status),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Researcher info
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      child: Text(
                        experiment.researcher.displayName[0],
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          experiment.researcher.displayName,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '🔬 ${experiment.researcher.researchPoints} research points',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Hypothesis and Methodology
                Text(
                  'Hypothesis',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  experiment.hypothesis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                Text(
                  'Methodology',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  experiment.methodology,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                // Results and Conclusions (if available)
                if (experiment.results != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Results',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    experiment.results!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],

                if (experiment.conclusions != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Conclusions',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    experiment.conclusions!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],

                const SizedBox(height: 16),

                // Impact Score and Tags
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '🎯 Impact: ${experiment.impactScore}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    ...experiment.tags.take(2).map((tag) => Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Chip(
                        label: Text(tag),
                        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                        labelStyle: Theme.of(context).textTheme.bodySmall,
                      ),
                    )),
                  ],
                ),
                const SizedBox(height: 16),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // View full experiment functionality
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('View full experiment coming soon!')),
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
                          // Apply insights functionality
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Apply insights coming soon!')),
                          );
                        },
                        icon: const Icon(Icons.science),
                        label: const Text('Apply'),
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

  Widget _buildResearchTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📊 Research Analytics',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Active Experiments',
                          '12',
                          Icons.science,
                          Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          'Completed',
                          '45',
                          Icons.check_circle,
                          Colors.green,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          'Impact Score',
                          '8.7',
                          Icons.trending_up,
                          Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Research Areas',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: ExperimentType.values.map((type) {
              return Card(
                child: InkWell(
                  onTap: () {
                    // Filter by experiment type functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Filter by ${type.name} coming soon!')),
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _getExperimentTypeIcon(type),
                          size: 32,
                          color: _getExperimentTypeColor(type, Theme.of(context).colorScheme),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _getExperimentTypeName(type),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightsTab() {
    // Mock insights data
    final insights = [
      {
        'title': 'AI Narrative Generation',
        'insight': 'Players prefer AI-generated stories when they have meaningful choices that affect the narrative.',
        'impact': 'High',
        'category': 'Narrative',
      },
      {
        'title': 'Accessibility Design',
        'insight': 'Games designed with accessibility in mind from the start have 23% higher player retention.',
        'impact': 'Medium',
        'category': 'Accessibility',
      },
      {
        'title': 'Emergent Mechanics',
        'insight': 'Simple mechanics with clear feedback loops create the most engaging emergent gameplay.',
        'impact': 'High',
        'category': 'Mechanics',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: insights.length,
      itemBuilder: (context, index) {
        final insight = insights[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        insight['title'] as String,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getImpactColor(insight['impact'] as String, Theme.of(context).colorScheme),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        insight['impact'] as String,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  insight['insight'] as String,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 12),
                Chip(
                  label: Text(insight['category'] as String),
                  backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildResearchersTab() {
    // Mock researchers data
    final researchers = [
      const CommunityMember(
        id: 'researcher1',
        username: 'NarrativeAI',
        displayName: 'Dr. Story Weaver',
        role: CommunityRole.labScientist,
        researchPoints: 2500,
        badges: ['🧪 Lab Scientist', '📚 Narrative Expert', '🤖 AI Researcher'],
      ),
      const CommunityMember(
        id: 'researcher2',
        username: 'AccessGamer',
        displayName: 'Accessibility Advocate',
        role: CommunityRole.researcher,
        researchPoints: 1800,
        badges: ['♿ Accessibility Expert', '🎮 UX Researcher'],
      ),
      const CommunityMember(
        id: 'researcher3',
        username: 'EmergentDev',
        displayName: 'Emergence Expert',
        role: CommunityRole.labScientist,
        researchPoints: 3200,
        badges: ['🧪 Lab Scientist', '🎯 Mechanics Expert', '🔬 Research Lead'],
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: researchers.length,
      itemBuilder: (context, index) {
        final researcher = researchers[index];
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
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      child: Text(
                        researcher.displayName[0],
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
                            researcher.displayName,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '@${researcher.username}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '🔬 ${researcher.researchPoints} research points',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.verified,
                      color: Theme.of(context).colorScheme.primary,
                      size: 24,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: researcher.badges.map((badge) {
                    return Chip(
                      label: Text(badge),
                      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                      labelStyle: Theme.of(context).textTheme.bodySmall,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // View researcher profile functionality
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('View researcher profile coming soon!')),
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
                          // Follow researcher functionality
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Follow researcher coming soon!')),
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

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getExperimentTypeColor(ExperimentType type, ColorScheme colorScheme) {
    switch (type) {
      case ExperimentType.mechanics:
        return Colors.blue;
      case ExperimentType.psychology:
        return Colors.purple;
      case ExperimentType.accessibility:
        return Colors.green;
      case ExperimentType.monetization:
        return Colors.orange;
      case ExperimentType.social:
        return Colors.pink;
      case ExperimentType.ai:
        return Colors.indigo;
      case ExperimentType.narrative:
        return Colors.teal;
      case ExperimentType.visual:
        return Colors.amber;
      case ExperimentType.audio:
        return Colors.cyan;
      case ExperimentType.performance:
        return Colors.red;
      case ExperimentType.crossPlatform:
        return Colors.lime;
      case ExperimentType.emergingTech:
        return Colors.deepPurple;
    }
  }

  IconData _getExperimentTypeIcon(ExperimentType type) {
    switch (type) {
      case ExperimentType.mechanics:
        return Icons.sports_esports;
      case ExperimentType.psychology:
        return Icons.psychology;
      case ExperimentType.accessibility:
        return Icons.accessibility;
      case ExperimentType.monetization:
        return Icons.attach_money;
      case ExperimentType.social:
        return Icons.people;
      case ExperimentType.ai:
        return Icons.smart_toy;
      case ExperimentType.narrative:
        return Icons.book;
      case ExperimentType.visual:
        return Icons.palette;
      case ExperimentType.audio:
        return Icons.music_note;
      case ExperimentType.performance:
        return Icons.speed;
      case ExperimentType.crossPlatform:
        return Icons.devices;
      case ExperimentType.emergingTech:
        return Icons.science;
    }
  }

  String _getExperimentTypeName(ExperimentType type) {
    switch (type) {
      case ExperimentType.mechanics:
        return 'Mechanics';
      case ExperimentType.psychology:
        return 'Psychology';
      case ExperimentType.accessibility:
        return 'Accessibility';
      case ExperimentType.monetization:
        return 'Monetization';
      case ExperimentType.social:
        return 'Social';
      case ExperimentType.ai:
        return 'AI';
      case ExperimentType.narrative:
        return 'Narrative';
      case ExperimentType.visual:
        return 'Visual';
      case ExperimentType.audio:
        return 'Audio';
      case ExperimentType.performance:
        return 'Performance';
      case ExperimentType.crossPlatform:
        return 'Cross-Platform';
      case ExperimentType.emergingTech:
        return 'Emerging Tech';
    }
  }

  Color _getStatusColor(ExperimentStatus status, ColorScheme colorScheme) {
    switch (status) {
      case ExperimentStatus.planning:
        return Colors.grey;
      case ExperimentStatus.inProgress:
        return colorScheme.primary;
      case ExperimentStatus.analyzing:
        return colorScheme.secondary;
      case ExperimentStatus.completed:
        return Colors.green;
      case ExperimentStatus.published:
        return Colors.blue;
      case ExperimentStatus.failed:
        return Colors.red;
    }
  }

  String _getStatusText(ExperimentStatus status) {
    switch (status) {
      case ExperimentStatus.planning:
        return '📋 Planning';
      case ExperimentStatus.inProgress:
        return '🔬 In Progress';
      case ExperimentStatus.analyzing:
        return '📊 Analyzing';
      case ExperimentStatus.completed:
        return '✅ Completed';
      case ExperimentStatus.published:
        return '📄 Published';
      case ExperimentStatus.failed:
        return '❌ Failed';
    }
  }

  Color _getImpactColor(String impact, ColorScheme colorScheme) {
    switch (impact.toLowerCase()) {
      case 'high':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.grey;
      default:
        return colorScheme.primary;
    }
  }
} 