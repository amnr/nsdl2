##  High level SDL 2.0 shared library wrapper for Nim.
##
##  Documentation below comes from SDL 2.0 library documentation.
##
##  Usage
##  -----
##
##  ```nim
##  # Load all symbols from SDL 2.0 shared library.
##  # This must be the first proc called.
##  if not open_sdl2_library():
##    echo "Failed to load SDL 2.0 library: ", last_sdl2_error()
##    quit QuitFailure
##  defer:
##    close_sdl2_library()
##
##  # Initialize SDL 2.0.
##  if not Init INIT_VIDEO:
##    echo "Failed to initialize SDL 2.0: ", GetError()
##    quit QuitFailure
##  defer:
##    Quit()
##
##  # SDL 2.0 calls follow…
##  ```
##
##  Configuration
##  -------------
##
##  You can disable functions you don't use.
##  All function groups are enabled by default.
##
##  | Group           | Define                  | Functions Defined In            |
##  | --------------- | ----------------------- | ------------------------------- |
##  | Audio           | `sdl2.audio=0`          | ``<SDL2/SDL_audio.h>``          |
##  | Blend Mode      | `sdl2.blendmode=0`      | ``<SDL2/SDL_blendmode.h>``      |
##  | Clipboard       | `sdl2.clipboard=0`      | ``<SDL2/SDL_clipboard.h>``      |
##  | Game Controller | `sdl2.gamecontroller=0` | ``<SDL2/SDL_gamecontroller.h>`` |
##  | Gesture         | `sdl2.gesture=0`        | ``<SDL2/SDL_gesture.h>``        |
##  | Haptic          | `sdl2.haptic=0`         | ``<SDL2/SDL_haptic.h>``         |
##  | Hints           | `sdl2.hints=0`          | ``<SDL2/SDL_hints.h>``          |
##  | Joystick        | `sdl2.joystick=0`       | ``<SDL2/SDL_joystick.h>``       |
##  | Keyboard        | `sdl2.keyboard=0`       | ``<SDL2/SDL_keyboard.h>``       |
##  | Mouse           | `sdl2.mouse=0`          | ``<SDL2/SDL_mouse.h>``          |
##  | Sensor          | `sdl2.sensor=0`         | ``<SDL2/SDL_sensor.h>``         |
##  | Shape           | `sdl2.shape=0`          | ``<SDL2/SDL_shape.h>``          |
##  | Touch           | `sdl2.touch=0`          | ``<SDL2/SDL_touch.h>``          |
##
##  For example if you don't need audio functions compile with:
##
##  ```sh
##  nim c -d=sdl2.audio=0 file(s)
##  ```
#[
  SPDX-License-Identifier: NCSA OR MIT OR Zlib
]#

{.push raises: [].}

when defined nimPreviewSlimSystem:
  from std/assertions import assert

import std/options

export options

import nsdl2/config
import nsdl2/libsdl2
import nsdl2/utils

export open_sdl2_library, close_sdl2_library, last_sdl2_error

when use_audio:
  import nsdl2/sdl2inc/sdl2audio
  export sdl2audio
when use_blendmode:
  import nsdl2/sdl2inc/sdl2blendmode
  export sdl2blendmode
import nsdl2/sdl2inc/sdl2events
export sdl2events
when use_hints:
  import nsdl2/sdl2inc/sdl2hints
  export sdl2hints
import nsdl2/sdl2inc/sdl2init
export sdl2init
when use_joystick:
  import nsdl2/sdl2inc/sdl2joystick
  export sdl2joystick
import nsdl2/sdl2inc/sdl2keycode
export sdl2keycode
import nsdl2/sdl2inc/sdl2log
export sdl2log
when use_messagebox:
  import nsdl2/sdl2inc/sdl2messagebox
  export sdl2messagebox
when use_mouse:
  import nsdl2/sdl2inc/sdl2mouse
  export sdl2mouse
import nsdl2/sdl2inc/sdl2pixels
export sdl2pixels
import nsdl2/sdl2inc/sdl2rect
export sdl2rect
import nsdl2/sdl2inc/sdl2render
export sdl2render
import nsdl2/sdl2inc/sdl2rwops
import nsdl2/sdl2inc/sdl2surface
export sdl2surface
import nsdl2/sdl2inc/sdl2timer
export sdl2timer
when use_touch:
  import nsdl2/sdl2inc/sdl2touch
  export sdl2touch
import nsdl2/sdl2inc/sdl2version
import nsdl2/sdl2inc/sdl2video
export sdl2video

# =========================================================================== #
# ==  SDL2 library functions                                               == #
# =========================================================================== #

converter from_sdl_bool(b: SdlBool): bool =
  b.int != 0

converter to_sdl_bool(b: bool): SdlBool =
  b.SdlBool

proc c_free(mem: pointer) {.header: "<stdlib.h>", importc: "free", nodecl.}

# --------------------------------------------------------------------------- #
# <SDL2/SDL.h>                                                                #
# --------------------------------------------------------------------------- #

proc Init*(flags: InitFlags = INIT_VIDEO or INIT_NOPARACHUTE): bool =
  ##  Initialize the SDL library.
  ##
  ##  Original name: `SDL_Init`
  assert SDL_Init != nil, "did you forget to call open_sdl2_library?"
  ensure_zero "SDL_Init":
    SDL_Init flags

proc InitSubSystem*(flags: InitFlags): bool =
  ##  Compatibility function to initialize the SDL library.
  ##
  ##  In SDL2, this function and `Init`_ are interchangeable.
  ##
  ##  Params:
  ##
  ##  - `flags` any of the flags used by `Init`_; see `Init`_
  ##    for details.
  ##
  ##  Returns `true` on success or `false` on failure; call `get_error`_
  ##  for more information.
  ##
  ##  Original name: `SDL_InitSubSystem`
  ensure_zero "SDL_InitSubSystem":
    SDL_InitSubSystem flags

proc Quit*() =
  ##  Clean up all initialized subsystems.
  ##
  ##  You should call this function even if you have already shutdown each
  ##  initialized subsystem with `QuitSubSystem`_. It is safe to call this
  ##  function even in the case of errors in initialization.
  ##
  ##  If you start a subsystem using a call to that subsystem's init function
  ##  (for example `VideoInit`_ instead of `Init`_ or `InitSubSystem`_,
  ##  then you must use that subsystem's quit function (`video_quit`_) to shut
  ##  it down before calling `Quit`_. But generally, you should not be using
  ##  those functions directly anyhow; use `Init`_ instead.
  ##
  ##  You can use this function with atexit() to ensure that it is run when your
  ##  application is shutdown, but it is not wise to do this from a library or
  ##  other dynamically loaded code.
  ##
  ##  Original name: `SDL_Quit`
  SDL_Quit()

proc QuitSubSystem*(flags: InitFlags) {.inline.} =
  ##  Shut down specific SDL subsystems.
  ##
  ##  If you start a subsystem using a call to that subsystem's init function
  ##  (for example `VideoInit`_ instead of `Init`_ or `InitSubSystem`_,
  ##  SDL_QuitSubSystem() and `WasInit`_ will not work. You will need to use
  ##  that subsystem's quit function (`VideoInit`_) directly instead. But
  ##  generally, you should not be using those functions directly anyhow; use
  ##  `Init`_ instead.
  ##
  ##  You still need to call `Quit`_ even if you close all open subsystems
  ##  with `InitSubSystem`_.
  ##
  ##  Params:
  ##  - `flags` - any of the flags used by `Init`_; see `Init`_ for details.
  ##
  ##  Original name: `SDL_QuitSubSystem`
  SDL_QuitSubSystem flags

proc WasInit*(flags: InitFlags = INIT_NONE): InitFlags {.inline.} =
  ##  Get a mask of the specified subsystems which are currently initialized.
  ##
  ##  Params:
  ##  - `flags` - any of the flags used by `Init`_; see `Init`_ for details.
  ##
  ##  Returns a mask of all initialized subsystems if `flags`
  ##  is `INIT_NONE<nsdl2/sdl2inc/init.html#INIT_NONE>`_,
  ##  otherwise it returns the initialization status of the specified subsystems.
  ##
  ##  The return value does not include
  ##  `INIT_NOPARACHUTE<nsdl2/sdl2inc/init.html#INIT_NOPARACHUTE>`_.
  ##
  ##  Original name: `SDL_WasInit`
  SDL_WasInit flags

# --------------------------------------------------------------------------- #
# <SDL2/SDL_audio.h>                                                          #
# --------------------------------------------------------------------------- #

when use_audio:

  proc AudioInit*(driver_name: string): bool =
    ##  ```c
    ##  int SDL_AudioInit(const char *driver_name);
    ##  ```
    ensure_zero "SDL_AudioInit":
      SDL_AudioInit driver_name.cstring

  proc AudioQuit*() {.inline.} =
    ##  ```c
    ##  void SDL_AudioQuit(void);
    ##  ```
    SDL_AudioQuit()

  # int SDL_AudioStreamAvailable(SDL_AudioStream *stream)
  # void SDL_AudioStreamClear(SDL_AudioStream *stream)
  # int SDL_AudioStreamFlush(SDL_AudioStream *stream)
  # int SDL_AudioStreamGet(SDL_AudioStream *stream, void *buf, int len)
  # int SDL_AudioStreamPut(SDL_AudioStream *stream, const void *buf, int len)
  # int SDL_BuildAudioCVT(SDL_AudioCVT *cvt, SDL_AudioFormat src_format,
  #     Uint8 src_channels, int src_rate, SDL_AudioFormat dst_format,
  #     Uint8 dst_channels, int dst_rate)
  # void SDL_ClearQueuedAudio(SDL_AudioDeviceID dev)

  proc CloseAudio*() {.inline.} =
    ##  ```c
    ##  void SDL_CloseAudio(void);
    ##  ```
    SDL_CloseAudio()

  proc CloseAudioDevice*(dev: AudioDeviceID) {.inline.} =
    ##  ```c
    ##  void SDL_CloseAudioDevice(SDL_AudioDeviceID dev);
    ##  ```
    SDL_CloseAudioDevice dev

  # int SDL_ConvertAudio(SDL_AudioCVT *cvt)
  # Uint32 SDL_DequeueAudio(SDL_AudioDeviceID dev, void *data, Uint32 len)
  # void SDL_FreeAudioStream(SDL_AudioStream *stream)

  proc FreeWAV*(audio_buf: ptr UncheckedArray[byte]) {.inline.} =
    ##  ```c
    ##  void SDL_FreeWAV(Uint8 *audio_buf);
    ##  ```
    SDL_FreeWAV audio_buf

  proc GetAudioDeviceName*(index: int, iscapture: bool): string {.inline.} =
    ##  ```c
    ##  const char *SDL_GetAudioDeviceName(int index, int iscapture);
    ##  ```
    $SDL_GetAudioDeviceName(index.cint, iscapture.cint)

  proc GetAudioDeviceSpec*(index: int, iscapture: bool,
                           spec: var AudioSpec): bool =
    ##  ```c
    ##  int SDL_GetAudioDeviceSpec(int index, int iscapture, SDL_AudioSpec *spec);
    ##  ```
    available_since SDL_GetAudioDeviceSpec, "2.0.16"
    ensure_zero "SDL_GetAudioDeviceSpec":
      SDL_GetAudioDeviceSpec index.cint, iscapture.cint, spec.addr

  proc GetAudioDeviceStatus*(dev: AudioDeviceID): AudioStatus {.inline.} =
    ##  ```c
    ##  SDL_AudioStatus SDL_GetAudioDeviceStatus(SDL_AudioDeviceID dev);
    ##  ```
    SDL_GetAudioDeviceStatus dev

  proc GetAudioDriver*(index: int): string =
    ##  ```c
    ##  const char* SDL_GetAudioDriver(int index);
    ##  ```
    let name = SDL_GetAudioDriver index.cint
    if name == nil:
      log_error "SDL_GetAudioDriver failed: " & $SDL_GetError()
      return ""
    $name

  proc GetAudioStatus*(): AudioStatus {.inline.} =
    ##  ```c
    ##  SDL_AudioStatus SDL_GetAudioStatus(void);
    ##  ```
    SDL_GetAudioStatus()

  proc GetCurrentAudioDriver*(): string {.inline.} =
    ##  ```c
    ##  const char* SDL_GetCurrentAudioDriver(void);
    ##  ```
    $SDL_GetCurrentAudioDriver()

  proc GetDefaultAudioInfo*(name: var string, spec: var AudioSpec,
                            iscapture: bool): bool =
    ##  ```c
    ##  int SDL_GetDefaultAudioInfo(char **name, SDL_AudioSpec *spec, int iscapture);
    ##  ```
    ##
    ##  Since SDL 2.24.0.
    available_since SDL_GetQueuedAudioSize, "2.0.4"
    var outname: cstring = nil
    ensure_zero "SDL_GetDefaultAudioInfo":
      SDL_GetDefaultAudioInfo outname.addr, spec.addr, iscapture.cint
    name = ""
    if outname != nil:
      name = $outname
      c_free outname

  proc GetNumAudioDevices*(iscapture: bool): int {.inline.} =
    ##  ```c
    ##  int SDL_GetNumAudioDevices(int iscapture);
    ##  ```
    SDL_GetNumAudioDevices iscapture.cint

  proc GetNumAudioDrivers*(): int {.inline.} =
    ##  ```c
    ##  int SDL_GetNumAudioDrivers(void);
    ##  ```
    SDL_GetNumAudioDrivers()

  proc GetQueuedAudioSize*(dev: AudioDeviceID): uint32 =
    ##  ```c
    ##  Uint32 SDL_GetQueuedAudioSize(SDL_AudioDeviceID dev);
    ##  ```
    available_since SDL_GetQueuedAudioSize, "2.0.4"
    SDL_GetQueuedAudioSize dev

  proc LoadWAV_RW*(src: RWops, freesrc: bool, spec: var AudioSpec,
                   audio_buf: var ptr UncheckedArray[byte],
                   audio_len: var uint32): ptr AudioSpec =
    ##  ```c
    ##  SDL_AudioSpec *
    ##  SDL_LoadWAV_RW(SDL_RWops *src, int freesrc, SDL_AudioSpec *spec,
    ##                 Uint8 ** audio_buf, Uint32 *audio_len);
    ##  ```
    ensure_not_nil "SDL_LoadWAV_RW":
      SDL_LoadWAV_RW src, freesrc.cint, spec.addr, audio_buf.addr,
                     audio_len.addr

  proc LoadWAV_RW_unchecked(src: RWops, freesrc: bool, spec: var AudioSpec,
                            audio_buf: var ptr UncheckedArray[byte],
                            audio_len: var uint32): ptr AudioSpec =
    ##  ##  Unchecked version. Used by `load_wav` not to generate multiple errors
    ##  such as:
    ##    - SDL_RWFromFile failed: Couldn't open test.wav
    ##    - SDL_LoadWAV_RW failed: Parameter 'src' is invalid
    ##
    ##  ```c
    ##  SDL_AudioSpec *
    ##  SDL_LoadWAV_RW(SDL_RWops *src, int freesrc, SDL_AudioSpec *spec,
    ##                 Uint8 ** audio_buf, Uint32 *audio_len);
    ##  ```
    SDL_LoadWAV_RW src, freesrc.cint, spec.addr, audio_buf.addr, audio_len.addr

  # void SDL_LockAudio(void)
  # void SDL_LockAudioDevice(SDL_AudioDeviceID dev)

  proc MixAudio*(dst: ptr UncheckedArray[byte],
                 src: ptr byte or ptr UncheckedArray[byte],
                 len: uint32, volume: int) =
    ##  ```c
    ##  void SDL_MixAudio(Uint8 *dst, const Uint8 *src, Uint32 len, int volume);
    ##  ```
    SDL_MixAudio(dst, src, len, volume.cint)

  # void SDL_MixAudioFormat(Uint8 *dst, const Uint8 *src,
  #     SDL_AudioFormat format, Uint32 len, int volume)
  # SDL_AudioStream * SDL_NewAudioStream(const SDL_AudioFormat src_format,
  #     const Uint8 src_channels, const int src_rate,
  #     const SDL_AudioFormat dst_format, const Uint8 dst_channels,
  #     const int dst_rate)

  proc OpenAudio*(desired: var AudioSpec): bool =
    ##  ```c
    ##  int SDL_OpenAudio(SDL_AudioSpec * desired, SDL_AudioSpec * obtained);
    ##  ```
    ensure_zero "SDL_OpenAudio":
      SDL_OpenAudio desired.addr, nil

  proc OpenAudio*(desired: AudioSpec, obtained: var AudioSpec): bool =
    ##  ```c
    ##  int SDL_OpenAudio(SDL_AudioSpec * desired, SDL_AudioSpec * obtained);
    ##  ```
    when NimMajor < 2:
      var desired = desired
    ensure_zero "SDL_OpenAudio":
      SDL_OpenAudio desired.addr, obtained.addr

  proc OpenAudioDevice*(device: string, iscapture: bool, desired: AudioSpec,
                        obtained: var AudioSpec,
                        allowed_changes = AudioAllowFlags 0): AudioDeviceID =
    ##  ```c
    ##  SDL_AudioDeviceID
    ##  SDL_OpenAudioDevice(const char *device, int iscapture,
    ##                      const SDL_AudioSpec *desired,
    ##                      SDL_AudioSpec *obtained, int allowed_changes);
    ##  ```
    let device_ptr = if device != "": device.cstring else: nil
    when NimMajor < 2:
      var desired = desired
    result = SDL_OpenAudioDevice(device_ptr, iscapture.cint,
                                         desired.addr, obtained.addr,
                                         allowed_changes)
    if result.uint32 == 0:
      log_error "SDL_OpenAudioDevice failed: ", $SDL_GetError()

  proc OpenAudioDevice*(device: string, iscapture: bool, desired: AudioSpec,
                        allowed_changes = AudioAllowFlags 0): AudioDeviceID =
    ##  ```c
    ##  SDL_AudioDeviceID
    ##  SDL_OpenAudioDevice(const char *device, int iscapture,
    ##                      const SDL_AudioSpec *desired,
    ##                      SDL_AudioSpec *obtained, int allowed_changes);
    ##  ```
    let device_ptr = if device != "": device.cstring else: nil
    when NimMajor < 2:
      var desired = desired
    result = SDL_OpenAudioDevice(device_ptr, iscapture.cint,
                                         desired.addr, nil, allowed_changes)
    if result.uint32 == 0:
      log_error "SDL_OpenAudioDevice failed: ", SDL_GetError()

  proc PauseAudio*(pause_on: bool) {.inline.} =
    SDL_PauseAudio pause_on.cint

  proc PauseAudioDevice*(dev: AudioDeviceID, pause_on: bool) {.inline.} =
    ##  ```c
    ##  void SDL_PauseAudioDevice(SDL_AudioDeviceID dev, int pause_on);
    ##  ```
    SDL_PauseAudioDevice dev, pause_on.cint

  proc QueueAudio*(dev: AudioDeviceID, data: pointer, len: uint32): bool =
    ##  ```c
    ##  int SDL_QueueAudio(SDL_AudioDeviceID dev, const void *data, Uint32 len);
    ##  ```
    available_since SDL_QueueAudio, "2.0.4"
    ensure_zero "SDL_QueueAudio":
      SDL_QueueAudio dev, data, len

  # void SDL_UnlockAudio(void)
  # void SDL_UnlockAudioDevice(SDL_AudioDeviceID dev)

