/* 
    Main usage to remove Pango dimmer over an area in the screen
    usually to watch a small video window, while keeping the dimmer
    level for the rest of the screen.
*/
#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\constants.ahk
#Include lib\utils.ahk
SetWorkingDir %AHK_ROOT_DIR%
g_TRAY_RELOAD_ON_LEFTCLICK := True      ; set only 1 to true to enable, see lib\utils.ahk
Menu, Tray, Icon, ..\resources\32x32\flashlight-135-761367.png
SetTitleMatchMode 2
pango_wintitle = Fade Lens ahk_class FadeLensScrClass ahk_exe PangoBright.exe
; RButton makes the target window always on top and returns it's hwnd
; MButton returns target window hwnd without changing its always on top status.
RunWait, MyScripts\Utils\Set Any Window Always On Top.ahk,,UseErrorLevel
window_to_brighten_hwnd := ErrorLevel

SetTimer, BRIGHTEN_WINDOW, 1500
SetTimer, ALWAYS_ON_TOP, 1000
always_on_top := True
Return

ALWAYS_ON_TOP:
    If !always_on_top
        Return
    If WinExist("ahk_id " window_to_brighten_hwnd)
        WinSet, AlwaysOnTop, On, ahk_id %window_to_brighten_hwnd%
    Return

#F6::   ; Toggle always on top
    always_on_top := !always_on_top
    If always_on_top
        Gosub ALWAYS_ON_TOP
    Else
        WinSet, AlwaysOnTop, Off, ahk_id %window_to_brighten_hwnd%
    aot_state := always_on_top ? "ON" : "OFF"
    SetTimer, ALWAYS_ON_TOP, %aot_state% 
    ttip("`r`nAlways on top state.... " aot_state " `r`n ",1500)
    Return

#F5:: Reload

#F4::    ; allows moving window when there isn't enough space on title bar to click and drag.
    If !WinExist("ahk_id " window_to_brighten_hwnd)
    {
        WinSet, Region,, %pango_wintitle%   ; Restore pango window to dim entire screen
        SetTimer, ALWAYS_ON_TOP, Off
        Return
    }
    WinActivate, ahk_id  %window_to_brighten_hwnd%
    WinWaitActive, ahk_id %window_to_brighten_hwnd%,,1
    ; Note: tried PostMessage, 0xA1, 2 ; 0xA1 = WM_NCLBUTTONDOWN but didn't work as well as the following.
    If WinActive("ahk_id " window_to_brighten_hwnd)
    {
        SendInput !{Space}  ; system menu
        Sleep 100
        SendInput m         ; move window
        Sleep 100
        SendInput {Right}   ; locks mouse on move cursor
    }
    Return
    
^!+r::  ; Turn off brightening window without exiting program
    WinSet, Region,, %pango_wintitle%   ; Restore pango window to dim entire screen
    SetTimer, BRIGHTEN_WINDOW, OFF
    SetTimer, ALWAYS_ON_TOP, OFF
    Return
    
BRIGHTEN_WINDOW:
    If !WinExist("ahk_id " window_to_brighten_hwnd)
    {
        Goto ^!+r
        Return
    }
    WinGetPos, x, y, w, h, ahk_id %window_to_brighten_hwnd%
    x := x+7
    w := w-14
    h := h-7
    trx := x+w
    bly := y+h
    fullscreen_window = 0-0 %A_ScreenWidth%-0 %A_ScreenWidth%-%A_ScreenHeight% 0-%A_ScreenHeight% 0-0
    brighten_window = %x%-%y% %trx%-%y% %trx%-%bly% %x%-%bly% %x%-%y%
    WinSet, Region, %fullscreen_window% %brighten_window%, %pango_wintitle%
    Return