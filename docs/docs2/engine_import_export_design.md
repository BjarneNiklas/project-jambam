# LUVY Engine Import/Export Design

This document outlines the design for importing and exporting projects and assets between different game engines supported by LUVY.

## 1. Goals

-   **Interoperability:** Allow users to move assets and basic project structures between supported engines (Bevy, Godot, Unity, Broxel, O3DE, etc.) where feasible.
-   **Flexibility:** Accommodate the diverse nature of game engines and their asset pipelines.
-   **Extensibility:** Allow new engines and formats to be supported over time.
-   **User Experience:** Make the import/export process as smooth as possible, managing expectations about what can and cannot be perfectly translated.

## 2. Core Design Philosophy: Hybrid Approach

A purely universal format for entire game projects is extremely challenging due to the proprietary and highly specific nature of engine scene files, material systems, scripting APIs, and build configurations. Therefore, a hybrid approach is proposed:

1.  **Standardized Asset Interchange:** Utilize industry-standard formats for common asset types.
2.  **Engine-Specific Conversion via Adapters:** Rely on engine adapters to handle the complex translation of engine-specific data (scenes, project settings, materials, scripts).
3.  **Metadata Manifest:** Accompany exported packages with a metadata file that describes the contents, dependencies, and original format.

## 3. Asset Interchange Formats

### 3.1. 3D Models, Materials, and Scenes (Partial)

-   **Format:** **glTF 2.0 (GL Transmission Format - `.gltf`, `.glb`)**
-   **Scope:** Static and animated 3D models, PBR materials, basic scene hierarchy (nodes, transforms).
-   **Pros:** Industry standard, widely supported, royalty-free, good for web and native.
-   **Cons/Limitations:**
    -   **Complex Materials/Shaders:** Custom shaders and complex material graphs from engines like Unity or Godot may not fully translate. Basic PBR properties (albedo, metallic, roughness, normal, emission) are well-supported.
    -   **Engine-Specific Scene Components:** Scripts, custom components, physics properties, lighting setups beyond basic lights will likely not be fully represented.
    -   **Prefabs/Prototypes:** glTF itself doesn't have a concept of engine-specific prefabs. These would need to be reconstructed.
-   **Action:** Engine adapters will be responsible for exporting models and basic scene structures to glTF and importing them.

### 3.2. 2D Textures and Images

-   **Formats:** **PNG, JPEG, KTX2 (with Basis Universal compression)**
-   **Scope:** Albedo maps, normal maps, UI elements, sprites.
-   **Action:** Export in original high-quality format (e.g., PNG) or a compressed universal format like KTX2 where appropriate. Adapters handle conversion to engine-preferred formats on import if needed (e.g., `.dds`, specific compression settings).

### 3.3. Audio Assets

-   **Formats:** **WAV (uncompressed), Ogg Vorbis (compressed), MP3 (compressed)**
-   **Scope:** Sound effects, music.
-   **Action:** Export in WAV for quality or Ogg Vorbis/MP3 for size.

### 3.4. Scripts

