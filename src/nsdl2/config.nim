##  SDL2 config.
#[
  SPDX-License-Identifier: NCSA OR MIT OR Zlib
]#

{.push raises: [].}

const
  ndoc = defined nimdoc

const
  use_audio*          {.booldefine: "sdl2.audio".}          = true or ndoc
    ##  Include audio functions.
  use_blendmode*      {.booldefine: "sdl2.blendmode".}      = true or ndoc
    ##  Include blend mode functions.
  use_clipboard*      {.booldefine: "sdl2.clipboard".}      = true or ndoc
    ##  Include clipboard functions.
  use_gamecontroller* {.booldefine: "sdl2.gamecontroller".} = true or ndoc
    ##  Include game controller functions.
  use_gesture*        {.booldefine: "sdl2.gesture".}        = true or ndoc
    ##  Include gesture functions.
  use_haptic*         {.booldefine: "sdl2.haptic".}         = true or ndoc
    ##  Include haptic functions.
  use_hints*          {.booldefine: "sdl2.hints".}          = true or ndoc
    ##  Include hints functions.
  use_joystick*       {.booldefine: "sdl2.joystick".}       = true or ndoc
    ##  Include joystick functions.
  use_keyboard*       {.booldefine: "sdl2.keyboard".}       = true or ndoc
    ##  Include keyboard functions.
  use_messagebox*     {.booldefine: "sdl2.messagebox".}     = true or ndoc
    ##  Include message box functions.
  use_mouse*          {.booldefine: "sdl2.mouse".}          = true or ndoc
    ##  Include mouse functions.
  use_sensor*         {.booldefine: "sdl2.sensor".}         = true or ndoc
    ##  Include sensor functions.
  use_shape*          {.booldefine: "sdl2.shape".}          = true or ndoc
    ##  Include shape functions.
  use_touch*          {.booldefine: "sdl2.touch".}          = true or ndoc
    ##  Include touch functions.

# vim: set sts=2 et sw=2:
