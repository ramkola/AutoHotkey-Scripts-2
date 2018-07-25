#Include ..\AutoHotkey Scripts
#Include lib\constants.ahk
#NoEnv
#SingleInstance Force
SetWorkingDir %AHK_MY_ROOT_DIR%
double_click := True
explorer_win := "ahk_class CabinetWClass ahk_exe Explorer.EXE"
CoordMode, Mouse, Screen
Loop
{
    WinGetPos, wx, wy, ww, wh, %explorer_win%
    MouseGetPos, x , y
    mouse_in_target_area := (x >= wx) and (x <= (wx + ww)) and (y >= wy) and (y <= (wy + wh))

    If !WinActive(explorer_win) or !mouse_in_target_area
        Menu, Tray, Icon, ..\resources\32x32\Peripherals\Mouse White - 3-32.ico
    Else
    {
        Sleep, 1000		 ; how long to hover before click..
        MouseGetPos, a , b
        If double_click & (a = x) & (b = y)
        {
            Click, 2
            Menu, Tray, Icon, ..\resources\32x32\Peripherals\Mouse Red - 3-32.ico
        }
    }
    Sleep 10
}

^!z::double_click := !double_click

^!p::pause

; Ralt::OutputDebug, % wx "-" (wx+ww) " x " wy "-"(wy+wh) "`r`nMouse: " x "," y "`r`nIn target: " (mouse_in_target_area ? "Yes" : "No")



