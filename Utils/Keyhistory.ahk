#InstallKeybdHook
SetTitleMatchMode 2
ControlGetFocus, control, A
Loop
{
    ControlGet, is_visible, Visible,,Edit1, Keyhistory.ahk - AutoHotkey
    if is_visible
        ; controlsend is used because it doesn't get logged by Keyhistory
        ControlSend, Edit1, {F5}, Keyhistory.ahk - AutoHotkey
    else
        KeyHistory

    ; SendMessage is used because it doesn't get logged by Keyhistory
    SendMessage, 0x115, 1, 0, %control%, A       ; auto scroll the window
    Sleep 3000
}

Escape::
^x::ExitApp