# --------------------------------------------------------------------------- #
# <SDL2/SDL_blendmode.h>                                                      #
# --------------------------------------------------------------------------- #

# SDL_BlendMode SDL_ComposeCustomBlendMode(SDL_BlendFactor srcColorFactor,
#     SDL_BlendFactor dstColorFactor, SDL_BlendOperation colorOperation,
#     SDL_BlendFactor srcAlphaFactor, SDL_BlendFactor dstAlphaFactor,
#     SDL_BlendOperation alphaOperation)

# --------------------------------------------------------------------------- #
# <SDL2/SDL_clipboard.h>                                                      #
# --------------------------------------------------------------------------- #

when use_clipboard:

  proc GetClipboardText*(): string =
    ##  Get UTF-8 text from the clipboard.
    ##
    ##  .. note::
    ##    Unlike `SDL_GetClipboardText`, the text returned by
    ##    `get_clipboard_text` must not be freed with `sdl_free`.
    ##
    ##  ```c
    ##  char * SDL_GetClipboardText(void);
    ##  ```
    let text = SDL_GetClipboardText()
    result = $text
    c_free text

  # char * SDL_GetPrimarySelectionText(void)
  # SDL_bool SDL_HasClipboardText(void)
  # SDL_bool SDL_HasPrimarySelectionText(void)

  proc SetClipboardText*(text: string): bool =
    ##  ```c
    ##  int SDL_SetClipboardText(const char *text);
    ##  ```
    ensure_zero "SDL_SetClipboardText":
      SDL_SetClipboardText text.cstring

  # int SDL_SetPrimarySelectionText(const char *text)

# --------------------------------------------------------------------------- #
# <SDL2/SDL_error.h>                                                          #
# --------------------------------------------------------------------------- #

proc ClearError*() {.inline.} =
  ##  ```c
  ##  void SDL_ClearError(void);
  ##  ```
  SDL_ClearError()

# int SDL_Error(SDL_errorcode code)

proc GetError*(): string {.inline.} =
  ##  ```c
  ##  const char *SDL_GetError(void);
  ##  ```
  assert SDL_GetError != nil
  $SDL_GetError()

# char * SDL_GetErrorMsg(char *errstr, int maxlen)

proc SetError*(msg: string): bool {.discardable, inline.} =
  ##  ```
  ##  int SDL_SetError(const char *fmt, ...);
  ##  ```
  discard SDL_SetError("%s".cstring, msg.cstring)
  false

# --------------------------------------------------------------------------- #
# <SDL2/SDL_events.h>                                                         #
# --------------------------------------------------------------------------- #

proc free_drop_event_file*(event: var Event) =
  ##  Free memory allocated for ``EVENT_DROPFILE`` and ``EVENT_DROPTEXT``.
  if event.typ == EVENT_DROPFILE or event.typ == EVENT_DROPTEXT:
    if event.drop.file != nil:
      c_free event.drop.file
      event.drop.file = nil       # Just in case.

# void SDL_AddEventWatch(SDL_EventFilter filter, void *userdata)
# void SDL_DelEventWatch(SDL_EventFilter filter, void *userdata)

proc EventState*(typ: EventType, state: bool): bool {.discardable, inline.} =
  ##  Set the state of processing events.
  ##
  ##  Return `true` if the event was enable prior calling this function,
  ##  `false` otherwise.
  ##
  ##  ```c
  ##  Uint8 SDL_EventState(Uint32 type, int state);
  ##  ```
  SDL_EventState(typ, state.cint) == ENABLE.byte

# void SDL_FilterEvents(SDL_EventFilter filter, void *userdata)

proc FlushEvent*(typ: EventType) {.inline.} =
  ##  ```c
  ##  void SDL_FlushEvent(Uint32 type);
  ##  ```
  SDL_FlushEvent typ

proc FlushEvents*(min_type, max_type: EventType) {.inline.} =
  ##  ```c
  ##  void SDL_FlushEvents(Uint32 min_type, Uint32 max_type);
  ##  ```
  SDL_FlushEvents min_type, max_type

# SDL_bool SDL_GetEventFilter(SDL_EventFilter *filter, void **userdata)
# SDL_bool SDL_HasEvent(Uint32 type)
# SDL_bool SDL_HasEvents(Uint32 minType, Uint32 maxType)

proc PeepEvents*(events: var openArray[Event], numevents: int,
                 action: EventAction, min_type: EventType,
                 max_type: EventType): int =
  ##  ```c
  ##  int SDL_PeepEvents(SDL_Event *events, int numevents,
  ##                     SDL_eventaction action, Uint32 minType,
  ##                     Uint32 maxType);
  ##  ```
  let num_events = cint min(numevents, events.len)
  result = SDL_PeepEvents(events[0].addr, num_events, action, min_type,
                          max_type)
  if result < 0:
    log_error "SDL_PeepEvents failed: ", $SDL_GetError()

proc PeepEvents*(events: var openArray[Event], action: EventAction,
                 min_type: EventType, max_type: EventType): int {.inline.} =
  PeepEvents events, action, min_type, max_type

proc PollEvent*(): bool {.inline.} =
  ##  ```c
  ##  int SDL_PollEvent(SDL_Event *event);
  ##  ```
  SDL_PollEvent(nil) != 0

proc PollEvent*(event: var Event): bool {.inline.} =
  ##  ```c
  ##  int SDL_PollEvent(SDL_Event *event);
  ##  ```
  SDL_PollEvent(event.addr) != 0

proc PumpEvents*() {.inline.} =
  ##  ```c
  ##  void SDL_PumpEvents(void);
  ##  ```
  SDL_PumpEvents()

proc PushEvent*(event: var Event): bool {.discardable, inline.} =
  ##  ```c
  ##  int SDL_PushEvent(SDL_Event *event);
  ##  ```
  SDL_PushEvent(event.addr) != 0

# Uint32 SDL_RegisterEvents(int numevents)
# void SDL_SetEventFilter(SDL_EventFilter filter, void *userdata)

proc WaitEvent*(): bool {.inline.} =
  ##  ```c
  ##  int SDL_WaitEvent(SDL_Event *event);
  ##  ```
  SDL_WaitEvent(nil) != 0

proc WaitEvent*(event: var Event): bool {.inline.} =
  ##  ```c
  ##  int SDL_WaitEvent(SDL_Event *event);
  ##  ```
  SDL_WaitEvent(event.addr) != 0

proc WaitEventTimeout*(timeout: int): bool {.inline.} =
  ##  ```c
  ##  int SDL_WaitEventTimeout(SDL_Event *event, int timeout);
  ##  ```
  SDL_WaitEventTimeout(nil, timeout.cint) != 0

proc WaitEventTimeout*(event: var Event, timeout: int): bool {.inline.} =
  ##  ```c
  ##  int SDL_WaitEventTimeout(SDL_Event *event, int timeout);
  ##  ```
  SDL_WaitEventTimeout(event.addr, timeout.cint) != 0

# --------------------------------------------------------------------------- #
# <SDL2/SDL_gamecontroller.h>                                                 #
# --------------------------------------------------------------------------- #

# TODO.
# SDL_GameControllerAddMapping(const char* mappingString)
# int SDL_GameControllerAddMappingsFromRW(SDL_RWops * rw, int freerw)
# void SDL_GameControllerClose(SDL_GameController *gamecontroller)
# int SDL_GameControllerEventState(int state)
# SDL_GameController *SDL_GameControllerFromInstanceID(SDL_JoystickID joyid)
# SDL_GameController *SDL_GameControllerFromPlayerIndex(int player_index)
# const char* SDL_GameControllerGetAppleSFSymbolsNameForAxis(SDL_GameController *gamecontroller, SDL_GameControllerAxis axis)
# const char* SDL_GameControllerGetAppleSFSymbolsNameForButton(SDL_GameController *gamecontroller, SDL_GameControllerButton button)
# SDL_bool SDL_GameControllerGetAttached(SDL_GameController *gamecontroller)
# Sint16 SDL_GameControllerGetAxis(SDL_GameController *gamecontroller, SDL_GameControllerAxis axis)
# SDL_GameControllerAxis SDL_GameControllerGetAxisFromString(const char *str)
# SDL_GameControllerButtonBind SDL_GameControllerGetBindForAxis(SDL_GameController *gamecontroller, SDL_GameControllerAxis axis)
# SDL_GameControllerButtonBind SDL_GameControllerGetBindForButton(SDL_GameController *gamecontroller, SDL_GameControllerButton button)
# Uint8 SDL_GameControllerGetButton(SDL_GameController *gamecontroller, SDL_GameControllerButton button)
# SDL_GameControllerButton SDL_GameControllerGetButtonFromString(const char *str)
# Uint16 SDL_GameControllerGetFirmwareVersion(SDL_GameController *gamecontroller)
# SDL_Joystick *SDL_GameControllerGetJoystick(SDL_GameController *gamecontroller)
# int SDL_GameControllerGetNumTouchpadFingers(SDL_GameController *gamecontroller, int touchpad)
# int SDL_GameControllerGetNumTouchpads(SDL_GameController *gamecontroller)
# int SDL_GameControllerGetPlayerIndex(SDL_GameController *gamecontroller)
# Uint16 SDL_GameControllerGetProduct(SDL_GameController *gamecontroller)
# Uint16 SDL_GameControllerGetProductVersion(SDL_GameController *gamecontroller)
# int SDL_GameControllerGetSensorData(SDL_GameController *gamecontroller, SDL_SensorType type, float *data, int num_values)
# float SDL_GameControllerGetSensorDataRate(SDL_GameController *gamecontroller, SDL_SensorType type)
# int SDL_GameControllerGetSensorDataWithTimestamp(SDL_GameController *gamecontroller, SDL_SensorType type, Uint64 *timestamp, float *data, int num_values)
# const char * SDL_GameControllerGetSerial(SDL_GameController *gamecontroller)
# const char* SDL_GameControllerGetStringForAxis(SDL_GameControllerAxis axis)
# const char* SDL_GameControllerGetStringForButton(SDL_GameControllerButton button)
# int SDL_GameControllerGetTouchpadFinger(SDL_GameController *gamecontroller, int touchpad, int finger, Uint8 *state, float *x, float *y, float *pressure)
# SDL_GameControllerType SDL_GameControllerGetType(SDL_GameController *gamecontroller)
# Uint16 SDL_GameControllerGetVendor(SDL_GameController *gamecontroller)
# SDL_bool SDL_GameControllerHasAxis(SDL_GameController *gamecontroller, SDL_GameControllerAxis axis)
# SDL_bool SDL_GameControllerHasButton(SDL_GameController *gamecontroller, SDL_GameControllerButton button)
# SDL_bool SDL_GameControllerHasLED(SDL_GameController *gamecontroller)
# SDL_bool SDL_GameControllerHasRumble(SDL_GameController *gamecontroller)
# SDL_bool SDL_GameControllerHasRumbleTriggers(SDL_GameController *gamecontroller)
# SDL_bool SDL_GameControllerHasSensor(SDL_GameController *gamecontroller, SDL_SensorType type)
# SDL_bool SDL_GameControllerIsSensorEnabled(SDL_GameController *gamecontroller, SDL_SensorType type)
# char * SDL_GameControllerMapping(SDL_GameController *gamecontroller)
# char *SDL_GameControllerMappingForDeviceIndex(int joystick_index)
# char * SDL_GameControllerMappingForGUID(SDL_JoystickGUID guid)
# char * SDL_GameControllerMappingForIndex(int mapping_index)
# const char *SDL_GameControllerName(SDL_GameController *gamecontroller)
# const char *SDL_GameControllerNameForIndex(int joystick_index)
# int SDL_GameControllerNumMappings(void)
# SDL_GameController *SDL_GameControllerOpen(int joystick_index)
# const char *SDL_GameControllerPath(SDL_GameController *gamecontroller)
# const char *SDL_GameControllerPathForIndex(int joystick_index)
# int SDL_GameControllerRumble(SDL_GameController *gamecontroller, Uint16 low_frequency_rumble, Uint16 high_frequency_rumble, Uint32 duration_ms)
# int SDL_GameControllerRumbleTriggers(SDL_GameController *gamecontroller, Uint16 left_rumble, Uint16 right_rumble, Uint32 duration_ms)
# int SDL_GameControllerSendEffect(SDL_GameController *gamecontroller, const void *data, int size)
# int SDL_GameControllerSetLED(SDL_GameController *gamecontroller, Uint8 red, Uint8 green, Uint8 blue)
# void SDL_GameControllerSetPlayerIndex(SDL_GameController *gamecontroller, int player_index)
# int SDL_GameControllerSetSensorEnabled(SDL_GameController *gamecontroller, SDL_SensorType type, SDL_bool enabled)
# SDL_GameControllerType SDL_GameControllerTypeForIndex(int joystick_index)
# void SDL_GameControllerUpdate(void)
# SDL_bool SDL_IsGameController(int joystick_index)

# --------------------------------------------------------------------------- #
# <SDL2/SDL_gesture.h>                                                        #
# --------------------------------------------------------------------------- #

# TODO.
# int SDL_LoadDollarTemplates(SDL_TouchID touchId, SDL_RWops *src);
# int SDL_RecordGesture(SDL_TouchID touchId);
# int SDL_SaveAllDollarTemplates(SDL_RWops *dst);
# int SDL_SaveDollarTemplate(SDL_GestureID gestureId,SDL_RWops *dst);

# --------------------------------------------------------------------------- #
# <SDL2/SDL_haptic.h>                                                         #
# --------------------------------------------------------------------------- #

# TODO.

# --------------------------------------------------------------------------- #
# <SDL2/SDL_hints.h>                                                          #
# --------------------------------------------------------------------------- #

when use_hints:

  # void SDL_AddHintCallback(const char *name, SDL_HintCallback callback,
  #     void *userdata)
  # void SDL_ClearHints(void)
  # void SDL_DelHintCallback(const char *name, SDL_HintCallback callback,
  #     void *userdata)

  proc GetHint*(name: HintName): string {.inline.} =
    ##  ```c
    ##  const char * SDL_GetHint(const char *name);
    ##  ```
    $SDL_GetHint name

  # SDL 2.0.5
  # SDL_bool SDL_GetHintBoolean(const char *name, SDL_bool default_value)

  # SDL 2.24.0
  # SDL_bool SDL_ResetHint(const char *name)

  # SDL 2.26.0
  # void SDL_ResetHints(void)

  proc SetHint*(name: HintName, value: string): bool {.inline.} =
    ##  ```c
    ##  ```
    SDL_SetHint(cstring $name, value.cstring)

  # SDL_bool SDL_SetHintWithPriority(const char *name, const char *value,
  #     SDL_HintPriority priority)

# --------------------------------------------------------------------------- #
# <SDL2/SDL_joystick.h>                                                       #
# --------------------------------------------------------------------------- #

when use_joystick:

  proc JoystickClose*(joystick: Joystick) {.inline.} =
    ##  Close a joystick previously opened with `open_joystick`.
    ##
    ##  Available since SDL 2.0.0.
    ##
    ##  See: `SDL_JoystickClose`
    SDL_JoystickClose joystick

  # XXX: print error on zero guid
  proc JoystickGetGUID*(joystick: Joystick): JoystickGUID =
    ##  Get the implementation-dependent GUID for the joystick.
    ##
    ##  Returns the GUID of the given joystick. If called on an invalid index, this function returns a zero GUID; call `get_error() <#get_error,string>`_ for more information.
    SDL_JoystickGetGUID joystick

  proc JoystickGetGUIDString*(guid: JoystickGUID): string =
    ##  Get an ASCII string representation for a given `JoystickGUID`.
    ##
    ##  See: `SDL_JoystickGetGUIDString <https://wiki.libsdl.org/SDL2/SDL_JoystickGetGUIDString>`_.
    var buf: array[33, char]    # 32 bytes for GUI + null terminator.
    SDL_JoystickGetGUIDString guid, buf[0].addr, buf.len.cint
    $cast[cstring](buf[0].addr)

  proc JoystickGetGUIDString*(joystick: Joystick): string =
    JoystickGetGUIDString JoystickGetGUID joystick

  proc JoystickGetDeviceProduct*(device_index: cint): uint16 =
    ##  Get the USB product ID of a joystick, if available.
    ##
    ##  Returns the USB product ID of the selected joystick. If called on an invalid index, this function returns zero.
    ##  Returns 0 on SDL prior to 2.0.6.
    ##
    ##  Available since SDL 2.0.6.
    ##
    ##  .. note::
    ##    This can be called before any joysticks are opened. If the product ID isn't available this function returns 0.
    ##
    ##  See: `SDL_JoystickGetDeviceProduct <https://wiki.libsdl.org/SDL2/SDL_JoystickGetDeviceProduct>`_
    available_since SDL_JoystickGetDeviceProduct, "2.0.6"
    SDL_JoystickGetDeviceProduct device_index

  proc JoystickGetDeviceVendor*(device_index: cint): uint16 =
    ##  Get the USB vendor ID of a joystick, if available.
    ##
    ##  Returns the USB vendor ID of the selected joystick. If called on an invalid index, this function returns zero.
    ##
    ##  Available since SDL 2.0.6.
    ##
    ##  .. note::
    ##    This can be called before any joysticks are opened. If the vendor ID isn't available this function returns 0.
    ##
    ##  See: `SDL_JoystickGetDeviceVendor <https://wiki.libsdl.org/SDL2/SDL_JoystickGetDeviceVendor>`_
    available_since SDL_JoystickGetDeviceVendor, "2.0.6"
    SDL_JoystickGetDeviceVendor device_index

  proc JoystickGetProduct*(joystick: Joystick): uint16 =
    ##  Get the USB product ID of a joystick, if available.
    ##
    ##  Returns the USB product ID of the selected joystick. If called
    ##  on an invalid index, this function returns zero.
    ##  Returns 0 on SDL prior to 2.0.6.
    ##
    ##  Available since SDL 2.0.6.
    available_since SDL_JoystickGetProduct, "2.0.6"
    SDL_JoystickGetProduct joystick

  # XXX: distinguish between no serial and error
  proc JoystickGetSerial*(joystick: Joystick): string =
    ##  Get the serial number of an opened joystick, if available.
    ##
    ##  Returns the serial number of the selected joystick, or "" if unavailable.
    ##  Returns "" on SDL prior to 2.0.14.
    ##
    ##  Available since SDL 2.0.14.
    ##
    ##  See: `SDL_JoystickGetSerial <https://wiki.libsdl.org/SDL2/SDL_JoystickGetSerial>`_.
    available_since SDL_JoystickGetSerial, "2.0.14"
    $SDL_JoystickGetSerial joystick

  proc JoystickGetType*(joystick: Joystick): JoystickType =
    ##  Get the type of an opened joystick.
    ##
    ##  Returns the `JoystickType <sdl2inc/joystick.html#JoystickType>`
    ##  of the selected joystick.
    ##  Returns `JOYSTICK_TYPE_UNKNOWN <sdl2inc/joystick#JoystickType,JOYSTICK_TYPE_UNKNOWN>` on SDL prior to 2.0.6.
    ##
    ##  Available since SDL 2.0.6.
    ##
    ##  See: `SDL_JoystickGetType <https://wiki.libsdl.org/SDL2/SDL_JoystickGetType>`_.
    available_since SDL_JoystickGetType, "2.0.6"    # XXX: , JOYSTICK_TYPE_UNKNOWN
    SDL_JoystickGetType joystick

  proc JoystickGetVendor*(joystick: Joystick): uint16 =
    ##  Get the USB vendor ID of an opened joystick, if available.
    ##
    ##  Returns the USB vendor ID of the selected joystick, or 0 if unavailable.
    ##
    ##  Available since SDL 2.0.6.
    ##
    ##  See: `SDL_JoystickGetVendor <https://wiki.libsdl.org/SDL2/SDL_JoystickGetVendor>`_.
    available_since SDL_JoystickGetVendor, "2.0.6"
    SDL_JoystickGetVendor joystick

  proc JoystickHasLED*(joystick: Joystick): bool =
    ##  Query whether a joystick has an LED.
    ##
    ##  Return `true` if the joystick has a modifiable LED, `false` otherwise.
    ##  Returns `false` on SDL prior to 2.0.14.
    ##
    ##  Available since SDL 2.0.14.
    ##
    ##  See: `SDL_JoystickHasLED <https://wiki.libsdl.org/SDL2/SDL_JoystickHasLED>`_.
    available_since SDL_JoystickHasLED, "2.0.14"
    SDL_JoystickHasLED joystick

  proc JoystickHasRumble*(joystick: Joystick): bool =
    ##  Query whether a joystick has rumble support.
    ##
    ##  Return `true` if the joystick has rumble, `false` otherwise.
    ##  Returns `false` on SDL prior to 2.0.18.
    ##
    ##  Available since SDL 2.0.18.
    ##
    ##  See: `SDL_JoystickHasRumble <https://wiki.libsdl.org/SDL2/SDL_JoystickHasRumble>`_.
    available_since SDL_JoystickHasRumble, "2.0.18"
    SDL_JoystickHasRumble joystick

  proc JoystickHasRumbleTriggers*(joystick: Joystick): bool =
    ##  Query whether a joystick has rumble support on triggers.
    ##
    ##  Return `true` if the joystick has trigger rumble, `false` otherwise.
    ##  Returns `false` on SDL prior to 2.0.18.
    ##
    ##  Available since SDL 2.0.18.
    ##
    ##  See: `SDL_JoystickHasRumbleTriggers <https://wiki.libsdl.org/SDL2/SDL_JoystickHasRumbleTriggers>`_.
    available_since SDL_JoystickHasRumbleTriggers, "2.0.18"
    SDL_JoystickHasRumbleTriggers joystick

  proc JoystickName*(joystick: Joystick): string =
    ##  Get the implementation dependent name of a joystick.
    ##
    ##  Available since SDL 2.0.0.
    ##
    ##  Returns the name of the selected joystick. If no name can be found, this function returns ""; call `get_error() <#get_error,string>`_ for more information.
    let name = SDL_JoystickName joystick
    if name == nil:
      log_error "SDL_JoystickName failed: ", SDL_GetError()
    $name

  # XXX: Result[int]?
  proc JoystickNumAxes*(joystick: Joystick): int =
    ##  Get the number of general axis controls on a joystick.
    ##
    ##  Returns the number of axis controls/number of axes on success
    ##  or a negative error code on failure; call `get_error() <#get_error,string>`_ for more information.
    ##
    ##  Available since SDL 2.0.0.
    ##
    ##  See: `SDL_JoystickNumAxes <https://wiki.libsdl.org/SDL2/SDL_JoystickNumAxes>`_
    ensure_natural "SDL_JoystickNumAxes":
      SDL_JoystickNumAxes joystick

  # XXX: Result[int]?
  proc JoystickNumBalls*(joystick: Joystick): int =
    ##  Get the number of trackballs on a joystick.
    ##
    ##  Returns the number of trackballs on success or a negative error code
    ##  on failure; call `get_error() <#get_error,string>`_ for more information.
    ##
    ##  Available since SDL 2.0.0.
    ##
    ##  See `SDL_JoystickNumBalls <https://wiki.libsdl.org/SDL2/SDL_JoystickNumBalls>`_
    ensure_natural "SDL_JoystickNumBalls":
      SDL_JoystickNumBalls joystick

  # XXX: Result[int]?
  proc JoystickNumButtons*(joystick: Joystick): int =
    ##  Get the number of buttons on a joystick.
    ##
    ##  Returns the number of buttons on success or a negative error code
    ##  on failure; call `get_error() <#get_error,string>`_ for more information.
    ##
    ##  Available since SDL 2.0.0.
    ##
    ##  See `SDL_JoystickNumButtons <https://wiki.libsdl.org/SDL2/SDL_JoystickNumButtons>`_
    ensure_natural "SDL_JoystickNumButtons":
      SDL_JoystickNumButtons joystick

  # XXX: Result[int]?
  proc JoystickNumHats*(joystick: Joystick): int =
    ##  Get the number of POV hats on a joystick.
    ##
    ##  Returns the number of POV hats on success or a negative error code
    ##  on failure; call `get_error() <#get_error,string>`_ for more information.
    ##
    ##  Available since SDL 2.0.0.
    ##
    ##  See: `SDL_JoystickNumHats <https://wiki.libsdl.org/SDL2/SDL_JoystickNumHats>`_
    ensure_natural "SDL_JoystickNumHats":
      SDL_JoystickNumHats joystick

  proc JoystickOpen*(device_index: int): Joystick =
    ##  Open a joystick for use.
    ##
    ##  Returns a joystick identifier or `nil` if an error occurred.
    ##
    ##  Available since SDL 2.0.0.
    ##
    ##  See: `SDL_JoystickOpen`
    ensure_not_nil "SDL_JoystickOpen":
      SDL_JoystickOpen device_index.cint

  proc JoystickPath*(joystick: Joystick): string {.inline.} =
    ##  Get the implementation dependent path of a joystick.
    ##
    ##  Returns the path of the selected joystick. If no path can be found, this function returns `nil`; call `get_error() <#get_error,string>`_ for more information.
    ##  Returns `""` on SDL prior to 2.24.0.
    ##
    ##  Available since SDL 2.24.0.
    ##
    ##  See: `SDL_JoystickPath`
    available_since SDL_JoystickPath, "2.24.0"
    let path = SDL_JoystickPath joystick
    if path == nil:
      log_error "SDL_JoystickPath failed: ", SDL_GetError()
    $path

  proc JoystickUpdate*() {.inline.} =
    ##  Update the current state of the open joysticks.
    ##
    ##  .. note::
    ##    This is called automatically by the event loop if any joystick events are enabled.
    ##
    ##  Available since SDL 2.0.0.
    ##
    ##  See: `SDL_JoystickUpdate`
    SDL_JoystickUpdate()

  # void SDL_LockJoysticks(void) SDL_ACQUIRE(SDL_joystick_lock);

  proc NumJoysticks*(): int =
    ##  Count the number of joysticks attached to the system.
    ##
    ##  Returns the number of attached joysticks on success or a negative error
    ##  code on failure; call `get_error() <#get_error,string>`_ for more information.
    ##
    ##  Available since SDL 2.0.0.
    ##
    ##  See: `SDL_NumJoysticks`
    ensure_natural "SDL_NumJoysticks":
      SDL_NumJoysticks()

  # void SDL_GetJoystickGUIDInfo(SDL_JoystickGUID guid, Uint16 *vendor, Uint16 *product, Uint16 *version, Uint16 *crc16);
  # int SDL_JoystickAttachVirtual(SDL_JoystickType type,
  # int SDL_JoystickAttachVirtualEx(const SDL_VirtualJoystickDesc *desc);
  # SDL_JoystickPowerLevel SDL_JoystickCurrentPowerLevel(SDL_Joystick *joystick);
  # int SDL_JoystickDetachVirtual(int device_index);
  # int SDL_JoystickEventState(int state);
  # SDL_Joystick *SDL_JoystickFromInstanceID(SDL_JoystickID instance_id);
  # SDL_Joystick *SDL_JoystickFromPlayerIndex(int player_index);
  # SDL_bool SDL_JoystickGetAttached(SDL_Joystick *joystick);
  # Sint16 SDL_JoystickGetAxis(SDL_Joystick *joystick,
  # SDL_bool SDL_JoystickGetAxisInitialState(SDL_Joystick *joystick,
  # int SDL_JoystickGetBall(SDL_Joystick *joystick,
  # Uint8 SDL_JoystickGetButton(SDL_Joystick *joystick,
  # SDL_JoystickGUID SDL_JoystickGetDeviceGUID(int device_index);
  # SDL_JoystickID SDL_JoystickGetDeviceInstanceID(int device_index);
  # int SDL_JoystickGetDevicePlayerIndex(int device_index);
  # Uint16 SDL_JoystickGetDeviceProduct(int device_index);
  # Uint16 SDL_JoystickGetDeviceProductVersion(int device_index);
  # SDL_JoystickType SDL_JoystickGetDeviceType(int device_index);
  # Uint16 SDL_JoystickGetDeviceVendor(int device_index);
  # Uint16 SDL_JoystickGetFirmwareVersion(SDL_Joystick *joystick);
  # SDL_JoystickGUID SDL_JoystickGetGUID(SDL_Joystick *joystick);
  # SDL_JoystickGUID SDL_JoystickGetGUIDFromString(const char *pchGUID);
  # void SDL_JoystickGetGUIDString(SDL_JoystickGUID guid, char *pszGUID, int cbGUID);
  # Uint8 SDL_JoystickGetHat(SDL_Joystick *joystick,
  # int SDL_JoystickGetPlayerIndex(SDL_Joystick *joystick);
  # Uint16 SDL_JoystickGetProductVersion(SDL_Joystick *joystick);
  # SDL_JoystickID SDL_JoystickInstanceID(SDL_Joystick *joystick);
  # SDL_bool SDL_JoystickIsVirtual(int device_index);
  # const char *SDL_JoystickNameForIndex(int device_index);
  # const char *SDL_JoystickPathForIndex(int device_index);
  # int SDL_JoystickRumble(SDL_Joystick *joystick, Uint16 low_frequency_rumble, Uint16 high_frequency_rumble, Uint32 duration_ms);
  # int SDL_JoystickRumbleTriggers(SDL_Joystick *joystick, Uint16 left_rumble, Uint16 right_rumble, Uint32 duration_ms);
  # int SDL_JoystickSendEffect(SDL_Joystick *joystick, const void *data, int size);
  # int SDL_JoystickSetLED(SDL_Joystick *joystick, Uint8 red, Uint8 green, Uint8 blue);
  # void SDL_JoystickSetPlayerIndex(SDL_Joystick *joystick, int player_index);
  # int SDL_JoystickSetVirtualAxis(SDL_Joystick *joystick, int axis, Sint16 value);
  # int SDL_JoystickSetVirtualButton(SDL_Joystick *joystick, int button, Uint8 value);
  # int SDL_JoystickSetVirtualHat(SDL_Joystick *joystick, int hat, Uint8 value);
  # void SDL_UnlockJoysticks(void) SDL_RELEASE(SDL_joystick_lock);

# --------------------------------------------------------------------------- #
# <SDL2/SDL_keyboard.h>                                                       #
# --------------------------------------------------------------------------- #

when use_keyboard:

  # void SDL_ClearComposition(void)
  # SDL_Keycode SDL_GetKeyFromName(const char *name)
  # SDL_Keycode SDL_GetKeyFromScancode(SDL_Scancode scancode)

  proc GetKeyName*(key: Keycode): string {.inline.} =
    ##  XXX.
    $SDL_GetKeyName key

  proc GetKeyboardFocus*(): Window {.inline.} =
    ##  ```c
    ##  ```
    SDL_GetKeyboardFocus()

  # const Uint8 *SDL_GetKeyboardState(int *numkeys)
  # SDL_Keymod SDL_GetModState(void)
  # SDL_Scancode SDL_GetScancodeFromKey(SDL_Keycode key)
  # SDL_Scancode SDL_GetScancodeFromName(const char *name)
  # const char *SDL_GetScancodeName(SDL_Scancode scancode)
  # SDL_bool SDL_HasScreenKeyboardSupport(void)
  # SDL_bool SDL_IsScreenKeyboardShown(SDL_Window *window)
  # SDL_bool SDL_IsTextInputActive(void)
  # SDL_bool SDL_IsTextInputShown(void)
  # void SDL_ResetKeyboard(void)
  # void SDL_SetModState(SDL_Keymod modstate)
  # void SDL_SetTextInputRect(const SDL_Rect *rect)
  # void SDL_StartTextInput(void)
  # void SDL_StopTextInput(void)

# --------------------------------------------------------------------------- #
# <SDL2/SDL_log.h>                                                            #
# --------------------------------------------------------------------------- #

# SDL_Log, SDL_LogCritical, SDL_LogDebug, SDL_LogError, SDL_LogInfo,
# SDL_LogVerbose and SDL_LogWarn are emulated by calling SDL_LogMessage.

proc LogMessage*(category: LogCategory, priority: LogPriority, message: string)

proc Log*(message: string) {.inline.} =
  ##  ```c
  ##  void SDL_Log(const char *fmt, ...);
  ##  ```
  LogMessage LOG_CATEGORY_APPLICATION, LOG_PRIORITY_INFO, message

proc LogCritical*(category: LogCategory, message: string) {.inline.} =
  ##  ```c
  ##  void SDL_LogCritical(int category, const char *fmt, ...);
  ##  ```
  LogMessage category, LOG_PRIORITY_CRITICAL, message

proc LogDebug*(category: LogCategory, message: string) {.inline.} =
  ##  ```c
  ##  void SDL_LogDebug(int category, const char *fmt, ...);
  ##  ```
  LogMessage category, LOG_PRIORITY_DEBUG, message

proc LogError*(category: LogCategory, message: string) {.inline.} =
  ##  ```c
  ##  void SDL_LogError(int category, const char *fmt, ...);
  ##  ```
  LogMessage category, LOG_PRIORITY_ERROR, message

# void SDL_LogGetOutputFunction(SDL_LogOutputFunction *callback,
#     void **userdata)
# SDL_LogPriority SDL_LogGetPriority(int category)

proc LogInfo*(category: LogCategory, message: string) {.inline.} =
  ##  ```c
  ##  void SDL_LogInfo(int category, const char *fmt, ...);
  ##  ```
  LogMessage category, LOG_PRIORITY_INFO, message

proc LogMessage*(category: LogCategory, priority: LogPriority,
                 message: string) =
  ##  ```c
  ##  void
  ##  SDL_LogMessage(int category, SDL_LogPriority priority,
  ##                 const char *fmt, ...);
  ##  ```
  SDL_LogMessage category, priority, "%s", message.cstring

# void SDL_LogMessageV(int category, SDL_LogPriority priority, const char *fmt,
#     va_list ap)
# void SDL_LogResetPriorities(void)

proc LogSetAllPriority*(priority: LogPriority) =
  ##  ```c
  ##  void SDL_LogSetAllPriority(SDL_LogPriority priority);
  ##  ```
  SDL_LogSetAllPriority priority

proc LogSetOutputFunction*(callback: LogOutputFunction,
                           userdata: pointer = nil) {.inline.} =
  ##  ```c
  ##  void
  ##  SDL_LogSetOutputFunction(SDL_LogOutputFunction callback, void *userdata);
  ##  ```
  SDL_LogSetOutputFunction callback, userdata

proc LogSetPriority*(category: LogCategory, priority: LogPriority) {.inline.} =
  ##  ```c
  ##  void SDL_LogSetPriority(int category, SDL_LogPriority priority);
  ##  ```
  SDL_LogSetPriority category, priority

proc LogVerbose*(category: LogCategory, message: string) {.inline.} =
  ##  ```c
  ##  void SDL_LogVerbose(int category, const char *fmt, ...);
  ##  ```
  LogMessage category, LOG_PRIORITY_VERBOSE, message

proc LogWarn*(category: LogCategory, message: string) {.inline.} =
  ##  ```c
  ##  void SDL_LogWarn(int category, const char *fmt, ...);
  ##  ```
  LogMessage category, LOG_PRIORITY_WARN, message

# --------------------------------------------------------------------------- #
# <SDL2/SDL_main.h>                                                           #
# --------------------------------------------------------------------------- #

# int SDL_GDKRunApp(SDL_main_func mainFunction, void *reserved)
# void SDL_GDKSuspendComplete(void)
# int SDL_RegisterApp(const char *name, Uint32 style, void *hInst)
# void SDL_SetMainReady(void)
# int SDL_UIKitRunApp(int argc, char *argv[], SDL_main_func mainFunction)
# void SDL_UnregisterApp(void)
# int SDL_WinRTRunApp(SDL_main_func mainFunction, void *reserved)

# --------------------------------------------------------------------------- #
# <SDL2/SDL_messagebox.h>                                                     #
# --------------------------------------------------------------------------- #

when use_messagebox:

  proc ShowMessageBo*(messageboxdata: var MessageBoxData,
                      buttonid: var int): bool =
    ##  ```c
    ##  int SDL_ShowMessageBox(const SDL_MessageBoxData *messageboxdata,
    ##                         int *buttonid);
    ##  ```
    var but: cint = 0
    ensure_zero "SDL_ShowMessageBox":
      SDL_ShowMessageBox(messageboxdata.addr, but.addr)
    buttonid = but

  proc ShowSimpleMessageBox*(flags: MessageBoxFlags, title: string,
                             message: string,
                             window: Window = nil): bool =
    ##  ```c
    ##  int SDL_ShowSimpleMessageBox(Uint32 flags, const char *title,
    ##                               const char *message, SDL_Window *window);
    ##  ```
    ensure_zero "SDL_ShowSimpleMessageBox":
      SDL_ShowSimpleMessageBox(flags.uint32, title.cstring,
                                         message.cstring, window)

# --------------------------------------------------------------------------- #
# <SDL2/SDL_mouse.h>                                                          #
# --------------------------------------------------------------------------- #

when use_mouse:

  proc CaptureMouse*(enabled: bool): bool =
    ##  ```c
    ##  int SDL_CaptureMouse(SDL_bool enabled);
    ##  ```
    available_since SDL_CaptureMouse, "2.0.4"
    ensure_zero "SDL_CaptureMouse":
      SDL_CaptureMouse enabled

  proc CreateColorCursor*(surface: SurfacePtr, hot_x, hot_y: int): CursorPtr =
    ##  ```c
    ##  SDL_Cursor *SDL_CreateColorCursor(SDL_Surface *surface,
    ##                                    int hot_x, int hot_y);
    ##  ```
    ensure_not_nil "SDL_CreateColorCursor":
      SDL_CreateColorCursor surface, hot_x.cint, hot_y.cint

  proc CreateCursor*(data: openArray[byte], mask: openArray[byte],
                     w: int, h: int, hot_x: int, hot_y: int): CursorPtr =
    ##  ```c
    ##  SDL_Cursor *SDL_CreateCursor(const Uint8 *data, const Uint8 *mask,
    ##                               int w, int h, int hot_x, int hot_y);
    ##  ```
    # XXX: check arrays size agains w/h
    ensure_not_nil "SDL_CreateCursor":
      when NimMajor >= 2:
        SDL_CreateCursor data[0].addr, mask[0].addr,
                                 w.cint, h.cint, hot_x.cint, hot_y.cint
      else:
        SDL_CreateCursor data[0].unsafeAddr, mask[0].unsafeAddr,
                                 w.cint, h.cint, hot_x.cint, hot_y.cint

  proc CreateSystemCursor*(id: SystemCursor) {.inline.} =
    ##  ```c
    ##  ```
    SDL_CreateSystemCursor id

  proc FreeCursor*(cursor: CursorPtr) {.inline.} =
    ##  ```c
    ##  ```
    SDL_FreeCursor cursor

  proc GetCursor*(): CursorPtr =
    ##  ```c
    ##  SDL_Cursor *SDL_GetCursor(void);
    ##  ```
    SDL_GetCursor()

  # SDL_Cursor *SDL_GetDefaultCursor(void)

  proc GetGlobalMouseState*(): tuple[x, y: int, state: uint32] =
    ##  .. note::
    ##    This function returns tuple of (-1, -1, 0) on SDL prior 2.0.4.
    ##
    ##  ```c
    ##  Uint32 SDL_GetGlobalMouseState(int *x, int *y);
    ##  ```
    if SDL_GetGlobalMouseState == nil:
      log_error "SDL_GetGlobalMouseState is available since SDL 2.0.4"
      return (-1, -1, 0)
    var outx, outy: cint = 0
    let state = SDL_GetGlobalMouseState(outx.addr, outy.addr)
    (outx.int, outy.int, state)

  proc GetMouseFocus*(): Window {.inline.} =
    ##  ```c
    ##  SDL_Window * SDL_GetMouseFocus(void);
    ##  ```
    # XXX: TODO: can this function return nil?
    SDL_GetMouseFocus()

  proc GetMouseState*(): tuple[x, y: int, state: uint32] =
    ##  ```c
    ##  Uint32 SDL_GetMouseState(int *x, int *y);
    ##  ```
    var outx, outy: cint = 0
    let state = SDL_GetMouseState(outx.addr, outy.addr)
    (outx.int, outy.int, state)

  proc GetRelativeMouseMode*(): bool {.inline.} =
    ##  ```c
    ##  SDL_bool SDL_GetRelativeMouseMode(void);
    ##  ```
    SDL_GetRelativeMouseMode()

  proc GetRelativeMouseState*(): tuple[x, y: int, state: uint32] =
    ##  ```c
    ##  Uint32 SDL_GetRelativeMouseState(int *x, int *y);
    ##  ```
    var outx, outy: cint = 0
    let state = SDL_GetRelativeMouseState(outx.addr, outy.addr)
    (outx.int, outy.int, state)

  proc SetCursor*(cursor: CursorPtr) {.inline.} =
    ##  ```c
    ##  void SDL_SetCursor(SDL_Cursor *cursor);
    ##  ```
    SDL_SetCursor cursor

  proc SetRelativeMouseMode*(enable: bool): bool =
    ##  ```c
    ##  int SDL_SetRelativeMouseMode(SDL_bool enabled);
    ##  ```
    ensure_zero "SDL_SetRelativeMouseMode":
      SDL_SetRelativeMouseMode enable

  proc ShowCursor*(toggle: EventState): bool {.inline.} =
    ##  ```c
    ##  int SDL_ShowCursor(int toggle);
    ##  ```
    SDL_ShowCursor(toggle) != 0

  # int SDL_WarpMouseGlobal(int x, int y)
  # void SDL_WarpMouseInWindow(SDL_Window *window, int x, int y)

# --------------------------------------------------------------------------- #
# <SDL2/SDL_pixels.h>                                                         #
# --------------------------------------------------------------------------- #

# SDL_PixelFormat * SDL_AllocFormat(Uint32 pixel_format)
# SDL_Palette *SDL_AllocPalette(int ncolors)
# void SDL_CalculateGammaRamp(float gamma, Uint16 *ramp)
# void SDL_FreeFormat(SDL_PixelFormat *format)
# void SDL_FreePalette(SDL_Palette *palette)

proc GetPixelFormatName*(format: PixelFormatEnum): string {.inline.} =
  ##  ```c
  ##  const char* SDL_GetPixelFormatName(Uint32 format);
  ##  ```
  $SDL_GetPixelFormatName format

# void SDL_GetRGB(Uint32 pixel, const SDL_PixelFormat *format,
#     Uint8 *r, Uint8 *g, Uint8 *b)
# void SDL_GetRGBA(Uint32 pixel, const SDL_PixelFormat *format,
#     Uint8 *r, Uint8 *g, Uint8 *b, Uint8 *a)

proc MapRGB*(format: PixelFormat, r: byte, g: byte, b: byte): uint32 =
  ##  ```c
  ##  Uint32 SDL_MapRGB(const SDL_PixelFormat *format, Uint8 r, Uint8 g, Uint8 b);
  ##  ```
  when NimMajor < 2:
    var format = format
  SDL_MapRGB format.addr, r, g, b

proc MapRGBA*(format: PixelFormat, r: byte, g: byte, b: byte,
              a: byte): uint32 =
  ##  ```c
  ##  Uint32 SDL_MapRGBA(const SDL_PixelFormat *format, Uint8 r, Uint8 g, Uint8 b, Uint8 a);
  ##  ```
  when NimMajor < 2:
    var format = format
  SDL_MapRGBA format.addr, r, g, b, a

proc MasksToPixelFormatEnum*(bpp: int, rmask: uint32, gmask: uint32,
                             bmask: uint32, amask: uint32): PixelFormatEnum =
  ##  ```c
  ##  Uint32 SDL_MasksToPixelFormatEnum(int bpp, Uint32 Rmask, Uint32 Gmask,
  ##                                    Uint32 Bmask, Uint32 Amask);
  ##  ```
  SDL_MasksToPixelFormatEnum bpp.cint, rmask, gmask, bmask, amask

proc PixelFormatEnumToMasks*(format: PixelFormatEnum): tuple[bpp: int, rmask, gmask, bmask, amask: uint32] =
  ##  Return tuple of `(0, 0, 0, 0)` on error.
  ##  ```c
  ##  SDL_bool SDL_PixelFormatEnumToMasks(Uint32 format, int *bpp,
  ##                                      Uint32 *Rmask, Uint32 *Gmask,
  ##                                      Uint32 *Bmask, Uint32 *Amask);
  ##  ```
  var
    bpp: cint = 0
    rmask, gmask, bmask, amask: uint32 = 0
  if not SDL_PixelFormatEnumToMasks(format, bpp.addr, rmask.addr,
                                    gmask.addr, bmask.addr, amask.addr):
    log_error "SDL_PixelFormatEnumToMasks failed: ", SDL_GetError()
    return (0, 0, 0, 0, 0)
  (bpp.int, rmask, gmask, bmask, amask)

proc SetPaletteColors*(palette: var Palette, colors: openArray[Color],
                       firstcolor: int = 0, ncolors: int = 0): bool =
  let ncolors = if ncolors > 0: ncolors else: colors.len - firstcolor
  ensure_zero "SDL_SetPaletteColors":
    SDL_SetPaletteColors palette.addr, colors[0].addr, firstcolor.cint,
                         ncolors.cint

proc SetPixelFormatPalette*(format: var PixelFormat, palette: Palette): bool =
  ##  ```c
  ##  int SDL_SetPixelFormatPalette(SDL_PixelFormat *format,
  ##                                SDL_Palette *palette);
  ##  ```
  when NimMajor < 2:
    var palette = palette
  ensure_zero "SDL_SetPixelFormatPalette":
    SDL_SetPixelFormatPalette format.addr, palette.addr

# --------------------------------------------------------------------------- #
# <SDL2/SDL_rect.h>                                                           #
# --------------------------------------------------------------------------- #

# SDL_bool SDL_EncloseFPoints(const SDL_FPoint *points, int count,
#     const SDL_FRect *clip, SDL_FRect *result)
# SDL_bool SDL_EnclosePoints(const SDL_Point *points, int count,
#     const SDL_Rect *clip, SDL_Rect *result)
# SDL_bool SDL_HasIntersection(const SDL_Rect *A, const SDL_Rect *B)
# SDL_bool SDL_HasIntersectionF(const SDL_FRect *A, const SDL_FRect *B)
# SDL_bool SDL_IntersectFRect(const SDL_FRect *A, const SDL_FRect *B,
#     SDL_FRect *result)
# SDL_bool SDL_IntersectFRectAndLine(const SDL_FRect *rect, float *X1,
#     float *Y1, float *X2, float *Y2)
# SDL_bool SDL_IntersectRect(const SDL_Rect *A, const SDL_Rect *B,
#     SDL_Rect *result)
# SDL_bool SDL_IntersectRectAndLine(const SDL_Rect *rect, int *X1, int *Y1,
#     int *X2, int *Y2)
# void SDL_UnionFRect(const SDL_FRect *A, const SDL_FRect *B,
#     SDL_FRect *result)
# void SDL_UnionRect(const SDL_Rect *A, const SDL_Rect *B, SDL_Rect *result)

# --------------------------------------------------------------------------- #
# <SDL2/SDL_render.h>                                                         #
# --------------------------------------------------------------------------- #

proc CreateRenderer*(window: Window, index: int,
                     flags = RendererFlags 0): Renderer =
  ##  ```c
  ##  SDL_Renderer * SDL_CreateRenderer(SDL_Window *window, int index,
  ##                                    Uint32 flags);
  ##  ```
  ensure_not_nil "SDL_CreateRenderer":
    SDL_CreateRenderer(window, index.cint, flags.uint32)

proc CreateRenderer*(window: Window,
                     flags = RendererFlags 0): Renderer {.inline.} =
  ##  ```c
  ##  SDL_Renderer * SDL_CreateRenderer(SDL_Window *window, int index,
  ##                                    Uint32 flags);
  ##  ```
  CreateRenderer window, -1, flags

proc CreateSoftwareRenderer*(surface: SurfacePtr): Renderer =
  ##  ```c
  ##  SDL_Renderer * SDL_CreateSoftwareRenderer(SDL_Surface *surface);
  ##  ```
  ensure_not_nil "SDL_CreateSoftwareRenderer":
    SDL_CreateSoftwareRenderer surface

proc CreateTexture*(renderer: Renderer, format: PixelFormatEnum,
                    access: TextureAccess, width, height: int): Texture =
  ##  ```c
  ##  SDL_Texture * SDL_CreateTexture(SDL_Renderer *renderer, Uint32 format,
  ##                                  int access, int w, int h);
  ##  ```
  ensure_not_nil "SDL_CreateTexture":
    SDL_CreateTexture renderer, format.uint32, access.cint,
                              width.cint, height.cint

proc CreateTextureFromSurface*(renderer: Renderer,
                               surface: SurfacePtr): Texture =
  ##  ```c
  ##  SDL_Texture * SDL_CreateTextureFromSurface(SDL_Renderer *renderer,
  ##                                             SDL_Surface *surface);
  ##  ```
  ensure_not_nil "SDL_CreateTextureFromSurface":
    SDL_CreateTextureFromSurface renderer, surface

proc CreateWindowAndRenderer*(width: int, height: int,
                              window_flags: WindowFlags = WindowFlags 0): tuple[window: Window, renderer: Renderer] =
  ##  ```c
  ##  int SDL_CreateWindowAndRenderer(int width, int height,
  ##                                  Uint32 window_flags, SDL_Window **window,
  ##                                  SDL_Renderer **renderer);
  ##  ```
  var out_window    : Window = nil
  var out_renderer  : Renderer = nil
  if not SDL_CreateWindowAndRenderer(width.cint, height.cint,
                                             window_flags, out_window.addr,
                                             out_renderer.addr) != 0:
    echo "SDL_CreateWindowAndRenderer failed: ", Get_Error()
    # XXX: TODO: check whether this function writes anythin on error.
    if out_renderer != nil:
      SDL_DestroyRenderer out_renderer
    if out_window != nil:
      SDL_DestroyWindow out_window
    return (nil, nil)

  (out_window, out_renderer)

proc DestroyRenderer*(renderer: Renderer) {.inline.} =
  ##  Destroy the window rendering context and free all textures.
  ##
  ##  ```c
  ##  void SDL_DestroyRenderer(SDL_Renderer *renderer);
  ##  ```
  SDL_DestroyRenderer renderer

proc DestroyTexture*(texture: Texture) {.inline.} =
  ##  Destroy the texture.
  ##
  ##  ```c
  ##  void SDL_DestroyTexture(SDL_Texture *texture);
  ##  ```
  SDL_DestroyTexture texture

# int SDL_GL_BindTexture(SDL_Texture *texture, float *texw, float *texh)
# int SDL_GL_UnbindTexture(SDL_Texture *texture)

proc GetNumRenderDrivers*(): int =
  ##  ```c
  ##  int SDL_GetNumRenderDrivers(void);
  ##  ```
  ensure_natural "SDL_GetNumRenderDrivers":
    SDL_GetNumRenderDrivers()

# int SDL_GetRenderDrawBlendMode(SDL_Renderer *renderer,
#     SDL_BlendMode *blendMode)

proc GetRenderDrawColor*(renderer: Renderer, r: var byte, g: var byte,
                         b: var byte, a: var byte): bool =
  ##  ```c
  ##  int SDL_GetRenderDrawColor(SDL_Renderer *renderer, Uint8 *r, Uint8 *g,
  ##                             Uint8 *b, Uint8 *a);
  ##  ```
  ensure_zero "SDL_GetRenderDrawColor":
    SDL_GetRenderDrawColor renderer, r.addr, g.addr, b.addr, a.addr

proc GetRenderDriverInfo*(index: int, info: var RendererInfo): bool =
  ##  ```c
  ##  int SDL_GetRenderDriverInfo(int index, SDL_RendererInfo *info);
  ##  ```
  ensure_zero "SDL_GetRenderDriverInfo":
    SDL_GetRenderDriverInfo index.cint, info.addr

proc GetRenderTarget*(renderer: Renderer): Texture {.inline.} =
  ##  ```c
  ##  SDL_Texture * SDL_GetRenderTarget(SDL_Renderer *renderer);
  ##  ```
  SDL_GetRenderTarget renderer

proc GetRenderer*(window: Window): Renderer =
  ##  ```c
  ##  SDL_Renderer * SDL_GetRenderer(SDL_Window *window);
  ##  ```
  ensure_not_nil "SDL_GetRenderer":
    SDL_GetRenderer window

proc GetRendererInfo*(renderer: Renderer, info: var RendererInfo): bool =
  ##  ```c
  ##  int SDL_GetRendererInfo(SDL_Renderer *renderer, SDL_RendererInfo *info);
  ##  ```
  ensure_zero "SDL_GetRendererInfo":
    SDL_GetRendererInfo renderer, info.addr

proc GetRendererOutputSize*(renderer: Renderer, w: var int, h: var int): bool =
  ##  ```c
  ##  int SDL_GetRendererOutputSize(SDL_Renderer *renderer, int *w, int *h);
  ##  ```
  var outw, outh: cint
  ensure_zero "SDL_GetRendererOutputSize":
    SDL_GetRendererOutputSize renderer, outw.addr, outh.addr
  w = outw
  h = outh

# int SDL_GetTextureAlphaMod(SDL_Texture *texture, Uint8 *alpha)
# int SDL_GetTextureBlendMode(SDL_Texture *texture, SDL_BlendMode *blendMode)
# int SDL_GetTextureColorMod(SDL_Texture *texture, Uint8 *r, Uint8 *g, Uint8 *b)
# int SDL_GetTextureScaleMode(SDL_Texture *texture, SDL_ScaleMode *scaleMode)
# void * SDL_GetTextureUserData(SDL_Texture *texture)
# int SDL_LockTexture(SDL_Texture *texture, const SDL_Rect *rect, void **pixels, int *pitch)
# int SDL_LockTextureToSurface(SDL_Texture *texture, const SDL_Rect *rect, SDL_Surface **surface)

proc QueryTexture*(texture: Texture, format: var uint32, access: var int,
                   w: var int, h: var int): bool =
  ##  ```c
  ##  int SDL_QueryTexture(SDL_Texture *texture, Uint32 *format, int *access, int *w, int *h);
  ##  ```
  var outaccess, outw, outh: cint
  if SDL_QueryTexture(texture, format.addr, outaccess.addr,
                              outw.addr, outh.addr) != 0:
    log_error "SDL_QueryTexture failed: ", $SDL_GetError()
    return false
  access = outaccess
  w = outw
  h = outh
  true

proc RenderClear*(renderer: Renderer): bool =
  ##  ```c
  ##  int SDL_RenderClear(SDL_Renderer *renderer);
  ##  ```
  ensure_zero "SDL_RenderClear":
    SDL_RenderClear renderer

proc RenderCopy*(renderer: Renderer, texture: Texture): bool =
  ##  ```c
  ##  int SDL_RenderCopy(SDL_Renderer *renderer, SDL_Texture *texture,
  ##                     const SDL_Rect *srcrect, const SDL_Rect *dstrect);
  ##  ```
  ensure_zero "SDL_RenderCopy":
    SDL_RenderCopy renderer, texture, nil, nil

proc RenderCopy*(renderer: Renderer, texture: Texture, dst: Rect): bool =
  ##  ```c
  ##  int SDL_RenderCopy(SDL_Renderer *renderer, SDL_Texture *texture,
  ##                     const SDL_Rect *srcrect, const SDL_Rect *dstrect);
  ##  ```
  when NimMajor < 2:
    var dst = dst
  ensure_zero "SDL_RenderCopy":
    SDL_RenderCopy renderer, texture, nil, dst.addr

proc RenderCopy*(renderer: Renderer, texture: Texture, x: int, y: int,
                 w: int, h: int): bool =
  ##  ```c
  ##  int SDL_RenderCopy(SDL_Renderer *renderer, SDL_Texture *texture,
  ##                     const SDL_Rect *srcrect, const SDL_Rect *dstrect);
  ##  ```
  when NimMajor >= 2:
    let dst: Rect = Rect(x: x.cint, y: y.cint, w: w.cint, h: h.cint)
  else:
    var dst: Rect = Rect(x: x.cint, y: y.cint, w: w.cint, h: h.cint)
  ensure_zero "SDL_RenderCopy":
    SDL_RenderCopy renderer, texture, nil, dst.addr

proc RenderCopy*(renderer: Renderer, texture: Texture, src: Rect,
                 dst: Rect): bool =
  ##  ```c
  ##  int SDL_RenderCopy(SDL_Renderer *renderer, SDL_Texture *texture,
  ##                     const SDL_Rect *srcrect, const SDL_Rect *dstrect);
  ##  ```
  when NimMajor < 2:
    var src = src
    var dst = dst
  ensure_zero "SDL_RenderCopy":
    SDL_RenderCopy renderer, texture, src.addr, dst.addr

proc RenderCopyEx*(renderer: Renderer, texture: Texture, src: Rect, dst: Rect,
                   angle: float, center: Point, flip: RendererFlip): bool =
  ##  ```c
  ##  SDL_RenderCopyEx(SDL_Renderer *renderer, SDL_Texture *texture,
  ##                   const SDL_Rect *srcrect, const SDL_Rect *dstrect,
  ##                   const double angle, const SDL_Point *center,
  ##                   const SDL_RendererFlip flip);
  ##  ```
  when NimMajor < 2:
    var src = src
    var dst = dst
    var center = center
  ensure_zero "SDL_RenderCopyEx":
    SDL_RenderCopyEx renderer, texture, src.addr, dst.addr,
                             angle.cdouble, center.addr, flip

# int SDL_RenderCopyExF(SDL_Renderer *renderer, SDL_Texture *texture,
#     const SDL_Rect *srcrect, const SDL_FRect *dstrect, const double angle,
#     const SDL_FPoint *center, const SDL_RendererFlip flip)
# int SDL_RenderCopyF(SDL_Renderer *renderer, SDL_Texture *texture,
#     const SDL_Rect *srcrect, const SDL_FRect *dstrect)

proc RenderDrawLine*(renderer: Renderer, x1: int, y1: int,
                     x2: int, y2: int): bool =
  ##  ```c
  ##  int SDL_RenderDrawLine(SDL_Renderer *renderer, int x1, int y1,
  ##                         int x2, int y2);
  ##  ```
  ensure_zero "SDL_RenderDrawLine":
    SDL_RenderDrawLine renderer, x1.cint, y1.cint, x2.cint, y2.cint

# SDL_RenderDrawLineF(SDL_Renderer *renderer, float x1, float y1, float x2, float y2)
# int SDL_RenderDrawLines(SDL_Renderer *renderer, const SDL_Point *points, int count)
# int SDL_RenderDrawLinesF(SDL_Renderer *renderer, const SDL_FPoint *points, int count)

proc RenderDrawPoint*(renderer: Renderer, x: int, y: int): bool =
  ##  ```c
  ##  int SDL_RenderDrawPoint(SDL_Renderer *renderer, int x, int y);
  ##  ```
  ensure_zero "SDL_RenderDrawPoint":
    SDL_RenderDrawPoint renderer, x.cint, y.cint

proc RenderDrawPointF*(renderer: Renderer, x: float, y: float): bool =
  ##  ```c
  ##  int SDL_RenderDrawPointF(SDL_Renderer *renderer, float x, float y);
  ##  ```
  # XXX: render with ints or just return false?
  if unlikely SDL_RenderDrawPointF == nil:
    return renderer.RenderDrawPoint(int (x + 0.5), int (y + 0.5))
  ensure_zero "SDL_RenderDrawPointF":
    SDL_RenderDrawPointF renderer, x.cfloat, y.cfloat

# int SDL_RenderDrawPoints(SDL_Renderer *renderer, const SDL_Point *points, int count)
# int SDL_RenderDrawPointsF(SDL_Renderer *renderer, const SDL_FPoint *points, int count)

proc RenderDrawRect*(renderer: Renderer, rect: Rect): bool =
  ##  ```c
  ##  int SDL_RenderDrawRect(SDL_Renderer *renderer, const SDL_Rect *rect);
  ##  ```
  when NimMajor < 2:
    var rect = rect
  ensure_zero "SDL_RenderDrawRect":
    SDL_RenderDrawRect renderer, rect.addr

proc RenderDrawRect*(renderer: Renderer, x: int, y: int,
                     w: int, h: int): bool {.inline.} =
  ##  ```c
  ##  int SDL_RenderDrawRect(SDL_Renderer *renderer, const SDL_Rect *rect);
  ##  ```
  RenderDrawRect renderer, Rect.init(x, y, w, h)

# int SDL_RenderDrawRectF(SDL_Renderer *renderer, const SDL_FRect *rect)
# int SDL_RenderDrawRects(SDL_Renderer *renderer, const SDL_Rect *rects, int count)
# int SDL_RenderDrawRectsF(SDL_Renderer *renderer, const SDL_FRect *rects, int count)

proc RenderFillRect*(renderer: Renderer): bool =
  ##  ```c
  ##  int SDL_RenderFillRect(SDL_Renderer *renderer, const SDL_Rect *rect);
  ##  ```
  ensure_zero "SDL_RenderFillRect":
    SDL_RenderFillRect renderer, nil

proc RenderFillRect*(renderer: Renderer, rect: Rect): bool =
  ##  ```c
  ##  int SDL_RenderFillRect(SDL_Renderer *renderer, const SDL_Rect *rect);
  ##  ```
  when NimMajor < 2:
    var rect = rect
  ensure_zero "SDL_RenderFillRect":
    SDL_RenderFillRect renderer, rect.addr

proc RenderFillRect*(renderer: Renderer, x, y: int,
                     w, h: int): bool {.inline.} =
  ##  ```c
  ##  int SDL_RenderFillRect(SDL_Renderer *renderer, const SDL_FRect *rect);
  ##  ```
  RenderFillRect renderer, Rect.init(x, y, w, h)

# int SDL_RenderFillRectF(SDL_Renderer *renderer, const SDL_FRect *rect)
# int SDL_RenderFillRects(SDL_Renderer *renderer, const SDL_Rect *rects, int count)
# int SDL_RenderFillRectsF(SDL_Renderer *renderer, const SDL_FRect *rects, int count)
# int SDL_RenderFlush(SDL_Renderer *renderer)

proc RenderGeometry*(renderer: Renderer, texture: Texture,
                     vertices: openArray[Vertex],
                     num_vertices: int = 0): bool =
  ##  ```c
  ##  int SDL_RenderGeometry(SDL_Renderer *renderer, SDL_Texture *texture,
  ##                         const SDL_Vertex *vertices, int num_vertices,
  ##                         const int *indices, int num_indices);
  ##  ```
  available_since SDL_RenderGeometry, "2.0.18"
  var max_vertices = vertices.len
  if num_vertices != 0:
    max_vertices = min(num_vertices, max_vertices)
  ensure_zero "SDL_RenderGeometry":
    when NimMajor >= 2:
      SDL_RenderGeometry renderer, texture, vertices[0].addr,
                                 max_vertices.cint, nil, 0
    else:
      SDL_RenderGeometry renderer, texture, vertices[0].unsafeAddr,
                                 max_vertices.cint, nil, 0

proc RenderGeometry*(renderer: Renderer, vertices: openArray[Vertex],
                     num_vertices: int = 0): bool {.inline.} =
  ##  ```c
  ##  int SDL_RenderGeometry(SDL_Renderer *renderer, SDL_Texture *texture,
  ##                         const SDL_Vertex *vertices, int num_vertices,
  ##                         const int *indices, int num_indices);
  ##  ```
  RenderGeometry renderer, nil, vertices, num_vertices

# int SDL_RenderGeometryRaw(SDL_Renderer *renderer, SDL_Texture *texture,
#     const float *xy, int xy_stride, const SDL_Color *color, int color_stride,
#     const float *uv, int uv_stride, int num_vertices, const void *indices,
#     int num_indices, int size_indices)

proc RenderGetClipRect*(renderer: Renderer, rect: var Rect) {.inline.} =
  ##  ```c
  ##  void SDL_RenderGetClipRect(SDL_Renderer *renderer, SDL_Rect *rect);
  ##  ```
  SDL_RenderGetClipRect renderer, rect.addr

# SDL_bool SDL_RenderGetIntegerScale(SDL_Renderer *renderer)

proc RenderGetLogicalSize*(renderer: Renderer, w: var int, h: var int) =
  ##  ```c
  ##  void SDL_RenderGetLogicalSize(SDL_Renderer *renderer, int *w, int *h)
  ##  ```
  var outw, outh: cint
  SDL_RenderGetLogicalSize renderer, outw.addr, outh.addr
  w = outw
  h = outh

# void *SDL_RenderGetMetalCommandEncoder(SDL_Renderer *renderer)
# void *SDL_RenderGetMetalLayer(SDL_Renderer *renderer)

proc RenderGetScale*(renderer: Renderer, scale_x, scale_y: var float) =
  ##  ```c
  ##  void SDL_RenderGetScale(SDL_Renderer *renderer, float *scaleX,
  ##                          float *scaleY);
  ##  ```
  var outx, outy: cfloat
  SDL_RenderGetScale renderer, outx.addr, outy.addr
  scale_x = outx
  scale_y = outy

proc RenderGetViewport*(renderer: Renderer, rect: var Rect) {.inline.} =
  ##  ```c
  ##  void SDL_RenderGetViewport(SDL_Renderer *renderer, SDL_Rect *rect);
  ##  ```
  SDL_RenderGetViewport renderer, rect.addr

proc RenderGetWindow*(renderer: Renderer): Window =
  ##  ```c
  ##  SDL_Window *SDL_RenderGetWindow(SDL_Renderer *renderer);
  ##  ```
  available_since SDL_RenderGetWindow, "2.0.22"
  ensure_not_nil "SDL_RenderGetWindow":
    SDL_RenderGetWindow renderer

# SDL_bool SDL_RenderIsClipEnabled(SDL_Renderer *renderer)
# void SDL_RenderLogicalToWindow(SDL_Renderer *renderer, float logicalX,
#     float logicalY, int *windowX, int *windowY)

proc RenderPresent*(renderer: Renderer) {.inline.} =
  ##  ```c
  ##  void SDL_RenderPresent(SDL_Renderer *renderer);
  ##  ```
  SDL_RenderPresent renderer

proc RenderReadPixels*(renderer: Renderer, format: PixelFormatEnum,
                       pixels: pointer, pitch: int): bool =
  ##  ```c
  ##  int SDL_RenderReadPixels(SDL_Renderer *renderer, const SDL_Rect *rect,
  ##                           Uint32 format, void *pixels, int pitch);
  ##  ```
  ensure_zero "SDL_RenderReadPixels":
    SDL_RenderReadPixels renderer, nil, format, pixels, pitch.cint

proc RenderReadPixels*(renderer: Renderer, rect: Rect, format: PixelFormatEnum,
                       pixels: pointer, pitch: int): bool =
  ##  ```c
  ##  int SDL_RenderReadPixels(SDL_Renderer *renderer, const SDL_Rect *rect,
  ##                           Uint32 format, void *pixels, int pitch);
  ##  ```
  when NimMajor < 2:
    var rect = rect
  ensure_zero "SDL_RenderReadPixels":
    SDL_RenderReadPixels renderer, rect.addr, format, pixels, pitch.cint

proc RenderSetClipRect*(renderer: Renderer): bool =
  ##  ```c
  ##  int SDL_RenderSetClipRect(SDL_Renderer *renderer, const SDL_Rect *rect);
  ##  ```
  ensure_zero "SDL_RenderSetClipRect":
    SDL_RenderSetClipRect renderer, nil

proc RenderSetClipRect*(renderer: Renderer, rect: Rect): bool =
  ##  ```c
  ##  int SDL_RenderSetClipRect(SDL_Renderer *renderer, const SDL_Rect *rect);
  ##  ```
  when NimMajor < 2:
    var rect = rect
  ensure_zero "SDL_RenderSetClipRect":
    SDL_RenderSetClipRect renderer, rect.addr

# int SDL_RenderSetIntegerScale(SDL_Renderer *renderer, SDL_bool enable)

proc RenderSetLogicalSize*(renderer: Renderer, w: int, h: int): bool =
  ##  ```c
  ##  int SDL_RenderSetLogicalSize(SDL_Renderer *renderer, int w, int h);
  ##  ```
  ensure_zero "SDL_RenderSetLogicalSize":
    SDL_RenderSetLogicalSize renderer, w.cint, h.cint

proc RenderSetScale*(renderer: Renderer, scale_x: float,
                     scale_y: float): bool =
  ##  ```c
  ##  int SDL_RenderSetScale(SDL_Renderer *renderer, float scaleX,
  ##                         float scaleY);
  ##  ```
  ensure_zero "SDL_RenderSetScale":
    SDL_RenderSetScale renderer, scale_x.cfloat, scale_y.cfloat

proc RenderSetVSync*(renderer: Renderer, vsync: bool): bool =
  ##  ```c
  ##  int SDL_RenderSetVSync(SDL_Renderer* renderer, int vsync);
  ##  ```
  available_since SDL_RenderSetVSync, "2.0.18"
  ensure_zero "SDL_RenderSetVSync":
    SDL_RenderSetVSync renderer, vsync.cint

proc RenderSetViewport*(renderer: Renderer): bool =
  ##  ```c
  ##  int SDL_RenderSetViewport(SDL_Renderer *renderer, const SDL_Rect *rect);
  ##  ```
  ensure_zero "SDL_RenderSetViewport":
    SDL_RenderSetViewport renderer, nil

proc RenderSetViewport*(renderer: Renderer, rect: Rect): bool =
  ##  ```c
  ##  int SDL_RenderSetViewport(SDL_Renderer *renderer, const SDL_Rect *rect);
  ##  ```
  when NimMajor < 2:
    var rect = rect
  ensure_zero "SDL_RenderSetViewport":
    SDL_RenderSetViewport renderer, rect.addr

proc RenderTargetSupported*(renderer: Renderer): bool =
  ##  Determine whether a renderer supports the use of render targets.
  ##
  ##  ```c
  ##  SDL_bool SDL_RenderTargetSupported(SDL_Renderer *renderer);
  ##  ```
  SDL_RenderTargetSupported renderer

proc RenderWindowToLogical*(renderer: Renderer, window_x: int, window_y: int,
                            logical_x: var float, logical_y: var float): bool =
  ##  ```c
  ##  void SDL_RenderWindowToLogical(SDL_Renderer *renderer, int windowX,
  ##                                 int windowY, float *logicalX,
  ##                                 float *logicalY);
  ##  ```
  available_since SDL_RenderWindowToLogical, "2.0.18"

  var outx, outy: cfloat
  SDL_RenderWindowToLogical renderer, window_x.cint, window_y.cint,
                                    outx.addr, outy.addr
  logical_x = outx
  logical_y = outy
  true

when use_blendmode:
  proc SetRenderDrawBlendMode*(renderer: Renderer, blend_mode: BlendMode): bool =
    ##  ```c
    ##  int SDL_SetRenderDrawBlendMode(SDL_Renderer *renderer, SDL_BlendMode blendMode);
    ##  ```
    ensure_zero "SDL_SetRenderDrawBlendMode":
      SDL_SetRenderDrawBlendMode renderer, blend_mode

proc SetRenderDrawColor*(renderer: Renderer, r: byte, g: byte, b: byte,
                         a: byte = 0xff): bool =
  ##  Set the color used for drawing operations (clear, line, rect, etc.).
  ##
  ##  ```c
  ##  int SDL_SetRenderDrawColor(SDL_Renderer *renderer, Uint8 r, Uint8 g,
  ##                             Uint8 b, Uint8 a);
  ##  ```
  ensure_zero "SDL_SetRenderDrawColor":
    SDL_SetRenderDrawColor renderer, r, g, b, a

proc SetRenderTarget*(renderer: Renderer, texture: Texture = nil): bool =
  ##  ```c
  ##  int SDL_SetRenderTarget(SDL_Renderer *renderer, SDL_Texture *texture);
  ##  ```
  ensure_zero "SDL_SetRenderTarget":
    SDL_SetRenderTarget renderer, texture

proc SetTextureAlphaMod*(texture: Texture, a: byte): bool =
  ##  ```c
  ##  int SDL_SetTextureAlphaMod(SDL_Texture *texture, Uint8 alpha);
  ##  ```
  ensure_zero "SDL_SetTextureAlphaMod":
    SDL_SetTextureAlphaMod texture, a

when use_blendmode:
  proc SetTextureBlendMode*(texture: Texture, blend_mode: BlendMode): bool =
    ##  ```c
    ##  int SDL_SetTextureBlendMode(SDL_Texture *texture,
    ##                              SDL_BlendMode blendMode);
    ##  ```
    ensure_zero "SDL_SetTextureBlendMode":
      SDL_SetTextureBlendMode texture, blend_mode

