#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\strings.ahk
SetTitleMatchMode 2
npp_wintitle := ".ahk - Notepad++ ahk_class Notepad++ ahk_exe notepad++.exe"
dbgview_wintitle := "ahk_class dbgviewClass ahk_exe Dbgview.exe"
dialog_wintitle := "ahk_class #32770 ahk_exe AutoHotkey.exe"

dialog_flag := WinExist(dialog_wintitle)
If dialog_flag
    ControlGetText, text_line, Static1, %dialog_wintitle%
Else
    ControlGet, text_line, List, Selected, SysListView321, %dbgview_wintitle%

; note controlget from SysListView321 returns the selected line multiple times. 
; the regexreplace also handles this retrieving the line# once.
If Instr(text_line, "Line#") and Not Instr(text_line, "-->")
    ; either an OutputDebug or MsgBox message with my own custom Line# error message
    line_num := RegExReplace(text_line, "si)^.*Line#(\d+).*$", "$1", replaced_count)
Else If Instr(text_line, "-->")
{
    Loop, Parse, text_line, `n, `r
    {
        ; AutoHotkey syntax checker error has an arrow as a unique feature pointing to the line number in error. 
        line_num := RegExReplace(A_LoopField, "^.*--->\s+(\d+):\s.*$", "$1", replaced_count) + 0 ; +0 gets rid of leading zeros
        If replaced_count
            Break
    }
}
Else If Instr(text_line, "Error at line")
    ; AutoHotkey syntax checker error has an arrow as a unique feature pointing to the line number in error. 
    line_num := RegExReplace(text_line, "m).*Error at line\s+(\d+)\..*", "$1", replaced_count)

If replaced_count
{
    goto_line(line_num)
    If dialog_flag
        WinActivate, %dialog_wintitle%
}
Else
    MsgBox, 48,, % "An error message line number was not found in selected Dbgview line or dialog box."
ExitApp

