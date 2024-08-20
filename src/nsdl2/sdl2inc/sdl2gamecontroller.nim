##  Game controller event definitions.
##
#[
  SPDX-License-Identifier: NCSA OR MIT OR Zlib
]#

{.push raises: [].}

type
  GameController {.final, incompletestruct, pure.} = object
    ##  Game controller.

  GameControllerPtr* = ptr GameController
    ##  Game controller.

  GameControllerType* {.size: cint.sizeof.} = enum
    CONTROLLER_TYPE_UNKNOWN     = 0
    CONTROLLER_TYPE_XBOX360
    CONTROLLER_TYPE_XBOXONE
    CONTROLLER_TYPE_PS3
    CONTROLLER_TYPE_PS4
    CONTROLLER_TYPE_NINTENDO_SWITCH_PRO
    CONTROLLER_TYPE_VIRTUAL
    CONTROLLER_TYPE_PS5
    CONTROLLER_TYPE_AMAZON_LUNA
    CONTROLLER_TYPE_GOOGLE_STADIA
    CONTROLLER_TYPE_NVIDIA_SHIELD
    CONTROLLER_TYPE_NINTENDO_SWITCH_JOYCON_LEFT
    CONTROLLER_TYPE_NINTENDO_SWITCH_JOYCON_RIGHT
    CONTROLLER_TYPE_NINTENDO_SWITCH_JOYCON_PAIR

  GameControllerBindType* {.size: cint.sizeof.} = enum
    CONTROLLER_BINDTYPE_NONE    = 0
    CONTROLLER_BINDTYPE_BUTTON
    CONTROLLER_BINDTYPE_AXIS
    CONTROLLER_BINDTYPE_HAT

type
  GameControllerButtonBind* {.final, pure.} = object
    ##  Joystick binding for button/axis mapping.
    bind_type*  : GameControllerBindType
    value*      : GameControllerButtonBindValueUnion

  GameControllerButtonBindValueUnion {.final, pure, union.} = object
    button*     : cint
    axis*       : cint
    hat*        : GameControllerButtonBindHatStruct

  GameControllerButtonBindHatStruct {.final, pure.} = object
    hat*        : cint
    hat_mask*   : cint

type
  GameControllerAxis* {.size: cint.sizeof.} = enum
    ##  Game controller axis.
    CONTROLLER_AXIS_INVALID = -1
    CONTROLLER_AXIS_LEFTX
    CONTROLLER_AXIS_LEFTY
    CONTROLLER_AXIS_RIGHTX
    CONTROLLER_AXIS_RIGHTY
    CONTROLLER_AXIS_TRIGGERLEFT
    CONTROLLER_AXIS_TRIGGERRIGHT

const
  CONTROLLER_AXIS_MAX* = GameControllerAxis.high.int + 1

type
  GameControllerButton* {.size: cint.sizeof.} = enum
    CONTROLLER_BUTTON_INVALID = -1
    CONTROLLER_BUTTON_A
    CONTROLLER_BUTTON_B
    CONTROLLER_BUTTON_X
    CONTROLLER_BUTTON_Y
    CONTROLLER_BUTTON_BACK
    CONTROLLER_BUTTON_GUIDE
    CONTROLLER_BUTTON_START
    CONTROLLER_BUTTON_LEFTSTICK
    CONTROLLER_BUTTON_RIGHTSTICK
    CONTROLLER_BUTTON_LEFTSHOULDER
    CONTROLLER_BUTTON_RIGHTSHOULDER
    CONTROLLER_BUTTON_DPAD_UP
    CONTROLLER_BUTTON_DPAD_DOWN
    CONTROLLER_BUTTON_DPAD_LEFT
    CONTROLLER_BUTTON_DPAD_RIGHT
    CONTROLLER_BUTTON_MISC1       ##  Xbox Series X share button,
                                  ##  PS5 microphone button,
                                  ##  Nintendo Switch Pro capture button, etc.
    CONTROLLER_BUTTON_PADDLE1     ##  Xbox Elite paddle P1.
    CONTROLLER_BUTTON_PADDLE2     ##  Xbox Elite paddle P3.
    CONTROLLER_BUTTON_PADDLE3     ##  Xbox Elite paddle P2.
    CONTROLLER_BUTTON_PADDLE4     ##  Xbox Elite paddle P4.
    CONTROLLER_BUTTON_TOUCHPAD    ##  PS4/PS5 touchpad button.

const
  CONTROLLER_BUTTON_MAX* = GameControllerButton.high.int + 1

# vim: set sts=2 et sw=2:
