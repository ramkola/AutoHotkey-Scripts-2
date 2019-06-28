#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\pango_level.ahk
saved_pango_level := pango_level(0)

While Not result
    result := pango_level(100)

Gui, Color, White
Gui, +ToolWindow -Caption
Gui, Show, x0 y0 w%A_ScreenWidth% h%A_ScreenHeight%
Return

Escape::
GuiEscape:
GuiClose:
    result := 0
    While Not result
        result := pango_level(saved_pango_level)
    ExitApp
    