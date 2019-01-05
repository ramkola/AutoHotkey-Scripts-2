#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\constants.ahk
#Include lib\utils.ahk
#SingleInstance Force
#Persistent
SetWorkingDir %AHK_ROOT_DIR%
Menu, Tray, Icon, ..\resources\32x32\Signs\launcher.png
g_TRAY_MENU_ON_LEFTCLICK := True      ; see lib\utils.ahk

Menu, Tray, NoStandard
Menu, Tray, Add, Load Keyboard Shortcuts, MENU_HANDLER
Menu, Tray, Disable, Load Keyboard Shortcuts
Menu, Tray, Add,
Menu, Tray, Add, Snooker147, MENU_HANDLER
Menu, Tray, Add, Tetris,     MENU_HANDLER
Menu, Tray, Add, Youtube,    MENU_HANDLER
Menu, Tray, Add,
Loop, Files, %A_ScriptDir%\*.ahk, F
{
    Menu, Tray, Add, %A_LoopFileName%, MENU_HANDLER
}
Menu, Tray, Add,
Menu, Tray, Add, Edit this script, MENU_HANDLER
Menu, Tray, Add, Reload this script, MENU_HANDLER
Menu, Tray, Add, Exit, MENU_HANDLER
Menu, Tray, Add
Menu, Tray, Add
Menu, Tray, Add, Monitor Sleep, MONITOR_SLEEP
Return

MENU_HANDLER:   
    ahk_program := (SubStr(A_ThisMenuItem, -3) = ".ahk")
    If (A_ThisMenuItem == "Snooker147")
        Run, C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts\MyScripts\Utils\Programs\Snooker147.ahk
    Else If (A_ThisMenuItem == "Tetris")
        Run, %A_ScriptDir%\TetrisMarathon.ahk
    Else If instr(A_ThisMenuItem, "youtube")
        Run, "%A_ScriptDir%\Youtube - hotkeys.ahk" ".*YouTube - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe"
    Else If (A_ThisMenuItem == "Edit this script")
        Run, "C:\Program Files (x86)\Notepad++\notepad++.exe" %A_ScriptFullPath%
    Else If (A_ThisMenuItem == "Reload this script")
        Run, %A_ScriptFullPath%
    Else If (A_ThisMenuItem == "Exit")
        ExitApp
    Else If ahk_program
        Run, "%A_ScriptDir%\%A_ThisMenuItem%"
    Else
        OutputDebug, % "Unexpected menu item: " A_ThisMenuItem

    WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
    Return

MONITOR_SLEEP:
    Run, "C:\Users\Mark\Desktop\Turn Off Monitor.ahk.lnk"
    Return
