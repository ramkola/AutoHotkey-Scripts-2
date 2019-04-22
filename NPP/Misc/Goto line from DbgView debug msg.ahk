#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\strings.ahk
#Include lib\npp.ahk
SetTitleMatchMode 2
npp_wintitle := ".ahk - Notepad++ ahk_class Notepad++ ahk_exe notepad++.exe"
WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
saved_clipboard := ClipboardAll
Clipboard := ""
SendInput ^c
ClipWait, 1
line_num := RegExReplace(Clipboard, "si)^.*Line#(\d+).*$", "$1", replaced_count)
If replaced_count
    goto_line(line_num, npp_wintitle)
Else
    MsgBox, 48,, % "Line# not found in selected Dbgview line.", 2
Clipboard := saved_clipboard
ExitApp
    