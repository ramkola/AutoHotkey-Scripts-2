#SingleInstance Force
Menu, Tray, Icon, ..\resources\32x32\Search\Color Wheel.ico
Gui Add, Text, x10 y90 w180  +0x800001 +0x200 vlbl_color_text

RButton::
MouseGetPos, x, y
PixelGetColor, color, %x%, %y%
Clipboard := Color
Gui, Color, %color%
GuiControl,,lbl_color_text, %color%
Gui, Show, w200 h200
return

GuiEscape:
GuiClose:
    ExitApp
