import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:logging/logging.dart';
import 'asset_generation_controller.dart';
import '../asset_preview/gaussian_splat_viewer.dart';
import 'package:project_jambam/src/shared/enhanced_chip.dart';

class AssetGenerationScreen extends ConsumerStatefulWidget {
  const AssetGenerationScreen({super.key});

  @override
  ConsumerState<AssetGenerationScreen> createState() => _AssetGenerationScreenState();
}

class _AssetGenerationScreenState extends ConsumerState<AssetGenerationScreen> {
  final _promptController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _logger = Logger('AssetGenerationScreen');
  String _selectedStyle = '';
  String _selectedQuality = 'standard';
  String _selectedFormat = 'glb';
  final List<String> _selectedAnimations = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    final state = ref.read(assetGenerationControllerProvider);
    if (state.availableStyles.isNotEmpty) {
      setState(() {
        _selectedStyle = state.availableStyles.first['name'] as String;
      });
    }
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final generationState = ref.watch(assetGenerationControllerProvider);
    final controller = ref.read(assetGenerationControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate 3D Asset'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Generation Form
            _buildGenerationForm(generationState, controller),
            
            const SizedBox(height: 24),
            
            // Progress Section
            if (generationState.isGenerating) _buildProgressSection(generationState),
            
            const SizedBox(height: 24),
            
            // Generated Asset Preview
            if (generationState.generatedAsset != null) 
              _buildAssetPreview(generationState.generatedAsset!),
            
            const SizedBox(height: 24),
            
            // Error Display
            if (generationState.error != null) _buildErrorSection(generationState, controller),
          ],
        ),
      ),
    );
  }

  Widget _buildGenerationForm(GenerationState state, AssetGenerationController controller) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create Your 3D Asset',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              // Prompt Input
              TextFormField(
                controller: _promptController,
                decoration: const InputDecoration(
                  labelText: 'Describe your 3D asset',
                  hintText: 'e.g., A futuristic robot with glowing blue eyes',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.edit),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Style Selection
              _buildStyleDropdown(state),
              const SizedBox(height: 16),
              
              // Quality and Format Selection
              Row(
                children: [
                  Expanded(child: _buildQualityDropdown()),
                  const SizedBox(width: 16),
                  Expanded(child: _buildFormatDropdown()),
                ],
              ),
              const SizedBox(height: 16),
              
              // Animation Selection
              _buildAnimationSelection(),
              const SizedBox(height: 16),
              
              // Generate Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: state.isLoading || state.isGenerating 
                    ? null 
                    : () => _generateAsset(controller),
                  icon: state.isLoading 
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.auto_awesome),
                  label: Text(
                    state.isGenerating ? 'Generating...' : 'Generate 3D Asset',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStyleDropdown(GenerationState state) {
    return DropdownButtonFormField<String>(
      value: _selectedStyle.isNotEmpty ? _selectedStyle : null,
      decoration: const InputDecoration(
        labelText: 'Art Style',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.palette),
      ),
      items: state.availableStyles.map((style) {
        return DropdownMenuItem<String>(
          value: style['name'] as String,
          child: Row(
            children: [
              Icon(
                Icons.style,
                color: _getStyleColor(style['name'] as String),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(style['name'] as String),
                    Text(
                      style['description'] as String? ?? '',
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedStyle = value;
          });
          ref.read(assetGenerationControllerProvider.notifier).selectStyle(value);
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a style';
        }
        return null;
      },
    );
  }

  Widget _buildQualityDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedQuality,
      decoration: const InputDecoration(
        labelText: 'Quality',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.high_quality),
      ),
      items: const [
        DropdownMenuItem(value: 'draft', child: Text('Draft (Fast)')),
        DropdownMenuItem(value: 'standard', child: Text('Standard')),
        DropdownMenuItem(value: 'high', child: Text('High Quality')),
        DropdownMenuItem(value: 'ultra', child: Text('Ultra (Slow)')),
      ],
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedQuality = value;
          });
        }
      },
    );
  }

  Widget _buildFormatDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedFormat,
      decoration: const InputDecoration(
        labelText: 'Format',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.file_download),
      ),
      items: const [
        DropdownMenuItem(value: 'glb', child: Text('glTF Binary (.glb)')),
        DropdownMenuItem(value: 'gltf', child: Text('glTF (.gltf)')),
        DropdownMenuItem(value: 'usd', child: Text('USD (.usd)')),
        DropdownMenuItem(value: 'obj', child: Text('OBJ (.obj)')),
      ],
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedFormat = value;
          });
        }
      },
    );
  }

  Widget _buildAnimationSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Animations (Optional)',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            'idle',
            'walk',
            'run',
            'jump',
            'attack',
            'dance',
          ].map((animation) {
            final isSelected = _selectedAnimations.contains(animation);
            return EnhancedFilterChip(
              label: animation,
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedAnimations.add(animation);
                  } else {
                    _selectedAnimations.remove(animation);
                  }
                });
              },
              icon: Icons.add,
              selectedIcon: Icons.check,
              selectedColor: Theme.of(context).colorScheme.primary,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildProgressSection(GenerationState state) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.sync, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'Generation Progress',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Progress Bar
            LinearProgressIndicator(
              value: state.generationProgress,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            const SizedBox(height: 8),
            
            // Status Text
            Text(
              state.generationStatus,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            
            if (state.jobId != null) ...[
              const SizedBox(height: 8),
              Text(
                'Job ID: ${state.jobId}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAssetPreview(Map<String, dynamic> asset) {
    final assetId = asset['id'] as int;
    
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  'Generated Successfully!',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Asset Preview
            Container(
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: GaussianSplatViewer(
                  assetId: assetId,
                  platform: 'web', // Default to web for now
                  width: double.infinity,
                  height: 300,
                  interactive: true,
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Asset Details
            _buildAssetDetails(asset),
            const SizedBox(height: 16),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _downloadAsset(asset),
                    icon: const Icon(Icons.download),
                    label: const Text('Download'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _shareAsset(asset),
                    icon: const Icon(Icons.share),
                    label: const Text('Share'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssetDetails(Map<String, dynamic> asset) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Asset Details',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        _buildDetailRow('Name', asset['name'] as String? ?? 'Unnamed Asset'),
        _buildDetailRow('Style', asset['style'] as String? ?? 'Unknown'),
        _buildDetailRow('Quality', asset['quality'] as String? ?? 'Standard'),
        _buildDetailRow('Format', asset['format'] as String? ?? 'glb'),
        _buildDetailRow('File Size', _formatFileSize(asset['file_size'] as int? ?? 0)),
        _buildDetailRow('Created', _formatDate(asset['created_at'] as String? ?? '')),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorSection(GenerationState state, AssetGenerationController controller) {
    return Card(
      color: Colors.red[50],
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red[400]),
                const SizedBox(width: 8),
                Text(
                  'Generation Failed',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.red[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              state.error!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.red[700],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                TextButton.icon(
                  onPressed: () => controller.clearError(),
                  icon: const Icon(Icons.clear),
                  label: const Text('Dismiss'),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () => controller.reset(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ===== HELPER METHODS =====

  Color _getStyleColor(String styleName) {
    switch (styleName.toLowerCase()) {
      case 'realistic':
        return Colors.green;
      case 'cartoon':
        return Colors.orange;
      case 'anime':
        return Colors.pink;
      case 'cyberpunk':
        return Colors.purple;
      case 'steampunk':
        return Colors.brown;
      default:
        return Colors.blue;
    }
  }

  void _generateAsset(AssetGenerationController controller) {
    if (_formKey.currentState!.validate()) {
      controller.generateAsset(
        prompt: _promptController.text.trim(),
        style: _selectedStyle,
        quality: _selectedQuality,
        outputFormat: _selectedFormat,
        animations: _selectedAnimations,
      );
    }
  }

  void _showShareError(Object e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Share failed: ${e.toString()}'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _shareAsset(Map<String, dynamic> asset) async {
    try {
      // Create temporary file for sharing
      final directory = await getTemporaryDirectory();
      final assetName = asset['name'] ?? 'asset';
      final format = asset['format'] ?? 'glb';
      final filename = '${assetName}_share.$format';
      final filePath = '${directory.path}/$filename';

      // Simulate asset data
      final assetData = Uint8List.fromList(List.generate(512, (i) => i % 256));
      final file = File(filePath);
      await file.writeAsBytes(assetData);

      _logger.info('Asset shared successfully: $filePath');
      // Share the file
      await Share.shareXFiles(
        [XFile(filePath)],
        text: 'Check out this 3D asset from JambaM: ${asset['name'] ?? 'Amazing Asset'}',
        subject: 'JambaM 3D Asset',
      );
    } catch (e) {
      _logger.severe('Failed to share asset: $e');
      // ignore: use_build_context_synchronously
      _showShareError(e);
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  String _formatDate(String dateString) {
    if (dateString.isEmpty) return 'Unknown';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
    } catch (e) {
      return dateString;
    }
  }

  void _downloadAsset(Map<String, dynamic> asset) async {
    try {
      // Request storage permission
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Storage permission required to download assets'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // Show download progress
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Downloading asset...'),
            duration: Duration(seconds: 2),
          ),
        );
      }

      // Get download directory
      final directory = await getExternalStorageDirectory() ?? await getApplicationDocumentsDirectory();
      final downloadsDir = Directory('${directory.path}/JambaM_Assets');
      if (!await downloadsDir.exists()) {
        await downloadsDir.create(recursive: true);
      }

      // Generate filename
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final assetName = asset['name'] ?? 'asset';
      final format = asset['format'] ?? 'glb';
      final filename = '${assetName}_$timestamp.$format';
      final filePath = '${downloadsDir.path}/$filename';

      // Simulate asset data (in real implementation, this would come from the asset URL)
      final assetData = Uint8List.fromList(List.generate(1024, (i) => i % 256));
      final file = File(filePath);
      await file.writeAsBytes(assetData);

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Asset downloaded to: $filePath'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'Open',
              onPressed: () => _openFileLocation(filePath),
            ),
          ),
        );
      }

      _logger.info('Asset downloaded successfully: $filePath');
    } catch (e) {
      _logger.severe('Failed to download asset: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Download failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _openFileLocation(String filePath) {
    // Open file location in file manager
    // This would use platform-specific code to open the file location
    _logger.info('Opening file location: $filePath');
  }
} 