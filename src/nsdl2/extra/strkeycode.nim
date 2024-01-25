##  Keyboard keys and modifiers definitions.

{.push raises: [], tags: [].}

import ../sdl2inc/keycode

proc `$`*(keycode: Keycode): string =
  case keycode
  of SDLK_UNKNOWN             : "SDLK_UNKNOWN"

  of SDLK_BACKSPACE           : "SDLK_BACKSPACE"
  of SDLK_TAB                 : "SDLK_TAB"
  of SDLK_RETURN              : "SDLK_RETURN"
  of SDLK_ESCAPE              : "SDLK_ESCAPE"
  of SDLK_SPACE               : "SDLK_SPACE"
  of SDLK_EXCLAIM             : "SDLK_EXCLAIM"
  of SDLK_QUOTEDBL            : "SDLK_QUOTEDBL"
  of SDLK_HASH                : "SDLK_HASH"
  of SDLK_DOLLAR              : "SDLK_DOLLAR"
  of SDLK_PERCENT             : "SDLK_PERCENT"
  of SDLK_AMPERSAND           : "SDLK_AMPERSAND"
  of SDLK_QUOTE               : "SDLK_QUOTE"
  of SDLK_LEFTPAREN           : "SDLK_LEFTPAREN"
  of SDLK_RIGHTPAREN          : "SDLK_RIGHTPAREN"
  of SDLK_ASTERISK            : "SDLK_ASTERISK"
  of SDLK_PLUS                : "SDLK_PLUS"
  of SDLK_COMMA               : "SDLK_COMMA"
  of SDLK_MINUS               : "SDLK_MINUS"
  of SDLK_PERIOD              : "SDLK_PERIOD"
  of SDLK_SLASH               : "SDLK_SLASH"
  of SDLK_0                   : "SDLK_0"
  of SDLK_1                   : "SDLK_1"
  of SDLK_2                   : "SDLK_2"
  of SDLK_3                   : "SDLK_3"
  of SDLK_4                   : "SDLK_4"
  of SDLK_5                   : "SDLK_5"
  of SDLK_6                   : "SDLK_6"
  of SDLK_7                   : "SDLK_7"
  of SDLK_8                   : "SDLK_8"
  of SDLK_9                   : "SDLK_9"
  of SDLK_COLON               : "SDLK_COLON"
  of SDLK_SEMICOLON           : "SDLK_SEMICOLON"
  of SDLK_LESS                : "SDLK_LESS"
  of SDLK_EQUALS              : "SDLK_EQUALS"
  of SDLK_GREATER             : "SDLK_GREATER"
  of SDLK_QUESTION            : "SDLK_QUESTION"
  of SDLK_AT                  : "SDLK_AT"

  of SDLK_LEFTBRACKET         : "SDLK_LEFTBRACKET"
  of SDLK_BACKSLASH           : "SDLK_BACKSLASH"
  of SDLK_RIGHTBRACKET        : "SDLK_RIGHTBRACKET"
  of SDLK_CARET               : "SDLK_CARET"
  of SDLK_UNDERSCORE          : "SDLK_UNDERSCORE"
  of SDLK_BACKQUOTE           : "SDLK_BACKQUOTE"
  of SDLK_a                   : "SDLK_a"
  of SDLK_b                   : "SDLK_b"
  of SDLK_c                   : "SDLK_c"
  of SDLK_d                   : "SDLK_d"
  of SDLK_e                   : "SDLK_e"
  of SDLK_f                   : "SDLK_f"
  of SDLK_g                   : "SDLK_g"
  of SDLK_h                   : "SDLK_h"
  of SDLK_i                   : "SDLK_i"
  of SDLK_j                   : "SDLK_j"
  of SDLK_k                   : "SDLK_k"
  of SDLK_l                   : "SDLK_l"
  of SDLK_m                   : "SDLK_m"
  of SDLK_n                   : "SDLK_n"
  of SDLK_o                   : "SDLK_o"
  of SDLK_p                   : "SDLK_p"
  of SDLK_q                   : "SDLK_q"
  of SDLK_r                   : "SDLK_r"
  of SDLK_s                   : "SDLK_s"
  of SDLK_t                   : "SDLK_t"
  of SDLK_u                   : "SDLK_u"
  of SDLK_v                   : "SDLK_v"
  of SDLK_w                   : "SDLK_w"
  of SDLK_x                   : "SDLK_x"
  of SDLK_y                   : "SDLK_y"
  of SDLK_z                   : "SDLK_z"

  of SDLK_DELETE              : "SDLK_DELETE"

  of SDLK_CAPSLOCK            : "SDLK_CAPSLOCK"

  of SDLK_F1                  : "SDLK_F1"
  of SDLK_F2                  : "SDLK_F2"
  of SDLK_F3                  : "SDLK_F3"
  of SDLK_F4                  : "SDLK_F4"
  of SDLK_F5                  : "SDLK_F5"
  of SDLK_F6                  : "SDLK_F6"
  of SDLK_F7                  : "SDLK_F7"
  of SDLK_F8                  : "SDLK_F8"
  of SDLK_F9                  : "SDLK_F9"
  of SDLK_F10                 : "SDLK_F10"
  of SDLK_F11                 : "SDLK_F11"
  of SDLK_F12                 : "SDLK_F12"

  of SDLK_PRINTSCREEN         : "SDLK_PRINTSCREEN"
  of SDLK_SCROLLLOCK          : "SDLK_SCROLLLOCK"
  of SDLK_PAUSE               : "SDLK_PAUSE"
  of SDLK_INSERT              : "SDLK_INSERT"
  of SDLK_HOME                : "SDLK_HOME"
  of SDLK_PAGEUP              : "SDLK_PAGEUP"
  of SDLK_END                 : "SDLK_END"
  of SDLK_PAGEDOWN            : "SDLK_PAGEDOWN"
  of SDLK_RIGHT               : "SDLK_RIGHT"
  of SDLK_LEFT                : "SDLK_LEFT"
  of SDLK_DOWN                : "SDLK_DOWN"
  of SDLK_UP                  : "SDLK_UP"

  of SDLK_NUMLOCKCLEAR        : "SDLK_NUMLOCKCLEAR"
  of SDLK_KP_DIVIDE           : "SDLK_KP_DIVIDE"
  of SDLK_KP_MULTIPLY         : "SDLK_KP_MULTIPLY"
  of SDLK_KP_MINUS            : "SDLK_KP_MINUS"
  of SDLK_KP_PLUS             : "SDLK_KP_PLUS"
  of SDLK_KP_ENTER            : "SDLK_KP_ENTER"
  of SDLK_KP_1                : "SDLK_KP_1"
  of SDLK_KP_2                : "SDLK_KP_2"
  of SDLK_KP_3                : "SDLK_KP_3"
  of SDLK_KP_4                : "SDLK_KP_4"
  of SDLK_KP_5                : "SDLK_KP_5"
  of SDLK_KP_6                : "SDLK_KP_6"
  of SDLK_KP_7                : "SDLK_KP_7"
  of SDLK_KP_8                : "SDLK_KP_8"
  of SDLK_KP_9                : "SDLK_KP_9"
  of SDLK_KP_0                : "SDLK_KP_0"
  of SDLK_KP_PERIOD           : "SDLK_KP_PERIOD"

  of SDLK_APPLICATION         : "SDLK_APPLICATION"
  of SDLK_POWER               : "SDLK_POWER"
  of SDLK_KP_EQUALS           : "SDLK_KP_EQUALS"
  of SDLK_F13                 : "SDLK_F13"
  of SDLK_F14                 : "SDLK_F14"
  of SDLK_F15                 : "SDLK_F15"
  of SDLK_F16                 : "SDLK_F16"
  of SDLK_F17                 : "SDLK_F17"
  of SDLK_F18                 : "SDLK_F18"
  of SDLK_F19                 : "SDLK_F19"
  of SDLK_F20                 : "SDLK_F20"
  of SDLK_F21                 : "SDLK_F21"
  of SDLK_F22                 : "SDLK_F22"
  of SDLK_F23                 : "SDLK_F23"
  of SDLK_F24                 : "SDLK_F24"
  of SDLK_EXECUTE             : "SDLK_EXECUTE"
  of SDLK_HELP                : "SDLK_HELP"
  of SDLK_MENU                : "SDLK_MENU"
  of SDLK_SELECT              : "SDLK_SELECT"
  of SDLK_STOP                : "SDLK_STOP"
  of SDLK_AGAIN               : "SDLK_AGAIN"
  of SDLK_UNDO                : "SDLK_UNDO"
  of SDLK_CUT                 : "SDLK_CUT"
  of SDLK_COPY                : "SDLK_COPY"
  of SDLK_PASTE               : "SDLK_PASTE"
  of SDLK_FIND                : "SDLK_FIND"
  of SDLK_MUTE                : "SDLK_MUTE"
  of SDLK_VOLUMEUP            : "SDLK_VOLUMEUP"
  of SDLK_VOLUMEDOWN          : "SDLK_VOLUMEDOWN"
  of SDLK_KP_COMMA            : "SDLK_KP_COMMA"
  of SDLK_KP_EQUALSAS400      : "SDLK_KP_EQUALSAS400"

  of SDLK_ALTERASE            : "SDLK_ALTERASE"
  of SDLK_SYSREQ              : "SDLK_SYSREQ"
  of SDLK_CANCEL              : "SDLK_CANCEL"
  of SDLK_CLEAR               : "SDLK_CLEAR"
  of SDLK_PRIOR               : "SDLK_PRIOR"
  of SDLK_RETURN2             : "SDLK_RETURN2"
  of SDLK_SEPARATOR           : "SDLK_SEPARATOR"
  of SDLK_OUT                 : "SDLK_OUT"
  of SDLK_OPER                : "SDLK_OPER"
  of SDLK_CLEARAGAIN          : "SDLK_CLEARAGAIN"
  of SDLK_CRSEL               : "SDLK_CRSEL"
  of SDLK_EXSEL               : "SDLK_EXSEL"

  of SDLK_KP_00               : "SDLK_KP_00"
  of SDLK_KP_000              : "SDLK_KP_000"
  of SDLK_THOUSANDSSEPARATOR  : "SDLK_THOUSANDSSEPARATOR"
  of SDLK_DECIMALSEPARATOR    : "SDLK_DECIMALSEPARATOR"
  of SDLK_CURRENCYUNIT        : "SDLK_CURRENCYUNIT"
  of SDLK_CURRENCYSUBUNIT     : "SDLK_CURRENCYSUBUNIT"
  of SDLK_KP_LEFTPAREN        : "SDLK_KP_LEFTPAREN"
  of SDLK_KP_RIGHTPAREN       : "SDLK_KP_RIGHTPAREN"
  of SDLK_KP_LEFTBRACE        : "SDLK_KP_LEFTBRACE"
  of SDLK_KP_RIGHTBRACE       : "SDLK_KP_RIGHTBRACE"
  of SDLK_KP_TAB              : "SDLK_KP_TAB"
  of SDLK_KP_BACKSPACE        : "SDLK_KP_BACKSPACE"
  of SDLK_KP_A                : "SDLK_KP_A"
  of SDLK_KP_B                : "SDLK_KP_B"
  of SDLK_KP_C                : "SDLK_KP_C"
  of SDLK_KP_D                : "SDLK_KP_D"
  of SDLK_KP_E                : "SDLK_KP_E"
  of SDLK_KP_F                : "SDLK_KP_F"
  of SDLK_KP_XOR              : "SDLK_KP_XOR"
  of SDLK_KP_POWER            : "SDLK_KP_POWER"
  of SDLK_KP_PERCENT          : "SDLK_KP_PERCENT"
  of SDLK_KP_LESS             : "SDLK_KP_LESS"
  of SDLK_KP_GREATER          : "SDLK_KP_GREATER"
  of SDLK_KP_AMPERSAND        : "SDLK_KP_AMPERSAND"
  of SDLK_KP_DBLAMPERSAND     : "SDLK_KP_DBLAMPERSAND"
  of SDLK_KP_VERTICALBAR      : "SDLK_KP_VERTICALBAR"
  of SDLK_KP_DBLVERTICALBAR   : "SDLK_KP_DBLVERTICALBAR"
  of SDLK_KP_COLON            : "SDLK_KP_COLON"
  of SDLK_KP_HASH             : "SDLK_KP_HASH"
  of SDLK_KP_SPACE            : "SDLK_KP_SPACE"
  of SDLK_KP_AT               : "SDLK_KP_AT"
  of SDLK_KP_EXCLAM           : "SDLK_KP_EXCLAM"
  of SDLK_KP_MEMSTORE         : "SDLK_KP_MEMSTORE"
  of SDLK_KP_MEMRECALL        : "SDLK_KP_MEMRECALL"
  of SDLK_KP_MEMCLEAR         : "SDLK_KP_MEMCLEAR"
  of SDLK_KP_MEMADD           : "SDLK_KP_MEMADD"
  of SDLK_KP_MEMSUBTRACT      : "SDLK_KP_MEMSUBTRACT"
  of SDLK_KP_MEMMULTIPLY      : "SDLK_KP_MEMMULTIPLY"
  of SDLK_KP_MEMDIVIDE        : "SDLK_KP_MEMDIVIDE"
  of SDLK_KP_PLUSMINUS        : "SDLK_KP_PLUSMINUS"
  of SDLK_KP_CLEAR            : "SDLK_KP_CLEAR"
  of SDLK_KP_CLEARENTRY       : "SDLK_KP_CLEARENTRY"
  of SDLK_KP_BINARY           : "SDLK_KP_BINARY"
  of SDLK_KP_OCTAL            : "SDLK_KP_OCTAL"
  of SDLK_KP_DECIMAL          : "SDLK_KP_DECIMAL"
  of SDLK_KP_HEXADECIMAL      : "SDLK_KP_HEXADECIMAL"

  of SDLK_LCTRL               : "SDLK_LCTRL"
  of SDLK_LSHIFT              : "SDLK_LSHIFT"
  of SDLK_LALT                : "SDLK_LALT"
  of SDLK_LGUI                : "SDLK_LGUI"
  of SDLK_RCTRL               : "SDLK_RCTRL"
  of SDLK_RSHIFT              : "SDLK_RSHIFT"
  of SDLK_RALT                : "SDLK_RALT"
  of SDLK_RGUI                : "SDLK_RGUI"

  of SDLK_MODE                : "SDLK_MODE"

  of SDLK_AUDIONEXT           : "SDLK_AUDIONEXT"
  of SDLK_AUDIOPREV           : "SDLK_AUDIOPREV"
  of SDLK_AUDIOSTOP           : "SDLK_AUDIOSTOP"
  of SDLK_AUDIOPLAY           : "SDLK_AUDIOPLAY"
  of SDLK_AUDIOMUTE           : "SDLK_AUDIOMUTE"
  of SDLK_MEDIASELECT         : "SDLK_MEDIASELECT"
  of SDLK_WWW                 : "SDLK_WWW"
  of SDLK_MAIL                : "SDLK_MAIL"
  of SDLK_CALCULATOR          : "SDLK_CALCULATOR"
  of SDLK_COMPUTER            : "SDLK_COMPUTER"
  of SDLK_AC_SEARCH           : "SDLK_AC_SEARCH"
  of SDLK_AC_HOME             : "SDLK_AC_HOME"
  of SDLK_AC_BACK             : "SDLK_AC_BACK"
  of SDLK_AC_FORWARD          : "SDLK_AC_FORWARD"
  of SDLK_AC_STOP             : "SDLK_AC_STOP"
  of SDLK_AC_REFRESH          : "SDLK_AC_REFRESH"
  of SDLK_AC_BOOKMARKS        : "SDLK_AC_BOOKMARKS"

  of SDLK_BRIGHTNESSDOWN      : "SDLK_BRIGHTNESSDOWN"
  of SDLK_BRIGHTNESSUP        : "SDLK_BRIGHTNESSUP"
  of SDLK_DISPLAYSWITCH       : "SDLK_DISPLAYSWITCH"
  of SDLK_KBDILLUMTOGGLE      : "SDLK_KBDILLUMTOGGLE"
  of SDLK_KBDILLUMDOWN        : "SDLK_KBDILLUMDOWN"
  of SDLK_KBDILLUMUP          : "SDLK_KBDILLUMUP"
  of SDLK_EJECT               : "SDLK_EJECT"
  of SDLK_SLEEP               : "SDLK_SLEEP"
  of SDLK_APP1                : "SDLK_APP1"
  of SDLK_APP2                : "SDLK_APP2"

  of SDLK_AUDIOREWIND         : "SDLK_AUDIOREWIND"
  of SDLK_AUDIOFASTFORWARD    : "SDLK_AUDIOFASTFORWARD"

  else                        : $keycode.uint32

# vim: set sts=2 et sw=2:
