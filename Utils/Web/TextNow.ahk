#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
#Include lib\ping.ahk
#NoTrayIcon
SetTitleMatchMode, RegEx

textnow_wintitle = ^(TextNow|Google Contacts).*[Google Chrome|Brave]$ ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
If WinExist(textnow_wintitle)
{
    If WinActive(textnow_wintitle) Or (A_Args[1] = "Minimize")
        WinMinimize     ; PostMessage, 0x112, 0xF020   ; 0x112 = WM_SYSCOMMAND, 0xF020 = SC_MINIMIZE
    Else
    {
        WinActivate
        WinMaximize     ; PostMessage, 0x112, 0xF030  ; 0x112 = WM_SYSCOMMAND, 0xF020 = SC_MINIMIZE
    }
    ExitApp
}

Try 
    connection := Ping("8.8.8.8") 
Catch exception_details
{
    OutputDebug, % "*** Ping Error Details - " A_ScriptName " ***"
    For key, value in exception_details
        OutputDebug, % key ": " value
    OutputDebug, % "^^^ End of Ping Error Details ^^^ " A_ScriptName 

    WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
    ExitApp
}    

OutputDebug, % "Ping check success: " connection "ms - A_ScriptName: " A_ScriptName 
db := default_browser() 
Run, "%db%" 
WinWaitActive, ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe,,2
WinMaximize, ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
Run, "https://contacts.google.com/"
Sleep 2000
Run, "https://www.textnow.com/messaging"
ExitApp
