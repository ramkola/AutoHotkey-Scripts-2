#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
g_TRAY_EXIT_ON_LEFTCLICK := True      ; set only 1 to true to enable, see lib\utils.ahk
SetTitleMatchMode 2
sleep_time := 0
While (sleep_time < 1)
{
    InputBox, sleep_time, Sleep Time, `r`nEnter number of SECONDS to wait before checking:,,,140,500,300,,,60
    If ErrorLevel
        ExitApp
}
sleep_time := sleep_time * 1000
Loop
{
    WinGetActiveTitle, active_window
    WinActivate, TextNow
    Sleep 1000  ; amount of time to view textnow window before returning to active_window
    Winactivate, %active_window%
    Sleep sleep_time
}

ExitApp

^+p::Pause
^+x::ExitApp

