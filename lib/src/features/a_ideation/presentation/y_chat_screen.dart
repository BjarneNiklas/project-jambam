import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/enhanced_chat_service.dart';
import '../data/ai_settings_service.dart';
import 'ai_settings_screen.dart'; // Import the screen to access the provider
import 'dart:developer';

// Provider für Enhanced Chat Service
final enhancedChatServiceProvider = Provider<EnhancedChatService?>((ref) {
  final aiSettingsAsync = ref.watch(aiSettingsServiceProvider);
  return aiSettingsAsync.when(
    data: (aiSettings) => EnhancedChatService(aiSettings),
    loading: () => null,
    error: (error, stack) {
      log('Error creating EnhancedChatService: $error');
      return null;
    },
  );
});

class YChatScreen extends ConsumerStatefulWidget {
  const YChatScreen({super.key});

  @override
  ConsumerState<YChatScreen> createState() => _YChatScreenState();
}

class _YChatScreenState extends ConsumerState<YChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  ChatSession? _currentSession;
  bool _isLoading = false;
  String _selectedCategory = 'chat';

  @override
  void initState() {
    super.initState();
    // Defer session initialization until the service is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeSession();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeSession() {
    // Reading the provider directly is fine here as we are in a lifecycle method
    // that runs after the initial build.
    try {
      final service = ref.read(enhancedChatServiceProvider);
      if (service == null) {
        // This case should ideally be handled by the .when() in enhancedChatServiceProvider
        // but as a fallback, we can show a message or throw an error.
        log('EnhancedChatService not available yet.');
        return;
      }
      setState(() {
        _currentSession = service.createSession(
          title: 'Y Chat Session',
          category: _selectedCategory,
        );
      });
    } catch (e) {
      // Handle the case where the service is not yet available
      // This might happen if the FutureProvider is still loading.
      // A more robust solution might involve listening to the provider state.
      log('Error initializing session: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final serviceProviderAsync = ref.watch(enhancedChatServiceProvider);
    final aiSettingsProvider = ref.watch(aiSettingsServiceProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal[400]!, Colors.teal[600]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.teal.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.chat, color: Colors.white, size: 24),
              SizedBox(width: 8),
              Text(
                'Y CHAT',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
        actions: [
          aiSettingsProvider.when(
            data: (aiSettings) => _buildModelSelector(serviceProviderAsync, aiSettings),
            loading: () => const Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            error: (err, stack) => IconButton(
              icon: const Icon(Icons.error, color: Colors.red),
              onPressed: () => ref.refresh(aiSettingsServiceProvider),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: IconButton(
              icon: Icon(Icons.settings, color: Colors.teal[300]),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AISettingsScreen()),
                );
              },
              tooltip: 'AI Einstellungen',
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCategorySelector(serviceProviderAsync),
          Expanded(
            child: _buildChatMessages(serviceProviderAsync),
          ),
          _buildMessageInput(serviceProviderAsync),
        ],
      ),
    );
  }

  Widget _buildModelSelector(EnhancedChatService? service, AISettingsService aiSettings) {
    if (service == null) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          'Lade AI-Einstellungen...',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    try {
      final currentModel = aiSettings.getModelInfoForCategory(_selectedCategory);
      final availableModels = service.getAvailableModelsForCategory(_selectedCategory);
      
      return Container(
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: PopupMenuButton<String>(
          icon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.psychology, color: Colors.teal[300], size: 16),
              const SizedBox(width: 4),
              Text(
                currentModel.name,
                style: TextStyle(color: Colors.teal[300], fontSize: 12),
              ),
              Icon(Icons.arrow_drop_down, color: Colors.teal[300], size: 16),
            ],
          ),
          itemBuilder: (context) => availableModels.map((model) {
            return PopupMenuItem(
              value: model.id,
              child: Row(
                children: [
                  Icon(
                    service.isModelAvailable(model.id) ? Icons.check_circle : Icons.circle_outlined,
                    color: service.isModelAvailable(model.id) ? Colors.teal[300] : Colors.grey,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          model.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${model.provider} • ${model.cost}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onSelected: (modelId) async {
            try {
              await aiSettings.setModelForCategory(_selectedCategory, modelId);
              setState(() {});
            } catch (e) {
              log('Error setting model: $e');
            }
          },
        ),
      );
    } catch (e) {
      log('Error building model selector: $e');
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          'Fehler beim Laden der Modelle',
          style: TextStyle(color: Colors.red),
        ),
      );
    }
  }

  Widget _buildCategorySelector(EnhancedChatService? service) {
    if (service == null) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          'Lade KI-Modelle...',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    final categories = <Map<String, dynamic>>[
      <String, dynamic>{'id': 'chat', 'name': 'Chat', 'icon': Icons.chat},
      <String, dynamic>{'id': 'concept_generation', 'name': 'Konzepte', 'icon': Icons.lightbulb},
      <String, dynamic>{'id': 'research', 'name': 'Forschung', 'icon': Icons.search},
      <String, dynamic>{'id': 'code_generation', 'name': 'Code', 'icon': Icons.code},
    ];

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category['id'];
          
          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedCategory = category['id'] as String;
                  _initializeSession();
                });
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.teal.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? Colors.teal.withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      category['icon'] as IconData,
                      color: isSelected ? Colors.teal[300] : Colors.grey,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      category['name'] as String,
                      style: TextStyle(
                        color: isSelected ? Colors.teal[300] : Colors.grey,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildChatMessages(EnhancedChatService? service) {
    if (service == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 64,
              color: Colors.grey[600],
            ),
            const SizedBox(height: 16),
            Text(
              'Lade KI-Modelle...',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Bitte warte, bis die KI-Modelle geladen sind.',
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    if (_currentSession == null || _currentSession!.messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 64,
              color: Colors.grey[600],
            ),
            const SizedBox(height: 16),
            Text(
              'Starte eine Konversation',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Wähle ein KI-Modell und beginne zu chatten',
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _currentSession!.messages.length,
      itemBuilder: (context, index) {
        final message = _currentSession!.messages[index];
        return _buildMessageBubble(message);
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage? message) {
    if (message == null) {
      return const SizedBox.shrink();
    }
    
    final isUser = message.role == 'user';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.teal[300],
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.psychology,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser 
                    ? Colors.teal.withValues(alpha: 0.2)
                    : Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isUser 
                      ? Colors.teal.withValues(alpha: 0.3)
                      : Colors.white.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(message.timestamp),
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                      if (message.modelUsed != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.teal.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            message.modelUsed!,
                            style: TextStyle(
                              color: Colors.teal[300],
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.teal[600],
                borderRadius: BorderRadius.circular(16),
              ),
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

  Widget _buildMessageInput(EnhancedChatService? service) {
    if (service == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          border: Border(
            top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
          ),
        ),
        child: const Center(
          child: Text(
            'Lade KI-Modelle...',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              ),
              child: TextField(
                controller: _messageController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Nachricht eingeben...',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(service),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal[400]!, Colors.teal[600]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.teal.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              onPressed: _isLoading ? null : () => _sendMessage(service),
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.send, color: Colors.white),
              tooltip: 'Nachricht senden',
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage(EnhancedChatService? service) async {
    if (service == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('KI-Modelle nicht geladen.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    final message = _messageController.text.trim();
    if (message.isEmpty || _isLoading) return;

    // Ensure session is initialized
    _currentSession ??= service.createSession(
      title: 'Y Chat Session',
      category: _selectedCategory,
    );

    // User-Nachricht hinzufügen
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: message,
      role: 'user',
      timestamp: DateTime.now(),
    );

    setState(() {
      _currentSession = service.addMessageToSession(_currentSession!, userMessage);
      _messageController.clear();
      _isLoading = true;
    });

    _scrollToBottom();

    try {
      // AI-Antwort erhalten
      final aiResponse = await service.sendMessage(
        message: message,
        sessionId: _currentSession!.id,
        category: _selectedCategory,
      );

      setState(() {
        _currentSession = service.addMessageToSession(_currentSession!, aiResponse);
        _isLoading = false;
      });

      _scrollToBottom();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _scrollToBottom() {
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

  String _formatTime(DateTime? time) {
    if (time == null) {
      return '';
    }
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}