##  Display information about all connected joysticks.
#[
  SPDX-License-Identifier: NCSA
]#

{.push raises: [].}

import std/strformat

import nsdl2

proc main() =
  # Load library.
  if not open_sdl2_library():
    echo "Failed to load SDL 2.0 library: ", last_sdl2_error()
    quit QuitFailure
  defer:
    close_sdl2_library()

  # Initialize SDL.
  if not Init INIT_JOYSTICK:
    echo "Failed to initialize SDL 2.0: ", GetError()
    quit QuitFailure
  defer:
    Quit()

  let num_joys = NumJoysticks()

  if num_joys < 0:
    echo "Error"
    quit QuitFailure

  if num_joys == 0:
    echo "No joysticks found."
    return

  for i in 0 ..< num_joys:
    echo "Joystick #", i, ':'
    let joy = JoystickOpen i
    if joy == nil:
      echo "Failed to open joystick #", i
      continue
    defer:
      JoystickClose joy

    let guid = JoystickGetGUIDString joy

    echo "  type . . : ", JoystickGetType joy
    echo "  name . . : ", JoystickName joy
    echo "  path . . : ", JoystickPath joy
    echo "  serial . : ", JoystickGetSerial joy
    echo "  GUID . . : ", JoystickGetGUIDString joy
    echo "  GUID . . : ", guid[0..7], '-', guid[8..11], '-', guid[12..15],
                          '-', guid[16..19], '-', guid[20..^1]
    try:
      echo &"  USB  . . : {JoystickGetVendor joy:04x}:{JoystickGetProduct joy:04x}"
    except ValueError:
      discard
    echo "  details  : ", JoystickNumAxes joy, " axes, ",
         JoystickNumBalls joy, " balls, ",
         JoystickNumButtons joy, " buttons, ",
         JoystickNumHats joy, " hats"
    echo "  features : LED: ", JoystickHasLED joy,
         " rumble: ", JoystickHasRumble joy,
         " rumble triggers: ", JoystickHasRumbleTriggers joy

when isMainModule:
  main()

# vim: set sts=2 et sw=2:
