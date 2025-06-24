**Note:** This changelog is no longer automatically updated. Future release notes and changelogs will be available under the [GitHub Releases](https://github.com/LUVY-Platform/luvyengine/releases) page for this repository. The content below is kept for historical purposes.

---
<!-- Farbdefinitionen für Changelog -->
<style>
.changelog-added { color: #27ae60; }
.changelog-improved { color: #2980b9; }
.changelog-fixed { color: #f1c40f; }
.changelog-removed { color: #e74c3c; }
</style>

# Changelog
## [Unreleased]
<span style="color:#27ae60">[ADDED]</span> This setup allows for A/B testing of UI frameworks and provides a
foundation for developing identical user interfaces in both Flutter and
React to evaluate performance and integration with game engines.
Bjarne Niklas Luttermann
Merge pull request [[#8](https://github.com/LUVY-Platform/luvyengine/pull/8)](https://github.com/LUVY-Platform/luvyengine/pull/8) from AURAVTECH/feat/gameplay-framework-proposal
docs: Add gameplay and gamification framework proposal
Bjarne Niklas Luttermann
Merge pull request [[#7](https://github.com/LUVY-Platform/luvyengine/pull/7)](https://github.com/LUVY-Platform/luvyengine/pull/7) from AURAVTECH/feat/e-learning-quiz
feat: Add E-Learning quiz section
Bjarne Niklas Luttermann
Merge pull request [[#6](https://github.com/LUVY-Platform/luvyengine/pull/6)](https://github.com/LUVY-Platform/luvyengine/pull/6) from AURAVTECH/doc-feature-ideas
docs: Add feature_ideas.md and link from project overview
Bjarne Niklas Luttermann
Merge pull request [[#5](https://github.com/LUVY-Platform/luvyengine/pull/5)](https://github.com/LUVY-Platform/luvyengine/pull/5) from AURAVTECH/initial-landscape-generator
feat: Implement initial image-to-3D-landscape generator
google-labs-jules[bot]
docs: Add gameplay and gamification framework proposal
This document outlines the research, analysis, and recommended architectural approach for implementing a gameplay and gamification framework within LUVY Engine.
It proposes developing custom Rust gameplay logic as Bevy plugins within the `gamelogic/` module, integrating specific libraries like `skillratings` for gamification aspects, and defining a clear FFI API via `engines/bevy_engine/` for Dart-Rust interaction.
google-labs-jules[bot]
feat: Implement initial image-to-3D-landscape generator
This commit introduces the foundational features for the application that converts 2D images into 3D block-based landscapes.
Key features implemented:
- Image loading and processing: Reads pixel colors from an input image.
- Color-to-block mapping: Translates specific RGB colors to defined block types (e.g., water, snow, forest, meadow, beach, rock, mountain).
- Random area generation: Black pixels in the input image are converted into a random selection of configured block types (meadow, rock, forest, beach).
- 3D rendering: Utilizes Pyglet for basic 3D visualization of the generated block map.
- Chunking system: Divides the map into chunks (default 16x16) for rendering and future performance optimization.
- Basic camera controls: Allows for orbiting, zooming, and FPS-style movement in the 3D view.
- Configuration: Key parameters like color mappings, block colors, and chunk size are configurable.
- Unit tests: Basic tests for image processing, chunking logic, and block type mapping.
- Documentation: README.md includes instructions on input image color mappings.
Known limitations:
- Full visual testing of the Pyglet rendering output was not possible in the automated environment due to the lack of a display server. Manual visual verification is recommended.
- Color matching for block types currently requires exact RGB values.
This initial version provides a functional base for further development and more advanced features like procedural generation enhancements and terrain editing tools.
google-labs-jules[bot]
docs: Add feature_ideas.md and link from project overview
This commit introduces a new file, docs/feature_ideas.md, which captures
a set of high-level feature concepts that were originally described in a
project issue. The German text from the issue has been translated into
English and structured with markdown for clarity.
A link to this new file has also been added to the "Module & Features"
section of docs/PROJECT_OVERVIEW.md to ensure these ideas are
discoverable within your project documentation.
google-labs-jules[bot]
feat: Add E-Learning quiz section
I've implemented a new E-Learning section accessible from the drawer.
This section includes quizzes on Flutter, Rust, Game Design, and Quantum Computing.
Features:
- Quizzes can be filtered by level, subject, and category.
- You can take quizzes, receive feedback on answers, and see your final score.
- Quiz data is stored in `lib/data/quiz_data.dart`.
- UI widgets for listing and taking quizzes are in `lib/widgets/quiz_widgets.dart`.
- Navigation is set up from the drawer to the quiz list and then to individual quizzes.
- Unit and widget tests have been added to verify the functionality.
Bjarne Niklas Luttermann
Merge pull request [[#4](https://github.com/LUVY-Platform/luvyengine/pull/4)](https://github.com/LUVY-Platform/luvyengine/pull/4) from AURAVTECH/legogpt-core-features
feat: Implement core C++ and FFI for LegoGPT functionality
google-labs-jules[bot]
feat: Implement core C++ and FFI for LegoGPT functionality
This commit introduces the foundational C++ logic and a C Foreign Function
Interface (FFI) for the LegoGPT feature.
Key implementations include:
1.  **LegoModel & LegoBrick:**
    *   Enhanced `LegoBrick` with color and material attributes.
    *   Implemented `rotate` and `scale` methods in `LegoModel` for 3D transformations.
2.  **Parsing & Generation:**
    *   `parseLegoGptData`: Parses a custom string format into a `LegoModel`.
    *   `LegoModelGenerator`: A class to manage a library of raw model strings and generate `LegoModel` instances.
3.  **VoxelWorld:**
    *   `generateSimpleWorld`: Basic procedural generation for a flat voxel world.
    *   Added method signatures for future collision detection and raycasting.
    *   `placeLegoModelInVoxelWorld`: Places a `LegoModel` into the `VoxelWorld`, respecting basic collisions (no placement if voxel is occupied).
4.  **Serialization (for Assets):**
    *   Implemented JSON serialization and deserialization for `LegoModel` and `LegoBrick` using the nlohmann/json library. This allows models to be saved to and loaded from JSON files.
5.  **C FFI Layer (`lego_ffi.h`, `lego_ffi.cpp`):**
    *   Exposes all major functionalities (model generation, VoxelWorld operations, model transformation, JSON serialization/deserialization) through a C-compatible interface using opaque handles. This enables integration with game engines (e.g., Bevy, O3DE) and other programming languages (e.g., Dart for Flutter UI).
6.  **Basic UX - Undo:**
    *   Implemented a single-level undo for the `placeLegoModelInVoxelWorld` operation. `VoxelWorld` now stores the state of voxels affected by the last placement and can revert them. This is exposed via the FFI.
This set of features provides the core backend for generating, manipulating, placing, and preparing Lego models for persistence within a voxel-based environment. The next steps will involve writing unit tests, integrating this C++ backend with a game engine for rendering and interaction, and developing the user interface.
BjarneNiklas
Added Flutter 3D objects
BjarneNiklas
Added good stuff
google-labs-jules[bot]
feat: Initial multi-engine PoC architecture
Sets up the foundational structure for a multi-engine proof-of-concept
integrating with a Flutter application.
Includes:
- A shared C++ core module for procedural generation logic and
  LegoGPT model data representation (headers and placeholder implementations).
- A Luanti-specific C++ integration layer with a C FFI, designed to
  bridge the shared core with the Luanti engine (placeholder Luanti calls).
- An O3DE-specific C++ integration layer (conceptual Gem structure)
  with a C FFI, designed to bridge the shared core with O3DE (placeholder
  O3DE calls).
- A Flutter application with basic UI for mode selection (Luanti/O3DE)
  and FFI bindings to interact with both integration layers.
This commit establishes the initial directory structures, build configurations
(CMakeLists.txt for C++ modules, pubspec.yaml for Flutter), and API
definitions for the proof-of-concept. Further work will involve
implementing the placeholder native functions and integrating with the
actual Luanti and O3DE engine runtimes and rendering.
Bjarne Niklas Luttermann
Merge pull request [[#3](https://github.com/LUVY-Platform/luvyengine/pull/3)](https://github.com/LUVY-Platform/luvyengine/pull/3) from AURAVTECH/feat/bevy-voxel-engine-backend
feat: Implement initial Bevy voxel engine backend and FFI
Bjarne Niklas Luttermann
Merge branch 'main' into feat/bevy-voxel-engine-backend
Bjarne Niklas Luttermann
Merge pull request [[#2](https://github.com/LUVY-Platform/luvyengine/pull/2)](https://github.com/LUVY-Platform/luvyengine/pull/2) from AURAVTECH/feat/bevy-adapter-dart-structure
feat: Add Dart-side Bevy engine adapter structure
Bjarne Niklas Luttermann
Merge pull request [[#1](https://github.com/LUVY-Platform/luvyengine/pull/1)](https://github.com/LUVY-Platform/luvyengine/pull/1) from AURAVTECH/experimental
added useful stuff
BjarneNiklas
added useful stuff
google-labs-jules[bot]
feat: Add Dart-side Bevy engine adapter structure
I've implemented the BevyEngineAdapter class in Dart and integrated it
with the existing PluginManager and EnginesManager.
This includes:
- Definition of BevyEngineAdapter implementing IPlugin and IEngineAdapter.
- Integration into lib/main.dart for initialization and basic UI interaction.
- Placeholder implementations for FFI calls to Rust.
NOTE: The Dart FFI bridge (`lib/src/generated_bridge.dart`)
is currently MISSING. My attempts to generate
this file have consistently failed due to Flutter SDK environment
issues. This commit provides the Dart-side framework, but the
Rust FFI integration is incomplete pending resolution of the
build environment problems.
google-labs-jules[bot]
feat: Implement initial Bevy voxel engine backend and FFI
I've implemented the foundational backend for a voxel engine using Bevy in Rust.
Key features included:
- Core data structures: Voxel, Chunk (16x16x16), and VoxelWorld resource.
- Procedural world generation using Perlin noise to create a simple terrain
  across multiple chunks on startup.
- Basic "naive cube" meshing for generated chunks, creating Bevy mesh
  entities.
- FFI functions exposed via flutter_rust_bridge:
    - initialize_bevy_engine_and_world(): Starts the Bevy app and world
      generation/meshing in a new thread.
    - get_generated_chunk_count(): Retrieves the count of generated chunks.
- I made sure to include unit tests for all new Rust modules (voxel, chunk, world, world_gen,
  meshing) to ensure core logic correctness.
Note on Flutter Integration:
The corresponding Flutter UI integration for these FFI functions is currently
blocked due to issues running `flutter_rust_bridge_codegen` in your
development environment, preventing the generation of Dart FFI bindings.
This backend is functional and ready for integration once the FFI
generation issue is resolved.
github-actions[bot]
docs: Update CHANGELOG.md via automated release workflow
BjarneNiklas
Initial commit
Bjarne Niklas Luttermann
Initial commit  

### Contributors
- `@testing-library/react`.
