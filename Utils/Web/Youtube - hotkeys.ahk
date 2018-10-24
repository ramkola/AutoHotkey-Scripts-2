#SingleInstance Force
Menu, Tray, Icon, C:\Users\Mark\Desktop\Misc\resources\32x32\Singles\youtube.png
SetTitleMatchMode RegEx

WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
OutputDebug, DBGVIEWCLEAR

#If WinActive("^.* - YouTube - Google Chrome$ ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe")
 or WinActive("^Watch.*- Watchseries - Google Chrome$ ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe")


*WheelUp::  OutputDebug, % "This should never print"
*WheelDown::OutputDebug, % "This should never print"

^WheelUp::
^WheelDown::
WheelUp::
WheelDown::
MButton::
RButton::
save_mouse_coordmode := A_CoordModeMouse
CoordMode, Mouse, Screen
; OutputDebug, % A_ThisHotkey
{
    WinGetPos, x1, y1, w, h, A      ; will be youtube page because of #if winactive
    x2 := x1 + w
    y2 := y1 + h
    MouseGetPos, x,y,hovering_hwnd
    WinGetTitle, win_page_title, ahk_id %hovering_hwnd%
 
    If x between %x1% and %x2%
        If y between %y1% and %y2%
        {
            If (A_ThisHotkey = "WheelUp")
                SendInput {Right}   ; seek video forward
            Else If (A_ThisHotkey = "WheelDown")
                SendInput {Left}    ; seek video backward
            Else If (A_ThisHotkey = "^WheelUp")
                scroll_page(x,y,x2,"{PgUp}")
            Else If (A_ThisHotkey = "^WheelDown")
                scroll_page(x,y,x2,"{PgDn}")
            Else If (A_ThisHotkey = "MButton")
                SendInput f         ; toggle fullscreen
            Else If (A_ThisHotkey = "RButton")
                SendInput +n        ; skip to next video
            Else
                OutputDebug, % "Unexpected hotkey: " A_ThisHotkey
        }
        Else
            1=1
            ; OutputDebug, % "hovering youtube page: " y " : " y1 " to " y2 " `t`t" win_page_title
    Else
        1=1
        ; OutputDebug, % "youtube page is active but mouse is hovering over: " x " : " x1 " to " x2 " `t`t" win_page_title 
}
CoordMode, Mouse, save_mouse_coordmode
; OutputDebug, % "save_mouse_coordmode: " save_mouse_coordmode
Return

scroll_page(p_x,p_y,p_x2,p_direction)
{
    saved_mouse_speed := A_DefaultMouseSpeed
    saved_mouse_delay := A_MouseDelay
    SetDefaultMouseSpeed, 0
    SetMouseDelay, -1
    MouseMove p_x2/2, 3
    Click
    SendInput %p_direction% 
    MouseMove p_x,p_y   
    Sleep 100
    SetMouseDelay, %saved_mouse_delay%
    SetDefaultMouseSpeed, %saved_mouse_speed%
}