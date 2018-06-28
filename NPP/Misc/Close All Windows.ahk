#NoEnv
#SingleInstance Force
#NoTrayIcon
SetTitleMatchMode 3

; If windows are docked
click_close_button("Button1")   ; Find Results
click_close_button("Button2")   ; Function List / Document Map
click_close_button("Button3")   ; ASCII Insertion Panel
click_close_button("Button4")   ; DBGp
click_close_button("Button5")   ; Folder as Workspace / Favorites / Explorer

; Needed in case DBGp is active and undocked
WinActivate, "ahk_class Notepad++ ahk_exe notepad++.exe"

; If windows are undocked
If WinExist("Function List ahk_class #32770 ahk_exe notepad++.exe")
    WinClose
If WinExist("Document Map ahk_class #32770 ahk_exe notepad++.exe")
    WinClose
If WinExist("ASCII Insertion Panel ahk_class #32770 ahk_exe notepad++.exe")
    WinClose
If WinExist("DBGp ahk_class #32770 ahk_exe notepad++.exe")
    WinClose
If WinExist("Folder as Workspace ahk_class #32770 ahk_exe notepad++.exe")
    WinClose
If WinExist("Favorites ahk_class #32770 ahk_exe notepad++.exe")
    WinClose
If WinExist("Explorer ahk_class #32770 ahk_exe notepad++.exe")
    WinClose
; undocked DBGp panels
If WinExist("Breakpoints ahk_class TDebugBreakpointsForm1 ahk_exe notepad++.exe")
    WinClose
If WinExist("Stack ahk_class TDebugStackForm1 ahk_exe notepad++.exe")
    WinClose
If WinExist("Watches ahk_class TDebugWatchFrom ahk_exe notepad++.exe")
    WinClose
If WinExist("Local context ahk_class TDebugContextForm ahk_exe notepad++.exe")
    WinClose
If WinExist("Global context ahk_class TDebugContextForm ahk_exe notepad++.exe")
    WinClose
; DGBp undocked tabs with any configuration of panels (title left out on purpose)
; executed twice in case both tabs are undocked.
If WinExist("ahk_class TJvDockTabHostForm ahk_exe notepad++.exe")
    WinClose
If WinExist("ahk_class TJvDockTabHostForm ahk_exe notepad++.exe")
    WinClose
;
SetTitleMatchMode 1
If WinExist("Find result ahk_class #32770 ahk_exe notepad++.exe")
    WinClose
    
ExitApp

click_close_button(p_control_classNN)
{    
    ControlGet, is_visible, Visible,, %p_control_classNN%, A
    if is_visible
    {    
        ControlGetPos, X, Y, Width, Height, %p_control_classNN%, A
        X := Width - 9
        Y := 5
        ControlClick, %p_control_classNN%, A,,,, NA x%X% y%Y%  
    }
    Return
}
