import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../../core/ai/ai_orchestrator_provider.dart';
import '../../../core/ai/ai_architecture_system.dart';
import '../data/enhanced_agent_services.dart';

class EnhancedJambaAIScreen extends ConsumerStatefulWidget {
  const EnhancedJambaAIScreen({super.key});

  @override
  ConsumerState<EnhancedJambaAIScreen> createState() => _EnhancedJambaAIScreenState();
}

class _EnhancedJambaAIScreenState extends ConsumerState<EnhancedJambaAIScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String _currentModel = 'Auto';
  double _currentConfidence = 0.0;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jamba AI - Enhanced'),
        actions: [
          // AI Performance Monitor
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: _showPerformanceMetrics,
          ),
          // AI Settings
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showAISettings,
          ),
        ],
      ),
      body: Column(
        children: [
          // AI Status Bar
          _buildAIStatusBar(),
          
          // Chat Messages
          Expanded(
            child: _buildChatMessages(),
          ),
          
          // Input Section
          _buildInputSection(),
        ],
      ),
    );
  }

  Widget _buildAIStatusBar() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Model Indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getModelColor(_currentModel),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _currentModel,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          
          // Confidence Indicator
          if (_currentConfidence > 0)
            Row(
              children: [
                Icon(
                  Icons.psychology,
                  size: 16,
                  color: _getConfidenceColor(_currentConfidence),
                ),
                const SizedBox(width: 4),
                Text(
                  '${(_currentConfidence * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 12,
                    color: _getConfidenceColor(_currentConfidence),
                  ),
                ),
              ],
            ),
          
          const Spacer(),
          
          // AI Status
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                'AI Ready',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChatMessages() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return _buildChatMessage(message);
      },
    );
  }

  Widget _buildChatMessage(ChatMessage message) {
    final isUser = message.isUser;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              backgroundColor: _getModelColor(message.modelUsed),
              child: Icon(
                _getModelIcon(message.modelUsed),
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
          ],
          
          Expanded(
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUser 
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isUser) ...[
                        // Model info
                        Row(
                          children: [
                            Text(
                              message.modelUsed,
                              style: TextStyle(
                                fontSize: 10,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (message.confidence > 0) ...[
                              const SizedBox(width: 8),
                              Text(
                                '${(message.confidence * 100).toInt()}% confidence',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                      ],
                      
                      // Message content
                      if (message.isMarkdown)
                        MarkdownBody(
                          data: message.content,
                          styleSheet: MarkdownStyleSheet(
                            textScaler: const TextScaler.linear(0.9),
                          ),
                        )
                      else
                        Text(message.content),
                      
                      // Sources
                      if (message.sources.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Sources: ${message.sources.join(', ')}',
                          style: TextStyle(
                            fontSize: 10,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                
                // Timestamp
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    _formatTimestamp(message.timestamp),
                    style: TextStyle(
                      fontSize: 10,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          if (isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInputSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Quick Actions
          _buildQuickActions(),
          
          const SizedBox(height: 12),
          
          // Input Field
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Ask Jamba AI anything...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  maxLines: null,
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 8),
              FloatingActionButton(
                onPressed: _isLoading ? null : _sendMessage,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.send),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final quickActions = [
      {'icon': Icons.science, 'label': 'Research', 'prompt': 'Research game development trends'},
      {'icon': Icons.auto_awesome, 'label': 'Creative', 'prompt': 'Generate a game idea'},
      {'icon': Icons.build, 'label': 'Code', 'prompt': 'Help me with game engine code'},
      {'icon': Icons.analytics, 'label': 'Analyze', 'prompt': 'Analyze my project status'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: quickActions.map((action) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ActionChip(
              avatar: Icon(action['icon'] as IconData, size: 16),
              label: Text(action['label'] as String),
              onPressed: () => _sendQuickAction(action['prompt'] as String),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Helper Methods
  Color _getModelColor(String model) {
    switch (model) {
      case 'SLM':
        return Colors.green;
      case 'LLM':
        return Colors.blue;
      case 'RAG':
        return Colors.orange;
      case 'Hybrid':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getModelIcon(String model) {
    switch (model) {
      case 'SLM':
        return Icons.flash_on;
      case 'LLM':
        return Icons.psychology;
      case 'RAG':
        return Icons.search;
      case 'Hybrid':
        return Icons.merge;
      default:
        return Icons.auto_awesome;
    }
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.8) return Colors.green;
    if (confidence >= 0.6) return Colors.orange;
    return Colors.red;
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
  }

  // Actions
  void _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty || _isLoading) return;

    // Add user message
    _addMessage(message, true);
    _messageController.clear();

    setState(() {
      _isLoading = true;
    });

    try {
      // Process with enhanced AI orchestrator
      final orchestrator = ref.read(enhancedJambaAIOrchestratorServiceProvider);
      final response = await orchestrator.processUserRequest(message, {
        'user_context': 'game_developer',
        'platform': 'jamba_ai',
      });

      // Update UI with response
      _addMessage(
        response.content,
        false,
        modelUsed: _getModelTypeName(response.usedModel.type),
        confidence: response.confidence,
        sources: response.sources,
        isMarkdown: true,
      );

      // Update status
      setState(() {
        _currentModel = _getModelTypeName(response.usedModel.type);
        _currentConfidence = response.confidence;
      });

    } catch (e) {
      _addMessage(
        'Sorry, I encountered an error: $e',
        false,
        modelUsed: 'Error',
        confidence: 0.0,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _sendQuickAction(String prompt) {
    _messageController.text = prompt;
    _sendMessage();
  }

  void _addMessage(
    String content,
    bool isUser, {
    String modelUsed = '',
    double confidence = 0.0,
    List<String> sources = const [],
    bool isMarkdown = false,
  }) {
    setState(() {
      _messages.add(ChatMessage(
        content: content,
        isUser: isUser,
        timestamp: DateTime.now(),
        modelUsed: modelUsed,
        confidence: confidence,
        sources: sources,
        isMarkdown: isMarkdown,
      ));
    });

    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _getModelTypeName(AIModelType type) {
    switch (type) {
      case AIModelType.slm:
        return 'SLM';
      case AIModelType.llm:
        return 'LLM';
      case AIModelType.rag:
        return 'RAG';
      case AIModelType.hybrid:
        return 'Hybrid';
    }
  }

  void _showPerformanceMetrics() {
    final metrics = ref.read(aiPerformanceMetricsProvider);
    final metricsData = metrics.getMetrics();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AI Performance Metrics'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Request Counts:'),
              ...metricsData['requestCounts'].entries.map((e) => 
                Text('  ${e.key}: ${e.value}')),
              const SizedBox(height: 16),
              Text('Average Response Times:'),
              ...metricsData['averageResponseTimes'].entries.map((e) => 
                Text('  ${e.key}: ${e.value.toStringAsFixed(0)}ms')),
              const SizedBox(height: 16),
              Text('Success Rates:'),
              ...metricsData['successRates'].entries.map((e) => 
                Text('  ${e.key}: ${e.value}%')),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAISettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AI Settings'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('AI settings configuration coming soon...'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

// Chat Message Model
class ChatMessage {
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final String modelUsed;
  final double confidence;
  final List<String> sources;
  final bool isMarkdown;

  ChatMessage({
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.modelUsed = '',
    this.confidence = 0.0,
    this.sources = const [],
    this.isMarkdown = false,
  });
} 