# Rust-Flutter FFI Communication

This document details the Foreign Function Interface (FFI) strategy for communication between the Rust middleware and the Flutter UI.

## 1. Recommended Tooling: `flutter_rust_bridge`

For robust and developer-friendly FFI, [`flutter_rust_bridge`](https://github.com/fzyzcjy/flutter_rust_bridge) is the recommended tool.

-   **Benefits:**
    -   **Automatic Code Generation:** Generates Dart FFI bindings from Rust function signatures and Rust code for the bridge.
    -   **Type Safety:** Supports a wide range of Rust and Dart types, including structs, enums, `Option`, `Result`, `Vec`, `HashMap`, etc.
    -   **Asynchronous Support:** Natively handles `async` Rust functions, returning `Future`s in Dart, and supports `Stream`s for continuous data flow.
    -   **Error Handling:** Translates Rust `Result::Err` into Dart exceptions.
    -   **Reduced Boilerplate:** Significantly less manual FFI code is required compared to `cbindgen` + `dart:ffi`.
    -   **Cross-Platform:** Works for mobile (iOS, Android) and desktop (Windows, macOS, Linux) Flutter targets.

-   **Workflow:**
    1.  Define Rust functions and data structures intended for FFI.
    2.  Annotate them as needed for `flutter_rust_bridge`.
    3.  Run the `flutter_rust_bridge_codegen` tool.
    4.  The generated Dart code is used directly in the Flutter application.
    5.  The generated Rust bridge code is included in the Rust middleware crate.

## 2. Alternative: `cbindgen` and `dart:ffi`

If `flutter_rust_bridge` is not suitable for a specific use case, or if a lower-level approach is preferred:

-   **`cbindgen`:** Used in the Rust project to generate C header files (`.h`) from the Rust FFI functions.
    -   Rust functions must be marked `extern "C"` and use C-compatible types.
-   **`dart:ffi`:** Used in the Flutter (Dart) project to load the compiled Rust library (e.g., `.so`, `.dll`, `.dylib`) and call the C functions defined in the generated header.

-   **Challenges with this approach:**
    -   **Manual Type Conversions:** Complex types (structs, strings, collections) must be manually converted to C pointers and reconstructed on the other side. This is error-prone.
    -   **String Handling:** Requires careful management of C strings (`*const c_char`, `CString`).
    -   **Error Handling:** Typically involves returning error codes from C functions and manually translating them to Dart exceptions.
    -   **Asynchronous Operations:** More complex to implement; often requires manual setup of ports (`IsolateNameServer`, `SendPort`, `ReceivePort`) for callbacks.
    -   **Boilerplate:** Significant boilerplate code is needed on both Rust and Dart sides.

## 3. Data Structures over FFI

-   **Using `flutter_rust_bridge`:**
    -   Many Rust structs and enums can be used directly. The tool handles their conversion to equivalent Dart classes.
    -   For example, a Rust `struct MyData { field: String, value: i32 }` can be mirrored as a Dart class `class MyData { final String field; final int value; ... }`.
-   **Using `cbindgen` / `dart:ffi`:**
    -   **Primitives:** `i32`, `f64`, `bool` can be passed directly.
    -   **Structs:** Must be `#[repr(C)]` in Rust. Dart side uses `Struct` from `dart:ffi`. Pointers are used for passing.
    -   **Strings:** Pass as `*const c_char` from Rust (created with `CString::new(rust_string).unwrap().into_raw()`). Dart receives `Pointer<Utf8>` and converts to `String`. Memory management is crucial (Rust must provide a function to free the string).
    -   **Byte Arrays (`Vec<u8>`):** Pass as `*const u8` and a `len`. Dart receives `Pointer<Uint8>` and creates a `Uint8List`.
    -   **JSON Strings:** A common pattern is to serialize complex Rust structs to a JSON string (`serde_json::to_string`), pass the string over FFI, and deserialize it in Dart (`jsonDecode`). This simplifies complex data transfer but adds serialization overhead.

## 4. Function Signatures

-   **Using `flutter_rust_bridge`:**
    ```rust
    // Rust function exposed to Flutter
    pub fn get_item_details(id: u32) -> Result<Option<ItemDetails>, anyhow::Error> {
        // ... logic ...
    }

    pub struct ItemDetails { pub name: String, pub price: f32 }
    ```
    `flutter_rust_bridge` generates the corresponding Dart function:
    ```dart
    Future<ItemDetails?> getItemDetails({required int id});
    class ItemDetails { final String name; final double price; ... }
    ```

-   **Using `cbindgen` / `dart:ffi`:**
    ```rust
    // Rust FFI function
    #[no_mangle]
    pub extern "C" fn get_item_name(id: u32, name_buf: *mut *mut c_char) -> i32 {
        // ... logic to get name ...
        // If successful:
        // let name_str = CString::new(item_name).unwrap();
        // unsafe { *name_buf = name_str.into_raw(); }
        // return 0; // Success code
        // If error:
        // return -1; // Error code
        unimplemented!();
    }

    #[no_mangle]
    pub extern "C" fn free_string(s: *mut c_char) {
        unsafe {
            if s.is_null() { return; }
            CString::from_raw(s)
        };
    }
    ```
    Dart side would involve loading the library, looking up symbols, and careful pointer/memory management.

## 5. Asynchronous Operations

-   **`flutter_rust_bridge`:** Handles `async fn` in Rust seamlessly, returning a `Future` in Dart. For streams of data, Rust functions can return a `Stream<T>` which translates to a Dart `Stream<T>`.
    ```rust
    // Rust
    pub async fn long_running_task(input: String) -> String {
        // ...
        input
    }

    pub fn continuous_data_stream() -> impl Stream<Item = i32> {
        // ... tokio::sync::mpsc::channel or similar ...
        unimplemented!();
    }
    ```
-   **`cbindgen` / `dart:ffi`:** Requires manual setup using Dart `Isolate`s and `ReceivePort`/`SendPort` for Rust to call back into Dart. Rust would typically be given a `SendPort` (as an `i64`) to send data back. This is significantly more complex.

## 6. Error Handling

-   **`flutter_rust_bridge`:** Rust `Result<T, E>` where `E: Error` is automatically translated into a Dart exception. Custom error types can be defined in Rust and mirrored in Dart.
    ```rust
    // Rust
    pub enum MyError { Timeout, ItemNotFound(String) }
    pub fn get_data() -> Result<String, MyError> {
        Err(MyError::ItemNotFound("example".to_string()))
    }
    ```
    Dart code can `try-catch` these specific errors.
-   **`cbindgen` / `dart:ffi`:** C functions typically return error codes (e.g., 0 for success, non-zero for error). Detailed error information might be passed via an out-parameter (a pointer to a struct to be filled with error details) or a global "get last error" function. Dart code must check return codes and manually throw exceptions.

## 7. Build Integration

-   The Rust middleware will be compiled as a dynamic or static library (e.g., `.so` for Android/Linux, `.dylib` for macOS/iOS, `.dll` for Windows).
-   **Flutter Build Process:** The Flutter build process (`flutter build ...`) needs to be configured to:
    1.  Trigger the Rust build (e.g., via a build script).
    2.  Bundle the compiled Rust library into the final Flutter application package.
    -   For mobile: Placed in `android/app/src/main/jniLibs` (Android) and linked in Xcode (iOS).
    -   For desktop: Placed alongside the executable or in a known library path.
-   `flutter_rust_bridge` provides documentation and examples for this integration.

## 8. Threading Model

-   Rust FFI calls from Dart typically run on a separate thread pool managed by the Rust async runtime (e.g., Tokio) or on dedicated threads if blocking FFI calls are made.
-   Care must be taken not to block the main Dart UI thread. Asynchronous FFI calls are crucial for this.
-   `flutter_rust_bridge` handles the threading aspects for async functions gracefully.

By using `flutter_rust_bridge`, the complexity of Rust-Flutter FFI can be significantly reduced, allowing developers to focus on the application logic rather than the intricacies of inter-language communication.
