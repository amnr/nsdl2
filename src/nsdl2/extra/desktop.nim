##  Desktop related functions.
##
#[
  SPDX-License-Identifier: NCSA OR MIT OR Zlib
]#

import ../../nsdl2

proc get_desktop_size*(width, height: var int, desktop_index = 0): bool =
  ##  Return usable desktop size.
  ##
  ##  This function return total desktop size prior to SDL 2.0.5.
  var rect: Rect
  result = GetDisplayUsableBounds(desktop_index, rect)
  width   = rect.w
  height  = rect.h

# vim: set sts=2 et sw=2:
