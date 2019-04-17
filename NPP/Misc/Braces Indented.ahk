#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\strings.ahk
indentspaces = 0
tab_spaces := "    "    ; 4 spaces
indent := get_statusbar_info("curcol") - 1
OutputDebug, % "indent: " indent
Loop, %indent%
    indent_spaces .= " "
brace1 := indent_spaces "{"
brace2 := indent_spaces "}"
SendInput, !{End}{Enter}
SendRaw, %brace1%
SendInput, {Enter 2}!{Home}
SendRaw, %brace2%
SendInput, {Up}%indent_spaces%%tab_spaces%
ExitApp
