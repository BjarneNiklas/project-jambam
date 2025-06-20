import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/jam_kit.dart';

class JamKitResultsScreen extends ConsumerWidget {
  const JamKitResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // Mock data for demonstration
    final jamKit = JamKit(
      id: 'kit-001',
      title: 'Cyberpunk Building Kit',
      theme: 'Neon-lit metropolis with modular construction',
      quests: [
        const Quest(
          title: 'Build the Core',
          description: 'Create the central building system with modular components',
        ),
        const Quest(
          title: 'Light the City',
          description: 'Implement dynamic lighting and neon effects',
        ),
        const Quest(
          title: 'Connect the Grid',
          description: 'Build networking and multiplayer functionality',
        ),
      ],
      assetSuggestions: [
        const AssetSuggestion(
          type: '3D Building Blocks',
          description: 'Modular building components with neon accents',
          stylePrompt: 'Cyberpunk building blocks, neon lighting, modular design',
        ),
        const AssetSuggestion(
          type: 'Lighting System',
          description: 'Dynamic neon lighting with color customization',
          stylePrompt: 'Neon lights, cyberpunk atmosphere, dynamic colors',
        ),
      ],
      kitType: KitType.building,
      complexity: Complexity.intermediate,
      estimatedBuildTime: const Duration(hours: 8),
      buildingComponents: [
        BuildingComponent(
          id: 'core-system',
          name: 'Core Building System',
          description: 'Essential modular building framework',
          type: ComponentType.core,
          estimatedTime: const Duration(hours: 2),
          assets: [
            const AssetSuggestion(
              type: 'Building Framework',
              description: 'Core building system with snap points',
              stylePrompt: 'Modular framework, snap connections, cyberpunk style',
            ),
          ],
          dependencies: [],
          alternatives: ['simple-system', 'advanced-system'],
          customizationOptions: [
            const CustomizationOption(
              name: 'Grid Size',
              description: 'Size of the building grid',
              type: CustomizationType.choice,
              options: ['Small (8x8)', 'Medium (16x16)', 'Large (32x32)'],
              defaultValue: 'Medium (16x16)',
            ),
            const CustomizationOption(
              name: 'Snap Precision',
              description: 'How precise the snap-to-grid system is',
              type: CustomizationType.range,
              defaultValue: '5',
            ),
          ],
        ),
        BuildingComponent(
          id: 'lighting-system',
          name: 'Dynamic Lighting',
          description: 'Neon lighting system with color customization',
          type: ComponentType.visual,
          estimatedTime: const Duration(hours: 3),
          assets: [
            const AssetSuggestion(
              type: 'Neon Lights',
              description: 'Dynamic neon lighting effects',
              stylePrompt: 'Neon lights, cyberpunk, dynamic colors, glow effects',
            ),
          ],
          dependencies: ['core-system'],
          alternatives: ['basic-lighting', 'advanced-lighting'],
          customizationOptions: [
            const CustomizationOption(
              name: 'Color Palette',
              description: 'Available neon colors',
              type: CustomizationType.choice,
              options: ['Classic (Blue/Pink)', 'Warm (Orange/Red)', 'Cool (Green/Cyan)', 'Custom'],
              defaultValue: 'Classic (Blue/Pink)',
            ),
            const CustomizationOption(
              name: 'Pulse Effect',
              description: 'Enable pulsing light effects',
              type: CustomizationType.boolean,
              defaultValue: 'true',
            ),
          ],
        ),
        BuildingComponent(
          id: 'networking',
          name: 'Multiplayer Networking',
          description: 'Real-time multiplayer building collaboration',
          type: ComponentType.networking,
          estimatedTime: const Duration(hours: 2),
          assets: [],
          dependencies: ['core-system'],
          alternatives: ['local-only', 'turn-based'],
          customizationOptions: [
            const CustomizationOption(
              name: 'Max Players',
              description: 'Maximum number of simultaneous builders',
              type: CustomizationType.range,
              defaultValue: '4',
            ),
            const CustomizationOption(
              name: 'Sync Frequency',
              description: 'How often to sync building changes',
              type: CustomizationType.choice,
              options: ['Low (2s)', 'Medium (1s)', 'High (0.5s)'],
              defaultValue: 'Medium (1s)',
            ),
          ],
        ),
      ],
      constructionGuides: [
        ConstructionGuide(
          id: 'quick-start',
          title: 'Quick Start Guide',
          description: 'Get your cyberpunk building kit running in 30 minutes',
          prerequisites: ['Basic Unity knowledge', 'Git installed'],
          tools: ['Unity 2022.3+', 'Visual Studio Code', 'Git'],
          steps: [
            ConstructionStep(
              id: 'step-1',
              title: 'Setup Project',
              description: 'Create a new Unity project and import the building kit',
              order: 1,
              estimatedTime: const Duration(minutes: 10),
              components: ['core-system'],
              codeSnippets: [
                const CodeSnippet(
                  title: 'Import Package',
                  code: 'git clone https://github.com/jambam/cyberpunk-building-kit.git',
                  language: 'bash',
                  description: 'Clone the building kit repository',
                ),
              ],
            ),
            ConstructionStep(
              id: 'step-2',
              title: 'Configure Core System',
              description: 'Set up the core building system with your preferred settings',
              order: 2,
              estimatedTime: const Duration(minutes: 15),
              components: ['core-system'],
              codeSnippets: [
                const CodeSnippet(
                  title: 'Grid Configuration',
                  code: '''
BuildingGridConfig config = new BuildingGridConfig {
  gridSize = GridSize.Medium,
  snapPrecision = 5,
  enableSnap = true
};
BuildingSystem.Initialize(config);
''',
                  language: 'csharp',
                  description: 'Configure the building grid system',
                ),
              ],
            ),
            ConstructionStep(
              id: 'step-3',
              title: 'Add Lighting',
              description: 'Integrate the dynamic neon lighting system',
              order: 3,
              estimatedTime: const Duration(minutes: 20),
              components: ['lighting-system'],
              codeSnippets: [
                const CodeSnippet(
                  title: 'Lighting Setup',
                  code: '''
NeonLightingConfig lightingConfig = new NeonLightingConfig {
  colorPalette = ColorPalette.Classic,
  enablePulse = true,
  pulseSpeed = 1.0f
};
LightingSystem.Initialize(lightingConfig);
''',
                  language: 'csharp',
                  description: 'Configure the neon lighting system',
                ),
              ],
            ),
          ],
          tips: [
            'Start with the core system before adding advanced features',
            'Test the snap system with different grid sizes',
            'Use the lighting system to create atmosphere',
          ],
          troubleshooting: [
            const TroubleshootingItem(
              problem: 'Building blocks not snapping correctly',
              solution: 'Check the snap precision setting and ensure grid alignment',
              cause: 'Incorrect snap precision or grid misalignment',
            ),
            const TroubleshootingItem(
              problem: 'Neon lights not appearing',
              solution: 'Verify the lighting system is initialized and materials are assigned',
              cause: 'Lighting system not initialized or missing materials',
            ),
          ],
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('🎯 Jam Kit Results'),
        backgroundColor: colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kit Overview
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _getKitTypeColor(jamKit.kitType),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _getKitTypeIcon(jamKit.kitType),
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                jamKit.title,
                                style: textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                jamKit.theme,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildInfoChip(
                          'Type',
                          jamKit.kitType.name.toUpperCase(),
                          _getKitTypeColor(jamKit.kitType),
                        ),
                        const SizedBox(width: 8),
                        _buildInfoChip(
                          'Complexity',
                          jamKit.complexity.name.toUpperCase(),
                          _getComplexityColor(jamKit.complexity),
                        ),
                        const SizedBox(width: 8),
                        _buildInfoChip(
                          'Build Time',
                          '${jamKit.estimatedBuildTime.inHours}h',
                          Colors.orange,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Building Components
            Text(
              '🧱 Building Components',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...jamKit.buildingComponents.map((component) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _getComponentTypeColor(component.type),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            _getComponentTypeIcon(component.type),
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
                                component.name,
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                component.description,
                                style: textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${component.estimatedTime.inHours}h',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    if (component.customizationOptions.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        'Customization Options:',
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: component.customizationOptions.map((option) => Chip(
                          label: Text(option.name),
                          backgroundColor: colorScheme.secondaryContainer,
                        )).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            )),
            const SizedBox(height: 24),

            // Construction Guides
            Text(
              '📋 Construction Guides',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...jamKit.constructionGuides.map((guide) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ExpansionTile(
                title: Text(
                  guide.title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(guide.description),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (guide.prerequisites.isNotEmpty) ...[
                          Text(
                            'Prerequisites:',
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          ...guide.prerequisites.map((prereq) => Padding(
                            padding: const EdgeInsets.only(left: 16, bottom: 2),
                            child: Text('• $prereq'),
                          )),
                          const SizedBox(height: 12),
                        ],
                        Text(
                          'Steps:',
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...guide.steps.map((step) => Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
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
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '${step.estimatedTime.inMinutes}m',
                                      style: textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                                if (step.codeSnippets.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  ...step.codeSnippets.map((snippet) => Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snippet.title,
                                          style: textTheme.bodySmall?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          snippet.code,
                                          style: textTheme.bodySmall?.copyWith(
                                            fontFamily: 'monospace',
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                                ],
                              ],
                            ),
                          ),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            )),
            const SizedBox(height: 24),

            // Quests
            Text(
              '🎮 Quests',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...jamKit.quests.map((quest) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const Icon(Icons.help_outline),
                title: Text(quest.title),
                subtitle: Text(quest.description),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Color _getKitTypeColor(KitType type) {
    switch (type) {
      case KitType.standard:
        return Colors.blue;
      case KitType.building:
        return Colors.green;
      case KitType.experimental:
        return Colors.purple;
      case KitType.hybrid:
        return Colors.orange;
    }
  }

  IconData _getKitTypeIcon(KitType type) {
    switch (type) {
      case KitType.standard:
        return Icons.auto_awesome;
      case KitType.building:
        return Icons.construction;
      case KitType.experimental:
        return Icons.science;
      case KitType.hybrid:
        return Icons.merge_type;
    }
  }

  Color _getComplexityColor(Complexity complexity) {
    switch (complexity) {
      case Complexity.beginner:
        return Colors.green;
      case Complexity.intermediate:
        return Colors.orange;
      case Complexity.advanced:
        return Colors.red;
      case Complexity.expert:
        return Colors.purple;
    }
  }

  Color _getComponentTypeColor(ComponentType type) {
    switch (type) {
      case ComponentType.core:
        return Colors.blue;
      case ComponentType.mechanics:
        return Colors.green;
      case ComponentType.ui:
        return Colors.orange;
      case ComponentType.audio:
        return Colors.purple;
      case ComponentType.visual:
        return Colors.pink;
      case ComponentType.ai:
        return Colors.indigo;
      case ComponentType.networking:
        return Colors.teal;
      case ComponentType.data:
        return Colors.brown;
      case ComponentType.tools:
        return Colors.grey;
    }
  }

  IconData _getComponentTypeIcon(ComponentType type) {
    switch (type) {
      case ComponentType.core:
        return Icons.settings;
      case ComponentType.mechanics:
        return Icons.sports_esports;
      case ComponentType.ui:
        return Icons.dashboard;
      case ComponentType.audio:
        return Icons.audiotrack;
      case ComponentType.visual:
        return Icons.visibility;
      case ComponentType.ai:
        return Icons.psychology;
      case ComponentType.networking:
        return Icons.wifi;
      case ComponentType.data:
        return Icons.storage;
      case ComponentType.tools:
        return Icons.build;
    }
  }
} 