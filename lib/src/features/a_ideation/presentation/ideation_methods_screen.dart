import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/ideation_methods.dart';

class IdeationMethodsScreen extends ConsumerStatefulWidget {
  const IdeationMethodsScreen({super.key});

  @override
  ConsumerState<IdeationMethodsScreen> createState() => _IdeationMethodsScreenState();
}

class _IdeationMethodsScreenState extends ConsumerState<IdeationMethodsScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  IdeationCategory _selectedCategory = IdeationCategory.brainstorming;
  Complexity _selectedComplexity = Complexity.simple;
  Duration _maxDuration = const Duration(minutes: 30);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('💡 Ideation Methods'),
        backgroundColor: colorScheme.primaryContainer,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '🎯 Methods'),
            Tab(text: '🔍 Filter'),
            Tab(text: '📊 Sessions'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMethodsTab(textTheme, colorScheme),
          _buildFilterTab(textTheme, colorScheme),
          _buildSessionsTab(textTheme, colorScheme),
        ],
      ),
    );
  }

  Widget _buildMethodsTab(TextTheme textTheme, ColorScheme colorScheme) {
    final filteredMethods = _getFilteredMethods();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'Creative Ideation Methods',
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Discover proven techniques to generate innovative game concepts for your jam',
                    style: textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Quick Stats
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Methods',
                  '${filteredMethods.length}',
                  Icons.lightbulb,
                  colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'AI Supported',
                  '${filteredMethods.where((m) => m.aiSupport).length}',
                  Icons.psychology,
                  colorScheme.secondary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Avg Success',
                  '${(filteredMethods.map((m) => m.successRate).reduce((a, b) => a + b) / filteredMethods.length * 100).toStringAsFixed(0)}%',
                  Icons.trending_up,
                  colorScheme.tertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Methods Grid
          ...filteredMethods.map((method) => _buildMethodCard(method, textTheme, colorScheme)),
        ],
      ),
    );
  }

  Widget _buildFilterTab(TextTheme textTheme, ColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter Methods',
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Category Filter
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Category',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: IdeationCategory.values.map((category) {
                      final isSelected = _selectedCategory == category;
                      return FilterChip(
                        label: Text(_getCategoryName(category)),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                        backgroundColor: colorScheme.surfaceContainerHighest,
                        selectedColor: colorScheme.primaryContainer,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Complexity Filter
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Complexity',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: Complexity.values.map((complexity) {
                      final isSelected = _selectedComplexity == complexity;
                      return FilterChip(
                        label: Text(_getComplexityName(complexity)),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedComplexity = complexity;
                          });
                        },
                        backgroundColor: colorScheme.surfaceContainerHighest,
                        selectedColor: colorScheme.primaryContainer,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Duration Filter
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Maximum Duration',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Slider(
                    value: _maxDuration.inMinutes.toDouble(),
                    min: 5,
                    max: 60,
                    divisions: 11,
                    label: '${_maxDuration.inMinutes} minutes',
                    onChanged: (value) {
                      setState(() {
                        _maxDuration = Duration(minutes: value.round());
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('5 min', style: textTheme.bodySmall),
                      Text('60 min', style: textTheme.bodySmall),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Quick Filters
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Filters',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ActionChip(
                        label: const Text('AI Supported'),
                        onPressed: () {
                          // Filter for AI supported methods
                        },
                        backgroundColor: colorScheme.secondaryContainer,
                      ),
                      ActionChip(
                        label: const Text('Quick (< 10 min)'),
                        onPressed: () {
                          setState(() {
                            _maxDuration = const Duration(minutes: 10);
                          });
                        },
                        backgroundColor: colorScheme.secondaryContainer,
                      ),
                      ActionChip(
                        label: const Text('Team Methods'),
                        onPressed: () {
                          // Filter for team methods
                        },
                        backgroundColor: colorScheme.secondaryContainer,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionsTab(TextTheme textTheme, ColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Sessions',
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Mock sessions
          ..._getMockSessions().map((session) => _buildSessionCard(session, textTheme, colorScheme)),
        ],
      ),
    );
  }

  Widget _buildMethodCard(IdeationMethod method, TextTheme textTheme, ColorScheme colorScheme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _getCategoryColor(method.category),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getCategoryIcon(method.category),
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
                    method.name,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    method.description,
                    style: textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            children: [
              _buildInfoChip(
                '${method.duration.inMinutes}m',
                _getDurationColor(method.duration),
              ),
              const SizedBox(width: 8),
              _buildInfoChip(
                _getParticipantText(method.participants),
                _getParticipantColor(method.participants),
              ),
              const SizedBox(width: 8),
              _buildInfoChip(
                '${(method.successRate * 100).toStringAsFixed(0)}%',
                _getSuccessColor(method.successRate),
              ),
              if (method.aiSupport) ...[
                const SizedBox(width: 8),
                _buildInfoChip(
                  'AI',
                  Colors.purple,
                ),
              ],
            ],
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Steps
                Text(
                  'Steps:',
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...method.steps.map((step) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            '${step.order}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              step.title,
                              style: textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              step.description,
                              style: textTheme.bodySmall,
                            ),
                            Text(
                              '${step.duration.inMinutes}m',
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),

                // Examples
                if (method.examples.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Examples:',
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...method.examples.map((example) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            example.title,
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            example.description,
                            style: textTheme.bodySmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Result: ${example.result}',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.primary,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
                ],

                // Action Buttons
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _startSession(method),
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Start Session'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _showMethodDetails(method),
                        icon: const Icon(Icons.info),
                        label: const Text('Details'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildSessionCard(IdeationSession session, TextTheme textTheme, ColorScheme colorScheme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getCategoryColor(session.method.category),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getCategoryIcon(session.method.category),
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(session.method.name),
        subtitle: Text(
          '${session.participants.length} participants • ${session.ideas.length} ideas • ${session.duration.inMinutes}m',
        ),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () => _showSessionDetails(session),
        ),
      ),
    );
  }

  List<IdeationMethod> _getFilteredMethods() {
    var methods = GameJamIdeationMethods.methods;

    // Filter by category
    methods = methods.where((m) => m.category == _selectedCategory).toList();

    // Filter by complexity
    methods = methods.where((m) => m.complexity == _selectedComplexity).toList();

    // Filter by duration
    methods = methods.where((m) => m.duration <= _maxDuration).toList();

    return methods;
  }

  List<IdeationSession> _getMockSessions() {
    return [
      IdeationSession(
        id: 'session-1',
        method: GameJamIdeationMethods.methods[0], // Crazy 8s
        participants: ['Alice', 'Bob', 'Charlie'],
        startTime: DateTime.now().subtract(const Duration(hours: 2)),
        duration: const Duration(minutes: 8),
        ideas: [
          GeneratedIdea(
            id: 'idea-1',
            title: 'Gravity Shift',
            description: 'Platformer where players control gravity direction',
            method: 'Crazy 8s',
            participants: ['Alice'],
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
            rating: 8,
            tags: ['platformer', 'puzzle', 'gravity'],
          ),
        ],
      ),
      IdeationSession(
        id: 'session-2',
        method: GameJamIdeationMethods.methods[1], // Constraint Challenge
        participants: ['David', 'Eve', 'Frank'],
        startTime: DateTime.now().subtract(const Duration(days: 1)),
        duration: const Duration(minutes: 15),
        ideas: [
          GeneratedIdea(
            id: 'idea-2',
            title: 'Circle World',
            description: 'Everything is made of circles - even the player',
            method: 'Constraint Challenge',
            participants: ['David', 'Eve'],
            timestamp: DateTime.now().subtract(const Duration(days: 1)),
            rating: 7,
            tags: ['constraint', 'circles', 'unique'],
          ),
        ],
      ),
    ];
  }

  void _startSession(IdeationMethod method) {
    // Navigate to session screen
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Start ${method.name} Session'),
        content: Text('Are you ready to begin? This will take ${method.duration.inMinutes} minutes.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Start session logic
            },
            child: const Text('Start'),
          ),
        ],
      ),
    );
  }

  void _showMethodDetails(IdeationMethod method) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(method.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(method.description),
              const SizedBox(height: 16),
              Text('Duration: ${method.duration.inMinutes} minutes'),
              Text('Participants: ${_getParticipantText(method.participants)}'),
              Text('Success Rate: ${(method.successRate * 100).toStringAsFixed(0)}%'),
              if (method.materials.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text('Materials: ${method.materials.join(', ')}'),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showSessionDetails(IdeationSession session) {
    // Show detailed session information
  }

  // Helper methods for UI
  String _getCategoryName(IdeationCategory category) {
    switch (category) {
      case IdeationCategory.brainstorming: return 'Brainstorming';
      case IdeationCategory.constraintBased: return 'Constraints';
      case IdeationCategory.randomStimulation: return 'Random';
      case IdeationCategory.analogy: return 'Analogy';
      case IdeationCategory.collaboration: return 'Collaboration';
      case IdeationCategory.research: return 'Research';
      case IdeationCategory.experimental: return 'Experimental';
      case IdeationCategory.gamification: return 'Gamification';
    }
  }

  String _getComplexityName(Complexity complexity) {
    switch (complexity) {
      case Complexity.simple: return 'Simple';
      case Complexity.moderate: return 'Moderate';
      case Complexity.advanced: return 'Advanced';
      case Complexity.expert: return 'Expert';
    }
  }

  Color _getCategoryColor(IdeationCategory category) {
    switch (category) {
      case IdeationCategory.brainstorming: return Colors.blue;
      case IdeationCategory.constraintBased: return Colors.green;
      case IdeationCategory.randomStimulation: return Colors.orange;
      case IdeationCategory.analogy: return Colors.purple;
      case IdeationCategory.collaboration: return Colors.pink;
      case IdeationCategory.research: return Colors.indigo;
      case IdeationCategory.experimental: return Colors.red;
      case IdeationCategory.gamification: return Colors.teal;
    }
  }

  IconData _getCategoryIcon(IdeationCategory category) {
    switch (category) {
      case IdeationCategory.brainstorming: return Icons.lightbulb;
      case IdeationCategory.constraintBased: return Icons.block;
      case IdeationCategory.randomStimulation: return Icons.shuffle;
      case IdeationCategory.analogy: return Icons.compare_arrows;
      case IdeationCategory.collaboration: return Icons.people;
      case IdeationCategory.research: return Icons.search;
      case IdeationCategory.experimental: return Icons.science;
      case IdeationCategory.gamification: return Icons.sports_esports;
    }
  }

  String _getParticipantText(ParticipantRange range) {
    switch (range) {
      case ParticipantRange.solo: return '1';
      case ParticipantRange.small: return '2-4';
      case ParticipantRange.medium: return '5-8';
      case ParticipantRange.large: return '9-15';
      case ParticipantRange.massive: return '15+';
    }
  }

  Color _getParticipantColor(ParticipantRange range) {
    switch (range) {
      case ParticipantRange.solo: return Colors.grey;
      case ParticipantRange.small: return Colors.green;
      case ParticipantRange.medium: return Colors.blue;
      case ParticipantRange.large: return Colors.orange;
      case ParticipantRange.massive: return Colors.red;
    }
  }

  Color _getDurationColor(Duration duration) {
    if (duration.inMinutes <= 10) return Colors.green;
    if (duration.inMinutes <= 20) return Colors.orange;
    return Colors.red;
  }

  Color _getSuccessColor(double rate) {
    if (rate >= 0.8) return Colors.green;
    if (rate >= 0.6) return Colors.orange;
    return Colors.red;
  }
} 