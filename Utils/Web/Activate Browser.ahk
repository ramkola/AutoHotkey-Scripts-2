#SingleInstance Force
#NoTrayIcon

; handle command line param: Force new window
If A_Args[1] 
{
	; Force opening a new browser window
	not_found := True
	Goto NEW_WINDOW
}

; Find existing browser window that's not running TextNow or Google Contacts
chrome_wintitle = ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
WinGet, chrome_list, List, %chrome_wintitle%
not_found := False
Loop
{
    If (chrome_list%A_Index% == "")
    {
        not_found := True
        Break
    }

    chrome_id := "ahk_id " chrome_list%A_Index%
    WinGetTitle, chrome_wintitle, %chrome_id%
    skip_window := InStr(chrome_wintitle, "TextNow") or InStr(chrome_wintitle, "Google Contacts")
    If Not skip_window
    {
        WinActivate, %chrome_wintitle%
        SendInput ^t        ; new tab (google)
        Break
    }
}

NEW_WINDOW:
If not_found 
{
    Run, "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
    WinWaitActive, %chrome_wintitle%
    WinMaximize, %chrome_wintitle%
}
ExitApp
