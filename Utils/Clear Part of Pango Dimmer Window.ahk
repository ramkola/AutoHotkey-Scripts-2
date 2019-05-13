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
; WinGetTitle, wt, ahk_id %window_to_brighten_hwnd%
; OutputDebug, % "window_to_brighten_hwnd: " window_to_brighten_hwnd ", wt: " wt 

SetTimer, BRIGHTEN_WINDOW, 1500

Return

#F5:: Reload

#F4::    ; allows moving window when there isn't enough space on title bar to click and drag.
    ; WinGetTitle, wt, ahk_id %window_to_brighten_hwnd%
    ; OutputDebug, % "window_to_brighten_hwnd: " window_to_brighten_hwnd ", wt: " wt 
    If !WinExist("ahk_id " window_to_brighten_hwnd)
    {
        WinSet, Region,, %pango_wintitle%   ; Restore pango window to dim entire screen
        Return
    }
    WinActivate, ahk_id  %window_to_brighten_hwnd%
    WinWaitActive, ahk_id %window_to_brighten_hwnd%,,1
    ; WinGetActiveTitle, wt
    ; ttip("`r`nwt: " wt " `r`n ", 1500)
    If WinActive("ahk_id " window_to_brighten_hwnd)
    {
        SendInput !{Space}  
        Sleep 100
        SendInput m
        Sleep 100
        SendInput {Right}
    }
    Return
    
^!+r::
    WinSet, Region,, %pango_wintitle%   ; Restore pango window to dim entire screen
    SetTimer, BRIGHTEN_WINDOW, OFF
    Return
    
BRIGHTEN_WINDOW:
    If !WinExist("ahk_id " window_to_brighten_hwnd)
    {
        Goto ^!+r
        Return
    }
    ; WinGetTitle, wt, ahk_id %window_to_brighten_hwnd%
    ; OutputDebug, % "window_to_brighten_hwnd: " window_to_brighten_hwnd ", wt: " wt 
    WinGetPos, x, y, w, h, ahk_id %window_to_brighten_hwnd%
    x := x+7
    w := w-14
    h := h-7
    trx := x+w
    bly := y+h
    WinSet, Region, 0-0 %A_ScreenWidth%-0 %A_ScreenWidth%-%A_ScreenHeight% 0-%A_ScreenHeight% 0-0   %x%-%y% %trx%-%y% %trx%-%bly% %x%-%bly% %x%-%y%, %pango_wintitle%
    Return