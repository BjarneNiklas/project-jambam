# Rust Middleware Communication Protocols

This document details the communication protocols used by the Rust middleware to interact with other components of the LUVY ecosystem.

## 1. Flutter UI <-> Rust Middleware

-   **Protocol:** Foreign Function Interface (FFI)
-   **Direction:** Bidirectional
-   **Purpose:** Allows the Flutter UI (Dart) to invoke Rust functions and for Rust to send data/events back to Flutter.
-   **Implementation Details:**
    -   **Tooling:**
        -   [`flutter_rust_bridge`](https://github.com/fzyzcjy/flutter_rust_bridge) is the recommended tool for generating the FFI bridge code. It simplifies type conversions, error handling, and asynchronous operations over FFI.
        -   Alternatively, `cbindgen` can be used to generate C headers from Rust code, and Dart's `dart:ffi` can be used to call these C functions. This approach is lower-level and requires more manual setup for complex types and async.
    -   **Data Serialization:**
        -   For complex data structures, JSON strings or Protocol Buffers (protobuf) are typically serialized and passed as `String` or `Uint8List` over FFI. `flutter_rust_bridge` handles this automatically for supported types.
        -   Simple primitive types can be passed directly.
    -   **Asynchronous Operations:**
        -   Rust functions exposed via FFI can be asynchronous (returning a `Future` in Dart). `flutter_rust_bridge` provides idiomatic support for this.
        -   Rust can also use `Stream`s to send continuous updates back to Flutter.
    -   **Error Handling:**
        -   Rust functions should return `Result<T, E>` where `E` is an error type that can be serialized and understood by Dart (e.g., a struct representing an error code and message). `flutter_rust_bridge` helps in translating these into Dart exceptions.
-   **Example (Conceptual using `flutter_rust_bridge`):**
    ```rust
    // Rust side
    pub async fn get_user_settings(user_id: String) -> Result<UserSettings, anyhow::Error> {
        // ... logic to fetch settings ...
    }
    pub struct UserSettings { pub theme: String, pub notifications_enabled: bool }
    ```
    ```dart
    // Dart side (generated by flutter_rust_bridge)
    Future<UserSettings> getUserSettings({required String userId});
    class UserSettings { final String theme; final bool notificationsEnabled; ... }
    ```

## 2. Rust Middleware <-> Backend Service APIs

-   **Protocol:** REST (HTTP/S)
-   **Direction:** Rust Middleware to Backend APIs
-   **Purpose:** To consume the services offered by Core, Engines, Mindflow, GameJam, Data, and Plugins APIs.
-   **Implementation Details:**
    -   The Rust middleware will act as an HTTP client.
    -   **Client Library:** A robust HTTP client library like [`reqwest`](https://crates.io/crates/reqwest) will be used.
    -   **Data Serialization/Deserialization:**
        -   `serde` and `serde_json` will be used to serialize request bodies to JSON and deserialize JSON responses into Rust structs.
        -   These Rust structs will be derived from or manually created to match the schemas defined in the OpenAPI specifications for each service.
    -   **API Client Generation (Optional):** Tools like `openapi-generator` (with Rust templates) or `oats` could be used to generate Rust client-side code from the OpenAPI specifications, reducing boilerplate.
    -   **Authentication:** The middleware will attach appropriate `Authorization` headers (Bearer tokens obtained via OAuth2 client credentials flow) to outgoing requests as specified in the OpenAPI security schemes.
    -   **Error Handling:** The middleware will handle HTTP status codes (e.g., 4xx, 5xx) and deserialize error responses (conforming to the `Error` schema in OpenAPI) from the backend services.
-   **Example:**
    ```rust
    // Rust struct mirroring an OpenAPI schema (e.g., CoreStatus)
    #[derive(Deserialize, Serialize)]
    struct CoreStatus {
        status: String,
        timestamp: String, // Consider using chrono::DateTime for actual date handling
        version: String,
        uptime: i64,
    }

    async fn fetch_core_status(api_base_url: &str, token: &str) -> Result<CoreStatus, reqwest::Error> {
        let client = reqwest::Client::new();
        let response = client.get(format!("{}/status", api_base_url))
            .bearer_auth(token)
            .send()
            .await?
            .json::<CoreStatus>()
            .await?;
        Ok(response)
    }
    ```

## 3. Rust Middleware <-> Game Engines (via Engine Adapters)

The Rust middleware, specifically its `EngineAdapter` implementations, communicates with the actual game engines using protocols tailored to each engine's capabilities and architecture. The `EngineAdapter` trait is implemented in Rust within `aurax_middleware`.

### 3.a. Communication with Bevy Engine (via `BevyEngineAdapter`)

-   **Protocol:** Rust Foreign Function Interface (FFI)
-   **Direction:** Bidirectional
-   **Purpose:** High-performance, low-overhead communication with the Bevy engine, which is also Rust-based. The `BevyEngineAdapter` makes direct calls to functions exposed by the Bevy engine crate/library.
-   **Implementation Details:**
    -   The Bevy engine component is treated as a Rust library/crate.
    -   The `BevyEngineAdapter` directly invokes `pub` functions from the Bevy engine library.
    -   Data structures are passed as Rust structs/enums.
    -   Events from Bevy to the middleware are handled via `tokio::sync::broadcast` channels or similar Rust-native mechanisms, exposed through an FFI function that the adapter calls to get a receiver.
-   **Use Case:** Interacting with the Bevy game engine.

### 3.b. Communication with Unity Engine (via `UnityEngineAdapter`)

-   **Protocol:** HTTP/S for commands, WebSockets for events.
-   **Direction:**
    -   Commands: Rust Middleware (client) to Unity Engine (HTTP server).
    -   Events: Unity Engine (WebSocket server/emitter) to Rust Middleware (WebSocket client/listener).
-   **Purpose:** Standard web protocols for interacting with Unity, which typically runs as a separate process and often exposes HTTP/WebSocket endpoints for external control.
-   **Implementation Details:**
    -   **Commands:** `UnityEngineAdapter` uses `reqwest` to send HTTP requests to a server component running inside the Unity game.
    -   **Events:** `UnityEngineAdapter` (or a component it manages, like the shared WebSocket manager in `aurax_middleware/src/engines_api/handlers.rs`) establishes a WebSocket connection to a WebSocket server in Unity to receive real-time events.
    -   Data is serialized to JSON for both HTTP and WebSocket communication.
-   **Use Case:** Interacting with the Unity game engine.

### 3.c. Communication with Godot Engine (via `GodotEngineAdapter`)

-   **Protocol:** C Foreign Function Interface (FFI)
-   **Direction:** Bidirectional
-   **Purpose:** Communication with the Godot engine via a GDNative or GDExtension library.
-   **Implementation Details:**
    -   The `GodotEngineAdapter` calls C functions exposed by a GDNative/GDExtension library (written in C/C++ and part of the Godot project).
    -   These C functions, in turn, call into GDScript or Godot's C++ APIs.
    -   Data is typically serialized to JSON strings when passing complex structures over the C FFI boundary.
    -   Events from Godot to Rust are planned to be handled by Godot calling a C FFI function, which then invokes a registered Rust callback function.
-   **Use Case:** Interacting with the Godot game engine.

## 4. Internal Middleware Communication / Asynchronous Task Management

-   **Protocol:** Direct function calls, Rust channels, or Message Queues (e.g., Redis Streams, NATS, RabbitMQ)
-   **Direction:** Internal to the Rust Middleware
-   **Purpose:** For decoupling components within the middleware, managing long-running background tasks, and handling event-driven logic.
-   **Implementation Details:**
    -   **Direct Calls/Channels:** For most intra-middleware communication, standard Rust concurrency tools (`async/await`, `tokio::spawn`, channels like `tokio::sync::mpsc`) are sufficient.
    -   **Message Queues:**
        -   Considered if:
            -   Tasks need to be persisted and survive middleware restarts.
            -   Multiple worker instances (potentially on different machines, though less likely for this middleware's scope) need to consume tasks.
            -   Complex event-driven architectures are required.
        -   If used, the middleware would produce messages to a queue, and one or more consumer components (within the same process or separate worker processes) would process them.
        -   Requires setup and management of the message broker.
-   **Current Assumption:** Standard Rust concurrency primitives will be prioritized. Message queues will only be introduced if a clear need for their advanced features arises (e.g., for specific Mindflow workflow step execution if they are very long-running and need persistence).

## 5. Security Considerations

-   **FFI (Flutter <-> Rust):** While not inherently a network protocol, the boundary must be treated with care. Input validation should occur on the Rust side even for data coming from Flutter.
-   **REST (Rust <-> Backend APIs):**
    -   All communication **must** be over HTTPS in production.
    -   Bearer tokens (JWTs) obtained via OAuth2 client credentials flow will be used for authenticating the middleware to backend services. The middleware is responsible for securely storing and managing these tokens (or the client secrets needed to obtain them).
-   **gRPC/Local IPC (Rust <-> Engine Adapters):**
    -   If running on the same machine, Unix domain sockets can be used for gRPC to avoid network overhead and improve security.
    -   If using local HTTP, ensure it's bound to `localhost` and not exposed externally.
    -   Consider token-based authentication for local gRPC/HTTP if there's a risk of unauthorized local processes accessing the adapter APIs.
-   **Message Queues:** Secure access to the message broker (authentication, network policies).
