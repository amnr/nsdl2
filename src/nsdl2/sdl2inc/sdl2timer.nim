##  Timer definitions.
##
#[
  SPDX-License-Identifier: NCSA OR MIT OR Zlib
]#

{.push raises: [].}

func ticks_passed*(a, b: uint32): bool {.inline.} =
  #  XXX: replace it (remove cast).
  cast[int32](b - a) <= 0

type
  TimerCallback* = proc (interval: uint32,
                         param: pointer): uint32 {.cdecl, gcsafe, raises: [].}

type
  TimerID* = distinct cint

# vim: set sts=2 et sw=2:
