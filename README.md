# High level SDL 2.0 shared library wrapper for Nim

**nsdl2** is a high level **SDL 2.0** shared library wrapper for Nim.

## Features

- Tries to hide as many C types from the user as possible.
- Replaces generic C types with Nim distinct ones.
- Does not require **SDL 2.0** library headers during build process.
- The executable is not linked again a specific **SDL 2.0** library version.
- Loads **SDL 2.0** library only when you need it (via `dynlib` module).
- Single external dependency: [dlutils](https://github.com/amnr/dlutils).

> **_NOTE:_** Not everything is implemented yet.

> **_NOTE:_** This is a mirror of my local git repository.

## API

Original C `SDL_` prefix is dropped:

- `SDL_INIT_VIDEO` becomes `INIT_VIDEO`
- `SDL_GetTicks` becomes `GetTicks`
- etc.

Refer to the [documentation](https://amnr.github.io/nsdl2/) for the complete
list of changes.

## Installation

```sh
git clone https://github.com/amnr/nsdl2/
cd nsdl2
nimble install
```

## Configuration

You can disable functions you don't use.
All function groups are enabled by default.

| Group           | Define                  | Functions Defined In            |
| --------------- | ----------------------- | ------------------------------- |
| Audio           | `sdl2.audio=0`          | ``<SDL2/SDL_audio.h>``          |
| Blend Mode      | `sdl2.blendmode=0`      | ``<SDL2/SDL_blendmode.h>``      |
| Clipboard       | `sdl2.clipboard=0`      | ``<SDL2/SDL_clipboard.h>``      |
| Game Controller | `sdl2.gamecontroller=0` | ``<SDL2/SDL_gamecontroller.h>`` |
| Gesture         | `sdl2.gesture=0`        | ``<SDL2/SDL_gesture.h>``        |
| Haptic          | `sdl2.haptic=0`         | ``<SDL2/SDL_haptic.h>``         |
| Hints           | `sdl2.hints=0`          | ``<SDL2/SDL_hints.h>``          |
| Joystick        | `sdl2.joystick=0`       | ``<SDL2/SDL_joystick.h>``       |
| Keyboard        | `sdl2.keyboard=0`       | ``<SDL2/SDL_keyboard.h>``       |
| Mouse           | `sdl2.mouse=0`          | ``<SDL2/SDL_mouse.h>``          |
| Sensor          | `sdl2.sensor=0`         | ``<SDL2/SDL_sensor.h>``         |
| Shape           | `sdl2.shape=0`          | ``<SDL2/SDL_shape.h>``          |
| Touch           | `sdl2.touch=0`          | ``<SDL2/SDL_touch.h>``          |

For example if you don't need audio functions compile with:

```sh
nim c -d=sdl2.audio=0 file(s)
```

## Basic Usage

```nim
import nsdl2

proc main() =
  # Load all symbols from SDL2 shared library.
  # This must be the first proc called.
  if not open_sdl2_library():
    echo "Failed to load SDL2 library: ", last_sdl2_error()
    quit QuitFailure
  defer:
    close_sdl2_library()

  # Initialize the library.
  if not Init INIT_VIDEO:
    echo "Error initializing SDL2: ", GetError()
    quit QuitFailure
  defer:
    Quit()

  # Create the window.
  let window = CreateWindow("Test Window", 640, 480)
  if window == nil:
    echo "Error creating window: ", GetError()
    quit QuitFailure
  defer:
    DestroyWindow window

  # Create window renderer.
  let renderer = CreateRenderer window
  if renderer == nil:
    echo "Error creating renderer: ", GetError()
    quit QuitFailure
  defer:
    DestroyRenderer renderer

  # Clear the window.
  discard RenderClear renderer
  RenderPresent renderer

  # Basic event loop.
  var event: Event
  while true:
    while PollEvent event:
      case event.typ
      of EVENT_QUIT:
        return
      else:
       discard
    Delay 100

when isMainModule:
  main()
```

You can find more examples [here](examples/).

## Author

- [Amun](https://github.com/amnr/)

## License

`nsdl2` is released under:

- [**MIT**](LICENSE-MIT.txt) &mdash; Nim license
- [**NCSA**](LICENSE-NCSA.txt) &mdash; author's license of choice
- [**Zlib**](LICENSE-Zlib.txt) &mdash; SDL 2.0 license

Pick the one you prefer (or all).
