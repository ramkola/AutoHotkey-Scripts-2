; doesn't work for processes that don't have at least a systray icon.
WM_COMMAND = 0x111
ID_FILE_EXIT = 65405
DetectHiddenWindows, On

WinGet, AList, List, ahk_class AutoHotkey       ; Make a list of all running AutoHotkey programs
Loop %AList% {                                  ; Loop through the list
  ID := AList%A_Index%
  WinGetTitle, ATitle, ahk_id %ID%              ; (You'll notice this isn't the same 'window title')
  MsgBox, 3, %A_ScriptName%, %ATitle%`n`nEnd?
  IfMsgBox Cancel
    Break
  IfMsgBox Yes
    PostMessage,WM_COMMAND,ID_FILE_EXIT,0,,% "ahk_id" AList%A_Index%   ; End the process (65404 to suspend, 65403 to pause)
}
ExitApp