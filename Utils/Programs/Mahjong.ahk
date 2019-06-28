#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
g_TRAY_RELOAD_ON_LEFTCLICK := True      ; set only 1 to true to enable, see lib\utils.ahk
SetTitleMatchMode 2
; SetMouseDelay, 0
SetDefaultMouseSpeed, 0
Menu, Tray, Icon, C:\Program Files\Microsoft Games\Mahjong\Mahjong.exe
OutputDebug, DBGVIEWCLEAR

SetTimer, EXIT_APP, 1000
; starts new game or activates current game 
Run, "C:\Program Files\Microsoft Games\Mahjong\Mahjong.exe"
WinWaitActive, Mahjong Titans ahk_class Mahjong Titans ahk_exe Mahjong.exe,,2
WinMaximize, Mahjong Titans ahk_class Mahjong Titans ahk_exe Mahjong.exe

Loop
{
    If Not WinExist("Mahjong Titans ahk_class Mahjong Titans ahk_exe Mahjong.exe")
        ExitApp
        
    If Not WinActive("Mahjong Titans ahk_class Mahjong Titans ahk_exe Mahjong.exe")
    {
        Sleep 10
        Continue
    }
    
    If Not mouse_get_pos("hover","Mahjong Titans")
    {
        Sleep 10
        Continue
    }
    ;
    MouseGetpos, x1, y1
    Sleep 300
    MouseGetpos, x2, y2
    If (x1 <> x2) or (y1 <> y2)
        Continue
    ;
    if (x1 = clicked_x) and (y1 = clicked_y)
        1=1
    else
    {
        Click
        clicked_x := x1
        clicked_y := y1
        OutputDebug, % "Clicked: " clicked_x "," clicked_y
    }
    Sleep 500
} 

ExitApp

EXIT_APP:
    If Not WinExist("Mahjong Titans ahk_class Mahjong Titans ahk_exe Mahjong.exe")
        ExitApp
    Return

^p::Pause
^+x::ExitApp
