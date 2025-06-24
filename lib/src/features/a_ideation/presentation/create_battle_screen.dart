import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateBattleScreen extends ConsumerStatefulWidget {
  const CreateBattleScreen({super.key});

  @override
  ConsumerState<CreateBattleScreen> createState() => _CreateBattleScreenState();
}

class _CreateBattleScreenState extends ConsumerState<CreateBattleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _themeController = TextEditingController();
  
  String _selectedCategory = 'Game Development';
  String _selectedDifficulty = 'Intermediate';
  String _selectedTeamSize = '1-4 members';
  String _selectedDuration = '7 days';
  final List<String> _selectedPlatforms = [];
  
  final List<String> _categories = [
    'Game Development',
    'App Development',
    'AI Integration',
    '3D Modeling',
    'Web Development',
    'Mobile Development',
  ];
  
  final List<String> _difficulties = [
    'Beginner',
    'Intermediate',
    'Advanced',
    'Expert',
  ];
  
  final List<String> _teamSizes = [
    'Solo (1 member)',
    'Duo (2 members)',
    'Squad (1-4 members)',
    'Crew (5-32 members)',
    'Educational Crew (15-32 members)',
    'Corporate Crew (8-24 members)',
    'Unlimited',
    'Custom',
  ];
  
  final List<String> _durations = [
    '24 hours',
    '48 hours',
    '3 days',
    '5 days',
    '7 days',
    '14 days',
    '30 days',
  ];
  
  final List<String> _platforms = [
    'Unity',
    'Unreal Engine',
    'Flutter',
    'React Native',
    'Web',
    'Mobile',
    'Desktop',
    'VR/AR',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Battle'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _saveDraft,
            child: const Text(
              'Save Draft',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildBasicInfoSection(),
            const SizedBox(height: 24),
            _buildDetailsSection(),
            const SizedBox(height: 24),
            _buildRulesSection(),
            const SizedBox(height: 24),
            _buildPrizesSection(),
            const SizedBox(height: 24),
            _buildTimelineSection(),
            const SizedBox(height: 32),
            _buildActionButtons(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple[400]!, Colors.indigo[400]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.sports_esports,
            color: Colors.white,
            size: 48,
          ),
          const SizedBox(height: 12),
          const Text(
            'Create New Battle',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Set up a new game development challenge for the community',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Basic Information', Icons.info),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Battle Title *',
                hintText: 'Enter a compelling battle title',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a battle title';
                }
                if (value.length < 5) {
                  return 'Title must be at least 5 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _themeController,
              decoration: const InputDecoration(
                labelText: 'Theme *',
                hintText: 'e.g., AI-Powered Adventure Games',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lightbulb),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a theme';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Description *',
                hintText: 'Describe the battle, objectives, and requirements...',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                if (value.length < 50) {
                  return 'Description must be at least 50 characters';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Battle Details', Icons.settings),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedDifficulty,
                    decoration: const InputDecoration(
                      labelText: 'Difficulty',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.trending_up),
                    ),
                    items: _difficulties.map((difficulty) {
                      return DropdownMenuItem(
                        value: difficulty,
                        child: Text(difficulty),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedDifficulty = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedTeamSize,
                    decoration: const InputDecoration(
                      labelText: 'Team Size',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.people),
                    ),
                    items: _teamSizes.map((size) {
                      return DropdownMenuItem(
                        value: size,
                        child: Text(size),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedTeamSize = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedDuration,
                    decoration: const InputDecoration(
                      labelText: 'Duration',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.schedule),
                    ),
                    items: _durations.map((duration) {
                      return DropdownMenuItem(
                        value: duration,
                        child: Text(duration),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedDuration = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Supported Platforms',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _platforms.map((platform) {
                final isSelected = _selectedPlatforms.contains(platform);
                return FilterChip(
                  label: Text(platform),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedPlatforms.add(platform);
                      } else {
                        _selectedPlatforms.remove(platform);
                      }
                    });
                  },
                  selectedColor: Colors.purple.withAlpha(51),
                  checkmarkColor: Colors.purple,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRulesSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Rules & Requirements', Icons.rule),
            const SizedBox(height: 16),
            _buildRuleItem('Original work only - no plagiarism', true),
            _buildRuleItem('AI tools are encouraged and required', true),
            _buildRuleItem('Submit playable prototype or demo', true),
            _buildRuleItem('Include source code and documentation', true),
            _buildRuleItem('Present your project in 3-minute pitch', true),
            _buildRuleItem('Follow community guidelines', true),
            const SizedBox(height: 16),
            TextFormField(
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Additional Rules',
                hintText: 'Add any specific rules or requirements...',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRuleItem(String rule, bool isRequired) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            isRequired ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isRequired ? Colors.green : Colors.grey,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              rule,
              style: TextStyle(
                fontWeight: isRequired ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrizesSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Prizes & Rewards', Icons.emoji_events),
            const SizedBox(height: 16),
            _buildPrizeInput('1st Place', '1000 XP + Premium Badge + \$500'),
            _buildPrizeInput('2nd Place', '750 XP + Silver Badge + \$300'),
            _buildPrizeInput('3rd Place', '500 XP + Bronze Badge + \$200'),
            _buildPrizeInput('Innovation Award', '250 XP + Innovation Badge + \$100'),
            _buildPrizeInput('Community Choice', '100 XP + Community Badge'),
            const SizedBox(height: 16),
            TextFormField(
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Additional Prizes',
                hintText: 'Add any special prizes or rewards...',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrizeInput(String place, String defaultReward) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.amber.withAlpha(25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              place,
              style: const TextStyle(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextFormField(
              initialValue: defaultReward,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Timeline', Icons.schedule),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Registration Start',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.event_available),
                    ),
                    readOnly: true,
                    onTap: () {
                      _selectDate(context);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Battle Start',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.play_arrow),
                    ),
                    readOnly: true,
                    onTap: () {
                      _selectDate(context);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Submission Deadline',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.stop),
                    ),
                    readOnly: true,
                    onTap: () {
                      _selectDate(context);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Results Date',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.emoji_events),
                    ),
                    readOnly: true,
                    onTap: () {
                      _selectDate(context);
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

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.purple, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _saveDraft,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: Colors.purple),
            ),
            child: const Text(
              'Save Draft',
              style: TextStyle(
                color: Colors.purple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _createBattle,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Create Battle',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      // TODO: Handle date selection
    }
  }

  void _saveDraft() {
    // TODO: Save battle as draft
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Draft saved successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _createBattle() {
    if (_formKey.currentState!.validate()) {
      if (_selectedPlatforms.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select at least one platform'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // TODO: Create battle
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Battle created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      
      Navigator.pop(context);
    }
  }
} 