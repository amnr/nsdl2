##  Video definitions.
##
#[
  SPDX-License-Identifier: NCSA OR MIT OR Zlib
]#

{.push raises: [].}

from sdl2pixels import PixelFormatEnum
from sdl2rect import Point

type
  DisplayMode* {.final, pure.} = object     # XXX: bycopy?
    ##  Display mode.
    format*       : PixelFormatEnum   ##  Pixel format.
    w*            : cint              ##  Screen width.
    h*            : cint              ##  Screen height.
    refresh_rate* : cint              ##  Refresh rate (zero == unspecified).
    driverdata    : pointer           ##  Driver specific data, init. to nil.

  Window* = ptr object
    ##  Window.

type
  WindowFlags* = distinct uint32
    ##  Window flags.

func `and`*(a, b: WindowFlags): WindowFlags {.borrow.}
func `or`*(a, b: WindowFlags): WindowFlags {.borrow.}

func `==`*(a, b: WindowFlags): bool {.borrow.}
func `==`*(a: WindowFlags, b: uint32): bool {.borrow.}

proc `+=`*(x: var WindowFlags, y: WindowFlags) {.borrow.}

const
  WINDOW_FULLSCREEN*        = WindowFlags 0x00000001
  WINDOW_OPENGL*            = WindowFlags 0x00000002
  WINDOW_SHOWN*             = WindowFlags 0x00000004
  WINDOW_HIDDEN*            = WindowFlags 0x00000008
  WINDOW_BORDERLESS*        = WindowFlags 0x00000010
  WINDOW_RESIZABLE*         = WindowFlags 0x00000020
  WINDOW_MINIMIZED*         = WindowFlags 0x00000040
  WINDOW_MAXIMIZED*         = WindowFlags 0x00000080
  WINDOW_MOUSE_GRABBED*     = WindowFlags 0x00000100
  WINDOW_INPUT_FOCUS*       = WindowFlags 0x00000200
  WINDOW_MOUSE_FOCUS*       = WindowFlags 0x00000400
  WINDOW_FOREIGN*           = WindowFlags 0x00000800
  WINDOW_ALLOW_HIGHDPI*     = WindowFlags 0x00002000
  WINDOW_MOUSE_CAPTURE*     = WindowFlags 0x00004000
  WINDOW_ALWAYS_ON_TOP*     = WindowFlags 0x00008000
  WINDOW_SKIP_TASKBAR*      = WindowFlags 0x00010000
  WINDOW_UTILITY*           = WindowFlags 0x00020000
  WINDOW_TOOLTIP*           = WindowFlags 0x00040000
  WINDOW_POPUP_MENU*        = WindowFlags 0x00080000
  WINDOW_KEYBOARD_GRABBED*  = WindowFlags 0x00100000
  WINDOW_VULKAN*            = WindowFlags 0x10000000
  WINDOW_METAL*             = WindowFlags 0x20000000

  WINDOW_FULLSCREEN_DESKTOP*  = WINDOW_FULLSCREEN or WindowFlags 0x00001000
  WINDOW_INPUT_GRABBED*       = WINDOW_MOUSE_GRABBED

const
  WINDOWPOS_UNDEFINED_MASK  = 0x1fff_0000'u32
  WINDOWPOS_CENTERED_MASK   = 0x2fff_0000'u32

func windowpos_undefined_display*(x: int): int {.inline.} =
  int WINDOWPOS_UNDEFINED_MASK or x.uint32

func windowpos_centered_display*(x: int): int {.inline.} =
  int WINDOWPOS_CENTERED_MASK or x.uint32

const
  WINDOWPOS_UNDEFINED*  = windowpos_undefined_display 0
  WINDOWPOS_CENTERED*   = windowpos_centered_display 0

