import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api_service.dart';

class GaussianSplatViewer extends ConsumerStatefulWidget {
  final int assetId;
  final String platform; // 'web', 'desktop', 'android'
  final double width;
  final double height;
  final bool interactive;

  const GaussianSplatViewer({
    super.key,
    required this.assetId,
    required this.platform,
    this.width = 400,
    this.height = 400,
    this.interactive = true,
  });

  @override
  ConsumerState<GaussianSplatViewer> createState() => _GaussianSplatViewerState();
}

class _GaussianSplatViewerState extends ConsumerState<GaussianSplatViewer> {
  String? _splatData;
  bool _isLoading = true;
  String? _error;
  late ApiService _apiService;

  @override
  void initState() {
    super.initState();
    _apiService = ref.read(apiServiceProvider);
    _loadSplatPreview();
  }

  Future<void> _loadSplatPreview() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final splatData = await _apiService.getSplatPreview(
        assetId: widget.assetId,
        platform: widget.platform,
      );

      setState(() {
        _splatData = splatData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingWidget();
    }

    if (_error != null) {
      return _buildErrorWidget();
    }

    if (_splatData == null) {
      return _buildNoDataWidget();
    }

    return _buildSplatViewer();
  }

  Widget _buildLoadingWidget() {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading 3D Preview...'),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red[400], size: 48),
            const SizedBox(height: 16),
            Text(
              'Failed to load preview',
              style: TextStyle(color: Colors.red[700]),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _loadSplatPreview,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoDataWidget() {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.view_in_ar, color: Colors.grey, size: 48),
            SizedBox(height: 16),
            Text(
              'No preview available',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSplatViewer() {
    // Platform-specific rendering
    switch (widget.platform) {
      case 'web':
        return _buildWebViewer();
      case 'desktop':
        return _buildDesktopViewer();
      case 'android':
        return _buildAndroidViewer();
      default:
        return _buildFallbackViewer();
    }
  }

  Widget _buildWebViewer() {
    // Web implementation placeholder
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[300]!),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.web, color: Colors.blue, size: 48),
            SizedBox(height: 16),
            Text(
              'Web 3D Viewer\n(WebGL implementation)',
              style: TextStyle(color: Colors.blue),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Gaussian Splat Preview',
              style: TextStyle(fontSize: 12, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopViewer() {
    // Desktop implementation placeholder
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green[300]!),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.desktop_windows, color: Colors.green, size: 48),
            SizedBox(height: 16),
            Text(
              'Desktop 3D Viewer\n(OpenGL/Vulkan implementation)',
              style: TextStyle(color: Colors.green),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Gaussian Splat Preview',
              style: TextStyle(fontSize: 12, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAndroidViewer() {
    // Android implementation placeholder
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange[300]!),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.phone_android, color: Colors.orange, size: 48),
            SizedBox(height: 16),
            Text(
              'Android 3D Viewer\n(OpenGL ES implementation)',
              style: TextStyle(color: Colors.orange),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Gaussian Splat Preview',
              style: TextStyle(fontSize: 12, color: Colors.orange),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackViewer() {
    // Fallback to simple 3D preview
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.purple[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.purple[300]!),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.view_in_ar, color: Colors.purple, size: 48),
            SizedBox(height: 16),
            Text(
              '3D Asset Preview\n(glTF/GLB Viewer)',
              style: TextStyle(color: Colors.purple),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Full 3D Model',
              style: TextStyle(fontSize: 12, color: Colors.purple),
            ),
          ],
        ),
      ),
    );
  }
} 