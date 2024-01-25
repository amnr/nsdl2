##  Joystick event definitions.
#[
  SPDX-License-Identifier: NCSA OR MIT OR Zlib
]#

{.push raises: [].}

type
  Joystick* = ptr object
    ##  Joystick.

  JoystickGUID* {.final, pure.} = object
    ##  Joystick GUID.
    data*:  array[16, byte]

  JoystickID* = distinct int32
    ##  Joystick unique ID.
    ##
    ##  The ID starts at 0. Invalid ID has value -1.

func `==`*(a: JoystickID, b: int32): bool {.borrow.}

type
  JoystickType* {.size: cint.sizeof.} = enum
    JOYSTICK_TYPE_UNKNOWN
    JOYSTICK_TYPE_GAMECONTROLLER
    JOYSTICK_TYPE_WHEEL
    JOYSTICK_TYPE_ARCADE_STICK
    JOYSTICK_TYPE_FLIGHT_STICK
    JOYSTICK_TYPE_DANCE_PAD
    JOYSTICK_TYPE_GUITAR
    JOYSTICK_TYPE_DRUM_KIT
    JOYSTICK_TYPE_ARCADE_PAD
    JOYSTICK_TYPE_THROTTLE

  JoystickPowerLevel* {.size: cint.sizeof.} = enum
    JOYSTICK_POWER_UNKNOWN = -1
    JOYSTICK_POWER_EMPTY    ##  <= 5%.
    JOYSTICK_POWER_LOW      ##  <= 20%.
    JOYSTICK_POWER_MEDIUM   ##  <= 70%.
    JOYSTICK_POWER_FULL     ##  <= 100%.
    JOYSTICK_POWER_WIRED
    JOYSTICK_POWER_MAX

const
  IPHONE_MAX_GFORCE*  = cfloat 5.0
  JOYSTICK_AXIS_MAX*  = 32767
  JOYSTICK_AXIS_MIN*  = -32768

type
  Hat* = distinct byte
    ##  Hat positions.

func `==`*(a, b: Hat): bool {.borrow.}
func `and`*(a, b: Hat): Hat {.borrow.}
func `or`(a, b: Hat): Hat {.borrow.}

const
  HAT_CENTERED*   = Hat 0x00
  HAT_UP*         = Hat 0x01
  HAT_RIGHT*      = Hat 0x02
  HAT_DOWN*       = Hat 0x04
  HAT_LEFT*       = Hat 0x08
  HAT_RIGHTUP*    = HAT_RIGHT or HAT_UP
  HAT_RIGHTDOWN*  = HAT_RIGHT or HAT_DOWN
  HAT_LEFTUP*     = HAT_LEFT or HAT_UP
  HAT_LEFTDOWN*   = HAT_LEFT or HAT_DOWN

# vim: set sts=2 et sw=2:
