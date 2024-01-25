##  Renderer definitions.
#[
  SPDX-License-Identifier: NCSA OR MIT OR Zlib
]#

{.push raises: [].}

from pixels import Color
from rect import FPoint

type
  RendererFlags* = distinct uint32
    ##  Renderer flags.

func `and`*(a, b: RendererFlags): RendererFlags {.borrow.}
func `or`*(a, b: RendererFlags): RendererFlags {.borrow.}

proc `+=`*(x: var RendererFlags, y: RendererFlags) {.borrow.}

const
  RENDERER_SOFTWARE*      = RendererFlags 0x00000001
  RENDERER_ACCELERATED*   = RendererFlags 0x00000002
  RENDERER_PRESENTVSYNC*  = RendererFlags 0x00000004
  RENDERER_TARGETTEXTURE* = RendererFlags 0x00000008

type
  RendererInfo* {.final, pure.} = object
    ##  Information on the capabilities of a render driver or context.
    name*                 : cstring             ##  Renderer name.
    flags*                : RendererFlags       ##  Supported flags.
    num_texture_formats*  : uint32              ##  The number of available
                                                ##  texture formats.
    texture_formats*      : array[16, uint32]   ##  Available texture formats.
    max_texture_width*    : cint                ##  Maximum texture width.
    max_texture_height*   : cint                ##  Maximum texture height.

  Vertex* {.final, pure.} = object
    ##  Vertex.
    position*   : FPoint    ##  Vertex position (`Renderer` coordinates).
    color*      : Color     ##  Vertex color.
    tex_coord*  : FPoint    ##  Normalized texture coordinates (if needed).

  ScaleMode* {.size: cint.sizeof.} = enum
    ##  Textture scaling mode.
    SCALEMODE_NEAREST     ##  Nearest pixel sampling.
    SCALEMODE_LINEAR      ##  Linear filtering.
    SCALEMODE_BEST        ##  Anisotropic filtering.

  TextureAccess* {.size: cint.sizeof.} = enum
    ##  Texture access pattern allowed.
    TEXTUREACCESS_STATIC      ##  Changes rarely, not lockable.
    TEXTUREACCESS_STREAMING   ##  Changes frequently, lockable.
    TEXTUREACCESS_TARGET      ##  Texture can be used as a render target.

  TextureModulate* {.size: cint.sizeof.} = enum
    ##  Texture channel modulation. Used in `copy()`.
    TEXTUREMODULATE_NONE    = 0x00000000    ##  No modulation.
    TEXTUREMODULATE_COLOR   = 0x00000001    ##  srcC = srcC * color.
    TEXTUREMODULATE_ALPHA   = 0x00000002    ##  srcA = srcA * alpha.

  RendererFlip* {.size: cint.sizeof.} = enum
    ##  Flip constants for `copy_ex()`.
    FLIP_NONE         = 0x00000000    ##  Do not flip.
    FLIP_HORIZONTAL   = 0x00000001    ##  Flip horizontally.
    FLIP_VERTICAL     = 0x00000002    ##  Flip vertically.

  Renderer* = ptr object
    ##  Rendering state.

  Texture* = ptr object
    ##  Texture.

# --------------------------------------------------------------------------- #
#   Sanity checks                                                             #
# --------------------------------------------------------------------------- #

when defined(gcc) and hostCPU == "amd64":
  when RendererInfo.sizeof != 88:
    {.fatal: "invalid RendererInfo size: " & $RendererInfo.sizeof.}

# vim: set sts=2 et sw=2:
