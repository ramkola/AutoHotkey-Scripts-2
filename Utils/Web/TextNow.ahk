#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
; g_TRAY_<xxx>_ON_LEFTCLICK := True      ; set only 1 to true to enable, see lib\utils.ahk

#NoTrayIcon
SetTitleMatchMode, RegEx
textnow_wintitle = ^(TextNow|Google Contacts).*[Google Chrome|Brave]$ ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
If WinActive(textnow_wintitle)
{
    WinMinimize
    ExitApp
}

If WinExist(textnow_wintitle)
    WinActivate
Else
{
    db := default_browser() 
    Run, "%db%" 
    WinWaitActive, ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe,,2
    WinMaximize, ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
    Run, "https://contacts.google.com/"
    Sleep 2000
    Run, "https://www.textnow.com/messaging"
}
ExitApp
