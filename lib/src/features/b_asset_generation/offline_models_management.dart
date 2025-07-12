import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/ai/mlc_llm_service.dart';

class OfflineModelsManagement extends StatefulWidget {
  const OfflineModelsManagement({super.key});

  @override
  State<OfflineModelsManagement> createState() => _OfflineModelsManagementState();
}

class _OfflineModelsManagementState extends State<OfflineModelsManagement>
    with TickerProviderStateMixin {
  final MLCLLMService _mlcService = MLCLLMService();
  
  late AnimationController _loadingController;
  late AnimationController _pulseController;
  
  bool _isInitialized = false;
  bool _isServerRunning = false;
  String? _currentModel;
  Map<String, ModelStatus> _modelStatuses = {};
  final Map<String, DownloadProgress> _downloadProgress = {};
  
  // Available models from HuggingFace
  final List<HuggingFaceModel> _availableModels = [
    HuggingFaceModel(
      id: 'llama-2-7b-chat',
      name: 'Llama 2 7B Chat',
      description: 'Meta\'s Llama 2 7B parameter chat model',
      size: '4.8 GB',
      downloads: 2500000,
      likes: 45000,
      tags: ['chat', 'assistant', 'general'],
      modelId: 'meta-llama/Llama-2-7b-chat-hf',
    ),
    HuggingFaceModel(
      id: 'mistral-7b-instruct',
      name: 'Mistral 7B Instruct',
      description: 'Mistral AI\'s 7B parameter instruction-tuned model',
      size: '4.2 GB',
      downloads: 1800000,
      likes: 32000,
      tags: ['chat', 'instruction', 'reasoning'],
      modelId: 'mistralai/Mistral-7B-Instruct-v0.2',
    ),
    HuggingFaceModel(
      id: 'gemma-2b-it',
      name: 'Gemma 2B IT',
      description: 'Google\'s lightweight 2B parameter instruction-tuned model',
      size: '1.5 GB',
      downloads: 950000,
      likes: 18000,
      tags: ['chat', 'lightweight', 'mobile'],
      modelId: 'google/gemma-2b-it',
    ),
    HuggingFaceModel(
      id: 'codellama-7b-instruct',
      name: 'Code Llama 7B Instruct',
      description: 'Meta\'s 7B parameter model specialized for code generation',
      size: '4.8 GB',
      downloads: 1200000,
      likes: 28000,
      tags: ['code', 'programming', 'debugging'],
      modelId: 'codellama/CodeLlama-7b-Instruct-hf',
    ),
    HuggingFaceModel(
      id: 'deepseek-coder-6.7b',
      name: 'DeepSeek Coder 6.7B',
      description: 'DeepSeek\'s 6.7B parameter model for code generation',
      size: '4.5 GB',
      downloads: 850000,
      likes: 22000,
      tags: ['code', 'programming', 'analysis'],
      modelId: 'deepseek-ai/deepseek-coder-6.7b-instruct',
    ),
    HuggingFaceModel(
      id: 'llava-1.5-7b',
      name: 'LLaVA 1.5 7B',
      description: 'Microsoft\'s multimodal model for vision and language',
      size: '6.2 GB',
      downloads: 680000,
      likes: 15000,
      tags: ['vision', 'image_analysis', 'multimodal'],
      modelId: 'llava-hf/llava-1.5-7b-hf',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadingController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _initializeService();
  }

  Future<void> _initializeService() async {
    setState(() {
      _isInitialized = false;
    });

    try {
      final initialized = await _mlcService.initialize();
      if (initialized) {
        setState(() {
          _isServerRunning = _mlcService.isServerRunning;
          _currentModel = _mlcService.currentModel;
          _isInitialized = true;
        });
        
        await _loadModelStatuses();
      }
    } catch (e) {
      // Log error silently for now
    }
  }

  Future<void> _loadModelStatuses() async {
    final prefs = await SharedPreferences.getInstance();
    final modelStatuses = <String, ModelStatus>{};
    
    for (final model in _availableModels) {
      final isDownloaded = prefs.getBool('model_${model.id}_downloaded') ?? false;
      final isInstalled = prefs.getBool('model_${model.id}_installed') ?? false;
      final lastUsed = prefs.getInt('model_${model.id}_last_used');
      
      modelStatuses[model.id] = ModelStatus(
        isDownloaded: isDownloaded,
        isInstalled: isInstalled,
        lastUsed: lastUsed != null ? DateTime.fromMillisecondsSinceEpoch(lastUsed) : null,
      );
    }
    
    setState(() {
      _modelStatuses = modelStatuses;
    });
  }

  Future<void> _downloadModel(HuggingFaceModel model) async {
    setState(() {
      _downloadProgress[model.id] = DownloadProgress(
        bytesDownloaded: 0,
        totalBytes: _parseSize(model.size),
        isDownloading: true,
      );
    });

    try {
      // Simulate download progress
      final totalBytes = _parseSize(model.size);
      int downloadedBytes = 0;
      
      while (downloadedBytes < totalBytes) {
        await Future.delayed(const Duration(milliseconds: 100));
        downloadedBytes += (totalBytes * 0.01).round();
        
        if (downloadedBytes > totalBytes) downloadedBytes = totalBytes;
        
        setState(() {
          _downloadProgress[model.id] = DownloadProgress(
            bytesDownloaded: downloadedBytes,
            totalBytes: totalBytes,
            isDownloading: true,
          );
        });
      }

      // Mark as downloaded
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('model_${model.id}_downloaded', true);
      
      setState(() {
        _modelStatuses[model.id] = ModelStatus(
          isDownloaded: true,
          isInstalled: false,
          lastUsed: null,
        );
        _downloadProgress.remove(model.id);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${model.name} downloaded successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _downloadProgress.remove(model.id);
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to download ${model.name}: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _installModel(HuggingFaceModel model) async {
    setState(() {
      _downloadProgress[model.id] = DownloadProgress(
        bytesDownloaded: 0,
        totalBytes: 100,
        isDownloading: true,
      );
    });

    try {
      // Simulate installation process
      await Future.delayed(const Duration(seconds: 3));
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('model_${model.id}_installed', true);
      
      setState(() {
        _modelStatuses[model.id] = ModelStatus(
          isDownloaded: true,
          isInstalled: true,
          lastUsed: null,
        );
        _downloadProgress.remove(model.id);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${model.name} installed successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _downloadProgress.remove(model.id);
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to install ${model.name}: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _loadModel(HuggingFaceModel model) async {
    if (!_isServerRunning) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('MLC LLM server is not running'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      final success = await _mlcService.loadModel(model.id);
      if (success) {
        setState(() {
          _currentModel = model.id;
        });
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('model_${model.id}_last_used', DateTime.now().millisecondsSinceEpoch);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${model.name} loaded successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load ${model.name}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading ${model.name}: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _startServer() async {
    try {
      final success = await _mlcService.startServer();
      if (success) {
        setState(() {
          _isServerRunning = true;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('MLC LLM server started successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to start MLC LLM server'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error starting server: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _stopServer() async {
    try {
      final success = await _mlcService.stopServer();
      if (success) {
        setState(() {
          _isServerRunning = false;
          _currentModel = null;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('MLC LLM server stopped'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error stopping server: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  int _parseSize(String size) {
    final number = double.parse(size.split(' ')[0]);
    final unit = size.split(' ')[1];
    
    switch (unit) {
      case 'GB':
        return (number * 1024 * 1024 * 1024).round();
      case 'MB':
        return (number * 1024 * 1024).round();
      default:
        return (number * 1024).round();
    }
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Models Management'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _initializeService,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: !_isInitialized
          ? _buildLoadingView()
          : _buildMainContent(),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _loadingController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _loadingController.value * 2 * 3.14159,
                child: const Icon(
                  Icons.sync,
                  size: 48,
                  color: Colors.blue,
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          const Text(
            'Initializing MLC LLM Service...',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      children: [
        _buildServerStatusCard(),
        const SizedBox(height: 16),
        Expanded(
          child: _buildModelsList(),
        ),
      ],
    );
  }

  Widget _buildServerStatusCard() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _isServerRunning ? Icons.cloud_done : Icons.cloud_off,
                  color: _isServerRunning ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  'MLC LLM Server',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                Switch(
                  value: _isServerRunning,
                  onChanged: (value) {
                    if (value) {
                      _startServer();
                    } else {
                      _stopServer();
                    }
                  },
                ),
              ],
            ),
            if (_currentModel != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.model_training, size: 16),
                  const SizedBox(width: 8),
                  Text('Current Model: $_currentModel'),
                ],
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.info_outline, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _isServerRunning
                        ? 'Server is running and ready for model operations'
                        : 'Server is stopped. Start to load and use models.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModelsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _availableModels.length,
      itemBuilder: (context, index) {
        final model = _availableModels[index];
        final status = _modelStatuses[model.id];
        final downloadProgress = _downloadProgress[model.id];
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            model.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            model.description,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    _buildModelStatusChip(status),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.storage, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(model.size),
                    const SizedBox(width: 16),
                    Icon(Icons.download, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text('${(model.downloads / 1000).toStringAsFixed(0)}k'),
                    const SizedBox(width: 16),
                    Icon(Icons.thumb_up, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text('${(model.likes / 1000).toStringAsFixed(0)}k'),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  children: model.tags.map((tag) => Chip(
                    label: Text(tag),
                    labelStyle: const TextStyle(fontSize: 10),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  )).toList(),
                ),
                if (downloadProgress != null) ...[
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: downloadProgress.totalBytes > 0
                        ? downloadProgress.bytesDownloaded / downloadProgress.totalBytes
                        : 0,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_formatBytes(downloadProgress.bytesDownloaded)} / ${_formatBytes(downloadProgress.totalBytes)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
                const SizedBox(height: 12),
                _buildModelActions(model, status),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildModelStatusChip(ModelStatus? status) {
    if (status == null) {
      return const Chip(
        label: Text('Unknown'),
        backgroundColor: Colors.grey,
        labelStyle: TextStyle(color: Colors.white, fontSize: 10),
      );
    }

    if (status.isInstalled) {
      return const Chip(
        label: Text('Installed'),
        backgroundColor: Colors.green,
        labelStyle: TextStyle(color: Colors.white, fontSize: 10),
      );
    } else if (status.isDownloaded) {
      return const Chip(
        label: Text('Downloaded'),
        backgroundColor: Colors.blue,
        labelStyle: TextStyle(color: Colors.white, fontSize: 10),
      );
    } else {
      return const Chip(
        label: Text('Available'),
        backgroundColor: Colors.orange,
        labelStyle: TextStyle(color: Colors.white, fontSize: 10),
      );
    }
  }

  Widget _buildModelActions(HuggingFaceModel model, ModelStatus? status) {
    final isCurrentModel = _currentModel == model.id;
    
    return Row(
      children: [
        if (!status!.isDownloaded)
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _downloadProgress.containsKey(model.id)
                  ? null
                  : () => _downloadModel(model),
              icon: const Icon(Icons.download, size: 16),
              label: const Text('Download'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        if (status.isDownloaded && !status.isInstalled)
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _downloadProgress.containsKey(model.id)
                  ? null
                  : () => _installModel(model),
              icon: const Icon(Icons.install_desktop, size: 16),
              label: const Text('Install'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        if (status.isInstalled)
          Expanded(
            child: ElevatedButton.icon(
              onPressed: !_isServerRunning
                  ? null
                  : isCurrentModel
                      ? null
                      : () => _loadModel(model),
              icon: Icon(isCurrentModel ? Icons.check : Icons.play_arrow, size: 16),
              label: Text(isCurrentModel ? 'Loaded' : 'Load'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isCurrentModel ? Colors.grey : Colors.purple,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () => _showModelDetails(model),
          icon: const Icon(Icons.info_outline),
          tooltip: 'Model Details',
        ),
      ],
    );
  }

  void _showModelDetails(HuggingFaceModel model) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(model.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: ${model.description}'),
            const SizedBox(height: 8),
            Text('Size: ${model.size}'),
            Text('Downloads: ${(model.downloads / 1000).toStringAsFixed(0)}k'),
            Text('Likes: ${(model.likes / 1000).toStringAsFixed(0)}k'),
            const SizedBox(height: 8),
            Text('Tags: ${model.tags.join(', ')}'),
            const SizedBox(height: 8),
            Text('HuggingFace ID: ${model.modelId}'),
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

  @override
  void dispose() {
    _loadingController.dispose();
    _pulseController.dispose();
    _mlcService.dispose();
    super.dispose();
  }
}

class HuggingFaceModel {
  final String id;
  final String name;
  final String description;
  final String size;
  final int downloads;
  final int likes;
  final List<String> tags;
  final String modelId;

  HuggingFaceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.size,
    required this.downloads,
    required this.likes,
    required this.tags,
    required this.modelId,
  });
}

class ModelStatus {
  final bool isDownloaded;
  final bool isInstalled;
  final DateTime? lastUsed;

  ModelStatus({
    required this.isDownloaded,
    required this.isInstalled,
    this.lastUsed,
  });
}

class DownloadProgress {
  final int bytesDownloaded;
  final int totalBytes;
  final bool isDownloading;

  DownloadProgress({
    required this.bytesDownloaded,
    required this.totalBytes,
    required this.isDownloading,
  });
}