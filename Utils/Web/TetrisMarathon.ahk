/* 
    Page zoom %110
*/
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
#SingleInstance Force
SetTitleMatchMode 3
Menu, Tray, Icon, C:\Users\Mark\Desktop\Misc\resources\32x32\Singles\TetrisFriends.png
Menu, Tray, Add, Start Tetris, START_TETRIS
g_TRAY_EXIT_ON_LEFTCLICK := True      ; see lib\utils.ahk
win_title = Tetris Marathon - Free online Tetris game at Tetris Friends - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
#If WinActive(win_title)

^a::
!a::
!Enter::    ; start new game from end of game page
{
    WinGetPos, x, y, w, h
    OutputDebug, % x ", " y ", " w ", " h
    BlockInput, On
    SendInput {Enter}
    Sleep 2500
    SendInput {Right 8}
    Sleep 3000
    Click 410, 654
    Sleep 3500
    SendInput {Control}
    MouseMove 9999, 0
    BlockInput, Off
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




START_TETRIS:
    Run, https://www.tetrisfriends.com/games/Marathon/game.php
