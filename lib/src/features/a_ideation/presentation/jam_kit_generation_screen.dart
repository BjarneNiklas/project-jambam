import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_jambam/src/features/a_ideation/presentation/jam_kit_generation_controller.dart';
import 'package:project_jambam/src/features/a_ideation/presentation/jam_kit_results_screen.dart';
import '../application/concept_generation_service.dart';
import 'package:project_jambam/src/features/asset_generation/asset_generation_screen.dart';
import 'package:project_jambam/src/features/a_ideation/domain/jam_kit.dart';

// Create a provider for the agent configuration
final agentConfigProvider = StateNotifierProvider<AgentConfigNotifier, AgentConfig>((ref) {
  return AgentConfigNotifier();
});

class AgentConfig {
  const AgentConfig({this.useMechanics = true, this.useMonetization = true});
  final bool useMechanics;
  final bool useMonetization;

  AgentConfig copyWith({bool? useMechanics, bool? useMonetization}) {
    return AgentConfig(
      useMechanics: useMechanics ?? this.useMechanics,
      useMonetization: useMonetization ?? this.useMonetization,
    );
  }
}

class AgentConfigNotifier extends StateNotifier<AgentConfig> {
  AgentConfigNotifier() : super(const AgentConfig());

  void setUseMechanics(bool value) {
    state = state.copyWith(useMechanics: value);
  }

  void setUseMonetization(bool value) {
    state = state.copyWith(useMonetization: value);
  }
}

class JamKitGenerationScreen extends ConsumerStatefulWidget {
  const JamKitGenerationScreen({super.key});

  @override
  ConsumerState<JamKitGenerationScreen> createState() => _JamKitGenerationScreenState();
}

