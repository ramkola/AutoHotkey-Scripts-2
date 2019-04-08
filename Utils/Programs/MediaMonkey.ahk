#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\strings.ahk
#Include lib\utils.ahk
#NoTrayIcon
SetCapsLockState, AlwaysOff

show_info_interval = 7000
microplayer_classnn = TMMPlayerSkinEngine1
microplayer_wintitle = ahk_class Shell_TrayWnd ahk_exe Explorer.EXE
mediamonkey_wintitle = MediaMonkey ahk_class TFMainWindow ahk_exe MediaMonkey.exe

#If mediamonkey_toolbar_visible(microplayer_wintitle, microplayer_classnn)

If Not mediamonkey_toolbar_visible(microplayer_wintitle, microplayer_classnn)
{
    RegRead, exe_path, % "HKEY_CLASSES_ROOT\MediaMonkey\shell\open\command"
    exe_path := RegExReplace(exe_path,"i)^([a-z]:\\(\w+|\\)+.*\.exe).*","$1")
    Run, "%exe_path%"
}

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
    SetMouseDelay -1
    MouseGetPos, save_x, save_y
    ControlGetPos, x,, w, h, %p_classnn%, %p_wintitle% 
    WinGetPos,,y,,, %p_wintitle%
    MouseMove, x + (w/2) - 10, y+(h/2)
    Sleep p_interval
    MouseMove, save_x, save_y
    BlockInput Off
    Return
}

;******************************************************
; These keys control MediaMonkey in MicroPlayer Mode
;******************************************************
CapsLock & s::      ; Show current track info/art
^!Up::              ; MediaMonkey MicroPlayer Volume Up (shortcut in MediaMonkey main window)
^!+Up::             ; MediaMonkey MicroPlayer Volume Up
^!+WheelUp::        ; MediaMonkey MicroPlayer Volume Up
^!Down::            ; MediaMonkey MicroPlayer Volume Down (shortcut in MediaMonkey main window)
^!+Down::           ; MediaMonkey MicroPlayer Volume Down
^!+WheelDown::      ; MediaMonkey MicroPlayer Volume Down
    KeyWait CapsLock
    SetCapsLockState, AlwaysOff
    If InStr(A_ThisHotkey, "Up")
        send_cmd := "WheelUp"
    Else If InStr(A_ThisHotkey, "Down")
        send_cmd := "WheelDown"
    If (A_ThisHotkey <> "CapsLock & s")
        ControlClick, TMMPlayerSkinEngine1, %microplayer_wintitle%,, %send_cmd%, 1, NA
    Else
        show_track_info(microplayer_wintitle, microplayer_classnn, show_info_interval)
    Return

^b::        ; previous track
^!Left::    ; previous track
^n::        ; next track
^!Right::   ; next track
^o::        ; stop
^p::        ; toggle play/pause
    If InStr(A_ThisHotkey, "Left")
        send_cmd := "^b"    ; previous track
    Else If InStr(A_ThisHotkey, "Right")
        send_cmd := "^n"    ; next track
    Else If InStr(A_ThisHotkey, "Space")
        send_cmd := "^p"     ; toggle play/pause
    Else
        send_cmd := A_ThisHotkey
    ControlSend, TMMPlayerSkinEngine1, %A_ThisHotkey%, %microplayer_wintitle%
    Return

^+k:: list_hotkeys()

