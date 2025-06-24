import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/content_filter_system.dart';

/// Provider für ContentFilterSystem
final contentFilterSystemProvider = Provider<ContentFilterSystem>((ref) {
  return ContentFilterSystem();
});

/// Provider für aktive Filter-Chips
final activeFilterChipsProvider = StateNotifierProvider<FilterChipsNotifier, Set<String>>((ref) {
  final system = ref.read(contentFilterSystemProvider);
  return FilterChipsNotifier(system);
});

/// StateNotifier für Filter-Chips
class FilterChipsNotifier extends StateNotifier<Set<String>> {
  final ContentFilterSystem _system;

  FilterChipsNotifier(this._system) : super(_system.settings.enabledConcerns.toSet());

  void toggleChip(String concern) {
    final newState = Set<String>.from(state);
    
    if (newState.contains(concern)) {
      newState.remove(concern);
    } else {
      newState.add(concern);
    }
    
    state = newState;
    _updateSystemSettings();
  }

  void addChip(String concern) {
    if (!state.contains(concern)) {
      final newState = Set<String>.from(state)..add(concern);
      state = newState;
      _updateSystemSettings();
    }
  }

  void removeChip(String concern) {
    if (state.contains(concern)) {
      final newState = Set<String>.from(state)..remove(concern);
      state = newState;
      _updateSystemSettings();
    }
  }

  void clearAllChips() {
    state = <String>{};
    _updateSystemSettings();
  }

  void addAllChips() {
    final allConcerns = _system.availableCategories.keys.toSet();
    state = allConcerns;
    _updateSystemSettings();
  }

  Future<void> _updateSystemSettings() async {
    final currentSettings = _system.settings;
    final newSettings = currentSettings.copyWith(enabledConcerns: state.toList());
    await _system.updateSettings(newSettings);
  }
}

/// Content Filter Chips Screen
class ContentFilterChipScreen extends ConsumerStatefulWidget {
  const ContentFilterChipScreen({super.key});

  @override
  ConsumerState<ContentFilterChipScreen> createState() => _ContentFilterChipScreenState();
}

class _ContentFilterChipScreenState extends ConsumerState<ContentFilterChipScreen> {
  final _testController = TextEditingController();
  FilterResult? _testResult;
  ContentAnalysis? _analysisResult;
  bool _isTesting = false;

