; This snippet is not in MyHotkeys.ahk so that it can be set up as toolbar button from the Notepad++ Run menu. 
; See plugin: customize toolbar buttons help for more details.
;^!+F5::   ; Debug current script being edited with DBGp debugger

; stop debugger if running from previous debugging session.
WinMenuSelectItem, A,, Plugins, DBGp, Stop
SendInput ^s    ; save the file before running it (my preference, can also run without saving.)
Sleep 100

; start debugger
WinMenuSelectItem, A,, Plugins, DBGp, Debugger 
Sleep 100

; if window is maximized on monitor 1 - move Breakpoints panel to stacked below watches panel.
ControlGetPos, x, y, width, height, TDebugBreakpointsForm11, ahk_class Notepad++, Breakpoints
xpos := (x >= 1660) and (x <= 1680)
ypos := (y >= 140) and (y <= 150)
if xpos and ypos
{
    Click, 1800, 130 Left, Down
    Click, 1800, 135, 0
    Click, -360, 715
}
    
; debug current script
WinGetTitle, current_script_wintitle, A
pos := Instr(current_script_wintitle, " - Notepad++") - 1
Sleep 100
debug_scriptnmame := SubStr(current_script_wintitle, 1, pos)
Run %A_AHKPath% /Debug "%debug_scriptnmame%"

ExitApp