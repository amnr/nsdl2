##  Event definitions.
##
#[
  SPDX-License-Identifier: NCSA OR MIT OR Zlib
]#

{.push raises: [].}

from sdl2audio import AudioDeviceID
from sdl2gesture import GestureID
from sdl2joystick import Hat, JoystickID
from sdl2keyboard import Keysym
from sdl2sensor import SensorID
from sdl2touch import FingerID, TouchID
from sdl2video import DisplayEventID, WindowEventID

# General keyboard/mouse state definitions.
const
  RELEASED* = 0
  PRESSED*  = 1

type
  EventType* {.size: uint32.sizeof.} = enum
    ##  Event types.
    EVENT_FIRSTEVENT                = 0

    # Application events.
    EVENT_QUIT                      = 0x100

    # iOS event types.
    EVENT_APP_TERMINATING
    EVENT_APP_LOWMEMORY
    EVENT_APP_WILLENTERBACKGROUND
    EVENT_APP_DIDENTERBACKGROUND
    EVENT_APP_WILLENTERFOREGROUND
    EVENT_APP_DIDENTERFOREGROUND
    EVENT_LOCALECHANGED

    # Display events.
    EVENT_DISPLAYEVENT              = 0x150

    # Window events.
    EVENT_WINDOWEVENT               = 0x200
    EVENT_SYSWMEVENT                = 0x201

    # Keyboard events.
    EVENT_KEYDOWN                   = 0x300
    EVENT_KEYUP                     = 0x301
    EVENT_TEXTEDITING               = 0x302
    EVENT_TEXTINPUT                 = 0x303
    EVENT_KEYMAPCHANGED             = 0x304
    EVENT_TEXTEDITING_EXT           = 0x305

    # Mouse events.
    EVENT_MOUSEMOTION               = 0x400
    EVENT_MOUSEBUTTONDOWN           = 0x401
    EVENT_MOUSEBUTTONUP             = 0x402
    EVENT_MOUSEWHEEL                = 0x403

    # Joystick events.
    EVENT_JOYAXISMOTION             = 0x600
    EVENT_JOYBALLMOTION             = 0x601
    EVENT_JOYHATMOTION              = 0x602
    EVENT_JOYBUTTONDOWN             = 0x603
    EVENT_JOYBUTTONUP               = 0x604
    EVENT_JOYDEVICEADDED            = 0x605
    EVENT_JOYDEVICEREMOVED          = 0x606
    EVENT_JOYBATTERYUPDATED         = 0x607

    # Game controller events.
    EVENT_CONTROLLERAXISMOTION      = 0x650
    EVENT_CONTROLLERBUTTONDOWN      = 0x651
    EVENT_CONTROLLERBUTTONUP        = 0x652
    EVENT_CONTROLLERDEVICEADDED     = 0x653
    EVENT_CONTROLLERDEVICEREMOVED   = 0x654
    EVENT_CONTROLLERDEVICEREMAPPED  = 0x655
    EVENT_CONTROLLERTOUCHPADDOWN    = 0x656
    EVENT_CONTROLLERTOUCHPADMOTION  = 0x657
    EVENT_CONTROLLERTOUCHPADUP      = 0x658
    EVENT_CONTROLLERSENSORUPDATE    = 0x659
    EVENT_CONTROLLERUPDATECOMPLETE_RESERVED_FOR_SDL3
    EVENT_CONTROLLERSTEAMHANDLEUPDATED

    # Touch events.
    EVENT_FINGERDOWN                = 0x700
    EVENT_FINGERUP                  = 0x701
    EVENT_FINGERMOTION              = 0x702

    # Gesture events.
    EVENT_DOLLARGESTURE             = 0x800
    EVENT_DOLLARRECORD
    EVENT_MULTIGESTURE

    # Clipboard events.
    EVENT_CLIPBOARDUPDATE           = 0x900

    # Drag and drop events.
    EVENT_DROPFILE                  = 0x1000
    EVENT_DROPTEXT                  = 0x1001
    EVENT_DROPBEGIN                 = 0x1002
    EVENT_DROPCOMPLETE              = 0x1003

    # Audio hotplug events.
    EVENT_AUDIODEVICEADDED          = 0x1100
    EVENT_AUDIODEVICEREMOVED        = 0x1101

    # Sensor events.
    EVENT_SENSORUPDATE              = 0x1200

    # Render events.
    EVENT_RENDER_TARGETS_RESET      = 0x2000
    EVENT_RENDER_DEVICE_RESET       = 0x2001

    # Internal events.
    EVENT_POLLSENTINEL              = 0x7f00

    # User defined events. To be registered with `register_events()`.
    # Nim exclusive defines. 10 custom user events ought to be enough for anyone.
    EVENT_USEREVENT                 = 0x8000
    EVENT_USEREVENT1                = 0x8001
    EVENT_USEREVENT2                = 0x8002
    EVENT_USEREVENT3                = 0x8003
    EVENT_USEREVENT4                = 0x8004
    EVENT_USEREVENT5                = 0x8005
    EVENT_USEREVENT6                = 0x8006
    EVENT_USEREVENT7                = 0x8007
    EVENT_USEREVENT8                = 0x8008

    EVENT_LASTEVENT                 = 0xffff

