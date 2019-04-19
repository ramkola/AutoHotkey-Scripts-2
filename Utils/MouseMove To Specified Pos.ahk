#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk

OutputDebug, DBGVIEWCLEAR

saved_coordmode  := A_CoordModeMouse
saved_mousedelay := A_MouseDelay
CoordMode, Mouse, Screen

Gui, Font, S12
Gui, Add, Text, x5 y3 , x:
Gui, Font, S10
Gui, Add, Edit, vx gx hwndx_hwnd xp+15 w40, 0
Gui, Font, S12
Gui, Add, Text, xp+55 yp, y:
Gui, Font, S10
Gui, Add, Edit, vy gy hwndy_hwnd w40 xp+15 yp, 0
Gui, Add, Listbox, vlb glb hwndlb_hwnd x5 w75 h35, Screen|Window|Client
ControlGetPos, x, y, w, h,, ahk_id %y_hwnd% 
go_w := w
go_x := x + w - go_w - 2
Gui, Add, Button, vgo ggo hwndgo_hwnd Default x%go_x% yp-1 w%go_w% hp+2, &Go

; WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe

Gui, -Sysmenu +AlwaysOnTop
gui_w := x + w + 5 
gui_x := A_ScreenWidth - gui_w -100 
Gui, Show,x%gui_x% y0 w%gui_w%, MouseX MoveY

Return

RButton::
    MouseGetPos,,,chosen_hwnd
    WinGetActiveTitle, chosen_title
    Sleep 1000
    ttip("`r`n`r`n     (" chosen_hwnd ") " chosen_title "   `r`n`r`n ", 2500)
    WinActivate, ahk_id %gui_hwnd%
    Return

    
GuiEscape:
GuiClose:
    SetMouseDelay %saved_mousedelay%
    CoordMode, Mouse, %saved_coordmode%
    ExitApp

GuiSize:
    WinGet, gui_hwnd, ID, MouseX MoveY
    If (chosen_hwnd = 0) or (chosen_hwnd == "")
        chosen_hwnd := gui_hwnd
    Return
go:
    Loop, 3
        Tooltip,,,, %A_Index%
    WinActivate, ahk_id %chosen_hwnd%
    WinWaitActive, ahk_id %chosen_hwnd%
    WinGetActiveTitle, chosen_title
    ttip("`r`nActive Window: `r`n`r`n" chosen_title " `r`n ", 2000,500,500)

    Gui, Submit, NoHide
    CoordMode, Mouse, Screen
    SetMouseDelay -1
    MouseMove 0, 0
    SetMouseDelay 150
    CoordMode, Mouse, %lb%
    MouseMove, x, y
    ttip(" " x ", " y " - " A_CoordModeMouse, 1500)
    
    CoordMode, Tooltip, Screen
    Tooltip, % " " x ", " y " - " A_CoordModeTooltip, x, y, 1
    CoordMode, Tooltip, Window
    Tooltip, % " " x ", " y " - " A_CoordModeTooltip, x, y, 2
    CoordMode, Tooltip, Client
    Tooltip, % " " x ", " y " - " A_CoordModeTooltip, x, y, 3
    WinActivate, ahk_id %gui_hwnd%
    Return

lb:
    OutputDebug, % "A_GuiEvent: " A_GuiEvent
Return
    
x:
Return

y:
Return

