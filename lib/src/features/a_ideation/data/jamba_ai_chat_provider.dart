import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'jamba_ai_orchestrator_service.dart';

class JambaAIChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;
  final List<String> activeAgents;
  final List<String> failedAgents;

  const JambaAIChatState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
    this.activeAgents = const [],
    this.failedAgents = const [],
  });

  JambaAIChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
    List<String>? activeAgents,
    List<String>? failedAgents,
  }) {
    return JambaAIChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      activeAgents: activeAgents ?? this.activeAgents,
      failedAgents: failedAgents ?? this.failedAgents,
    );
  }
}

class ChatMessage {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final String? agentName;

  const ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.agentName,
  });
}

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
    );

    try {
      // Process with orchestrator
      final response = await _orchestratorService.processRequest(message);

      // Add AI response
      final aiMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: response.content,
        isUser: false,
        timestamp: DateTime.now(),
        agentName: response.usedAgents.isNotEmpty ? response.usedAgents.first : null,
      );

      state = state.copyWith(
        messages: [...state.messages, aiMessage],
        isLoading: false,
        activeAgents: response.usedAgents,
        failedAgents: response.failedAgents,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
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
}

final jambaAIChatProvider = StateNotifierProvider<JambaAIChatNotifier, JambaAIChatState>((ref) {
  final orchestratorService = ref.watch(jambaAIOrchestratorServiceProvider);
  return JambaAIChatNotifier(orchestratorService);
}); 