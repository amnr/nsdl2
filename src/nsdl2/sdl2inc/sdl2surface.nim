##  Surface definitions.
##
#[
  SPDX-License-Identifier: NCSA OR MIT OR Zlib
]#

{.push raises: [].}

from sdl2pixels import PixelFormat
from sdl2rect import Rect

type
  SurfaceFlags* = distinct uint32
    ##  Surface flags.

func `and`(a, b: SurfaceFlags): SurfaceFlags {.borrow.}
func `or`*(a, b: SurfaceFlags): SurfaceFlags {.borrow.}

func `==`*(a: SurfaceFlags, b: uint32): bool {.borrow.}

const
  SWSURFACE*    = SurfaceFlags 0
  PREALLOC*     = SurfaceFlags 0x00000001   ##  Surface uses prealloc. memory.
  RLEACCEL*     = SurfaceFlags 0x00000002   ##  Surface is RLE encoded.
  DONTFREE*     = SurfaceFlags 0x00000004   ##  Surface is ref. internally.
  SIMD_ALIGNED* = SurfaceFlags 0x00000008   ##  Surface uses aligned memory.

type
  Surface {.bycopy, final, pure.} = object
    ##  Surface (a collection of pixels used in software blitting).
    flags         : SurfaceFlags      ##  Surface flags.
    format        : ptr PixelFormat   ##  Surface format.
    w             : cint              ##  Surface width.
    h             : cint              ##  Surface height.
    pitch         : cint              ##  Surface pitch.
    pixels        : ptr UncheckedArray[byte]    ##  Pixel data. May be `nil`.
    userdata*     : pointer           ##  User data pointer.
    locked*       : cint              ##  Surface lock flag. Read-only.
    list_blitmap  : pointer           ##  Private.
    clip_rect*    : Rect              ##  Clipping information. Read-only.
    map           : pointer           ##  Private.
    refcount      : cint              ##  Reference count.

  SurfacePtr* = ptr Surface
    ##  Surface.

func format*(self: SurfacePtr): ptr PixelFormat {.inline.} =
  self.format

func w*(self: SurfacePtr): int {.inline.} =
  ##  Surface width.
  self.w

func h*(self: SurfacePtr): int {.inline.} =
  ##  Surface height.
  self.h

func pitch*(self: SurfacePtr): cint {.inline.} =
  ##  Surface pitch.
  self.pitch

func pixels*(self: SurfacePtr): ptr UncheckedArray[byte] {.inline.} =
  ##  Surface pixels as unchecked array of `byte`.
  self.pixels

func pixels16*(self: SurfacePtr): ptr UncheckedArray[uint16] {.inline.} =
  ##  Surface pixels as unchecked array of `uint16`.
  cast[ptr UncheckedArray[uint16]](self.pixels)

func pixels32*(self: SurfacePtr): ptr UncheckedArray[uint32] {.inline.} =
  ##  Surface pixels as unchecked array of `uint32`.
  cast[ptr UncheckedArray[uint32]](self.pixels)

func mustlock*(self: SurfacePtr): bool {.inline.} =
  ##  True if the surface needs to be locked before access.
  (self.flags and RLEACCEL) != 0

type
  YuvConversionMode* {.size: cint.sizeof.} = enum
    ##  YUV and RGB conversion mode.
    YUV_CONVERSION_JPEG       ##  Full range JPEG.
    YUV_CONVERSION_BT601      ##  BT.601 (the default).
    YUV_CONVERSION_BT709      ##  BT.709.
    YUV_CONVERSION_AUTOMATIC  ##  BT.601 for SD content, BT.709 for HD content.

# --------------------------------------------------------------------------- #
#   Sanity checks                                                             #
# --------------------------------------------------------------------------- #

when defined(gcc) and hostCPU == "amd64":
  when Surface.sizeof != 96:
    {.fatal: "invalid Surface size: " & $Surface.sizeof.}

# vim: set sts=2 et sw=2:
