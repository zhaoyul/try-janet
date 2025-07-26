# Raylib C Examples Ported to Janet/Jaylib

This project contains ports of the original C examples from the [Raylib game library](https://github.com/raysan5/raylib/tree/master/examples) to the [Janet programming language](https://janet-lang.org/), using the [Jaylib](https://github.com/janet-lang/jaylib) bindings.

Each example is organized into its own independent project directory, containing all necessary source code and resources.

## How to Run an Example

To compile and run any of the examples, follow these steps:

1.  Navigate to the example's directory:
    ```sh
    cd <example_name>
    # e.g., cd core_basic_window
    ```

2.  Build the project using the Janet Package Manager (`jpm`):
    ```sh
    jpm build
    ```

3.  Run the compiled executable from the `build` directory:
    ```sh
    ./build/<example_name>
    # e.g., ./build/core_basic_window
    ```

## Migration Progress

### Completed Categories

- [x] **core**: Core functionalities, window management, and input handling.
- [x] **shapes**: Drawing basic 2D shapes.
- [x] **textures**: Loading and drawing 2D textures.
- [x] **text**: Font loading and text rendering.
- [x] **models**: Loading and drawing 3D models.
- [x] **shaders**: Using custom shaders for advanced effects.
- [x] **audio**: Loading and playing sounds and music.

### To-Do Categories

The following categories from the original Raylib examples are yet to be migrated:

- [ ] **extras**
- [ ] **network**
- [ ] **physics**
- [ ] **web**
