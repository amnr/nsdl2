##  Message box utils.

{.push raises: [].}

import ../../nsdl2

{.push inline.}

proc show_error_message_box*(window: Window, title: string,
                             message: string): bool {.inline.} =
  ShowSimpleMessageBox MESSAGEBOX_ERROR, title, message, window

proc show_info_message_box*(window: Window, title: string,
                            message: string): bool {.inline.} =
  ShowSimpleMessageBox MESSAGEBOX_INFORMATION, title, message, window

proc log_warning_message_box*(window: Window, title: string,
                              message: string): bool {.inline.} =
  ShowSimpleMessageBox MESSAGEBOX_WARNING, title, message, window

{.pop.}   # inline.

# vim: set sts=2 et sw=2:
