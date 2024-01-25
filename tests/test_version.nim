##  Test version.

{.push raises: [].}

import std/unittest

import nsdl2

test "get_version":
  check open_sdl2_library()
  defer:
    close_sdl2_library()

  check Init INIT_NONE
  defer:
    Quit()

  check GetVersion().major == 2

# vim: set sts=2 et sw=2:
