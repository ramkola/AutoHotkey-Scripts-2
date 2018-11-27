#SingleInstance Force
SetTitleMatchMode 2
Menu, Tray, Icon, C:\Users\Mark\Desktop\Misc\resources\32x32\Singles\TetrisFriends.png
Menu, Tray, Icon, C:\Users\Mark\Desktop\Misc\resources\16x16\TetrisFriends.ico
win_title = Tetris Marathon - Free online Tetris game at Tetris Friends - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
#If WinActive(win_title)
WinActivate, %win_title%

!Enter:: 
{
        MouseMove 100, 100
        SendInput {Enter}
        Sleep 5000
        ; Loop 8
        SendInput {Right 8}
        Sleep 3000
        Click 365, 660
        Sleep 3500
        SendInput {Control}
        Return
}
