;---------------------------------------------------------------------------------------
;
; Creates an access key in the Search/Find dialog to "Find all in Current Document"
;
;---------------------------------------------------------------------------------------
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\constants.ahk
#NoEnv
; #NoTrayIcon
#SingleInstance Force
SendMode Input
SetWorkingDir %AHK_MY_ROOT_DIR%
StringCaseSense Off
Menu, Tray, Icon, ..\resources\32x32\icons8-under-construction-32.png
SetTitleMatchMode 3     ; exact

find_window := "Find ahk_class #32770"
edit_window := "ahk_class Notepad++ ahk_exe notepad++.exe"
ControlGetfocus, edit_control, A

WinMenuSelectItem, %edit_window%,,Search,Find
Sleep 100

; if any runtime param is passed, Find All in Current Document will 
; execute automatically with whatever text was selected at the time.
If A_Args.Length() > 0  
    SendInput !a

RESETTIMER:
; If hotkey was not used then the program would never exit. Timer ensures that the 
; program exits automatically after 10 seconds if the find_window is not active.
; Note: Search is executed with the same options set on the last manual search. 
SetTimer, EXITNOW, 1000
    
Return

!a::
    SetControlDelay -1
    countx := 0 
    ; Make sure !a is available ONLY when the Find tab is active
    While (tab_title != "Find") and countx < 50
    {
        ; sometimes when there are 0 search results it needs to clicked again
        ; anyways... clicking doesn't hurt so keep trying... (?)
        WinGetTitle, tab_title, A
        Winactivate, %find_window%
        sleep 50
        Controlfocus, Button26, %find_window%
        ControlClick, Button26, %find_window%,,,, NA
        ControlGetfocus, got_focus, A
        countx++
    }
    ; OutputDebug, % "got_focus: " got_focus "   countx: " countx
    sleep 500
    WinClose, %find_window%     ; sometimes it doesn't close by itself 
    
    ; return focus from "Find Result" window to editor (personal preference)
    Controlfocus, %edit_control%, A
    Click

EXITNOW:
    If WinActive(find_window)
        Goto RESETTIMER
    Exitapp


ExitApp

^p::Pause
^x::ExitApp
