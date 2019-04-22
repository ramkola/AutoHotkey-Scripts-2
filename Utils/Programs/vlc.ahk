#SingleInstance Force 
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\constants.ahk
#Include lib\strings.ahk
#Include lib\utils.ahk
g_TRAY_EXIT_ON_LEFTCLICK := True      ; set only 1 to true to enable, see lib\utils.ahk
SetWorkingDir %AHK_ROOT_DIR%
Menu, Tray, Icon, ..\resources\32x32\icons8-under-construction-32.png
SetTitleMatchMode 2
player_wintitle := "VLC media player ahk_class Qt5QWindowIcon ahk_exe vlc.exe"
playlist_wintitle := "Playlist ahk_class Qt5QWindowIcon ahk_exe vlc.exe"
dlg_save_playlist_wintitle := "Save playlist as... ahk_class #32770 ahk_exe vlc.exe"
dlg_confirm_save_wintitle := "Confirm Save As ahk_class #32770 ahk_exe vlc.exe"
dlg_open_file_wintitle := "Select one or more files to open ahk_class #32770 ahk_exe vlc.exe"

If Not WinExist(player_wintitle)
{
    RegRead, exe_path, % "HKEY_CLASSES_ROOT\Applications\vlc.exe\shell\open\command"
    exe_path := RegExReplace(exe_path,"i)^""?([a-z]:\\(\s+|\w+|\\|\(|\)|-|\.)+?.*\.exe).*","$1")
    Run, "%exe_path%"
}

lbutton_switch := True
ttip(A_ScriptName " running" ,1500)

OutputDebug, DBGVIEWCLEAR

Return
;************************************************************************
;
; Make these hotkeys available ONLY within VLC (video/playlist)
; 
;************************************************************************
#If WinActive(player_wintitle) or WinActive(playlist_wintitle)

!LButton::
    lbutton_switch := !lbutton_switch
    switch_text := lbutton_switch ? "On" : "Off"
    Hotkey, LButton, %switch_text%
    If lbutton_switch
        ttip("`r`nLeftclick toggles play / pause  in VLC player window`r`n ", 1500)
    Else
        ttip("`r`nNormal left click button `r`n ", 1500)
    Return     

LButton:: 
    If Not mouse_hovering_over_window("i).*VLC media player")
    {
        SendInput {Click, Left, 1}
        Return
    }
    MouseGetPos,,,,active_classnn
    If InStr(active_classnn, "VLC video output") 
        SendInput {Space} ; play / pause toggle
    Else
        SendInput {Click, Left, 1}
    Return

~MButton:: SendInput f  ; fullscreen toggle
!WheelUp:: SendInput {Right}   ; Seek forward 30 secs
!WheelDown:: SendInput {Left}  ; Seek backward 30 secs
WheelUp:: SendInput {Up}       ; Volume up
WheelDown:: SendInput {Down}   ; Volume down


^+k:: list_hotkeys()

^+e::   ; Opens VLC effects and filters options when video is in fullscreen
{
    SendInput f^ef
    Sleep 200
    WinActivate, Adjustments And Effects ahk_class Qt5QWindowToolSaveBits ahk_exe vlc.exe
    Return
}

^+j::   ; Opens VLC Codec Information when video is in fullscreen
{
    OutputDebug, DBGVIEWCLEAR
    SendInput f^j
    WinWaitActive, Current Media Information,,1
    While WinExist("Current Media Information")
    {
        WinActivate     ; as if always on top
        Sleep 500
    }
    WinActivate, %player_wintitle%
    WinWaitActive, %player_wintitle%,,1
    If ErrorLevel
        OutputDebug, % "errorlevel: " ErrorLevel " player_wintitle: " player_wintitle
    SendInput f
    Return
}

^+w::   ; Toggles video/always fit window when video is in fullscreen
{
    SendInput f!vwf
    Return
}

f::     ; VLC fullscreen
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

