import 'dart:convert';
import 'package:http/http.dart' as http;

class MLCLLMService {
  static const String _baseUrl = 'http://localhost:8000';
  static const String _apiPrefix = '/v1';
  
  // Model categories and their typical use cases
  static const Map<String, List<String>> _modelCategories = {
    'chat': ['llama-2-7b-chat', 'mistral-7b-instruct', 'gemma-2b-it'],
    'code': ['codellama-7b-instruct', 'deepseek-coder-6.7b', 'wizardcoder-7b'],
    'creative': ['llama-2-7b', 'mistral-7b', 'gemma-2b'],
    'multimodal': ['llava-1.5-7b', 'bakllava-1-7b'],
  };

  // Model specifications with realistic performance metrics
  static const Map<String, Map<String, dynamic>> _modelSpecs = {
    'llama-2-7b-chat': {
      'size': '7B',
      'context': 4096,
      'speed': 'medium',
      'quality': 'high',
      'memory': '4GB',
      'use_cases': ['chat', 'assistant', 'general'],
    },
    'mistral-7b-instruct': {
      'size': '7B',
      'context': 8192,
      'speed': 'fast',
      'quality': 'high',
      'memory': '4GB',
      'use_cases': ['chat', 'instruction', 'reasoning'],
    },
    'gemma-2b-it': {
      'size': '2B',
      'context': 8192,
      'speed': 'very_fast',
      'quality': 'medium',
      'memory': '2GB',
      'use_cases': ['chat', 'lightweight', 'mobile'],
    },
    'codellama-7b-instruct': {
      'size': '7B',
      'context': 4096,
      'speed': 'medium',
      'quality': 'high',
      'memory': '4GB',
      'use_cases': ['code', 'programming', 'debugging'],
    },
    'deepseek-coder-6.7b': {
      'size': '6.7B',
      'context': 4096,
      'speed': 'medium',
      'quality': 'high',
      'memory': '4GB',
      'use_cases': ['code', 'programming', 'analysis'],
    },
    'wizardcoder-7b': {
      'size': '7B',
      'context': 4096,
      'speed': 'medium',
      'quality': 'high',
      'memory': '4GB',
      'use_cases': ['code', 'programming', 'generation'],
    },
    'llava-1.5-7b': {
      'size': '7B',
      'context': 4096,
      'speed': 'slow',
      'quality': 'high',
      'memory': '6GB',
      'use_cases': ['vision', 'image_analysis', 'multimodal'],
    },
  };

  // Server status tracking
  bool _isServerRunning = false;
  bool _isInitialized = false;
  String? _currentModel;
  final Map<String, dynamic> _serverStatus = {};

  // Performance tracking
  final Map<String, List<double>> _responseTimes = {};
  final Map<String, int> _requestCounts = {};

  // Getters
  bool get isServerRunning => _isServerRunning;
  bool get isInitialized => _isInitialized;
  String? get currentModel => _currentModel;
  Map<String, dynamic> get serverStatus => _serverStatus;
  Map<String, List<double>> get responseTimes => _responseTimes;
  Map<String, int> get requestCounts => _requestCounts;

  // Model management
  List<String> get availableModels => _modelSpecs.keys.toList();
  Map<String, Map<String, dynamic>> get modelSpecs => _modelSpecs;
  Map<String, List<String>> get modelCategories => _modelCategories;

  // Initialize the service
  Future<bool> initialize() async {
    try {
      // Check if server is already running
      final isRunning = await _checkServerStatus();
      if (isRunning) {
        _isServerRunning = true;
        await _loadServerStatus();
        _isInitialized = true;
        return true;
      }

      // Try to start server
      final started = await startServer();
      if (started) {
        _isInitialized = true;
        return true;
      }

      return false;
    } catch (e) {
      // Log error silently for now
      return false;
    }
  }

