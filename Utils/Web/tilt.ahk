#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
#SingleInstance Force
Menu, Tray, Icon, C:\Users\Mark\Desktop\Misc\resources\32x32\Singles\GamesLol.net.png
g_TRAY_EXIT_ON_LEFTCLICK := True      ; see lib\utils.ahk
SetTitleMatchMode 2
win_title = Tilt - Play Free Online Games - Google Chrome
#If WinActive(win_title)
WinActivate, %win_title%
CoordMode Mouse, Screen

Right::
Left::
Up::
Down::
+Right::
+Left::
+Up::
+Down::
Numpad0::
    increment1 = 10
    increment2 = 90
    MouseGetPos, x, y
    If (A_ThisHotkey = "Right")
        MouseMove, x + increment1, y
    Else If (A_ThisHotkey = "Left")
        MouseMove, x - increment1, y
    Else If (A_ThisHotkey = "Up")
        MouseMove, x, y - increment1
    Else If (A_ThisHotkey = "Down")
        MouseMove, x, y + increment1 
    Else If (A_ThisHotkey = "+Right")
        MouseMove, x + increment2, y
    Else If (A_ThisHotkey = "+Left")
        MouseMove, x - increment2, y
    Else If (A_ThisHotkey = "+Up")
        MouseMove, x, y - increment2
    Else If (A_ThisHotkey = "+Down")
        MouseMove, x, y + increment2 
    Else If (A_ThisHotkey = "Numpad0")  ; Start
    {
        MouseMove 925, 390
        Click
    }
    Else
        OutputDebug, % "Unexpected hotkey: " A_ThisHotkey
