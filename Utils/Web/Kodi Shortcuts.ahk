; kodi shortcuts
\::     ; kodi fullscreen
    If WinExist("Kodi ahk_class Kodi ahk_exe kodi.exe")
    {
        SendPlay {LControl}    ; pause tetris
        Sleep 50
        WinActivate, Kodi ahk_class Kodi ahk_exe kodi.exe
        SendInput \             ; kodi fullscreen toggle
        ; WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
    }
    Return