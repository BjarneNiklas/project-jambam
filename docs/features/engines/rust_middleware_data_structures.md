# Rust Middleware Data Structures

This document describes how data structures are defined and managed within the Rust middleware, ensuring consistency with the OpenAPI specifications and facilitating communication between different components.

## 1. Core Principle: OpenAPI as the Source of Truth

The OpenAPI specifications defined for each backend service (Core, Engines, Mindflow, GameJam, Data, Plugins) are the **single source of truth** for the request and response payloads exchanged between the Rust middleware and these services.

Rust data structures (structs and enums) that represent these payloads will be directly derived from or manually created to precisely match the schemas in the OpenAPI YAML files.

## 2. Rust Structs for API Communication

-   **Derivation:**
    -   Ideally, tools like `openapi-generator` (with Rust templates such as `rust-server` or `rust`) or community tools like `oats` can be used to automatically generate Rust types (structs, enums) from the OpenAPI specifications. This minimizes manual effort and ensures synchronization.
    -   If auto-generation is not perfectly suitable or requires customization, Rust structs will be manually defined.
-   **Serialization/Deserialization:**
    -   The `serde` framework (with `serde_json` for JSON payloads) is the standard for serializing Rust structs into JSON for HTTP request bodies and deserializing JSON from HTTP responses back into Rust structs.
    -   All such structs will derive `serde::Serialize` and `serde::Deserialize`.
-   **Naming Conventions:** Rust struct and field names should follow Rust's idiomatic `snake_case` convention. `serde` provides attributes (`#[serde(rename_all = "camelCase")]`, `#[serde(rename = "actualFieldName")]`) to map these to `camelCase` or other conventions used in the JSON APIs if they differ. The OpenAPI specs generally use `camelCase` or `snake_case` for properties. Consistency with the OpenAPI definition is key.
-   **Optional Fields & Nullability:** OpenAPI's `nullable: true` and non-`required` fields translate to `Option<T>` in Rust structs. `serde` handles this mapping gracefully.
-   **Data Types:** OpenAPI data types will be mapped to their corresponding Rust equivalents:
    -   `string` -> `String`
    -   `string` with `format: uuid` -> `String` (or a dedicated UUID type like `uuid::Uuid`)
    -   `string` with `format: date-time` -> `String` (or `chrono::DateTime<chrono::Utc>`)
    -   `integer`, `number` -> `i32`, `i64`, `f32`, `f64` (choose based on expected range and precision)
    -   `boolean` -> `bool`
    -   `array` -> `Vec<T>`
    -   `object` (with defined properties) -> A corresponding Rust struct
    -   `object` (with `additionalProperties: true`) -> `std::collections::HashMap<String, serde_json::Value>` or a custom struct with a catch-all field.

### Example: Mapping OpenAPI Schema to Rust Struct

**OpenAPI Schema (from `core_api.yaml` - `CoreStatus`):**

```yaml
# components:
#   schemas:
#     CoreStatus:
#       type: object
#       properties:
#         status:
#           type: string
#           example: "Core API is operational"
#         timestamp:
#           type: string
#           format: date-time
#           example: "2024-01-01T12:00:00Z"
#         version:
#           type: string
#           example: "0.1.0"
#         uptime:
#           type: integer 
#           example: 3600
```

**Corresponding Rust Struct:**

```rust
use serde::{Deserialize, Serialize};
// Potentially use chrono for actual date/time parsing if needed beyond string representation
// use chrono::{DateTime, Utc};

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct CoreStatus {
    pub status: String,
    // #[serde(with = "chrono::serde::ts_seconds_option")] // Example if using chrono DateTime
    pub timestamp: String, // Or DateTime<Utc> if parsed
    pub version: String,
    pub uptime: i64,
}
```
*(Note: If specific OpenAPI field names differ from Rust struct field names, `#[serde(rename = "openapiFieldName")]` would be used.)*

## 3. Data Structures for FFI (Flutter <-> Rust)

-   **Tooling Influence:** The choice of FFI tooling (e.g., `flutter_rust_bridge`) heavily influences how data structures are defined and shared.
    -   `flutter_rust_bridge` allows using native Rust structs directly in many cases, as it handles the conversion to Dart types.
-   **Serialization:** For complex types not directly mappable by the FFI tool, or when using `cbindgen`, data is often serialized to JSON (using `serde_json`) or Protobuf and passed as a `String` or `Vec<u8>`/`Uint8List`. The receiving side then deserializes it.
-   **Simplicity:** Keep data structures exchanged over FFI as simple as possible. If a complex Rust internal struct is needed, create a simpler, FFI-friendly version (a Data Transfer Object or DTO) for the boundary.
-   **Consistency:** Where possible, these FFI DTOs should still align with or be derived from the concepts in the OpenAPI specifications, especially if the FFI call triggers further API requests.

### Example: FFI Data Structure

If an FFI function needs to return a simplified version of `CoreStatus`:

```rust
// Rust side (for FFI, potentially simplified)
#[derive(Serialize, Deserialize, Debug, Clone)] // Serde still useful if passing as JSON string
pub struct FfiCoreStatus {
    pub is_operational: bool,
    pub version: String,
}

// This struct might be directly usable by flutter_rust_bridge
// Or, it would be serialized to JSON if using a manual FFI setup:
// let ffi_status = FfiCoreStatus { is_operational: true, version: "0.1.0".to_string() };
// let json_string = serde_json::to_string(&ffi_status).unwrap();
// pass_string_over_ffi(json_string);
```

## 4. Data Structures for Engine Adapters

-   **gRPC/Protobuf:** If gRPC is used to communicate with engine adapters, data structures are defined using Protocol Buffers (`.proto` files). `tonic-build` in Rust can compile these into Rust structs.
-   **FFI (Direct Linking):** If adapters are Rust crates or C/C++ libraries, data structures are native Rust or C structs. Ensure compatibility (e.g., `#[repr(C)]` for structs shared with C).
-   **Alignment with Engine Capabilities:** The data structures for engine adapters should accurately reflect the input parameters and output results of the specific capabilities of each engine, as defined in the `Engines API` (e.g., `EngineInvocationRequest`, `EngineInvocationResponse`). The middleware might adapt these generic structures to more specific ones required by the adapter.

## 5. Internal Middleware Data Structures

-   The middleware will have its own internal data structures for managing state, configuration, and intermediate data during request processing.
-   These are not directly dictated by external APIs but should be designed for clarity, efficiency, and maintainability.
-   Where they represent data that will eventually be sent to or received from an external API, they should be easily convertible to/from the API-specific structs.

## 6. Error Structures

-   **API Errors:** The standard `Error` schema from the OpenAPI specifications (`{ code: integer, message: string }`) will be the basis for error responses from the backend APIs. The Rust middleware will deserialize these into a common Rust error struct.
-   **FFI Errors:** Errors passed over FFI to Flutter should also be structured (e.g., an error code and a message) and ideally allow for easy translation into Dart exceptions. `flutter_rust_bridge` provides mechanisms for this.
-   **Internal Errors:** Rust's `Result<T, E>` and custom error enums (possibly using libraries like `thiserror` or `anyhow`) will be used for internal error handling. These internal errors will be mapped to the appropriate API or FFI error structures when crossing boundaries.

By adhering to these principles, the Rust middleware can maintain data consistency across the ecosystem, leverage strong typing, and benefit from the clarity of the OpenAPI specifications.
