#SingleInstance Force
SetTitleMatchMode 2
OutputDebug, DBGVIEWCLEAR
Menu, Tray, Icon, C:\Users\Mark\Desktop\Misc\resources\32x32\Singles\GamesLol.net.png
win_title = Monopoly - Play Free Online Games - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
#If WinActive(win_title)
WinActivate, %win_title%
CoordMode Mouse, Screen

/* 	
    Window size & pos: x: 521	y: 2	w: 819	h: 968
    Monopoly zoom level: 116
*/

Space:: Click 830, 450         ; roll dice & end turn
+Space:: Click 760, 575        ; ok
LControl:: Click 800, 500      ; close

RAlt::  Click 870, 540         ; bid
+RAlt:: Click 870, 575         ; fold

+Up:: Click 1098, 708          ; trade
Up:: 
    MouseMove 705, 565            ; trade - cash transfer increase
    SendInput {LButton Down}
Down:: Click 705, 578          ; ; trade - cash transfer decrease