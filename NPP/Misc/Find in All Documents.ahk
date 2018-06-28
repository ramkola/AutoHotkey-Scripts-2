;
; Creates an access key in the Search/Find dialog to "Find all in Current Document"
;
#Include C:\Users\Mark\Desktop\Misc\autoHotkey Scripts
#Include lib\utils.ahk
#NoEnv
#SingleInstance force
Menu, Tray, NoIcon
SetTitleMatchMode 3     ; exact

; WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
; OutputDebug, DBGVIEWCLEAR
; WinActivate, ahk_class Notepad++ ahk_exe notepad++.exe

#If WinExist(find_window)  ; make sure !a is available ONLY when Search/Find window is available
find_window := "Find ahk_class #32770"
edit_window := "ahk_class Notepad++ ahk_exe notepad++.exe"
ControlGetfocus, edit_control, A

WinMenuSelectItem, %edit_window%,,Search,Find
Hotkey, !a, ACCESSKEY
If A_Args.Length() > 0
{    
    Sleep 100
    SendInput {Alt Down}a{Alt Up}
    outputDebug, "Executing Find All..."
}
Return

ACCESSKEY:
countx := 0 
; Make sure !a is available ONLY when the Find tab is active
While (tab_title != "Find") and countx < 5
{
    ; sometimes when there are 0 search results it needs to clicked again
    ; anyways... clicking doesn't hurt so keep trying... (?)
    WinGetTitle, tab_title, A
    Winactivate, %find_window%
    sleep 5
    Controlfocus, Button26, %find_window%
    If ErrorLevel
        outputDebug, Find All in Current Document`nCould not get fOCUS.
    SetControlDelay -1
    ControlClick, Button26, %find_window%
    ; ControlClick, Button26, %find_window%,,Left,5,NA,Replace,Replace
    If ErrorLevel
        outputDebug, Find All in Current Document`nCould not CLICK the button.
    countx++
}
sleep 50
WinClose, %find_window%     ; sometimes it doesn't close by itself 

; try to return focus from "Find Result" window to editor (personal preference)
countx := 0 
got_focus := ""
While (got_focus != edit_control) and countx < 10
{
    Controlfocus, %edit_control%, A
    ControlGetfocus, got_focus, A
    countx++
    Sleep 1
}
 if (got_focus != edit_control)
    ; outputDebug, % "Did not get focus: " . got_focus . "`nCount = " . countx

; disable hotkey when Find not in progress
Hotkey !a, Off
Exitapp


