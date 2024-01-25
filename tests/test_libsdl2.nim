##  Test SDL 2.0 ABI.
#[
  SPDX-License-Identifier: NCSA OR MIT OR Zlib
]#

{.push raises: [].}

import nsdl2/libsdl2
from nsdl2/sdl2inc/version import Version

proc main() =
  if not open_sdl2_library():
    echo "Failed to load SDL: ", last_sdl2_error()
    quit QuitFailure
  defer:
    close_sdl2_library()

  var ver: Version

  SDL_GetVersion ver.addr

  doAssert ver.major == 2

when isMainModule:
  main()

# vim: set sts=2 et sw=2:
