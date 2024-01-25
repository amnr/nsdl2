##  Draw random rectangles.
#[
  SPDX-License-Identifier: NCSA
]#

{.push raises: [].}

when NimMajor >= 2 or defined nimPreviewSlimSystem:
  import std/assertions
import std/random

import nsdl2

const
  WindowTitle = "Random Rectangles"
  Width       = 320     # Texture width.
  Height      = 240     # Texture height.
  Scale       = 3       # Window pixel scale.
  MaxRects    = 200
  DrawDelay   = 10

proc loop(renderer: Renderer, texture: Texture) =
  var
    event: Event
    cnt = 0
    fill_mode = false
    force_clear = false

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
          fill_mode = not fill_mode
          force_clear = true
        else:
          discard
      of EVENT_QUIT:
        return
      else:
        discard

    if cnt >= MaxRects:
      fill_mode = not fill_mode
      force_clear = true
      cnt = 0

    if force_clear:
      assert SetRenderDrawColor(renderer, 0x00, 0x00, 0x00)
      assert RenderClear renderer
      force_clear = false

    # Set random pixel with random color.
    let
      x1 = rand Scale * Width - 1
      y1 = rand Scale * Height - 1
      x2 = rand Scale * Width - 1
      y2 = rand Scale * Height - 1
      color = rand 0x00ffffff

    let
      x = min(x1, x2)
      y = min(y1, y2)
      w = max(x1, x2) - x
      h = max(y1, y2) - y

    let
      r = byte (color shr 16) and 0xff
      g = byte (color shr 8) and 0xff
      b = byte color and 0xff

    assert SetRenderDrawColor(renderer, r, g, b)
    if fill_mode:
      assert RenderFillRect(renderer, x, y, w, h)
    else:
      assert RenderDrawRect(renderer, x, y, w, h)
    inc cnt

    # Render the texture.
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
