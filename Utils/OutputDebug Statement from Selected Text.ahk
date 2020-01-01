#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\strings.ahk

label_flag := (A_Args[1] = "Label") ? True : False
msg_type := (A_Args[2] = "OutputDebug") ? "OutputDebug" : "MsgBox"

selected_text := select_and_copy_word()
write_string := ""
start_pos = 1
found_pos = 99999
While found_pos
{
    ; out of character class: \.*?+[{|()^$   |||   in character class: ^-]\
    found_pos := RegExMatch(selected_text, "O)\b([.\w/*+\-]+)\b", match, start_pos)
    If found_pos
    {
        start_pos := match.Pos + match.len
        If label_flag
            write_string .= Chr(34) " - " match.value ": " Chr(34) " " match.value " "
        Else
            write_string .= Chr(34) " - " Chr(34) " " match.value " "
    }
}

If label_flag
{
    write_string := Trim(SubStr(write_string, 5))     ; chop off first " - " spacer.
    If (msg_type = "OutputDebug")
        write_string := "output_debug(" chr(34) write_string ")"
    Else
        write_string := "MsgBox,,, % " chr(34) write_string ", 2"
}
Else
{
    write_string := Trim(SubStr(write_string, 6))     ; chop off first " - " spacer.
    If (msg_type = "OutputDebug")
        write_string := "output_debug(" write_string ")"
    Else If (msg_type = "MsgBox")
        write_string := "MsgBox,,, % " write_string ", 2"
}
paste_on_new_line(write_string)
ExitApp 


