import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/ai/enhanced_ai_providers.dart';

class AIPersonalizationScreen extends ConsumerStatefulWidget {
  const AIPersonalizationScreen({super.key});

  @override
  ConsumerState<AIPersonalizationScreen> createState() =>
      _AIPersonalizationScreenState();
}

class _AIPersonalizationScreenState
    extends ConsumerState<AIPersonalizationScreen> {
  Map<String, dynamic>? _personalizationData;

  @override
  Widget build(BuildContext context) {
    final aiService = ref.watch(enhancedAIServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Personalisierung'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            onPressed: _resetToDefaults,
            tooltip: 'Reset to Defaults',
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: aiService.getPersonalizationSettings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              _personalizationData == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData && _personalizationData == null) {
            _personalizationData = snapshot.data;
          }

          if (_personalizationData == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Could not load settings.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => setState(() {}),
                    child: const Text('Retry'),
                  )
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserProfileSection(),
                const SizedBox(height: 24),
                _buildLearningPreferencesSection(),
                const SizedBox(height: 24),
                _buildInteractionPreferencesSection(),
                const SizedBox(height: 24),
                _buildContentPreferencesSection(),
                const SizedBox(height: 24),
                _buildPrivacySection(),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveSettings,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Save Personalization Settings',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserProfileSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, color: Colors.blue[600]),
                const SizedBox(width: 8),
                const Text(
                  'User Profile',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Expertise Level',
                border: OutlineInputBorder(),
              ),
              value: _personalizationData!['expertise_level'] as String? ??
                  'intermediate',
              items: const [
                DropdownMenuItem(value: 'beginner', child: Text('Beginner')),
                DropdownMenuItem(
                    value: 'intermediate', child: Text('Intermediate')),
                DropdownMenuItem(value: 'advanced', child: Text('Advanced')),
                DropdownMenuItem(value: 'expert', child: Text('Expert')),
              ],
              onChanged: (value) =>
                  setState(() => _personalizationData!['expertise_level'] = value),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Preferred Language',
                border: OutlineInputBorder(),
              ),
              value: _personalizationData!['preferred_language'] as String? ??
                  'english',
              items: const [
                DropdownMenuItem(value: 'english', child: Text('English')),
                DropdownMenuItem(value: 'german', child: Text('German')),
                DropdownMenuItem(
                    value: 'mixed', child: Text('Mixed (English/German)')),
              ],
              onChanged: (value) => setState(
                  () => _personalizationData!['preferred_language'] = value),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Primary Development Focus',
                border: OutlineInputBorder(),
              ),
              value: _personalizationData!['development_focus'] as String? ??
                  'game_development',
              items: const [
                DropdownMenuItem(
                    value: 'game_development',
                    child: Text('Game Development')),
                DropdownMenuItem(
                    value: '3d_applications', child: Text('3D Applications')),
                DropdownMenuItem(
                    value: 'media_production', child: Text('Media Production')),
                DropdownMenuItem(value: 'general', child: Text('General')),
              ],
              onChanged: (value) => setState(
                  () => _personalizationData!['development_focus'] = value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLearningPreferencesSection() {
    final learningPreferences = Map<String, dynamic>.from(
        _personalizationData!['learning_preferences'] ?? {});

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.school, color: Colors.green[600]),
                const SizedBox(width: 8),
                const Text(
                  'Learning Preferences',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Learning Style',
                border: OutlineInputBorder(),
              ),
              value:
                  learningPreferences['learning_style'] as String? ?? 'visual',
              items: const [
                DropdownMenuItem(value: 'visual', child: Text('Visual')),
                DropdownMenuItem(value: 'auditory', child: Text('Auditory')),
                DropdownMenuItem(
                    value: 'kinesthetic', child: Text('Hands-on')),
                DropdownMenuItem(value: 'mixed', child: Text('Mixed')),
              ],
              onChanged: (value) =>
                  setState(() => learningPreferences['learning_style'] = value),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Pacing Preference',
                border: OutlineInputBorder(),
              ),
              value: learningPreferences['pacing'] as String? ?? 'self_paced',
              items: const [
                DropdownMenuItem(
                    value: 'self_paced', child: Text('Self-paced')),
                DropdownMenuItem(
                    value: 'structured', child: Text('Structured')),
              ],
              onChanged: (value) =>
                  setState(() => learningPreferences['pacing'] = value),
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text('Prefer video content'),
              value: learningPreferences['prefer_video'] as bool? ?? false,
              onChanged: (value) =>
                  setState(() => learningPreferences['prefer_video'] = value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractionPreferencesSection() {
    final interactionPreferences = Map<String, dynamic>.from(
        _personalizationData!['interaction_preferences'] ?? {});

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.touch_app, color: Colors.orange[600]),
                const SizedBox(width: 8),
                const Text(
                  'AI Interaction Preferences',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Communication Style',
                border: OutlineInputBorder(),
              ),
              value: interactionPreferences['communication_style'] as String? ??
                  'neutral',
              items: const [
                DropdownMenuItem(value: 'formal', child: Text('Formal')),
                DropdownMenuItem(value: 'neutral', child: Text('Neutral')),
                DropdownMenuItem(value: 'friendly', child: Text('Friendly')),
              ],
              onChanged: (value) => setState(
                  () => interactionPreferences['communication_style'] = value),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Response Verbosity',
                border: OutlineInputBorder(),
              ),
              value:
                  interactionPreferences['verbosity'] as String? ?? 'balanced',
              items: const [
                DropdownMenuItem(value: 'concise', child: Text('Concise')),
                DropdownMenuItem(value: 'balanced', child: Text('Balanced')),
                DropdownMenuItem(value: 'detailed', child: Text('Detailed')),
              ],
              onChanged: (value) =>
                  setState(() => interactionPreferences['verbosity'] = value),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Proactive Suggestions'),
              subtitle: const Text('Allow AI to make suggestions'),
              value: interactionPreferences['proactive_suggestions'] as bool? ??
                  true,
              onChanged: (value) => setState(() =>
                  interactionPreferences['proactive_suggestions'] = value),
            ),
            SwitchListTile(
              title: const Text('Use Emojis'),
              subtitle: const Text('Allow AI to use emojis in responses'),
              value: interactionPreferences['use_emojis'] as bool? ?? false,
              onChanged: (value) =>
                  setState(() => interactionPreferences['use_emojis'] = value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentPreferencesSection() {
    final contentPreferences = Map<String, dynamic>.from(
        _personalizationData!['content_preferences'] ?? {});

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.content_paste, color: Colors.purple[600]),
                const SizedBox(width: 8),
                const Text(
                  'Content Preferences',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Preferred Content Types',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            CheckboxListTile(
              title: const Text('Tutorials & Guides'),
              value: contentPreferences['tutorials'] as bool? ?? true,
              onChanged: (value) =>
                  setState(() => contentPreferences['tutorials'] = value),
            ),
            CheckboxListTile(
              title: const Text('Code Examples'),
              value: contentPreferences['code_examples'] as bool? ?? true,
              onChanged: (value) =>
                  setState(() => contentPreferences['code_examples'] = value),
            ),
            CheckboxListTile(
              title: const Text('Best Practices'),
              value: contentPreferences['best_practices'] as bool? ?? true,
              onChanged: (value) =>
                  setState(() => contentPreferences['best_practices'] = value),
            ),
            CheckboxListTile(
              title: const Text('Troubleshooting'),
              value: contentPreferences['troubleshooting'] as bool? ?? true,
              onChanged: (value) =>
                  setState(() => contentPreferences['troubleshooting'] = value),
            ),
            CheckboxListTile(
              title: const Text('Industry News'),
              value: contentPreferences['industry_news'] as bool? ?? false,
              onChanged: (value) =>
                  setState(() => contentPreferences['industry_news'] = value),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Content Complexity',
                border: OutlineInputBorder(),
              ),
              value: contentPreferences['complexity_level'] as String? ??
                  'balanced',
              items: const [
                DropdownMenuItem(
                    value: 'simple', child: Text('Simple (Basic concepts)')),
                DropdownMenuItem(
                    value: 'balanced',
                    child: Text('Balanced (Mixed complexity)')),
                DropdownMenuItem(
                    value: 'advanced',
                    child: Text('Advanced (Complex topics)')),
              ],
              onChanged: (value) => setState(
                  () => contentPreferences['complexity_level'] = value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacySection() {
    final privacySettings =
        Map<String, dynamic>.from(_personalizationData!['privacy_settings'] ?? {});

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.privacy_tip, color: Colors.red[600]),
                const SizedBox(width: 8),
                const Text(
                  'Privacy & Security',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Data Collection'),
              subtitle: const Text('Allow AI to learn from your interactions'),
              value: privacySettings['data_collection'] as bool? ?? true,
              onChanged: (value) =>
                  setState(() => privacySettings['data_collection'] = value),
            ),
            SwitchListTile(
              title: const Text('Personalization'),
              subtitle: const Text('Use personal data for customization'),
              value: privacySettings['personalization'] as bool? ?? true,
              onChanged: (value) =>
                  setState(() => privacySettings['personalization'] = value),
            ),
            SwitchListTile(
              title: const Text('Analytics'),
              subtitle: const Text('Share usage data for improvements'),
              value: privacySettings['analytics'] as bool? ?? false,
              onChanged: (value) =>
                  setState(() => privacySettings['analytics'] = value),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Data Retention Period',
                border: OutlineInputBorder(),
              ),
              value:
                  privacySettings['retention_period'] as String? ?? '30_days',
              items: const [
                DropdownMenuItem(value: '7_days', child: Text('7 Days')),
                DropdownMenuItem(value: '30_days', child: Text('30 Days')),
                DropdownMenuItem(value: '90_days', child: Text('90 Days')),
                DropdownMenuItem(value: '1_year', child: Text('1 Year')),
                DropdownMenuItem(
                    value: 'indefinite', child: Text('Indefinite')),
              ],
              onChanged: (value) =>
                  setState(() => privacySettings['retention_period'] = value),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveSettings() async {
    if (_personalizationData == null) return;

    final aiService = ref.read(enhancedAIServiceProvider);
    try {
      await aiService.updatePersonalizationSettings(_personalizationData!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Settings saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving settings: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _resetToDefaults() async {
    final aiService = ref.read(enhancedAIServiceProvider);
    try {
      await aiService.resetPersonalizationSettings();
      setState(() {
        _personalizationData = null;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Settings reset to defaults.'),
            backgroundColor: Colors.blue,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error resetting settings: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
} 