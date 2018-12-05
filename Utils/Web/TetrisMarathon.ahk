#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
#SingleInstance Force
SetTitleMatchMode 3
Menu, Tray, Icon, C:\Users\Mark\Desktop\Misc\resources\32x32\Singles\TetrisFriends.png
g_TRAY_EXIT_ON_LEFTCLICK := True      ; see lib\utils.ahk
win_title = Tetris Marathon - Free online Tetris game at Tetris Friends - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
#If WinActive(win_title)

!Enter:: 
{
    BlockInput, On
    SendInput {Enter}
    Sleep 4000
    SendInput {Right 8}
    Sleep 3000
    Click 410, 650
    Sleep 3500
    SendInput {Control}
    BlockInput, Off
    Return
}
