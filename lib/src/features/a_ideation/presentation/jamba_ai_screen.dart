import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/jamba_ai_orchestrator_service.dart';

// Simple JumpY Action class
class JumpYAction {
  final IconData icon;
  final String label;
  final String description;
  final String prompt;
  final String category;

  const JumpYAction({
    required this.icon,
    required this.label,
    required this.description,
    required this.prompt,
    required this.category,
  });
}

// Simple Chat Message class
class ChatMessage {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final String? agentName;
  final List<String>? usedAgents;
  final List<String>? failedAgents;
  final List<String>? suggestions;

  const ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.agentName,
    this.usedAgents,
    this.failedAgents,
    this.suggestions,
  });
}

// Enhanced Chat State with Agent Tracking
class JambaAIChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;
  final List<String> activeAgents;
  final List<String> failedAgents;
  final List<String> suggestions;
  final Map<String, dynamic>? lastResponseMetadata;

  const JambaAIChatState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
    this.activeAgents = const [],
    this.failedAgents = const [],
    this.suggestions = const [],
    this.lastResponseMetadata,
  });

  JambaAIChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
    List<String>? activeAgents,
    List<String>? failedAgents,
    List<String>? suggestions,
    Map<String, dynamic>? lastResponseMetadata,
  }) {
    return JambaAIChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      activeAgents: activeAgents ?? this.activeAgents,
      failedAgents: failedAgents ?? this.failedAgents,
      suggestions: suggestions ?? this.suggestions,
      lastResponseMetadata: lastResponseMetadata ?? this.lastResponseMetadata,
    );
  }
}

// Enhanced Chat Notifier with Real Orchestrator Integration
class JambaAIChatNotifier extends StateNotifier<JambaAIChatState> {
  final JambaAIOrchestratorService _orchestratorService;

  JambaAIChatNotifier(this._orchestratorService) : super(const JambaAIChatState());

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    // Add user message
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: message,
      isUser: true,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
      error: null,
      activeAgents: [],
      failedAgents: [],
      suggestions: [],
    );

    try {
      // Process with real orchestrator
      final response = await _orchestratorService.processRequest(message);

      // Add AI response with full metadata
      final aiMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: response.content,
        isUser: false,
        timestamp: DateTime.now(),
        agentName: 'Y AI',
        usedAgents: response.usedAgents,
        failedAgents: response.failedAgents,
        suggestions: response.suggestions,
      );

      state = state.copyWith(
        messages: [...state.messages, aiMessage],
        isLoading: false,
        activeAgents: response.usedAgents,
        failedAgents: response.failedAgents,
        suggestions: response.suggestions,
        lastResponseMetadata: response.metadata,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        activeAgents: [],
        failedAgents: [],
      );
    }
  }

  // JumpY Quick Action Execution
  Future<void> executeJumpYAction(JumpYAction action) async {
    if (action.prompt.trim().isEmpty) return;

    // Add JumpY action message
    final jumpYMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: '🚀 **JumpY: ${action.label}**\n\n${action.description}',
      isUser: true,
      timestamp: DateTime.now(),
      agentName: 'JumpY',
    );

    state = state.copyWith(
      messages: [...state.messages, jumpYMessage],
      isLoading: true,
      error: null,
      activeAgents: [],
      failedAgents: [],
      suggestions: [],
    );

    try {
      // Process JumpY action with orchestrator
      final response = await _orchestratorService.processRequest(action.prompt);

      // Add AI response for JumpY action
      final aiMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: response.content,
        isUser: false,
        timestamp: DateTime.now(),
        agentName: 'Y AI',
        usedAgents: response.usedAgents,
        failedAgents: response.failedAgents,
        suggestions: response.suggestions,
      );

      state = state.copyWith(
        messages: [...state.messages, aiMessage],
        isLoading: false,
        activeAgents: response.usedAgents,
        failedAgents: response.failedAgents,
        suggestions: response.suggestions,
        lastResponseMetadata: response.metadata,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'JumpY Fehler: $e',
        activeAgents: [],
        failedAgents: [],
      );
    }
  }

  void addMessage(String content, String response, {bool isUser = false, String? agentName}) {
    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: isUser ? content : response,
      isUser: isUser,
      timestamp: DateTime.now(),
      agentName: agentName,
    );

    state = state.copyWith(
      messages: [...state.messages, message],
    );
  }

  void clearChat() {
    state = const JambaAIChatState();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void clearSuggestions() {
    state = state.copyWith(suggestions: []);
  }
}

