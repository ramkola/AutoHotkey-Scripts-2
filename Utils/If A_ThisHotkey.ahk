#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\strings.ahk
Return

RAlt::
    hotkey_line := select_and_copy_line()
    hot_key := RegExReplace(hotkey_line, "s)^(.*)::.*$", "$1", replaced_count)
    If (replaced_count <> 1)
    {
        MsgBox, 48,, % "Invalid hotkey selection", 3
        Return
    }
    write_string = Else If (A_ThisHotkey = "%hot_key%") 
    SendInput {End}{Enter}
    Sleep 10
    SendRaw %write_string%
    Return

^+x::ExitApp