  @override
  void dispose() {
    _testController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeChips = ref.watch(activeFilterChipsProvider);
    final system = ref.read(contentFilterSystemProvider);
    final categories = system.availableCategories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Content Filter Chips'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          // Toggle alle Chips
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (action) {
              final notifier = ref.read(activeFilterChipsProvider.notifier);
              switch (action) {
                case 'add_all':
                  notifier.addAllChips();
                  break;
                case 'clear_all':
                  notifier.clearAllChips();
                  break;
                case 'export':
                  _exportSettings(system);
                  break;
                case 'import':
                  _importSettings(system);
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'add_all',
                child: Row(
                  children: [
                    Icon(Icons.add_circle),
                    SizedBox(width: 8),
                    Text('Add All Filters'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clear_all',
                child: Row(
                  children: [
                    Icon(Icons.clear_all),
                    SizedBox(width: 8),
                    Text('Clear All Filters'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.download),
                    SizedBox(width: 8),
                    Text('Export Settings'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'import',
                child: Row(
                  children: [
                    Icon(Icons.upload),
                    SizedBox(width: 8),
                    Text('Import Settings'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info Banner
            _buildInfoBanner(activeChips.length, categories.length),
            
            const SizedBox(height: 24),
            
            // Aktive Filter Chips
            _buildActiveChips(activeChips, categories),
            
            const SizedBox(height: 24),
            
            // Verfügbare Filter Chips
            _buildAvailableChips(activeChips, categories),
            
            const SizedBox(height: 24),
            
            // Live Test
            _buildLiveTest(system),
            
            const SizedBox(height: 24),
            
            // Test Results
            if (_testResult != null || _analysisResult != null)
              _buildTestResults(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBanner(int activeCount, int totalCount) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.filter_list,
            color: Colors.blue[700],
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Content Filter Chips',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blue[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$activeCount von $totalCount Filtern aktiv',
                  style: TextStyle(
                    color: Colors.blue[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue[700],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$activeCount/$totalCount',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveChips(Set<String> activeChips, Map<String, EthicalCategory> categories) {
    if (activeChips.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(
              Icons.filter_list_off,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 12),
            Text(
              'Keine Filter aktiv',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Füge Filter hinzu um Content zu moderieren',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 8),
            Text(
              'Aktive Filter (${activeChips.length})',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: activeChips.map((concern) {
            final category = categories[concern];
            if (category == null) return const SizedBox.shrink();
            
            return _buildFilterChip(
              category,
              isActive: true,
              onTap: () {
                ref.read(activeFilterChipsProvider.notifier).removeChip(concern);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAvailableChips(Set<String> activeChips, Map<String, EthicalCategory> categories) {
    final availableChips = categories.entries
        .where((entry) => !activeChips.contains(entry.key))
        .toList();

    if (availableChips.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.add_circle_outline, color: Colors.grey),
            const SizedBox(width: 8),
            Text(
              'Verfügbare Filter (${availableChips.length})',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: availableChips.map((entry) {
            final category = entry.value;
            return _buildFilterChip(
              category,
              isActive: false,
              onTap: () {
                ref.read(activeFilterChipsProvider.notifier).addChip(entry.key);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFilterChip(EthicalCategory category, {required bool isActive, required VoidCallback onTap}) {
    final color = _getSeverityColor(category.severity);
    final icon = _getSeverityIcon(category.severity);
    
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? color : color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? color : color.withValues(alpha: 0.3),
            width: isActive ? 2 : 1,
          ),
          boxShadow: isActive ? [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ] : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive ? Colors.white : color,
            ),
            const SizedBox(width: 6),
            Text(
              category.name,
              style: TextStyle(
                color: isActive ? Colors.white : color,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                fontSize: 12,
              ),
            ),
            if (isActive) ...[
              const SizedBox(width: 6),
              Icon(
                Icons.remove_circle,
                size: 16,
                color: Colors.white,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLiveTest(ContentFilterSystem system) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.science, color: Colors.purple),
                const SizedBox(width: 8),
                const Text(
                  'Live Test',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Teste deine aktiven Filter mit eigenem Content:',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _testController,
              maxLines: 4,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Gib hier Text ein um deine Filter zu testen...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _testController.clear(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isTesting ? null : _testFilter,
                    icon: _isTesting 
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.play_arrow),
                    label: Text(_isTesting ? 'Testing...' : 'Test Filter'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _isTesting ? null : _testAnalysis,
                  icon: const Icon(Icons.analytics),
                  label: const Text('Analyze'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestResults() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.assessment, color: Colors.orange),
                const SizedBox(width: 8),
                const Text(
                  'Test Results',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Filter-Ergebnis
            if (_testResult != null) ...[
              _buildFilterResult(),
              const SizedBox(height: 16),
            ],
            
            // Analyse-Ergebnis
            if (_analysisResult != null) ...[
              _buildAnalysisResult(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFilterResult() {
    if (_testResult == null) return const SizedBox.shrink();
    
    final result = _testResult!;
    final color = result.shouldFilter ? Colors.red : Colors.green;
    final icon = result.shouldFilter ? Icons.block : Icons.check_circle;
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.shouldFilter ? 'Content Filtered' : 'Content Allowed',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  'Reason: ${result.reason}',
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  'Confidence: ${(result.confidence * 100).toStringAsFixed(1)}%',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisResult() {
    if (_analysisResult == null) return const SizedBox.shrink();
    
    final analysis = _analysisResult!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overall Risk: ${(analysis.overallRisk * 100).toStringAsFixed(1)}%',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: analysis.overallRisk > 0.7 ? Colors.red : Colors.green,
          ),
        ),
        const SizedBox(height: 8),
        ...analysis.concernAnalyses.entries.map((entry) {
          final concernAnalysis = entry.value;
          
          if (concernAnalysis.overallRisk < 0.1) return const SizedBox.shrink();
          
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  concernAnalysis.category.name,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  'Risk: ${(concernAnalysis.overallRisk * 100).toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: concernAnalysis.overallRisk > 0.7 ? Colors.red : Colors.orange,
                    fontSize: 12,
                  ),
                ),
                if (concernAnalysis.keywordMatches.isNotEmpty)
                  Text(
                    'Keywords: ${concernAnalysis.keywordMatches.join(', ')}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Color _getSeverityColor(FilterSeverity severity) {
    switch (severity) {
      case FilterSeverity.low:
        return Colors.blue;
      case FilterSeverity.medium:
        return Colors.orange;
      case FilterSeverity.high:
        return Colors.red;
      case FilterSeverity.critical:
        return Colors.purple;
    }
  }

  IconData _getSeverityIcon(FilterSeverity severity) {
    switch (severity) {
      case FilterSeverity.low:
        return Icons.info;
      case FilterSeverity.medium:
        return Icons.warning;
      case FilterSeverity.high:
        return Icons.error;
      case FilterSeverity.critical:
        return Icons.dangerous;
    }
  }

  Future<void> _testFilter() async {
    if (_testController.text.isEmpty) return;
    
    setState(() {
      _isTesting = true;
      _testResult = null;
      _analysisResult = null;
    });
    
    try {
      final system = ref.read(contentFilterSystemProvider);
      final result = await system.filterContent(_testController.text);
      
      setState(() {
        _testResult = result;
        _isTesting = false;
      });
    } catch (e) {
      setState(() {
        _isTesting = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _testAnalysis() async {
    if (_testController.text.isEmpty) return;
    
    setState(() {
      _isTesting = true;
      _testResult = null;
      _analysisResult = null;
    });
    
    try {
      final system = ref.read(contentFilterSystemProvider);
      final analysis = await system.analyzeContent(_testController.text);
      
      setState(() {
        _analysisResult = analysis;
        _isTesting = false;
      });
    } catch (e) {
      setState(() {
        _isTesting = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _exportSettings(ContentFilterSystem system) async {
    try {
      final exportData = await system.exportSettings();
      
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Export Filter Settings'),
            content: SelectableText(exportData),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _importSettings(ContentFilterSystem system) async {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Import feature coming soon')),
      );
    }
  }
} 