-   **Formats:** **Plain Text (`.gd` for Godot, `.cs` for Unity/Godot C#, `.rs` for Bevy, `.lua`, `.py`)**
-   **Scope:** Game logic scripts.
-   **Challenge:** Direct script translation is generally **not feasible** due to differences in APIs, languages, and paradigms.
-   **Action:**
    -   Scripts will be exported as plain text files in their original language.
    -   The metadata manifest will list scripts and their original engine/language.
    -   **No automatic conversion.** Users will need to rewrite or adapt scripts for the target engine.
    -   LUVY's Mindflow API might eventually assist in suggesting API mappings or code structure changes, but this is a complex AI task for the future.

### 3.5. Scene Files (Engine-Specific)

-   **Challenge:** Scene files (`.tscn` for Godot, `.unity` for Unity, Bevy's ECS approach) are highly engine-specific.
-   **Action:**
    -   **Primary Export:** Export scene *content* to glTF where possible (geometry, basic hierarchy).
    -   **Secondary Export (Optional):** The engine adapter *may* also export its native scene file format as part of the package. This file would only be directly usable by the same engine.
    -   **Import:** Importing a glTF can create a new scene in the target engine. Reconstructing complex scene logic, lighting, and entity component setups will be required.

### 3.6. Other Asset Types

-   **Fonts:** TTF, OTF.
-   **Data Files:** JSON, XML, CSV (exported as is).
-   **Shaders:** Export raw shader code (`.glsl`, `.hlsl`, `.shader`) but expect significant rework for different engines.

## 4. Project Settings and Configuration

-   **Challenge:** Extremely engine-specific (build settings, input mappings, physics layers, rendering pipelines).
-   **Action: Limited Scope via Custom Manifest**
    -   A `project_luvy_manifest.json` file will be created at the root of the exported package.
    -   This manifest will store:
        -   **Original Engine:** Name and version (e.g., "Godot 4.1", "Unity 2022.3").
        -   **Export Timestamp.**
        -   **LUVY Exporter Version.**
        -   **List of Assets:** Path, type (e.g., "model_gltf", "texture_png"), original engine path, dependencies (e.g., a model depending on specific textures).
        -   **Basic Project Configuration (Common Subset):**
            -   `project_name: String`
            -   `default_scene: Option<String>` (path to main scene file, if applicable)
            -   `target_resolution: Option<(u32, u32)>`
            -   `primary_scripting_language: Option<String>`
            -   *Other common settings identified through research.*
        -   **Engine-Specific Settings (Opaque Blob):** The source engine adapter can optionally include a section in the manifest with its own settings (e.g., specific rendering features enabled, important plugin versions). This blob is not intended for direct translation but can provide hints to the importing adapter or user.

```json
// Example: project_luvy_manifest.json
{
  "exporter_version": "LUVY_Exporter_v0.1",
  "export_timestamp": "2024-03-15T10:00:00Z",
  "source_engine": {
    "name": "Godot",
    "version": "4.1.2"
  },
  "project_settings": {
    "project_name": "MyAwesomeGame",
    "default_scene_path": "scenes/main_scene.gltf", // Path within the export package
    "primary_scripting_language": "GDScript"
  },
  "assets": [
    {
      "path_in_package": "models/player.glb",
      "original_path": "res://player/player_character.glb",
      "type": "model_gltf",
      "dependencies": ["textures/player_albedo.png"]
    },
    {
      "path_in_package": "textures/player_albedo.png",
      "original_path": "res://player/textures/player_albedo.png",
      "type": "texture_png",
      "dependencies": []
    },
    {
      "path_in_package": "scripts/player_controller.gd",
      "original_path": "res://player/player_controller.gd",
      "type": "script_gdscript",
      "dependencies": []
    }
    // ... other assets
  ],
  "engine_specific_blob": {
    // Godot-specific settings, not for direct translation by other engines
    "godot_settings": {
      "rendering_mode": "forward_plus",
      "active_plugins": ["plugin_a_v1.2"]
    }
  }
}
```

## 5. Import/Export Process Flow

1.  **User Initiates Export (via LUVY UI/Tooling):**
    -   Selects project or specific assets to export.
    -   Specifies target "LUVY Interchange Package" format (which is essentially a structured folder with the manifest).
2.  **Rust Middleware Orchestration:**
    -   Receives request (potentially via FFI from Flutter UI, or an internal command).
    -   Identifies the source engine of the project (e.g., from project metadata managed by LUVY).
    -   Invokes the appropriate **Engine Adapter** for the source engine (e.g., `GodotEngineAdapter`).
3.  **Engine Adapter `export_project(outputPath, options)` / `export_asset(...)`:**
    -   The adapter uses the source engine's tools or APIs (if available) to:
        -   Convert 3D models/scenes to glTF.
        -   Copy other assets (textures, audio) to standard formats.
        -   Collect metadata for each asset.
        -   Extract relevant common project settings.
        -   Generate the `project_luvy_manifest.json`.
    -   The output is a folder containing the manifest and all exported assets in a structured way.
    -   This folder might be zipped by the middleware for easier distribution.
4.  **User Initiates Import:**
    -   Selects a LUVY Interchange Package (folder or zip).
    -   Specifies the target engine.
5.  **Rust Middleware Orchestration:**
    -   Reads the `project_luvy_manifest.json`.
    -   Identifies the target engine adapter (e.g., `UnityEngineAdapter`).
    -   Invokes `import_project(packagePath, options)` on the target adapter.
6.  **Engine Adapter `import_project(packagePath, options)` / `import_asset(...)`:**
    -   Parses `project_luvy_manifest.json`.
    -   Imports glTF assets (models, basic scenes).
    -   Copies standard assets (textures, audio) into the target engine's project structure, potentially converting them to engine-optimal formats (e.g., texture compression).
    -   Applies common project settings from the manifest if possible.
    -   **Crucially, it does NOT attempt to automatically convert scripts or complex engine-specific scene logic.** It may lay out the basic scene hierarchy from glTF.
    -   It may use the `engine_specific_blob` from the manifest as hints if importing from the same engine type (e.g., Godot 4.0 project to Godot 4.1).
    -   The user will need to configure render pipelines, input, physics, re-attach/rewrite scripts, and relink materials/shaders.

## 6. Integration with Engine Adapter Architecture

The existing `IEngineAdapter` concept (even if currently in Dart) needs to be extended or mirrored in the Rust middleware's interaction model with engine adapters (which could be Rust crates, FFI calls, or gRPC services).

**New (Conceptual) Adapter Interface Methods:**

```rust
// Conceptual Rust trait for an engine adapter
pub trait EngineAdapter {
    // ... existing methods like open_project, etc. ...

    /// Exports the currently open project to the LUVY interchange format.
    /// `output_path`: Directory where the interchange package will be created.
    /// `options`: Export options (e.g., specific assets, export quality).
    async fn export_project(&self, output_path: &Path, options: ExportOptions) -> Result<(), AdapterError>;

    /// Imports a project from the LUVY interchange format into the engine.
    /// `package_path`: Path to the root of the interchange package (containing the manifest).
    /// `target_project_path`: Path where the new engine project will be created/updated.
    /// `options`: Import options.
    async fn import_project(&self, package_path: &Path, target_project_path: &Path, options: ImportOptions) -> Result<(), AdapterError>;

    // Potentially similar methods for individual assets:
    // async fn export_asset(&self, asset_id: &str, output_path: &Path, options: AssetExportOptions) -> Result<(), AdapterError>;
    // async fn import_asset(&self, asset_package_path: &Path, target_path_in_project: &str, options: AssetImportOptions) -> Result<(), AdapterError>;
}

pub struct ExportOptions { /* ... */ }
pub struct ImportOptions { /* ... */ }
// ... other structs and error types ...
```

-   The Rust middleware's `EngineManager` component would be responsible for calling these adapter methods.
-   The `Engines API` (OpenAPI spec) could expose endpoints to trigger these import/export operations, which the middleware would then route to the appropriate adapter.

## 7. Limitations and User Expectations

It's crucial to set clear expectations:

-   **Perfect "one-click" conversion is not the goal** for entire projects, especially for complex scenes and game logic.
-   **Asset Portability:** Focus is on making common assets (models, textures, audio) portable.
-   **Scripting:** Scripts will require manual rewriting.
-   **Materials/Shaders:** Basic PBR materials will transfer with glTF. Complex, custom shaders will need manual recreation.
-   **Engine-Specific Features:** Physics, UI systems, animation state machines, particle systems, etc., are highly engine-specific and will require manual setup in the target engine.

This design provides a balance between leveraging standards and acknowledging the inherent complexities of engine diversity. The engine adapters bear the primary responsibility for the "last mile" translation.
