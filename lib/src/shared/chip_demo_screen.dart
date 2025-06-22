import 'package:flutter/material.dart';
import 'package:project_jambam/src/shared/enhanced_chip.dart';

/// Demo Screen für Enhanced Chips
class ChipDemoScreen extends StatefulWidget {
  const ChipDemoScreen({super.key});

  @override
  State<ChipDemoScreen> createState() => _ChipDemoScreenState();
}

class _ChipDemoScreenState extends State<ChipDemoScreen> {
  String _selectedMode = 'creative';
  final Set<String> _selectedAnimations = {};
  final Set<String> _selectedCategories = {};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Enhanced Chips Demo'),
        backgroundColor: colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Single Select (ChoiceChip) Demo
            _buildDemoSection(
              title: 'Single Select (ChoiceChip)',
              description: 'Nur eine Option kann ausgewählt werden',
              child: Wrap(
                spacing: 8,
                children: [
                  'creative',
                  'analytical',
                  'experimental',
                ].map((mode) {
                  return EnhancedChoiceChip(
                    label: mode.capitalize(),
                    selected: _selectedMode == mode,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedMode = mode);
                      }
                    },
                    icon: _getModeIcon(mode),
                    selectedIcon: _getModeSelectedIcon(mode),
                    selectedColor: _getModeColor(mode),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 32),

            // Multi Select (FilterChip) Demo
            _buildDemoSection(
              title: 'Multi Select (FilterChip)',
              description: 'Mehrere Optionen können ausgewählt werden',
              child: Wrap(
                spacing: 8,
                children: [
                  'idle',
                  'walk',
                  'run',
                  'jump',
                  'attack',
                  'dance',
                ].map((animation) {
                  return EnhancedFilterChip(
                    label: animation.capitalize(),
                    selected: _selectedAnimations.contains(animation),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedAnimations.add(animation);
                        } else {
                          _selectedAnimations.remove(animation);
                        }
                      });
                    },
                    icon: Icons.add,
                    selectedIcon: Icons.check,
                    selectedColor: colorScheme.primary,
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 32),

            // Action Chips Demo
            _buildDemoSection(
              title: 'Action Chips',
              description: 'Für Aktionen ohne Auswahlzustand',
              child: Wrap(
                spacing: 8,
                children: [
                  EnhancedActionChip(
                    label: 'AI Supported',
                    onPressed: () => _showSnackBar('AI Supported clicked'),
                    icon: Icons.psychology,
                    color: colorScheme.secondary,
                    backgroundColor: colorScheme.secondaryContainer,
                  ),
                  EnhancedActionChip(
                    label: 'Quick (< 10 min)',
                    onPressed: () => _showSnackBar('Quick filter clicked'),
                    icon: Icons.speed,
                    color: colorScheme.tertiary,
                    backgroundColor: colorScheme.tertiaryContainer,
                  ),
                  EnhancedActionChip(
                    label: 'Team Methods',
                    onPressed: () => _showSnackBar('Team Methods clicked'),
                    icon: Icons.group,
                    color: colorScheme.primary,
                    backgroundColor: colorScheme.primaryContainer,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Category Chips Demo
            _buildDemoSection(
              title: 'Category Chips',
              description: 'Kategorien mit verschiedenen Farben',
              child: Wrap(
                spacing: 8,
                children: [
                  '🎮 Mechanik',
                  '🎨 Art',
                  '📖 Story',
                  '🔬 Tech',
                  '🌍 World',
                  '🎵 Audio',
                ].map((category) {
                  final isSelected = _selectedCategories.contains(category);
                  return EnhancedFilterChip(
                    label: category,
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedCategories.add(category);
                        } else {
                          _selectedCategories.remove(category);
                        }
                      });
                    },
                    selectedColor: _getCategoryColor(category),
                    backgroundColor: colorScheme.surfaceContainerHighest,
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 32),

            // Selection Summary
            if (_selectedAnimations.isNotEmpty || _selectedCategories.isNotEmpty)
              _buildDemoSection(
                title: 'Aktuelle Auswahl',
                description: 'Übersicht der ausgewählten Optionen',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_selectedMode.isNotEmpty) ...[
                      Text('Modus: $_selectedMode', style: theme.textTheme.bodyMedium),
                      const SizedBox(height: 8),
                    ],
                    if (_selectedAnimations.isNotEmpty) ...[
                      Text('Animationen: ${_selectedAnimations.join(', ')}', 
                           style: theme.textTheme.bodyMedium),
                      const SizedBox(height: 8),
                    ],
                    if (_selectedCategories.isNotEmpty) ...[
                      Text('Kategorien: ${_selectedCategories.join(', ')}', 
                           style: theme.textTheme.bodyMedium),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoSection({
    required String title,
    required String description,
    required Widget child,
  }) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  IconData _getModeIcon(String mode) {
    switch (mode) {
      case 'creative': return Icons.brush;
      case 'analytical': return Icons.analytics;
      case 'experimental': return Icons.science;
      default: return Icons.category;
    }
  }

  IconData _getModeSelectedIcon(String mode) {
    switch (mode) {
      case 'creative': return Icons.auto_awesome;
      case 'analytical': return Icons.trending_up;
      case 'experimental': return Icons.explore;
      default: return Icons.check;
    }
  }

  Color _getModeColor(String mode) {
    switch (mode) {
      case 'creative': return Colors.purple;
      case 'analytical': return Colors.blue;
      case 'experimental': return Colors.orange;
      default: return Colors.grey;
    }
  }

  Color _getCategoryColor(String category) {
    if (category.contains('🎮')) return Colors.blue;
    if (category.contains('🎨')) return Colors.pink;
    if (category.contains('📖')) return Colors.green;
    if (category.contains('🔬')) return Colors.orange;
    if (category.contains('🌍')) return Colors.teal;
    if (category.contains('🎵')) return Colors.purple;
    return Colors.grey;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
} 