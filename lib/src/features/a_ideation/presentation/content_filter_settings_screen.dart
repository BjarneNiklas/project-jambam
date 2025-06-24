import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/content_filter_system.dart';

/// Provider für ContentFilterSystem
final contentFilterSystemProvider = Provider<ContentFilterSystem>((ref) {
  return ContentFilterSystem();
});

/// Provider für Filter-Einstellungen
final filterSettingsProvider = StateNotifierProvider<FilterSettingsNotifier, FilterSettings>((ref) {
  final system = ref.read(contentFilterSystemProvider);
  return FilterSettingsNotifier(system);
});

/// StateNotifier für Filter-Einstellungen
class FilterSettingsNotifier extends StateNotifier<FilterSettings> {
  final ContentFilterSystem _system;

  FilterSettingsNotifier(this._system) : super(_system.settings);

  Future<void> updateSettings(FilterSettings newSettings) async {
    await _system.updateSettings(newSettings);
    state = newSettings;
  }

  Future<void> toggleConcern(String concern) async {
    final newConcerns = List<String>.from(state.enabledConcerns);
    
    if (newConcerns.contains(concern)) {
      newConcerns.remove(concern);
    } else {
      newConcerns.add(concern);
    }
    
    final newSettings = state.copyWith(enabledConcerns: newConcerns);
    await updateSettings(newSettings);
  }

  Future<void> toggleFilterType(String filterType) async {
    FilterSettings newSettings;
    
    switch (filterType) {
      case 'keyword':
        newSettings = state.copyWith(useKeywordFilter: !state.useKeywordFilter);
        break;
      case 'context':
        newSettings = state.copyWith(useContextFilter: !state.useContextFilter);
        break;
      case 'ai':
        newSettings = state.copyWith(useAIClassification: !state.useAIClassification);
        break;
      case 'feedback':
        newSettings = state.copyWith(useUserFeedback: !state.useUserFeedback);
        break;
      default:
        return;
    }
    
    await updateSettings(newSettings);
  }

  Future<void> updateThreshold(String thresholdType, double value) async {
    FilterSettings newSettings;
    
    switch (thresholdType) {
      case 'ai':
        newSettings = state.copyWith(aiThreshold: value);
        break;
      case 'feedback':
        newSettings = state.copyWith(userFeedbackThreshold: value);
        break;
      case 'keywords':
        newSettings = state.copyWith(minKeywordMatches: value.round());
        break;
      default:
        return;
    }
    
    await updateSettings(newSettings);
  }
}

/// Content Filter Settings Screen
class ContentFilterSettingsScreen extends ConsumerStatefulWidget {
  const ContentFilterSettingsScreen({super.key});

  @override
  ConsumerState<ContentFilterSettingsScreen> createState() => _ContentFilterSettingsScreenState();
}

class _ContentFilterSettingsScreenState extends ConsumerState<ContentFilterSettingsScreen> {
  final _testController = TextEditingController();
  FilterResult? _testResult;
  ContentAnalysis? _testAnalysis;
  bool _isTesting = false;

