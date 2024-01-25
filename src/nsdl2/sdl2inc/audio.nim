##  Audio definitions.
#[
  SPDX-License-Identifier: NCSA OR MIT OR Zlib
]#

{.push raises: [].}

type
  AudioFormat* = distinct uint16
    ##  Audio format.

func `and`*(a, b: AudioFormat): AudioFormat {.borrow.}
func `or`*(a, b: AudioFormat): AudioFormat {.borrow.}

func `==`*(a, b: AudioFormat): bool {.borrow.}

const
  # Audio flags.
  AUDIO_MASK_BITSIZE*   = 0xff
  AUDIO_MASK_DATATYPE*  = 1 shl 8
  AUDIO_MASK_ENDIAN*    = 1 shl 12
  AUDIO_MASK_SIGNED*    = 1 shl 15

# AUDIO_BITSIZE(x)         (x & SDL_AUDIO_MASK_BITSIZE)
# AUDIO_ISFLOAT(x)         (x & SDL_AUDIO_MASK_DATATYPE)
# AUDIO_ISBIGENDIAN(x)     (x & SDL_AUDIO_MASK_ENDIAN)
# AUDIO_ISSIGNED(x)        (x & SDL_AUDIO_MASK_SIGNED)
# AUDIO_ISINT(x)           (!SDL_AUDIO_ISFLOAT(x))
# AUDIO_ISLITTLEENDIAN(x)  (!SDL_AUDIO_ISBIGENDIAN(x))
# AUDIO_ISUNSIGNED(x)      (!SDL_AUDIO_ISSIGNED(x))

const
  # Audio format flags.
  AUDIO_U8*       = AudioFormat 0x0008    ##  Unsigned 8-bit samples.
  AUDIO_S8*       = AudioFormat 0x8008    ##  Signed 8-bit samples.
  AUDIO_U16LSB*   = AudioFormat 0x0010    ##  Unsigned 16-bit samples (little endian).
  AUDIO_S16LSB*   = AudioFormat 0x8010    ##  Signed 16-bit samples (little endian).
  AUDIO_U16MSB*   = AudioFormat 0x1010    ##  Unsigned 16-bit samples (big endian).
  AUDIO_S16MSB*   = AudioFormat 0x9010    ##  Signed 16-bit samples (big endian).
  AUDIO_U16*      = AUDIO_U16LSB
  AUDIO_S16*      = AUDIO_S16LSB

  AUDIO_S32LSB*   = AudioFormat 0x8020    ##  32-bit integer samples (little endian).
  AUDIO_S32MSB*   = AudioFormat 0x9020    ##  32-bit integer samples (big endian).
  AUDIO_S32*      = AUDIO_S32LSB

  AUDIO_F32LSB*   = AudioFormat 0x8120    ##  32-bit floating point samples (little endian).
  AUDIO_F32MSB*   = AudioFormat 0x9120    ##  32-bit floating point samples (big endian).
  AUDIO_F32*      = AUDIO_F32LSB

when cpuEndian == littleEndian:
  const
    AUDIO_U16SYS* = AUDIO_U16LSB
    AUDIO_S16SYS* = AUDIO_S16LSB
    AUDIO_S32SYS* = AUDIO_S32LSB
    AUDIO_F32SYS* = AUDIO_F32LSB
else:
  const
    AUDIO_U16SYS* = AUDIO_U16MSB
    AUDIO_S16SYS* = AUDIO_S16MSB
    AUDIO_S32SYS* = AUDIO_S32MSB
    AUDIO_F32SYS* = AUDIO_F32MSB

type
  AudioAllowFlags* = distinct cint
    ##  Flags for `open_audio_device`.

func `or`*(a, b: AudioAllowFlags): AudioAllowFlags {.borrow.}

const
  # Allow change flags.
  AUDIO_ALLOW_FREQUENCY_CHANGE*   = AudioAllowFlags 0x00000001
  AUDIO_ALLOW_FORMAT_CHANGE*      = AudioAllowFlags 0x00000002
  AUDIO_ALLOW_CHANNELS_CHANGE*    = AudioAllowFlags 0x00000004
  AUDIO_ALLOW_SAMPLES_CHANGE*     = AudioAllowFlags 0x00000008
  AUDIO_ALLOW_ANY_CHANGE*         = AUDIO_ALLOW_FREQUENCY_CHANGE  or
                                    AUDIO_ALLOW_FORMAT_CHANGE     or
                                    AUDIO_ALLOW_CHANNELS_CHANGE   or
                                    AUDIO_ALLOW_SAMPLES_CHANGE

type
  AudioCallback* = proc (userdata: pointer, stream: ptr UncheckedArray[byte],
                         len: cint) {.cdecl, gcsafe, raises: [].}

type
  AudioSpec* {.final, pure.} = object
    freq*       : cint            ##  Frequency (samples per second).
    format*     : AudioFormat     ##  Audio data format.
    channels*   : byte            ##  Number of channels: 1 mono, 2 stereo.
    silence*    : byte            ##  Audio buffer silence value. Calculated.
    samples*    : uint16          ##  Audio buffer size (sample frames -
                                  ##  - total samples / channel count).
    padding     : uint16
    size*       : uint32          ##  Audio buffer size (bytes). Calculated.
    callback*   : AudioCallback   ##  Audio feed callback. Use `nil` in `queue_audio`.
    userdata*   : pointer         ##  User defined pointer.

const
  AUDIOCVT_MAX_FILTERS*   = 9

type
  AudioFilter* = proc (cvt: ptr AudioCVT,
                       format: AudioFormat) {.cdecl, gcsafe, raises: [].}

  AudioCVT* {.final, packed, pure.} = object
    needed*       : cint          ##  Set to 1 if conversion is possible.
    src_format*   : AudioFormat   ##  Source audio format.
    dst_format*   : AudioFormat   ##  Target audio format.
    rate_incr*    : cdouble       ##  Rate conversion increment.
    buf*          : ptr byte      ##  Buffer to hold entire audio data.
    len*          : cint          ##  Original audio buffer length.
    len_cvt*      : cint          ##  Converted audio buffer length.
    len_mult*     : cint          ##  Note: buffer size must be `len` * `len_mult`.
    len_ratio*    : cdouble       ##  Given len, final size is len*len_ratio.
    filters*      : array[AUDIOCVT_MAX_FILTERS + 1, AudioFilter]    ##  Filter
                                  ##  functions list. `nil` terminated.
    filter_index* : cint          ##  Current audio conversion function.

type
  AudioDeviceID* = distinct uint32

func `==`*(a, b: AudioDeviceID): bool {.borrow.}
func `==`*(a: AudioDeviceID, b: uint32): bool {.borrow.}

type
  AudioStatus* {.size: cint.sizeof.} = enum   # XXX: size.
    ##  Audio status.
    AUDIO_STOPPED = 0
    AUDIO_PLAYING
    AUDIO_PAUSED

type
  AudioStream* = ptr object
    ##  Audio stream.

const
  MIX_MAXVOLUME*  = 128

# vim: set sts=2 et sw=2:
