#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\constants.ahk
#Include lib\utils.ahk
SetWorkingDir %AHK_ROOT_DIR%

OutputDebug, DBGVIEWCLEAR
; check if 'new <n>.ahk' is open in Notepad++ and build the new scratch filename
found_num := 0
new_num := 1
new_fname := ""
WinGetActiveTitle, start_fname
start_fname := RegExReplace(start_fname,"^.*?(\w.*\.ahk) - Notepad\+\+", "$1")
current_fname := start_fname
Loop
{
    found_num := RegExReplace(current_fname,"i).*new\s(\d+)\.ahk.*", "$1", replaced_count)
    If replaced_count and (found_num >= new_num)
    {    
        new_num := found_num + 1
        new_fname := AHK_ROOT_DIR "\new " new_num ".ahk"
    }
    SendInput !{Right}
    Sleep 100
    WinGetActiveTitle, current_fname
    current_fname := RegExReplace(current_fname,"^.*?(\w.*\.ahk) - Notepad\+\+", "$1")
} Until (current_fname = start_fname)
If (new_fname == "")
    ; No AHK scratch files are open in Notepad++
    new_fname := AHK_ROOT_DIR "\new 1.ahk"

;
WinMenuSelectItem, A,, File, New
Sleep 100
WinMenuSelectItem, A,, File, Save As
Sleep 300
SendInput %new_fname%
Sleep 500
SendInput !s    ; save 
Sleep 300
If WinActive("Confirm Save As ahk_class #32770 ahk_exe notepad++.exe")
    SendInput !y
ExitApp
