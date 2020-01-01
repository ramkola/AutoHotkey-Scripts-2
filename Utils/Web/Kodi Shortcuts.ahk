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
#Include lib\pango_level.ahk
g_TRAY_EXIT_ON_LEFTCLICK := True      ; set only 1 to true to enable, see lib\utils.ahk
SetWorkingDir %AHK_ROOT_DIR%
result = 0
While Not result
    result := pango_level(100)
If result = -999
    Return
    
    
Menu, Tray, Icon, ..\resources\16x16\kodi.ico
Menu, Tray, Add, 
Menu, Tray, Add, % "Mark As Watched", MARK_AS_WATCHED
Menu, Tray, Add, % "List Hotkeys", LIST_MYHOTKEYS
Menu, Tray, Add, % "Run Kodi", RUN_KODI
Menu, Tray, Add, 
Menu, Tray, Add, 
Menu, Tray, Add, Monitor Sleep, MONITOR_SLEEP

SetTitleMatchMode 2
kodi_wintitle = ahk_class Kodi ahk_exe kodi.exe
#If WinExist(kodi_wintitle)
Return

MONITOR_SLEEP:
    Run, "C:\Users\Mark\Desktop\Turn Off Monitor.ahk.lnk"
    Return

MARK_AS_WATCHED:
    Run, MyScripts\Utils\Web\Kodi Mark As Watched.ahk
    Return

LIST_MYHOTKEYS:
    list_hotkeys()
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


#If WinActive("ahk_class Kodi ahk_exe kodi.exe")

^+k:: list_hotkeys(,,10)

/* 
************************************
*** OBSOLETE - NO MORE CHAPPA'AI ***
************************************
+RAlt::  ; Chappa'ai context player menu
{
    SendInput {AppsKey}{Up 4}{Enter}
    Sleep 100
    SendInput {Enter}
    Return
}

RAlt::  ; Select alternative player from Chappa'ai context player menu
{
    SendInput {AppsKey}{Up 4}{Enter}
    Sleep 100
    SendInput {Enter}
    Sleep 3500
    SendInput {Down}{Enter}
    Return
}

 */

^!s::  ; start selected video wait the "xx" seconds then pause video
!s::   ; start next episode wait the "xx" seconds then pause video
    If WinActive(kodi_wintitle)
    {
        If (A_ThisHotkey = "!s")
        {
            SendInput {Home}{Right}
            Sleep 100
        }
        SendInput {Enter}
        Sleep 50000         ; 50 seconds for sdarot videos plus video load time.
        SendInput 0000{Enter}  ; time to skip forward past previous episodes recap / theme song
        SendInput {Space}
    }
    Return

!f::    ; fast forward speed x32
    SendInput {f 5}
    Return

MButton:: 
    SendInput \         ; Toggle Fullscreen
    Return

MButton & WheelUp::     ; fast forward
    Click, 500, 200
    SendInput f     
    Return
MButton & WheelDown::   ; fast reverse 
    Click, 500, 200
    SendInput r     
    Return
MButton & LButton::     ; play normal speed
    Click, 500, 200
    SendInput p     
    Return
