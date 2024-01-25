##  Shape definitions.
#[
  SPDX-License-Identifier: NCSA OR MIT OR Zlib
]#

{.push raises: [].}

from pixels import Color

const
  NONSHAPEABLE_WINDOW*    = -1
  INVALID_SHAPE_ARGUMENT* = -2
  SDL_WINDOW_LACKS_SHAPE* = -3

type
  WindowShapeModeEnum* {.size: cint.sizeof.} = enum
    ShapeModeDefault
    ShapeModeBinarizeAlpha
    ShapeModeReverseBinarizeAlpha
    ShapeModeColorKey

# XXX:
#define SDL_SHAPEMODEALPHA(mode) (mode == ShapeModeDefault || mode == ShapeModeBinarizeAlpha || mode == ShapeModeReverseBinarizeAlpha)

type
  WindowShapeParams* {.final, union, pure.} = object
    ##  Shaped windows parameters.
    binarization_cutoff*  : byte
    color_key*            : Color

type
  WindowShapeMode* {.final, pure.} = object
    mode*         : WindowShapeModeEnum
    parameters*   : WindowShapeParams

# vim: set sts=2 et sw=2:
