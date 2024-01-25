##  Draw random lines.
#[
  SPDX-License-Identifier: NCSA
]#

{.push raises: [].}

when NimMajor >= 2 or defined nimPreviewSlimSystem:
  import std/assertions
import std/random

import nsdl2

const
  WindowTitle = "Random Lines"
  Width       = 320     # Texture width.
  Height      = 240     # Texture height.
  Scale       = 3       # Window pixel scale.
  MaxLines    = 200
  DrawDelay   = 10

proc loop(renderer: Renderer, texture: Texture) =
  var
    event: Event
    cnt = 0

  # Randomize RNG for the loop.
  randomize()

  assert RenderClear renderer

  while true:
    while PollEvent event:
      case event.typ
      of EVENT_KEYDOWN:
        case event.key.keysym.sym
        of SDLK_ESCAPE, SDLK_q:
          return
        of SDLK_SPACE:
          assert SetRenderDrawColor(renderer, 0x00, 0x00, 0x00)
          assert RenderClear renderer
        else:
          discard
      of EVENT_QUIT:
        return
      else:
        discard

    if cnt < MaxLines:
      # Set random pixel with random color.
      let
        x1 = rand Scale * Width - 1
        y1 = rand Scale * Height - 1
        x2 = rand Scale * Width - 1
        y2 = rand Scale * Height - 1
        color = rand 0x00ffffff

      assert SetRenderDrawColor(renderer, byte (color shr 16) and 0xff,
                                byte (color shr 8) and 0xff,
                                byte color and 0xff)
      assert RenderDrawLine(renderer, x1, y1, x2, y2)
      inc cnt
    else:
      # Clear the pixmap if max number of pixels were drawn.
      assert SetRenderDrawColor(renderer, 0x00, 0x00, 0x00)
      assert RenderClear renderer
      cnt = 0

    # Render the texture.
    #discard renderer.render_clear
    #discard renderer.render_copy texture
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

  echo "Press <space> to clear the window."
  echo "Press <q> or <escape> to exit."

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
