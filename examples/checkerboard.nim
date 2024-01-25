##  Checkerboard.
#[
  SPDX-License-Identifier: NCSA
]#

{.push raises: [].}

when NimMajor >= 2 or defined nimPreviewSlimSystem:
  import std/assertions

import nsdl2

const
  win_width   = 800
  win_height  = 600

proc draw_checkerboard(texture: Texture) =
  ##  Draw checkerboard on the texture.
  var format: uint32
  var access, width, height: int
  assert QueryTexture(texture, format, access, width, height)

  var buf = newSeqUninitialized[byte](width * height * uint32.sizeof)

  const components = [0x99'u8, 0x66'u8]

  var pos = 0
  for y in 0 ..< height:
    for x in 0 ..< width:
      let comp = components[((x xor y) div 8) and 1]
      buf[pos + 0] = comp
      buf[pos + 1] = comp
      buf[pos + 2] = comp
      buf[pos + 3] = comp
      pos += 4

  let pitch = width * uint32.sizeof
  assert UpdateTexture(texture, buf[0].addr, pitch)

proc mainloop() =
  # Create the window.
  let win = CreateWindow("Checkerboard", WINDOWPOS_CENTERED,
                         WINDOWPOS_CENTERED, win_width, win_height)
  if win == nil:
    echo "Failed to create window: ", GetError()
    quit QuitFailure
  defer:
    DestroyWindow win

  # Create the window renderer.
  let renderer = CreateRenderer win
  if renderer == nil:
    echo "Failed to create renderer: ", GetError()
    quit QuitFailure
  defer:
    DestroyRenderer renderer

  # Create the texture.
  let texture = CreateTexture(renderer, PIXELFORMAT_RGBA8888,
                              TEXTUREACCESS_STATIC, 640, 480)
  if texture == nil:
    echo "Failed to create texture: ", GetError()
    quit QuitFailure
  defer:
    DestroyTexture texture

  # Draw the checkerboard on the texture.
  draw_checkerboard texture

  # Update the window.
  assert RenderClear renderer
  assert RenderCopy(renderer, texture)
  RenderPresent renderer

  # Event loop.
  var event: Event
  while true:
    while PollEvent event:
      case event.typ
      of EVENT_KEYDOWN:
        if event.key.keysym.sym in [SDLK_ESCAPE, SDLK_q]:
          return
      of EVENT_QUIT:
        return
      else:
        discard

    Delay 50

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

  mainloop()

when isMainModule:
  main()

# vim: set sts=2 et sw=2:
