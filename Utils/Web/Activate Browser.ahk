#SingleInstance Force
#NoTrayIcon
SetTitleMatchMode 2

If A_Args[1]            ; If %True% is passed it always opens a new window
	Goto NEW_WINDOW
open_new_tab := A_Args[2]
goto_url := A_Args[3]

; Find existing browser window that's not an excluded window (ie: TextNow)
not_found := True
chrome_wintitle = ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
WinGet, chrome_list, List, %chrome_wintitle%    ; creates pseudo array
Loop
{
    If (chrome_list%A_Index% == "")
        Break   ; no more chrome windows found

    chrome_id := "ahk_id " chrome_list%A_Index%
    WinGetTitle, current_chrome_wintitle, %chrome_id%
    excluded_window := RegExMatch(current_chrome_wintitle, "i).*(TextNow|Google Contacts|Youtube|Sdarot|Tetris).*")
    If Not excluded_window
    {
        WinActivate, %chrome_id%
        not_found := False
        Break
    }
}

NEW_WINDOW:
If not_found 
{
    Run, "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" 
    open_new_tab := False
}

WinWaitActive, %chrome_wintitle%,,5
WinMaximize, %chrome_wintitle%
If open_new_tab
{
    If Not WinActive("Google - Google Chrome") and Not WinActive("Google Search - Google Chrome")
        SendInput ^t        ; open new tab (i.e. https://www.google.ca/)
    Else
    {
        SendInput {Home}
        If WinActive("Google - Google Chrome")
            Click, 400, 535
        Else 
            Click, 400, 153
            ; MouseMove, 400, 150
        SendInput ^a
    }
}

If goto_url
{
    SetTitleMatchMode 2
    WinWaitActive, %chrome_wintitle%,,5
    ; If ErrorLevel
        ; MsgBox, % "ErrorLevel: " ErrorLevel " - Line#" A_LineNumber " (" A_ScriptName " - " A_ThisFunc ")"
    Sleep 1000
    SendInput !d
    Sleep 10
    SendRaw %goto_url%
    SendInput {Enter}
}

ExitApp
