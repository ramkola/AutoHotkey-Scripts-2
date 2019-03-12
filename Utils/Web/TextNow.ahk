#NoTrayIcon
SetTitleMatchMode, RegEx
textnow_wintitle = ^(TextNow|Google Contacts).*Google Chrome$ ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
If WinActive(textnow_wintitle)
{
    WinMinimize
    ExitApp
}

If WinExist(textnow_wintitle)
    WinActivate
Else
{
    Run, "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" 
    WinWaitActive, ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe,,2
    WinMaximize, ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
    Run, "https://contacts.google.com/"
    Sleep 2000
    Run, "https://www.textnow.com/messaging"
}
ExitApp
