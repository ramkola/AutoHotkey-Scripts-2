#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
#Include lib\constants.ahk
g_TRAY_SUSPEND_ON_LEFTCLICK := True      ; set only 1 to true to enable, see lib\utils.ahk
SetTitleMatchMode 2
SetWorkingDir %AHK_ROOT_DIR%
Menu, Tray, Icon, ..\Resources\32x32\Singles\rarbg.png

#If WinActive("RARBG - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe")

LButton:: SendInput {Control Down}{RButton}{Control Up}

^LButton::SendInput {Click}