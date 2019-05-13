#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\strings.ahk

label_flag := (A_Args[1] = "Label") ? True : False
msg_text := (A_Args[2] = "OutputDebug") ? "OutputDebug" : "MsgBox"

selected_text := select_and_copy_word()
write_string := ""
start_pos = 1
found_pos = 99999
While found_pos
{
    ; always: \.*?+[{|()^$   ||| in character class: ^-]\
    found_pos := RegExMatch(selected_text, "O)\b([\w/.*+\-]+)\b", match, start_pos)
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
    write_string := "" msg_text ", % " Chr(34) write_string 
}
Else
{
    write_string := Trim(SubStr(write_string, 6))     ; chop off first " - " spacer.
    write_string := "" msg_text ", % " write_string 
}
paste_on_new_line(write_string)
ExitApp 