func windowpos_isundefined*(x: int): bool {.inline.} =
  (x.uint32 and 0xffff0000'u32) == WINDOWPOS_UNDEFINED_MASK

func windowpos_iscentered*(x: int): bool {.inline.} =
  (x.uint32 and 0xffff0000'u32) == WINDOWPOS_CENTERED_MASK

type
  WindowEventID* {.size: byte.sizeof.} = enum
    ##  Window event subtype.
    WINDOWEVENT_NONE
    WINDOWEVENT_SHOWN
    WINDOWEVENT_HIDDEN
    WINDOWEVENT_EXPOSED
    WINDOWEVENT_MOVED
    WINDOWEVENT_RESIZED
    WINDOWEVENT_SIZE_CHANGED
    WINDOWEVENT_MINIMIZED
    WINDOWEVENT_MAXIMIZED
    WINDOWEVENT_RESTORED
    WINDOWEVENT_ENTER
    WINDOWEVENT_LEAVE
    WINDOWEVENT_FOCUS_GAINED
    WINDOWEVENT_FOCUS_LOST
    WINDOWEVENT_CLOSE
    WINDOWEVENT_TAKE_FOCUS
    WINDOWEVENT_HIT_TEST
    WINDOWEVENT_ICCPROF_CHANGED
    WINDOWEVENT_DISPLAY_CHANGED

  DisplayEventID* {.size: byte.sizeof.} = enum
    ##  Display event subtype.
    DISPLAYEVENT_NONE
    DISPLAYEVENT_ORIENTATION
    DISPLAYEVENT_CONNECTED
    DISPLAYEVENT_DISCONNECTED
    DISPLAYEVENT_MOVED

  DisplayOrientation* {.size: cint.sizeof.} = enum
    ##  Display orientation.
    ORIENTATION_UNKNOWN
    ORIENTATION_LANDSCAPE
    ORIENTATION_LANDSCAPE_FLIPPED
    ORIENTATION_PORTRAIT
    ORIENTATION_PORTRAIT_FLIPPED 

  FlashOperation* {.size: cint.sizeof.} = enum
    ##  Window flash operation.
    FLASH_CANCEL
    FLASH_BRIEFLY
    FLASH_UNTIL_FOCUSED

  GLattr* {.pure, size: cint.sizeof.} = enum    # XXX: size.
    ##  OpenGL configuration attributes.
    GL_RED_SIZE
    GL_GREEN_SIZE
    GL_BLUE_SIZE
    GL_ALPHA_SIZE
    GL_BUFFER_SIZE
    GL_DOUBLEBUFFER
    GL_DEPTH_SIZE
    GL_STENCIL_SIZE
    GL_ACCUM_RED_SIZE
    GL_ACCUM_GREEN_SIZE
    GL_ACCUM_BLUE_SIZE
    GL_ACCUM_ALPHA_SIZE
    GL_STEREO
    GL_MULTISAMPLEBUFFERS
    GL_MULTISAMPLESAMPLES
    GL_ACCELERATED_VISUAL
    GL_RETAINED_BACKING
    GL_CONTEXT_MAJOR_VERSION
    GL_CONTEXT_MINOR_VERSION
    GL_CONTEXT_EGL
    GL_CONTEXT_FLAGS
    GL_CONTEXT_PROFILE_MASK
    GL_SHARE_WITH_CURRENT_CONTEXT
    GL_FRAMEBUFFER_SRGB_CAPABLE
    GL_CONTEXT_RELEASE_BEHAVIOR
    GL_CONTEXT_RESET_NOTIFICATION
    GL_CONTEXT_NO_ERROR
    GL_FLOATBUFFERS

  GLprofile* {.size: cint.sizeof.} = enum    # XXX: distinct type.
    GL_CONTEXT_PROFILE_CORE           = 0x0001
    GL_CONTEXT_PROFILE_COMPATIBILITY  = 0x0002
    GL_CONTEXT_PROFILE_ES             = 0x0004

  GLcontextFlag* {.size: cint.sizeof.} = enum    # XXX: distinct type
    GL_CONTEXT_DEBUG_FLAG              = 0x0001
    GL_CONTEXT_FORWARD_COMPATIBLE_FLAG = 0x0002
    GL_CONTEXT_ROBUST_ACCESS_FLAG      = 0x0004
    GL_CONTEXT_RESET_ISOLATION_FLAG    = 0x0008

  GLcontextReleaseFlag* {.size: cint.sizeof.} = enum    # XXX: distinct type
    GL_CONTEXT_RELEASE_BEHAVIOR_NONE   = 0x0000
    GL_CONTEXT_RELEASE_BEHAVIOR_FLUSH  = 0x0001

  GLContextResetNotification* {.size: cint.sizeof.} = enum    # XXX: distinct type
    GL_CONTEXT_RESET_NO_NOTIFICATION = 0x0000
    GL_CONTEXT_RESET_LOSE_CONTEXT    = 0x0001

type
  HitTestResult* {.size: cint.sizeof.} = enum
    HITTEST_NORMAL
    HITTEST_DRAGGABLE
    HITTEST_RESIZE_TOPLEFT
    HITTEST_RESIZE_TOP
    HITTEST_RESIZE_TOPRIGHT
    HITTEST_RESIZE_RIGHT
    HITTEST_RESIZE_BOTTOMRIGHT
    HITTEST_RESIZE_BOTTOM
    HITTEST_RESIZE_BOTTOMLEFT
    HITTEST_RESIZE_LEFT

type
  HitTest* = proc (
    win   : Window,
    area  : ptr Point,
    data  : pointer
  ): HitTestResult {.cdecl, gcsafe, raises: [].}
    ##  Hit testing callback.

# --------------------------------------------------------------------------- #
#   Sanity checks                                                             #
# --------------------------------------------------------------------------- #

when defined(gcc) and hostCPU == "amd64":
  when DisplayMode.sizeof != 24:
    {.fatal: "invalid DisplayMode size: " & $DisplayMode.sizeof.}

# vim: set sts=2 et sw=2:
