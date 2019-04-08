#SingleInstance Force 

#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\constants.ahk
#Include lib\utils.ahk
g_TRAY_RELOAD_ON_LEFTCLICK := True      ; set only 1 to true to enable, see lib\utils.ahk
SetWorkingDir %AHK_ROOT_DIR%
Menu, Tray, Icon, ..\resources\32x32\icons8-under-construction-32.png
SetTitleMatchMode RegEx
player_wintitle = i)^.*VLC media player$ ahk_class Qt5QWindowIcon
playlist_wintitle = Playlist ahk_class Qt5QWindowIcon

^!+l::ListLines
Return

;-------
; Mouse
;-------
#If WinActive(player_wintitle)
~MButton:: SendInput f  ; fullscreen toggle
RButton & WheelUp:: SendInput {Right}   ; Seek forward 30 secs
RButton & WheelDown:: SendInput {Left}  ; Seek backward 30 secs
LButton Up:: 
    if not mouse_hovering_over_window("i).*VLC media player")
    {
        OutputDebug, % "Mouse is not hovering VLC Player window."
        SendInput {Click, Left, 1}
        Return
    }
    OutputDebug, DBGVIEWCLEAR
    MouseGetPos,,,,active_classnn
    If InStr(active_classnn, "VLC video output") 
        SendInput {Space} ; play / pause toggle
    Else
        SendInput {Click, Left, 1}
    Return
    
#If WinActive(playlist_wintitle)
WheelUp:: SendInput {Up}
WheelDown:: SendInput {Down}
~Enter:: WinActivate, %player_wintitle%   ; start video and setfocus on player window

;************************************************************************
;
; Make these hotkeys available ONLY within VLC (video/playlist)
; 
;************************************************************************
#If WinActive(player_wintitle) or WinActive(playlist_wintitle)

^+e::   ; Opens VLC effects and filters options when video is in fullscreen
{
    SendInput f^ef
    Sleep 200
    WinActivate, Adjustments and Effects ahk_class Qt5QWindowToolSaveBits ahk_exe vlc.exe
    Return
}

^!+j::   ; Opens VLC Codec Information when video is in fullscreen
{
    OutputDebug, DBGVIEWCLEAR
    SendInput f^j
    OutputDebug, % "Exists"
    ; While WinExist("Current Media Information ahk_class Qt5QWindowIcon ahk_exe vlc.exe")
    While WinExist(".*Current Media Information.*")
    {
        OutputDebug, % "Exists"
        Sleep 10
    }
    ; WinActivate, %player_wintitle%
    ; WinWaitActive, %player_wintitle%,,2
    OutputDebug, DBGVIEWCLEAR
    WinActivate, .*VLC media Player
    WinWaitActive, .*VLC media Player
    if errorlevel
        OutputDebug, % "errorlevel: " errorlevel " player_wintitle: " player_wintitle
    WinGetTitle, wt, A
    OutputDebug, % "A: " A
    
    SendInput f
    Return
}

^+w::   ; Toggles video/always fit window when video is in fullscreen
{
    SendInput f!vwf
    Return
}

f::
^f::    ; VLC fullscreen
{
    WinActivate, %player_wintitle%
    SendInput f 
    WinActivate, ahk_class Qt5QWindowIcon ahk_exe vlc.exe
    Return
}

^s::    ; VLC stop 
{
    WinActivate, %player_wintitle%
    SendInput s
    Return
}

; l::     ; Toggle playist & overwrites loop video
^+a::    ; Toggle playlist
{
    ; if playlist exists close it
    If WinExist(playlist_wintitle)
    {
        WinActivate, %playlist_wintitle%
        If WinActive(playlist_wintitle)
            SendInput !{F4}

    }
    ; if playlist does not exist open it
    If Not WinExist(playlist_wintitle)
    {
        WinActivate, %player_wintitle%
        SendInput {Alt Down}il{Enter}
        Return
    }
    Return
}

/* obsolete */
; ^!a ::   ; Sets VLC default audio device to speakers
; {
    ; WinActivate, %player_wintitle%
    ; ; WinMenuSelectItem, VLC media player ahk_class Qt5QWindowIcon,, Audio, Audio Device, Speakers (Realtek High Definition Audio) 
    ; SendInput {Alt Down}ad
    ; Sleep 1000
    ; SendInput {Up}{Alt Up}{Enter}
    ; Return
; }

~Delete::    ; no return statement so it executes the save (^!y) routine as well.
^!y::   ; Saves VLC unwatched.xspf playlist
{
    Sleep 200   ; allows delete to occur
    WinActivate, %player_wintitle%
    SendInput ^y
    Sleep 500
    SendInput C:\Users\Mark\Google Drive\Unwatched.xspf!s{Left}{Enter}
    If (A_ThisHotkey = "~Delete")
    {
        Sleep 500
        WinActivate, %playlist_wintitle%
    }
    Return
}

^!+y::   ; Saves VLC unwatched backup.xspf playlist
{
    WinActivate, %player_wintitle%
    SendInput s         ; stop video if playing
    SendInput ^y        ; save playlist
    Sleep 500
    SendInput C:\Users\Mark\Google Drive\Unwatched backup.xspf!s{Left}{Enter}
    Sleep 1500
    WinMinimize, %player_wintitle%
    If WinExist(playlist_wintitle)
    {
        WinActivate, %playlist_wintitle%
        WinWaitActive
        If WinActive(playlist_wintitle)
            SendInput !{F4}     ; close playlist
    }
    Return
}

^!o::   ; Opens VLC unwatched.xspf playlist
{
OutputDebug, % "A_ThisHotkey: " A_ThisHotkey
    WinActivate, %player_wintitle%
    SendInput ^o
    Sleep 500
    SendInput C:\Users\Mark\Google Drive\Unwatched.xspf
    WinActivate, %playlist_wintitle%
    If WinActive(playlist_wintitle)
        SendInput !{F4}
    Return
}

^+o::   ; Show VLC containing folder...
{
    If !WinExist(playlist_wintitle)
    {    
        SendInput ^l    ; open playlist
        Sleep 10
    }
    WinActivate, %playlist_wintitle%
    SendInput {AppsKey}{Down 5}
    Sleep 10
    SendInput {Enter}
    Return
}
