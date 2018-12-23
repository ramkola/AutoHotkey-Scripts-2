#SingleInstance Force
; #Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
; #Include lib\utils.ahk
; g_TRAY_RELOAD_ON_LEFTCLICK := True      ; set only 1 to true to enable, see lib\utils.ahk

; ; SetWorkingDir C:\Users\Mark\Desktop\Misc\resources\32x32\Singles
; ; ImageSearch, x, y, A_ScreenWidth - 430, A_ScreenHeight - 50, A_ScreenWidth, A_ScreenHeight, *25 PangoBright_MAINICON_16x16.ico 

; ; ; ImageSearch, x, y, A_ScreenWidth - 430, A_ScreenHeight - 50, A_ScreenWidth, A_ScreenHeight, *25 PangoBright_MAINICON.ico 

; ; If (ErrorLevel == 0)
    ; ; MsgBox, 48,, % "x,y: " x "," y, 10
; ; Else
    ; ; MsgBox, 48,, % "Not Found - ErrorLevel = " ErrorLevel , 1

; WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
; OutputDebug, DBGVIEWCLEAR
; Return 
!+Numpad0:: 
; ^+Numpad9:: 
; ^+Numpad8:: 
; ^+Numpad7:: 
; ^+Numpad6:: 
; ^+Numpad5:: 
; ^+Numpad4:: 
; ^+Numpad3:: 
; ^+Numpad2::
OutputDebug, % "A_ThisHotkey: " A_ThisHotkey
    If (A_ThisHotkey = "^+Numpad0") 
        dimmer_level := 2
    Else If (A_ThisHotkey = "^+Numpad9") 
        dimmer_level := 3
    Else If (A_ThisHotkey = "^+Numpad8") 
        dimmer_level := 4
    Else If (A_ThisHotkey = "^+Numpad7") 
        dimmer_level := 5
    Else If (A_ThisHotkey = "^+Numpad6") 
        dimmer_level := 6
    Else If (A_ThisHotkey = "^+Numpad5") 
        dimmer_level := 7
    Else If (A_ThisHotkey = "^+Numpad4") 
        dimmer_level := 8
    Else If (A_ThisHotkey = "^+Numpad3") 
        dimmer_level := 9
    Else If (A_ThisHotkey = "^+Numpad2")
        dimmer_level := 10
    Else
    {
        OutputDebug, % "Unexepected hotkey: " A_ThisHotkey " (" A_ScriptName ")"
        ; Return
    }

    save_coordmode := A_CoordModeMouse
    CoordMode, Mouse, Screen
    MouseMove, 1110, 1005
    Click
    SendInput {Down %dimmer_level%}{Enter}
    CoordMode, Mouse, %save_coordmode%

; WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe

    Return 