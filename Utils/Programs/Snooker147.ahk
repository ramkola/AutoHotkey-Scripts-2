/*
    window should be in top left corner 
    resolution 1280x1024 
    
*/
OutputDebug, DBGVIEWCLEAR
WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe

#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
Menu, Tray, Icon, C:\Program Files (x86)\JHC Software Limited\Snooker147 & Poolster\Snooker147\Snooker147.exe
Menu, Tray, Add, Start Snooker147, START_SNOOKER147
g_TRAY_RELOAD_ON_LEFTCLICK := True      ; see lib\utils.ahk

SetTitleMatchMode RegEx
snooker_wintitle = Snooker 147 - Version 1.3 ahk_class OwlWindow ahk_exe Snooker147.exe
If Not WinExist(snooker_wintitle)
    Goto START_SNOOKER147

WinMinimize, A
WinActivate, ^[BBUK|Big Brother].*YouTube - Google Chrome$ ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
WinActivate, %snooker_wintitle%
WinGetTitle, snooker_short_title, A
SetTimer, MISSED_SHOT, 50
;---------------------------------------------
; Reset mouse focus to middle of game window
;---------------------------------------------
#q::
    If Not WinExist(snooker_wintitle)
        Return
    WinActivate, %snooker_wintitle%
    WinGetPos, x, y, w, h, A
    MouseMove, w/2, h/2
    Return

#If WinActive(snooker_wintitle)
#Include MyScripts\Utils\Web\Youtube Keys.ahk
#Include MyScripts\Utils\Move Mouse By Keyboard.ahk
Return
; =============================================================================================

START_SNOOKER147:
    WinActivate, ^[BBUK|Big Brother].*YouTube - Google Chrome$ ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe

    Run, "C:\Program Files (x86)\JHC Software Limited\Snooker147 & Poolster\Snooker147\Snooker147.exe"
    WinWaitActive, %snooker_wintitle%
    WinMenuSelectItem, A,,Options,Auto Power Reset
    WinMenuSelectItem, A,,Options,Computer Player2
    WinMenuSelectItem, A,,Options,Display Reminder
    WinMenuSelectItem, A,,Window,Normal(fastest)
    WinMove, 640 , 0   
    WinGetTitle, snooker_short_title, A
    Return

MISSED_SHOT:
    missed_shot_wintitle = Snooker147 - Player Missed ahk_class #32770 ahk_exe Snooker147.exe
    If WinExist(missed_shot_wintitle)
    {
        WinActivate, %missed_shot_wintitle%
        WinWaitActive, %missed_shot_wintitle%
        ; SendInput {Enter}              ; same player retakes shot on foul (Previous... button)
        SendInput {Right}{Enter}       ; next player continues where balls are after foul (Continue button)
    }
    BlockInput, Default
    BlockInput, MouseMoveOff
    BlockInput, Off
    ; SetTimer, MISSED_SHOT, Off
    Return

^+b::
    BlockInput, Default
    BlockInput, MouseMoveOff
    BlockInput, Off
    Return

;-----------
; Shoot ball
;-----------
s::
RButton::
SHOOT_BALL:
    SetTimer, MISSED_SHOT, On       ; check for Foul (missed) shot after shot taken 
    save_coordmode := A_CoordModeMouse
    ; check for valid pool shot i.e. cursor is somewhere within the exterior
    ; perimeter of snooker table in Window/Normal (fastest) mode
    CoordMode, Mouse, Client
    MouseGetPos x, y
    If ((x >= 0 and x <= 640 ) and (y >= 0 and y <= 370))
        1=1
    Else 
    {
        ; OutputDebug, % "Cursor not in valid table shot area. x, y: " x ", " y
        Return
    }
    ; Take the shot
    CoordMode, Mouse, Screen
    BlockInput, SendAndMouse        ; see MISSED_SHOT for turning BlockInputs off
    BlockInput, MouseMove           ;               ""
    BlockInput, On                  ;               ""
    Click
    Sleep 1     ; allow default action of ball shot to take place
    ;
    MouseGetPos x, y
    MouseMove, x + 100, y   ; move mouse away from action for better viewing
    Sleep 1500
    MouseMove, x, y         ; return mouse to pre-shot position
    WinMenuSelectItem, A,,Shot,Halt Balls!      
    CoordMode, Mouse, %save_coordmode%
    Return
;--------------------------
; Misc keyboard shortcuts
;--------------------------
!l:: WinMenuSelectItem, A,,Shot, Replay Slow
!r:: 
    WinMenuSelectItem, A,,Game,Re-Rack
    Sleep 1000
    If WinActive("Snooker 147 - Warning ahk_class #32770 ahk_exe Snooker147.exe")
        SendInput !y       ; Answer Yes to game in progress prompt.
    Sleep 20
    MouseMove, 145, 200
    Return
;-----------------
; Shot "English"
;-----------------
c::      ; Full Right
z::      ; Full Left
d::      ; Full Forward Spin
x::      ; Full Back Spin
    MouseGetPos, x, y
    SetKeyDelay 0
    If (A_ThisHotkey == "c")    ; full right
        SendInput {Click 585,  470, Down}{Click 650, 470, Up}
    Else If (A_ThisHotkey == "z")     ; full left
        SendInput {Click 585,  470, Down}{Click 520, 470, Up}
    Else If (A_ThisHotkey == "d")    ; forward spin
        SendInput {Click 585,  470, Down}{Click 585, 440, Up}
    Else If (A_ThisHotkey == "x")    ; back spin
        SendInput {Click 585,  470, Down}{Click 585, 510, Up}

    MouseMove, x, y, 0
    Return
;---------------
; Shot strength
;---------------
+1::   
+2::
+3::
+4::
+5::        ; i.e. +<num> = shot strength will be 5½
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

^+x::ExitApp