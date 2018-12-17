/* 
    Page zoom %110
*/
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
#SingleInstance Force
SetTitleMatchMode RegEx
Menu, Tray, Icon, C:\Users\Mark\Desktop\Misc\resources\32x32\Singles\TetrisFriends.png
Menu, Tray, Add, Start Tetris, START_TETRIS
; g_TRAY_EXIT_ON_LEFTCLICK := True      ; see lib\utils.ahk
g_TRAY_RELOAD_ON_LEFTCLICK := True      ; see lib\utils.ahk

WinActivate, ^.*YouTube - Google Chrome$ ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe

win_title = ^Tetris Marathon.*Google Chrome$ ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
#If WinActive(win_title)
WinActivate, %win_title%
#Include %A_ScriptDir%\Youtube Keys.ahk
Return

START_TETRIS:
    Run, https://www.tetrisfriends.com/games/Marathon/game.php

^a::
!a::
!Enter::    ; start new game from end of game page
{
    BlockInput, On
    SendInput {Enter}
    Sleep 5000
    SendInput {Control Up}
    SendInput {Escape}
    SendInput {Right 8}
    Sleep 3000
    Click 410, 657
    Sleep 3500
    SendInput {Control}
    MouseMove 9999, 0
    BlockInput, Off
    Return
}

1::
{
    BlockInput, On
    SendInput {Right 8}
    Sleep 3000
    Click 410, 657
    BlockInput, Off
    Return
}

2::
{
    Click 410, 657
    Return
}

s::     ; show stats of last game played from end of game page
{
    CoordMode, Mouse, Screen
    BlockInput, On
    SendInput {Left 4}
    Sleep 10
    Click, 910, 300     ; stats tab
    Sleep 1000
    SendInput {Right 4}
    MouseMove 9999, 0   ; move mouse off screen (hide)
    BlockInput, Off
    Return   
}

r::     ; resume play
{
    CoordMode, Mouse, Screen
    Click, 1140, 720
    MouseMove 9999, 0
    Return   
}

#Include %A_ScriptDir%\Kodi Shortcuts.ahk
g_kodi_shortcuts_param := "Tetris"