  @override
  void dispose() {
    _testController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(filterSettingsProvider);
    final system = ref.read(contentFilterSystemProvider);
    final categories = system.availableCategories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Content Filter Settings'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _exportSettings(system),
          ),
          IconButton(
            icon: const Icon(Icons.upload),
            onPressed: () => _importSettings(system),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Haupt-Toggle
            _buildMainToggle(settings),
            
            const SizedBox(height: 24),
            
            // Ethische Bedenken
            _buildEthicalConcerns(settings, categories),
            
            const SizedBox(height: 24),
            
            // Filter-Typen
            _buildFilterTypes(settings),
            
            const SizedBox(height: 24),
            
            // Schwellenwerte
            _buildThresholds(settings),
            
            const SizedBox(height: 24),
            
            // Live-Test
            _buildLiveTest(system),
            
            const SizedBox(height: 24),
            
            // Test-Ergebnisse
            _buildTestResults(),
          ],
        ),
      ),
    );
  }

  Widget _buildMainToggle(FilterSettings settings) {
    return Card(
      child: SwitchListTile(
        title: const Text(
          'Content Filtering',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: const Text('Aktiviere intelligente Content-Filterung'),
        value: settings.enabled,
        onChanged: (value) async {
          final notifier = ref.read(filterSettingsProvider.notifier);
          await notifier.updateSettings(settings.copyWith(enabled: value));
        },
        secondary: Icon(
          settings.enabled ? Icons.shield : Icons.shield_outlined,
          color: settings.enabled ? Colors.green : Colors.grey,
        ),
      ),
    );
  }

  Widget _buildEthicalConcerns(FilterSettings settings, Map<String, EthicalCategory> categories) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ethical Concerns',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              'Wähle die ethischen Bedenken aus, die gefiltert werden sollen:',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ...categories.entries.map((entry) {
              final concern = entry.key;
              final category = entry.value;
              final isEnabled = settings.enabledConcerns.contains(concern);
              
              return CheckboxListTile(
                title: Text(category.name),
                subtitle: Text(category.description),
                value: isEnabled,
                onChanged: (value) {
                  final notifier = ref.read(filterSettingsProvider.notifier);
                  notifier.toggleConcern(concern);
                },
                secondary: _getSeverityIcon(category.severity),
                controlAffinity: ListTileControlAffinity.leading,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTypes(FilterSettings settings) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter Types',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              'Wähle die Filter-Methoden aus:',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            _buildFilterTypeTile(
              'Keyword Filter',
              'Filtert basierend auf problematischen Schlüsselwörtern',
              Icons.search,
              settings.useKeywordFilter,
              'keyword',
            ),
            _buildFilterTypeTile(
              'Context Filter',
              'Filtert basierend auf problematischen Kontext-Mustern',
              Icons.text_fields,
              settings.useContextFilter,
              'context',
            ),
            _buildFilterTypeTile(
              'AI Classification',
              'Verwendet AI für komplexe Klassifizierung',
              Icons.psychology,
              settings.useAIClassification,
              'ai',
            ),
            _buildFilterTypeTile(
              'User Feedback',
              'Lernt aus User-Feedback und Reports',
              Icons.people,
              settings.useUserFeedback,
              'feedback',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTypeTile(
    String title,
    String subtitle,
    IconData icon,
    bool isEnabled,
    String filterType,
  ) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: isEnabled,
      onChanged: (value) {
        final notifier = ref.read(filterSettingsProvider.notifier);
        notifier.toggleFilterType(filterType);
      },
      secondary: Icon(icon),
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  Widget _buildThresholds(FilterSettings settings) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thresholds',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            _buildThresholdSlider(
              'Minimum Keyword Matches',
              'Anzahl der Keywords die gefunden werden müssen',
              settings.minKeywordMatches.toDouble(),
              1,
              10,
              (value) {
                final notifier = ref.read(filterSettingsProvider.notifier);
                notifier.updateThreshold('keywords', value);
              },
            ),
            const SizedBox(height: 16),
            _buildThresholdSlider(
              'AI Classification Threshold',
              'Mindest-Risiko für AI-basierte Filterung',
              settings.aiThreshold,
              0.0,
              1.0,
              (value) {
                final notifier = ref.read(filterSettingsProvider.notifier);
                notifier.updateThreshold('ai', value);
              },
            ),
            const SizedBox(height: 16),
            _buildThresholdSlider(
              'User Feedback Threshold',
              'Mindest-Score für User-Feedback-Filterung',
              settings.userFeedbackThreshold,
              0.0,
              1.0,
              (value) {
                final notifier = ref.read(filterSettingsProvider.notifier);
                notifier.updateThreshold('feedback', value);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThresholdSlider(
    String title,
    String subtitle,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: value,
                min: min,
                max: max,
                divisions: ((max - min) * 10).round(),
                onChanged: onChanged,
              ),
            ),
            SizedBox(
              width: 50,
              child: Text(
                value.toStringAsFixed(1),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLiveTest(ContentFilterSystem system) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Live Test',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              'Teste den Content-Filter mit deinem eigenen Text:',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _testController,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Gib hier Text ein um den Filter zu testen...',
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
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _isTesting ? null : _runTestAnalysis,
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
    if (_testResult == null && _testAnalysis == null) return const SizedBox.shrink();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Test Results',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            
            // Filter-Ergebnis
            if (_testResult != null) ...[
              _buildFilterResult(),
              const SizedBox(height: 16),
            ],
            
            // Analyse-Ergebnis
            if (_testAnalysis != null) ...[
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
        color: color.withAlpha((0.1 * 255).toInt()),
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
    if (_testAnalysis == null) return const SizedBox.shrink();
    final analysis = _testAnalysis!;
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

  Icon _getSeverityIcon(FilterSeverity severity) {
    switch (severity) {
      case FilterSeverity.low:
        return const Icon(Icons.info, color: Colors.blue);
      case FilterSeverity.medium:
        return const Icon(Icons.warning, color: Colors.orange);
      case FilterSeverity.high:
        return const Icon(Icons.error, color: Colors.red);
      case FilterSeverity.critical:
        return const Icon(Icons.dangerous, color: Colors.purple);
    }
  }

  Future<void> _testFilter() async {
    if (_testController.text.isEmpty) return;
    
    setState(() {
      _isTesting = true;
      _testResult = null;
      _testAnalysis = null;
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

  Future<void> _runTestAnalysis() async {
    if (_testController.text.isEmpty) return;
    
    setState(() {
      _isTesting = true;
      _testResult = null;
      _testAnalysis = null;
    });
    
    try {
      final system = ref.read(contentFilterSystemProvider);
      final analysis = await system.analyzeContent(_testController.text);
      
      setState(() {
        _testAnalysis = analysis;
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
            title: const Text('Export Settings'),
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