#SingleInstance Force
#NoTrayIcon

not_found := True
; If %True% is passed it always opens a new window
If A_Args[1] 
	Goto NEW_WINDOW

; Find existing browser window that's not running TextNow or Google Contacts
chrome_wintitle = ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
WinGet, chrome_list, List, %chrome_wintitle%
Loop
{
    If (chrome_list%A_Index% == "")
        Break   ; no more chrome windows found

    chrome_id := "ahk_id " chrome_list%A_Index%
    WinGetTitle, current_chrome_wintitle, %chrome_id%
    excluded_window := RegExMatch(current_chrome_wintitle, "i)(TextNow|Google Contacts)")
    If Not excluded_window
    {
        WinActivate, %current_chrome_wintitle%
        SendInput ^t        ; open new tab (i.e. https://www.google.ca/)
        not_found := False
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
