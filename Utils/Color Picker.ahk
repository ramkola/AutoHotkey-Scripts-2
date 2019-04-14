#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
#Include lib\strings.ahk
#Include lib\constants.ahk
SetWorkingDir %AHK_ROOT_DIR%
g_TRAY_EXIT_ON_LEFTCLICK := True      ; set only 1 to true to enable, see lib\utils.ahk
Menu, Tray, Icon, ..\resources\32x32\SHELL32_239.ico



OnExit("restore_cursors")
set_system_cursor("IDC_CROSS")
w := 150
Gui, Font, s10
Gui, Add, Text, x0 w%w% r2 +Center vcolor_text, color goes here
Gui, +AlwaysOnTop -SysMenu +Owner -Caption +Border
x := A_ScreenWidth - w - 20
Gui, Show, x%x% y20  w%w% h50, color_window

#If WinExist("color_window ahk_class AutoHotkeyGUI ahk_exe AutoHotkey.exe")

Loop 
{
    MouseGetPos, mouse_x, mouse_y
    PixelGetColor, pixel_color, %mouse_x%, %mouse_y%, Alt Slow RGB
    x := hex2rgb(pixel_color)
    window_text := Format("HEX: {:-18} `r`nRGB: ({:03}) ({:03}) ({:03})", pixel_color, x[1], x[2], x[3])
    ; ttip("`r`n" window_text " `r`n ", 1000)
    GuiControl,, color_text, %window_text%      ; change text
    Gui, Color, %pixel_color%                   ; change window color
}
ExitApp

GuiClose:
GuiEscape:
; Escape::   ; exit / cancel
    restore_cursors()
    ExitApp

+Up::     ; move mouse 20 pixels up
^Up::     ; move mouse 10 pixels up
Up::      ; move mouse 1  pixel  up 
    move_pixels := get_keyboard_move(A_ThisHotkey)
    MouseGetPos, mouse_x, mouse_y
    MouseMove, mouse_x, mouse_y - move_pixels
    Return

+Down::     ; move mouse 20 pixels down
^Down::     ; move mouse 10 pixels down
Down::      ; move mouse 1  pixel  down
    move_pixels := get_keyboard_move(A_ThisHotkey)
    MouseGetPos, mouse_x, mouse_y
    MouseMove, mouse_x, mouse_y + move_pixels
    Return

+Left::     ; move mouse 20 pixels left
^Left::     ; move mouse 10 pixels left
Left::      ; move mouse 1  pixel  left 
    move_pixels := get_keyboard_move(A_ThisHotkey)
    MouseGetPos, mouse_x, mouse_y
    MouseMove, mouse_x - move_pixels, mouse_y
    Return

+Right::     ; move mouse 20 pixels right
^Right::     ; move mouse 10 pixels right
Right::      ; move mouse 1  pixel  right 
    move_pixels := get_keyboard_move(A_ThisHotkey)
    MouseGetPos, mouse_x, mouse_y
    MouseMove, mouse_x + move_pixels, mouse_y
    Return

+AppsKey::  ; copy color info to clipboard
+RButton::  ; copy color info to clipboard
AppsKey & RButton::
^!+Break::
    ControlGetText, color_window_text, Static1, color_window
    hex_no_prefix := StrReplace(pixel_color, "0x","")
    Clipboard := hex_no_prefix
    ttip("`r`nClipboard: " hex_no_prefix "`r`n`r`n" color_window_text " `r`n ",3000)
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

Escape::
    restore_cursors()
    ExitApp
    
^+k:: list_hotkeys()