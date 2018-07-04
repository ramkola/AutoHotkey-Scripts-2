#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\strings.ahk
#SingleInstance Force
 
MouseGetPos, save_x, save_y

; docked watches window assumed
SetTitleMatchMode 2
SetTitleMatchMode Slow
classnn := "TDebugWatchFrom1"
ControlGet, is_visible, Visible,,%classnn%, A
if not is_visible
{
    MsgBox, 48,, % "DBGp is not running or not docked or `n`nWatches panel not activated.", 10
    return
}
ControlFocus, %classnn%, ahk_class Notepad++, Watches
ControlGetFocus, got_focus, A
if (got_focus <> classnn)
{
    MsgBox, 48,, % "Can't focus! " got_focus, 10
    Clipboard := got_focus
    ClipWait,,1
    Return
}
ControlGetPos, x, y, width, height, %classnn%, ahk_class Notepad++, Watches
MouseMove, x + 100, y + 200
sleep 100
Click
loop 50
    SendInput {AppsKey}d{Down}

MouseMove, save_x, save_y
Sleep 100
Click    
ExitApp
