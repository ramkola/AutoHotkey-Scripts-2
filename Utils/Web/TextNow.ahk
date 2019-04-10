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
    write_string := "*** NO INTERNET CONNECTION *** - " A_ScriptName "`r`n"
    For key, value in exception_details
        write_string .= key ": " value "`r`n"
    ttip(write_string, 2000)
    ExitApp
}    
OutputDebug, % "Ping check success: " connection "ms - A_ScriptName: " A_ScriptName 
db := default_browser() 
Run, "%db%"     ; run textnow in its own browser window
WinWaitActive, ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe,,2
WinMaximize, ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
Run, "https://contacts.google.com/"
Sleep 2000
Run, "https://www.textnow.com/messaging"
Sleep 2000
SendInput ^1    ; default newtaburl when chrome starts (ie google)
Sleep 100
SendInput ^w    ; close the newtaburl
Sleep 100
SendInput ^2    ; go to TextNow tab
ExitApp