const
  TEXTEDITINGEVENT_TEXT_SIZE  = 32
  TEXTINPUTEVENT_TEXT_SIZE    = 32

type
  CommonEvent* {.final, pure.} = object
    ##  Common event.
    typ*          : EventType
    timestamp*    : uint32      ##  Timestamp (ms).

  DisplayEvent* {.final, pure.} = object
    ##  Display state change event.
    typ*          : EventType         ##  `EVENT_DISPLAYEVENT`.
    timestamp*    : uint32            ##  Timestamp (ms).
    display*      : uint32            ##  Associated display.
    event*        : DisplayEventID    ##  Display event ID.
    padding1      : byte
    padding2      : byte
    padding3      : byte
    data1*        : int32             ##  Event dependent data.

  WindowEvent* {.final, pure.} = object
    ##  Window state change event.
    typ*          : EventType         ##  `EVENT_WINDOWEVENT`.
    timestamp*    : uint32            ##  Timestamp (ms).
    window_id*    : uint32            ##  Associated window.
    event*        : WindowEventID     ##  Window event ID.
    padding1      : byte
    padding2      : byte
    padding3      : byte
    data1*        : int32             ##  Event dependent data.
    data2*        : int32             ##  Event dependent data.

  KeyboardEvent* {.final, pure.} = object
    ##  Keyboard button event.
    typ*          : EventType         ##  `EVENT_KEYDOWN` or `EVENT_KEYUP`.
    timestamp*    : uint32            ##  Timestamp (ms).
    window_id*    : uint32            ##  Window with keyboard focus (if any).
    state*        : byte              ##  `PRESSED` or `RELEASED`.
    repeat*       : byte              ##  Non-zero if key repeat.
    padding2      : byte
    padding3      : byte
    keysym*       : Keysym            ##  Key that was pressed or released.

  TextEditingEvent* {.final, pure.} = object
    ##  Keyboard text editing event.
    typ*          : EventType         ##  `EVENT_TEXTEDITING`.
    timestamp*    : uint32            ##  Timestamp (ms).
    window_id*    : uint32            ##  Window with keyboard focus (if any).
    text*         : array[TEXTEDITINGEVENT_TEXT_SIZE, char] ##  The editing text.
    start*        : int32             ##  Selected editing text start cursor.
    length*       : int32             ##  Selected editing text length.

  TextInputEvent* {.final, pure.} = object
    ##  Keyboard text input event.
    typ*          : EventType         ##  `EVENT_TEXTINPUT`.
    timestamp*    : uint32            ##  Timestamp (ms).
    window_id*    : uint32            ##  Window with keyboard focus (if any).
    text*         : array[TEXTINPUTEVENT_TEXT_SIZE, char]   ##  The input text.

  MouseMotionEvent* {.final, pure.} = object
    ##  Mouse motion event.
    typ*          : EventType   ##  `EVENT_MOUSEMOTION`.
    timestamp*    : uint32      ##  Timestamp (ms).
    window_id*    : uint32      ##  Window with mouse focus (if any).
    which*        : uint32      ##  Mouse instance ID or `TOUCH_MOUSEID`.
    state*        : uint32      ##  Button state.
    x*            : int32       ##  X position.
    y*            : int32       ##  Y position.
    xrel*         : int32       ##  Relative motion (X direction).
    yrel*         : int32       ##  Relative motion (Y direction).

  MouseButtonEvent* {.final, pure.} = object
    ##  Mouse button event.
    typ*          : EventType   ##  `EVENT_MOUSEBUTTONDOWN` or `EVENT_MOUSEBUTTONUP`.
    timestamp*    : uint32      ##  Timestamp (ms).
    window_id*    : uint32      ##  Window with mouse focus (if any).
    which*        : uint32      ##  Mouse instance id or `TOUCH_MOUSEID`.
    button*       : byte        ##  Mouse button index.
    state*        : byte        ##  `PRESSED` or `RELEASED`.
    clicks*       : byte        ##  Single click (1), double click (2), etc.
    padding1      : byte
    x*            : int32       ##  X position.
    y*            : int32       ##  Y position.

  MouseWheelEvent* {.final, pure.} = object
    ##  Mouse wheel event.
    typ*          : EventType   ##  `EVENT_MOUSEWHEEL`.
    timestamp*    : uint32      ##  Timestamp (ms).
    window_id*    : uint32      ##  Window with mouse focus (if any).
    which*        : uint32      ##  Mouse instance id or `TOUCH_MOUSEID`.
    x*            : int32       ##  Horizontal scroll amount. Positive to the
                                ##  right. Negative to the left.
    y*            : int32       ##  Vertical scroll amount. Positive to the
                                ##  user, negative toward the user.
    direction*    : uint32      ##  Direction (`MOUSEWHEEL_*`).
    precise_x*    : cfloat      ##  Precise horizontal scroll amount.
                                ##  Since SDL 2.0.18.
    precise_y*    : cfloat      ##  Precise vertical scroll amount.
                                ##  Since SDL 2.0.18.

  JoyAxisEvent* {.final, pure.} = object
    ##  Joystick axis motion event.
    typ*          : EventType   ##  `EVENT_JOYAXISMOTION`.
    timestamp*    : uint32      ##  Timestamp (ms).
    which*        : JoystickID  ##  Joystick ID.
    axis*         : byte        ##  Joystick axis index.
    padding1      : byte
    padding2      : byte
    padding3      : byte
    value*        : int16       ##  Axis value (range: -32768 to 32767).
    padding4      : uint16

  JoyBallEvent* {.final, pure.} = object
    ##  Joystick trackball motion event.
    typ*          : EventType   ##  `EVENT_JOYBALLMOTION`.
    timestamp*    : uint32      ##  Timestamp (ms).
    which*        : JoystickID  ##  Joystick ID.
    ball*         : byte        ##  Joystick trackball index.
    padding1      : byte
    padding2      : byte
    padding3      : byte
    xrel*         : int16       ##  Relative motion (X direction).
    yrel*         : int16       ##  Relative motion (Y direction).

  JoyHatEvent* {.final, pure.} = object
    ##  Joystick hat position change event.
    typ*          : EventType   ##  `EVENT_JOYHATMOTION`.
    timestamp*    : uint32      ##  Timestamp (ms).
    which*        : JoystickID  ##  Joystick ID.
    hat*          : byte        ##  Joystick hat index.
    value*        : Hat         ##  Hat position.
    padding1      : byte
    padding2      : byte

  JoyButtonEvent* {.final, pure.} = object
    ##  Joystick button event.
    typ*          : EventType   ##  `EVENT_JOYBUTTONDOWN` or `EVENT_JOYBUTTONUP`.
    timestamp*    : uint32      ##  Timestamp (ms).
    which*        : JoystickID  ##  Joystick ID.
    button*       : byte        ##  Joystick button index.
    state*        : byte        ##  `PRESSED` or `RELEASED`.
    padding1      : byte
    padding2      : byte

  JoyDeviceEvent* {.final, pure.} = object
    ##  Joystick device event.
    typ*          : EventType   ##  `EVENT_JOYDEVICEADDED` or `EVENT_JOYDEVICEREMOVED`.
    timestamp*    : uint32      ##  Timestamp (ms).
    which*        : int32       ##  Joystick device index for the `ADDED` event
                                ##  or instance id for the `REMOVED` event.

  ControllerAxisEvent* {.final, pure.} = object
    ##  Game controller axis motion event.
    typ*          : EventType   ##  `EVENT_CONTROLLERAXISMOTION`.
    timestamp*    : uint32      ##  Timestamp (ms).
    which*        : JoystickID  ##  Joystick ID.
    axis*         : byte        ##  Controller axis (`GameControllerAxis`).
    padding1      : byte
    padding2      : byte
    padding3      : byte
    value*        : int16       ##  Axis value (range: -32768 to 32767).
    padding4      : uint16

  ControllerButtonEvent* {.final, pure.} = object
    ##  Game controller button event.
    typ*          : EventType   ##  `EVENT_CONTROLLERBUTTONDOWN`` or `EVENT_CONTROLLERBUTTONUP`.
    timestamp*    : uint32      ##  Timestamp (ms).
    which*        : JoystickID  ##  Joystick ID.
    button*       : byte        ##  Joystick button (`GameControllerButton`).
    state*        : byte        ##  `PRESSED` or `RELEASED`.
    padding1      : byte
    padding2      : byte

  ControllerDeviceEvent* {.final, pure.} = object
    ##  Controller device event.
    typ*          : EventType   ##  `EVENT_CONTROLLERDEVICEADDED`,
                                ##  `EVENT_CONTROLLERDEVICEREMOVED`,
                                ##  `EVENT_CONTROLLERDEVICEREMAPPED`
                                ##  or `EVENT_CONTROLLERSTEAMHANDLEUPDATED`.
    timestamp*    : uint32      ##  Timestamp (ms).
    which*        : int32       ##  Joystick device index for the `ADDED` event
                                ##  or instance id for the `REMOVED`
                                ##  or `REMAPPED` event.

  ControllerTouchpadEvent* {.final, pure.} = object
    ##  Game controller touchpad event.
    typ*          : EventType   ##  `EVENT_CONTROLLERTOUCHPADDOWN`,
                                ##  `EVENT_CONTROLLERTOUCHPADMOTION`
                                ##  or `EVENT_CONTROLLERTOUCHPADUP`.
    timestamp*    : uint32      ##  Timestamp (ms).
    which*        : JoystickID  ##  Joystick ID.
    touchpad*     : int32       ##  Touchpad index.
    finger*       : int32       ##  Finger index.
    x*            : cfloat      ##  Normalized, range 0 - 1; 0 is left.
    y*            : cfloat      ##  Normalized, range 0 - 1; 0 is top.
    pressure*     : cfloat      ##  Normalized, range 0 - 1.

  ControllerSensorEvent* {.final, pure.} = object
    ##  Game controller sensor event.
    typ*          : EventType   ##  `EVENT_CONTROLLERSENSORUPDATE`.
    timestamp*    : uint32      ##  Timestamp (ms).
    which*        : JoystickID  ##  Joystick ID.
    sensor*       : int32       ##  Sensor type (`SensorType`).
    data*         : array[3, cfloat]  ##  Sensor values (up to 3).

  AudioDeviceEvent* {.final, pure.} = object
    ##  Audio device event.
    typ*          : EventType     ##  `EVENT_AUDIODEVICEADDED` or `EVENT_AUDIODEVICEREMOVED`.
    timestamp*    : uint32        ##  Timestamp (ms).
    which*        : AudioDeviceID ##  Audio device index for the `ADDED` event
                                  ##  (valid until next `get_num_audio_devices()
                                  ##  call) or `AudioDeviceID` for the `REMOVED` event.
    iscapture*    : byte          ##  Output device (0) or capture device (non-zero).
    padding1      : byte
    padding2      : byte
    padding3      : byte

  TouchFingerEvent* {.final, pure.} = object
    ##  Touch finger event.
    typ*          : EventType   ##  `EVENT_FINGERMOTION`, `EVENT_FINGERDOWN` or `EVENT_FINGERUP`.
    timestamp*    : uint32      ##  Timestamp (ms).
    touchId*      : TouchID     ##  Touch ID.
    fingerId*     : FingerID
    x*            : cfloat      ##  Normalized, range 0 - 1.
    y*            : cfloat      ##  Normalized, range 0 - 1.
    dx*           : cfloat      ##  Normalized, range -1 - 1.
    dy*           : cfloat      ##  Normalized, range -1 - 1.
    pressure*     : cfloat      ##  Normalized, range 0 - 1.
    window_id*    : uint32      ##  Window underneath the finger (if any).

  MultiGestureEvent* {.final, pure.} = object
    ##  Multiple Finger Gesture Event.
    typ*          : EventType   ##  `EVENT_MULTIGESTURE`.
    timestamp*    : uint32      ##  Timestamp (ms).
    touch_id*     : TouchID     ##  Touch ID.
    d_theta*      : cfloat
    d_dist*       : cfloat
    x*            : cfloat
    y*            : cfloat
    num_fingers*  : uint16
    padding       : uint16

  DollarGestureEvent* {.final, pure.} = object
    ##  Dollar Gesture Event.
    typ*          : EventType   ##  `EVENT_DOLLARGESTURE` or `EVENT_DOLLARRECORD`.
    timestamp*    : uint32      ##  Timestamp (ms).
    touchId*      : TouchID     ##  Touch ID.
    gestureId*    : GestureID
    numFingers*   : uint32
    error*        : cfloat
    x*            : cfloat      ##  Normalized gesture center.
    y*            : cfloat      ##  Normalized gesture center.

  DropEvent* {.final, pure.} = object
    ##  An event used to request a file open by the system. Enabled by default.
    typ*          : EventType   ##  `EVENT_DROPBEGIN`, `EVENT_DROPFILE`,
                                ##  `EVENT_DROPTEXT` or `EVENT_DROPCOMPLETE`.
    timestamp*    : uint32      ##  Timestamp (ms).
    file*         : cstring     ##  File name. Must be freed.
                                ##  `nil` on begin/complete.
    window_id*    : uint32      ##  Window ID file was dropped on (if any).

  SensorEvent* {.final, pure.} = object
    ##  Sensor event.
    typ*          : EventType   ##  `EVENT_SENSORUPDATE`.
    timestamp*    : uint32      ##  Timestamp (ms).
    which*        : SensorID    ##  Sensor ID.
    data*         : array[6, cfloat]  ##  Sensor values (up to 6).
                                ##  Query additional values with
                                ##  `sensor_get_data()`.

  QuitEvent* {.final, pure.} = object
    ##  The "quit requested" event.
    typ*          : EventType   ##  `EVENT_QUIT`.
    timestamp*    : uint32      ##  Timestamp (ms).

  UserEvent* {.final, pure.} = object
    ##  A user-defined event type.
    typ*          : EventType   ##  `EVENT_USEREVENT` - `EVENT_USEREVENT8`.
    timestamp*    : uint32      ##  Timestamp (ms).
    window_id*    : uint32      ##  Associated window (if any).
    code*         : int32       ##  User defined code.
    data1*        : pointer     ##  User defined data pointer.
    data2*        : pointer     ##  User defined data pointer.

  SysWMmsg {.final, incompletestruct, pure.} = object

  SysWMmsgPtr* = ptr SysWMmsg

  SysWMEvent* {.final, pure.} = object
    ##  A video driver dependent system event. Disabled by default.
    typ*          : EventType     ##  `EVENT_SYSWMEVENT`.
    timestamp*    : uint32        ##  Timestamp (ms).
    msg*          : SysWMmsgPtr   ##  Driver dependent data.

