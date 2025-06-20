import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api_service.dart';

// ===== STATE CLASSES =====

class GenerationState {
  final bool isLoading;
  final String? error;
  final String? jobId;
  final Map<String, dynamic>? jobStatus;
  final List<Map<String, dynamic>> availableStyles;
  final Map<String, dynamic>? selectedStyle;
  final Map<String, dynamic>? generatedAsset;
  final bool isGenerating;
  final double generationProgress;
  final String generationStatus;

  const GenerationState({
    this.isLoading = false,
    this.error,
    this.jobId,
    this.jobStatus,
    this.availableStyles = const [],
    this.selectedStyle,
    this.generatedAsset,
    this.isGenerating = false,
    this.generationProgress = 0.0,
    this.generationStatus = 'idle',
  });

  GenerationState copyWith({
    bool? isLoading,
    String? error,
    String? jobId,
    Map<String, dynamic>? jobStatus,
    List<Map<String, dynamic>>? availableStyles,
    Map<String, dynamic>? selectedStyle,
    Map<String, dynamic>? generatedAsset,
    bool? isGenerating,
    double? generationProgress,
    String? generationStatus,
  }) {
    return GenerationState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      jobId: jobId ?? this.jobId,
      jobStatus: jobStatus ?? this.jobStatus,
      availableStyles: availableStyles ?? this.availableStyles,
      selectedStyle: selectedStyle ?? this.selectedStyle,
      generatedAsset: generatedAsset ?? this.generatedAsset,
      isGenerating: isGenerating ?? this.isGenerating,
      generationProgress: generationProgress ?? this.generationProgress,
      generationStatus: generationStatus ?? this.generationStatus,
    );
  }
}

// ===== CONTROLLER =====

class AssetGenerationController extends StateNotifier<GenerationState> {
  final ApiService _apiService;

  AssetGenerationController(this._apiService) : super(const GenerationState()) {
    _loadAvailableStyles();
  }

  // ===== STYLE MANAGEMENT =====

  Future<void> _loadAvailableStyles() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final styles = await _apiService.getAvailableStyles();
      final stylesList = (styles['styles'] as List).cast<Map<String, dynamic>>();
      
      state = state.copyWith(
        isLoading: false,
        availableStyles: stylesList,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> selectStyle(String styleName) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final styleInfo = await _apiService.getStyleInfo(styleName);
      
      state = state.copyWith(
        isLoading: false,
        selectedStyle: styleInfo,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // ===== ASSET GENERATION =====

  Future<void> generateAsset({
    required String prompt,
    required String style,
    String quality = 'standard',
    String outputFormat = 'glb',
    List<String> animations = const [],
  }) async {
    try {
      state = state.copyWith(
        isLoading: true, 
        error: null, 
        jobId: null, 
        jobStatus: null,
        isGenerating: true,
        generationProgress: 0.0,
        generationStatus: 'starting',
      );
      
      final response = await _apiService.generateAsset(
        prompt: prompt,
        style: style,
        quality: quality,
        outputFormat: outputFormat,
        animations: animations,
      );
      
      final jobId = response['job_id'] as String;
      
      state = state.copyWith(
        isLoading: false,
        jobId: jobId,
        generationStatus: 'generating',
      );
      
      // Start polling for job status
      _pollJobStatus(jobId);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        isGenerating: false,
        generationStatus: 'failed',
      );
    }
  }

  // ===== JOB STATUS TRACKING =====

  Future<void> _pollJobStatus(String jobId) async {
    const maxAttempts = 60; // 5 minutes with 5-second intervals
    int attempts = 0;
    
    while (attempts < maxAttempts) {
      try {
        await Future.delayed(const Duration(seconds: 5));
        
        final jobStatus = await _apiService.getJobStatus(jobId);
        final progress = (attempts / maxAttempts) * 100.0;
        
        state = state.copyWith(
          jobStatus: jobStatus,
          generationProgress: progress,
        );
        
        final status = jobStatus['status'] as String;
        
        if (status == 'completed') {
          // Generation completed successfully
          final assetData = jobStatus['result'] as Map<String, dynamic>?;
          state = state.copyWith(
            isGenerating: false,
            generationProgress: 100.0,
            generationStatus: 'completed',
            generatedAsset: assetData,
          );
          break;
        } else if (status == 'failed') {
          final error = jobStatus['error'] as String? ?? 'Generation failed';
          state = state.copyWith(
            error: error,
            isGenerating: false,
            generationStatus: 'failed',
          );
          break;
        }
        
        attempts++;
      } catch (e) {
        state = state.copyWith(
          error: e.toString(),
          isGenerating: false,
          generationStatus: 'failed',
        );
        break;
      }
    }
    
    if (attempts >= maxAttempts) {
      state = state.copyWith(
        error: 'Generation timed out',
        isGenerating: false,
        generationStatus: 'timeout',
      );
    }
  }

  Future<void> checkJobStatus(String jobId) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final jobStatus = await _apiService.getJobStatus(jobId);
      
      state = state.copyWith(
        isLoading: false,
        jobStatus: jobStatus,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // ===== UTILITY METHODS =====

  void clearError() {
    state = state.copyWith(error: null);
  }

  void reset() {
    state = const GenerationState();
    _loadAvailableStyles();
  }
}

// ===== PROVIDERS =====

final assetGenerationControllerProvider = StateNotifierProvider<AssetGenerationController, GenerationState>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return AssetGenerationController(apiService);
});

final availableStylesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  final response = await apiService.getAvailableStyles();
  return (response['styles'] as List).cast<Map<String, dynamic>>();
});

final styleInfoProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, styleName) async {
  final apiService = ref.read(apiServiceProvider);
  return await apiService.getStyleInfo(styleName);
});

final jobStatusProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, jobId) async {
  final apiService = ref.read(apiServiceProvider);
  return await apiService.getJobStatus(jobId);
}); 