import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/ai/enhanced_ai_providers.dart';

class AIMultimodalScreen extends ConsumerStatefulWidget {
  const AIMultimodalScreen({super.key});

  @override
  ConsumerState<AIMultimodalScreen> createState() => _AIMultimodalScreenState();
}

class _AIMultimodalScreenState extends ConsumerState<AIMultimodalScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  bool _isRecording = false;
  bool _isProcessing = false;
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  List<Map<String, dynamic>> _conversationHistory = [];
  String _currentInput = '';
  String _currentResponse = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Multimodal Interface'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: _clearConversation,
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportConversation,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.chat), text: 'Text'),
            Tab(icon: Icon(Icons.mic), text: 'Voice'),
            Tab(icon: Icon(Icons.image), text: 'Image'),
            Tab(icon: Icon(Icons.video_library), text: 'Media'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Conversation History
          Expanded(
            child: _buildConversationHistory(),
          ),
          
          // Input Area
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildConversationHistory() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _conversationHistory.length + (_currentResponse.isNotEmpty ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _conversationHistory.length && _currentResponse.isNotEmpty) {
          return _buildResponseCard(_currentResponse, 'processing');
        }
        
        final message = _conversationHistory[index];
        final isUser = message['type'] == 'user';
        
        return _buildMessageCard(message, isUser);
      },
    );
  }

  Widget _buildMessageCard(Map<String, dynamic> message, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue[100] : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getMessageIcon(message['input_type']),
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  message['input_type']?.toString().toUpperCase() ?? 'TEXT',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              message['content'] ?? '',
              style: const TextStyle(fontSize: 14),
            ),
            if (message['timestamp'] != null) ...[
              const SizedBox(height: 4),
              Text(
                _formatTimestamp(message['timestamp']),
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResponseCard(String response, String status) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.psychology,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  'AI RESPONSE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                const Spacer(),
                if (status == 'processing')
                  const SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              response,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildTextInput(),
          _buildVoiceInput(),
          _buildImageInput(),
          _buildMediaInput(),
        ],
      ),
    );
  }

  Widget _buildTextInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _textController,
            decoration: const InputDecoration(
              hintText: 'Type your message...',
              border: OutlineInputBorder(),
            ),
            maxLines: null,
            onChanged: (value) {
              setState(() {
                _currentInput = value;
              });
            },
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: _currentInput.isNotEmpty ? _sendTextMessage : null,
          icon: const Icon(Icons.send),
          color: _currentInput.isNotEmpty ? Colors.blue : Colors.grey,
        ),
      ],
    );
  }

  Widget _buildVoiceInput() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: _isRecording ? null : _startVoiceRecording,
              icon: Icon(_isRecording ? Icons.stop : Icons.mic),
              color: _isRecording ? Colors.red : Colors.blue,
              iconSize: 32,
            ),
            if (_isRecording)
              const Text(
                'Recording...',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
          ],
        ),
        if (_currentInput.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Transcribed: $_currentInput',
              style: const TextStyle(fontSize: 12),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _sendVoiceMessage,
                  child: const Text('Send Voice Message'),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _clearVoiceInput,
                icon: const Icon(Icons.clear),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildImageInput() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.photo_library),
              label: const Text('Gallery'),
            ),
            ElevatedButton.icon(
              onPressed: _takePhoto,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Camera'),
            ),
          ],
        ),
        if (_currentInput.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Image Description: $_currentInput',
              style: const TextStyle(fontSize: 12),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _sendImageMessage,
                  child: const Text('Send Image'),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _clearImageInput,
                icon: const Icon(Icons.clear),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildMediaInput() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: _pickVideo,
              icon: const Icon(Icons.video_library),
              label: const Text('Video'),
            ),
            ElevatedButton.icon(
              onPressed: _pickAudio,
              icon: const Icon(Icons.audiotrack),
              label: const Text('Audio'),
            ),
            ElevatedButton.icon(
              onPressed: _pickDocument,
              icon: const Icon(Icons.description),
              label: const Text('Document'),
            ),
          ],
        ),
        if (_currentInput.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Media Description: $_currentInput',
              style: const TextStyle(fontSize: 12),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _sendMediaMessage,
                  child: const Text('Send Media'),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _clearMediaInput,
                icon: const Icon(Icons.clear),
              ),
            ],
          ),
        ],
      ],
    );
  }

  // Helper methods
  IconData _getMessageIcon(String? inputType) {
    switch (inputType) {
      case 'voice':
        return Icons.mic;
      case 'image':
        return Icons.image;
      case 'video':
        return Icons.video_library;
      case 'audio':
        return Icons.audiotrack;
      case 'document':
        return Icons.description;
      default:
        return Icons.chat;
    }
  }

  String _formatTimestamp(String? timestamp) {
    if (timestamp == null) return '';
    try {
      final date = DateTime.parse(timestamp);
      return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return '';
    }
  }

  // Action methods
  void _sendTextMessage() async {
    if (_currentInput.isEmpty) return;

    final message = {
      'type': 'user',
      'input_type': 'text',
      'content': _currentInput,
      'timestamp': DateTime.now().toIso8601String(),
    };

    setState(() {
      _conversationHistory.add(message);
      _currentResponse = 'Processing your message...';
      _textController.clear();
      _currentInput = '';
    });

    _scrollToBottom();

    try {
      final service = ref.read(enhancedAIServiceProvider);
      final response = await service.processMultimodalInput(
        message['content'] as String,
        context: {'type': 'text'},
      );

      setState(() {
        _currentResponse = '';
        _conversationHistory.add({
          'type': 'ai',
          'input_type': 'text',
          'content': response,
          'timestamp': DateTime.now().toIso8601String(),
        });
      });

      _scrollToBottom();
    } catch (e) {
      setState(() {
        _currentResponse = '';
        _conversationHistory.add({
          'type': 'ai',
          'input_type': 'text',
          'content': 'Error: $e',
          'timestamp': DateTime.now().toIso8601String(),
        });
      });
    }
  }

  void _startVoiceRecording() async {
    setState(() {
      _isRecording = true;
    });

    try {
      final service = ref.read(enhancedAIServiceProvider);
      final result = await service.startVoiceRecording();
      
      setState(() {
        _isRecording = false;
        _currentInput = result['transcription'] ?? '';
      });
    } catch (e) {
      setState(() {
        _isRecording = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Voice recording failed: $e')),
      );
    }
  }

  void _sendVoiceMessage() async {
    if (_currentInput.isEmpty) return;

    final message = {
      'type': 'user',
      'input_type': 'voice',
      'content': _currentInput,
      'timestamp': DateTime.now().toIso8601String(),
    };

    setState(() {
      _conversationHistory.add(message);
      _currentResponse = 'Processing voice message...';
    });

    _scrollToBottom();

    try {
      final service = ref.read(enhancedAIServiceProvider);
      final response = await service.processMultimodalInput({
        'type': 'voice',
        'content': message['content'],
      });

      setState(() {
        _currentResponse = '';
        _conversationHistory.add({
          'type': 'ai',
          'input_type': 'voice',
          'content': response['response'] ?? 'No response received',
          'timestamp': DateTime.now().toIso8601String(),
        });
        _currentInput = '';
      });

      _scrollToBottom();
    } catch (e) {
      setState(() {
        _currentResponse = '';
        _conversationHistory.add({
          'type': 'ai',
          'input_type': 'voice',
          'content': 'Error: $e',
          'timestamp': DateTime.now().toIso8601String(),
        });
      });
    }
  }

  void _pickImage() async {
    try {
      final service = ref.read(enhancedAIServiceProvider);
      final result = await service.pickImage();
      
      setState(() {
        _currentInput = result['description'] ?? 'Image selected';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image selection failed: $e')),
      );
    }
  }

  void _takePhoto() async {
    try {
      final service = ref.read(enhancedAIServiceProvider);
      final result = await service.takePhoto();
      
      setState(() {
        _currentInput = result['description'] ?? 'Photo taken';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Photo capture failed: $e')),
      );
    }
  }

  void _sendImageMessage() async {
    if (_currentInput.isEmpty) return;

    final message = {
      'type': 'user',
      'input_type': 'image',
      'content': _currentInput,
      'timestamp': DateTime.now().toIso8601String(),
    };

    setState(() {
      _conversationHistory.add(message);
      _currentResponse = 'Analyzing image...';
    });

    _scrollToBottom();

    try {
      final service = ref.read(enhancedAIServiceProvider);
      final response = await service.processMultimodalInput({
        'type': 'image',
        'content': message['content'],
      });

      setState(() {
        _currentResponse = '';
        _conversationHistory.add({
          'type': 'ai',
          'input_type': 'image',
          'content': response['response'] ?? 'No response received',
          'timestamp': DateTime.now().toIso8601String(),
        });
        _currentInput = '';
      });

      _scrollToBottom();
    } catch (e) {
      setState(() {
        _currentResponse = '';
        _conversationHistory.add({
          'type': 'ai',
          'input_type': 'image',
          'content': 'Error: $e',
          'timestamp': DateTime.now().toIso8601String(),
        });
      });
    }
  }

  void _pickVideo() async {
    try {
      final service = ref.read(enhancedAIServiceProvider);
      final result = await service.pickVideo();
      
      setState(() {
        _currentInput = result['description'] ?? 'Video selected';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Video selection failed: $e')),
      );
    }
  }

  void _pickAudio() async {
    try {
      final service = ref.read(enhancedAIServiceProvider);
      final result = await service.pickAudio();
      
      setState(() {
        _currentInput = result['description'] ?? 'Audio selected';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Audio selection failed: $e')),
      );
    }
  }

  void _pickDocument() async {
    try {
      final service = ref.read(enhancedAIServiceProvider);
      final result = await service.pickDocument();
      
      setState(() {
        _currentInput = result['description'] ?? 'Document selected';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Document selection failed: $e')),
      );
    }
  }

  void _sendMediaMessage() async {
    if (_currentInput.isEmpty) return;

    final message = {
      'type': 'user',
      'input_type': 'media',
      'content': _currentInput,
      'timestamp': DateTime.now().toIso8601String(),
    };

    setState(() {
      _conversationHistory.add(message);
      _currentResponse = 'Processing media...';
    });

    _scrollToBottom();

    try {
      final service = ref.read(enhancedAIServiceProvider);
      final response = await service.processMultimodalInput({
        'type': 'media',
        'content': message['content'],
      });

      setState(() {
        _currentResponse = '';
        _conversationHistory.add({
          'type': 'ai',
          'input_type': 'media',
          'content': response['response'] ?? 'No response received',
          'timestamp': DateTime.now().toIso8601String(),
        });
        _currentInput = '';
      });

      _scrollToBottom();
    } catch (e) {
      setState(() {
        _currentResponse = '';
        _conversationHistory.add({
          'type': 'ai',
          'input_type': 'media',
          'content': 'Error: $e',
          'timestamp': DateTime.now().toIso8601String(),
        });
      });
    }
  }

  void _clearVoiceInput() {
    setState(() {
      _currentInput = '';
    });
  }

  void _clearImageInput() {
    setState(() {
      _currentInput = '';
    });
  }

  void _clearMediaInput() {
    setState(() {
      _currentInput = '';
    });
  }

  void _clearConversation() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Conversation'),
        content: const Text('Are you sure you want to clear the entire conversation?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _conversationHistory.clear();
        _currentResponse = '';
        _currentInput = '';
        _textController.clear();
      });
    }
  }

  void _exportConversation() async {
    try {
      final service = ref.read(enhancedAIServiceProvider);
      await service.exportConversation(_conversationHistory);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Conversation exported successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export failed: $e')),
      );
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
} 