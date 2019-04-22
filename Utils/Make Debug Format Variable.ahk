#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\strings.ahk
saved_clipboard := ClipboardAll
Clipboard := select_and_copy_word()
ClipWait,2
If ErrorLevel or (Clipboard == "")
{
    MsgBox, 48,, % "Invalid selection....`r`nYou need to select a word."
    Goto MAKE_DEBUG_EXIT
}
clip_word := Clipboard
SendInput, {Left}^+{Right}"%clip_word%: " %clip_word%{Control Down}{Left 4}{Control Up}

MAKE_DEBUG_EXIT:
Clipboard := saved_clipboard
ExitApp
