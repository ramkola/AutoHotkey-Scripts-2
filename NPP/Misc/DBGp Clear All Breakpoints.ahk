#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\strings.ahk
#SingleInstance Force
 
MouseGetPos, save_x, save_y

; docked Breakpoints window assumed
SetTitleMatchMode 2
SetTitleMatchMode Slow
classnn := "TDebugBreakpointsForm11"
ControlGet, is_visible, Visible,,%classnn%, A
if not is_visible
{
    MsgBox, 48,, % "DBGp is not running or not docked or `n`nBreakpoints panel not activated.", 10
    return
}
ControlFocus, %classnn%, ahk_class Notepad++, Breakpoints
ControlGetFocus, got_focus, A
if (got_focus <> classnn)
{
    MsgBox, 48,, % "Can't focus! " got_focus, 10
    Clipboard := got_focus
    ClipWait,,1
    Return
}
ControlGetPos, x, y, width, height, %classnn%, ahk_class Notepad++, Breakpoints
MouseMove, x + 100, y + 100
sleep 100
Click
SendInput {AppsKey}m
MouseMove, save_x, save_y
Sleep 100
Click
ExitApp
