; Main purpose of this program is to provide globally available hotkeys to manipulate
; PangoBright.exe dimmer levels.
;
; See also: lib\pango_level.ahk for documentation
; When passed as a parameter must be 1 of 0|1|20|30|40|50|60|70|80|90|100 
; or it will fail with a return code -999 for passing a bad parameter.
; 0 = get current dimmer level. Returns current dimmer level setting or False if imagesearch failed.
; 1 = view pango menu for 2 seconds to visually checj current dimmer level. Always returns True 
; 20-100 = set dimmer level. Returns dimmer_level or false.
;
#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
; #Include lib\utils.ahk
#Include lib\trayicon.ahk
#Include lib\pango_level.ahk
; #NoTrayIcon
pango_menu_wintitle = ahk_class #32768 ahk_exe PangoBright.exe
dimmer_level := (A_Args[1] == "") ? 1 : A_Args[1]   
Goto BYPASS_HOTKEY  ; when program is initially started
Return

;========================================================================

CapsLock & `::  ; View current level for 2 sceonds
CapsLock & 0::  ; Get current level
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
    If (A_ThisHotkey = "CapsLock & `")
        dimmer_level := 1
    Else
        dimmer_level := (dimmer_level = 1) ? 100 : dimmer_level * 10    ; zero remains zero = get current level 
        
BYPASS_HOTKEY:  ; when a command line parameter was used to set dimmer_level instead of a hotkey
    result := pango_level(p_dimmer_level)
    Return 