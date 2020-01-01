#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
#Include lib\pango_level.ahk
#Include lib\strings.ahk
g_TRAY_EXIT_ON_LEFTCLICK := True      ; set only 1 to true to enable, see lib\utils.ahk
SetWorkingDir C:\Users\Mark\Desktop\Misc\Resources\Images
Menu, Tray, Add
Menu, Tray, Add
Menu, Tray, Add, % "List Hotkeys", LIST_MYHOTKEYS
Menu, Tray, Icon, ..\32x32\mouse_middle_button.png
Global save_pango_level
save_pango_level := pango_level(0)
OnExit("set_pango")
While (result <> 1)
    result := pango_level(100)

chrome_wintitle = ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
#If WinActive(chrome_wintitle)

Return

!m::
MButton::       ; open link in foreground new tab 
    SendInput ^+{Click}
    Sleep 3000
    Goto, !s
Return

!s::                  ; Fullscreen
MButton & RButton::   ; Fullscreen
MButton & LButton::   ; Fullscreen
    If InStr(A_ThisHotkey, "MButton")
        If (A_PriorHotkey != A_ThisHotkey or A_TimeSincePriorHotkey < 200) 
            Return
    SendInput f

    ; SendInput, {LAlt}    ; activate video menu
    ; ImageSearch, x, y, 0, 0, A_ScreenWidth, A_ScreenHeight,*2 Generic Fullscreen Video Button - Pango 100 Zoom 100.png
    ; If (ErrorLevel = 0)
        ; MouseMove, x, y
    ; Else
        ; SendInput f
Return
LIST_MYHOTKEYS:
    list_hotkeys()
    Return
    
set_pango()
{
    While (result <> 1)
        result := pango_level(save_pango_level)
    Return
}