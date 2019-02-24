#SingleInstance Force
#NoTrayIcon
Loop
{
    MouseGetPos, x, y, out_hwnd, out_class

    WinGetTitle, i_title, ahk_id %out_hwnd%
    WinGetClass, i_class, ahk_id %out_hwnd%
    WinGet, i_procname, ProcessName, ahk_id %out_hwnd%
    i_class := "ahk_class " . i_class
    i_procname := "ahk_exe " . i_procname
    active_win := i_title "`r`n" i_class " " i_procname
    WinGet, control_list, ControlList, ahk_id %out_hwnd%
    sort control_list
    visible_control_list := ""
    Loop, parse, control_list, "`r`n"
    {
        ControlGet, is_visible, Visible,, %A_LoopField%, A
        if is_visible
            visible_control_list .= A_LoopField "`r`n"
    }

    ; active_win := If StrLen(active_win) <= 60 ? active_win : SubStr(active_win,1,3) "..." Substr(active_win,60)
    tooltip_text := "" 
        . "RButton=short info | Ctrl+RButton=long info | Escape=Exit" 
        . "`r`n`r`n" active_win
        . "`r`nahk_id " out_hwnd 
        . "`r`nControl: " out_class
        . "`r`n`r`nMouse - CoordMode: " A_CoordModeMouse " | x, y: " x ", " y

    tooltip_text_full := tooltip_text  "`r`nControl list: `r`n" visible_control_list

    tooltip, %tooltip_text% , x + 20, y + 20  
    Sleep 1000
}

ExitApp     ; see escape hotkey

RButton:: Clipboard := RegExReplace(tooltip_text, "i)RButton.*?Escape=Exit")
        
Control & RButton:: 
    Clipboard := RegExReplace(tooltip_text_full,"i)RButton.*?Escape=Exit")
    tooltip, %tooltip_text_full% , x + 20, y + 20 
    While GetKeyState("RButton","P" )
        Sleep 10
    Return

Escape::ExitApp

