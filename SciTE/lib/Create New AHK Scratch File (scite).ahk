#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\constants.ahk
#Include lib\utils.ahk
#Include lib\scite.ahk
SetWorkingDir %AHK_ROOT_DIR%\MyScripts\SciTE

; check if 'new <n>.ahk' is open in SciTE and build the new scratch filename
oscite := create_scite_comobj()
scite_tabs := oscite.tabs
for file_name in scite_tabs.Array
{
    found_num := RegExReplace(file_name,"i).*new\s(\d+)\.ahk.*", "$1", replaced_count)
    If replaced_count and (found_num >= new_num)
    {    
        new_num := found_num + 1
        new_fname := A_WorkingDir "\new " new_num ".ahk"
    }
}
If (new_fname == "")
    new_fname := A_WorkingDir "\new 1.ahk"

WinMenuSelectItem, A,, File, New
Sleep 100
WinMenuSelectItem, A,, File, Save As
Sleep 300
SendInput %new_fname%
Sleep 500
SendInput !s    ; save 
Sleep 300
If WinActive("Confirm Save As ahk_class #32770 ahk_exe SciTE.exe")
    SendInput !y
ExitApp
