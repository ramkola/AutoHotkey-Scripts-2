/* 
    This program is meant to be included by other scripts that want to able to control youtube playlists
    and videos in Chrome browser. Typically, you have a youtube window and another app window
    and you want control youtube from your app window without losing focus for too long from the app
    window. (See TetrisMarathon.ahk and Snooker147.ahk for examples.)

    Note: Hotkeys in calling program might conflict with the hotkeys here so make the necessary changes
          in the calling program but don't change the hotkeys here.
*/
m::          ; toggle mute
f::          ; toggle fullscreen
p::          ; skip to previous video
n::          ; skip to next video
Break::      ; toggle play / pause video
l::          ; seek forward 10 seconds
j::          ; seek backward 10 seconds
!+Right::    ; seek forward 5 seconds 
!+Left::     ; seek backwar 5 seconds 
!+Up::       ; volume up
!+Down::     ; volume down
{
    If Not WinExist(youtube_wintitle)
        Return
 
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
    
    If (A_ThisHotkey = "m")
        SendInput m
    Else If (A_ThisHotkey = "f")
        SendInput f
    Else If (A_ThisHotkey = "p")
        SendInput +p
    Else If (A_ThisHotkey = "n")
        SendInput +n
    Else If (A_ThisHotkey = "Break")
        SendInput {Space}
    Else If (A_ThisHotkey = "!+Right")
        SendInput {Right}
    Else If (A_ThisHotkey = "!+Left")
        SendInput {Left}
    Else If (A_ThisHotkey = "l")
        SendInput l
    Else If (A_ThisHotkey = "j")
        SendInput j
    Else If (A_ThisHotkey = "!+Up")
        SendInput {Up}
    Else If (A_ThisHotkey = "!+Down")
        SendInput {Down}
    Else
        OutputDebug, % "Unexpected hotkey: " A_ThisHotkey
    
    Sleep 10
    If (A_ThisHotkey != "f")
    WinActivate, ahk_id %active_hwnd%
    SetTitleMatchMode, %save_titlematchmode%
    Return
}