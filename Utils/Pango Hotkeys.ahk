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
#Include lib\utils.ahk
#Include lib\trayicon.ahk
#Include lib\pango_level.ahk
#NoTrayIcon

pango_menu_wintitle = ahk_class #32768 ahk_exe PangoBright.exe
dimmer_level := A_Args[1]   
If dimmer_level
    Goto BYPASS_HOTKEY  ; when program is initially started
Else
    ttip(A_ScriptName " is running", 1500)
Return

;========================================================================
>+MButton::     ; Display pango menu
>+WheelDown::   ; Make screen darker
>+WheelUp::     ; Make screen brighter
    current_level := pango_level(0)
    TrayIcon_Button("PangoBright.exe", "L", False, 1)    
    Sleep 100
    If (A_ThisHotkey = ">+MButton")
        Return  ; keep pango menu open
    Else If (A_ThisHotkey = ">+WheelUp")
        current_level := (current_level + 10 > 100) ? 100 : current_level +=10
    Else If (A_ThisHotkey = ">+WheelDown")
        current_level := (current_level - 10 < 20) ? 20 : current_level -=10
    
    new_level := Round(current_level / 10)
    menu_accelerator_key := (new_level = 10) ?  1 : new_level
    ControlSend,, %menu_accelerator_key%, %pango_menu_wintitle%
    Return

ScrollLock & \::  ; View current level for 2 sceonds
ScrollLock & 1::  ; Get current level
ScrollLock & 0::  ; %100  
ScrollLock & 9::  ; %90 
ScrollLock & 8::  ; %80 
ScrollLock & 7::  ; %70 
ScrollLock & 6::  ; %60 
ScrollLock & 5::  ; %50 
ScrollLock & 4::  ; %40 
ScrollLock & 3::  ; %30 
ScrollLock & 2::  ; %20
    ; If a hotkey was used to set the dimmer_level
	KeyWait ScrollLock
    SetScrollLockState, AlwaysOff
    hotkey_level := SubStr(A_ThisHotkey, 0)
    If (A_ThisHotkey = "ScrollLock & \")
        dimmer_level := 1
    Else If (A_ThisHotkey = "ScrollLock & 1")
        dimmer_level := 0
    Else
        dimmer_level := (hotkey_level = 0) ? 100 : hotkey_level * 10
BYPASS_HOTKEY:  ; when a command line parameter was used to set dimmer_level instead of a hotkey
    active_id := WinExist("A")
    pango_level(dimmer_level)
    WinActivate, ahk_id %active_id%
    Return 