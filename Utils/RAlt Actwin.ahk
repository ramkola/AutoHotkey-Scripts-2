#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
#SingleInstance Force

RAlt::
    WinGetTitle, i_title, A
    WinGetClass, i_class, A
    WinGet, i_hwnd, ID, A
    WinGet, i_procname, ProcessName, A
    i_class := "ahk_class " . i_class
    i_hwnd := "ahk_id " . i_hwnd
    i_procname := "ahk_exe " . i_procname
    active_win := i_title A_Space i_class A_Space i_procname
    WinActivate, %active_win%
    ControlGetFocus, got_focus, A
    OutputDebug, % active_win "`n" got_focus
    WinGet, control_list, ControlList, A
    sort control_list
    Loop, parse, control_list, "`r`n"
    {
        ControlGet, is_visible, Visible,, %A_LoopField%, A
        if is_visible
            OutputDebug % A_LoopField
    }
    
    Return