type
  Event* {.bycopy, final, pure, union.} = object
    ##  Event.
    typ*          : EventType                 ##  Event type.
    common*       : CommonEvent               ##  Common event.
    display*      : DisplayEvent              ##  Display event.
    window*       : WindowEvent               ##  Window event.
    key*          : KeyboardEvent             ##  Keyboard event.
    edit*         : TextEditingEvent          ##  Text editing event.
    text*         : TextInputEvent            ##  Text input event.
    motion*       : MouseMotionEvent          ##  Mouse motion event.
    button*       : MouseButtonEvent          ##  Mouse button event.
    wheel*        : MouseWheelEvent           ##  Mouse wheel event.
    jaxis*        : JoyAxisEvent              ##  Joystick axis event.
    jball*        : JoyBallEvent              ##  Joystick ball event.
    jhat*         : JoyHatEvent               ##  Joystick hat event.
    jbutton*      : JoyButtonEvent            ##  Joystick button event.
    jdevice*      : JoyDeviceEvent            ##  Joystick device change event.
    caxis*        : ControllerAxisEvent       ##  Game Controller axis event.
    cbutton*      : ControllerButtonEvent     ##  Game Controller button event.
    cdevice*      : ControllerDeviceEvent     ##  Game Controller device event.
    ctouchpad*    : ControllerTouchpadEvent   ##  Game Controller touchpad event.
    csensor*      : ControllerSensorEvent     ##  Game Controller sensor event.
    adevice*      : AudioDeviceEvent          ##  Audio device event.
    sensor*       : SensorEvent               ##  Sensor event.
    quit*         : QuitEvent                 ##  Quit request event.
    user*         : UserEvent                 ##  Custom event.
    syswm*        : SysWMEvent                ##  System dependent window event.
    tfinger*      : TouchFingerEvent          ##  Touch finger event.
    mgesture*     : MultiGestureEvent         ##  Gesture event.
    dgesture*     : DollarGestureEvent        ##  Gesture event.
    drop*         : DropEvent                 ##  Drag and drop event.

    # See `SDL_events.h` for details.
    padding       : array[when pointer.sizeof <= 8:
                        56
                      elif pointer.sizeof == 16:
                        64
                      else:
                        3 * pointer.sizeof, byte]

