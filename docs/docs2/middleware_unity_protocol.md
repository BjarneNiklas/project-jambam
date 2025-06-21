# Middleware-Unity Communication Protocol

This document outlines the communication protocol between the Aurax Middleware and a game engine (specifically targeting Unity, but adaptable for others). The protocol uses HTTP for command-based interactions (Middleware to Unity) and WebSockets for event-driven messages (Unity to Middleware).

## 1. Overview

*   **Middleware (Client) to Unity (Server) - Commands:**
    *   Protocol: HTTP/S
    *   Format: JSON payloads
    *   Method: Primarily POST, GET for status/queries.
    *   Unity acts as an HTTP server, exposing endpoints for various commands.
*   **Unity (Server/Client) to Middleware (Server) - Events:**
    *   Protocol: WebSockets
    *   Format: JSON payloads
    *   Unity connects to a WebSocket server hosted by the Middleware to send asynchronous events (e.g., "simulation step complete", "user interaction", "error occurred").

## 2. HTTP Command Protocol (Middleware -> Unity)

The Middleware sends commands to Unity to control engine behavior, load assets, spawn entities, etc. Unity must expose an HTTP server listening on a configurable port.

### 2.1. Common Request Structure

*   **Endpoint Base URL:** `http://<unity_host>:<unity_port>/api/v1/`
*   **Content-Type:** `application/json`
*   **Authentication (Optional):** An API key or token might be passed in headers (e.g., `X-API-Key: <key>`) if security is required.

### 2.2. Common Response Structure

*   **Success (200 OK):**
    ```json
    {
        "status": "success",
        "data": { /* command-specific response data */ }
    }
    ```
*   **Error (4xx, 5xx):**
    ```json
    {
        "status": "error",
        "message": "A description of the error.",
        "details": { /* optional, more detailed error info */ }
    }
    ```

### 2.3. Standard Endpoints & Payloads

These endpoints correspond to methods in the `EngineAdapter` trait.

#### 2.3.1. Initialize Engine

*   **Endpoint:** `POST /api/v1/engine/initialize`
*   **Request Body:**
    ```json
    {
        "engine_settings": { /* Unity-specific settings */ },
        "project_path": "/path/to/unity/project", // Optional
        "initial_scene": "MainMenu" // Optional
    }
    ```
*   **Response Body (Success):**
    ```json
    {
        "status": "success",
        "data": {
            "message": "Unity engine initialized successfully.",
            "engine_version": "202x.x.x",
            "status": "ready"
        }
    }
    ```

#### 2.3.2. Shutdown Engine

*   **Endpoint:** `POST /api/v1/engine/shutdown`
*   **Request Body:** (Empty or specific shutdown parameters)
    ```json
    {}
    ```
*   **Response Body (Success):**
    ```json
    {
        "status": "success",
        "data": {
            "message": "Unity engine shut down."
        }
    }
    ```

#### 2.3.3. Get Engine Status

*   **Endpoint:** `GET /api/v1/engine/status`
*   **Response Body (Success):**
    ```json
    {
        "status": "success",
        "data": {
            "current_scene": "Level1",
            "is_playing": true,
            "fps": 60,
            "memory_usage_mb": 512
            // ... other relevant status info
        }
    }
    ```

#### 2.3.4. Send Generic Command

This provides flexibility for engine-specific commands not covered by dedicated endpoints.

*   **Endpoint:** `POST /api/v1/command/{command_name}`
    *   Example: `POST /api/v1/command/MyCustomUnityFunction`
*   **Request Body:** Command-specific arguments.
    ```json
    {
        "param1": "value1",
        "param2": 123
    }
    ```
*   **Response Body (Success):** Command-specific output.
    ```json
    {
        "status": "success",
        "data": { /* result from MyCustomUnityFunction */ }
    }
    ```

#### 2.3.5. Load Level/Scene

*   **Endpoint:** `POST /api/v1/world/load_level`
*   **Request Body:**
    ```json
    {
        "level_name": "DesertOasis", // or "level_path": "Assets/Scenes/DesertOasis.unity"
        "load_additive": false // Optional: Whether to load additively
    }
    ```
