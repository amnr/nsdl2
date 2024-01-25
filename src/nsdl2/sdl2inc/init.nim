##  Init definitions.
#[
  SPDX-License-Identifier: NCSA OR MIT OR Zlib
]#

{.push raises: [].}

type
  SdlBool* = distinct cint

type
  InitFlags* = distinct uint32
    ##  Window flags.

func `and`*(a, b: InitFlags): InitFlags {.borrow.}
func `or`*(a, b: InitFlags): InitFlags {.borrow.}

func `==`*(a: InitFlags, b: uint32): bool {.borrow.}

const
  INIT_NONE*            = InitFlags 0x0000_0000   ##  Nim specific.
  INIT_TIMER*           = InitFlags 0x0000_0001
  INIT_AUDIO*           = InitFlags 0x0000_0010
  INIT_VIDEO*           = InitFlags 0x0000_0020   ##  Implies `INIT_EVENTS`_.
  INIT_JOYSTICK*        = InitFlags 0x0000_0200   ##  Implies `INIT_EVENTS`_.
  INIT_HAPTIC*          = InitFlags 0x0000_1000
  INIT_GAMECONTROLLER*  = InitFlags 0x0000_2000   ##  Implies `INIT_JOYSTICK`_.
  INIT_EVENTS*          = InitFlags 0x0000_4000
  INIT_SENSOR*          = InitFlags 0x0000_8000
  INIT_NOPARACHUTE*     = InitFlags 0x0010_0000   ##  Ignored.

const
  INIT_EVERYTHING* =
    INIT_TIMER or INIT_AUDIO or INIT_VIDEO or INIT_EVENTS or
    INIT_JOYSTICK or INIT_HAPTIC or INIT_GAMECONTROLLER or INIT_SENSOR

# vim: set sts=2 et sw=2:
