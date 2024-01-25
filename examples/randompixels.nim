##  Draw random pixels.
#[
  SPDX-License-Identifier: NCSA
]#

{.push raises: [].}

import std/random

import nsdl2

const
  WindowTitle = "Random Pixels"
  Width       = 320     # Texture width.
  Height      = 240     # Texture height.
  Scale       = 3       # Window pixel scale.
  MaxPixels   = 1000
  DrawDelay   = 10

proc loop(renderer: Renderer, texture: Texture) =
  var
    pixels: array[Width * Height, uint32]
    event: Event
    cnt = 0

  # Randomize RNG for the loop.
  randomize()

  while true:
    while PollEvent event:
      case event.typ
      of EVENT_KEYDOWN:
        case event.key.keysym.sym
        of SDLK_ESCAPE, SDLK_q:
          return
        else:
          discard
      of EVENT_QUIT:
        return
      else:
        discard

    if cnt < MaxPixels:
      # Set random pixel with random color.
      let
        x = rand Width - 1
        y = rand Height - 1
        color = rand 0x00ffffff

      pixels[Width * y + x] = uint32 color
      inc cnt
    else:
      # Clear the pixmap if max number of pixels were drawn.
      for i in 0 ..< pixels.len:
        pixels[i] = 0
      cnt = 0

    # Update the texture with new pixel data.
    discard UpdateTexture(texture, pixels[0].addr, Width * uint32.sizeof)

    # Render the texture.
    discard RenderClear renderer
    discard RenderCopy(renderer, texture)
    RenderPresent renderer

    Delay DrawDelay

proc main() =
  # Load library.
  if not open_sdl2_library():
    echo "Failed to load SDL 2.0 library: ", last_sdl2_error()
    quit QuitFailure
  defer:
    close_sdl2_library()

  # Initialize SDL.
  if not Init INIT_VIDEO:
    echo "Failed to initialize SDL 2.0: ", GetError()
    quit QuitFailure
  defer:
    Quit()

  # Create window.
  let win = CreateWindow(WindowTitle, WINDOWPOS_CENTERED, WINDOWPOS_CENTERED,
                         Scale * Width, Scale * Height)
  if win == nil:
    echo "Failed to create window: ", GetError()
    quit QuitFailure
  defer:
    DestroyWindow win

  # Create window renderer.
  let renderer = CreateRenderer win
  if renderer == nil:
    echo "Failed to create renderer: ", GetError()
    quit QuitFailure
  defer:
    DestroyRenderer renderer

  # Create renderer texture.
  let texture = CreateTexture(renderer, PIXELFORMAT_ARGB8888,
                              TEXTUREACCESS_STATIC, Width, Height)
  if texture == nil:
    echo "Failed to create texture: ", GetError()
    quit QuitFailure
  defer:
    DestroyTexture texture

  loop renderer, texture

when isMainModule:
  main()

# vim: set sts=2 et sw=2:
