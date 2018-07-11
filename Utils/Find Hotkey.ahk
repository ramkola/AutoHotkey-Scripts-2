#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\processes.ahk
#Include lib\strings.ahk
#Include lib\constants.ahk
#Include lib\utils.ahk
#NoEnv
; #NoTrayIcon
#SingleInstance Force
SendMode Input
SetWorkingDir %AHK_MY_ROOT_DIR%
StringCaseSense Off
Menu, Tray, Icon, resources\32x32\icons8-under-construction-32.png

WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
OutputDebug, DBGVIEWCLEAR
WinActivate, ahk_class Notepad++ ahk_exe notepad++.exe

InputBox, search_term, Find Hotkey, Enter search term: 
If ErrorLevel
    ExitApp
; search_term:="vlc"
; need to escape search_term characters that need to be literal for regexmatch

in_file := "MyScripts\MyHotkeys.ahk" 
FileRead in_file_var1, %in_file% 
in_file := "MyScripts\MyHotStrings.ahk" 
FileRead in_file_var2, %in_file% 
in_file := "Misc\Shortcut Mapper List - Formatted.txt" 
FileRead in_file_var3, %in_file% 

in_file_var := in_file_var1 "`n" in_file_var2 "`n" in_file_var3

result := ""
Loop, Parse, in_file_var, `n, `r 
{
    found_pos := RegExMatch(A_LoopField, "iO)^.*" search_term ".*$", match)
    If found_pos
        result .= match.value "`n"          
}

OutputDebug, % result

ExitApp