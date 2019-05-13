#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
#NoTrayIcon

SetTimer, MOUSE_TOOL_TIP, 1000 
OnExit("restore_cursors")
set_system_cursor("IDC_HAND")
tt_msg = 
(Join`n
Leftclick      -  Select window
Rightclick    - Toggles Always On Top
Middle/Esc  - Cancel
)

MOUSE_TOOL_TIP:
    MouseGetPos, x, y
    ToolTip, %tt_msg%, x+10, y+20
    Return

RButton::   
    MouseGetPos,,, hwnd_under_cursor
    WinSet, AlwaysOnTop, Toggle, ahk_id %hwnd_under_cursor%
    SetTimer, MOUSE_TOOL_TIP, Off
    ToolTip
    restore_cursors()
    ExitApp, hwnd_under_cursor

MButton::    MouseGetPos,,, hwnd_under_cursor
    ExitApp, hwnd_under_cursor
    
Escape::
    ExitApp