import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domain/multi_agent_system.dart';

/// Interface für Engine-Adapter
abstract class EngineAdapter {
  String get name;
  List<String> getSupportedFeatures();
  Future<bool> build(Map<String, dynamic> projectData);
  Future<bool> export(Map<String, dynamic> projectData, String targetPlatform);
  Future<bool> run(Map<String, dynamic> projectData);
}

/// Mock-Adapter für Godot
class GodotEngineAdapter implements EngineAdapter {
  @override
  String get name => 'Godot';

  @override
  List<String> getSupportedFeatures() => [
        '2D',
        '3D',
        'Scripting (GDScript, C#)',
        'Export (Web, Desktop, Mobile)',
      ];

  @override
  Future<bool> build(Map<String, dynamic> projectData) async {
    // TODO: Echte Godot-CLI/API-Integration
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }

  @override
  Future<bool> export(Map<String, dynamic> projectData, String tVGargetPlatform) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }

  @override
  Future<bool> run(Map<String, dynamic> projectData) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }
}

/// Mock-Adapter für Unity
class UnityEngineAdapter implements EngineAdapter {
  @override
  String get name => 'Unity';

  @override
  List<String> getSupportedFeatures() => [
        '2D',
        '3D',
        'C# Scripting',
        'Export (Desktop, Mobile, WebGL, Konsole)',
      ];

  @override
  Future<bool> build(Map<String, dynamic> projectData) async {
    // TODO: Echte Unity-CLI/API-Integration
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }

  @override
  Future<bool> export(Map<String, dynamic> projectData, String targetPlatform) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }

  @override
  Future<bool> run(Map<String, dynamic> projectData) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }
}

/// Mock-Adapter für Bevy
class BevyEngineAdapter implements EngineAdapter {
  @override
  String get name => 'Bevy';

  @override
  List<String> getSupportedFeatures() => [
        '2D',
        '3D',
        'Rust Scripting',
        'Export (Desktop, WebAssembly)',
      ];

  @override
  Future<bool> build(Map<String, dynamic> projectData) async {
    // TODO: Echte Bevy-Build-Integration
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }

  @override
  Future<bool> export(Map<String, dynamic> projectData, String targetPlatform) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }

  @override
  Future<bool> run(Map<String, dynamic> projectData) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }
}

/// Mock-Adapter für Unreal
class UnrealEngineAdapter implements EngineAdapter {
  @override
  String get name => 'Unreal';

  @override
  List<String> getSupportedFeatures() => [
        '3D',
        'Blueprints',
        'C++ Scripting',
        'Export (Desktop, Mobile, Konsole)',
      ];

  @override
  Future<bool> build(Map<String, dynamic> projectData) async {
    // TODO: Echte Unreal-CLI/API-Integration
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }

  @override
  Future<bool> export(Map<String, dynamic> projectData, String targetPlatform) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }

  @override
  Future<bool> run(Map<String, dynamic> projectData) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }
}

/// Engine-Registry für dynamische Auswahl
class EngineRegistry {
  final Map<String, EngineAdapter> _adapters = {
    'Godot': GodotEngineAdapter(),
    'Unity': UnityEngineAdapter(),
    'Bevy': BevyEngineAdapter(),
    'Unreal': UnrealEngineAdapter(),
  };

  List<String> get availableEngines => _adapters.keys.toList();

  EngineAdapter? getAdapter(String name) => _adapters[name];
}

/// GameEngineAgent-Service mit Multi-Engine-Support
class GameEngineAgentService {
  static const String _baseUrl = 'http://localhost:8000';
  final EngineRegistry _registry = EngineRegistry();

  List<String> getSupportedEngines() => _registry.availableEngines;

  EngineAdapter? getAdapter(String engineName) => _registry.getAdapter(engineName);

  /// Beispiel: Build für gewählte Engine
  Future<bool> buildWithEngine(String engineName, Map<String, dynamic> projectData) async {
    final adapter = getAdapter(engineName);
    if (adapter == null) return false;
    return await adapter.build(projectData);
  }

  /// Beispiel: Export für gewählte Engine
  Future<bool> exportWithEngine(String engineName, Map<String, dynamic> projectData, String targetPlatform) async {
    final adapter = getAdapter(engineName);
    if (adapter == null) return false;
    return await adapter.export(projectData, targetPlatform);
  }

  /// Beispiel: Run für gewählte Engine
  Future<bool> runWithEngine(String engineName, Map<String, dynamic> projectData) async {
    final adapter = getAdapter(engineName);
    if (adapter == null) return false;
    return await adapter.run(projectData);
  }

  /// Liefert Features der Engine
  List<String> getEngineFeatures(String engineName) {
    final adapter = getAdapter(engineName);
    return adapter?.getSupportedFeatures() ?? [];
  }

  /// Importiert Assets und Game Design in die Ziel-Engine
  Future<EngineIntegrationResult> importToEngine({
    required String engine, // z.B. 'unity', 'unreal', 'godot', 'bevy'
    required List<GeneratedAsset> assets,
    required GameDesignDocument design,
    Map<String, dynamic>? engineConfig,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/game-engine/import'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode({
          'engine': engine,
          'assets': assets.map((a) => a.id).toList(),
          'design': design, // ggf. toJson()
          'engine_config': engineConfig ?? {},
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _parseIntegrationResult(data);
      } else {
        throw Exception('Failed to import to engine: {response.statusCode}');
      }
    } catch (e) {
      // Fallback: Mock
      return _createMockIntegrationResult(engine, assets, design);
    }
  }

  /// Generiert Engine-spezifischen Code (z.B. C#, GDScript, Blueprints, Rust)
  Future<EngineCodeResult> generateEngineCode({
    required String engine,
    required GameDesignDocument design,
    required List<GeneratedAsset> assets,
    Map<String, dynamic>? codeOptions,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/game-engine/codegen'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode({
          'engine': engine,
          'design': design, // ggf. toJson()
          'assets': assets.map((a) => a.id).toList(),
          'code_options': codeOptions ?? {},
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _parseCodeResult(data);
      } else {
        throw Exception('Failed to generate engine code: {response.statusCode}');
      }
    } catch (e) {
      // Fallback: Mock
      return _createMockCodeResult(engine, design);
    }
  }

  /// Baut und exportiert ein lauffähiges Spiel/Anwendung
  Future<EngineBuildResult> buildAndExport({
    required String engine,
    required String targetPlatform, // z.B. 'windows', 'macos', 'linux', 'android', 'ios'
    required Map<String, dynamic> buildConfig,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/game-engine/build'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode({
          'engine': engine,
          'target_platform': targetPlatform,
          'build_config': buildConfig,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _parseBuildResult(data);
      } else {
        throw Exception('Failed to build/export: {response.statusCode}');
      }
    } catch (e) {
      // Fallback: Mock
      return _createMockBuildResult(engine, targetPlatform);
    }
  }

  // --- Mock & Parser Implementierungen ---

  EngineIntegrationResult _createMockIntegrationResult(String engine, List<GeneratedAsset> assets, GameDesignDocument design) {
    return EngineIntegrationResult(
      engine: engine,
      success: true,
      importedAssets: assets.map((a) => a.id).toList(),
      sceneCount: 3,
      warnings: [],
      logs: ['Mock import successful'],
    );
  }

  EngineIntegrationResult _parseIntegrationResult(Map<String, dynamic> data) {
    return EngineIntegrationResult(
      engine: data['engine'] ?? 'unknown',
      success: data['success'] ?? false,
      importedAssets: List<String>.from(data['imported_assets'] ?? []),
      sceneCount: data['scene_count'] ?? 0,
      warnings: List<String>.from(data['warnings'] ?? []),
      logs: List<String>.from(data['logs'] ?? []),
    );
  }

  EngineCodeResult _createMockCodeResult(String engine, GameDesignDocument design) {
    if (engine == 'bevy') {
      return EngineCodeResult(
        engine: engine,
        codeFiles: [
          EngineCodeFile(filename: 'main.rs', content: '// Bevy game main loop'),
          EngineCodeFile(filename: 'player.rs', content: '// Player logic in Rust'),
        ],
        warnings: [],
        logs: ['Mock Bevy code generation'],
      );
    }
    if (engine == 'godot') {
      return EngineCodeResult(
        engine: engine,
        codeFiles: [
          EngineCodeFile(filename: 'Player.gd', content: '# GDScript player logic'),
          EngineCodeFile(filename: 'GameManager.gd', content: '# GDScript game management'),
        ],
        warnings: [],
        logs: ['Mock Godot code generation'],
      );
    }
    if (engine == 'unity') {
      return EngineCodeResult(
        engine: engine,
        codeFiles: [
          EngineCodeFile(filename: 'PlayerController.cs', content: '// Player logic'),
          EngineCodeFile(filename: 'GameManager.cs', content: '// Game management'),
        ],
        warnings: [],
        logs: ['Mock Unity code generation'],
      );
    }
    if (engine == 'unreal') {
      return EngineCodeResult(
        engine: engine,
        codeFiles: [
          EngineCodeFile(filename: 'PlayerController.cpp', content: '// Unreal C++ player logic'),
          EngineCodeFile(filename: 'GameManager.cpp', content: '// Unreal C++ game management'),
        ],
        warnings: [],
        logs: ['Mock Unreal code generation'],
      );
    }
    return EngineCodeResult(
      engine: engine,
      codeFiles: [],
      warnings: ['Unknown engine'],
      logs: [],
    );
  }

  EngineCodeResult _parseCodeResult(Map<String, dynamic> data) {
    return EngineCodeResult(
      engine: data['engine'] ?? 'unknown',
      codeFiles: (data['code_files'] as List<dynamic>?)
              ?.map((f) => EngineCodeFile(
                    filename: f['filename'] ?? 'unknown',
                    content: f['content'] ?? '',
                  ))
              .toList() ??
          [],
      warnings: List<String>.from(data['warnings'] ?? []),
      logs: List<String>.from(data['logs'] ?? []),
    );
  }

  EngineBuildResult _createMockBuildResult(String engine, String platform) {
    return EngineBuildResult(
      engine: engine,
      targetPlatform: platform,
      buildUrl: 'mock://build.zip',
      buildSize: 100 * 1024 * 1024,
      success: true,
      logs: ['Mock build complete'],
      warnings: [],
    );
  }

  EngineBuildResult _parseBuildResult(Map<String, dynamic> data) {
    return EngineBuildResult(
      engine: data['engine'] ?? 'unknown',
      targetPlatform: data['target_platform'] ?? 'unknown',
      buildUrl: data['build_url'] ?? '',
      buildSize: data['build_size'] ?? 0,
      success: data['success'] ?? false,
      logs: List<String>.from(data['logs'] ?? []),
      warnings: List<String>.from(data['warnings'] ?? []),
    );
  }
}

