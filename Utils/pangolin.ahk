#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\trayicon.ahk
#Include lib\utils.ahk
#NoTrayIcon
#If
#IfWinActive
pango_menu_wintitle = ahk_class #32768 ahk_exe PangoBright.exe
dimmer_level := (A_Args[1] == "") ? 7 : A_Args[1]   ; 7 = pango dimmer level %70
Goto BYPASS_HOTKEY
Return

;========================================================================

CapsLock & 0::  ; Show current level
CapsLock & 1::  ; %100
CapsLock & 9::  ; %90 
CapsLock & 8::  ; %80 
CapsLock & 7::  ; %70 
CapsLock & 6::  ; %60 
CapsLock & 5::  ; %50 
CapsLock & 4::  ; %40 
CapsLock & 3::  ; %30 
CapsLock & 2::  ; %20
    ; If a hotkey was used to set the dimmer_level
	KeyWait CapsLock
    SetCapslockState, AlwaysOff
    dimmer_level := SubStr(A_ThisHotkey, 0)

BYPASS_HOTKEY:  ; if a command line parameter was used to set dimmer_level
    WinGet, active_pid, Id, A

    TrayIcon_Button("PangoBright.exe", "L", False, 1)    
	If (dimmer_level > 0)
    {
        Sleep 100   ; allow time for menu to show for controlsend
        ControlSend,, %dimmer_level%, %pango_menu_wintitle% 
    }
	Else 
		Sleep 2000  ; allow time for user to view current level in the popup menu

	WinActivate, %pango_menu_wintitle%	; causes menu to close if ControlSend wasn't used or didn't work	
    SendInput {CapsLock Up}
    WinActivate, ahk_id %active_pid%
    Return