#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\trayicon.ahk
#NoTrayIcon
pango_menu_wintitle = ahk_class #32768 ahk_exe PangoBright.exe
dimmer_level := (A_Args[1] == "") ? 7 : A_Args[1]   ; 7 = default pango %70
Goto BYPASS_HOTKEY
Return

;========================================================================

CapsLock & 0::  ; %100
CapsLock & 1::  ; %100
CapsLock & 9::  ; %90 
CapsLock & 8::  ; %80 
CapsLock & 7::  ; %70 
CapsLock & 6::  ; %60 
CapsLock & 5::  ; %50 
CapsLock & 4::  ; %40 
CapsLock & 3::  ; %30 
CapsLock & 2::  ; %20
    SetCapslockState, AlwaysOff
    dimmer_level := SubStr(A_ThisHotkey, 0)
BYPASS_HOTKEY:
    WinGet, active_pid, Id, A
    TrayIcon_Button("PangoBright.exe", "R", False, 1)    
    Sleep 500
    dimmer_level := (dimmer_level = 0) ? 1 : dimmer_level
    If WinExist(pango_menu_wintitle)
        ControlSend,, %dimmer_level%, %pango_menu_wintitle%   
    SendInput {CapsLock Up}
    WinActivate, ahk_id %active_pid%
    Return 
