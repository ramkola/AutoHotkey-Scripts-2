/* 
   Finds the lowest unopened new <#>.ahk file to create as new scratch file. 
   (ie: new 1.ahk and new 3.ahk are open in Notepad++. This will create the new 2.ahk scratch file.)
   The assumption is that if the new <#>.ahk is not open in Notepad++ then it is available to be
   overwritten as new empty scratch file. New <#>.ahk files should be renamed if you want to save its
   contents before closing the file.
*/
#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\constants.ahk
#Include lib\npp.ahk
SetTitleMatchMode 2
SetWorkingDir %AHK_ROOT_DIR%

npp_wintitle = ahk_class Notepad++ ahk_exe notepad++.exe
saveas_wintitle = Save As ahk_class #32770 ahk_exe notepad++.exe
If !WinActive(npp_wintitle)
    Return

; check if 'new <n>.ahk' is open in Notepad++ and build the new scratch filename
tab_list := npp_get_open_tabs(False)
new_ahk_list := []
Sort tab_list 
Loop, Parse, tab_list, `n, `r
{
    If RegExMatch(A_LoopField,"i)^\Q" AHK_ROOT_DIR "\\Enew\s(\d+)\.ahk\*?$")
    {
        file_num := RegExReplace(A_LoopField, "i)^.*new\s(\d+)\.ahk\*?$", "$1",replaced_count) + 0
        new_ahk_list.push([file_num, A_LoopField])
    }
}
max_num:=0
For i, j In new_ahk_list
{
    max_num := i
    If (i <> j[1])
    {
        new_num := i 
        Break
    }
}
new_num := (new_num == "") ? max_num + 1 : new_num
new_fname := AHK_ROOT_DIR "\new " new_num ".ahk"
;
WinMenuSelectItem, A,, File, New
WinWaitActive, new %npp_wintitle%,, 2
WinMenuSelectItem, A,, File, Save As
WinWaitActive, %saveas_wintitle%,,2
Sleep 100
ControlSetText, Edit1, %new_fname%, %saveas_wintitle%
ControlClick, &Save, %saveas_wintitle%,, Left, 1, NA 
WinWaitActive, Confirm Save As ahk_class #32770 ahk_exe notepad++.exe,,2
If (ErrorLevel = 0)
    SendInput !y
ExitApp