proc SetTextureColorMod*(texture: Texture, r: byte, g: byte, b: byte): bool =
  ##  ```c
  ##  int SDL_SetTextureColorMod(SDL_Texture *texture, Uint8 r, Uint8 g,
  ##                             Uint8 b);
  ##  ```
  ensure_zero "SDL_SetTextureColorMod":
    SDL_SetTextureColorMod texture, r, g, b

# Since SDL 2.0.12.
# int SDL_SetTextureScaleMode(SDL_Texture *texture, SDL_ScaleMode scaleMode)
# Since SDL 2.0.18.
# int SDL_SetTextureUserData(SDL_Texture *texture, void *userdata)
# void SDL_UnlockTexture(SDL_Texture *texture)
# int SDL_UpdateNVTexture(SDL_Texture *texture, const SDL_Rect *rect,
#     const Uint8 *Yplane, int Ypitch, const Uint8 *UVplane, int UVpitch)

proc UpdateTexture*(texture: Texture, rect: Rect, pixels: pointer,
                    pitch: int): bool =
  ##  ```c
  ##  int SDL_UpdateTexture(SDL_Texture *texture, const SDL_Rect *rect,
  ##                        const void *pixels, int pitch);
  ##  ```
  when NimMajor < 2:
    var rect = rect
  ensure_zero "SDL_UpdateTexture":
    SDL_UpdateTexture texture, rect.addr, pixels, pitch.cint

proc UpdateTexture*(texture: Texture, pixels: pointer, pitch: int): bool =
  ##  ```c
  ##  int SDL_UpdateTexture(SDL_Texture *texture, const SDL_Rect *rect,
  ##                        const void *pixels, int pitch);
  ##  ```
  ensure_zero "SDL_UpdateTexture":
    SDL_UpdateTexture texture, nil, pixels, pitch.cint

proc UpdateTexture*[T: SomeUnsignedInt](texture: Texture, pixels: openArray[T],
                                        pitch: int): bool {.inline.} =
  ##  ```c
  ##  int SDL_UpdateTexture(SDL_Texture *texture, const SDL_Rect *rect,
  ##                        const void *pixels, int pitch);
  ##  ```
  when NimMajor >= 2:
    UpdateTexture texture, pixels[0].addr, pitch
  else:
    UpdateTexture texture, pixels[0].unsafeAddr, pitch

# int SDL_UpdateYUVTexture(SDL_Texture *texture, const SDL_Rect *rect,
#     const Uint8 *Yplane, int Ypitch, const Uint8 *Uplane, int Upitch,
#     const Uint8 *Vplane, int Vpitch)

# --------------------------------------------------------------------------- #
# <SDL2/SDL_rwops.h>                                                          #
# --------------------------------------------------------------------------- #

proc RWFromFile*(file, mode: string): RWops =
  ##  ```c
  ##  SDL_RWops * SDL_RWFromFile(const char *file, const char *mode);
  ##  ```
  ensure_not_nil "SDL_RWFromFile":
    SDL_RWFromFile file.cstring, mode.cstring

proc SaveBMP*(surface: SurfacePtr, file: string): bool =
  ##  ```c
  ##  ```
  ensure_zero "SDL_SaveBMP_RW":
    SDL_SaveBMP_RW surface, SDL_RWFromFile(file, "wb"), 1

# --------------------------------------------------------------------------- #
# <SDL2/SDL_sensor.h>                                                         #
# --------------------------------------------------------------------------- #

# TODO.

# --------------------------------------------------------------------------- #
# <SDL2/SDL_shape.h>                                                          #
# --------------------------------------------------------------------------- #

# TODO.

# --------------------------------------------------------------------------- #
# <SDL2/SDL_surface.h>                                                        #
# --------------------------------------------------------------------------- #

# int SDL_ConvertPixels(int width, int height, Uint32 src_format,
#     const void *src, int src_pitch, Uint32 dst_format, void *dst,
#     int dst_pitch)

proc ConvertSurface*(src: SurfacePtr, fmt: PixelFormat): SurfacePtr =
  ##  ```c
  ##  SDL_Surface *SDL_ConvertSurface(SDL_Surface *src,
  ##                                  const SDL_PixelFormat *fmt,
  ##                                  Uint32 flags);
  ##  ```
  when NimMajor < 2:
    var fmt = fmt
  ensure_not_nil "SDL_ConvertSurface":
    SDL_ConvertSurface src, fmt.addr, 0

proc ConvertSurfaceFormat*(src: SurfacePtr,
                           pixel_format: PixelFormatEnum): SurfacePtr =
  ##  ```c
  ##  SDL_Surface *SDL_ConvertSurfaceFormat(SDL_Surface *src,
  ##                                        Uint32 pixel_format, Uint32 flags);
  ##  ```
  ensure_not_nil "SDL_ConvertSurfaceFormat":
    SDL_ConvertSurfaceFormat src, pixel_format, 0

proc CreateRGBSurface*(flags: SurfaceFlags, width: int, height: int,
                       depth: int, rmask: uint32, gmask: uint32, bmask: uint32,
                       amask: uint32): SurfacePtr =
  ##  ```c
  ##  SDL_Surface *SDL_CreateRGBSurface(Uint32 flags, int width, int height,
  ##                                    int depth, Uint32 Rmask, Uint32 Gmask,
  ##                                    Uint32 Bmask, Uint32 Amask);
  ##  ```
  ensure_not_nil "SDL_CreateRGBSurface":
    SDL_CreateRGBSurface flags, width.cint, height.cint, depth.cint,
                         rmask, gmask, bmask, amask

proc CreateRGBSurface*(width: int, height: int, depth: int, rmask: uint32,
                       gmask: uint32, bmask: uint32,
                       amask: uint32): SurfacePtr {.inline.} =
  ##  ```c
  ##  SDL_Surface *SDL_CreateRGBSurface(Uint32 flags, int width, int height,
  ##                                    int depth, Uint32 Rmask, Uint32 Gmask,
  ##                                    Uint32 Bmask, Uint32 Amask);
  ##  ```
  CreateRGBSurface SWSURFACE, width, height, depth, rmask, gmask, bmask, amask

proc CreateRGBSurfaceFrom*(pixels: pointer, width: int, height: int,
                           depth: int, pitch: int, rmask: uint32,
                           gmask: uint32, bmask: uint32,
                           amask: uint32): SurfacePtr =
  ##  ```c
  ##  SDL_Surface *SDL_CreateRGBSurfaceFrom(void *pixels, int width,
  ##                                        int height, int depth, int pitch,
  ##                                        Uint32 Rmask, Uint32 Gmask,
  ##                                        Uint32 Bmask, Uint32 Amask);
  ##  ```
  ensure_not_nil "SDL_CreateRGBSurfaceFrom":
    SDL_CreateRGBSurfaceFrom pixels, width.cint, height.cint, depth.cint,
                             pitch.cint, rmask, gmask, bmask, amask

proc CreateRGBSurfaceWithFormat*(width: int, height: int, depth: int,
                                 format: PixelFormatEnum): SurfacePtr =
  ##  ```c
  ##  SDL_Surface *SDL_CreateRGBSurfaceWithFormat(Uint32 flags, int width,
  ##                                              int height, int depth,
  ##                                              Uint32 format);
  ##  ```
  available_since SDL_CreateRGBSurfaceWithFormat, "2.0.5"
  ensure_not_nil "SDL_CreateRGBSurfaceWithFormat":
    SDL_CreateRGBSurfaceWithFormat 0, width.cint, height.cint, depth.cint,
                                   format

# SDL_Surface *SDL_CreateRGBSurfaceWithFormatFrom(void *pixels, int width, int height, int depth, int pitch, Uint32 format)
# SDL_Surface *SDL_DuplicateSurface(SDL_Surface *surface)

proc FillRect*(dst: SurfacePtr, color: uint32): bool =
  ##  ```c
  ##  int SDL_FillRect (SDL_Surface *dst, const SDL_Rect *rect, Uint32 color);
  ##  ```
  ensure_zero "SDL_FillRect":
    SDL_FillRect dst, nil, color

proc FillRect*(dst: SurfacePtr, rect: Rect, color: uint32): bool =
  ##  ```c
  ##  int SDL_FillRect (SDL_Surface *dst, const SDL_Rect *rect, Uint32 color);
  ##  ```
  when NimMajor < 2:
    var rect = rect
  ensure_zero "SDL_FillRect":
    SDL_FillRect dst, rect.addr, color

# int SDL_FillRects (SDL_Surface *dst, const SDL_Rect *rects, int count, Uint32 color)

proc FreeSurface*(surface: SurfacePtr) {.inline.} =
  ##  ```c
  ##  void SDL_FreeSurface(SDL_Surface *surface);
  ##  ```
  SDL_FreeSurface surface

# void SDL_GetClipRect(SDL_Surface *surface, SDL_Rect *rect)
# int SDL_GetColorKey(SDL_Surface *surface, Uint32 *key)
# int SDL_GetSurfaceAlphaMod(SDL_Surface *surface, Uint8 *alpha)
# int SDL_GetSurfaceBlendMode(SDL_Surface *surface, SDL_BlendMode *blendMode)
# int SDL_GetSurfaceColorMod(SDL_Surface *surface, Uint8 *r, Uint8 *g, Uint8 *b)
# SDL_YUV_CONVERSION_MODE SDL_GetYUVConversionMode(void)
# SDL_YUV_CONVERSION_MODE SDL_GetYUVConversionModeForResolution(int width, int height)
# SDL_bool SDL_HasColorKey(SDL_Surface *surface)
# SDL_bool SDL_HasSurfaceRLE(SDL_Surface *surface)

# SDL_Surface *SDL_LoadBMP_RW(SDL_RWops *src, int freesrc)

proc LoadBMP_RW*(src: RWops, freesrc: bool): SurfacePtr =
  ##  ```c
  ##  SDL_Surface *SDL_LoadBMP_RW(SDL_RWops *src, int freesrc);
  ##  ```
  ensure_not_nil "SDL_LoadBMP_RW":
    SDL_LoadBMP_RW src, freesrc.cint

proc LoadBMP_RW_unchecked(src: RWops, freesrc: bool): SurfacePtr {.inline.} =
  ##  Unchecked version. Used by `load_bmp` not to generate multiple errors
  ##  such as:
  ##    - SDL_RWFromFile failed: Couldn't open sail.bmp
  ##    - SDL_LoadBMP_RW failed: Parameter 'src' is invalid
  ##
  ##  ```c
  ##  SDL_Surface *SDL_LoadBMP_RW(SDL_RWops *src, int freesrc);
  ##  ```
  SDL_LoadBMP_RW src, freesrc.cint

proc LockSurface*(surface: SurfacePtr): bool {.discardable.} =
  ##  ```c
  ##  int SDL_LockSurface(SDL_Surface *surface);
  ##  ```
  ensure_zero "SDL_LockSurface":
    SDL_LockSurface surface

# int SDL_LowerBlit (SDL_Surface *src, SDL_Rect *srcrect,
#     SDL_Surface *dst, SDL_Rect *dstrect)
# int SDL_LowerBlitScaled (SDL_Surface *src, SDL_Rect *srcrect,
#     SDL_Surface *dst, SDL_Rect *dstrect)

# Since SDL 2.0.18.
proc PremultiplyAlpha*(width: int, height: int, src_format: PixelFormatEnum,
                       src: pointer, src_pitch: int,
                       dst_format: PixelFormatEnum, dst: pointer,
                       dst_pitch: int): bool =
  ##  ```c
  ##  int SDL_PremultiplyAlpha(int width, int height, Uint32 src_format,
  ##                           const void *src, int src_pitch,
  ##                           Uint32 dst_format, void *dst, int dst_pitch);
  ##  ```
  available_since SDL_PremultiplyAlpha, "2.0.18"
  ensure_zero "SDL_PremultiplyAlpha":
    SDL_PremultiplyAlpha width.cint, height.cint, src_format, src,
                         src_pitch.cint, dst_format, dst, dst_pitch.cint

# int SDL_SaveBMP_RW (SDL_Surface *surface, SDL_RWops *dst, int freedst)
# SDL_bool SDL_SetClipRect(SDL_Surface *surface, const SDL_Rect *rect)

proc SetColorKey*(surface: SurfacePtr, flag: bool, key: uint32): bool =
  ##  ```c
  ##  int SDL_SetColorKey(SDL_Surface *surface, int flag, Uint32 key);
  ##  ```
  ensure_zero "SDL_SetColorKey":
    SDL_SetColorKey surface, flag.cint, key

# int SDL_SetSurfaceAlphaMod(SDL_Surface *surface, Uint8 alpha)
# int SDL_SetSurfaceBlendMode(SDL_Surface *surface, SDL_BlendMode blendMode)
# int SDL_SetSurfaceColorMod(SDL_Surface *surface, Uint8 r, Uint8 g, Uint8 b)

proc SetSurfacePalette*(surface: SurfacePtr, palette: Palette): bool =
  ensure_zero "SDL_SetSurfacePalette":
    SDL_SetSurfacePalette surface, palette.addr

# int SDL_SetSurfaceRLE(SDL_Surface *surface, int flag)
# void SDL_SetYUVConversionMode(SDL_YUV_CONVERSION_MODE mode)
# int SDL_SoftStretch(SDL_Surface *src, const SDL_Rect *srcrect,
#     SDL_Surface *dst, const SDL_Rect *dstrect)
# int SDL_SoftStretchLinear(SDL_Surface *src, const SDL_Rect *srcrect,
#     SDL_Surface *dst, const SDL_Rect *dstrect)

proc UnlockSurface*(surface: SurfacePtr) =
  ##  ```c
  ##  void SDL_UnlockSurface(SDL_Surface *surface);
  ##  ```
  SDL_UnlockSurface surface

# int SDL_UpperBlit (SDL_Surface *src, const SDL_Rect *srcrect,
#     SDL_Surface *dst, SDL_Rect *dstrect)
# int SDL_UpperBlitScaled (SDL_Surface *src, const SDL_Rect *srcrect,
#     SDL_Surface *dst, SDL_Rect *dstrect)

# --------------------------------------------------------------------------- #
# <SDL2/SDL_system.h>                                                         #
# --------------------------------------------------------------------------- #

# TODO.

# --------------------------------------------------------------------------- #
# <SDL2/SDL_syswm.h>                                                          #
# --------------------------------------------------------------------------- #

# SDL_bool SDL_GetWindowWMInfo(SDL_Window *window, SDL_SysWMinfo *info)

# --------------------------------------------------------------------------- #
# <SDL2/SDL_timer.h>                                                          #
# --------------------------------------------------------------------------- #

proc AddTimer*(interval: uint32, callback: TimerCallback,
               param: pointer = nil): TimerID {.inline.} =
  ##  ```c
  ##  SDL_TimerID SDL_AddTimer(Uint32 interval, SDL_TimerCallback callback, void *param);
  ##  ```
  result = SDL_AddTimer(interval, callback, param)
  if result.int == 0:
    log_error "SDL_AddTimer failed: ", $SDL_GetError()

proc Delay*(ms: uint32) {.inline.} =
  ##  ```c
  ##  void SDL_Delay(Uint32 ms);
  ##  ```
  SDL_Delay ms

proc GetPerformanceCounter*(): uint64 {.inline.} =
  ##  ```c
  ##  Uint64 SDL_GetPerformanceCounter(void);
  ##  ```
  SDL_GetPerformanceCounter()

proc GetPerformanceFrequency*(): uint64 {.inline.} =
  ##  ```c
  ##  Uint64 SDL_GetPerformanceFrequency(void);
  ##  ```
  SDL_GetPerformanceFrequency()

proc GetTicks*(): uint32 {.inline.} =
  ##  Get the number of milliseconds since SDL library initialization.
  ##
  ##  This value wraps if the program runs for more than ~49 days.
  ##
  ##  This function is not recommended as of SDL 2.0.18; use `GetTicks64`_
  ##  instead, where the value doesn't wrap every ~49 days. There are places in
  ##  SDL where we provide a 32-bit timestamp that can not change without
  ##  breaking binary compatibility, though, so this function isn't officially
  ##  deprecated.
  ##
  ##  Returns an unsigned 32-bit value representing the number of milliseconds
  ##  since the SDL library initialized.
  ##
  ##  Original name: `SDL_GetTicks`
  SDL_GetTicks()

proc GetTicks64*(): uint64 {.inline.} =
  ##  Get the number of milliseconds since SDL library initialization.
  ##
  ##  Note that you should not use the `TICKS_PASSED` macro with values
  ##  returned by this function, as that macro does clever math to compensate for
  ##  the 32-bit overflow every ~49 days that `GetTicks`_ suffers from. 64-bit
  ##  values from this function can be safely compared directly.
  ##
  ##  For example, if you want to wait 100 ms, you could do this:
  ##
  ##  ```nim
  ##  let timeout = get_ticks64() + 100
  ##  while get_ticks64() < timeout:
  ##    # ... do work until timeout has elapsed
  ##  ```
  ##
  ##  Returns an unsigned 64-bit value representing the number of milliseconds
  ##  since the SDL library initialized.
  ##
  ##  This function is available since SDL 2.0.18.
  ##
  ##  Original name: `SDL_GetTicks64`
  SDL_GetTicks64()

proc RemoveTimer*(id: TimerID): bool {.discardable, inline.} =
  ##  ```c
  ##  SDL_bool SDL_RemoveTimer(SDL_TimerID id);
  ##  ```
  SDL_RemoveTimer id

# --------------------------------------------------------------------------- #
# <SDL2/SDL_touch.h>                                                          #
# --------------------------------------------------------------------------- #

when use_touch:

  proc GetNumTouchDevices*(): int =
    ##  Get the number of registered touch devices.
    ##  ```c
    ##  int SDL_GetNumTouchDevices(void);
    ##  ```
    SDL_GetNumTouchDevices()

  proc GetNumTouchFingers*(touch_id: TouchID): int =
    ##  Get the number of active fingers for a given touch device.
    ##
    ##  ```c
    ##  int SDL_GetNumTouchFingers(SDL_TouchID touchID);
    ##  ```
    SDL_GetNumTouchFingers touch_id

  proc GetTouchDevice*(index: int): TouchID =
    ##  Get the touch ID with the given index.
    ##
    ##  ```c
    ##  SDL_TouchID SDL_GetTouchDevice(int index);
    ##  ```
    SDL_GetTouchDevice index.cint

  proc GetTouchDeviceType*(touch_id: TouchID): TouchDeviceType =
    ##  Get the type of the given touch device.
    ##
    ##  This function is available since SDL 2.0.10.
    ##
    ##  ```c
    ##  SDL_TouchDeviceType SDL_GetTouchDeviceType(SDL_TouchID touchID);
    ##  ```
    available_since SDL_GetTouchDeviceType, "2.0.10"
    SDL_GetTouchDeviceType touch_id

  # XXX: change return type
  proc GetTouchFinger*(touch_id: TouchID, index: int): ptr Finger =
    ##  Get the finger object for specified touch device ID and finger index.
    ##
    ##  ```c
    ##  SDL_Finger * SDL_GetTouchFinger(SDL_TouchID touchID, int index);
    ##  ```
    SDL_GetTouchFinger touch_id, index.cint

  proc GetTouchName*(index: int): string =
    ##  Get the touch device name as reported from the driver or ""
    ##  if the index is invalid.
    ##
    ##  This function is available since SDL 2.0.22.
    ##
    ##  ```c
    ##  const char* SDL_GetTouchName(int index);
    ##  ```
    available_since SDL_GetTouchName, "2.0.22"
    $SDL_GetTouchName index.cint

