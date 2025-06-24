# Gameplay and Gamification Framework Proposal for LUVY Engine

Date: 2025-05-27

## 1. Introduction

This document outlines a proposed architectural approach for implementing gameplay and gamification features within the LUVY Engine.
The primary considerations are LUVY's modular design, its use of Flutter for the main application and Rust with the Bevy engine for performance-sensitive parts, and the need for flexible gameplay logic, potentially starting with survival game mechanics.

## 2. Research Findings

Initial research into existing Rust-based gameplay and gamification frameworks revealed the following:

*   **General Gameplay Frameworks:** No mature, general-purpose Rust frameworks specifically for "survival gameplay mechanics" (that aren't full game engines themselves) were immediately identified in broad searches (e.g., `awesome-rust`). Such systems are often custom-built or are part of engine-specific plugin ecosystems.
*   **Bevy Engine Ecosystem:** LUVY utilizes the Bevy engine (currently version 0.13) for its Rust components. Bevy is a data-driven engine with its own Entity Component System (ECS). Gameplay features in Bevy are typically implemented as plugins that extend its ECS.
*   **Gamification Libraries:**
    *   The **`skillratings`** crate (`atomflunder/skillratings`) was identified as a suitable library for implementing player rating and ranking systems (e.g., Elo, Glicko-2, TrueSkill). This can form a component of the gamification strategy.
    *   Broader, off-the-shelf gamification frameworks (e.g., comprehensive achievement systems, quest managers as generic libraries) were not immediately apparent and may require custom development or integration of smaller, more focused modules.
*   **Networking:** For potential multiplayer aspects (relevant to survival games), libraries like `rust-libp2p` (for P2P) or Bevy-specific networking plugins (e.g., `bevy_replicon`) are available options.

## 3. Analysis of LUVY's Existing Structure

*   **`gamelogic/` Module:** This module is currently a placeholder, containing only a README. It is the designated area for gameplay logic and is suitable for housing new Rust crates for this purpose.
*   **`engines/bevy_engine/` Adapter:**
    *   This adapter is correctly set up as a minimal, headless Bevy instance.
    *   It uses `flutter_rust_bridge` for FFI communication between Dart (LUVY's core) and Rust (Bevy).
    *   The `Cargo.toml` specifies Bevy 0.13. The `edition` field was noted as `2024`, which should likely be `2021` (current latest Rust edition) and requires verification.
    *   This adapter is well-suited to load and manage Bevy plugins developed in the `gamelogic/` module.

## 4. Proposed Architectural Approach

Based on the findings and LUVY's architecture, the following approach is recommended:

1.  **Location of Rust Gameplay Logic:**
    *   All Rust-based gameplay logic should reside in a new Rust crate (or set of crates) within the `gamelogic/` directory (e.g., `gamelogic/rust_game_core/`).
    *   This new crate will be a dependency of the `engines/bevy_engine/` adapter.

2.  **Core Gameplay Development - Custom (Leveraging Bevy):**
    *   The core gameplay mechanics (e.g., survival systems, inventory, crafting, interactions) should be custom-developed as a collection of Bevy plugins within `gamelogic/rust_game_core/`.
    *   These plugins will utilize Bevy's ECS and follow Bevy's plugin development patterns.
    *   Modularity should be key, e.g., `PlayerStatsPlugin`, `InventoryPlugin`, `WorldInteractionPlugin`.

3.  **Integration of Specific Libraries:**
    *   Integrate the `skillratings` crate into `gamelogic/rust_game_core/` for player ranking systems.
    *   Proactively research and integrate other focused Rust libraries or Bevy plugins as needed for features like AI (behavior trees), physics, networking, etc.

4.  **FFI and Interaction with LUVY (Dart):**
    *   The `engines/bevy_engine/src/api.rs` file (using `flutter_rust_bridge`) will define the API for Dart to interact with the Rust/Bevy gameplay systems.
    *   This API should support:
        *   Sending commands and events to the Bevy world.
        *   Querying game state from Bevy.
        *   Receiving events or callbacks from Bevy (e.g., via event streams).

5.  **Example Structure for `gamelogic/rust_game_core/`:**

    ```
    gamelogic/rust_game_core/
    ├── Cargo.toml  (depends on bevy, skillratings, etc.)
    └── src/
        ├── lib.rs          (exports Bevy plugins: CoreGameplayPlugin)
        ├── player/
        │   ├── mod.rs
        │   ├── components.rs
        │   ├── systems.rs
        │   └── inventory_plugin.rs
        ├── survival/
        │   ├── mod.rs
        │   └── stats_plugin.rs
        ├── crafting/
        │   └── crafting_plugin.rs
        ├── gamification/
        │   ├── mod.rs
        │   └── skill_plugin.rs (uses skillratings)
        └── common/         (shared components, utilities)
            └── mod.rs
    ```

6.  **Bevy Integration:**
    *   The `engines/bevy_engine/src/lib.rs` will initialize and add the primary plugin(s) from `gamelogic/rust_game_core/` to the Bevy `App`.

## 5. Recommendations

*   **Proceed with custom Bevy plugin development** for core gameplay features within a new Rust crate in the `gamelogic/` module.
*   **Integrate `skillratings`** for an initial gamification feature.
*   **Define a clear FFI API** in `engines/bevy_engine/src/api.rs` for Dart-Rust interaction, considering asynchronous operations where appropriate.
*   **Verify and correct the Rust edition** in `engines/bevy_engine/Cargo.toml` to `2021` if `2024` is not intentional or valid yet.
*   **Prioritize modularity** within the Rust gameplay code by developing features as distinct Bevy plugins.
*   **Embrace test-driven development** for both the Rust logic and FFI integrations.
*   **Continuously research** the Bevy plugin ecosystem for tools that can accelerate development of specific features (e.g., AI, networking, physics) as these needs become clearer.

## 6. Next Steps (Post-Proposal)

*   User/team discussion and approval of this proposal.
*   Scaffolding of the `gamelogic/rust_game_core/` crate.
*   Begin development of a foundational gameplay plugin (e.g., player stats or basic world interaction).
*   Start defining the initial FFI points in `api.rs`.
```
