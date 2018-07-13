#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\strings.ahk
#Include lib\constants.ahk
#NoEnv
#NoTrayIcon
#SingleInstance Force
SetWorkingDir %AHK_MY_ROOT_DIR%

selection := select_and_copy_word()
OutputDebug, % selection
if selection
    Run, MyScripts\Utils\Maintain AHK Word List.ahk %selection%
else
    MsgBox, 48,, % "No word(s) selected.", 10

ExitApp

/*

word1,word2,word3

*/