# --------------------------------------------------------------------------- #
# <SDL2/SDL_version.h>                                                        #
# --------------------------------------------------------------------------- #

proc GetRevision*(): string =
  ##  Get the code revision of SDL that is linked against your program.
  ##
  ##  ```c
  ##  const char *SDL_GetRevision(void);
  ##  ```
  $SDL_GetRevision()

proc GetVersion*(): tuple[major, minor, patch: int] =
  ##  Get the version of SDL that is linked against your program.
  ##
  ##  ```c
  ##  void SDL_GetVersion(SDL_version *ver);
  ##  ```
  var ver = Version(major: 0, minor: 0, patch: 0)
  SDL_GetVersion ver.addr
  (ver.major.int, ver.minor.int, ver.patch.int)

# --------------------------------------------------------------------------- #
# <SDL2/SDL_video.h>                                                          #
# --------------------------------------------------------------------------- #

proc CreateWindow*(title: string, x: int, y: int, w: int, h: int,
                   flags = WindowFlags 0): Window =
  ##  Create a window with the specified position, dimensions, and flags.
  ##
  ##  ```c
  ##  SDL_Window * SDL_CreateWindow(const char *title, int x, int y,
  ##                                int w, int h, Uint32 flags);
  ##  ```
  ensure_not_nil "SDL_CreateWindow":
    SDL_CreateWindow title, x.cint, y.cint, w.cint, h.cint, flags.uint32

proc CreateWindow*(title: string, w: int, h: int,
                   flags = WindowFlags 0): Window {.inline.} =
  ##  Create a window with the specified position, dimensions, and flags.
  ##
  ##  ```c
  ##  SDL_Window * SDL_CreateWindow(const char *title, int x, int y,
  ##                                int w, int h, Uint32 flags);
  ##  ```
  CreateWindow title, WINDOWPOS_CENTERED, WINDOWPOS_CENTERED, w, h, flags

# SDL_Window * SDL_CreateWindowFrom(const void *data);

proc DestroyWindow*(window: Window) {.inline.} =
  ##  Destroy a window.
  ##
  ##  ```c
  ##  void SDL_DestroyWindow(SDL_Window *window);
  ##  ```
  SDL_DestroyWindow window

# int SDL_DestroyWindowSurface(SDL_Window *window)

proc DisableScreenSaver*() {.inline.} =
  ##  Prevent the screen from being blanked by a screen saver.
  ##
  ##  ```c
  ##  void SDL_DisableScreenSaver(void);
  ##  ```
  SDL_DisableScreenSaver()

proc EnableScreenSaver*() {.inline.} =
  ##  Allow the screen to be blanked by a screen saver.
  ##
  ##  ```c
  ##  void SDL_EnableScreenSaver(void);
  ##  ```
  SDL_EnableScreenSaver()

proc FlashWindow*(window: Window, operation: FlashOperation): bool =
  ##  Request a window to demand attention from the user.
  ##
  ##  This function is available since SDL 2.0.16.
  ##
  ##  ```c
  ##  int SDL_FlashWindow(SDL_Window *window, SDL_FlashOperation operation);
  ##  ```
  available_since SDL_FlashWindow, "2.0.16"
  ensure_zero "SDL_FlashWindow":
    SDL_FlashWindow window, operation

# SDL_GLContext SDL_GL_CreateContext(SDL_Window *window)
# void SDL_GL_DeleteContext(SDL_GLContext context)
# SDL_bool SDL_GL_ExtensionSupported(const char *extension)
# int SDL_GL_GetAttribute(SDL_GLattr attr, int *value)
# SDL_GLContext SDL_GL_GetCurrentContext(void)
# SDL_Window* SDL_GL_GetCurrentWindow(void)
# void SDL_GL_GetDrawableSize(SDL_Window *window, int *w, int *h)
# void *SDL_GL_GetProcAddress(const char *proc)
# int SDL_GL_GetSwapInterval(void)
# int SDL_GL_LoadLibrary(const char *path)
# int SDL_GL_MakeCurrent(SDL_Window *window, SDL_GLContext context)
# void SDL_GL_ResetAttributes(void)
# int SDL_GL_SetAttribute(SDL_GLattr attr, int value)
# int SDL_GL_SetSwapInterval(int interval)
# void SDL_GL_SwapWindow(SDL_Window *window)
# void SDL_GL_UnloadLibrary(void)
# SDL_DisplayMode * SDL_GetClosestDisplayMode(int displayIndex,
#     const SDL_DisplayMode *mode, SDL_DisplayMode *closest)

proc GetCurrentDisplayMode*(display_index: Natural,
                            mode: var DisplayMode): bool =
  ##  Get information about the current display mode.
  ##
  ##  Returns 0 on success or a negative error code on failure;
  ##  call `get_error() <#get_error,string>`_ for more information.
  ##
  ##  ```c
  ##  int SDL_GetCurrentDisplayMode(int displayIndex, SDL_DisplayMode *mode)
  ##  ```
  ensure_zero "SDL_GetCurrentDisplayMode":
    SDL_GetCurrentDisplayMode display_index.cint, mode.addr

proc GetCurrentVideoDriver*(): string {.inline.} =
  ##  Get the name of the currently initialized video driver.
  ##
  ##  Returns the name of the current video driver
  ##  or "" if no driver has been initialized.
  ##
  ##  ```c
  ##  const char *SDL_GetCurrentVideoDriver(void);
  ##  ```
  $SDL_GetCurrentVideoDriver()

proc GetDesktopDisplayMode*(display_index: Natural,
                            mode: var DisplayMode): bool =
  ##  Get information about the desktop's display mode.
  ##
  ##  ```c
  ##  int SDL_GetDesktopDisplayMode(int displayIndex, SDL_DisplayMode *mode);
  ##  ```
  ensure_zero "SDL_GetDesktopDisplayMode":
    SDL_GetDesktopDisplayMode display_index.cint, mode.addr

proc GetDisplayBounds*(display_index: Natural, rect: var Rect): bool =
  ##  Get the desktop area represented by a display.
  ##
  ##  ```c
  ##  int SDL_GetDisplayBounds(int displayIndex, SDL_Rect *rect);
  ##  ```
  ensure_zero "SDL_GetDisplayBounds":
    SDL_GetDisplayBounds(display_index.cint, rect.addr)

proc GetDisplayBounds*(display_index: Natural): Option[Rect] =
  ##  Get the desktop area represented by a display.
  ##
  ##  ```c
  ##  int SDL_GetDisplayBounds(int displayIndex, SDL_Rect *rect);
  ##  ```
  var bounds = Rect.init(-1, -1, -1, -1)
  if not GetDisplayBounds(display_index, bounds):
    return none Rect
  some bounds

# XXX: deprecate?
proc GetDisplayBounds*(display_index: Natural, x: var int, y: var int,
                       width: var int, height: var int): bool =
  ##  Get the desktop area represented by a display.
  ##
  ##  ```c
  ##  int SDL_GetDisplayBounds(int displayIndex, SDL_Rect *rect);
  ##  ```
  var bounds = Rect.init(-1, -1, -1, -1)
  if not GetDisplayBounds(display_index, bounds):
    return false
  (x, y, width, height) = (bounds.x, bounds.y, bounds.w, bounds.h)
  true

proc GetDisplayDPI*(display_index: int, ddpi: var float, hdpi: var float,
                    vdpi: var float): bool =
  ##  Get the dots/pixels-per-inch for a display.
  ##
  ##  This function is available since SDL 2.0.4.
  ##
  ##  ```c
  ##  int SDL_GetDisplayDPI(int displayIndex, float *ddpi, float *hdpi,
  ##                        float *vdpi);
  ##  ```
  available_since SDL_GetDisplayDPI, "2.0.4"
  var outd, outh, outv: cfloat
  ensure_zero "SDL_GetDisplayDPI":
    SDL_GetDisplayDPI display_index.cint, outd.addr, outh.addr,
                              outv.addr
  ddpi = outd
  hdpi = outh
  vdpi = outv

proc GetDisplayMode*(display_index: Natural, mode_index: int,
                     mode: var DisplayMode): bool =
  ##  Get information about a specific display mode.
  ##
  ##  ```c
  ##  int SDL_GetDisplayMode(int displayIndex, int modeIndex,
  ##                         SDL_DisplayMode *mode);
  ##  ```
  ensure_zero "SDL_GetDisplayMode":
    SDL_GetDisplayMode display_index.cint, mode_index.cint, mode.addr

proc GetDisplayName*(display_index: Natural): string =
  ##  Get the name of a display in UTF-8 encoding.
  ##
  ##  ```c
  ##  const char * SDL_GetDisplayName(int displayIndex);
  ##  ```
  let name = SDL_GetDisplayName display_index.cint
  if name == nil:
    log_error "SDL_GetDisplayName failed: ", $SDL_GetError()
    return ""
  $name

proc GetDisplayOrientation*(display_index: Natural): DisplayOrientation =
  ##  Get the orientation of a display.
  ##
  ##  This function is available since SDL 2.0.9.
  ##  Returns `ORIENTATION_UNKNOWN<nsdl2/sdl2inc/video.html#DisplayOrientation>`_
  ##  in SDL prior 2.0.9.
  ##
  ##  ```c
  ##  SDL_DisplayOrientation SDL_GetDisplayOrientation(int displayIndex);
  ##  ```
  # XXX: "available since"
  if SDL_GetDisplayOrientation == nil:
    log_warn "SDL_GetDisplayOrientation is available since SDL 2.0.9"
    return ORIENTATION_UNKNOWN
  SDL_GetDisplayOrientation display_index.cint

proc GetDisplayUsableBounds*(display_index: Natural, rect: var Rect): bool =
  ##  Get the usable desktop area represented by a display.
  ##
  ##  Available since SDL 2.0.5. Equal to `GetDisplayBounds`_ prior SDL 2.0.5.
  ##
  ##  ```c
  ##  int SDL_GetDisplayUsableBounds(int displayIndex, SDL_Rect *rect);
  ##  ```
  if unlikely SDL_GetDisplayUsableBounds == nil:
    # XXX: TODO: warn?
    return GetDisplayBounds(display_index, rect)

  ensure_zero "SDL_GetDisplayUsableBounds":
    SDL_GetDisplayUsableBounds(display_index.cint, rect.addr)

proc GetDisplayUsableBounds*(display_index: Natural): Option[Rect] =
  ##  Get the usable desktop area represented by a display.
  ##
  ##  Available since SDL 2.0.5. Equal to `GetDisplayBounds`_ prior SDL 2.0.5.
  ##
  ##  ```c
  ##  int SDL_GetDisplayUsableBounds(int displayIndex, SDL_Rect *rect);
  ##  ```
  var rect {.noinit.}: Rect
  if not GetDisplayUsableBounds(display_index, rect):
    return none Rect
  some rect

# XXX: deprecate?
proc GetDisplayUsableBounds*(display_index: Natural, x: var int, y: var int,
                             width: var int, height: var int): bool =
  ##  Get the usable desktop area represented by a display.
  ##
  ##  Available since SDL 2.0.5. Equal to `GetDisplayBounds`_ prior SDL 2.0.5.
  ##
  ##  ```c
  ##  int SDL_GetDisplayUsableBounds(int displayIndex, SDL_Rect *rect);
  ##  ```
  if unlikely SDL_GetDisplayUsableBounds == nil:
    # XXX: TODO: warn?
    return GetDisplayBounds(display_index, x, y, width, height)

  var bounds = Rect(x: 0, y: 0, w: 0, h: 0)
  if SDL_GetDisplayUsableBounds(display_index.cint, bounds.addr) != 0:
    log_error "SDL_GetDisplayUsableBounds failed: ", $SDL_GetError()
    return false
  (x, y, width, height) = (bounds.x, bounds.y, bounds.w, bounds.h)
  true

proc GetGrabbedWindow*(): Window =
  ##  Get the window that currently has an input grab enabled.
  ##
  ##  ```c
  ##  SDL_Window *SDL_GetGrabbedWindow(void);
  ##  ```
  available_since SDL_GetGrabbedWindow, "2.0.4"
  SDL_GetGrabbedWindow()

proc GetNumDisplayModes*(display_index: Natural): int =
  ##  Get the number of available display modes.
  ##
  ##  ```c
  ##  int SDL_GetNumDisplayModes(int displayIndex);
  ##  ```
  ensure_positive "SDL_GetNumDisplayModes":
    SDL_GetNumDisplayModes display_index.cint

proc GetNumVideoDisplays*(): int =
  ##  Get the number of available video displays.
  ##
  ##  ```c
  ##  int SDL_GetNumVideoDisplays(void);
  ##  ```
  ensure_positive "SDL_GetNumVideoDisplays":
    SDL_GetNumVideoDisplays()

proc GetNumVideoDrivers*(): int =
  ##  Get the number of video drivers compiled into SDL.
  ##
  ##  ```c
  ##  int SDL_GetNumVideoDrivers(void);
  ##  ```
  ensure_positive "SDL_GetNumVideoDrivers":
    SDL_GetNumVideoDrivers()

# int SDL_GetPointDisplayIndex(const SDL_Point *point)
# int SDL_GetRectDisplayIndex(const SDL_Rect *rect)

proc GetVideoDriver*(index: int): string {.inline.} =
  ##  Get the name of a built in video driver.
  ##
  ##  ```c
  ##  const char *SDL_GetVideoDriver(int index);
  ##  ```
  $SDL_GetVideoDriver index.cint

proc GetWindowBordersSize*(window: Window, top: var int, left: var int,
                           bottom: var int, right: var int): bool =
  ##  Get the size of a window's borders (decorations) around the client area.
  ##
  ##  This function is available since SDL 2.0.5.
  ##
  ##  ```c
  ##  int SDL_GetWindowBordersSize(SDL_Window *window, int *top, int *left, int *bottom, int *right);
  ##  ```
  available_since SDL_GetWindowBordersSize, "2.0.5"
  var out_top, out_left, out_bottom, out_right: cint
  ensure_zero "SDL_GetWindowBordersSize":
    SDL_GetWindowBordersSize window, out_top.addr, out_left.addr,
                                     out_bottom.addr, out_right.addr
  top     = out_top
  left    = out_left
  bottom  = out_bottom
  right   = out_right

# float SDL_GetWindowBrightness(SDL_Window *window)
# void *SDL_GetWindowData(SDL_Window *window, const char *name)

proc GetWindowDisplayIndex*(window: Window): int =
  ##  Get the index of the display associated with a window.
  ##
  ##  ```c
  ##  int SDL_GetWindowDisplayIndex(SDL_Window *window)
  ##  ```
  ensure_natural "SDL_GetWindowDisplayIndex":
    SDL_GetWindowDisplayIndex window

proc GetWindowDisplayMode*(window: Window, mode: var DisplayMode): bool =
  ##  Query the display mode to use when a window is visible at fullscreen.
  ##
  ##  ```c
  ##  int SDL_GetWindowDisplayMode(SDL_Window *window, SDL_DisplayMode *mode)
  ##  ```
  ensure_zero "SDL_GetWindowDisplayMode":
    SDL_GetWindowDisplayMode window, mode.addr

proc GetWindowFlags*(window: Window): WindowFlags {.inline.} =
  ##  Get the window flags.
  ##
  ##  ```c
  ##  Uint32 SDL_GetWindowFlags(SDL_Window *window);
  ##  ```
  SDL_GetWindowFlags window

proc GetWindowFromID*(id: uint32): Window =
  ##  Get a window from a stored ID.
  ##
  ##  ```c
  ##  SDL_Window * SDL_GetWindowFromID(Uint32 id);
  ##  ```
  ensure_not_nil "SDL_GetWindowFromID":
    SDL_GetWindowFromID id

# int SDL_GetWindowGammaRamp(SDL_Window *window, Uint16 *red, Uint16 *green, Uint16 *blue)

proc GetWindowGrab*(window: Window): bool {.inline.} =
  ##  Get a window's input grab mode.
  ##
  ##  ```c
  ##  SDL_bool SDL_GetWindowGrab(SDL_Window *window);
  ##  ```
  SDL_GetWindowGrab window

# void* SDL_GetWindowICCProfile(SDL_Window *window, size_t* size)

proc GetWindowID*(window: Window): uint32 =
  ##  Get the numeric ID of a window.
  ##
  ##  ```c
  ##  Uint32 SDL_GetWindowID(SDL_Window *window);
  ##  ```
  ensure_positive "SDL_GetWindowID":
    SDL_GetWindowID window

proc GetWindowKeyboardGrab*(window: Window): bool =
  ##  Get a window's keyboard grab mode.
  ##
  ##  This function is available since SDL 2.0.16.
  ##
  ##  ```c
  ##  SDL_bool SDL_GetWindowKeyboardGrab(SDL_Window *window);
  ##  ```
  available_since SDL_GetWindowKeyboardGrab, "2.0.16"
  SDL_GetWindowKeyboardGrab window

proc GetWindowMaximumSize*(window: Window): tuple[w, h: int] =
  ##  Get the maximum size of a window's client area.
  ##
  ##  ```c
  ##  void SDL_GetWindowMaximumSize(SDL_Window *window, int *w, int *h);
  ##  ```
  var outw, outh: cint = 0
  SDL_GetWindowMaximumSize window, outw.addr, outh.addr
  (outw.int, outh.int)

proc GetWindowMinimumSize*(window: Window): tuple[w, h: int] =
  ##  Get the minimum size of a window's client area.
  ##
  ##  ```c
  ##  void SDL_GetWindowMinimumSize(SDL_Window *window, int *w, int *h);
  ##  ```
  var outw, outh: cint = 0
  SDL_GetWindowMinimumSize window, outw.addr, outh.addr
  (outw.int, outh.int)

