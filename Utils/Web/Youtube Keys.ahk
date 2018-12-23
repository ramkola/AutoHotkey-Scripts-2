/* 
    This program is meant to be included by other scripts that want to able to control youtube playlists
    and videos in Chrome browser. Typically, you have a youtube window and another app window
    and you want control youtube from your app window without losing focus for too long from the app
    window. (See TetrisMarathon.ahk and Snooker147.ahk for examples.)

    Note: Hotkeys in calling program might conflict with the hotkeys here so make the necessary changes
          in the calling program but don't change the hotkeys here.
*/
CapsLock & Break::        ; toggle play / pause video. Also use to setfocus on video player so that hotkeys work properly.
CapsLock & m::            ; toggle mute
CapsLock & f::            ; toggle fullscreen
CapsLock & p::            ; skip to previous video
n::                       ; skip to next video 
CapsLock & n::            
CapsLock & l::            ; seek forward 10 seconds
CapsLock & j::            ; seek backward 10 seconds
CapsLock & Right::        ; seek forward 5 seconds 
CapsLock & Left::         ; seek backwar 5 seconds 
CapsLock & Up::           ; volume up
CapsLock & Down::         ; volume down
{
    If Not WinExist(youtube_wintitle)
        Return
    SetCapsLockState, AlwaysOff
    save_titlematchmode := A_TitleMatchMode
    SetTitleMatchMode, RegEx
    youtube_wintitle := "^.*YouTube - Google Chrome$ ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe"
    WinGet, active_hwnd, ID, A
    WinActivate, %youtube_wintitle%
    WinWaitActive, %youtube_wintitle%,,2
    If ErrorLevel
    {   
        OutputDebug, % A_ScriptName " could not activate youtube window." 
        Return
    }

    If (A_ThisHotkey = "CapsLock & Break")
        Click, 400, 300
    Else If (A_ThisHotkey = "CapsLock & m")
        SendInput m
    Else If (A_ThisHotkey = "CapsLock & f")
        SendInput f
    Else If (A_ThisHotkey = "CapsLock & p")
        SendInput +p
    Else If (A_ThisHotkey = "CapsLock & n") Or (A_ThisHotkey = "n")
        SendInput +n
    Else If (A_ThisHotkey = "CapsLock & Right")
        SendInput {Right}
    Else If (A_ThisHotkey = "CapsLock & Left")
        SendInput {Left}
    Else If (A_ThisHotkey = "CapsLock & l")
        SendInput l
    Else If (A_ThisHotkey = "CapsLock & j")
        SendInput j
    Else If (A_ThisHotkey = "CapsLock & Up")
        SendInput {Up}
    Else If (A_ThisHotkey = "CapsLock & Down")
        SendInput {Down}
    Else
        OutputDebug, % "Unexpected hotkey: " A_ThisHotkey
    
    Sleep 10
    If (A_ThisHotkey != "CapsLock & f")
        WinActivate, ahk_id %active_hwnd%
    SetTitleMatchMode, %save_titlematchmode%
    MouseMove, 9999, 200
    ; Send {Alt Up}           ; just in case, sometimes alt would stay down
    Return
}