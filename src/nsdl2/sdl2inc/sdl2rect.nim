##  Rect definitions.
##
#[
  SPDX-License-Identifier: NCSA OR MIT OR Zlib
]#

{.push raises: [].}

type
  Point* {.bycopy, final, pure.} = object
    ##  Point (integer).
    x*  : cint
    y*  : cint

  FPoint* {.bycopy, final, pure.} = object
    ##  Point (floating point).
    x*  : cfloat
    y*  : cfloat

type
  Rect* {.bycopy, final, pure.} = object
    ##  Rectangle (integer).
    x*  : cint
    y*  : cint
    w*  : cint
    h*  : cint

func init*(T: typedesc[Rect], x, y: int, w, h: int): T =
  T(x: x.cint, y: y.cint, w: w.cint, h: h.cint)

type
  FRect* {.bycopy, final, pure.} = object
    ##  Rectangle (floating point).
    x*  : cfloat
    y*  : cfloat
    w*  : cfloat
    h*  : cfloat

func point_in_rect*(p: Point, r: Rect): bool {.inline.} =
  ##  Return `true` if point resides inside a rectangle.
  (p.x >= r.x) and (p.x < (r.x + r.w)) and
  (p.y >= r.y) and (p.y < (r.y + r.h))

func contains*(r: Rect, p: Point): bool {.inline.} =
  ##  Alias for `point_in_rect`.
  p.point_in_rect r

# XXX: needed?
# func rect_empty*(r: ptr Rect): bool {.inline.} =
#   ##  Return `true` if the rectangle has no area.
#   (r == nil) or (r.w <= 0) or (r.h <= 0)

func rect_empty*(r: Rect): bool {.inline.} =
  ##  Return `true` if the rectangle has no area.
  (r.w <= 0) or (r.h <= 0)

# XXX: needed?
# func rect_equals*(a, b: ptr Rect): bool {.inline.} =
#   ##  Return `true` if the two rectangles are equal.
#   (a != nil) and (b != nil) and
#   (a.x == b.x) and (a.y == b.y) and
#   (a.w == b.w) and (a.h == b.h)

# vim: set sts=2 et sw=2:
