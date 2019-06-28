#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\constants.ahk
#Include lib\utils.ahk
#SingleInstance Force
#Persistent
SetWorkingDir %AHK_ROOT_DIR%
Menu, Tray, Icon, ..\resources\32x32\Signs\launcher.png
g_TRAY_MENU_ON_LEFTCLICK := True      ; see lib\utils.ahk
;-------------------------------------------------------
; Top of Systray Menu
;-------------------------------------------------------
Menu, Tray, NoStandard
Menu, Tray, Add, Load Keyboard Shortcuts, MENU_HANDLER
Menu, Tray, Disable, Load Keyboard Shortcuts
Menu, Tray, Add,
Menu, Tray, Add, Freecell, MENU_HANDLER_PROGRAMS
Menu, Tray, Add, Mahjong, MENU_HANDLER_PROGRAMS
Menu, Tray, Add, MineSweeper, MENU_HANDLER_PROGRAMS
Menu, Tray, Add, Snooker147, MENU_HANDLER_PROGRAMS
Menu, Tray, Add, Tetris, MENU_HANDLER
Menu, Tray, Add, Monopoly, MENU_HANDLER
;
Menu, Tray, Disable, Tetris     ; TetrisMarathon is no longer in service
SetWorkingDir %AHK_ROOT_DIR%\MyScripts\Utils
;-------------------------------------------------------
; Programs submenu
;-------------------------------------------------------
Menu, Tray, Add,
Menu, Programs, Add, DUMMY
Loop, Files, %A_WorkingDir%\Programs\*.ahk, F
    Menu, Programs, Add, %A_LoopFileName%, MENU_HANDLER_PROGRAMS
Menu, Programs, Delete, DUMMY
Menu, Tray, Add, Programs, :Programs
;-------------------------------------------------------
; Web submenu
;-------------------------------------------------------
Menu, Web, Add, DUMMY
Loop, Files, %A_WorkingDir%\Web\*.ahk, F
    Menu, Web, Add, %A_LoopFileName%, MENU_HANDLER
Menu, Web, Delete, DUMMY
Menu, Tray, Add, Web, :Web
;-------------------------------------------------------
; Utils submenu
;-------------------------------------------------------
Menu, Utils, Add, DUMMY
Loop, Files, %A_WorkingDir%\*.ahk, F
    Menu, Utils, Add, %A_LoopFileName%, MENU_HANDLER_UTILS
Menu, Utils, Delete, DUMMY
Menu, Tray, Add, Utils, :Utils
;-------------------------------------------------------
; Launch submenu (alternative to using +MButton method)
; *********** UNDER CONSTRUCTION ***********
;-------------------------------------------------------
countx := 1
Menu, Tray, Add,
Menu, Launch, Add, DUMMY
Loop, Files, C:\Users\Mark\Documents\Launch\*.*, FDR
{
    If InStr(FileExist(A_LoopFileFullPath),"D") 
        Continue    ; skip directories
    If (A_LoopFileName = "desktop.ini")
        Continue
    ; If Mod(countx, 10)= 0
        ; Menu, Launch, Add,,+BarBreak 
    Menu, Launch, Add, %A_LoopFileName%, MENU_HANDLER_LAUNCH
    countx++
}
Menu, Launch, Delete, DUMMY
Menu, Tray, Add, Launch, :Launch
;-------------------------------------------------------
; Bottom of systray menu
;-------------------------------------------------------
Menu, Tray, Add,
Menu, Tray, Add, Edit this script, MENU_HANDLER
Menu, Tray, Add, Reload this script, MENU_HANDLER
Menu, Tray, Add, Exit, MENU_HANDLER
Menu, Tray, Add
Menu, Tray, Add
Menu, Tray, Add, Monitor Sleep, MONITOR_SLEEP
Return

;=============================================================================================

DUMMY:
    Return


MENU_HANDLER:   
    ahk_program := (SubStr(A_ThisMenuItem, -3) = ".ahk")
    If (A_ThisMenuItem == "Tetris")
        1=1
        ; Run, "%A_WorkingDir%\Web\TetrisMarathon.ahk"
    Else If (A_ThisMenuItem == "Monopoly")
        Run, "%A_WorkingDir%\Web\Monopoly.ahk"
    Else If InStr(A_ThisMenuItem, "youtube")
        Run, "%A_ScriptDir%\Video (youtube) Remote Mouse Control.ahk" ".*YouTube - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe"
    Else If (A_ThisMenuItem == "Edit this script")
        Run, "C:\Program Files (x86)\Notepad++\notepad++.exe" "%A_ScriptFullPath%"
    Else If (A_ThisMenuItem == "Reload this script")
        Run, %A_ScriptFullPath%
    Else If (A_ThisMenuItem == "Exit")
        ExitApp
    Else If ahk_program
        Run, "%A_WorkingDir%\Web\%A_ThisMenuItem%"
    Else
        OutputDebug, % "Unexpected menu item: " A_ThisMenuItem

    WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
    Return

MENU_HANDLER_PROGRAMS:
    ahk_program := (SubStr(A_ThisMenuItem, -3) = ".ahk")
    If (A_ThisMenuItem == "Freecell")
        Run, "%A_WorkingDir%\Programs\Freecell.ahk"
    Else If (A_ThisMenuItem == "Mahjong")
        Run, "%A_WorkingDir%\Programs\Mahjong.ahk"
    Else If (A_ThisMenuItem == "MineSweeper")
        Run, "%A_WorkingDir%\Programs\MineSweeper.ahk"
    Else If (A_ThisMenuItem == "Snooker147")
        Run, "%A_WorkingDir%\Programs\Snooker147.ahk"
    Else If ahk_program
        Run, "%A_WorkingDir%\%A_ThisMenu%\%A_ThisMenuItem%"
    Else
        OutputDebug, % "Unexpected menu item: " A_ThisMenuItem
    Return

MENU_HANDLER_UTILS:
    Run, "%A_WorkingDir%\%A_ThisMenuItem%"
    Return

MENU_HANDLER_LAUNCH:
    MouseGetPos, x, y
    ToolTip, *** Under Construction *** %A_ThisMenu% %A_ThisMenuItem%, x-100, y-100
    Sleep 2000
    ToolTip
    Return
        
MONITOR_SLEEP:
    Run, "C:\Users\Mark\Desktop\Turn Off Monitor.ahk.lnk"
    Return

