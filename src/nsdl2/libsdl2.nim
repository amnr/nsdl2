##  SDL 2.0 ABI.
##
#[
  SPDX-License-Identifier: NCSA OR MIT OR Zlib
]#

{.push raises: [].}

import pkg/dlutils

import config

when use_audio:
  import sdl2inc/sdl2audio
when use_blendmode:
  import sdl2inc/sdl2blendmode
# XXX: use_gamecontroller
# XXX: use_gesture
import sdl2inc/sdl2events
# XXX: use_haptic
when use_hints:
  import sdl2inc/sdl2hints
import sdl2inc/sdl2init
when use_joystick:
  import sdl2inc/sdl2joystick
when use_keyboard:
  import sdl2inc/sdl2keycode
import sdl2inc/sdl2log
when use_messagebox:
  import sdl2inc/sdl2messagebox
when use_mouse:
  import sdl2inc/sdl2mouse
import sdl2inc/sdl2pixels
import sdl2inc/sdl2rect
import sdl2inc/sdl2render
import sdl2inc/sdl2rwops
# XXX: use_sensor
# XXX: use_shape
import sdl2inc/sdl2surface
import sdl2inc/sdl2timer
when use_touch:
  import sdl2inc/sdl2touch
import sdl2inc/sdl2version
import sdl2inc/sdl2video

when defined macosx:
  const lib_paths = [
    "libSDL2-2.0.0.dylib",
    "libSDL2.dylib"
  ]
elif defined posix:
  const lib_paths = [
    "libSDL2-2.0.so",
    "libSDL2-2.0.so.0"
  ]
elif defined windows:
  const lib_paths = [
    "SDL2.dll"
  ]
else:
  {.fatal: "unsupported platform.".}

# =========================================================================== #
# ==  SDL2 library object                                                  == #
# =========================================================================== #

dlgencalls "sdl2", lib_paths:

  # ------------------------------------------------------------------------- #
  # <SDL2/SDL.h>                                                              #
  # ------------------------------------------------------------------------- #

  proc SDL_Init(flags: InitFlags): cint

  proc SDL_InitSubSystem(flags: InitFlags): cint

  proc SDL_Quit()

  proc SDL_QuitSubSystem(flags: InitFlags)

  proc SDL_WasInit(flags: InitFlags): InitFlags

  # ------------------------------------------------------------------------- #
  # <SDL2/SDL_audio.h>                                                        #
  # ------------------------------------------------------------------------- #

  when use_audio:

    proc SDL_AudioInit(driver_name: cstring): cint

    proc SDL_AudioQuit()

    # int SDL_AudioStreamAvailable(SDL_AudioStream *stream)
    # void SDL_AudioStreamClear(SDL_AudioStream *stream)
    # int SDL_AudioStreamFlush(SDL_AudioStream *stream)
    # int SDL_AudioStreamGet(SDL_AudioStream *stream, void *buf, int len)
    # int SDL_AudioStreamPut(SDL_AudioStream *stream, const void *buf, int len)
    # int SDL_BuildAudioCVT(SDL_AudioCVT *cvt, SDL_AudioFormat src_format,
    #     Uint8 src_channels, int src_rate, SDL_AudioFormat dst_format,
    #     Uint8 dst_channels, int dst_rate)
    # void SDL_ClearQueuedAudio(SDL_AudioDeviceID dev)

    proc SDL_CloseAudio()

    proc SDL_CloseAudioDevice(dev: AudioDeviceID)

    # int SDL_ConvertAudio(SDL_AudioCVT *cvt)
    # Uint32 SDL_DequeueAudio(SDL_AudioDeviceID dev, void *data, Uint32 len)
    # void SDL_FreeAudioStream(SDL_AudioStream *stream)

    proc SDL_FreeWAV(audio_buf: ptr UncheckedArray[byte])

    proc SDL_GetAudioDeviceName(
      index     : cint,
      iscapture : cint
    ): cstring

    proc SDL_GetAudioDeviceSpec(
      index     : cint,
      iscapture : cint,
      spec      : ptr AudioSpec
    ): cint {.unchecked.}   # SDL 2.0.16.

    proc SDL_GetAudioDeviceStatus(dev: AudioDeviceID): AudioStatus

    proc SDL_GetAudioDriver(index: cint): cstring

    proc SDL_GetAudioStatus(): AudioStatus

    proc SDL_GetCurrentAudioDriver(): cstring

    # Since SDL 2.24.0.
    proc SDL_GetDefaultAudioInfo(
      name      : ptr cstring,
      spec      : ptr AudioSpec,
      iscapture : cint
    ): cint {.unchecked.}

    proc SDL_GetNumAudioDevices(iscapture: cint): cint

    proc SDL_GetNumAudioDrivers(): cint

    # Since SDL 2.0.4.
    proc SDL_GetQueuedAudioSize(dev: AudioDeviceID): uint32 {.unchecked.}

    proc SDL_LoadWAV_RW(
      src       : RWops,
      freesrc   : cint,
      spec      : ptr AudioSpec,
      audio_buf : ptr ptr UncheckedArray[byte],
      audio_len : ptr uint32
    ): ptr AudioSpec

    # void SDL_LockAudio(void)
    # void SDL_LockAudioDevice(SDL_AudioDeviceID dev)

    proc SDL_MixAudio(
      dst       : ptr UncheckedArray[byte],
      src       : ptr byte,
      len       : uint32,
      volume    : cint
    )

    # void SDL_MixAudio(Uint8 *dst, const Uint8 *src, Uint32 len, int volume)
    # void SDL_MixAudioFormat(Uint8 *dst, const Uint8 *src,
    #     SDL_AudioFormat format, Uint32 len, int volume)
    # SDL_AudioStream *SDL_NewAudioStream(const SDL_AudioFormat src_format,
    #     const Uint8 src_channels, const int src_rate,
    #     const SDL_AudioFormat dst_format, const Uint8 dst_channels,
    #     const int dst_rate)

    proc SDL_OpenAudio(
      desired   : ptr AudioSpec,
      obtained  : ptr AudioSpec
    ): cint

    proc SDL_OpenAudioDevice(
      device          : cstring,
      iscapture       : cint,
      desired         : ptr AudioSpec,
      obtained        : ptr AudioSpec,
      allowed_changes : AudioAllowFlags
    ): AudioDeviceID

    proc SDL_PauseAudio(pause_on: cint)

    proc SDL_PauseAudioDevice(dev: AudioDeviceID, pause_on: cint)

    # Since SDL 2.0.4.
    proc SDL_QueueAudio(
      dev       : AudioDeviceID,
      data      : pointer,
      len       : uint32
    ): cint {.unchecked.}

    # void SDL_UnlockAudio(void)
    # void SDL_UnlockAudioDevice(SDL_AudioDeviceID dev)

  # ------------------------------------------------------------------------- #
  # <SDL2/SDL_blendmode.h>                                                    #
  # ------------------------------------------------------------------------- #

  # when use_blendmode:
  # SDL_BlendMode SDL_ComposeCustomBlendMode(SDL_BlendFactor srcColorFactor,
  #     SDL_BlendFactor dstColorFactor, SDL_BlendOperation colorOperation,
  #     SDL_BlendFactor srcAlphaFactor, SDL_BlendFactor dstAlphaFactor,
  #     SDL_BlendOperation alphaOperation)

  # ------------------------------------------------------------------------- #
  # <SDL2/SDL_clipboard.h>                                                    #
  # ------------------------------------------------------------------------- #

  when use_clipboard:

    proc SDL_GetClipboardText(): cstring

    proc SDL_GetPrimarySelectionText(): cstring

    proc SDL_HasClipboardText(): SdlBool

    proc SDL_HasPrimarySelectionText(): SdlBool

    proc SDL_SetClipboardText(text: cstring): cint

    proc SDL_SetPrimarySelectionText(text: cstring): cint

  # ------------------------------------------------------------------------- #
  # <SDL2/SDL_error.h>                                                        #
  # ------------------------------------------------------------------------- #

  proc SDL_ClearError()

  # int SDL_Error(SDL_errorcode code)

  proc SDL_GetError(): cstring

  # char *SDL_GetErrorMsg(char *errstr, int maxlen)

  proc SDL_SetError(fmt: cstring): cint {.varargs.}

  # ------------------------------------------------------------------------- #
  # <SDL2/SDL_events.h>                                                       #
  # ------------------------------------------------------------------------- #

  # void SDL_AddEventWatch(SDL_EventFilter filter, void *userdata)
  # void SDL_DelEventWatch(SDL_EventFilter filter, void *userdata)

  proc SDL_EventState(typ: EventType, state: cint): byte

  # void SDL_FilterEvents(SDL_EventFilter filter, void *userdata)

  proc SDL_FlushEvent(typ: EventType)

  proc SDL_FlushEvents(min_type, max_type: EventType)

  # SDL_bool SDL_GetEventFilter(SDL_EventFilter *filter, void **userdata)
  # SDL_bool SDL_HasEvent(Uint32 type)
  # SDL_bool SDL_HasEvents(Uint32 minType, Uint32 maxType)

  proc SDL_PeepEvents(events: ptr Event, numevents: cint, action: EventAction,
                      min_type, max_type: EventType): cint

  proc SDL_PollEvent(event: ptr Event): cint

  proc SDL_PumpEvents()

  proc SDL_PushEvent(event: ptr Event): cint

  # Uint32 SDL_RegisterEvents(int numevents)
  # void SDL_SetEventFilter(SDL_EventFilter filter, void *userdata)

  proc SDL_WaitEvent(event: ptr Event): cint

  proc SDL_WaitEventTimeout(event: ptr Event, timeout: cint): cint

  # ------------------------------------------------------------------------- #
  # <SDL2/SDL_filesystem.h>                                                   #
  # ------------------------------------------------------------------------- #

  # XXX TODO.

  # ------------------------------------------------------------------------- #
  # <SDL2/SDL_gamecontroller.h>                                               #
  # ------------------------------------------------------------------------- #

  when use_gamecontroller:

    proc SDL_GameControllerUpdate()

  # XXX TODO.
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
  # Uint64 SDL_GameControllerGetSteamHandle(SDL_GameController *gamecontroller)
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
  # SDL_bool SDL_IsGameController(int joystick_index)

  # ------------------------------------------------------------------------- #
  # <SDL2/SDL_gesture.h>                                                      #
  # ------------------------------------------------------------------------- #

  # XXX TODO.
  # int SDL_LoadDollarTemplates(SDL_TouchID touchId, SDL_RWops *src)
  # int SDL_RecordGesture(SDL_TouchID touchId)
  # int SDL_SaveAllDollarTemplates(SDL_RWops *dst)
  # int SDL_SaveDollarTemplate(SDL_GestureID gestureId,SDL_RWops *dst)

  # ------------------------------------------------------------------------- #
  # <SDL2/SDL_haptic.h>                                                       #
  # ------------------------------------------------------------------------- #

  # XXX TODO.

  # ------------------------------------------------------------------------- #
  # <SDL2/SDL_hidapi.h>                                                       #
  # ------------------------------------------------------------------------- #

  # XXX TODO.

  # ------------------------------------------------------------------------- #
  # <SDL2/SDL_hints.h>                                                        #
  # ------------------------------------------------------------------------- #

  when use_hints:

    # void SDL_AddHintCallback(const char *name, SDL_HintCallback callback,
    #     void *userdata)
    # void SDL_ClearHints(void)
    # void SDL_DelHintCallback(const char *name, SDL_HintCallback callback,
    #     void *userdata)

    proc SDL_GetHint(name: HintName): cstring

    # SDL_bool SDL_GetHintBoolean(const char *name, SDL_bool default_value)
    # SDL_bool SDL_ResetHint(const char *name)
    # void SDL_ResetHints(void)

    proc SDL_SetHint(name: cstring, value: cstring): SdlBool

    # SDL_bool SDL_SetHintWithPriority(const char *name, const char *value,
    #     SDL_HintPriority priority)

  # ------------------------------------------------------------------------- #
  # <SDL2/SDL_joystick.h>                                                     #
  # ------------------------------------------------------------------------- #

  when use_joystick:

    # Since SDL 2.0.0.
    proc SDL_JoystickClose(joystick: Joystick)

    # Since SDL 2.0.0.
    proc SDL_JoystickGetGUID(joystick: Joystick): JoystickGUID

    # Since SDL 2.0.0.
    proc SDL_JoystickGetGUIDString(
      guid      : JoystickGUID,
      psz_guid  : ptr char,
      cb_guid   : cint
    )

    # Since SDL 2.0.6.
    proc SDL_JoystickGetDeviceProduct(device_index: cint): uint16 {.unchecked.}

    # Since SDL 2.0.6.
    proc SDL_JoystickGetDeviceVendor(device_index: cint): uint16 {.unchecked.}

    # Since SDL 2.0.6.
    proc SDL_JoystickGetProduct(joystick: Joystick): uint16 {.unchecked.}

    # Since SDL 2.0.14.
    proc SDL_JoystickGetSerial(joystick: Joystick): cstring {.unchecked.}

    # Since SDL 2.0.6.
    proc SDL_JoystickGetType(joystick: Joystick): JoystickType {.unchecked.}

    # Since SDL 2.0.6.
    proc SDL_JoystickGetVendor(joystick: Joystick): uint16 {.unchecked.}

    # Since SDL 2.0.14.
    proc SDL_JoystickHasLED(joystick: Joystick): SdlBool {.unchecked.}

    # Since SDL 2.0.18.
    proc SDL_JoystickHasRumble(joystick: Joystick): SdlBool {.unchecked.}

    # Since SDL 2.0.18.
    proc SDL_JoystickHasRumbleTriggers(joystick: Joystick): SdlBool {.unchecked.}

    # Since SDL 2.0.0.
    proc SDL_JoystickName(joystick: Joystick): cstring

    # Since SDL 2.0.0.
    proc SDL_JoystickNumAxes(joystick: Joystick): cint

    # Since SDL 2.0.0.
    proc SDL_JoystickNumBalls(joystick: Joystick): cint

    # Since SDL 2.0.0.
    proc SDL_JoystickNumButtons(joystick: Joystick): cint

    # Since SDL 2.0.0.
    proc SDL_JoystickNumHats(joystick: Joystick): cint

    # Since SDL 2.0.0.
    proc SDL_JoystickOpen(device_index: cint): Joystick

    # Since SDL 2.24.0.
    proc SDL_JoystickPath(joystick: Joystick): cstring {.unchecked.}

    # Since SDL 2.0.0.
    proc SDL_JoystickUpdate()

    # Since SDL 2.0.0.
    proc SDL_NumJoysticks(): cint

    # void SDL_GetJoystickGUIDInfo(SDL_JoystickGUID guid, Uint16 *vendor,
    #     Uint16 *product, Uint16 *version, Uint16 *crc16)
    # int SDL_JoystickAttachVirtual(SDL_JoystickType type,
    # int SDL_JoystickAttachVirtualEx(const SDL_VirtualJoystickDesc *desc)
    # SDL_JoystickPowerLevel SDL_JoystickCurrentPowerLevel(joystick: Joystick)
    # int SDL_JoystickDetachVirtual(device_index: cint)
    # int SDL_JoystickEventState(int state)
    # SDL_Joystick *SDL_JoystickFromInstanceID(SDL_JoystickID instance_id)
    # SDL_Joystick *SDL_JoystickFromPlayerIndex(int player_index)
    # SDL_bool SDL_JoystickGetAttached(joystick: Joystick)
    # Sint16 SDL_JoystickGetAxis(joystick: Joystick,
    # SDL_bool SDL_JoystickGetAxisInitialState(joystick: Joystick,
    # int SDL_JoystickGetBall(joystick: Joystick,
    # Uint8 SDL_JoystickGetButton(joystick: Joystick,
    # SDL_JoystickGUID SDL_JoystickGetDeviceGUID(device_index: cint)
    # SDL_JoystickID SDL_JoystickGetDeviceInstanceID(device_index: cint)
    # int SDL_JoystickGetDevicePlayerIndex(device_index: cint)
    # Uint16 SDL_JoystickGetDeviceProductVersion(device_index: cint)
    # SDL_JoystickType SDL_JoystickGetDeviceType(device_index: cint)
    # Uint16 SDL_JoystickGetFirmwareVersion(joystick: Joystick)
    # SDL_JoystickGUID SDL_JoystickGetGUIDFromString(const char *pchGUID)
    # Uint8 SDL_JoystickGetHat(joystick: Joystick,
    # int SDL_JoystickGetPlayerIndex(joystick: Joystick)
    # Uint16 SDL_JoystickGetProductVersion(joystick: Joystick)
    # SDL_JoystickID SDL_JoystickInstanceID(joystick: Joystick)
    # SDL_bool SDL_JoystickIsVirtual(device_index: cint)
    # const char *SDL_JoystickNameForIndex(device_index: cint)
    # const char *SDL_JoystickPathForIndex(device_index: cint)
    # int SDL_JoystickRumble(joystick: Joystick, Uint16 low_frequency_rumble,
    #     Uint16 high_frequency_rumble, Uint32 duration_ms)
    # int SDL_JoystickRumbleTriggers(joystick: Joystick, Uint16 left_rumble,
    #     Uint16 right_rumble, Uint32 duration_ms)
    # int SDL_JoystickSendEffect(joystick: Joystick, const void *data, int size)
    # int SDL_JoystickSetLED(joystick: Joystick, Uint8 red, Uint8 green, Uint8 blue)
    # void SDL_JoystickSetPlayerIndex(joystick: Joystick, int player_index)
    # int SDL_JoystickSetVirtualAxis(joystick: Joystick, int axis, Sint16 value)
    # int SDL_JoystickSetVirtualButton(joystick: Joystick, int button, Uint8 value)
    # int SDL_JoystickSetVirtualHat(joystick: Joystick, int hat, Uint8 value)
    # void SDL_LockJoysticks(void) SDL_ACQUIRE(SDL_joystick_lock)
    # void SDL_UnlockJoysticks(void) SDL_RELEASE(SDL_joystick_lock)

  # ------------------------------------------------------------------------- #
  # <SDL2/SDL_keyboard.h>                                                     #
  # ------------------------------------------------------------------------- #

  when use_keyboard:

    # void SDL_ClearComposition(void)
    # SDL_Keycode SDL_GetKeyFromName(const char *name)
    # SDL_Keycode SDL_GetKeyFromScancode(SDL_Scancode scancode)

    proc SDL_GetKeyName(key: Keycode): cstring

    proc SDL_GetKeyboardFocus(): Window

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

  # ------------------------------------------------------------------------- #
  # <SDL2/SDL_log.h>                                                          #
  # ------------------------------------------------------------------------- #

  # Note:
  # SDL_Log, SDL_LogCritical, SDL_LogDebug, SDL_LogError, SDL_LogInfo,
  # SDL_LogVerbose and SDL_LogWarn are emulated by calling SDL_LogMessage.

  # void SDL_LogGetOutputFunction(SDL_LogOutputFunction *callback,
  #     void **userdata)
  # SDL_LogPriority SDL_LogGetPriority(int category)

  proc SDL_LogMessage(category: LogCategory, priority: LogPriority,
                      fmt: cstring) {.varargs.}

  # void SDL_LogMessageV(int category, SDL_LogPriority priority,
  #                      const char *fmt, va_list ap)
  # void SDL_LogResetPriorities(void)

  proc SDL_LogSetAllPriority(priority: LogPriority)

  proc SDL_LogSetOutputFunction(callback: LogOutputFunction, userdata: pointer)

  proc SDL_LogSetPriority(category: LogCategory, priority: LogPriority)

  # ------------------------------------------------------------------------- #
  # <SDL2/SDL_main.h>                                                         #
  # ------------------------------------------------------------------------- #

  # int SDL_GDKRunApp(SDL_main_func mainFunction, void *reserved)
  # void SDL_GDKSuspendComplete(void)
  # int SDL_RegisterApp(const char *name, Uint32 style, void *hInst)
  # void SDL_SetMainReady(void)
  # int SDL_UIKitRunApp(int argc, char *argv[], SDL_main_func mainFunction)
  # void SDL_UnregisterApp(void)
  # int SDL_WinRTRunApp(SDL_main_func mainFunction, void *reserved)

  # ------------------------------------------------------------------------- #
  # <SDL2/SDL_messagebox.h>                                                   #
  # ------------------------------------------------------------------------- #

  when use_messagebox:

    proc SDL_ShowMessageBox(messageboxdata: ptr MessageBoxData,
                            buttonid: ptr cint): cint

    proc SDL_ShowSimpleMessageBox(flags: uint32, title: cstring,
                                  message: cstring, window: Window): cint

  # ------------------------------------------------------------------------- #
  # <SDL2/SDL_mouse.h>                                                        #
  # ------------------------------------------------------------------------- #

  when use_mouse:

    # Since SDL 2.0.4.
    proc SDL_CaptureMouse(enabled: SdlBool): cint {.unchecked.}

    proc SDL_CreateColorCursor(surface: SurfacePtr,
                               hot_x, hot_y: cint): CursorPtr

    proc SDL_CreateCursor(data: ptr byte, mask: ptr byte, w, h: cint,
                          hot_x, hot_y: cint): CursorPtr

    proc SDL_CreateSystemCursor(id: SystemCursor)

    proc SDL_FreeCursor(cursor: CursorPtr)

    proc SDL_GetCursor(): CursorPtr

    # SDL_Cursor *SDL_GetDefaultCursor(void)

    # Since SDL 2.0.4.
    proc SDL_GetGlobalMouseState(x, y: ptr cint): uint32 {.unchecked.}

    proc SDL_GetMouseFocus(): Window

    proc SDL_GetMouseState(x, y: ptr cint): uint32

    proc SDL_GetRelativeMouseMode(): SdlBool

    proc SDL_GetRelativeMouseState(x, y: ptr cint): uint32

    proc SDL_SetCursor(cursor: CursorPtr)

    proc SDL_SetRelativeMouseMode(enabled: SdlBool): cint

    proc SDL_ShowCursor(toggle: EventState): cint

    # int SDL_WarpMouseGlobal(int x, int y)
    # void SDL_WarpMouseInWindow(SDL_Window *window, int x, int y)

  # ------------------------------------------------------------------------- #
  # <SDL2/SDL_pixels.h>                                                       #
  # ------------------------------------------------------------------------- #

  proc SDL_AllocFormat(pixel_format: PixelFormatEnum): ptr PixelFormat

  proc SDL_AllocPalette(ncolors: cint): ptr Palette

  proc SDL_CalculateGammaRamp(
    gamma       : cfloat,
    ramp        : ptr uint16
  )

  proc SDL_FreeFormat(format: ptr PixelFormat)

  proc SDL_FreePalette(palette: ptr Palette)

  proc SDL_GetPixelFormatName(format: PixelFormatEnum): cstring

  proc SDL_GetRGB(
    pixel       : uint32,
    format      : ptr PixelFormat,
    r           : ptr byte,
    g           : ptr byte,
    b           : ptr byte
  )

  proc SDL_GetRGBA(
    pixel       : uint32,
    format      : ptr PixelFormat,
    r           : ptr byte,
    g           : ptr byte,
    b           : ptr byte,
    a           : ptr byte
  )

  proc SDL_MapRGB(
    format      : ptr PixelFormat,
    r           : byte,
    g           : byte,
    b           : byte
  ): uint32

  proc SDL_MapRGBA(
    format      : ptr PixelFormat,
    r           : byte,
    g           : byte,
    b           : byte,
    a           : byte
  ): uint32

  proc SDL_MasksToPixelFormatEnum(
    bpp         : cint,
    rmask       : uint32,
    gmask       : uint32,
    bmask       : uint32,
    amask       : uint32
  ): PixelFormatEnum

  proc SDL_PixelFormatEnumToMasks(
    format      : PixelFormatEnum,
    bpp         : ptr cint,
    rmask       : ptr uint32,
    gmask       : ptr uint32,
    bmask       : ptr uint32,
    amask       : ptr uint32
  ): SdlBool

  proc SDL_SetPaletteColors(
    palette     : ptr Palette,
    colors      : ptr Color,
    firstcolor  : cint,
    ncolors     : cint
  ): cint

  proc SDL_SetPixelFormatPalette(
    format      : ptr PixelFormat,
    palette     : ptr Palette
  ): cint

  # ------------------------------------------------------------------------- #
  # <SDL2/SDL_power.h>                                                        #
  # ------------------------------------------------------------------------- #

  # SDL_PowerState SDL_GetPowerInfo(int *seconds, int *percent)

  # ------------------------------------------------------------------------- #
  # <SDL2/SDL_rect.h>                                                         #
  # ------------------------------------------------------------------------- #

  # SDL_bool SDL_EncloseFPoints(const SDL_FPoint *points, int count,
  #     const SDL_FRect *clip, SDL_FRect *result)
  # SDL_bool SDL_EnclosePoints(const SDL_Point *points, int count,
  #     const SDL_Rect *clip, SDL_Rect *result)
  # SDL_bool SDL_HasIntersection(const SDL_Rect *A, const SDL_Rect *B)
  # SDL_bool SDL_HasIntersectionF(const SDL_FRect *A, const SDL_FRect *B)
  # SDL_bool SDL_IntersectFRect(const SDL_FRect *A, const SDL_FRect *B,
  #     SDL_FRect *result)
  # SDL_bool SDL_IntersectFRectAndLine(const SDL_FRect *rect,
  #     float *X1, float *Y1, float *X2, float *Y2)
  # SDL_bool SDL_IntersectRect(const SDL_Rect *A, const SDL_Rect *B,
  #     SDL_Rect *result)
  # SDL_bool SDL_IntersectRectAndLine(const SDL_Rect *rect,
  #     int *X1, int *Y1, int *X2, int *Y2)
  # void SDL_UnionFRect(const SDL_FRect *A, const SDL_FRect *B,
  #     SDL_FRect *result)
  # void SDL_UnionRect(const SDL_Rect *A, const SDL_Rect *B,
  #     SDL_Rect *result)

  # ------------------------------------------------------------------------- #
  # <SDL2/SDL_render.h>                                                       #
  # ------------------------------------------------------------------------- #

  # XXX: TODO: uint32 -> distinct type?
  proc SDL_CreateRenderer(window: Window, index: cint,
                          flags: uint32): Renderer

  proc SDL_CreateSoftwareRenderer(surface: SurfacePtr): Renderer

  proc SDL_CreateTexture(renderer: Renderer, format: uint32, access: cint,
                         w, h: cint): Texture

  proc SDL_CreateTextureFromSurface(renderer: Renderer,
                                    surface: SurfacePtr): Texture

  proc SDL_CreateWindowAndRenderer(width, height: cint,
                                   window_flags: WindowFlags,
                                   window: ptr Window,
                                   renderer: ptr Renderer): cint

  proc SDL_DestroyRenderer(renderer: Renderer)

  proc SDL_DestroyTexture(texture: Texture)

  # int SDL_GL_BindTexture(SDL_Texture *texture, float *texw, float *texh)
  # int SDL_GL_UnbindTexture(SDL_Texture *texture)

  proc SDL_GetNumRenderDrivers(): cint

  # int SDL_GetRenderDrawBlendMode(SDL_Renderer *renderer,
  #     SDL_BlendMode *blendMode)

  proc SDL_GetRenderDrawColor(renderer: Renderer,
                              r, g, b, a: ptr byte): cint

  proc SDL_GetRenderDriverInfo(index: cint, info: ptr RendererInfo): cint

  proc SDL_GetRenderTarget(renderer: Renderer): Texture

  proc SDL_GetRenderer(window: Window): Renderer

  proc SDL_GetRendererInfo(renderer: Renderer, info: ptr RendererInfo): cint

  proc SDL_GetRendererOutputSize(renderer: Renderer, w, h: ptr cint): cint

  # int SDL_GetTextureAlphaMod(SDL_Texture *texture, Uint8 *alpha)
  # int SDL_GetTextureBlendMode(SDL_Texture *texture,
  #     SDL_BlendMode *blendMode)
  # int SDL_GetTextureColorMod(SDL_Texture *texture,
  #     Uint8 *r, Uint8 *g, Uint8 *b)
  # int SDL_GetTextureScaleMode(SDL_Texture *texture,
  #     SDL_ScaleMode *scaleMode)
  # void *SDL_GetTextureUserData(SDL_Texture *texture)
  # int SDL_LockTexture(SDL_Texture *texture, const SDL_Rect *rect,
  #     void **pixels, int *pitch)
  # int SDL_LockTextureToSurface(SDL_Texture *texture, const SDL_Rect *rect,
  #     SDL_Surface **surface)

  proc SDL_QueryTexture(texture: Texture, format: ptr uint32,
                        access: ptr cint, w, h: ptr cint): cint

  proc SDL_RenderClear(renderer: Renderer): cint

  proc SDL_RenderCopy(renderer: Renderer, texture: Texture,
                      src, dst: ptr Rect): cint

  proc SDL_RenderCopyEx(renderer: Renderer, texture: Texture,
                        srcrect, dstrect: ptr Rect, angle: cdouble,
                        center: ptr Point, flip: RendererFlip): cint

  # int SDL_RenderCopyExF(SDL_Renderer *renderer, SDL_Texture *texture,
  #     const SDL_Rect *srcrect, const SDL_FRect *dstrect,
  #     const double angle, const SDL_FPoint *center,
  #     const SDL_RendererFlip flip)
  # int SDL_RenderCopyF(SDL_Renderer *renderer, SDL_Texture *texture,
  #     const SDL_Rect *srcrect, const SDL_FRect *dstrect)

  proc SDL_RenderDrawLine(renderer: Renderer, x1, y1: cint,
                          x2, y2: cint): cint

  # int SDL_RenderDrawLineF(SDL_Renderer *renderer, float x1, float y1,
  #     float x2, float y2)
  # int SDL_RenderDrawLines(SDL_Renderer *renderer,
  #     const SDL_Point *points, int count)
  # int SDL_RenderDrawLinesF(SDL_Renderer *renderer,
  #     const SDL_FPoint *points, int count)

  proc SDL_RenderDrawPoint(renderer: Renderer, x, y: cint): cint

  # Since SDL 2.0.10.
  proc SDL_RenderDrawPointF(renderer: Renderer,
                            x, y: cfloat): cint {.unchecked.}

  # int SDL_RenderDrawPoints(SDL_Renderer *renderer,
  #     const SDL_Point *points, int count)
  # int SDL_RenderDrawPointsF(SDL_Renderer *renderer,
  #     const SDL_FPoint *points, int count)

  proc SDL_RenderDrawRect(renderer: Renderer, rect: ptr Rect): cint

  # int SDL_RenderDrawRectF(SDL_Renderer *renderer, const SDL_FRect *rect)
  # int SDL_RenderDrawRects(SDL_Renderer *renderer,
  #     const SDL_Rect *rects, int count)
  # int SDL_RenderDrawRectsF(SDL_Renderer *renderer,
  #     const SDL_FRect *rects, int count)

  proc SDL_RenderFillRect(renderer: Renderer, rect: ptr Rect): cint

  # int SDL_RenderFillRectF(SDL_Renderer *renderer, const SDL_FRect *rect)
  # int SDL_RenderFillRects(SDL_Renderer *renderer, const SDL_Rect *rects,
  #     int count)
  # int SDL_RenderFillRectsF(SDL_Renderer *renderer, const SDL_FRect *rects,
  #     int count)
  # int SDL_RenderFlush(SDL_Renderer *renderer)

  # Since SDL 2.0.18.
  proc SDL_RenderGeometry(renderer: Renderer, texture: Texture,
                          vertices: ptr Vertex, num_vertices: cint,
                          indices: ptr cint,
                          num_indices: cint): cint {.unchecked.}

  # int SDL_RenderGeometryRaw(SDL_Renderer *renderer, SDL_Texture *texture,
  #     const float *xy, int xy_stride, const SDL_Color *color,
  #     int color_stride, const float *uv, int uv_stride, int num_vertices,
  #     const void *indices, int num_indices, int size_indices)

  proc SDL_RenderGetClipRect(renderer: Renderer, rect: ptr Rect)

  # SDL_bool SDL_RenderGetIntegerScale(SDL_Renderer *renderer)

  proc SDL_RenderGetLogicalSize(renderer: Renderer, w, h: ptr cint)

  # void *SDL_RenderGetMetalCommandEncoder(SDL_Renderer *renderer)
  # void *SDL_RenderGetMetalLayer(SDL_Renderer *renderer)

  proc SDL_RenderGetScale(renderer: Renderer, scale_x, scale_y: ptr cfloat)

  proc SDL_RenderGetViewport(renderer: Renderer, rect: ptr Rect)

  # Since SDL 2.0.22.
  proc SDL_RenderGetWindow(renderer: Renderer): Window {.unchecked.}

  # SDL_bool SDL_RenderIsClipEnabled(SDL_Renderer *renderer)
  # void SDL_RenderLogicalToWindow(SDL_Renderer *renderer,
  #     float logicalX, float logicalY, int *windowX, int *windowY)

  proc SDL_RenderPresent(renderer: Renderer)

  proc SDL_RenderReadPixels(renderer: Renderer, rect: ptr Rect,
                            format: PixelFormatEnum, pixels: pointer,
                            pitch: cint): cint

  proc SDL_RenderSetClipRect(renderer: Renderer, rect: ptr Rect): cint

  # int SDL_RenderSetIntegerScale(SDL_Renderer *renderer, SDL_bool enable)

  proc SDL_RenderSetLogicalSize(renderer: Renderer, w, h: cint): cint

  proc SDL_RenderSetScale(renderer: Renderer,
                          scale_x, scale_y: cfloat): cint

  # Since SDL 2.0.18.
  proc SDL_RenderSetVSync(renderer: Renderer,
                          vsync: cint): cint {.unchecked.}

  proc SDL_RenderSetViewport(renderer: Renderer, rect: ptr Rect): cint

  proc SDL_RenderTargetSupported(renderer: Renderer): SdlBool

  # Since SDL 2.0.18.
  proc SDL_RenderWindowToLogical(renderer: Renderer,
                                 window_x, window_y: cint,
                                 logical_x, logical_y: ptr cfloat) {.unchecked.}

  when use_blendmode:
    proc SDL_SetRenderDrawBlendMode(renderer: Renderer,
                                    blend_mode: BlendMode): cint

  proc SDL_SetRenderDrawColor(renderer: Renderer, r, g, b, a: byte): cint

  proc SDL_SetRenderTarget(renderer: Renderer, texture: Texture): cint

  proc SDL_SetTextureAlphaMod(texture: Texture, a: byte): cint

  when use_blendmode:
    proc SDL_SetTextureBlendMode(texture: Texture,
                                 blend_mode: BlendMode): cint

  proc SDL_SetTextureColorMod(texture: Texture, r, g, b: byte): cint

  # Since SDL 2.0.12.
  # int SDL_SetTextureScaleMode(SDL_Texture *texture,
  #     SDL_ScaleMode scaleMode)
  # Since SDL 2.0.18.
  # int SDL_SetTextureUserData(SDL_Texture *texture, void *userdata)
  # void SDL_UnlockTexture(SDL_Texture *texture)
  # int SDL_UpdateNVTexture(SDL_Texture *texture, const SDL_Rect *rect,
  #     const Uint8 *Yplane, int Ypitch, const Uint8 *UVplane, int UVpitch)

  proc SDL_UpdateTexture(texture: Texture, rect: ptr Rect, pixels: pointer,
                         pitch: cint): cint

  # int SDL_UpdateYUVTexture(SDL_Texture *texture, const SDL_Rect *rect,
  #     const Uint8 *Yplane, int Ypitch, const Uint8 *Uplane, int Upitch,
  #     const Uint8 *Vplane, int Vpitch)

  # ------------------------------------------------------------------------- #
  # <SDL2/SDL_rwops.h>                                                        #
  # ------------------------------------------------------------------------- #

  # XXX: TODO.

  proc SDL_RWFromFile(file: cstring, mode: cstring): RWops

  # ------------------------------------------------------------------------- #
  # <SDL2/SDL_sensor.h>                                                       #
  # ------------------------------------------------------------------------- #

  # void SDL_LockSensors(void)
  # int SDL_NumSensors(void)
  # void SDL_SensorClose(SDL_Sensor *sensor)
  # SDL_Sensor *SDL_SensorFromInstanceID(SDL_SensorID instance_id)
  # int SDL_SensorGetData(SDL_Sensor *sensor, float *data, int num_values)
  # int SDL_SensorGetDataWithTimestamp(SDL_Sensor *sensor, Uint64 *timestamp,
  #     float *data, int num_values)
  # SDL_SensorID SDL_SensorGetDeviceInstanceID(device_index: cint)
  # const char *SDL_SensorGetDeviceName(device_index: cint)
  # int SDL_SensorGetDeviceNonPortableType(device_index: cint)
  # SDL_SensorType SDL_SensorGetDeviceType(device_index: cint)
  # SDL_SensorID SDL_SensorGetInstanceID(SDL_Sensor *sensor)
  # const char *SDL_SensorGetName(SDL_Sensor *sensor)
  # int SDL_SensorGetNonPortableType(SDL_Sensor *sensor)
  # SDL_SensorType SDL_SensorGetType(SDL_Sensor *sensor)
  # SDL_Sensor *SDL_SensorOpen(device_index: cint)
  # void SDL_SensorUpdate(void)
  # void SDL_UnlockSensors(void)

  # ------------------------------------------------------------------------- #
  # <SDL2/SDL_shape.h>                                                        #
  # ------------------------------------------------------------------------- #

  # SDL_Window *SDL_CreateShapedWindow(const char *title, unsigned int x,
  #     unsigned int y, unsigned int w, unsigned int h, Uint32 flags)
  # int SDL_GetShapedWindowMode(SDL_Window *window,
  #     SDL_WindowShapeMode *shape_mode)
  # SDL_bool SDL_IsShapedWindow(const SDL_Window *window)
  # int SDL_SetWindowShape(SDL_Window *window, SDL_Surface *shape,
  #     SDL_WindowShapeMode *shape_mode)

  # ------------------------------------------------------------------------- #
  # <SDL2/SDL_surface.h>                                                      #
  # ------------------------------------------------------------------------- #

  # int SDL_ConvertPixels(int width, int height, Uint32 src_format,
  #     const void *src, int src_pitch, Uint32 dst_format,
  #     void *dst, int dst_pitch)

  proc SDL_ConvertSurface(src: SurfacePtr, fmt: ptr PixelFormat,
                          flags: uint32): SurfacePtr

  proc SDL_ConvertSurfaceFormat(src: SurfacePtr, pixel_format: PixelFormatEnum,
                                flags: uint32): SurfacePtr

  proc SDL_CreateRGBSurface(flags: SurfaceFlags, width, height: cint,
                            depth: cint, rmask, gmask, bmask: uint32,
                            amask: uint32): SurfacePtr

  proc SDL_CreateRGBSurfaceFrom(pixels: pointer, width, height: cint,
                                depth: cint, pitch: cint,
                                rmask, gmask, bmask: uint32,
                                amask: uint32): SurfacePtr

  # Since SDL 2.0.5.
  proc SDL_CreateRGBSurfaceWithFormat(flags: uint32, width, height: cint,
                                      depth: cint,
                                      format: PixelFormatEnum): SurfacePtr

  # SDL_Surface *SDL_CreateRGBSurfaceWithFormatFrom(void *pixels, int width,
  #     int height, int depth, int pitch, Uint32 format)
  # SDL_Surface *SDL_DuplicateSurface(SDL_Surface *surface)

  proc SDL_FillRect(dst: SurfacePtr, rect: ptr Rect, color: uint32): cint

  # int SDL_FillRects (SDL_Surface *dst, const SDL_Rect *rects, int count,
  #     Uint32 color)

  proc SDL_FreeSurface(surface: SurfacePtr)

  # void SDL_GetClipRect(SDL_Surface *surface, SDL_Rect *rect)
  # int SDL_GetColorKey(SDL_Surface *surface, Uint32 *key)
  # int SDL_GetSurfaceAlphaMod(SDL_Surface *surface, Uint8 *alpha)
  # int SDL_GetSurfaceBlendMode(SDL_Surface *surface,
  #     SDL_BlendMode *blendMode)
  # int SDL_GetSurfaceColorMod(SDL_Surface *surface,
  #     Uint8 *r, Uint8 *g, Uint8 *b)
  # SDL_YUV_CONVERSION_MODE SDL_GetYUVConversionMode(void)
  # SDL_YUV_CONVERSION_MODE SDL_GetYUVConversionModeForResolution(int width,
  #     int height)
  # SDL_bool SDL_HasColorKey(SDL_Surface *surface)
  # SDL_bool SDL_HasSurfaceRLE(SDL_Surface *surface)

  proc SDL_LoadBMP_RW(src: RWops, freesrc: cint): SurfacePtr

  proc SDL_LockSurface(surface: SurfacePtr): cint

  # int SDL_LowerBlit (SDL_Surface *src, SDL_Rect *srcrect,
  #     SDL_Surface *dst, SDL_Rect *dstrect)
  # int SDL_LowerBlitScaled (SDL_Surface *src, SDL_Rect *srcrect,
  #     SDL_Surface *dst, SDL_Rect *dstrect)

  # Since SDL 2.0.18.
  proc SDL_PremultiplyAlpha(width: cint, height: cint,
                            src_format: PixelFormatEnum, src: pointer,
                            src_pitch: cint, dst_format: PixelFormatEnum,
                            dst: pointer, dst_pitch: cint): cint {.unchecked.}

  proc SDL_SaveBMP_RW(surface: SurfacePtr, dst: RWops, freedst: cint): cint

  # SDL_bool SDL_SetClipRect(SDL_Surface *surface, const SDL_Rect *rect)

  proc SDL_SetColorKey(surface: SurfacePtr, flag: cint, key: uint32): cint

  # int SDL_SetSurfaceAlphaMod(SDL_Surface *surface, Uint8 alpha)
  # int SDL_SetSurfaceBlendMode(SDL_Surface *surface,
  #     SDL_BlendMode blendMode)
  # int SDL_SetSurfaceColorMod(SDL_Surface *surface,
  #     Uint8 r, Uint8 g, Uint8 b)
  # int SDL_SetSurfacePalette(SDL_Surface *surface, SDL_Palette *palette)
  # int SDL_SetSurfaceRLE(SDL_Surface *surface, int flag)
  # void SDL_SetYUVConversionMode(SDL_YUV_CONVERSION_MODE mode)
  # int SDL_SoftStretch(SDL_Surface *src, const SDL_Rect *srcrect,
  #     SDL_Surface *dst, const SDL_Rect *dstrect)
  # int SDL_SoftStretchLinear(SDL_Surface *src, const SDL_Rect *srcrect,
  #     SDL_Surface *dst, const SDL_Rect *dstrect)

  proc SDL_UnlockSurface(surface: SurfacePtr)

  # int SDL_UpperBlit (SDL_Surface *src, const SDL_Rect *srcrect,
  #     SDL_Surface *dst, SDL_Rect *dstrect)
  # int SDL_UpperBlitScaled (SDL_Surface *src, const SDL_Rect *srcrect,
  #     SDL_Surface *dst, SDL_Rect *dstrect)

  # ------------------------------------------------------------------------- #
  # <SDL2/SDL_system.h>                                                       #
  # ------------------------------------------------------------------------- #

  # XXX: TODO.

  # ------------------------------------------------------------------------- #
  # <SDL2/SDL_syswm.h>                                                        #
  # ------------------------------------------------------------------------- #

  # SDL_bool SDL_GetWindowWMInfo(SDL_Window *window, SDL_SysWMinfo *info)

  # ------------------------------------------------------------------------- #
  # <SDL2/SDL_timer.h>                                                        #
  # ------------------------------------------------------------------------- #

  # SDL_TimerID
  proc SDL_AddTimer(interval: uint32, callback: TimerCallback,
                    param: pointer): TimerID

  proc SDL_Delay(ms: uint32)

  proc SDL_GetPerformanceCounter(): uint64

  proc SDL_GetPerformanceFrequency(): uint64

  proc SDL_GetTicks(): uint32

  proc SDL_GetTicks64(): uint64
  
  proc SDL_RemoveTimer(id: TimerID): SdlBool

  # ------------------------------------------------------------------------- #
  # <SDL2/SDL_touch.h>                                                        #
  # ------------------------------------------------------------------------- #

  when use_touch:
    proc SDL_GetNumTouchDevices(): cint
    proc SDL_GetNumTouchFingers(touch_id: TouchID): cint
    proc SDL_GetTouchDevice(index: cint): TouchID
    proc SDL_GetTouchDeviceType(touch_id: TouchID): TouchDeviceType {.unchecked.}   # Since SDL 2.0.10.
    proc SDL_GetTouchFinger(touch_id: TouchID, index: cint): ptr Finger
    proc SDL_GetTouchName(index: cint): cstring {.unchecked.}   # Since SDL 2.0.22.

  # ------------------------------------------------------------------------- #
  # <SDL2/SDL_version.h>                                                      #
  # ------------------------------------------------------------------------- #

  proc SDL_GetRevision(): cstring

  proc SDL_GetVersion(ver: ptr Version)

  # ------------------------------------------------------------------------- #
  # <SDL2/SDL_video.h>                                                        #
  # ------------------------------------------------------------------------- #

  proc SDL_CreateWindow(title: cstring, x, y: cint, w, h: cint,
                        windowFlags: uint32): Window

  # SDL_Window *SDL_CreateWindowFrom(const void *data)

  proc SDL_DestroyWindow(window: Window)

  # SDL 2.28.0.
  # int SDL_DestroyWindowSurface(SDL_Window *window)

  proc SDL_DisableScreenSaver()

  proc SDL_EnableScreenSaver()

  # Since SDL 2.0.16.
  proc SDL_FlashWindow(window: Window,
                       operation: FlashOperation): cint {.unchecked.}

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
  # SDL_DisplayMode *SDL_GetClosestDisplayMode(int displayIndex,
  #     const SDL_DisplayMode *mode, SDL_DisplayMode *closest)

  proc SDL_GetCurrentDisplayMode(display_index: cint,
                                 mode: ptr DisplayMode): cint

  proc SDL_GetCurrentVideoDriver(): cstring

  proc SDL_GetDesktopDisplayMode(display_index: cint,
                                 mode: ptr DisplayMode): cint

  proc SDL_GetDisplayBounds(display_index: cint, rect: ptr Rect): cint

  # Since SDL 2.0.4.
  proc SDL_GetDisplayDPI(display_index: cint, ddpi: ptr cfloat,
                         hdpi, vdpi: ptr cfloat): cint {.unchecked.}

  proc SDL_GetDisplayMode(display_index: cint, mode_index: cint,
                          mode: ptr DisplayMode): cint

  proc SDL_GetDisplayName(display_index: cint): cstring

  # Since SDL 2.0.9.
  proc SDL_GetDisplayOrientation(display_index: cint): DisplayOrientation {.unchecked.}

  # Since SDL 2.0.5.
  proc SDL_GetDisplayUsableBounds(display_index: cint,
                                  rect: ptr Rect): cint {.unchecked.}

  # Since SDL 2.0.4.
  proc SDL_GetGrabbedWindow(): Window {.unchecked.}

  proc SDL_GetNumDisplayModes(display_index: cint): cint

  proc SDL_GetNumVideoDisplays(): cint

  proc SDL_GetNumVideoDrivers(): cint

  # int SDL_GetPointDisplayIndex(const SDL_Point *point)
  # int SDL_GetRectDisplayIndex(const SDL_Rect *rect)

  proc SDL_GetVideoDriver(index: cint): cstring

  # Since SDL 2.0.5.
  proc SDL_GetWindowBordersSize(window: Window, top, left: ptr cint,
                                bottom, right: ptr cint): cint {.unchecked.}

  # float SDL_GetWindowBrightness(SDL_Window *window)
  # void *SDL_GetWindowData(SDL_Window *window, const char *name)

  proc SDL_GetWindowDisplayIndex(window: Window): cint

  proc SDL_GetWindowDisplayMode(window: Window, mode: ptr DisplayMode): cint

  proc SDL_GetWindowFlags(window: Window): WindowFlags

  proc SDL_GetWindowFromID(id: uint32): Window

  # int SDL_GetWindowGammaRamp(SDL_Window *window,
  #     Uint16 *red, Uint16 *green, Uint16 *blue)

  proc SDL_GetWindowGrab(window: Window): SdlBool

  # void* SDL_GetWindowICCProfile(SDL_Window *window, size_t* size)

  proc SDL_GetWindowID(window: Window): uint32

  # Since SDL 2.0.16.
  proc SDL_GetWindowKeyboardGrab(window: Window): SdlBool {.unchecked.}

  proc SDL_GetWindowMaximumSize(window: Window, w, h: ptr cint)

  proc SDL_GetWindowMinimumSize(window: Window, w, h: ptr cint)

  # Since SDL 2.0.16.
  proc SDL_GetWindowMouseGrab(window: Window): SdlBool

  # Since SDL 2.0.18.
  proc SDL_GetWindowMouseRect(window: Window): ptr Rect

  # Since SDL 2.0.5.
  proc SDL_GetWindowOpacity(window: Window,
                            opacity: ptr cfloat): cint {.unchecked.}

  proc SDL_GetWindowPixelFormat(window: Window): PixelFormatEnum

  proc SDL_GetWindowPosition(window: Window, x, y: ptr cint)

  proc SDL_GetWindowSize(window: Window, width, height: ptr cint)

  # Since SDL 2.26.0.
  proc SDL_GetWindowSizeInPixels(window: Window,
                                 w, h: ptr cint) {.unchecked.}

  proc SDL_GetWindowSurface(window: Window): SurfacePtr

  proc SDL_GetWindowTitle(window: Window): cstring

  # Since SDL 2.28.0.
  proc SDL_HasWindowSurface(window: Window): SdlBool {.unchecked.}

  proc SDL_HideWindow(window: Window)

  # SDL_bool SDL_IsScreenSaverEnabled(void)

  proc SDL_MaximizeWindow(window: Window)

  proc SDL_MinimizeWindow(window: Window)

  proc SDL_RaiseWindow(window: Window)

  proc SDL_RestoreWindow(window: Window)

  # Since SDL 2.0.16.
  proc SDL_SetWindowAlwaysOnTop(window: Window,
                                on_top: SdlBool) {.unchecked.}

  proc SDL_SetWindowBordered(window: Window, bordered: SdlBool)

  # int SDL_SetWindowBrightness(SDL_Window *window, float brightness)
  # void* SDL_SetWindowData(SDL_Window *window, const char *name,
  #     void *userdata)

  proc SDL_SetWindowDisplayMode(window: Window, mode: ptr DisplayMode): cint

  proc SDL_SetWindowFullscreen(window: Window, flags: uint32): cint

  # int SDL_SetWindowGammaRamp(SDL_Window *window, const Uint16 *red,
  #     const Uint16 *green, const Uint16 *blue)

  proc SDL_SetWindowGrab(window: Window, grabbed: SdlBool)

  # Since SDL 2.0.4.
  proc SDL_SetWindowHitTest(window: Window, callback: HitTest,
                            callback_data: pointer): cint {.unchecked.}

  proc SDL_SetWindowIcon(window: Window, surface: SurfacePtr)

  # int SDL_SetWindowInputFocus(SDL_Window *window)

  # Since SDL 2.0.16.
  proc SDL_SetWindowKeyboardGrab(window: Window,
                                 grabbed: SdlBool) {.unchecked.}

  proc SDL_SetWindowMaximumSize(window: Window, max_w, max_h: cint)

  proc SDL_SetWindowMinimumSize(window: Window, min_w, min_h: cint)

  # Since SDL 2.0.5.
  proc SDL_SetWindowModalFor(modal_window: Window,
                             parent_window: Window): cint {.unchecked.}

  # Since SDL 2.0.16.
  proc SDL_SetWindowMouseGrab(window: Window,
                              grabbed: SdlBool) {.unchecked.}

  # Since SDL 2.0.18.
  proc SDL_SetWindowMouseRect(window: Window,
                              rect: ptr Rect): cint {.unchecked.}

  # Since SDL 2.0.5.
  proc SDL_SetWindowOpacity(window: Window,
                            opacity: cfloat): cint {.unchecked.}

  proc SDL_SetWindowPosition(window: Window, x, y: cint)

  proc SDL_SetWindowResizable(window: Window, ontop: SdlBool)

  proc SDL_SetWindowSize(window: Window, x, y: cint)

  proc SDL_SetWindowTitle(window: Window, title: cstring)

  proc SDL_ShowWindow(window: Window)

  proc SDL_UpdateWindowSurface(window: Window): cint

  # int SDL_UpdateWindowSurfaceRects(SDL_Window *window,
  #     const SDL_Rect *rects, int numrects)

  proc SDL_VideoInit(driver_name: cstring): cint

  proc SDL_VideoQuit()

  # ------------------------------------------------------------------------- #
  # <SDL2/SDL_vulkan.h>                                                       #
  # ------------------------------------------------------------------------- #

  # SDL_bool SDL_Vulkan_CreateSurface(SDL_Window *window,
  #     VkInstance instance, VkSurfaceKHR* surface)
  # void SDL_Vulkan_GetDrawableSize(SDL_Window *window, int *w, int *h)
  # SDL_bool SDL_Vulkan_GetInstanceExtensions(SDL_Window *window,
  #     unsigned int *pCount, const char **pNames)
  # void *SDL_Vulkan_GetVkGetInstanceProcAddr(void)
  # int SDL_Vulkan_LoadLibrary(const char *path)
  # void SDL_Vulkan_UnloadLibrary(void)

# vim: set sts=2 et sw=2:
