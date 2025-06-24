import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/ai/intelligent_router.dart';
import '../../../core/ai/multi_tier_ai_stack.dart';

class IntelligentRouterScreen extends ConsumerStatefulWidget {
  const IntelligentRouterScreen({super.key});

  @override
  ConsumerState<IntelligentRouterScreen> createState() => _IntelligentRouterScreenState();
}

class _IntelligentRouterScreenState extends ConsumerState<IntelligentRouterScreen> {
  final TextEditingController _requestController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  bool _isProcessing = false;
  RequestAnalysis? _currentAnalysis;
  RouteSelection? _currentRoute;
  AIResponse? _currentResponse;
  final List<Map<String, dynamic>> _requestHistory = [];

  late final IntelligentRouter _router;
  late final MultiTierAIStack _aiStack;

  @override
  void initState() {
    super.initState();
    _initializeAIStack();
  }

  void _initializeAIStack() {
    _router = IntelligentRouter();
    _aiStack = MultiTierAIStack(
      router: _router,
      ruleLayer: RuleBasedLayer(),
      slmLayer: LocalSLMLayer(),
      ragLayer: RAGLayer(),
      llmLayer: LLMLayer(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Intelligent AI Router'),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: _showPerformanceMetrics,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showRouterSettings,
          ),
        ],
      ),
      body: Column(
        children: [
          // Request Input Section
          _buildRequestInputSection(),
          
          // Analysis and Route Selection Section
          if (_currentAnalysis != null && _currentRoute != null)
            _buildRouteSelectionSection(),
          
          // Response Section
          if (_currentResponse != null)
            _buildResponseSection(),
          
          // Request History
          Expanded(
            child: _buildRequestHistory(),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestInputSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'AI Request',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _requestController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Enter your request... (e.g., "What is Unity?", "Create a game concept", "Research game development trends")',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.send),
                onPressed: _isProcessing ? null : _processRequest,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : _processRequest,
                  child: _isProcessing
                      ? const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 8),
                            Text('Processing...'),
                          ],
                        )
                      : const Text('Process Request'),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: _clearAll,
                child: const Text('Clear'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRouteSelectionSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        border: Border(bottom: BorderSide(color: Colors.blue[200]!)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.route, color: Colors.blue[700]),
              const SizedBox(width: 8),
              const Text(
                'Route Selection',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Selected Route Card
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _getApproachIcon(_currentRoute!.approach),
                        color: _getApproachColor(_currentRoute!.approach),
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getApproachName(_currentRoute!.approach),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _currentRoute!.reasoning,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Metrics
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricCard(
                          'Estimated Cost',
                          '\$${_currentRoute!.estimatedCost.toStringAsFixed(3)}',
                          Icons.attach_money,
                          Colors.green,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildMetricCard(
                          'Estimated Time',
                          '${_currentRoute!.estimatedTimeMs}ms',
                          Icons.timer,
                          Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Alternatives
                  if (_currentRoute!.alternatives.isNotEmpty) ...[
                    const Text(
                      'Alternative Approaches:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _currentRoute!.alternatives.map((approach) {
                        return Chip(
                          label: Text(_getApproachName(approach)),
                          backgroundColor: Colors.grey[200],
                          onDeleted: () => _selectAlternative(approach),
                        );
                      }).toList(),
                    ),
                  ],
                  
                  const SizedBox(height: 16),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _confirmAndExecute,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Confirm & Execute'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _showAnalysisDetails,
                          child: const Text('View Analysis'),
                        ),
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

  Widget _buildResponseSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        border: Border(bottom: BorderSide(color: Colors.green[200]!)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.psychology, color: Colors.green[700]),
              const SizedBox(width: 8),
              const Text(
                'AI Response',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Response content
                  Text(
                    _currentResponse!.content,
                    style: const TextStyle(fontSize: 16),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Response metrics
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricCard(
                          'Confidence',
                          '${(_currentResponse!.confidence * 100).toStringAsFixed(1)}%',
                          Icons.psychology,
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildMetricCard(
                          'Actual Cost',
                          '\$${_currentResponse!.cost.toStringAsFixed(3)}',
                          Icons.attach_money,
                          Colors.green,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildMetricCard(
                          'Duration',
                          '${_currentResponse!.durationMs}ms',
                          Icons.timer,
                          Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  
                  if (_currentResponse!.sources.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'Sources:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _currentResponse!.sources.map((source) {
                        return Chip(
                          label: Text(source),
                          backgroundColor: Colors.blue[100],
                        );
                      }).toList(),
                    ),
                  ],
                  
                  const SizedBox(height: 16),
                  
                  // Feedback buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _provideFeedback(true),
                          icon: const Icon(Icons.thumb_up),
                          label: const Text('Good'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _provideFeedback(false),
                          icon: const Icon(Icons.thumb_down),
                          label: const Text('Poor'),
                        ),
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

  Widget _buildRequestHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Text(
                'Request History',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              TextButton(
                onPressed: _clearHistory,
                child: const Text('Clear History'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _requestHistory.length,
            itemBuilder: (context, index) {
              final historyItem = _requestHistory[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Icon(
                    _getApproachIcon(AIApproach.values.firstWhere(
                      (a) => a.name == historyItem['approach'],
                    )),
                    color: _getApproachColor(AIApproach.values.firstWhere(
                      (a) => a.name == historyItem['approach'],
                    )),
                  ),
                  title: Text(
                    historyItem['request'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Approach: ${historyItem['approach']}'),
                      Text('Confidence: ${(historyItem['confidence'] * 100).toStringAsFixed(1)}%'),
                      Text('Cost: \$${historyItem['cost'].toStringAsFixed(3)}'),
                    ],
                  ),
                  trailing: Text(
                    _formatTimestamp(historyItem['timestamp']),
                    style: const TextStyle(fontSize: 12),
                  ),
                  onTap: () => _loadHistoryItem(historyItem),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  IconData _getApproachIcon(AIApproach approach) {
    switch (approach) {
      case AIApproach.ruleBased:
        return Icons.rule;
      case AIApproach.localSLM:
        return Icons.computer;
      case AIApproach.rag:
        return Icons.search;
      case AIApproach.llm:
        return Icons.psychology;
      case AIApproach.hybrid:
        return Icons.merge;
    }
  }

  Color _getApproachColor(AIApproach approach) {
    switch (approach) {
      case AIApproach.ruleBased:
        return Colors.green;
      case AIApproach.localSLM:
        return Colors.blue;
      case AIApproach.rag:
        return Colors.orange;
      case AIApproach.llm:
        return Colors.purple;
      case AIApproach.hybrid:
        return Colors.teal;
    }
  }

  String _getApproachName(AIApproach approach) {
    switch (approach) {
      case AIApproach.ruleBased:
        return 'Rule-Based';
      case AIApproach.localSLM:
        return 'Local SLM';
      case AIApproach.rag:
        return 'RAG (Retrieval)';
      case AIApproach.llm:
        return 'LLM';
      case AIApproach.hybrid:
        return 'Hybrid';
    }
  }

  String _formatTimestamp(String timestamp) {
    try {
      final date = DateTime.parse(timestamp);
      return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return '';
    }
  }

  // Action methods
  Future<void> _processRequest() async {
    if (_requestController.text.trim().isEmpty) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final request = UserRequest(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: _requestController.text.trim(),
        userId: 'user123',
        timestamp: DateTime.now(),
        requiresConfirmation: true,
      );

      // Analyze request
      final analysis = _router.analyzeRequest(request);
      
      // Select route
      final route = _router.selectOptimalRoute(analysis);

      setState(() {
        _currentAnalysis = analysis;
        _currentRoute = route;
        _currentResponse = null;
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error processing request: $e')),
      );
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<void> _confirmAndExecute() async {
    if (_currentRoute == null) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final request = UserRequest(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: _requestController.text.trim(),
        userId: 'user123',
        timestamp: DateTime.now(),
      );

      final response = await _aiStack.processRequest(request);

      setState(() {
        _currentResponse = response;
      });

      // Add to history
      _requestHistory.insert(0, {
        'request': request.content,
        'approach': response.approach.name,
        'confidence': response.confidence,
        'cost': response.cost,
        'timestamp': request.timestamp.toIso8601String(),
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error executing request: $e')),
      );
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  void _selectAlternative(AIApproach approach) {
    if (_currentAnalysis == null) return;

    final route = _router.selectOptimalRoute(_currentAnalysis!);
    setState(() {
      _currentRoute = RouteSelection(
        approach: approach,
        reasoning: 'User selected alternative approach',
        alternatives: route.alternatives,
        estimatedCost: _calculateEstimatedCost(approach),
        estimatedTimeMs: _calculateEstimatedTime(approach),
        configuration: _getConfiguration(approach, _currentAnalysis!),
      );
    });
  }

  double _calculateEstimatedCost(AIApproach approach) {
    switch (approach) {
      case AIApproach.ruleBased:
        return 0.0;
      case AIApproach.localSLM:
        return 0.01;
      case AIApproach.rag:
        return 0.05;
      case AIApproach.llm:
        return 0.15;
      case AIApproach.hybrid:
        return 0.10;
    }
  }

  int _calculateEstimatedTime(AIApproach approach) {
    switch (approach) {
      case AIApproach.ruleBased:
        return 50;
      case AIApproach.localSLM:
        return 200;
      case AIApproach.rag:
        return 1000;
      case AIApproach.llm:
        return 2000;
      case AIApproach.hybrid:
        return 1500;
    }
  }

  Map<String, dynamic> _getConfiguration(AIApproach approach, RequestAnalysis analysis) {
    return {
      'domain': analysis.domain,
      'complexity': analysis.complexity.name,
      'language': analysis.metadata['language'] ?? 'english',
    };
  }

  void _showAnalysisDetails() {
    if (_currentAnalysis == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Request Analysis'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Complexity: ${_currentAnalysis!.complexity.name}'),
            Text('Domain: ${_currentAnalysis!.domain}'),
            Text('Urgent: ${_currentAnalysis!.isUrgent}'),
            Text('Privacy Level: ${_currentAnalysis!.privacyLevel.name}'),
            Text('Cost Sensitivity: ${_currentAnalysis!.costSensitivity.name}'),
            const SizedBox(height: 8),
            const Text('Metadata:', style: TextStyle(fontWeight: FontWeight.bold)),
            ..._currentAnalysis!.metadata.entries.map((e) => Text('${e.key}: ${e.value}')),
          ],
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

  void _provideFeedback(bool isPositive) {
    // In real implementation, send feedback to learning system
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Feedback recorded: ${isPositive ? 'Positive' : 'Negative'}'),
        backgroundColor: isPositive ? Colors.green : Colors.orange,
      ),
    );
  }

  void _loadHistoryItem(Map<String, dynamic> historyItem) {
    _requestController.text = historyItem['request'];
    // Could also restore the analysis and route if stored
  }

  void _clearAll() {
    setState(() {
      _requestController.clear();
      _currentAnalysis = null;
      _currentRoute = null;
      _currentResponse = null;
    });
  }

  void _clearHistory() {
    setState(() {
      _requestHistory.clear();
    });
  }

  void _showPerformanceMetrics() {
    // Show performance analytics
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Performance metrics coming soon...')),
    );
  }

  void _showRouterSettings() {
    // Show router configuration
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Router settings coming soon...')),
    );
  }
} 