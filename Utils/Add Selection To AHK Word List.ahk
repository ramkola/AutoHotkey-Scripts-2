#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\strings.ahk
#Include lib\constants.ahk
#NoEnv
#NoTrayIcon
#SingleInstance Force
SetWorkingDir %AHK_ROOT_DIR%


; Run, MyScripts\Utils\Maintain AHK Word List.ahk "C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts\Misc\autohotkey.xml.stripped.txt"
; ExitApp

selection := select_and_copy_word()
if selection
    Run, MyScripts\Utils\Maintain AHK Word List.ahk %selection%
else
    MsgBox, 48,, % "No word(s) selected.", 10

ExitApp

/*
Force
zword5,zword6,zword7
And
*/