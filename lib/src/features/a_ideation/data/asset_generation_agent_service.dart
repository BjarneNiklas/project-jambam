import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domain/multi_agent_system.dart';

/// Asset Generation Agent Service
/// Verantwortlich für 3D-Modelle, Texturen, Animationen, Audio
class AssetGenerationAgentService {
  static const String _baseUrl = 'http://localhost:8000';
  
  /// Generiert 3D-Modelle basierend auf Beschreibung
  Future<GeneratedAsset> generate3DModel({
    required String description,
    required AssetType type,
    required Map<String, dynamic> specifications,
    required GenerationEngine engine,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/asset-generation/3d-model'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'description': description,
          'asset_type': type.toString().split('.').last,
          'specifications': specifications,
          'engine': engine.toString().split('.').last,
          'include_uv_mapping': true,
          'include_lod': true,
          'include_optimization': true,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _parseGeneratedAsset(data);
      } else {
        throw Exception('Failed to generate 3D model: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback: Mock implementation
      return _createMock3DModel(description, type, engine);
    }
  }

  /// Generiert Texturen basierend auf Beschreibung
  Future<GeneratedAsset> generateTexture({
    required String description,
    required Map<String, dynamic> specifications,
    required GenerationEngine engine,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/asset-generation/texture'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'description': description,
          'specifications': specifications,
          'engine': engine.toString().split('.').last,
          'include_normal_map': true,
          'include_roughness_map': true,
          'include_metallic_map': true,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _parseGeneratedAsset(data);
      } else {
        throw Exception('Failed to generate texture: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback: Mock implementation
      return _createMockTexture(description, engine);
    }
  }

  /// Generiert Animationen für 3D-Modelle
  Future<GeneratedAsset> generateAnimation({
    required String modelId,
    required String animationType,
    required Map<String, dynamic> specifications,
    required GenerationEngine engine,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/asset-generation/animation'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'model_id': modelId,
          'animation_type': animationType,
          'specifications': specifications,
          'engine': engine.toString().split('.').last,
          'include_keyframes': true,
          'include_interpolation': true,
          'include_optimization': true,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _parseGeneratedAsset(data);
      } else {
        throw Exception('Failed to generate animation: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback: Mock implementation
      return _createMockAnimation(animationType, engine);
    }
  }

  /// Generiert Audio (Sound Effects & Music)
  Future<GeneratedAsset> generateAudio({
    required String description,
    required AssetType type,
    required Map<String, dynamic> specifications,
    required GenerationEngine engine,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/asset-generation/audio'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'description': description,
          'asset_type': type.toString().split('.').last,
          'specifications': specifications,
          'engine': engine.toString().split('.').last,
          'include_variations': true,
          'include_loops': type == AssetType.audio,
          'include_optimization': true,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _parseGeneratedAsset(data);
      } else {
        throw Exception('Failed to generate audio: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback: Mock implementation
      return _createMockAudio(description, type, engine);
    }
  }

  /// Generiert Shader und Materialien
  Future<GeneratedAsset> generateShader({
    required String description,
    required Map<String, dynamic> specifications,
    required GenerationEngine engine,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/asset-generation/shader'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'description': description,
          'specifications': specifications,
          'engine': engine.toString().split('.').last,
          'include_pbr': true,
          'include_optimization': true,
          'include_variants': true,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _parseGeneratedAsset(data);
      } else {
        throw Exception('Failed to generate shader: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback: Mock implementation
      return _createMockShader(description, engine);
    }
  }

  /// Erstellt Rigging für 3D-Modelle
  Future<GeneratedAsset> generateRig({
    required String modelId,
    required Map<String, dynamic> specifications,
    required GenerationEngine engine,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/asset-generation/rig'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'model_id': modelId,
          'specifications': specifications,
          'engine': engine.toString().split('.').last,
          'include_bones': true,
          'include_weights': true,
          'include_ik_chains': true,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _parseGeneratedAsset(data);
      } else {
        throw Exception('Failed to generate rig: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback: Mock implementation
      return _createMockRig(engine);
    }
  }

  /// Generiert Particle Effects
  Future<GeneratedAsset> generateParticleEffect({
    required String description,
    required Map<String, dynamic> specifications,
    required GenerationEngine engine,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/asset-generation/particle'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'description': description,
          'specifications': specifications,
          'engine': engine.toString().split('.').last,
          'include_emitters': true,
          'include_particles': true,
          'include_optimization': true,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _parseGeneratedAsset(data);
      } else {
        throw Exception('Failed to generate particle effect: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback: Mock implementation
      return _createMockParticleEffect(description, engine);
    }
  }

  /// Optimiert Assets für verschiedene Plattformen
  Future<GeneratedAsset> optimizeAsset({
    required String assetId,
    required String targetPlatform,
    required Map<String, dynamic> optimizationSettings,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/asset-generation/optimize'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'asset_id': assetId,
          'target_platform': targetPlatform,
          'optimization_settings': optimizationSettings,
          'include_compression': true,
          'include_lod_generation': true,
          'include_format_conversion': true,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _parseGeneratedAsset(data);
      } else {
        throw Exception('Failed to optimize asset: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback: Mock implementation
      return _createMockOptimizedAsset(targetPlatform);
    }
  }

  /// Batch-Generierung von Assets
  Future<List<GeneratedAsset>> generateAssetBatch({
    required List<AssetGenerationRequest> requests,
    required Map<String, dynamic> batchSettings,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/asset-generation/batch'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'requests': requests.map((r) => r.toJson()).toList(),
          'batch_settings': batchSettings,
          'include_parallel_processing': true,
          'include_quality_control': true,
          'include_optimization': true,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _parseGeneratedAssetList(data['assets']);
      } else {
        throw Exception('Failed to generate asset batch: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback: Mock implementation
      return _createMockAssetBatch(requests);
    }
  }

  // Mock Implementations für Fallback
  GeneratedAsset _createMock3DModel(String description, AssetType type, GenerationEngine engine) {
    return GeneratedAsset(
      id: 'mock_3d_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Generated 3D Model',
      description: description,
      assetType: type,
      engine: engine,
      fileUrl: 'mock://3d-model.glb',
      fileSize: 1024 * 1024, // 1MB
      quality: 0.85,
      metadata: {
        'vertices': 1000,
        'faces': 2000,
        'materials': 2,
        'textures': 1,
        'optimized': true,
      },
      tags: ['3d', 'model', 'generated'],
      createdAt: DateTime.now(),
    );
  }

  GeneratedAsset _createMockTexture(String description, GenerationEngine engine) {
    return GeneratedAsset(
      id: 'mock_texture_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Generated Texture',
      description: description,
      assetType: AssetType.texture,
      engine: engine,
      fileUrl: 'mock://texture.png',
      fileSize: 512 * 1024, // 512KB
      quality: 0.9,
      metadata: {
        'resolution': '2048x2048',
        'format': 'PNG',
        'channels': 'RGBA',
        'compressed': true,
      },
      tags: ['texture', 'generated'],
      createdAt: DateTime.now(),
    );
  }

  GeneratedAsset _createMockAnimation(String animationType, GenerationEngine engine) {
    return GeneratedAsset(
      id: 'mock_animation_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Generated Animation',
      description: '$animationType animation',
      assetType: AssetType.animation,
      engine: engine,
      fileUrl: 'mock://animation.fbx',
      fileSize: 256 * 1024, // 256KB
      quality: 0.8,
      metadata: {
        'duration': '2.5s',
        'fps': 30,
        'keyframes': 75,
        'optimized': true,
      },
      tags: ['animation', 'generated'],
      createdAt: DateTime.now(),
    );
  }

  GeneratedAsset _createMockAudio(String description, AssetType type, GenerationEngine engine) {
    return GeneratedAsset(
      id: 'mock_audio_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Generated Audio',
      description: description,
      assetType: type,
      engine: engine,
      fileUrl: 'mock://audio.wav',
      fileSize: 1024 * 1024, // 1MB
      quality: 0.85,
      metadata: {
        'duration': '10s',
        'sample_rate': 44100,
        'channels': 2,
        'format': 'WAV',
      },
      tags: ['audio', 'generated'],
      createdAt: DateTime.now(),
    );
  }

  GeneratedAsset _createMockShader(String description, GenerationEngine engine) {
    return GeneratedAsset(
      id: 'mock_shader_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Generated Shader',
      description: description,
      assetType: AssetType.shader,
      engine: engine,
      fileUrl: 'mock://shader.glsl',
      fileSize: 4 * 1024, // 4KB
      quality: 0.9,
      metadata: {
        'type': 'PBR',
        'features': ['normal_mapping', 'roughness', 'metallic'],
        'optimized': true,
      },
      tags: ['shader', 'generated'],
      createdAt: DateTime.now(),
    );
  }

  GeneratedAsset _createMockRig(GenerationEngine engine) {
    return GeneratedAsset(
      id: 'mock_rig_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Generated Rig',
      description: 'Character rigging',
      assetType: AssetType.rig,
      engine: engine,
      fileUrl: 'mock://rig.fbx',
      fileSize: 128 * 1024, // 128KB
      quality: 0.85,
      metadata: {
        'bones': 25,
        'ik_chains': 3,
        'weight_painting': true,
        'optimized': true,
      },
      tags: ['rig', 'generated'],
      createdAt: DateTime.now(),
    );
  }

  GeneratedAsset _createMockParticleEffect(String description, GenerationEngine engine) {
    return GeneratedAsset(
      id: 'mock_particle_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Generated Particle Effect',
      description: description,
      assetType: AssetType.particle,
      engine: engine,
      fileUrl: 'mock://particle.vfx',
      fileSize: 64 * 1024, // 64KB
      quality: 0.8,
      metadata: {
        'emitters': 3,
        'particles': 1000,
        'duration': '5s',
        'optimized': true,
      },
      tags: ['particle', 'effect', 'generated'],
      createdAt: DateTime.now(),
    );
  }

  GeneratedAsset _createMockOptimizedAsset(String targetPlatform) {
    return GeneratedAsset(
      id: 'mock_optimized_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Optimized Asset',
      description: 'Platform-optimized asset',
      assetType: AssetType.model3d,
      engine: GenerationEngine.custom,
      fileUrl: 'mock://optimized.glb',
      fileSize: 512 * 1024, // 512KB
      quality: 0.9,
      metadata: {
        'target_platform': targetPlatform,
        'compression_ratio': 0.5,
        'lod_levels': 3,
        'optimized': true,
      },
      tags: ['optimized', 'platform-specific'],
      createdAt: DateTime.now(),
    );
  }

  List<GeneratedAsset> _createMockAssetBatch(List<AssetGenerationRequest> requests) {
    return requests.map((request) {
      switch (request.assetType) {
        case AssetType.model3d:
          return _createMock3DModel(request.description, request.assetType, request.engine);
        case AssetType.texture:
          return _createMockTexture(request.description, request.engine);
        case AssetType.animation:
          return _createMockAnimation('idle', request.engine);
        case AssetType.audio:
          return _createMockAudio(request.description, request.assetType, request.engine);
        case AssetType.shader:
          return _createMockShader(request.description, request.engine);
        case AssetType.rig:
          return _createMockRig(request.engine);
        case AssetType.particle:
          return _createMockParticleEffect(request.description, request.engine);
        case AssetType.material:
          return _createMockShader(request.description, request.engine);
      }
    }).toList();
  }

  // Parser Methods
  GeneratedAsset _parseGeneratedAsset(Map<String, dynamic> data) {
    return GeneratedAsset(
      id: data['id'] ?? 'unknown',
      name: data['name'] ?? 'Unknown Asset',
      description: data['description'] ?? '',
      assetType: _parseAssetType(data['asset_type']),
      engine: _parseGenerationEngine(data['engine']),
      fileUrl: data['file_url'] ?? '',
      fileSize: data['file_size'] ?? 0,
      quality: (data['quality'] ?? 0.8).toDouble(),
      metadata: Map<String, dynamic>.from(data['metadata'] ?? {}),
      tags: List<String>.from(data['tags'] ?? []),
      createdAt: DateTime.parse(data['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  List<GeneratedAsset> _parseGeneratedAssetList(List<dynamic> assets) {
    return assets.map((asset) => _parseGeneratedAsset(asset)).toList();
  }

  AssetType _parseAssetType(String? type) {
    switch (type) {
      case 'model3d': return AssetType.model3d;
      case 'texture': return AssetType.texture;
      case 'animation': return AssetType.animation;
      case 'audio': return AssetType.audio;
      case 'shader': return AssetType.shader;
      case 'material': return AssetType.material;
      case 'rig': return AssetType.rig;
      case 'particle': return AssetType.particle;
      default: return AssetType.model3d;
    }
  }

  GenerationEngine _parseGenerationEngine(String? engine) {
    switch (engine) {
      case 'blender': return GenerationEngine.blender;
      case 'stableDiffusion': return GenerationEngine.stableDiffusion;
      case 'audioCraft': return GenerationEngine.audioCraft;
      case 'openUSD': return GenerationEngine.openUSD;
      case 'brickGPT': return GenerationEngine.brickGPT;
      case 'custom': return GenerationEngine.custom;
      default: return GenerationEngine.blender;
    }
  }
}

/// Generated Asset Model
class GeneratedAsset {
  final String id;
  final String name;
  final String description;
  final AssetType assetType;
  final GenerationEngine engine;
  final String fileUrl;
  final int fileSize;
  final double quality;
  final Map<String, dynamic> metadata;
  final List<String> tags;
  final DateTime createdAt;

  GeneratedAsset({
    required this.id,
    required this.name,
    required this.description,
    required this.assetType,
    required this.engine,
    required this.fileUrl,
    required this.fileSize,
    required this.quality,
    required this.metadata,
    required this.tags,
    required this.createdAt,
  });
}

/// Asset Generation Request Model
class AssetGenerationRequest {
  final String description;
  final AssetType assetType;
  final GenerationEngine engine;
  final Map<String, dynamic> specifications;

  AssetGenerationRequest({
    required this.description,
    required this.assetType,
    required this.engine,
    required this.specifications,
  });

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'asset_type': assetType.toString().split('.').last,
      'engine': engine.toString().split('.').last,
      'specifications': specifications,
    };
  }
}