l::      ; Toggle playist (also overrides loop video VLC hotkey)
^+a::    ; Toggle playlist
{
    If WinExist(playlist_wintitle)
        WinClose
    Else
    {
        ; Player Menu - View/Playlist
        ControlSend, Qt5QWindowIcon10, {Alt Down}il{Alt Up}{Enter}, %player_wintitle%
        If ErrorLevel
            ; Problem on VLC startup - Qt5QWindowIcon10 doesn't exist until a video has been played
            SendInput, {Alt Down}il{Alt Up}{Enter}
    }
    Return
}

^!y::       ; Saves VLC unwatched.xspf playlist
{    
    If (A_ThisHotkey = "~Delete") and WinActive(playlist_wintitle)
        Sleep 200   ; allow delete to occur before saving playlist
    WinActivate, %player_wintitle%
    ; VLC Player Menu - Media/Save Playlist to File...
    ControlSend, Qt5QWindowIcon10, !mff{Enter}, %player_wintitle%  
    If ErrorLevel
        SendInput, !mff{Enter}
    WinWaitActive, %dlg_save_playlist_wintitle%,,1
    ControlSetText, Edit1, C:\Users\Mark\Google Drive\Unwatched.xspf, %dlg_save_playlist_wintitle%
    ControlClick, Save, %dlg_save_playlist_wintitle%,, Left, 1, NA
    WinWaitActive, %dlg_confirm_save_wintitle%,,1
    ControlClick, Yes, %dlg_confirm_save_wintitle%,, Left, 1, NA
    Return
}

^!+y::   ; Saves VLC unwatched backup.xspf playlist
{
    WinActivate, %player_wintitle%
    SendInput s         ; stop video if playing
    SendInput ^y        ; save playlist
    WinWaitActive, %dlg_save_playlist_wintitle%,,1
    ControlSetText, Edit1, C:\Users\Mark\Google Drive\Unwatched backup.xspf, %dlg_save_playlist_wintitle%
    ControlClick, Save, %dlg_save_playlist_wintitle%,, Left, 1, NA
    WinWaitActive, %dlg_confirm_save_wintitle%,,1
    ControlClick, Yes, %dlg_confirm_save_wintitle%,, Left, 1, NA
    ; this backup is usually done when I don't want to watch anymore videos for now...
    WinClose, %playlist_wintitle%   
    WinMinimize, %player_wintitle% 
    Return
}

^!o::   ; Opens VLC unwatched.xspf playlist
{
    WinActivate, %player_wintitle%
    SendInput ^o
    WinWaitActive, %dlg_open_file_wintitle%,,1
    ControlSetText, Edit1, C:\Users\Mark\Google Drive\Unwatched backup.xspf, %dlg_open_file_wintitle%
    ControlClick, Open, %dlg_open_file_wintitle%,, Left, 1, NA
    ; WinClose, %playlist_wintitle%
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

; Playlist only hotkeys can't use #IF for context sensitive screws up !LButton 
^WheelUp::      ; Scroll playlist up
^WheelDown::    ; Scroll playlist down
~Enter::        ; Starts selected video and activates player window 
RButton::       ; In Playlist - shows context menu. In Player - 
    If WinActive(playlist_wintitle)
    {   
        If (A_ThisHotkey = "^WheelUp")
            SendInput {Up}
        Else If (A_ThisHotkey = "^WheelDown")
            SendInput {Down}
        Else If (A_ThisHotkey = "~Enter")
            WinActivate, %player_wintitle%   ; start video and setfocus on player window
        Else If (A_ThisHotkey = "RButton")
            SendInput {AppsKey}
    }
    
    If WinActive(player_wintitle)
    {
        If (A_ThisHotkey = "RButton")
            ttip("`r`n`r`n    I need to put something here    `r`n`r`n ", 1000)
    }
    Return

/* 
    OBSOLETE ^!a : :   ; Sets VLC default audio device to speakers
    To make setting permanent in VLC:
    tools/preferences/audio/output modules/MMDevice - Output Device set to Speakers(Realtek...)

^!a : :  ; Sets VLC default audio device to speakers
{
    WinActivate, %player_wintitle%
    ; WinMenuSelectItem, VLC media player ahk_class Qt5QWindowIcon,, Audio, Audio Device, Speakers (Realtek High Definition Audio) 
    SendInput {Alt Down}ad
    Sleep 1000
    SendInput {Up}{Alt Up}{Enter}
    Return
}
*/