# Let's make sure we haven't broken binary compatibility.
when Event.sizeof != Event.padding.sizeof:
  {.error: "invalid Event size".}

type
  EventAction* {.size: cint.sizeof.} = enum
    ADDEVENT
    PEEKEVENT
    GETEVENT

type
  EventFilter* = proc (userdata: pointer,
                       event: ptr Event): cint {.cdecl, gcsafe, raises: [].}
    ##  Event queue watch function callback.

type
  EventState* = distinct cint
    ##  Event state.

const
  QUERY*    = EventState -1
  IGNORE*   = EventState 0
  DISABLE*  = EventState 0
  ENABLE*   = EventState 1

# =========================================================================== #
# ==  Nim specific                                                         == #
# =========================================================================== #

# Calling default `$` and repr on union in Nim results with:
# SIGSEGV: Illegal storage access. (Attempt to read from nil?)

when defined release:
  func `$`*(event: ptr Event): string {.error: "do not `$` unions in Nim".}
  func repr*(event: Event): string {.error: "do not repr unions in Nim".}
else:
  func `$`*(event: Event): string = "(typ: " & $event.typ & ", ...)"
  func repr*(event: Event): string = "[typ = " & $event.typ & ", ...]"

func repr*(event: ptr Event): string {.error: "do not repr unions in Nim".}

# --------------------------------------------------------------------------- #
#   Sanity checks                                                             #
# --------------------------------------------------------------------------- #

when defined(gcc) and hostCPU == "amd64":
  when CommonEvent.sizeof != 8:
    {.fatal: "invalid CommonEvent size: " & $CommonEvent.sizeof.}
  when DisplayEvent.sizeof != 20:
    {.fatal: "invalid DisplayEvent size: " & $DisplayEvent.sizeof.}
  when Event.sizeof != 56:
    {.fatal: "invalid Event size: " & $Event.sizeof.}

# vim: set sts=2 et sw=2:
