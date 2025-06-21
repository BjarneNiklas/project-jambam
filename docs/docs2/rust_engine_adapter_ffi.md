# Rust Middleware - Engine Adapter Communication

This document outlines communication strategies between the Rust middleware and Engine Adapters. Engine adapters are responsible for interfacing with the actual AI models or other processing engines.

## 1. Scenarios for Engine Adapter Implementation

Engine adapters can be implemented in several ways, each influencing the optimal communication protocol with the Rust middleware:

1.  **Rust Crate:** The adapter is written in Rust and compiled as a crate, becoming a direct dependency of the middleware.
2.  **C/C++ Native Library:** The engine (or its SDK) provides a C or C++ API. The adapter might be a thin Rust wrapper over this library, or the middleware calls it directly.
3.  **Separate Process (e.g., Python Server):** The engine runs in a separate process (common for Python-based AI models). The adapter is part of this separate process or acts as a proxy to it.

## 2. Communication Protocols

### 2.1. Direct Linking / FFI (for Rust Crates or C/C++ Libraries)

This approach is used when the engine adapter can be compiled and linked into the same process as the Rust middleware.

-   **Protocol:** Direct Rust function calls (if adapter is a Rust crate) or Foreign Function Interface (FFI) (if adapter is a C/C++ library or a Rust crate exposing a C API).
-   **Benefits:**
    -   **High Performance:** Lowest latency as there's no network or IPC overhead.
    -   **Simplified Data Handling:** Data can be passed via memory pointers or direct struct usage (with `#[repr(C)]` for C FFI).
    -   **Type Safety:** Strong type checking at compile time (especially for Rust-to-Rust calls).
-   **Implementation (Adapter as Rust Crate):**
    -   The adapter crate exposes a public Rust API (functions, structs).
    -   The middleware adds the adapter crate as a dependency in its `Cargo.toml`.
    -   Communication is via standard Rust function calls.
    ```rust
    // In Engine Adapter Crate (e.g., my_engine_adapter_crate)
    pub struct EngineInput { pub data: String; }
    pub struct EngineOutput { pub result: String; }
    pub fn process(input: EngineInput) -> Result<EngineOutput, anyhow::Error> {
        // ... call actual engine logic ...
        Ok(EngineOutput { result: "processed: ".to_string() + &input.data })
    }

    // In Rust Middleware
    // use my_engine_adapter_crate::{process, EngineInput};
    // fn handle_engine_request(data_from_ui: String) {
    //     let input = EngineInput { data: data_from_ui };
    //     match process(input) {
    //         Ok(output) => { /* send output.result to UI */ },
    //         Err(e) => { /* handle error */ },
    //     }
    // }
    ```
-   **Implementation (Adapter as C/C++ Library or Rust Crate with C API):**
    -   The library exposes functions using `extern "C"` and C-compatible data structures (`#[repr(C)]` structs).
    -   The Rust middleware uses `unsafe` blocks to call these FFI functions.
    -   `cbindgen` can be used if a Rust-based adapter needs to expose a C API for another Rust crate (though direct Rust calls are preferred if both are Rust).
    ```rust
    // C-compatible struct (defined in Rust adapter or C library)
    #[repr(C)]
    pub struct MyEngineAdapterInput {
        pub data: *const std::os::raw::c_char,
        pub data_len: usize,
    }
    #[repr(C)]
    pub struct MyEngineAdapterOutput {
        pub result: *mut std::os::raw::c_char, // Adapter allocates, middleware frees
        pub error_msg: *mut std::os::raw::c_char, // Adapter allocates, middleware frees
    }

    // Function signature in the adapter (e.g., if it's a C library)
    // extern "C" MyEngineAdapterOutput call_engine(MyEngineAdapterInput input);
    // extern "C" void free_engine_output(MyEngineAdapterOutput output);

    // Rust middleware calling the FFI function
    // unsafe {
    //     // ... prepare input ...
    //     // let output = call_engine(c_input);
    //     // ... process output, handle potential errors, and free memory ...
    //     // free_engine_output(output);
    // }
    ```
-   **Data Structures:**
    -   Rust-to-Rust: Native Rust structs/enums.
    -   Rust-to-C/C++: `#[repr(C)]` structs, pointers to primitive types, C strings (`*const c_char`, `*mut c_char`). Careful memory management is required (e.g., who allocates/deallocates).
-   **Error Handling:**
    -   Rust-to-Rust: `Result<T, E>`.
    -   FFI: Typically error codes returned by functions, or a field in the output struct indicating success/failure and error messages.

### 2.2. Inter-Process Communication (IPC) - gRPC (for Separate Processes)

This is preferred when the engine adapter runs as a separate process, especially if it's written in a different language (e.g., Python AI models).

-   **Protocol:** gRPC
-   **Benefits:**
    -   **Language Agnostic:** Protobuf definitions allow services and clients to be written in different languages.
    -   **Strongly Typed:** Service contracts are clearly defined in `.proto` files.
    -   **Efficient:** Uses HTTP/2 and Protobuf binary serialization for good performance (though higher overhead than FFI).
    -   **Streaming:** Supports various streaming modes (unary, server-streaming, client-streaming, bidirectional).
-   **Implementation:**
    1.  **Define `.proto` file:** Specify gRPC service methods and message (request/response) types.
        ```protobuf
        // engine_adapter.proto
        syntax = "proto3";
        package engineadapter;

        service EngineAdapterService {
          rpc ProcessText (TextRequest) returns (TextResponse);
          // Add other RPC methods for different capabilities
        }

        message TextRequest {
          string request_id = 1;
          string text_input = 2;
          map<string, string> parameters = 3;
        }

        message TextResponse {
          string request_id = 1;
          string result_text = 2;
          string error_message = 3; // Empty if successful
        }
        ```
    2.  **Generate Code:**
        -   **Rust Middleware (Client):** Use `tonic-build` to generate Rust client stubs from the `.proto` file.
        -   **Engine Adapter (Server):** Use gRPC tools for the adapter's language (e.g., Python's `grpcio-tools`) to generate server stubs.
    3.  **Implement Client (Middleware) and Server (Adapter):**
        -   Middleware uses the generated client to call the adapter's gRPC service.
        -   Adapter implements the service logic.
    ```rust
    // Rust Middleware (Client example using generated code from tonic-build)
    // async fn call_engine_adapter_grpc(text: String) -> Result<String, Box<dyn std::error::Error>> {
    //     let mut client = EngineAdapterServiceClient::connect("http://[::1]:50051").await?; // Assuming adapter runs on port 50051
    //     let request = tonic::Request::new(TextRequest {
    //         request_id: "some_uuid".to_string(),
    //         text_input: text,
    //         parameters: Default::default(),
    //     });
    //     let response = client.process_text(request).await?;
    //     let reply = response.into_inner();
    //     if !reply.error_message.is_empty() {
    //         return Err(reply.error_message.into());
    //     }
    //     Ok(reply.result_text)
    // }
    ```
-   **Data Structures:** Defined as Protobuf messages. These are compiled into native structs/classes in each language.
-   **Error Handling:** gRPC status codes and error messages. Custom error details can be included in response messages or using `google.rpc.Status`.
-   **Transport:** Typically TCP/IP. For local IPC, Unix Domain Sockets (UDS) can be used with gRPC for better performance and security on Unix-like systems.

### 2.3. Inter-Process Communication (IPC) - Local REST/HTTP

An alternative to gRPC for separate processes, though generally less performant for local IPC.

-   **Protocol:** Standard HTTP/S.
-   **Benefits:** Simpler to implement if teams are more familiar with REST than gRPC.
-   **Drawbacks:** Higher overhead than gRPC for local communication. Less strict contract enforcement than Protobuf.
-   **Implementation:** Similar to how the Rust middleware communicates with backend APIs (see `rust_middleware_communication_protocols.md`, Section 2), but the server is the local Engine Adapter process.

## 3. Choosing the Right Protocol

-   **Engine Adapter in Rust:** Prefer **direct linking (Rust crate dependency)**.
-   **Engine Adapter in C/C++ (or Rust with C API):** Prefer **FFI**.
-   **Engine Adapter in Python or other language (separate process):** Prefer **gRPC**. Use local REST as a fallback if gRPC is too complex for the specific need.

The `Engines API` OpenAPI specification defines a generic way to invoke engines (`/engines/{engine_id}/invoke` with `EngineInvocationRequest` and `EngineInvocationResponse`). The Rust middleware will receive these generic requests. It's the middleware's responsibility, possibly in conjunction with the `engine_manager` component, to:

1.  Identify the target engine adapter.
2.  Determine the communication protocol for that adapter.
3.  Transform the generic `EngineInvocationRequest` into the specific format required by the adapter (e.g., specific struct for FFI, specific gRPC message).
4.  Invoke the adapter using the chosen protocol.
5.  Transform the adapter's response back into the generic `EngineInvocationResponse` to be sent back through the Engines API (if the middleware is proxying) or directly to the Flutter UI.

This provides a flexible system where the core API for engine invocation remains consistent, while the actual communication mechanism with each engine can be tailored for performance and language compatibility.
