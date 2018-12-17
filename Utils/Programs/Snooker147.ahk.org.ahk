#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
#SingleInstance Force
Menu, Tray, Icon, C:\Program Files (x86)\JHC Software Limited\Snooker147 & Poolster\Snooker147\Snooker147.exe
Menu, Tray, Add, Start Snooker147, START_SNOOKER147
g_TRAY_EXIT_ON_LEFTCLICK := True      ; see lib\utils.ahk
SetTitleMatchMode RegEx
win_title = Snooker 147 - Version 1.3 ahk_class OwlWindow ahk_exe Snooker147.exe

WinMinimize, A
WinActivate, ^BBUK.*YouTube - Google Chrome$ ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
WinActivate, %win_title%

#If WinActive(win_title)
SetTimer, MISSED_SHOT, 1000
#Include MyScripts\Utils\Move Mouse By Keyboard.ahk

Return
; =============================================================================================

START_SNOOKER147:
    WinActivate, ^BBUK.*YouTube - Google Chrome$ ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe

    Run, "C:\Program Files (x86)\JHC Software Limited\Snooker147 & Poolster\Snooker147\Snooker147.exe"
    WinWaitActive, %win_title%
    WinMenuSelectItem, A,,Options,Auto Power Reset
    WinMenuSelectItem, A,,Options,Computer Player2
    WinMenuSelectItem, A,,Options,Display Reminder
    WinMenuSelectItem, A,,Window,Normal(fastest)
    WinMove, 640 , 0   
    Return

MISSED_SHOT:
    If WinExist("Snooker147 - Player Missed ahk_class #32770 ahk_exe Snooker147.exe")
    {
        WinActivate
        SendInput {Enter}
    }
    Return

;--------------------------
; Misc Keyboard Shortcuts
;--------------------------
r:: WinMenuSelectItem, A,,Game,Re-Rack
l:: WinMenuSelectItem, A,,Shot, Replay Slow
;---------------------------------
; Reset Mouse Focus to Game Window
;---------------------------------
m::
    If Not WinExist(win_title)
        Return
    WinActivate, %win_title%
    WinGetPos, x, y, w, h, A
    MouseMove, w/2, h/2
    Return
;-----------
; Shoot Ball
;-----------
s::
RButton::
    BlockInput, SendAndMouse
    BlockInput, MouseMove
    BlockInput, On
    Click
    Sleep 1     ; allow default action of ball shot to take place
    MouseGetPos x, y
    MouseMove, x + 100, y   ; move mouse away from action for better viewing
    Sleep 2500
    MouseMove, x, y         ; return mouse to pre-shot position
    WinMenuSelectItem, A,,Shot,Halt Balls!      
    BlockInput, Default
    BlockInput, MouseMoveOff
    BlockInput, Off
    Return
;---------------
; Shot Strength
;---------------
+1::   
+2::
+3::
+4::
+5::        ; i.e. shot strength will be 5½
+6::
+7::
+8::
+9::
+0::
1::
2::
3::
4::
5::
6::
7::
8::
9::
0::
    save_mousespeed := A_DefaultMouseSpeed 
    SetDefaultMouseSpeed, 0
    SetMouseDelay, 0
    MouseGetPos, save_x, save_y 
    save_mousemode := A_CoordModeMouse
    CoordMode, Mouse, Window   
    ; reset shot strength ruler zero level 
    MouseMove, 300, 500     ; grab strength pool cue
    Click, Down
    MouseMove, 9999, 500    ; move as far right as possible 
    Click, Up
    ; line up mouse with strength pool cue on zero level
    MouseMove, 470, 500
    Click, Down
    ;
    ; move strength pool cue to desired level
    strength_factor := (A_ThisHotkey == "0") ? 10 : A_ThisHotkey
    plus_half := (SubStr(A_ThisHotkey, 1, 1) == "+") ? 15 : 0
    MouseMove, 470 - (strength_factor * 30) - plus_half, 500 
    Click, Up
    ; 
    MouseMove, save_x, save_y 
    CoordMode, Mouse, %A_CoordModeMouse%
    SetDefaultMouseSpeed := save_mousespeed
    Return