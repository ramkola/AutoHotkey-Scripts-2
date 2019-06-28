#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\strings.ahk
#Include lib\utils.ahk
#NoTrayIcon

; excluded windows
aoe_wintitle = Age of Empires II Expansion ahk_class Age of Empires II Expansion ahk_exe age2_x1.exe

show_info_interval = 7000
microplayer_classnn = TMMPlayerSkinEngine1
microplayer_wintitle = ahk_class Shell_TrayWnd ahk_exe Explorer.EXE
mediamonkey_wintitle = MediaMonkey ahk_class TFMainWindow ahk_exe MediaMonkey.exe
ttip("`r`n " A_ScriptName " is STARTING. `r`n ",,,, False)

#If mediamonkey_toolbar_visible(microplayer_wintitle, microplayer_classnn) and Not WinExist(aoe_wintitle)

While Not mediamonkey_toolbar_visible(microplayer_wintitle, microplayer_classnn)
{
    If WinActive(mediamonkey_wintitle)
        SendInput ^!+m      ; Change main window to microplayer
    Else
    {
        ; if program is active this will just activate the main window or 
        ; microplayer, whichever state it was in when last closed.
        RegRead, exe_path, % "HKEY_CLASSES_ROOT\MediaMonkey\shell\open\command"
        exe_path := RegExReplace(exe_path,"i)^\x22?([a-z]:\\(\w+|\s|\\|\(|\)|-|\.)*\.exe).*","$1")
        Run, "%exe_path%"
    }
    Sleep 1000
}

ttip("`r`n " A_ScriptName " is RUNNING. `r`n ", 1500)

Return

;======================================

mediamonkey_toolbar_visible(p_wintitle, p_classnn) 
{
    ControlGet, is_visible, Visible,, %p_classnn%, %p_wintitle%
    Return is_visible
}    

show_track_info(p_wintitle, p_classnn, p_interval)
{
    BlockInput On
    set_system_cursor("IDC_WAIT")
    ToolTip, % "`r`n`tPlease wait and look down at microplayer`t`r`n ", 500, 500
    SetMouseDelay -1
    MouseGetPos, save_x, save_y
    ControlGetPos, x,, w, h, %p_classnn%, %p_wintitle%  ; y = 0 get it from WinGetPos
    WinGetPos,,y,,, %p_wintitle%
    MouseMove, x+(w/2) - 15, y+(h/2)
    Sleep p_interval
    MouseMove, save_x, save_y
    ToolTip
    restore_cursors()
    BlockInput Off
    Return
}

switch_to_normal_player(p_wintitle, p_classnn, p_wintitle2)
{
    SetMouseDelay -1
    MouseGetPos, save_x, save_y
    ControlGetPos, x,, w, h, %p_classnn%, %p_wintitle%  ; y = 0 get it from WinGetPos 
    WinGetPos,,y,,, %p_wintitle%
    MouseMove, x+18, y+16
    SendEvent {Click, Left, Down}{Click, Left, Up}
    Sleep 1000
    WinMaximize, %p_wintitle2%
    MouseMove, save_x, save_y
    Return
}

rate_playing_song(p_wintitle, p_classnn, p_rating)
{
    SetMouseDelay 10
    MouseGetPos, save_x, save_y
    ControlGetPos, x,, w, h, %p_classnn%, %p_wintitle%  ; y = 0 get it from WinGetPos 
    WinGetPos,,y,,, %p_wintitle%
    MouseMove, x+65, y+15
    SendEvent {Click, Right, Down}{Click, Right, Up}     ; activate context menu
    Sleep 100
    SendInput a     ; activate My Rating - context menu submenu 
    Sleep 100
    SendInput %p_rating%%p_rating%{Enter}       ; twice to skip over half star ratings
    MouseMove, save_x, save_y
    Return
}

;******************************************************
; These keys control MediaMonkey in MicroPlayer Mode
;******************************************************
CapsLock & s::      ; Show current track info/art
^m::                ; Switch from microplayer to normal window / in normal window  ^!+m configured to switch back to microplayer
^!Up::              ; MediaMonkey MicroPlayer Volume Up (shortcut in MediaMonkey main window)
^!+Up::             ; MediaMonkey MicroPlayer Volume Up
^!+WheelUp::        ; MediaMonkey MicroPlayer Volume Up
^!Down::            ; MediaMonkey MicroPlayer Volume Down (shortcut in MediaMonkey main window)
^!+Down::           ; MediaMonkey MicroPlayer Volume Down
^!+WheelDown::      ; MediaMonkey MicroPlayer Volume Down
    KeyWait CapsLock
    SetCapsLockState, AlwaysOff
    send_cmd := ""
    If InStr(A_ThisHotkey, "Up")
        send_cmd := "WheelUp"
    Else If InStr(A_ThisHotkey, "Down")
        send_cmd := "WheelDown"
    
    If send_cmd
        ControlClick, TMMPlayerSkinEngine1, %microplayer_wintitle%,, %send_cmd%, 1, NA
    Else If (A_ThisHotkey == "CapsLock & s")
        show_track_info(microplayer_wintitle, microplayer_classnn, show_info_interval)
    Else If (A_ThisHotkey == "^m")
    {
        ; KeyWait Control
        ; KeyWait m
        switch_to_normal_player(microplayer_wintitle, microplayer_classnn, mediamonkey_wintitle)
    }
    Else
        MsgBox, 48,, % "Unexpected hotkey: " A_ThisHotkey
    Return
^!0::       ; rate now playing song 0 stars         - these hotkeys are configured the same in normal window
^!1::       ; rate now playing song 1 star          - these hotkeys are configured the same in normal window
^!2::       ; rate now playing song 2 stars         - these hotkeys are configured the same in normal window
^!3::       ; rate now playing song 3 stars         - these hotkeys are configured the same in normal window
^!4::       ; rate now playing song 4 stars         - these hotkeys are configured the same in normal window
^!5::       ; rate now playing song 5 stars         - these hotkeys are configured the same in normal window
^b::        ; previous track     - hotkey is configured the same in normal window
^!Left::    ; previous track
^n::        ; next track         - hotkey is configured the same in normal window
^!Right::   ; next track
^p::        ; toggle play/pause  - hotkey is configured the same in normal window
    If InStr(A_ThisHotkey, "Left")
        send_cmd := "^b"    ; previous track
    Else If InStr(A_ThisHotkey, "Right")
        send_cmd := "^n"    ; next track
    Else If RegExMatch(A_ThisHotkey, "i)\^!\d")
    {
        KeyWait Control
        KeyWait Alt
        rating_num := SubStr(A_ThisHotkey, 0)
        rate_playing_song(microplayer_wintitle, microplayer_classnn, rating_num)
    }
    Else
        send_cmd := A_ThisHotkey
   
    ControlSend, TMMPlayerSkinEngine1, %send_cmd%, %microplayer_wintitle%
    Return

^+k:: list_hotkeys(,,25)

ExitApp

^+x::ExitApp

