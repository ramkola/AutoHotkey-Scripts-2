#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
g_TRAY_RELOAD_ON_LEFTCLICK := True      ; set only 1 to true to enable, see lib\utils.ahk
#NoTrayIcon

SetWorkingDir C:\Users\Mark\Desktop\Misc\resources\32x32\Singles
ImageSearch, x, y, A_ScreenWidth - 430, A_ScreenHeight - 50, A_ScreenWidth, A_ScreenHeight, *25 PangoBright_MAINICON_16x16.ico 
; ImageSearch, x, y, A_ScreenWidth - 430, A_ScreenHeight - 50, A_ScreenWidth, A_ScreenHeight, *25 PangoBright_MAINICON.ico 
If (ErrorLevel == 0)
    MsgBox, 48,, % "x,y: " x "," y, 10
Else
    MsgBox, 48,, % "Not Found - ErrorLevel = " ErrorLevel , 1

Return 

Capslock & 0::
Capslock & 9:: 
Capslock & 8:: 
Capslock & 7:: 
Capslock & 6:: 
Capslock & 5:: 
Capslock & 4:: 
Capslock & 3:: 
Capslock & 2::
    SetCapsLockState, AlwaysOff
    If (A_ThisHotkey = "Capslock & 0")
        dimmer_level := 2
    Else If (A_ThisHotkey = "Capslock & 9") 
        dimmer_level := 3
    Else If (A_ThisHotkey = "Capslock & 8") 
        dimmer_level := 4
    Else If (A_ThisHotkey = "Capslock & 7") 
        dimmer_level := 5
    Else If (A_ThisHotkey = "Capslock & 6") 
        dimmer_level := 6
    Else If (A_ThisHotkey = "Capslock & 5") 
        dimmer_level := 7
    Else If (A_ThisHotkey = "Capslock & 4") 
        dimmer_level := 8
    Else If (A_ThisHotkey = "Capslock & 3") 
        dimmer_level := 9
    Else If (A_ThisHotkey = "Capslock & 2")
        dimmer_level := 10
    Else
    {
        OutputDebug, % "Unexepected hotkey: " A_ThisHotkey " (" A_ScriptName ")"
        Return
    }
    
    save_coordmode := A_CoordModeMouse
    CoordMode, Mouse, Screen
    SetMouseDelay, -1
    MouseGetPos, save_x, save_y  
    Click, 1100, 1005   ; assumed position of Pangolin tray icon
    SendInput {Down %dimmer_level%}{Enter}
    MouseMove, save_x, save_y
    CoordMode, Mouse, %save_coordmode%
    Return 