#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\trayicon.ahk
#Include lib\processes.ahk
#Include lib\strings.ahk
#NoTrayIcon
#If pango_running()
If Not pango_running()
    Run, "C:\Program Files (x86)\PangoBright.exe"
pango_menu_wintitle = ahk_class #32768 ahk_exe PangoBright.exe
dimmer_level := (A_Args[1] == "") ? 7 : A_Args[1]   ; 7 = default pango %70
Goto BYPASS_HOTKEY
Return
;========================================================================
pango_running()
{
    Return find_process(x,"PangoBright.exe")
}
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
    OutputDebug, % "A_ThisHotkey: " A_ThisHotkey " - A_ScriptName: " A_ScriptName 
    KeyWait CapsLock, T2
    If ErrorLevel
    {
        MsgBox, 48,, % "Remove finger from capslock quicker when you try again", 5
        Return
    }
    dimmer_level := SubStr(A_ThisHotkey, 0)
    SendInput {CapsLock Up}

BYPASS_HOTKEY:
    SetCapslockState, Off 
    WinGet, active_pid, Id, A
    TrayIcon_Button("PangoBright.exe", "R", False, 1)    
    Sleep 500
    dimmer_level := (dimmer_level = 0) ? 1 : dimmer_level
    SendInput %dimmer_level%
    SendInput {CapsLock Up}
    WinActivate, ahk_id %active_pid%
    Return 

^+k:: list_hotkeys()