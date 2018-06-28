; This snippet is not in MyHotkeys.ahk so that it can be set up as toolbar button from the Notepad++ Run menu. 
; See plugin: customize toolbar buttons help for more details.
;^!+F5::   ; Debug current script being edited with DBGp debugger
    SendInput ^s    ; save the file before running it (my preference, can also run without saving.)
    Sleep 100
    WinMenuSelectItem, A,, Plugins, DBGp, Debugger 
    Sleep 100
    WinGetTitle, current_script_wintitle, A
    pos := Instr(current_script_wintitle, " - Notepad++") - 1
    Sleep 100
    debug_scriptnmame := SubStr(current_script_wintitle, 1, pos)
    Run %A_AHKPath% /Debug "%debug_scriptnmame%"
    Return