/// Ergebnis der Engine-Integration
class EngineIntegrationResult {
  final String engine;
  final bool success;
  final List<String> importedAssets;
  final int sceneCount;
  final List<String> warnings;
  final List<String> logs;

  EngineIntegrationResult({
    required this.engine,
    required this.success,
    required this.importedAssets,
    required this.sceneCount,
    required this.warnings,
    required this.logs,
  });
}

/// Ergebnis der Code-Generierung
class EngineCodeResult {
  final String engine;
  final List<EngineCodeFile> codeFiles;
  final List<String> warnings;
  final List<String> logs;

  EngineCodeResult({
    required this.engine,
    required this.codeFiles,
    required this.warnings,
    required this.logs,
  });
}

class EngineCodeFile {
  final String filename;
  final String content;

  EngineCodeFile({required this.filename, required this.content});
}

/// Ergebnis des Engine-Builds
class EngineBuildResult {
  final String engine;
  final String targetPlatform;
  final String buildUrl;
  final int buildSize;
  final bool success;
  final List<String> logs;
  final List<String> warnings;

  EngineBuildResult({
    required this.engine,
    required this.targetPlatform,
    required this.buildUrl,
    required this.buildSize,
    required this.success,
    required this.logs,
    required this.warnings,
  });
}

/// DOKUMENTATION:
/// - Für echte Integration: CLI- oder API-Calls in den jeweiligen Adapter einbauen
/// - Adapter können erweitert werden (z.B. Unreal, Phaser, Custom)
/// - Registry ermöglicht dynamische Auswahl und Erweiterung
/// - Mock-Implementierungen erlauben UI/UX-Tests ohne Engine-Abhängigkeit 