class _JamKitGenerationScreenState extends ConsumerState<JamKitGenerationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _keywordsController = TextEditingController();
  final _inspirationController = TextEditingController();
  
  String _selectedInspirationMode = 'creative';
  GenerationMode _selectedMode = GenerationMode.jamKit;
  bool _useMechanics = true;
  bool _useMonetization = true;
  bool _showAdvancedSettings = false;

  @override
  void dispose() {
    _keywordsController.dispose();
    _inspirationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(jamKitGenerationControllerProvider.notifier);
    final state = ref.watch(jamKitGenerationControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Jam Kit'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => setState(() => _showAdvancedSettings = !_showAdvancedSettings),
            tooltip: 'Advanced Settings',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              _buildHeader(context),
              const SizedBox(height: 24),

              // Keywords Input
              _buildKeywordsInput(context),
              const SizedBox(height: 16),

              // Inspiration Mode
              _buildInspirationModeSelector(context),
              const SizedBox(height: 16),

              // Generation Mode
              _buildGenerationModeSelector(),
              const SizedBox(height: 16),

              // Advanced Settings
              if (_showAdvancedSettings) ...[
                _buildAdvancedSettings(context),
                const SizedBox(height: 16),
              ],

              // Generate Button
              _buildGenerateButton(context, controller, state),
              const SizedBox(height: 24),

              // Results
              if (state.isLoading) _buildLoadingIndicator(),
              if (state.hasError) _buildErrorWidget(state.error.toString()),
              if (state.hasValue && state.value != null) _buildResults(context, state.value!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Icon(
              Icons.auto_awesome,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'AI-Powered Jam Kit Generation',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Generate complete game concepts with our multi-agent AI system',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeywordsInput(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Keywords & Inspiration',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _keywordsController,
              decoration: const InputDecoration(
                labelText: 'Keywords (comma-separated)',
                hintText: 'e.g., cyberpunk, gardening, time travel, puzzle',
                prefixIcon: Icon(Icons.tag),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter some keywords';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _inspirationController,
              decoration: const InputDecoration(
                labelText: 'Additional Inspiration (optional)',
                hintText: 'Any specific ideas, themes, or references...',
                prefixIcon: Icon(Icons.lightbulb),
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInspirationModeSelector(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Inspiration Mode',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('Creative'),
                  selected: _selectedInspirationMode == 'creative',
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedInspirationMode = 'creative');
                    }
                  },
                ),
                ChoiceChip(
                  label: const Text('Analytical'),
                  selected: _selectedInspirationMode == 'analytical',
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedInspirationMode = 'analytical');
                    }
                  },
                ),
                ChoiceChip(
                  label: const Text('Experimental'),
                  selected: _selectedInspirationMode == 'experimental',
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedInspirationMode = 'experimental');
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenerationModeSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🎯 Wähle deinen Generierungsmodus',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Jam Kit Option
            _buildModeOption(
              title: '🎮 Jam Kit',
              subtitle: 'Vollständiges Game Development Kit',
              description: 'Detaillierte Spezifikationen, Monetarisierung, Technische Architektur',
              duration: '2-4 Wochen Entwicklung',
              target: 'Professionelle Entwickler & Studios',
              isSelected: _selectedMode == GenerationMode.jamKit,
              onTap: () => setState(() => _selectedMode = GenerationMode.jamKit),
              color: Colors.blue,
            ),
            
            const SizedBox(height: 12),
            
            // Jam Seed Option
            _buildModeOption(
              title: '🌱 Jam Seed',
              subtitle: 'Der Keim einer Idee',
              description: 'Ein kleiner Anfangspunkt, aus dem etwas Großes entstehen kann. Perfekt für Community-Experimente und kreative Evolution.',
              duration: '1-2 Wochen Entwicklung',
              target: 'Indie-Entwickler & Community',
              isSelected: _selectedMode == GenerationMode.jamSeed,
              onTap: () => setState(() => _selectedMode = GenerationMode.jamSeed),
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeOption({
    required String title,
    required String subtitle,
    required String description,
    required String duration,
    required String target,
    required bool isSelected,
    required VoidCallback onTap,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : null,
          border: Border.all(
            color: isSelected ? color : Colors.grey.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isSelected ? Icons.check : Icons.arrow_forward,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? color : null,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.schedule, size: 14, color: color),
                      const SizedBox(width: 4),
                      Text(
                        duration,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.people, size: 14, color: color),
                      const SizedBox(width: 4),
                      Text(
                        target,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedSettings(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Advanced Settings',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            // Agent Toggles
            _buildAgentToggle(
              context,
              title: 'Include Mechanics Agent',
              subtitle: 'Generate specific gameplay mechanics',
              value: _useMechanics,
              onChanged: (value) => setState(() => _useMechanics = value),
              icon: Icons.sports_esports,
            ),
            const SizedBox(height: 12),
            
            _buildAgentToggle(
              context,
              title: 'Include Monetization Agent',
              subtitle: 'Generate revenue strategies',
              value: _useMonetization,
              onChanged: (value) => setState(() => _useMonetization = value),
              icon: Icons.monetization_on,
            ),
            const SizedBox(height: 16),
            
            // Agent Info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Active AI Agents:',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildAgentInfo('Research Agent', 'Current trends & technologies', Icons.science),
                  _buildAgentInfo('Theme Agent', 'Storytelling & narrative concepts', Icons.theater_comedy),
                  _buildAgentInfo('World Builder', 'Game world & setting', Icons.public),
                  _buildAgentInfo('Art Direction', 'Visual style & aesthetics', Icons.palette),
                  _buildAgentInfo('Asset Agent', 'Technical specifications', Icons.build),
                  if (_useMechanics) _buildAgentInfo('Mechanics Agent', 'Gameplay mechanics', Icons.sports_esports),
                  if (_useMonetization) _buildAgentInfo('Monetization Agent', 'Revenue strategies', Icons.monetization_on),
                  _buildAgentInfo('Critic Agent', 'Feedback & improvements', Icons.rate_review),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAgentToggle(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
  }) {
    return SwitchListTile(
      title: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildAgentInfo(String name, String description, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$name: $description',
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenerateButton(BuildContext context, JamKitGenerationController controller, AsyncValue<JamKit?> state) {
    return ElevatedButton.icon(
      onPressed: state.isLoading ? null : _generateJamKit,
      icon: state.isLoading 
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.auto_awesome),
      label: Text(state.isLoading ? 'Generating...' : 'Generate Jam Kit'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Generating your Jam Kit...',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Our AI agents are collaborating to create the perfect game concept!',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Card(
      color: Theme.of(context).colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.error, color: Theme.of(context).colorScheme.error),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                error,
                style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults(BuildContext context, JamKit jamKit) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Generated Jam Kit',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              jamKit.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(jamKit.theme),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const JamKitResultsScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.visibility),
                    label: const Text('View Details'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AssetGenerationScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text('Generate Assets'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _generateJamKit() {
    if (!_formKey.currentState!.validate()) return;

    final keywords = _keywordsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final controller = ref.read(jamKitGenerationControllerProvider.notifier);
    controller.generateJamKit(
      keywords: keywords,
      inspirationMode: _selectedInspirationMode,
      generationMode: _selectedMode,
      useMechanics: _useMechanics,
      useMonetization: _useMonetization,
    );
  }
} 