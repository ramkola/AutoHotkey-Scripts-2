#SingleInstance Force
Menu, Tray, Icon, C:\Users\Mark\Desktop\Misc\resources\32x32\Singles\instagram.png
SetTitleMatchMode RegEx
win_title = ^.*?Instagram.*?Google Chrome$ ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
delay = 3000
slideshow := False
#If WinActive(win_title)

PgUp::
PgDn::
^s::
    If (A_ThisHotkey = "^s")
        slideshow := !slideshow
    Else If (A_ThisHotkey = "PgUp")
    {
        delay += 50
        slideshow := True
    }
    Else If (A_ThisHotkey = "PgDn")
    {
        delay -= 50
        slideshow := True
    }
    OutputDebug, % "slideshow: " slideshow " - delay: " delay

    While slideshow
    {
        SendInput {Right}
        Sleep %delay%
    }
    Return


^WheelUp::SendInput {PgUp}
^WheelDown::SendInput {PgDn}

WheelUp::SendInput {Right}
WheelDown::SendInput {Left}
MButton::SendInput {Escape}

Up::
Down::
Space::
    saved_mouse_speed := A_DefaultMouseSpeed
    saved_mouse_delay := A_MouseDelay
    SetDefaultMouseSpeed, 0
    SetMouseDelay, -1
    WinActivate, %win_title%
    WinWaitActive, %win_title%
    CoordMode, Mouse, Window
    WinGetPos, win_x, win_y, win_w, win_h, A
    MouseMove win_w/2, win_h/2
    Click
    MouseMove win_x + 10,0
    SetMouseDelay, %saved_mouse_delay%
    SetDefaultMouseSpeed, %saved_mouse_speed%
    Return

^+x::ExitApp

