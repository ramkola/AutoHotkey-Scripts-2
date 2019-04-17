#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\strings.ahk

capslock_state := GetKeyState("CapsLock")
numlock_state := GetKeyState("NumLock")
scrolllock_state := GetKeyState("ScrollLock")
lwin_state := GetKeyState("LWin")
lcontrol_state := GetKeyState("LControl")
rcontrol_state := GetKeyState("RControl")
control_state := GetKeyState("Control")
lshift_state := GetKeyState("LShift")
rshift_state := GetKeyState("RShift")
shift_state := GetKeyState("Shift")
lalt_state := GetKeyState("LAlt")
ralt_state := GetKeyState("RAlt")
alt_state := GetKeyState("Alt")

write_string .= "capslock_state: " capslock_state "`r`n"
write_string .= "numlock_state: " numlock_state "`r`n"
write_string .= "scrolllock_state: " scrolllock_state "`r`n"
write_string .= "lwin_state: " lwin_state "`r`n"
write_string .= "lcontrol_state: " lcontrol_state "`r`n"
write_string .= "rcontrol_state: " rcontrol_state "`r`n"
write_string .= "control_state: " control_state "`r`n"
write_string .= "lshift_state: " lshift_state "`r`n"
write_string .= "rshift_state: " rshift_state "`r`n"
write_string .= "shift_state: " shift_state "`r`n"
write_string .= "lalt_state: " lalt_state "`r`n"
write_string .= "ralt_state: " ralt_state "`r`n"
write_string .= "alt_state: " alt_state

Loop, Parse, write_string, `n, `r
{
    p1 := RegExReplace(A_LoopField, "^(.*:\s)\d$","$1")
    p2 := RegExReplace(A_LoopField, "^.*:\s(\d)$","$1")
    formatted_string .= Format("{:20} {}`r`n`r`n", p1, p2)
}

display_text(formatted_string )

ExitApp 