#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\constants.ahk
#Include lib\utils.ahk
SetWorkingDir %AHK_ROOT_DIR%
Menu, Tray, Icon, ..\resources\32x32\icons8-under-construction-32.png
g_TRAY_EXIT_ON_LEFTCLICK := True      ; set only 1 to true to enable, see lib\utils.ahk
SetTitleMatchMode RegEx
win_title = ^Watch.*Watchseries - Google Chrome$
WinActivate, %win_title%

#If WinActive(win_title) ;  and Not WinActive("Tetris.*Google Chrome$")

~LButton Up::
    OutputDebug, DBGVIEWCLEAR
    OutputDebug, % A_Now " ======================================================="
    ; If Not WinActive(win_title) And mouse_hovering(win_title)
    ; {
        ; WinActivate, %win_title%
        ; WinWaitActive, %win_title%, 2
        
        ; WinGetTitle, aw, A
        ; OutputDebug, % "active window after hover check: " aw
    ; }
    Sleep 1000
    If Not WinActive(win_title) And Not WinActive("^Tetris.*Google Chrome$")
        SendInput ^w
    Else
        OutputDebug, % "Neither Watchseries nor Tetris windows are active."       

    ; WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
    Return