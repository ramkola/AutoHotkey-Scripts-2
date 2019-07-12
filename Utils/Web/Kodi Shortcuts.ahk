;************************************************************************
;
; Make these hotkeys available ONLY when dealing with Kodi
; 
; See C:\Users\Mark\AppData\Roaming\Kodi\userdata\keymaps\MyKeymap.xml
; for more shortcuts set internally in kodi.
;************************************************************************
#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\constants.ahk
#Include lib\strings.ahk
#Include lib\utils.ahk
g_TRAY_EXIT_ON_LEFTCLICK := True      ; set only 1 to true to enable, see lib\utils.ahk

SetWorkingDir %AHK_ROOT_DIR%
Menu, Tray, Icon, ..\resources\16x16\kodi.ico
Menu, Tray, Add, 
Menu, Tray, Add, 
Menu, Tray, Add, Run Kodi, RUN_KODI

; #NoTrayIcon
SetTitleMatchMode 2
kodi_wintitle = ahk_class Kodi ahk_exe kodi.exe
#If WinExist(kodi_wintitle)
Return

RUN_KODI:
    Run, "C:\Users\Mark\Documents\Restart Kodi.bat"
    Return

!\::     ; toggle fullscreen / window
!t::     ; toggle subtitles on / off
!Home::  ; toggle play / pause
    save_hotkey := SubStr(A_ThisHotkey,2)
    save_hotkey :=  (save_hotkey = "Home") ? "{Space}" : save_hotkey
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

^+k:: list_hotkeys(,,10)

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

!s::   ; start kodi video wait the "30" seconds then pause video
    If WinActive(kodi_wintitle)
    {
        SendInput {Enter}
        Sleep 50000     ; 50 seconds for sdarot videos plus video load time.
        SendInput {Space}
    }
    Return

; LButton:: SendInput {Click,Left}
; LButton & WheelUp::   SendInput f     ; fast forward
; LButton & WheelDown:: SendInput r     ; fast reverse
; LButton & MButton::   SendInput p     ; play normal speed 