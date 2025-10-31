# Odin Programming Language Setup for NixOS

This document describes the Odin setup in your NixOS configuration, including all vendor library support.

## Setup Overview

Odin is configured in `/etc/nixos/modules/packages/odin.nix` with a wrapped compiler that automatically provides all necessary library paths for vendor packages.

## What's Included

### Odin Compiler
- **Package**: `odinWrapped` - A wrapped version of the Odin compiler with pre-configured library paths
- **Version**: dev-2025-10 (from nixpkgs unstable)

### Supported Vendor Libraries

All of Odin's built-in `vendor:` packages are supported with the following system libraries:

#### Graphics & Window Management
- **raylib** → `vendor:raylib` - Popular game/graphics library
- **GLFW** → `vendor:glfw` - OpenGL window/context library  
- **SDL2** → `vendor:sdl2` - Cross-platform multimedia library
- **SDL3** → `vendor:sdl3` - Next-generation SDL

#### Graphics APIs
- **OpenGL** → `vendor:OpenGL` - OpenGL library
- **Vulkan** → `vendor:vulkan` - Vulkan API with headers and loader

#### Display Protocols
- **Wayland** → Wayland display server support
- **X11** → `vendor:x11` with full support (libX11, libXcursor, libXrandr, libXi, libXinerama)

#### Audio & Other Libraries
- **PortMIDI** → `vendor:portmidi` - MIDI I/O library
- **Lua** → `vendor:lua` - Lua scripting language bindings
- **Zlib** → `vendor:zlib` - Compression library
- **ALSA** - Audio support for SDL/raylib

#### Development Tools
- **Clang** - C compiler backend (Odin uses LLVM/Clang)
- **LLDB** - LLVM debugger
- **GDB** - GNU debugger

## How It Works

The configuration uses a `symlinkJoin` wrapper that:

1. Wraps the Odin compiler executable
2. Sets `LD_LIBRARY_PATH` to include all vendor library paths
3. Sets `LIBRARY_PATH` for compile-time library discovery

This means you can simply run:

```bash
odin build myproject.odin -file
```

And all vendor libraries will be automatically found during compilation and linking.

## Testing Vendor Support

### Raylib Example
```odin
package main

import rl "vendor:raylib"

main :: proc() {
    rl.InitWindow(800, 450, "Raylib Test")
    defer rl.CloseWindow()
    
    rl.SetTargetFPS(60)
    
    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        rl.ClearBackground(rl.RAYWHITE)
        rl.DrawText("Raylib + Odin works!", 190, 200, 20, rl.LIGHTGRAY)
        rl.EndDrawing()
    }
}
```

### SDL3 Example
```odin
package main

import sdl "vendor:sdl3"
import "core:fmt"

main :: proc() {
    if !sdl.Init({.VIDEO}) {
        fmt.println("Failed to initialize SDL3")
        return
    }
    defer sdl.Quit()
    
    fmt.println("SDL3 initialized successfully!")
}
```

### STB (Header-only) Example
```odin
package main

import "core:fmt"
import stb "vendor:stb/image"

main :: proc() {
    fmt.println("STB vendor imported successfully!")
}
```

## Vendor Packages Available

All of these are available in `/nix/store/.../share/vendor/`:

- box2d, cgltf, commonmark, compress
- darwin, directx
- egl, ENet
- fontstash
- ggpo, glfw
- kb_text_shape
- libc, lua
- microui, miniaudio
- nanovg
- OpenEXRCore, OpenGL
- portmidi
- raylib
- sdl2, sdl3, stb
- vulkan
- wasm, wgpu, windows
- x11
- zlib

## Building Projects

### Simple file
```bash
odin build myfile.odin -file
```

### Project directory
```bash
odin build .
```

### With debug info
```bash
odin build . -debug
```

### Run directly
```bash
odin run .
```

## Notes

- The wrapped Odin compiler handles all library paths automatically
- No need to manually specify `-extra-linker-flags` for vendor libraries
- All libraries are from nixpkgs unstable channel
- SDL3 is available and working (version 3.2.22)
- Header-only vendor libraries (like STB) work out of the box

## Configuration File

Location: `/etc/nixos/modules/packages/odin.nix`

The configuration:
- Defines all required libraries in `odinLibs`
- Creates a wrapped Odin compiler with library paths
- Includes all necessary development tools
- Is imported in `configuration.nix`

## Troubleshooting

If you encounter library linking issues:

1. Check if the library is in the `odinLibs` list in `odin.nix`
2. Verify the package exists in nixpkgs: `nix search nixpkgs <package-name>`
3. After adding a new library, rebuild: `sudo nixos-rebuild switch`

## Testing Your Setup

Run these commands to verify everything works:

```bash
# Check Odin version
odin version

# Check Odin root (where vendors are)
odin root

# List available vendors
ls $(odin root)/vendor/

# Build a simple test
cd /tmp && echo 'package main; import "core:fmt"; main :: proc() { fmt.println("Works!") }' > test.odin
odin build test.odin -file && ./test
```

All vendor libraries should compile and link without any manual configuration!
