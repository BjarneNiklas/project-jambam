# Project Jambam

### (Jamba M — BAM: Building Autonomous Metaverse)

*Your AI Co-Creator for Game Jams and the Metaverse*

## Vision

Project Jambam aims to democratize and accelerate the entire development process of interactive 3D applications (games, simulations, metaverse building blocks) by providing an AI-powered co-creation platform. It aspires to be a "GitHub Copilot for the 3D world" with strong community aspects, especially tailored for events like game jams.

## Core Features

Project Jambam is built upon four foundational pillars:

1.  **The Concept Forge (AI Innovation Assistant):** Generates complete "Jam Kits" (themes, quests, descriptions, asset suggestions) on demand, based on user input, scientific contexts, and market trends.
2.  **The JamFam (Community & Gamification):** A vibrant ecosystem where users can propose, vote on, and collaboratively develop themes and ideas. Meaningful gamification will reward quality contributions.
3.  **Open Architecture:** A cross-platform application (Mobile, Web, Desktop) with an API-first design, enabling future integration with any game engine (Unity, Godot, etc.) via plugins.
4.  **Long-Term Roadmap:** The evolution from an ideation tool towards an explorable 3D marketplace (built on OpenUSD) and a multi-engine development platform.

## Tech Stack

The initial frontend framework for Project Jambam is **Flutter** (using the Dart programming language). This choice was made due to its strong cross-platform capabilities, allowing for a single codebase across multiple platforms.

## Getting Started

(This section is a placeholder and will be updated with detailed instructions.)

To get started with Project Jambam, you'll need to have Flutter installed on your system.

1.  **Install Flutter:** Follow the official Flutter installation guide: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
2.  **Clone the repository:**
    ```bash
    git clone https://github.com/your-username/project-jambam.git
    cd project-jambam
    ```
3.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
4.  **Configure Environment (Flutter & API):**
    *   **Flutter App:** You need to provide your Supabase project URL and Anon Key. These are typically set in `lib/src/core/environment.dart` or directly in `lib/main.dart` where Supabase is initialized. Look for `Environment.supabaseUrl` and `Environment.supabaseAnonKey`.
    *   **FastAPI Backend:** The backend also requires Supabase configuration (URL and Service Key) via environment variables (see `api/core/config.py` and `api/env.example`).
    *   **App Initialization:** Ensure that core services like Logging (`Logger.initialize()`) and API services (`EnhancedApiService().initialize()`) are called early in `main.dart` as they are crucial for application functionality including caching and offline support.

5.  **Run the app:**
    ```bash
    flutter run
    ```

## Key Features & Optimizations

*   **Robust Logging:** Uses the `logging` package for structured and configurable logging.
*   **State Management:** Leverages Riverpod for efficient and scalable state management.
*   **Performance:** Includes widget rendering optimizations, image caching (`CachedNetworkImage`), and API response caching (`DioCacheInterceptor` with Hive/Memory stores).
*   **Offline Support:** Basic infrastructure for offline data handling and request synchronization.
*   **Style Adherence:** Follows a defined style guide for UI/UX consistency (see `docs/STYLE_GUIDE.md`).

## Authentication System

Project Jambam now uses **Supabase** for its authentication and user management. This replaces the previous custom JWT-based system in the backend.

*   **Backend (FastAPI):**
    *   User registration and login are handled via Supabase.
    *   User profile data is stored in the `profiles` table in Supabase.
    *   API endpoints related to users now expect Supabase User IDs (UUID strings).
*   **Frontend (Flutter):**
    *   The Flutter app uses the `supabase_flutter` package to interact with Supabase for auth.
    *   Ensure you have configured the Supabase URL and Anon Key as mentioned in the "Configure Environment" step.

## Contributing

We welcome contributions to Project Jambam! Please refer to the `CONTRIBUTING.md` file for guidelines on how to contribute to the project. (Note: `CONTRIBUTING.md` will be created soon).