proc GetWindowMouseGrab*(window: Window): bool =
  ##  Get a window's mouse grab mode.
  ##
  ##  This function is available since SDL 2.0.16.
  ##
  ##  ```c
  ##  SDL_bool SDL_GetWindowMouseGrab(SDL_Window *window);
  ##  ```
  available_since SDL_GetWindowMouseGrab, "2.0.16"
  SDL_GetWindowMouseGrab window

proc GetWindowMouseRect*(window: Window): Rect =
  ##  Get the mouse confinement rectangle of a window.
  ##
  ##  This function is available since SDL 2.0.18.
  ##
  ##  ```c
  ##  const SDL_Rect * SDL_GetWindowMouseRect(SDL_Window *window);
  ##  ```
  available_since SDL_GetWindowMouseRect, "2.0.18"
  let rect = SDL_GetWindowMouseRect window
  if rect == nil:
    return Rect.init(-1, -1, -1, -1)
  rect[]

proc GetWindowOpacity*(window: Window, opacity: var float): bool =
  ##  Get the opacity of a window.
  ##
  ##  This function is available since SDL 2.0.5.
  ##
  ##  ```c
  ##  int SDL_GetWindowOpacity(SDL_Window *window, float *out_opacity);
  ##  ```
  available_since SDL_GetWindowOpacity, "2.0.5"
  var outval: cfloat = 0.0
  #if SDL_GetWindowOpacity == nil:
  #  error "SDL_GetWindowOpacity is available since SDL 2.0.5"
  #  return false

  ensure_zero "SDL_GetWindowOpacity":
    SDL_GetWindowOpacity window, outval.addr

  opacity = outval

proc GetWindowPixelFormat*(window: Window): PixelFormatEnum {.inline.} =
  ##  Get the pixel format associated with the window.
  ##
  ##  Returns the pixel format of the window on success
  ##  or `PIXELFORMAT_UNKNOWN<nsdl2/sdl2inc/pixels.html#PixelFormatEnum>`_
  ##  on failure; call `get_error <#get_error,string>`_ for more information.
  ##
  ##  ```c
  ##  Uint32 SDL_GetWindowPixelFormat(SDL_Window *window);
  ##  ```
  SDL_GetWindowPixelFormat window

proc GetWindowPosition*(window: Window): tuple[x, y: int] =
  ##  Get the position of a window.
  ##
  ##  ```c
  ##  void SDL_GetWindowPosition(SDL_Window *window, int *x, int *y);
  ##  ```
  var outx, outy: cint = 0
  SDL_GetWindowPosition window, outx.addr, outy.addr
  (outx.int, outy.int)

proc GetWindowSize*(window: Window): tuple[w, h: int] =
  ##  Get the size of a window's client area.
  ##
  ##  ```c
  ##  void SDL_GetWindowSize(SDL_Window *window, int *w, int *h);
  ##  ```
  var outw, outh: cint = 0
  SDL_GetWindowSize window, outw.addr, outh.addr
  (outw.int, outh.int)

proc GetWindowSizeInPixels*(window: Window): tuple[w, h: int] =
  ##  Get the size of a window in pixels.
  ##
  ##  This function is available since SDL 2.26.0.
  ##
  ##  ```c
  ##  void SDL_GetWindowSizeInPixels(SDL_Window *window, int *w, int *h);
  ##  ```
  available_since SDL_GetWindowSizeInPixels, "2.26.0"
  var outw: cint = 0
  var outh: cint = 0
  SDL_GetWindowSizeInPixels window, outw.addr, outh.addr
  (outw.int, outh.int)

proc GetWindowSurface*(window: Window): SurfacePtr =
  ##  Get the SDL surface associated with the window.
  ##
  ##  ```c
  ##  SDL_Surface * SDL_GetWindowSurface(SDL_Window *window);
  ##  ```
  ensure_not_nil "SDL_GetWindowSurface":
    SDL_GetWindowSurface window

proc GetWindowTitle*(window: Window): string {.inline.} =
  ##  Get the title of a window.
  ##
  ##  Params:
  ##  - `window` - the window to query
  ##
  ##  Returns the title of the window in UTF-8 format or `""` if there is no
  ##  title.
  ##
  ##  Original name: `SDL_GetWindowTitle`
  $SDL_GetWindowTitle window

proc HasWindowSurface*(window: Window): bool =
  ##  Return whether the window has a surface associated with it.
  ##
  ##  This function is available since SDL 2.28.0.
  ##
  ##  ```c
  ##  SDL_bool SDL_HasWindowSurface(SDL_Window *window);
  ##  ```
  available_since SDL_HasWindowSurface, "2.28.0"
  SDL_HasWindowSurface window

proc HideWindow*(window: Window) {.inline.} =
  ##  Hide a window.
  ##
  ##  Params:
  ##  - `window` - the window to hide
  ##
  ##  Original name: `SDL_HideWindow`
  SDL_HideWindow window

# SDL_bool SDL_IsScreenSaverEnabled(void)

proc MaximizeWindow*(window: Window) {.inline.} =
  ##  Make a window as large as possible.
  ##
  ##  ```c
  ##  void SDL_MaximizeWindow(SDL_Window *window);
  ##  ```
  SDL_MinimizeWindow window

proc MinimizeWindow*(window: Window) {.inline.} =
  ##  Minimize a window to an iconic representation.
  ##
  ##  ```c
  ##  void SDL_MinimizeWindow(SDL_Window *window);
  ##  ```
  SDL_MinimizeWindow window

proc RaiseWindow*(window: Window) {.inline.} =
  ##  Raise a window above other windows and set the input focus.
  ##
  ##  ```c
  ##  void SDL_RaiseWindow(SDL_Window *window);
  ##  ```
  SDL_RaiseWindow window

proc RestoreWindow*(window: Window) {.inline.} =
  ##  Restore the size and position of a minimized or maximized window.
  ##
  ##  ```c
  ##  void SDL_RestoreWindow(SDL_Window *window);
  ##  ```
  SDL_RestoreWindow window

proc SetWindowAlwaysOnTop*(window: Window, on_top: bool): bool =
  ##  Set the window to always be above the others.
  ##
  ##  This function is available since SDL 2.0.16.
  ##
  ##  ```c
  ##  void SDL_SetWindowAlwaysOnTop(SDL_Window *window, SDL_bool on_top);
  ##  ```
  if SDL_SetWindowAlwaysOnTop == nil:
    log_error "SDL_SetWindowKeyboardGrab is available since SDL 2.0.16"
    return false
  SDL_SetWindowAlwaysOnTop window, on_top
  true

proc SetWindowBordered*(window: Window, bordered: bool) {.inline.} =
  ##  Set the border state of a window.
  ##
  ##  ```c
  ##  void SDL_SetWindowBordered(SDL_Window *window, SDL_bool bordered);
  ##  ```
  SDL_SetWindowBordered window, bordered

# int SDL_SetWindowBrightness(SDL_Window *window, float brightness)
# void* SDL_SetWindowData(SDL_Window *window, const char *name, void *userdata)

proc SetWindowDisplayMode*(window: Window, mode: DisplayMode): bool =
  ##  Set the display mode to use when a window is visible at fullscreen.
  ##
  ##  ```c
  ##  int SDL_SetWindowDisplayMode(SDL_Window *window, const SDL_DisplayMode *mode);
  ##  ```
  when NimMajor < 2:
    var mode = mode
  ensure_zero "SDL_SetWindowDisplayMode":
    SDL_SetWindowDisplayMode window, mode.addr

proc SetWindowFullscreen*(window: Window, flags = WindowFlags 0): bool =
  ##  Set a window's fullscreen state.
  ##
  ##  ```c
  ##  int SDL_SetWindowFullscreen(SDL_Window *window, Uint32 flags);
  ##  ```
  ensure_zero "SDL_SetWindowFullscreen":
    SDL_SetWindowFullscreen window, flags.uint32

# int SDL_SetWindowGammaRamp(SDL_Window *window, const Uint16 *red,
#     const Uint16 *green, const Uint16 *blue)

proc SetWindowGrab*(window: Window, grabbed: bool) {.inline.} =
  ##  Set a window's input grab mode.
  ##
  ##  ```c
  ##  void SDL_SetWindowGrab(SDL_Window *window, SDL_bool grabbed);
  ##  ```
  SDL_SetWindowGrab window, grabbed

proc SetWindowHitTest*(window: Window, callback: HitTest,
                       callback_data: pointer): bool =
  ##  Provide a callback that decides if a window region has special
  ##  properties.
  ##
  ##  This function is available since SDL 2.0.4.
  ##
  ##  ```c
  ##  int SDL_SetWindowHitTest(SDL_Window *window, SDL_HitTest callback, void *callback_data);
  ##  ```
  available_since SDL_SetWindowHitTest, "2.0.4"
  ensure_zero "SDL_SetWindowHitTest":
    SDL_SetWindowHitTest window, callback, callback_data

proc SetWindowIcon*(window: Window, surface: SurfacePtr) {.inline.} =
  ##  Set the icon for a window.
  ##
  ##  ```c
  ##  void SDL_SetWindowIcon(SDL_Window *window, SDL_Surface *icon);
  ##  ```
  SDL_SetWindowIcon window, surface

proc SetWindowInputFocus*(window: Window): bool {.deprecated: "use RaiseWindow instead".} =
  ##  Explicitly set input focus to the window.
  ##
  ##  ```c
  ##  int SDL_SetWindowInputFocus(SDL_Window *window);
  ##  ```
  # XXX: available_since SDL_SetWindowInputFocus, "2.0.5"
  false

proc SetWindowKeyboardGrab*(window: Window, grabbed: bool): bool =
  ##  Set a window's keyboard grab mode.
  ##
  ##  This function is available since SDL 2.0.16.
  ##
  ##  ```c
  ##  void SDL_SetWindowKeyboardGrab(SDL_Window *window, SDL_bool grabbed);
  ##  ```
  available_since SDL_SetWindowKeyboardGrab, "2.0.16"
  SDL_SetWindowKeyboardGrab window, grabbed
  true

proc SetWindowMaximumSize*(window: Window, max_w: int, max_h: int) {.inline.} =
  ##  Set the maximum size of a window's client area.
  ##
  ##  ```c
  ##  void SDL_SetWindowMaximumSize(SDL_Window *window, int max_w, int max_h);
  ##  ```
  SDL_SetWindowMaximumSize window, max_w.cint, max_h.cint

proc SetWindowMinimumSize*(window: Window, min_w: int, min_h: int) {.inline.} =
  ##  Set the minimum size of a window's client area.
  ##
  ##  ```c
  ##  void SDL_SetWindowMinimumSize(SDL_Window *window, int min_w, int min_h);
  ##  ```
  SDL_SetWindowMinimumSize window, min_w.cint, min_h.cint

proc SetWindowModalFor*(modal_window: Window, parent_window: Window): bool =
  ##  Set the window as a modal for another window.
  ##
  ##  This function is available since SDL 2.0.5.
  ##
  ##  ```c
  ##  int SDL_SetWindowModalFor(SDL_Window *modal_window,
  ##                            SDL_Window *parent_window);
  ##  ```
  available_since SDL_SetWindowModalFor, "2.0.5"
  ensure_zero "SDL_SetWindowModalFor":
    SDL_SetWindowModalFor modal_window, parent_window

proc SetWindowMouseGrab*(window: Window, grabbed: bool): bool {.discardable.} =
  ##  Set a window's mouse grab mode.
  ##
  ##  This function is available since SDL 2.0.16.
  ##
  ##  ```c
  ##  void SDL_SetWindowMouseGrab(SDL_Window *window, SDL_bool grabbed);
  ##  ```
  available_since SDL_SetWindowMouseGrab, "2.0.16"
  SDL_SetWindowMouseGrab window, grabbed
  true

proc SetWindowMouseRect*(window: Window, rect: Rect): bool =
  ##  Confines the cursor to the specified area of a window.
  ##
  ##  This function is available since SDL 2.0.18.
  ##
  ##  ```c
  ##  int SDL_SetWindowMouseRect(SDL_Window *window, const SDL_Rect *rect);
  ##  ```
  available_since SDL_SetWindowMouseRect, "2.0.18"
  when NimMajor < 2:
    var rect = rect
  ensure_zero "SDL_SetWindowMouseRect":
    SDL_SetWindowMouseRect window, rect.addr

proc SetWindowOpacity*(window: Window, opacity: float): bool =
  ##  Set the opacity for a window.
  ##
  ##  This function is available since SDL 2.0.5.
  ##
  ##  ```c
  ##  int SDL_SetWindowOpacity(SDL_Window *window, float opacity);
  ##  ```
  available_since SDL_SetWindowOpacity, "2.0.5"
  ensure_zero "SDL_SetWindowOpacity":
    SDL_SetWindowOpacity window, opacity.cfloat

proc SetWindowPosition*(window: Window, x: int, y: int) {.inline.} =
  ##  Set the position of a window.
  ##
  ##  .. note::
  ##    Centering the window after returning from full screen moves
  ##    the window to primary display.
  ##
  ##  ```c
  ##  void SDL_SetWindowPosition(SDL_Window *window, int x, int y);
  ##  ```
  SDL_SetWindowPosition window, x.cint, y.cint

proc SetWindowResizable*(window: Window, ontop: bool): bool {.discardable.} =
  ##  Set the user-resizable state of a window.
  ##
  ##  This function is available since SDL 2.0.5.
  ##
  ##  ```c
  ##  void SDL_SetWindowResizable(SDL_Window *window, SDL_bool resizable);
  ##  ```
  available_since SDL_SetWindowResizable, "2.0.5"
  SDL_SetWindowResizable window, ontop
  true

proc SetWindowSize*(window: Window, x: int, y: int) {.inline.} =
  ##  Set the size of a window's client area.
  ##
  ##  ```c
  ##  void SDL_SetWindowSize(SDL_Window *window, int w, int h);
  ##  ```
  SDL_SetWindowSize window, x.cint, y.cint

proc SetWindowTitle*(window: Window, title: string) {.inline.} =
  ##  Set the title of a window.
  ##
  ##  This string is expected to be in UTF-8 encoding.
  ##
  ##  Params:
  ##  - `window` - the window to change
  ##  - `title` - the desired window title in UTF-8 format
  ##
  ##  Original name: `SDL_SetWindowTitle`
  SDL_SetWindowTitle window, title

proc ShowWindow*(window: Window) {.inline.} =
  ##  Show a window.
  ##
  ##  Params:
  ##  - `window` - the window to show
  ##
  ##  Original name: `SDL_ShowWindow`
  SDL_ShowWindow window

proc UpdateWindowSurface*(window: Window): bool =
  ##  Copy the window surface to the screen.
  ##
  ##  ```c
  ##  int SDL_UpdateWindowSurface(SDL_Window *window);
  ##  ```
  ensure_zero "SDL_UpdateWindowSurface":
    SDL_UpdateWindowSurface window

# int SDL_UpdateWindowSurfaceRects(SDL_Window *window, const SDL_Rect *rects,
#     int numrects)

proc VideoInit*(): bool =
  ##  Initialize the video subsystem.
  ensure_zero "SDL_VideoInit":
    SDL_VideoInit nil

proc VideoInit*(driver_name: string): bool =
  ##  Initialize the video subsystem, optionally specifying a video driver.
  ##
  ##  ```c
  ##  int SDL_VideoInit(const char *driver_name);
  ##  ```
  ensure_zero "SDL_VideoInit":
    SDL_VideoInit driver_name.cstring

proc VideoQuit*() {.inline.} =
  ##  Shut down the video subsystem, if initialized with
  ##  `VideoInit() <#VideoInit,string>`_.
  ##
  ##  ```c
  ##  void SDL_VideoQuit(void);
  ##  ```
  SDL_VideoQuit()

# --------------------------------------------------------------------------- #
# <SDL2/SDL_vulkan.h>                                                         #
# --------------------------------------------------------------------------- #

# SDL_bool SDL_Vulkan_CreateSurface(SDL_Window *window, VkInstance instance, VkSurfaceKHR* surface)
# void SDL_Vulkan_GetDrawableSize(SDL_Window *window, int *w, int *h)
# SDL_bool SDL_Vulkan_GetInstanceExtensions(SDL_Window *window, unsigned int *pCount, const char **pNames)
# void *SDL_Vulkan_GetVkGetInstanceProcAddr(void)
# int SDL_Vulkan_LoadLibrary(const char *path)
# void SDL_Vulkan_UnloadLibrary(void)

# =========================================================================== #
# ==  C macros                                                             == #
# =========================================================================== #

when use_audio:
  proc LoadWAV*(file: string, spec: var AudioSpec,
                audio_buf: var ptr UncheckedArray[byte],
                audio_len: var uint32): ptr AudioSpec {.inline.} =
    ##  ```c
    ##  #define SDL_LoadWAV(file, spec, audio_buf, audio_len) \
    ##      SDL_LoadWAV_RW(SDL_RWFromFile(file, "rb"),1, spec,audio_buf,audio_len)
    ##  ```
    LoadWAV_RW_unchecked RWFromFile(file, "rb"), true, spec, audio_buf,
                         audio_len

# --------------------------------------------------------------------------- #
# <SDL/SDL_quit.h>                                                            #
# --------------------------------------------------------------------------- #

proc QuitRequested*(): bool {.inline.} =
  ##  ```c
  ##  #define SDL_QuitRequested() \
  ##      SDL_PumpEvents(), \
  ##      (SDL_PeepEvents(NULL,0,SDL_PEEKEVENT,SDL_QUIT,SDL_QUIT) > 0))
  ##  ```
  PumpEvents()
  var events: seq[Event] = @[]
  PeepEvents(events, 0, PEEKEVENT, EVENT_QUIT, EVENT_QUIT) > 0

# --------------------------------------------------------------------------- #
# <SDL/SDL_video.h>                                                           #
# --------------------------------------------------------------------------- #

proc LoadBMP*(file: string): SurfacePtr {.inline.} =
  ##  ```c
  ##  #define SDL_LoadBMP(file) SDL_LoadBMP_RW(SDL_RWFromFile(file, "rb"), 1);
  ##  ```
  LoadBMP_RW_unchecked RWFromFile(file, "rb"), true

# =========================================================================== #
# ==  Helper functions                                                     == #
# =========================================================================== #

proc GetVersionString*(): string =
  let ver = GetVersion()
  $ver.major & '.' & $ver.minor & '.' & $ver.patch

proc sdl2_avail*(flags = INIT_VIDEO): bool =
  result = Init flags
  if result:
    Quit()

# vim: set sts=2 et sw=2:
