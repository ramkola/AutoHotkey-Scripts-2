;************************************************************************
;
; Make these hotkeys available ONLY when dealing with Kodi
; 
; See C:\Users\Mark\AppData\Roaming\Kodi\userdata\keymaps\MyKeymap.xml
; for more shortcuts set internally in kodi.
;************************************************************************
#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\strings.ahk
; #NoTrayIcon
SetTitleMatchMode 2
kodi_wintitle = ahk_class Kodi ahk_exe kodi.exe
#If WinExist(kodi_wintitle)
Return

\::     ; toggle fullscreen / window
t::     ; toggle subtitles on / off
Home::  ; toggle play / pause
    save_hotkey :=  (A_ThisHotkey = "Home") ? "{Space}" : A_ThisHotkey
    If Not WinExist(kodi_wintitle)
        Return

    ; WinGet, active_hwnd, ID, A
    WinGetTitle, active_wintitle, A
    If Instr(active_wintitle, "tetris")
    {
        SendPlay {LControl}    ; pause tetris
        Sleep 50
    }
    WinActivate, %kodi_wintitle%
    WinWaitActive, %kodi_wintitle%,,1
    If Not ErrorLevel
        SendInput %save_hotkey%     
    If (save_hotkey != "\")
        WinActivate, %active_wintitle%
    Return

^+k:: list_hotkeys()

#If WinActive("ahk_class Kodi ahk_exe kodi.exe")
RAlt::  ; Chappa'ai context player menu
{
    SendInput {AppsKey}{Up 2}{Enter}
    Sleep 100
    SendInput {Enter}
    Return
}

+RAlt::  ; Select Death Streams Autoplay from Chappa'ai context player menu
{
    SendInput {AppsKey}{Up 2}{Enter}
    Sleep 100
    SendInput {Enter}
    Sleep 3000
    SendInput {Down}{Enter}
    Return
}

; LButton:: SendInput {Click,Left}
; LButton & WheelUp::   SendInput f     ; fast forward
; LButton & WheelDown:: SendInput r     ; fast reverse
; LButton & MButton::   SendInput p     ; play normal speed 