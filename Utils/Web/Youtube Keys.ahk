/* 
    This program is meant to be included by other scripts that want to able to control youtube playlists
    and videos in Chrome browser. Typically, you have a youtube window and another app window
    and you want control youtube from your app window without losing focus for too long from the app
    window. (See TetrisMarathon.ahk and Snooker147.ahk for examples.)

    Note: Hotkeys in calling program might conflict with the hotkeys here so make the necessary changes
          in the calling program but don't change the hotkeys here.
*/
#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\strings.ahk
#Include lib\utils.ahk
#NoTrayIcon
ttip(A_ScriptName " is running.", 1500)
Return 

CapsLock & m::            ; toggle mute
CapsLock & f::            ; toggle fullscreen
CapsLock & p::            ; skip to previous video
CapsLock & n::            ; skip to next video 
CapsLock & l::            ; seek forward 10 seconds
CapsLock & j::            ; seek backward 10 seconds
CapsLock & k::            ; toggle play / pause video 
CapsLock & r::            ; restore window from fullscreen video
CapsLock & Right::        ; seek forward 5 seconds 
CapsLock & Left::         ; seek backwar 5 seconds 
CapsLock & Up::           ; volume up
CapsLock & Down::         ; volume down
CapsLock & Break::        ; switch to youtube window and setfocus on video player
{
    SetCapsLockState, AlwaysOff
    save_titlematchmode := A_TitleMatchMode
    SetTitleMatchMode, RegEx
    tetris_wintitle := "^.*Tetris.* - Google Chrome$ ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe"
    youtube_wintitle := "^.*YouTube - Google Chrome$ ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe"
    watchseries_wintitle := "^.*Watch.*Watchseries.*Google Chrome$ ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe"
    If Not WinExist(youtube_wintitle) and Not WinExist(watchseries_wintitle)
    {
        OutputDebug, % "No window found"
        Return
    }
    ;
    ; If WinActive(tetris_wintitle)
        ; SendInput {Control}     ; toggle play/pause

    ;
    WinGet, active_hwnd, ID, A  ; save current active window to return to later
    WinActivate     ; use last found window from WinExist statement above
    WinWaitActive   ;
    If ErrorLevel
    {   
        OutputDebug, % A_ScriptName " could not activate window." 
        Return
    }

    WinGetActiveTitle, active_title                 ; should be last found window from WinExist statement above
    OutputDebug, % "active_title: " active_title

    If (A_ThisHotkey = "CapsLock & k")
        Click, 400, 300
    Else If (A_ThisHotkey = "CapsLock & f")
        SendInput f
    Else If (A_ThisHotkey = "CapsLock & m")
        SendInput m
    Else If (A_ThisHotkey = "CapsLock & p")
        SendInput +p
    Else If (A_ThisHotkey = "CapsLock & n")
        SendInput +n
    Else If (A_ThisHotkey = "CapsLock & Right")
        SendInput {Right}
    Else If (A_ThisHotkey = "CapsLock & Left")
        SendInput {Left}
    Else If (A_ThisHotkey = "CapsLock & l")
        SendInput l
    Else If (A_ThisHotkey = "CapsLock & j")
        SendInput j
    Else If (A_ThisHotkey = "CapsLock & r")
    {
        SendInput f     ; exit fullscreen video
        WinRestore
    }
    Else If (A_ThisHotkey = "CapsLock & Up")
        SendInput {Up}
    Else If (A_ThisHotkey = "CapsLock & Down")
        SendInput {Down}
    Else If (A_ThisHotkey = "CapsLock & Break")
    {
        Click, 400, 300     ; first click video to setfocus on player so that player hotkeys work.
        SendInput k         ; Assumes video was playing. Click paused the video, this starts playing again.
    }
    Else
        OutputDebug, % "Unexpected hotkey: " A_ThisHotkey
    
    Sleep 10
    ; If (A_ThisHotkey = "CapsLock & p") Or (A_ThisHotkey = "CapsLock & n") Or (A_ThisHotkey = "n")
    ; {
        ; WinGetTitle, current_vid_wintitle, A
        ; current_vid_wintitle := RegExReplace(current_vid_wintitle, "i)^(.*) - YouTube - Google Chrome$", "$1")
        ; MsgBox, 48,, % current_vid_wintitle, 3
    ; }
    ;
    If (A_ThisHotkey != "CapsLock & f") And (A_ThisHotkey != "CapsLock & Break")  
        WinActivate, ahk_id %active_hwnd%
    ;
    ; If WinActive(tetris_wintitle)
        ; SendInput {Control}     ; toggle play/pause
    ;
    SetTitleMatchMode, %save_titlematchmode%
    MouseMove, 9999, 200
    Return
}
#If WinActive(youtube_wintitle)
^+k:: list_hotkeys()
