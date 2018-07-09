#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\ahk_word_lists.ahk
#Include lib\strings.ahk
#Include lib\constants.ahk
#NoEnv
#NoTrayIcon
#SingleInstance Force
SetWorkingDir %AHK_MY_ROOT_DIR%

WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
OutputDebug, DBGVIEWCLEAR
WinActivate, ahk_class Notepad++ ahk_exe notepad++.exe

word_list := get_word_lists()
word_list_check := {}
countx := 0
Loop, Parse, word_list, `n, `r 
{
    If word_list_check.haskey(A_LoopField)
    {
        OutputDebug, % "Approx. Line Location: " Format("{:03}", A_Index + 25) "   Word: " A_LoopField 
        countx++
    }
    Else
        word_list_check[A_LoopField] := A_LoopField
}

OutputDebug, % "Total duplicate words found: " countx

ExitApp