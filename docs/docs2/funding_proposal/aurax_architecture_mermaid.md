```mermaid
graph TD;
    %% Styles
    classDef platform fill:#daf,stroke:#a8c,stroke-width:2px;
    classDef engine fill:#adf,stroke:#7ac,stroke-width:2px;
    classDef module fill:#fdd,stroke:#c99,stroke-width:1px;
    classDef data fill:#fdb,stroke:#c98,stroke-width:1px;
    classDef ui fill:#dfd,stroke:#9c9,stroke-width:1px;
    classDef community fill:#ffd,stroke:#cc9,stroke-width:1px;
    classDef ai fill:#dff,stroke:#9cc,stroke-width:1px;

    %% AURAX Platform
    subgraph AURAX_Platform ["AURAX Platform (Open, Modular, AI-Driven)"]
        direction LR
        AP_UI["Flutter UI (Mobile-First, In-App Dev)"]:::ui
        AP_Services["Platform Services"]
        AP_Marketplace["Asset Marketplace"]:::module
        AP_Analytics["Analytics & Tagging"]:::ai
        AP_CommunityTools["Community Tools (Game Jams, Live Area)"]:::community

        AP_UI --> AP_Services;
        AP_Services --> AP_Marketplace;
        AP_Services --> AP_Analytics;
        AP_Services --> AP_CommunityTools;
        AP_Services --> LUVY_Engine;
    end
    class AURAX_Platform platform;

    %% LUVY Engine
    subgraph LUVY_Engine ["LUVY Engine (Innovative, AI-Powered)"]
        direction TD
        LE_Core["Core (Orchestration, Plugin System, DI, Registry)"]:::module
        
        subgraph LE_Engines ["Engines (Multi-Engine Support)"]
            direction TB
            LE_Broxel["Broxel Engine (Voxel, Multi-Engine Capable)"]:::engine
            LE_Adapter_Unity["Unity Adapter"]:::module
            LE_Adapter_Godot["Godot Adapter"]:::module
            LE_Adapter_Bevy["Bevy Adapter"]:::module
            LE_Adapter_O3DE["O3DE Adapter"]:::module
        end

        subgraph LE_Mindflow ["Mindflow (AI Modules)"]
            direction TB
            LE_LegoGPT["LegoGPT (Style Transfer, Level Opt., Gen AI)"]:::ai
            LE_GameDesignAsst["Game Design Assistant"]:::ai
            LE_ProcGen["Procedural Generation Tools"]:::ai
            LE_AIBridge["AI Bridge (OpenAI, HuggingFace, Local Models)"]:::ai
        end
        class LE_Mindflow ai

        LE_GameJam["GameJam Module (Engine-Agnostic)"]:::module
        LE_GameLogic["GameLogic (Genres, Simulations, Robotics)"]:::module
        
        subgraph LE_Data ["Data Layer (Offline-First)"]
            direction LR
            LE_SQLite["SQLite (Offline)"]:::data
            LE_CloudSync["PostgreSQL/Supabase (Cloud, Optional)"]:::data
        end
        
        LE_Plugins["Plugin System (Extensibility)"]:::module

        LE_Core --> LE_Engines;
        LE_Core --> LE_Mindflow;
        LE_Core --> LE_GameJam;
        LE_Core --> LE_GameLogic;
        LE_Core --> LE_Data;
        LE_Core --> LE_Plugins;
        LE_Engines -.-> LE_Plugins;
        LE_Mindflow -.-> LE_Plugins;
        LE_GameLogic -.-> LE_Plugins;
    end
    class LUVY_Engine engine;

    %% Community & Creators
    subgraph Creators_Community ["Community & Creators"]
        direction TD
        Users["Users / Players"]:::community
        Developers["Developers / Creators"]:::community
        Influencers["Influencers"]:::community
    end
    class Creators_Community community;

    %% Content & Data Flow
    Minigames["Minigames (Creative, Analytical, AI-Powered)"]:::module
    Games["Full Games (User-Generated, Co-Created)"]:::module
    AssetUsageData["Asset & Usage Data"]:::data
    TrainedAIModels["Trained AI Models"]:::ai
    
    %% Relationships
    Creators_Community -- "Create & Use" .-> AP_UI;
    Creators_Community -- "Participate & Contribute" .-> AP_CommunityTools;
    Creators_Community -- "Share & Monetize" .-> AP_Marketplace;
    
    AP_UI -- "Access & Develop With" .-> LUVY_Engine;
    LUVY_Engine -- "Powers" .-> Minigames;
    LUVY_Engine -- "Powers" .-> Games;
    AP_CommunityTools -- "Hosts & Facilitates" .-> Minigames;
    AP_CommunityTools -- "Hosts & Facilitates" .-> Games;
    
    Minigames -- "Generate" .-> AssetUsageData;
    Games -- "Generate" .-> AssetUsageData;
    AssetUsageData -- "Input for" .-> AP_Analytics;
    AssetUsageData -- "Trains" .-> LE_Mindflow;
    LE_Mindflow -- "Outputs" .-> TrainedAIModels;
    TrainedAIModels -- "Improves & Enables" .-> LUVY_Engine;
    TrainedAIModels -- "Enhances" .-> AP_Analytics;
    TrainedAIModels -- "Assists" .-> AP_UI;


    %% Styling for specific nodes
    class AP_UI,LE_Core,LE_Broxel,LE_LegoGPT,Minigames,Games,Users,Developers,AP_Marketplace,AP_CommunityTools,AssetUsageData,AP_Analytics highlight;
```
