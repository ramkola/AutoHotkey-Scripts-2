SetTitleMatchMode 2
npp_wintitle = ahk_class Notepad++ ahk_exe notepad++.exe
;
horizontal_splitter = nsspliter1
ControlGet, is_visible, Visible,, %horizontal_splitter%, %npp_wintitle%
If is_visible
{
    ControlGetPos, x, y, w, h, %horizontal_splitter%, %npp_wintitle%
    MouseMove, w/2, (y+h)-2
    ; rotate_view("Right")
    rotate_view("Left")
    Goto EXIT_APP
}
;
vertical_splitter = wespliter1
ControlGet, is_visible, Visible,, %vertical_splitter%, %npp_wintitle%
If is_visible
{
    ControlGetPos, x, y, w, h, %vertical_splitter%, %npp_wintitle%
    MouseMove, x+w-5, (y+h)/2
    rotate_view("Left")
}
Else    
    MsgBox, 48,, % "No Views Active.`nCtrl+F8 = Clone to other view.`nCtrl+Alt+F8 = Move to other view", 10

EXIT_APP:

ExitApp

rotate_view(p_direction)
{
    menuitem_pos := (p_direction = "Right") ? 1:2 
    Click, Right
    Sleep 10
    SendInput, {Down %menuitem_pos%}{Enter}
}

