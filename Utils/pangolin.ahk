#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\trayicon.ahk
#Include lib\processes.ahk
#NoTrayIcon
#IfWinActive
pango_menu_wintitle = Pangolin Screen Brightness
pango_menu_wintitle = ahk_class #32768 ahk_exe PangoBright.exe
If (A_Args[1] == "")
    dimmer_level = 2    ; %100
Else
    dimmer_level := A_Args[1]
Goto BYPASS_HOTKEY
Return 

CapsLock & 0::
CapsLock & 9:: 
CapsLock & 8:: 
CapsLock & 7:: 
CapsLock & 6:: 
CapsLock & 5:: 
CapsLock & 4:: 
CapsLock & 3:: 
CapsLock & 2::
    KeyWait CapsLock
    If (A_ThisHotkey = "Capslock & 0")
        dimmer_level := 2   ; %100
    Else If (A_ThisHotkey = "Capslock & 9") 
        dimmer_level := 3   ; %90
    Else If (A_ThisHotkey = "Capslock & 8") 
        dimmer_level := 4   ; %80
    Else If (A_ThisHotkey = "Capslock & 7") 
        dimmer_level := 5   ; %70
    Else If (A_ThisHotkey = "Capslock & 6") 
        dimmer_level := 6   ; %60
    Else If (A_ThisHotkey = "Capslock & 5") 
        dimmer_level := 7   ; %50
    Else If (A_ThisHotkey = "Capslock & 4") 
        dimmer_level := 8   ; %40
    Else If (A_ThisHotkey = "Capslock & 3") 
        dimmer_level := 9   ; %30
    Else If (A_ThisHotkey = "Capslock & 2")
        dimmer_level := 10   ; %20
    Else
    {
        OutputDebug, % "Unexepected hotkey: " A_ThisHotkey " (" A_ScriptName ")"
        Return
    }

BYPASS_HOTKEY:
    SetCapsLockState, AlwaysOff
    save_detect_hidden_windows := A_DetectHiddenWindows 
    DetectHiddenWindows, On       
    TrayIcon_Button("PangoBright.exe", "R", False, 1)    
    Sleep 300
    SetTitleMatchMode 2 
    OutputDebug, % "pango_menu_wintitle: " pango_menu_wintitle
    If Not WinExist(pango_menu_wintitle)
        MsgBox, 48,, % "Pangolin Popup menu does not exist", 10
    Else
    {
        ; If WinActive(pango_menu_wintitle)
        ; {
            WinSet, Top,,%pango_menu_wintitle%
            Sleep 100
            SendInput {Down %dimmer_level%}
            Sleep 300
            SendInput {Enter}
        ; }
        ; Else
        ; {
            ; WinGetActiveTitle, aw
            ; OutputDebug, % "aw: " aw
            ; OutputDebug, % "A_ThisLabel: " A_ThisLabel " - A_ScriptName: " A_ScriptName  
        ; }
    }
    SendInput {CapsLock Up}
    DetectHiddenWindows, %save_detect_hidden_windows%
    Return 