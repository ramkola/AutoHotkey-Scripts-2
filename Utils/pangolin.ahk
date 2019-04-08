#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\trayicon.ahk
#Include lib\utils.ahk
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
	KeyWait CapsLock
    SetCapslockState, AlwaysOff
    dimmer_level := SubStr(A_ThisHotkey, 0)
BYPASS_HOTKEY:
    ; dimmer_level := (dimmer_level = 0) ? 1 : dimmer_level
    WinGet, active_pid, Id, A
    TrayIcon_Button("PangoBright.exe", "L", False, 1)    
	If (dimmer_level > 0)
		Sleep 500
	Else 
		Sleep 2000
	If (dimmer_level > 0)
	{
		If WinExist(pango_menu_wintitle)
			ControlSend,, %dimmer_level%, %pango_menu_wintitle% 
	}
	WinActivate, %pango_menu_wintitle%	; this actually causes the menu to close if ControlSend didn't work	
    SendInput {CapsLock Up}
    WinActivate, ahk_id %active_pid%
    Return 
