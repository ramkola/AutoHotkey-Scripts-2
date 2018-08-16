#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\constants.ahk
#NoEnv
#SingleInstance Force
SetWorkingDir %AHK_ROOT_DIR%
Menu, Tray, Icon, ..\resources\32x32\consulting.png

OnMessage(0x4a, "Receive_WM_COPYDATA")          ; 0x4a is WM_COPYDATA
; OnMessage(0x16, "Receive_WM_ENDSESSION")        ; 0x16 is WM_ENDSESSION 
; OnMessage(0x11, "Receive_WM_QUERYENDSESSION")   ;  0x11 is WM_QUERYENDSESSION

win_size = X-1284 Y38 W244 H10

Winget, hwnd_receiver,ID, Receive WM_COPYDATA from AutoHotkey ahk_class PythonAhkReceiver ahk_exe notepad++.exe
if hwnd_receiver
{
    Wingetpos, x,y,w,h, ahk_id %hwnd_receiver%
    win_size := "X"x " Y"(y+h-1) " W"(w-6) " H"(h-29)
    Clipboard := "hex: " hwnd_receiver " dec: " Format("{:d}", hwnd_receiver)
    OutputDebug, % Clipboard
}
Gui, Font, s8
Gui, +ToolWindow -SysMenu
Gui, Show,%win_size%,Receive WM_COPYDATA from PythonScript

Return

GuiEscape:
GuiClose:
    ExitApp
    ; MsgBox, 291,, % "Are you sure want to close Receive WM_COPYDATA from PythonScript?"
    ; IfMsgBox Yes
        ; ExitApp

Receive_WM_COPYDATA(wParam, lParam)
{
    OutputDebug, % A_ScriptName " - " A_ThisFunc " - Received a message."
    StringAddress := NumGet(lParam + 2*A_PtrSize)  ; Retrieves the CopyDataStruct's lpData member.
    CopyOfData := StrGet(StringAddress)  ; Copy the string out of the structure.
    ; Show it with ToolTip vs. MsgBox so we can return in a timely fashion:
    ToolTip %A_ScriptName%`nReceived the following string:`n%CopyOfData%
    Clipboard := CopyOfData
    SetTimer, TOOLTIPOFF, 5000
    return true  ; Returning 1 (true) is the traditional way to acknowledge this message.
}

TOOLTIPOFF:
ToolTip
Return

#s::Gui, Show
