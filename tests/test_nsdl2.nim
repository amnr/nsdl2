##  Test nsdl2.
#[
  SPDX-License-Identifier: NCSA OR MIT OR Zlib
]#

{.push raises: [].}

include nsdl2

proc main() =
  if not open_sdl2_library():
    echo "Failed to load SDL 2.0 library: ", last_sdl2_error()
    quit QuitFailure
  defer:
    close_sdl2_library()

  let ver = GetVersion()

  doAssert ver.major == 2

when isMainModule:
  main()

# vim: set sts=2 et sw=2:
