; kodi shortcuts
; #If WinExist(kodi_wintitle)

\::     ; toggle fullscreen / window
t::     ; toggle subtitles on / off
Home::  ; toggle play / pause
    save_hotkey :=  (A_ThisHotkey = "Home") ? "{Space}" : A_ThisHotkey
    kodi_wintitle = Kodi ahk_class Kodi ahk_exe kodi.exe
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