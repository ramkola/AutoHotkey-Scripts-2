#InstallKeybdHook
SetTitleMatchMode 2

WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
OutputDebug, DBGVIEWCLEAR
WinActivate, ahk_class Notepad++ ahk_exe notepad++.exe

Loop
{
    ControlGet, is_visible, Visible,,Edit1, Keyhistory.ahk - AutoHotkey
    if is_visible
    {
        ; controlsend is used because it doesn't get logged by Keyhistory
        ControlSend, Edit1, {F5}, Keyhistory.ahk - AutoHotkey
        OutputDebug, F5
    }
    else
    {
        KeyHistory
        OutputDebug, keyhistory
    }
    ; WheelDown is used because it doesn't get logged by Keyhistory
    SendInput {WheelDown}    ; auto scroll the window
    Sleep 3000
}

Escape::
^x::ExitApp

