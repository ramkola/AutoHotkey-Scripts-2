#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\processes.ahk
#Include lib\strings.ahk
#Include lib\constants.ahk
#Include lib\utils.ahk
#NoEnv
; #NoTrayIcon
#SingleInstance Force
SendMode Input
SetWorkingDir %AHK_ROOT_DIR%
StringCaseSense Off
Menu, Tray, Icon, ..\resources\32x32\icons8-under-construction-32.png

If Not WinExist("ahk_class dbgviewClass ahk_exe Dbgview.exe")
{
    MsgBox, 48,, % "Start DbgView Win+G (#g) and try again...", 5
    ExitApp
}
saved_search_file := create_script_outfile_name(A_ScriptFullPath) 
FileRead, saved_search_expression, %saved_search_file% 
InputBox, search_term, Find Hotkey
    , Enter search term (RegEx notation):`r`n`r`nThese need to be escaped if used :`r`n`r`n`t`t \ . * ? + [ { | ( ) ^ $ 
    ,,,,,,,, %saved_search_expression%
If ErrorLevel
    ExitApp     ; user pressed cancel
FileDelete, %saved_search_file% 
FileAppend, %search_term%, %saved_search_file% 

; search_term:="vlc"
; need to escape search_term characters that need to be literal for regexmatch

in_file := "MyScripts\MyHotkeys.ahk" 
FileRead in_file_var1, %in_file% 
in_file := "MyScripts\MyHotStrings.ahk" 
FileRead in_file_var2, %in_file% 
in_file := "Misc\Shortcut Mapper List - Formatted.txt" 
FileRead in_file_var3, %in_file% 
in_file := "MyScripts\SciTE\lib\scite4ahk_hotkeys.ahk" 
FileRead in_file_var4, %in_file% 
in_file_var := in_file_var1 "`n" in_file_var2 "`n" in_file_var3 "`n" in_file_var4

result := ""
Loop, Parse, in_file_var, `n, `r 
{
    found_pos := RegExMatch(A_LoopField, "iO)^.*" search_term ".*$", match)
    If found_pos
        result .= match.value "`n"          
}
result := if (result == "" ) ? "*** NOT FOUND: " search_term : result

OutputDebug, DBGVIEWCLEAR
OutputDebug, % result
WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
; WinMaximize

ExitApp
