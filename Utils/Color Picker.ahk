#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
#SingleInstance Force
OnExit("restore_cursors")
set_system_cursor("IDC_CROSS")

w := 110
Gui, Font, s12 
; Gui, Add, Text, Center x5 y10 w%w% vcolor_text
Gui, Add, Text, Center x0 w%w% vcolor_text

Gui, +AlwaysOnTop -SysMenu +Owner -Caption +Border
x := A_ScreenWidth - w - 20
Gui, Show, x%x% y20  w%w% h50, color_window

Loop 
{
    MouseGetPos, mouse_x, mouse_y
    PixelGetColor,pixel_color, %mouse_x%, %mouse_y%,Alt Slow RGB
    GuiControl,, color_text, %pixel_color% 
    Gui, Color, %pixel_color%
}

ExitApp

GuiClose:
GuiEscape:
Esc::
    restore_cursors()
    ExitApp

+Up::
^Up::
Up::
    move_pixels := get_keyboard_move(A_ThisHotkey)
    MouseGetPos, mouse_x, mouse_y
    MouseMove, mouse_x, mouse_y - move_pixels
    Return

+Down::
^Down::
Down::
    move_pixels := get_keyboard_move(A_ThisHotkey)
    MouseGetPos, mouse_x, mouse_y
    MouseMove, mouse_x, mouse_y + move_pixels
    Return

+Left::
^Left::
Left::
    move_pixels := get_keyboard_move(A_ThisHotkey)
    MouseGetPos, mouse_x, mouse_y
    MouseMove, mouse_x - move_pixels, mouse_y
    Return

+Right::
^Right::
Right::
    move_pixels := get_keyboard_move(A_ThisHotkey)
    MouseGetPos, mouse_x, mouse_y
    MouseMove, mouse_x + move_pixels, mouse_y
    Return

+AppsKey::
+RButton::
    ControlGetText, color_hex, Static1, color_window
    Clipboard := color_hex
    OutputDebug, % "color_hex: " color_hex
    x := hex2rgb(color_hex)
    for i, j in x
        OutputDebug, % Format("{:02}) ", i) j 
    Return

hex2rgb(p_hex)
{
    rgb_result := []
    If (SubStr(p_hex,1,2) = "0x")
        hex_num := p_hex
    Else
        hex_num := "0x" p_hex

    If (StrLen(hex_num) != 8)
    {
        OutputDebug, % "Bad param: " p_hex
        Return 
    }
    red  := Format("{:d}",      SubStr(hex_num,1,4))
    green:= Format("{:d}", "0x" SubStr(hex_num,3,2))
    blue := Format("{:d}", "0x" SubStr(hex_num,5,2))
    rgb_result.push(red, green, blue)
    Return %rgb_result%
}

get_keyboard_move(p_this_hotkey)
{
    If (SubStr(p_this_hotkey,1,1) == "^")
        move_pixels = 10
    Else If (SubStr(p_this_hotkey,1,1) == "+")
        move_pixels = 20
    Else
        move_pixels = 1

    Return %move_pixels%
}
