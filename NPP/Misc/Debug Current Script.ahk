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
RunWait, C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts\MyScripts\NPP\Misc\DBGp Reposition Breakponts Panel.ahk
    
; debug current script
WinGetTitle, current_script_wintitle, A
pos := Instr(current_script_wintitle, " - Notepad++") - 1
Sleep 100
debug_scriptnmame := SubStr(current_script_wintitle, 1, pos)
Run %A_AHKPath% /Debug "%debug_scriptnmame%"

ExitApp