  // Check if MLC LLM server is running
  Future<bool> _checkServerStatus() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl$_apiPrefix/models'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 5));
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Start MLC LLM server
  Future<bool> startServer() async {
    try {
      // In a real implementation, this would start the MLC LLM server process
      // For now, we'll simulate the server startup
      
      // Simulate server startup delay
      await Future.delayed(const Duration(seconds: 2));
      
      // Check if server started successfully
      final isRunning = await _checkServerStatus();
      if (isRunning) {
        _isServerRunning = true;
        await _loadServerStatus();
        return true;
      }
      
      return false;
    } catch (e) {
      // Log error silently for now
      return false;
    }
  }

  // Stop MLC LLM server
  Future<bool> stopServer() async {
    try {
      // In a real implementation, this would stop the MLC LLM server process
      
      // Simulate server shutdown
      await Future.delayed(const Duration(seconds: 1));
      
      _isServerRunning = false;
      _currentModel = null;
      _serverStatus.clear();
      
      return true;
    } catch (e) {
      // Log error silently for now
      return false;
    }
  }

  // Load server status and available models
  Future<void> _loadServerStatus() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl$_apiPrefix/models'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _serverStatus['models'] = data['data'] ?? [];
        _serverStatus['object'] = data['object'] ?? 'list';
      }
    } catch (e) {
      // Log error silently for now
      // Fallback to static data
      _serverStatus['models'] = _modelSpecs.keys.map((model) => {
        'id': model,
        'object': 'model',
        'created': DateTime.now().millisecondsSinceEpoch,
        'owned_by': 'mlc-llm',
      }).toList();
      _serverStatus['object'] = 'list';
    }
  }

  // Load a specific model
  Future<bool> loadModel(String modelId) async {
    if (!_isServerRunning) {
      return false;
    }

    try {
      // In a real implementation, this would load the model via API
      // For now, we'll simulate model loading
      
      // Simulate model loading delay based on model size
      final modelSpec = _modelSpecs[modelId];
      final loadingTime = modelSpec?['size'] == '2B' ? 3 : 8;
      await Future.delayed(Duration(seconds: loadingTime));
      
      _currentModel = modelId;
      
      return true;
    } catch (e) {
      // Log error silently for now
      return false;
    }
  }

  // Generate text completion
  Future<Map<String, dynamic>> generateCompletion({
    required String prompt,
    String? modelId,
    int maxTokens = 1000,
    double temperature = 0.7,
    double topP = 0.9,
    int topK = 40,
    bool stream = false,
  }) async {
    if (!_isServerRunning) {
      throw Exception('MLC LLM server is not running');
    }

    final model = modelId ?? _currentModel;
    if (model == null) {
      throw Exception('No model loaded');
    }

    try {
      final startTime = DateTime.now();
      
      final requestBody = {
        'model': model,
        'prompt': prompt,
        'max_tokens': maxTokens,
        'temperature': temperature,
        'top_p': topP,
        'top_k': topK,
        'stream': stream,
      };

      final response = await http.post(
        Uri.parse('$_baseUrl$_apiPrefix/completions'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      ).timeout(const Duration(seconds: 30));

      final responseTime = DateTime.now().difference(startTime).inMilliseconds;
      
      // Track performance
      if (!_responseTimes.containsKey(model)) {
        _responseTimes[model] = [];
      }
      _responseTimes[model]!.add(responseTime.toDouble());
      
      if (!_requestCounts.containsKey(model)) {
        _requestCounts[model] = 0;
      }
      _requestCounts[model] = _requestCounts[model]! + 1;

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Add performance metrics to response
        data['performance'] = {
          'response_time_ms': responseTime,
          'model': model,
          'tokens_generated': data['choices']?[0]?['text']?.split(' ').length ?? 0,
        };
        
        return data;
      } else {
        throw Exception('API request failed: ${response.statusCode}');
      }
    } catch (e) {
      // Log error silently for now
      // Return fallback response for demo purposes
      return _generateFallbackResponse(prompt, model, maxTokens);
    }
  }

  // Generate chat completion
  Future<Map<String, dynamic>> generateChatCompletion({
    required List<Map<String, String>> messages,
    String? modelId,
    int maxTokens = 1000,
    double temperature = 0.7,
    double topP = 0.9,
    int topK = 40,
    bool stream = false,
  }) async {
    if (!_isServerRunning) {
      throw Exception('MLC LLM server is not running');
    }

    final model = modelId ?? _currentModel;
    if (model == null) {
      throw Exception('No model loaded');
    }

    try {
      final startTime = DateTime.now();
      
      final requestBody = {
        'model': model,
        'messages': messages,
        'max_tokens': maxTokens,
        'temperature': temperature,
        'top_p': topP,
        'top_k': topK,
        'stream': stream,
      };

      final response = await http.post(
        Uri.parse('$_baseUrl$_apiPrefix/chat/completions'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      ).timeout(const Duration(seconds: 30));

      final responseTime = DateTime.now().difference(startTime).inMilliseconds;
      
      // Track performance
      if (!_responseTimes.containsKey(model)) {
        _responseTimes[model] = [];
      }
      _responseTimes[model]!.add(responseTime.toDouble());
      
      if (!_requestCounts.containsKey(model)) {
        _requestCounts[model] = 0;
      }
      _requestCounts[model] = _requestCounts[model]! + 1;

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Add performance metrics to response
        data['performance'] = {
          'response_time_ms': responseTime,
          'model': model,
          'tokens_generated': data['choices']?[0]?['message']?['content']?.split(' ').length ?? 0,
        };
        
        return data;
      } else {
        throw Exception('API request failed: ${response.statusCode}');
      }
    } catch (e) {
      // Log error silently for now
      // Return fallback response for demo purposes
      return _generateFallbackChatResponse(messages, model, maxTokens);
    }
  }

  // Fallback response for demo purposes
  Map<String, dynamic> _generateFallbackResponse(String prompt, String model, int maxTokens) {
    final responses = {
      'llama-2-7b-chat': 'This is a simulated response from Llama 2 7B Chat model. The actual response would be generated by the loaded model.',
      'mistral-7b-instruct': 'This is a simulated response from Mistral 7B Instruct model. The model would process your request and generate appropriate text.',
      'gemma-2b-it': 'This is a simulated response from Gemma 2B IT model. This lightweight model is optimized for chat interactions.',
      'codellama-7b-instruct': 'This is a simulated response from Code Llama 7B Instruct model. This model is specialized for code generation and programming tasks.',
      'deepseek-coder-6.7b': 'This is a simulated response from DeepSeek Coder 6.7B model. This model excels at code analysis and generation.',
      'wizardcoder-7b': 'This is a simulated response from WizardCoder 7B model. This model is designed for code generation and programming assistance.',
      'llava-1.5-7b': 'This is a simulated response from LLaVA 1.5 7B model. This multimodal model can process both text and images.',
    };

    return {
      'id': 'simulated-${DateTime.now().millisecondsSinceEpoch}',
      'object': 'text_completion',
      'created': DateTime.now().millisecondsSinceEpoch,
      'model': model,
      'choices': [
        {
          'text': responses[model] ?? 'Simulated response from MLC LLM.',
          'index': 0,
          'logprobs': null,
          'finish_reason': 'length',
        }
      ],
      'usage': {
        'prompt_tokens': prompt.split(' ').length,
        'completion_tokens': 20,
        'total_tokens': prompt.split(' ').length + 20,
      },
      'performance': {
        'response_time_ms': 1500,
        'model': model,
        'tokens_generated': 20,
        'simulated': true,
      },
    };
  }

  // Fallback chat response for demo purposes
  Map<String, dynamic> _generateFallbackChatResponse(List<Map<String, String>> messages, String model, int maxTokens) {
    final lastMessage = messages.last['content'] ?? '';
    final responses = {
      'llama-2-7b-chat': 'This is a simulated chat response from Llama 2 7B Chat model. I understand your message: "$lastMessage"',
      'mistral-7b-instruct': 'This is a simulated chat response from Mistral 7B Instruct model. I can help you with: "$lastMessage"',
      'gemma-2b-it': 'This is a simulated chat response from Gemma 2B IT model. Your message: "$lastMessage"',
      'codellama-7b-instruct': 'This is a simulated chat response from Code Llama 7B Instruct model. I can assist with programming: "$lastMessage"',
      'deepseek-coder-6.7b': 'This is a simulated chat response from DeepSeek Coder 6.7B model. Code-related query: "$lastMessage"',
      'wizardcoder-7b': 'This is a simulated chat response from WizardCoder 7B model. Programming assistance: "$lastMessage"',
      'llava-1.5-7b': 'This is a simulated chat response from LLaVA 1.5 7B model. Multimodal query: "$lastMessage"',
    };

    return {
      'id': 'simulated-chat-${DateTime.now().millisecondsSinceEpoch}',
      'object': 'chat.completion',
      'created': DateTime.now().millisecondsSinceEpoch,
      'model': model,
      'choices': [
        {
          'index': 0,
          'message': {
            'role': 'assistant',
            'content': responses[model] ?? 'Simulated chat response from MLC LLM.',
          },
          'finish_reason': 'stop',
        }
      ],
      'usage': {
        'prompt_tokens': messages.fold(0, (sum, msg) => sum + (msg['content']?.split(' ').length ?? 0)),
        'completion_tokens': 25,
        'total_tokens': messages.fold(0, (sum, msg) => sum + (msg['content']?.split(' ').length ?? 0)) + 25,
      },
      'performance': {
        'response_time_ms': 1800,
        'model': model,
        'tokens_generated': 25,
        'simulated': true,
      },
    };
  }

  // Get performance statistics
  Map<String, dynamic> getPerformanceStats() {
    final stats = <String, dynamic>{};
    
    _responseTimes.forEach((model, times) {
      if (times.isNotEmpty) {
        final avgTime = times.reduce((a, b) => a + b) / times.length;
        final minTime = times.reduce((a, b) => a < b ? a : b);
        final maxTime = times.reduce((a, b) => a > b ? a : b);
        
        stats[model] = {
          'average_response_time_ms': avgTime,
          'min_response_time_ms': minTime,
          'max_response_time_ms': maxTime,
          'total_requests': _requestCounts[model] ?? 0,
          'total_time_ms': times.reduce((a, b) => a + b),
        };
      }
    });
    
    return stats;
  }

  // Get model recommendations based on use case
  List<String> getModelRecommendations(String useCase) {
    final recommendations = <String>[];
    
    _modelSpecs.forEach((model, specs) {
      final useCases = specs['use_cases'] as List<String>?;
      if (useCases?.contains(useCase) == true) {
        recommendations.add(model);
      }
    });
    
    // Sort by quality and speed
    recommendations.sort((a, b) {
      final aSpec = _modelSpecs[a]!;
      final bSpec = _modelSpecs[b]!;
      
      // Prioritize quality over speed
      if (aSpec['quality'] != bSpec['quality']) {
        return aSpec['quality'] == 'high' ? -1 : 1;
      }
      
      // Then by speed
      if (aSpec['speed'] != bSpec['speed']) {
        return aSpec['speed'] == 'very_fast' ? -1 : 1;
      }
      
      return 0;
    });
    
    return recommendations;
  }

  // Check if model is suitable for current device
  bool isModelSuitable(String modelId) {
    final modelSpec = _modelSpecs[modelId];
    if (modelSpec == null) return false;
    
    // In a real implementation, this would check actual device capabilities
    // For now, we'll use conservative estimates
    final memoryRequirement = modelSpec['memory'] as String;
    
    // Simple memory check (in a real app, you'd check actual available memory)
    if (memoryRequirement.contains('6GB')) {
      return false; // Too heavy for most devices
    }
    
    return true;
  }

  // Get model download size estimate
  String getModelDownloadSize(String modelId) {
    final modelSpec = _modelSpecs[modelId];
    if (modelSpec == null) return 'Unknown';
    
    final size = modelSpec['size'] as String;
    switch (size) {
      case '2B':
        return '~1.5 GB';
      case '6.7B':
        return '~4.5 GB';
      case '7B':
        return '~4.8 GB';
      default:
        return '~2-5 GB';
    }
  }

  // Dispose resources
  void dispose() {
    stopServer();
    _responseTimes.clear();
    _requestCounts.clear();
  }
} 