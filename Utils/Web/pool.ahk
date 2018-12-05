#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
#SingleInstance Force
Menu, Tray, Icon, C:\Users\Mark\Desktop\Misc\resources\32x32\Singles\GamesLol.net.png
g_TRAY_EXIT_ON_LEFTCLICK := True      ; see lib\utils.ahk
SetTitleMatchMode RegEx
win_title = Billiards Master Pro - Play Free Online Games - Google Chrome
#If WinActive(win_title)
WinActivate, ^.*YouTube - Google Chrome$ ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
WinActivate, %win_title%
CoordMode Mouse, Screen
; 590,0,700,991
; 608,0,679,991
; WinMove, %win_title%,, 608, 0, 672, 982 
WinMove,608, 0
; WinMaximize, %win_title%
WinMaximize, win_title
; Winset, Region, 608-0 W672 H982, %win_title% 
; WinSet, Transparent, 255, %win_title% 
elements_erased := True
Return

s::    ; play again
    If elements_erased
        Click 930, 370
    Else
        Click 930, 325
    save_window()
    Return

Space::
r::    ; restart game 
    If elements_erased
        Click 630, 205
    Else
        Click 610, 155
    If elements_erased
        Click 930, 340
    Else
        Click 930, 295
    save_window()
    Return

save_window()
{
    WinGetPos, x, y, w, h, A
    OutputDebug, % x "," y "," w "," h
    ; WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
    Return
}