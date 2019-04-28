#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\constants.ahk
#Include lib\utils.ahk
#Include lib\strings.ahk
#Include lib\npp.ahk
SetTitleMatchMode 2
SetWorkingDir %AHK_ROOT_DIR%

npp_wintitle = ahk_class Notepad++ ahk_exe notepad++.exe
saveas_wintitle = Save As ahk_class #32770 ahk_exe notepad++.exe
If !WinActive(npp_wintitle)
    Return

; check if 'new <n>.ahk' is open in Notepad++ and build the new scratch filename
tab_list := npp_get_open_tabs(True)
Sort tab_list, r     
Loop, Parse, tab_list, `n, `r
{
    highest_num := RegExReplace(A_LoopField, "i)^.*new\s(\d+)\.ahk\*?$", "$1",replaced_count)
    If replaced_count
        break   ; highest new <n>.ahk file is the first in the list that has been sorted reversed 
}
new_num := (highest_num == "") ? 1 : highest_num + 1
new_fname := AHK_ROOT_DIR "\new " new_num ".ahk"
;
WinMenuSelectItem, A,, File, New
WinWaitActive, new %npp_wintitle%,, 2
WinMenuSelectItem, A,, File, Save As
WinWaitActive, %saveas_wintitle%,,2
ControlSetText, Edit1, %new_fname%, %saveas_wintitle%
ControlClick, &Save, %saveas_wintitle%,, Left, 1, NA 
WinWaitActive, Confirm Save As ahk_class #32770 ahk_exe notepad++.exe,,2
If (ErrorLevel = 0)
    SendInput !y
ExitApp
