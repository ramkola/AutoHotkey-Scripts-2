#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\constants.ahk
#Include lib\utils.ahk
#NoEnv
#SingleInstance Force
#NoTrayIcon
SetWorkingDir %AHK_MY_ROOT_DIR%

quote := chr(34)   ;  is ASCII: "
; separate search strings with a pipe "|". 
; This is going to be part of a RegEx search string.
; Usually, this would be the unique tag to extract
; the word next to the tag.
; start_string = <p><strong>|<td>|<p id=%quote% ; AutoHotkey Help file single page 
; Autohotkey Help file sidebar index listing commands only
start_string = <a href=%quote%https://autohotkey.com/docs/commands/.*data-content=%quote%   
; Autohotkey Help file sidebar index listing all
start_string = data-content=%quote%   ; Autohotkey Help file sidebar index listing

in_file := "C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts\Autohotkey Help HTML Source - Index Only.html"
SplitPath, in_file, fname
OutputDebug, % "fname: " fname

FileRead, x, %in_file% 
in_file_array := StrSplit(x, Chr(10))

write_string := ""
For i_index, line in in_file_array
{ 
    ; find the word after that comes after 1 of start_string options
    ;
    re_search = iO)(?<=%start_string%)[\+|#]*\w+
    pos := RegExMatch(line, re_search, match)
    if pos
        write_string .= match.value "`n"
}

; crop last carriage return
write_string := SubStr(write_string,1, - 1) 

; not all file extensions are 3 characters (.html, .jpeg, .mpeg, .saved_session, .whatever the_hell_you_want ...)
extension_period_pos := instr(fname, ".", -1)
fname_no_ext := Substr(fname,1, extension_period_pos)
out_file := AHK_MY_ROOT_DIR "\zzz-" fname_no_ext "txt" 
FileDelete, %out_file% 
FileAppend, %write_string%, %out_file% 
SendInput !fo 
Sleep 300 
SendInput %out_file%
Sleep 100
SendInput {Enter}

ExitApp