// Provider with Orchestrator Service
final jambaAIChatProvider = StateNotifierProvider<JambaAIChatNotifier, JambaAIChatState>((ref) {
  final orchestratorService = ref.watch(jambaAIOrchestratorServiceProvider);
  return JambaAIChatNotifier(orchestratorService);
});

class JambaAIScreen extends ConsumerStatefulWidget {
  const JambaAIScreen({super.key});

  @override
  ConsumerState<JambaAIScreen> createState() => _JambaAIScreenState();
}

class _JambaAIScreenState extends ConsumerState<JambaAIScreen> {
  final TextEditingController _messageController = TextEditingController();
  
  // JumpY Quick Actions
  final List<JumpYAction> _quickActions = [
    JumpYAction(
      icon: Icons.science,
      label: 'Research',
      description: 'Schnelle Forschung',
      prompt: 'Research game development trends',
      category: 'research',
    ),
    JumpYAction(
      icon: Icons.auto_awesome,
      label: 'Creative',
      description: 'Kreative Ideen',
      prompt: 'Generate a game idea',
      category: 'creative',
    ),
    JumpYAction(
      icon: Icons.build,
      label: 'Code',
      description: 'Code generieren',
      prompt: 'Help me with game engine code',
      category: 'code',
    ),
    JumpYAction(
      icon: Icons.analytics,
      label: 'Analyze',
      description: 'Projekt analysieren',
      prompt: 'Analyze my project status',
      category: 'analysis',
    ),
    JumpYAction(
      icon: Icons.psychology,
      label: 'Brainstorm',
      description: 'Ideen entwickeln',
      prompt: 'Brainstorm game mechanics',
      category: 'creative',
    ),
    JumpYAction(
      icon: Icons.trending_up,
      label: 'Trends',
      description: 'Markt-Trends',
      prompt: 'What are current game development trends?',
      category: 'research',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(jambaAIChatProvider);
    final chatNotifier = ref.read(jambaAIChatProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.chat, color: Colors.blue),
            SizedBox(width: 8),
            Text('Y Chat'),
          ],
        ),
        actions: [
          // JumpY Quick Access
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () => _showJumpYQuickActions(context, chatNotifier),
            tooltip: 'JumpY - Schnelle Aktionen',
          ),
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: chatNotifier.clearChat,
            tooltip: 'Chat löschen',
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(context),
            tooltip: 'Info',
          ),
        ],
      ),
      body: Column(
        children: [
          // JumpY Quick Actions Bar
          _buildJumpYQuickActionsBar(chatNotifier),
          
          // Agenten-Status-Anzeige
          if (chatState.activeAgents.isNotEmpty || chatState.failedAgents.isNotEmpty)
            _buildAgentStatusBar(chatState),
          
          // Chat Messages
          Expanded(
            child: _buildChatList(chatState),
          ),
          
          // Global Suggestions Bar
          if (chatState.suggestions.isNotEmpty) _buildSuggestionsBar(chatState, chatNotifier),
          
          // Loading Indicator
          if (chatState.isLoading) _buildLoadingIndicator(),
          
          // Error Display
          if (chatState.error != null) _buildErrorDisplay(chatState.error!),
          
          // Input Section
          _buildInputSection(chatNotifier, chatState),
        ],
      ),
    );
  }

  // JumpY Quick Actions Bar
  Widget _buildJumpYQuickActionsBar(JambaAIChatNotifier chatNotifier) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        border: Border(bottom: BorderSide(color: Colors.blue[200]!)),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _quickActions.length,
        itemBuilder: (context, index) {
          final action = _quickActions[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: ActionChip(
              avatar: Icon(action.icon, size: 16, color: Colors.blue[700]),
              label: Text(
                action.label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
              backgroundColor: Colors.white,
              side: BorderSide(color: Colors.blue[300]!),
              onPressed: () => _executeJumpYAction(action, chatNotifier),
            ),
          );
        },
      ),
    );
  }

  // JumpY Quick Actions Dialog
  void _showJumpYQuickActions(BuildContext context, JambaAIChatNotifier chatNotifier) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Icon(Icons.flash_on, color: Colors.blue[700], size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'JumpY - Schnelle Aktionen',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            
            // Quick Actions Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2,
                ),
                itemCount: _quickActions.length,
                itemBuilder: (context, index) {
                  final action = _quickActions[index];
                  return _buildJumpYActionCard(action, chatNotifier);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJumpYActionCard(JumpYAction action, JambaAIChatNotifier chatNotifier) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          _executeJumpYAction(action, chatNotifier);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                action.icon,
                size: 32,
                color: _getCategoryColor(action.category),
              ),
              const SizedBox(height: 8),
              Text(
                action.label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                action.description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'research':
        return Colors.green;
      case 'creative':
        return Colors.purple;
      case 'code':
        return Colors.blue;
      case 'analysis':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  // Execute JumpY Action
  Future<void> _executeJumpYAction(JumpYAction action, JambaAIChatNotifier chatNotifier) async {
    // Show JumpY processing indicator
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.flash_on, color: Colors.white),
            const SizedBox(width: 8),
            Text('JumpY: ${action.label}...'),
          ],
        ),
        backgroundColor: Colors.blue[600],
        duration: const Duration(seconds: 2),
      ),
    );

    try {
      // Send to chat
      await chatNotifier.executeJumpYAction(action);
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('JumpY Fehler: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildAgentStatusBar(JambaAIChatState state) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (state.activeAgents.isNotEmpty) ...[
            Row(
              children: [
                const Icon(Icons.psychology, size: 16, color: Colors.blue),
                const SizedBox(width: 4),
                Text(
                  'Aktive Agenten: ${state.activeAgents.join(', ')}',
                  style: const TextStyle(fontSize: 12, color: Colors.blue),
                ),
              ],
            ),
            const SizedBox(height: 4),
          ],
          if (state.failedAgents.isNotEmpty) ...[
            Row(
              children: [
                const Icon(Icons.error_outline, size: 16, color: Colors.red),
                const SizedBox(width: 4),
                Text(
                  'Fehlgeschlagene Agenten: ${state.failedAgents.join(', ')}',
                  style: const TextStyle(fontSize: 12, color: Colors.red),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildChatList(JambaAIChatState state) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.messages.length,
      itemBuilder: (context, index) {
        final message = state.messages[index];
        return _buildChatMessage(message);
      },
    );
  }

  Widget _buildChatMessage(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue[100],
              child: Icon(
                Icons.lightbulb,
                size: 16,
                color: Colors.blue[700],
              ),
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: message.isUser ? Colors.blue[100] : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: !message.isUser && (message.usedAgents?.isNotEmpty == true || message.failedAgents?.isNotEmpty == true)
                    ? Border.all(color: Colors.blue[200]!, width: 1)
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Agent Name and Badges
                  if (message.agentName != null) ...[
                    Row(
                      children: [
                        Text(
                          message.agentName!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                        if (message.usedAgents?.isNotEmpty == true) ...[
                          const SizedBox(width: 8),
                          ...message.usedAgents!.map((agent) => Container(
                            margin: const EdgeInsets.only(right: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _getAgentDisplayName(agent),
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.green[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )),
                        ],
                        if (message.failedAgents?.isNotEmpty == true) ...[
                          const SizedBox(width: 8),
                          ...message.failedAgents!.map((agent) => Container(
                            margin: const EdgeInsets.only(right: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _getAgentDisplayName(agent),
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.red[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                  
                  // Message Content with Markdown-like formatting
                  Text(
                    _formatMessageContent(message.content),
                    style: const TextStyle(fontSize: 14),
                  ),
                  
                  // Suggestions
                  if (message.suggestions?.isNotEmpty == true) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.lightbulb_outline, size: 16, color: Colors.blue[700]),
                              const SizedBox(width: 4),
                              Text(
                                'Vorschläge:',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[700],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: message.suggestions!.map((suggestion) => ActionChip(
                              label: Text(
                                suggestion,
                                style: const TextStyle(fontSize: 12),
                              ),
                              backgroundColor: Colors.white,
                              side: BorderSide(color: Colors.blue[300]!),
                              onPressed: () {
                                // Auto-fill suggestion in input
                                _messageController.text = suggestion;
                                _messageController.selection = TextSelection.fromPosition(
                                  TextPosition(offset: suggestion.length),
                                );
                              },
                            )).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey[300],
              child: const Icon(
                Icons.person,
                size: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Format message content with basic markdown-like formatting
  String _formatMessageContent(String content) {
    // Simple markdown formatting
    String formatted = content;
    
    // Bold text (**text**)
    formatted = formatted.replaceAllMapped(
      RegExp(r'\*\*(.*?)\*\*'),
      (match) => match.group(1) ?? '',
    );
    
    // Code blocks (```code```)
    formatted = formatted.replaceAllMapped(
      RegExp(r'```(.*?)```', dotAll: true),
      (match) => 'Code: ${match.group(1)?.trim() ?? ''}',
    );
    
    // Inline code (`code`)
    formatted = formatted.replaceAllMapped(
      RegExp(r'`(.*?)`'),
      (match) => 'Code: ${match.group(1) ?? ''}',
    );
    
    return formatted;
  }

  // Get display name for agent
  String _getAgentDisplayName(String agentId) {
    switch (agentId) {
      case 'creative_director':
        return 'Creative Director';
      case 'game_engine':
        return 'Game Engine';
      case 'asset_generation':
        return 'Asset Generation';
      case 'project_master':
        return 'Project Master';
      case 'research':
        return 'Research';
      default:
        return agentId;
    }
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 16),
          Text('Y AI denkt nach...'),
        ],
      ),
    );
  }

  Widget _buildErrorDisplay(String error) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.red[50],
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red[700]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Fehler: $error',
              style: TextStyle(color: Colors.red[700]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputSection(JambaAIChatNotifier chatNotifier, JambaAIChatState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Frag Y AI...',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              maxLines: null,
              enabled: !state.isLoading,
              onSubmitted: (text) {
                if (text.trim().isNotEmpty) {
                  chatNotifier.sendMessage(text);
                  _messageController.clear();
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: state.isLoading
                ? null
                : () {
                    if (_messageController.text.trim().isNotEmpty) {
                      chatNotifier.sendMessage(_messageController.text);
                      _messageController.clear();
                    }
                  },
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Y AI - Multi-Agenten-System'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Y AI nutzt ein intelligentes Multi-Agenten-System:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text('🔬 Research Agent - Wissenschaftliche Quellen'),
              Text('🎭 Creative Director - Game Design & Storytelling'),
              Text('🎨 Asset Generation - 3D Models, Texturen, Audio'),
              Text('💻 Game Engine - Code für Unity, Godot, Bevy, Unreal'),
              Text('📊 Project Master - Projekt-Management & Analyse'),
              SizedBox(height: 12),
              Text(
                'JumpY ist der schnelle, intelligente Assistent für sofortige Aktionen.',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Verstanden'),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionsBar(JambaAIChatState state, JambaAIChatNotifier chatNotifier) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        border: Border(top: BorderSide(color: Colors.blue[200]!)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, size: 16, color: Colors.blue[700]),
              const SizedBox(width: 4),
              Text(
                'Globale Vorschläge:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: state.suggestions.map((suggestion) => ActionChip(
              label: Text(
                suggestion,
                style: const TextStyle(fontSize: 12),
              ),
              backgroundColor: Colors.white,
              side: BorderSide(color: Colors.blue[300]!),
              onPressed: () {
                // Auto-fill suggestion in input
                _messageController.text = suggestion;
                _messageController.selection = TextSelection.fromPosition(
                  TextPosition(offset: suggestion.length),
                );
              },
            )).toList(),
          ),
        ],
      ),
    );
  }
} 