import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/ai/enhanced_ai_providers.dart';

class AIPersonalizationScreen extends ConsumerStatefulWidget {
  const AIPersonalizationScreen({super.key});

  @override
  ConsumerState<AIPersonalizationScreen> createState() => _AIPersonalizationScreenState();
}

class _AIPersonalizationScreenState extends ConsumerState<AIPersonalizationScreen> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final aiService = ref.watch(enhancedAIServiceProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Personalisierung'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: aiService.getPersonalizationSettings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          final personalizationData = snapshot.data ?? {};
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Profile Section
                _buildUserProfileSection(personalizationData),
                
                const SizedBox(height: 24),
                
                // Learning Preferences Section
                _buildLearningPreferencesSection(personalizationData),
                
                const SizedBox(height: 24),
                
                // AI Interaction Preferences
                _buildInteractionPreferencesSection(personalizationData),
                
                const SizedBox(height: 24),
                
                // Content Preferences
                _buildContentPreferencesSection(personalizationData),
                
                const SizedBox(height: 24),
                
                // Privacy & Security
                _buildPrivacySection(personalizationData),
                
                const SizedBox(height: 32),
                
                // Save Button
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

  Widget _buildUserProfileSection(Map<String, dynamic> data) {
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
            
            // Expertise Level
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Expertise Level',
                border: OutlineInputBorder(),
              ),
              value: data['expertise_level'] ?? 'intermediate',
              items: const [
                DropdownMenuItem(value: 'beginner', child: Text('Beginner')),
                DropdownMenuItem(value: 'intermediate', child: Text('Intermediate')),
                DropdownMenuItem(value: 'advanced', child: Text('Advanced')),
                DropdownMenuItem(value: 'expert', child: Text('Expert')),
              ],
              onChanged: (value) => _updatePersonalization('expertise_level', value),
            ),
            
            const SizedBox(height: 16),
            
            // Preferred Language
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Preferred Language',
                border: OutlineInputBorder(),
              ),
              value: data['preferred_language'] ?? 'english',
              items: const [
                DropdownMenuItem(value: 'english', child: Text('English')),
                DropdownMenuItem(value: 'german', child: Text('German')),
                DropdownMenuItem(value: 'mixed', child: Text('Mixed (English/German)')),
              ],
              onChanged: (value) => _updatePersonalization('preferred_language', value),
            ),
            
            const SizedBox(height: 16),
            
            // Development Focus
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Primary Development Focus',
                border: OutlineInputBorder(),
              ),
              value: data['development_focus'] ?? 'game_development',
              items: const [
                DropdownMenuItem(value: 'game_development', child: Text('Game Development')),
                DropdownMenuItem(value: '3d_applications', child: Text('3D Applications')),
                DropdownMenuItem(value: 'media_production', child: Text('Media Production')),
                DropdownMenuItem(value: 'general', child: Text('General')),
              ],
              onChanged: (value) => _updatePersonalization('development_focus', value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLearningPreferencesSection(Map<String, dynamic> data) {
    final learningPreferences = data['learning_preferences'] as Map<String, dynamic>? ?? {};
    
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
            
            // Learning Style
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Learning Style',
                border: OutlineInputBorder(),
              ),
              value: learningPreferences['learning_style'] ?? 'visual',
              items: const [
                DropdownMenuItem(value: 'visual', child: Text('Visual')),
                DropdownMenuItem(value: 'auditory', child: Text('Auditory')),
                DropdownMenuItem(value: 'kinesthetic', child: Text('Hands-on')),
                DropdownMenuItem(value: 'mixed', child: Text('Mixed')),
              ],
              onChanged: (value) => _updateLearningPreference('learning_style', value),
            ),
            
            const SizedBox(height: 16),
            
            // Detail Level
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Preferred Detail Level',
                border: OutlineInputBorder(),
              ),
              value: learningPreferences['detail_level'] ?? 'moderate',
              items: const [
                DropdownMenuItem(value: 'minimal', child: Text('Minimal (Quick answers)')),
                DropdownMenuItem(value: 'moderate', child: Text('Moderate (Balanced)')),
                DropdownMenuItem(value: 'detailed', child: Text('Detailed (Comprehensive)')),
                DropdownMenuItem(value: 'expert', child: Text('Expert (Deep technical)')),
              ],
              onChanged: (value) => _updateLearningPreference('detail_level', value),
            ),
            
            const SizedBox(height: 16),
            
            // Code Examples Preference
            SwitchListTile(
              title: const Text('Include Code Examples'),
              subtitle: const Text('Show practical code snippets in responses'),
              value: learningPreferences['include_code_examples'] ?? true,
              onChanged: (value) => _updateLearningPreference('include_code_examples', value),
            ),
            
            SwitchListTile(
              title: const Text('Step-by-Step Explanations'),
              subtitle: const Text('Break down complex concepts into steps'),
              value: learningPreferences['step_by_step_explanations'] ?? true,
              onChanged: (value) => _updateLearningPreference('step_by_step_explanations', value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractionPreferencesSection(Map<String, dynamic> data) {
    final interactionPreferences = data['interaction_preferences'] as Map<String, dynamic>? ?? {};
    
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.chat, color: Colors.orange[600]),
                const SizedBox(width: 8),
                const Text(
                  'AI Interaction Preferences',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Response Style
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Response Style',
                border: OutlineInputBorder(),
              ),
              value: interactionPreferences['response_style'] ?? 'friendly',
              items: const [
                DropdownMenuItem(value: 'formal', child: Text('Formal')),
                DropdownMenuItem(value: 'friendly', child: Text('Friendly')),
                DropdownMenuItem(value: 'casual', child: Text('Casual')),
                DropdownMenuItem(value: 'technical', child: Text('Technical')),
              ],
              onChanged: (value) => _updateInteractionPreference('response_style', value),
            ),
            
            const SizedBox(height: 16),
            
            // Proactive Suggestions
            SwitchListTile(
              title: const Text('Proactive Suggestions'),
              subtitle: const Text('AI suggests improvements and alternatives'),
              value: interactionPreferences['proactive_suggestions'] ?? true,
              onChanged: (value) => _updateInteractionPreference('proactive_suggestions', value),
            ),
            
            SwitchListTile(
              title: const Text('Follow-up Questions'),
              subtitle: const Text('AI asks clarifying questions when needed'),
              value: interactionPreferences['follow_up_questions'] ?? true,
              onChanged: (value) => _updateInteractionPreference('follow_up_questions', value),
            ),
            
            SwitchListTile(
              title: const Text('Context Memory'),
              subtitle: const Text('Remember conversation context'),
              value: interactionPreferences['context_memory'] ?? true,
              onChanged: (value) => _updateInteractionPreference('context_memory', value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentPreferencesSection(Map<String, dynamic> data) {
    final contentPreferences = data['content_preferences'] as Map<String, dynamic>? ?? {};
    
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
            
            // Content Types
            const Text(
              'Preferred Content Types',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            
            CheckboxListTile(
              title: const Text('Tutorials & Guides'),
              value: contentPreferences['tutorials'] ?? true,
              onChanged: (value) => _updateContentPreference('tutorials', value),
            ),
            
            CheckboxListTile(
              title: const Text('Code Examples'),
              value: contentPreferences['code_examples'] ?? true,
              onChanged: (value) => _updateContentPreference('code_examples', value),
            ),
            
            CheckboxListTile(
              title: const Text('Best Practices'),
              value: contentPreferences['best_practices'] ?? true,
              onChanged: (value) => _updateContentPreference('best_practices', value),
            ),
            
            CheckboxListTile(
              title: const Text('Troubleshooting'),
              value: contentPreferences['troubleshooting'] ?? true,
              onChanged: (value) => _updateContentPreference('troubleshooting', value),
            ),
            
            CheckboxListTile(
              title: const Text('Industry News'),
              value: contentPreferences['industry_news'] ?? false,
              onChanged: (value) => _updateContentPreference('industry_news', value),
            ),
            
            const SizedBox(height: 16),
            
            // Content Complexity
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Content Complexity',
                border: OutlineInputBorder(),
              ),
              value: contentPreferences['complexity_level'] ?? 'balanced',
              items: const [
                DropdownMenuItem(value: 'simple', child: Text('Simple (Basic concepts)')),
                DropdownMenuItem(value: 'balanced', child: Text('Balanced (Mixed complexity)')),
                DropdownMenuItem(value: 'advanced', child: Text('Advanced (Complex topics)')),
              ],
              onChanged: (value) => _updateContentPreference('complexity_level', value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacySection(Map<String, dynamic> data) {
    final privacySettings = data['privacy_settings'] as Map<String, dynamic>? ?? {};
    
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
              value: privacySettings['data_collection'] ?? true,
              onChanged: (value) => _updatePrivacySetting('data_collection', value),
            ),
            
            SwitchListTile(
              title: const Text('Personalization'),
              subtitle: const Text('Use personal data for customization'),
              value: privacySettings['personalization'] ?? true,
              onChanged: (value) => _updatePrivacySetting('personalization', value),
            ),
            
            SwitchListTile(
              title: const Text('Analytics'),
              subtitle: const Text('Share usage data for improvements'),
              value: privacySettings['analytics'] ?? false,
              onChanged: (value) => _updatePrivacySetting('analytics', value),
            ),
            
            const SizedBox(height: 16),
            
            // Data Retention
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Data Retention Period',
                border: OutlineInputBorder(),
              ),
              value: privacySettings['retention_period'] ?? '30_days',
              items: const [
                DropdownMenuItem(value: '7_days', child: Text('7 Days')),
                DropdownMenuItem(value: '30_days', child: Text('30 Days')),
                DropdownMenuItem(value: '90_days', child: Text('90 Days')),
                DropdownMenuItem(value: '1_year', child: Text('1 Year')),
                DropdownMenuItem(value: 'indefinite', child: Text('Indefinite')),
              ],
              onChanged: (value) => _updatePrivacySetting('retention_period', value),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods for updating preferences
  void _updatePersonalization(String key, dynamic value) {
    final service = ref.read(enhancedAIServiceProvider);
    service.updatePersonalizationSettings({key: value});
  }

  void _updateLearningPreference(String key, dynamic value) {
    final service = ref.read(enhancedAIServiceProvider);
    final currentData = service.getPersonalizationSettings();
    final learningPreferences = Map<String, dynamic>.from(
      currentData['learning_preferences'] as Map<String, dynamic>? ?? {}
    );
    learningPreferences[key] = value;
    service.updatePersonalizationSettings({'learning_preferences': learningPreferences});
  }

  void _updateInteractionPreference(String key, dynamic value) {
    final service = ref.read(enhancedAIServiceProvider);
    final currentData = service.getPersonalizationSettings();
    final interactionPreferences = Map<String, dynamic>.from(
      currentData['interaction_preferences'] as Map<String, dynamic>? ?? {}
    );
    interactionPreferences[key] = value;
    service.updatePersonalizationSettings({'interaction_preferences': interactionPreferences});
  }

  void _updateContentPreference(String key, dynamic value) {
    final service = ref.read(enhancedAIServiceProvider);
    final currentData = service.getPersonalizationSettings();
    final contentPreferences = Map<String, dynamic>.from(
      currentData['content_preferences'] as Map<String, dynamic>? ?? {}
    );
    contentPreferences[key] = value;
    service.updatePersonalizationSettings({'content_preferences': contentPreferences});
  }

  void _updatePrivacySetting(String key, dynamic value) {
    final service = ref.read(enhancedAIServiceProvider);
    final currentData = service.getPersonalizationSettings();
    final privacySettings = Map<String, dynamic>.from(
      currentData['privacy_settings'] as Map<String, dynamic>? ?? {}
    );
    privacySettings[key] = value;
    service.updatePersonalizationSettings({'privacy_settings': privacySettings});
  }

  Future<void> _saveSettings() async {
    final aiService = ref.read(enhancedAIServiceProvider);
    final settings = <String, dynamic>{
      'learning_style': _learningStyle,
      'interaction_preference': _interactionPreference,
      'content_preference': _contentPreference,
      'privacy_level': _privacyLevel,
    };
    await aiService.savePersonalizationSettings(settings);
  }

  Future<void> _resetToDefaults() async {
    final aiService = ref.read(enhancedAIServiceProvider);
    await aiService.resetPersonalizationSettings();
  }
} 