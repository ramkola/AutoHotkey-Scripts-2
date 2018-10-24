#SingleInstance Force
; Keyboard Hotkeys
NumpadDot::
Home::Send {Click, Left}
End::Send {Click, Right}
PgUp::Send {Click, Left, Up} 
PgDn::Send {Click, Left, Down} 
!PgUp::Send {Click, Right, Up} 
!PgDn::Send {Click, Right, Down} 

+Left::
^Left::
Left::
+Right::
^Right::
Right::
+Up::
^Up::
Up::
+Down::
^Down::
Down::
    hot_key := A_ThisHotkey
    move_pixels := get_keyboard_move(hot_key)
    MouseGetPos, mouse_x, mouse_y
    If InStr(hot_key, "up") or InStr(hot_key, "down")
        mouse_y := mouse_y + move_pixels
    Else
        mouse_x := mouse_x + move_pixels
    MouseMove, mouse_x, mouse_y
    Return

get_keyboard_move(p_this_hotkey)
{
    If (SubStr(p_this_hotkey,1,1) == "^")
        move_pixels = 10    ; medium move
    Else If (SubStr(p_this_hotkey,1,1) == "+")
        move_pixels = 20    ; large move
    Else
        move_pixels = 1     ; small move
    If InStr(p_this_hotkey, "left") or InStr(p_this_hotkey, "up")
        move_pixels := -move_pixels
    Return %move_pixels%
}