#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\strings.ahk
saved_clipboard := ClipboardAll
Clipboard := check_selection_copy(,,1)
ClipWait,2
If ErrorLevel or (Clipboard == "")
{
    MsgBox, 48,, % "Invalid selection....`r`nYou need to select a word."
    Goto MAKE_DEBUG_EXIT
}
clip_word := Clipboard
SendInput, "%clip_word%: " %clip_word%

MAKE_DEBUG_EXIT:
Clipboard := saved_clipboard
ExitApp
