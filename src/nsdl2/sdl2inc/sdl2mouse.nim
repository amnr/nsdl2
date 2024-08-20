##  Mouse event definitions.
##
#[
  SPDX-License-Identifier: NCSA OR MIT OR Zlib
]#

{.push raises: [].}

type
  Cursor {.final, incompletestruct, pure.} = object
    ##  Cursor.

  CursorPtr* = ptr Cursor
    ##  Cursor.

  SystemCursor* {.size: cint.sizeof.} = enum
    ##  Cursor types for `create_system_cursor()`.
    SYSTEM_CURSOR_ARROW
    SYSTEM_CURSOR_IBEAM
    SYSTEM_CURSOR_WAIT
    SYSTEM_CURSOR_CROSSHAIR
    SYSTEM_CURSOR_WAITARROW
    SYSTEM_CURSOR_SIZENWSE
    SYSTEM_CURSOR_SIZENESW
    SYSTEM_CURSOR_SIZEWE
    SYSTEM_CURSOR_SIZENS
    SYSTEM_CURSOR_SIZEALL
    SYSTEM_CURSOR_NO
    SYSTEM_CURSOR_HAND

const
  NUM_SYSTEM_CURSORS* = SYSTEM_CURSOR_HAND.int + 1

type
  MouseWheelDirection* {.size: uint32.sizeof.} = enum
    ##  Scroll event scroll direction types.
    MOUSEWHEEL_NORMAL
    MOUSEWHEEL_FLIPPED

# Used as a mask when testing buttons in buttonstate.
#
# - Button 1:  Left mouse button.
# - Button 2:  Middle mouse button.
# - Button 3:  Right mouse button.

func button_mask*[T: byte or uint32](x: T): T =
  1.T shl (x - 1)

const
  BUTTON_LEFT*    = 1u8
  BUTTON_MIDDLE*  = 2u8
  BUTTON_RIGHT*   = 3u8
  BUTTON_X1*      = 4u8
  BUTTON_X2*      = 5u8
  BUTTON_LMASK*   = button_mask BUTTON_LEFT
  BUTTON_MMASK*   = button_mask BUTTON_MIDDLE
  BUTTON_RMASK*   = button_mask BUTTON_RIGHT
  BUTTON_X1MASK*  = button_mask BUTTON_X1
  BUTTON_X2MASK*  = button_mask BUTTON_X2

# vim: set sts=2 et sw=2:
