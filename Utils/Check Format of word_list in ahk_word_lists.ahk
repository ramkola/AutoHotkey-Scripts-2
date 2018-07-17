#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\ahk_word_lists.ahk
#NoEnv
; #NoTrayIcon
#SingleInstance Force
SetWorkingDir %AHK_MY_ROOT_DIR%
Menu, Tray, Icon, ..\resources\32x32\icons8-under-construction-32.png

WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
OutputDebug, DBGVIEWCLEAR
WinActivate, ahk_class Notepad++ ahk_exe notepad++.exe


in_file := "lib\ahk_word_lists.ahk"
FileRead, in_file_var, %in_file% 
countx := 0
Loop, Parse, in_file_var, `n, `r 
{
    pos := RegExMatch(A_LoopField,"O)(^|#)\w+$", match) 
    if (pos = 0)
    {
        OutputDebug, % pos "  " A_LoopField
        countx++
    }
}

OutputDebug, % "countx: " countx