*   **Response Body (Success):**
    ```json
    {
        "status": "success",
        "data": { "message": "Level 'DesertOasis' loaded." }
    }
    ```

#### 2.3.6. Spawn Entity

*   **Endpoint:** `POST /api/v1/entities/spawn`
*   **Request Body:**
    ```json
    {
        "prefab_name": "RobotCharacter", // or "asset_id": "guid_or_path"
        "position": { "x": 0.0, "y": 1.0, "z": 5.0 },
        "rotation": { "x": 0.0, "y": 0.0, "z": 0.0, "w": 1.0 }, // Quaternion
        "initial_properties": {
            "health": 100,
            "ai_behavior": "patrol"
        }
    }
    ```
*   **Response Body (Success):**
    ```json
    {
        "status": "success",
        "data": {
            "entity_id": "unique_id_of_spawned_robot_123",
            "message": "Entity 'RobotCharacter' spawned."
        }
    }
    ```

#### 2.3.7. Destroy Entity

*   **Endpoint:** `POST /api/v1/entities/destroy`
*   **Request Body:**
    ```json
    {
        "entity_id": "unique_id_of_spawned_robot_123"
    }
    ```
*   **Response Body (Success):**
    ```json
    {
        "status": "success",
        "data": { "message": "Entity 'unique_id_of_spawned_robot_123' destroyed." }
    }
    ```

#### 2.3.8. Set Entity Properties

*   **Endpoint:** `POST /api/v1/entities/set_properties`
*   **Request Body:**
    ```json
    {
        "entity_id": "unique_id_of_spawned_robot_123",
        "properties": {
            "health": 90,
            "target_position": { "x": 10.0, "y": 1.0, "z": -2.0 }
        }
    }
    ```
*   **Response Body (Success):**
    ```json
    {
        "status": "success",
        "data": { "message": "Properties updated for entity 'unique_id_of_spawned_robot_123'." }
    }
    ```

#### 2.3.9. Get Entity Properties

*   **Endpoint:** `GET /api/v1/entities/get_properties?entity_id=unique_id_of_spawned_robot_123`
    *   (Alternatively, POST with body `{"entity_id": "..."}`)
*   **Response Body (Success):**
    ```json
    {
        "status": "success",
        "data": {
            "entity_id": "unique_id_of_spawned_robot_123",
            "properties": {
                "health": 90,
                "current_position": { "x": 1.5, "y": 1.0, "z": 3.2 },
                "ai_behavior": "patrol"
                // ... other properties
            }
        }
    }
    ```

#### 2.3.10. Generate Voxel World (Lego/Voxel Specific)

*   **Endpoint:** `POST /api/v1/voxel/generate_world`
*   **Request Body:**
    ```json
    {
        "seed": 12345,
        "width": 64,
        "height": 32,
        "depth": 64,
        "generation_algorithm": "PerlinNoiseTerrain", // Example
        "custom_lego_models": [ /* Array of model JSON strings or identifiers */ ] // Optional
    }
    ```
*   **Response Body (Success):**
    ```json
    {
        "status": "success",
        "data": {
            "world_id": "voxel_world_789",
            "message": "Voxel world generated."
        }
    }
    ```

#### 2.3.11. Place Voxel Model (Lego/Voxel Specific)

*   **Endpoint:** `POST /api/v1/voxel/place_model`
*   **Request Body:**
    ```json
    {
        "model_data": { /* Full JSON representation of the Lego model */ },
        "position": { "x": 10, "y": 5, "z": 12 }, // Voxel coordinates
        "rotation": { "axis": "y", "angle": 90 } // Or quaternion
    }
    ```
*   **Response Body (Success):**
    ```json
    {
        "status": "success",
        "data": { "message": "Voxel model placed." }
    }
    ```

#### 2.3.12. Display Voxel Model (Lego/Voxel Specific)

*   **Endpoint:** `POST /api/v1/voxel/display_model`
*   **Request Body (Example for raw voxel data):**
    ```json
    {
        "width": 32,
        "height": 32,
        "depth": 32,
        "voxels": [
            { "x": 0, "y": 0, "z": 0, "type": 1 }, // type could be color_id or block_id
            { "x": 1, "y": 0, "z": 0, "type": 2 }
            // ... more voxels
        ]
    }
    ```
*   **Response Body (Success):**
    ```json
    {
        "status": "success",
        "data": { "message": "Voxel model display updated/set." }
    }
    ```

#### 2.3.13. Clear Voxel View (Lego/Voxel Specific)

*   **Endpoint:** `POST /api/v1/voxel/clear_view`
*   **Request Body:** (Empty)
    ```json
    {}
    ```
*   **Response Body (Success):**
    ```json
    {
        "status": "success",
        "data": { "message": "Voxel view cleared." }
    }
    ```

## 3. WebSocket Event Protocol (Unity -> Middleware)

Unity connects to a WebSocket server hosted by the Middleware to send real-time events.

*   **Middleware WebSocket URL:** `ws://<middleware_host>:<middleware_ws_port>/events`

### 3.1. Event Message Structure

All messages from Unity to the Middleware over WebSockets should be JSON and follow this structure:

```json
{
    "event_type": "event_name_string", // e.g., "simulation_step", "entity_damaged", "user_input"
    "timestamp": "ISO_8601_datetime_string", // e.g., "2023-10-27T10:30:00Z"
    "source": "UnityEngine", // Or more specific (e.g., "UnityEngine:PhysicsSystem")
    "payload": { /* event-specific data */ }
}
```

### 3.2. Standard Event Types & Payloads

#### 3.2.1. Engine Ready

*   **`event_type`**: `"engine_ready"`
*   **`payload`**:
    ```json
    {
        "message": "Unity engine is ready and connected via WebSocket.",
        "engine_version": "202x.x.x"
    }
    ```

#### 3.2.2. Scene Loaded

*   **`event_type`**: `"scene_loaded"`
*   **`payload`**:
    ```json
    {
        "scene_name": "Level1",
        "build_index": 1 // Optional
    }
    ```

#### 3.2.3. Simulation Step (e.g., after each physics update or frame)

*   **`event_type`**: `"simulation_step_completed"`
*   **`payload`**:
    ```json
    {
        "frame_number": 12345,
        "delta_time_ms": 16.67
    }
    ```

#### 3.2.4. Entity State Update

*   **`event_type`**: `"entity_state_update"`
*   **`payload`**:
    ```json
    {
        "entity_id": "unique_id_of_robot_123",
        "changes": {
            "position": { "x": 1.6, "y": 1.0, "z": 3.3 },
            "health": 85
        }
    }
    ```

#### 3.2.5. User Interaction

*   **`event_type`**: `"user_interaction"`
*   **`payload`**:
    ```json
    {
        "interaction_type": "button_click", // "key_press", "mouse_click"
        "ui_element_id": "StartSimulationButton", // Optional
        "details": { /* e.g., key_code, mouse_coordinates */ }
    }
    ```

#### 3.2.6. Log Message / Engine Warning

*   **`event_type`**: `"engine_log"`
*   **`payload`**:
    ```json
    {
        "log_level": "Warning", // "Info", "Error"
        "message": "Asset not found: MyMissingTexture.png",
        "stack_trace": "..." // Optional
    }
    ```

#### 3.2.7. Custom Event

*   **`event_type`**: `"custom_event"` (or a more specific user-defined event name)
*   **`payload`**:
    ```json
    {
        "custom_event_name": "MyGameSpecificEvent",
        "data": { /* any relevant data for this custom event */ }
    }
    ```

## 4. Considerations

*   **Error Handling:** Robust error handling and reporting are crucial on both sides.
*   **Idempotency:** For critical operations, consider how to handle retries and ensure idempotency where possible (e.g., using unique request IDs).
*   **Scalability:** For multiple Unity instances, the Middleware needs to manage connections and route commands/events appropriately. The HTTP server in Unity might need to be designed to handle concurrent requests if the middleware sends commands rapidly.
*   **Security:** For production environments, HTTPS and WSS should be used. Authentication/authorization mechanisms should be implemented.
*   **Versioning:** The API should be versioned (e.g., `/api/v1/`) to allow for future changes without breaking existing integrations.

This protocol provides a foundational structure. Specific commands, event types, and their payloads will need to be further detailed based on the exact requirements of the Aurax project and its interaction with the game engine.
