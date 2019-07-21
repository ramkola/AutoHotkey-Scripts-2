#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\strings.ahk
#Include lib\utils.ahk
#Include lib\constants.ahk
SetWorkingDir %AHK_ROOT_DIR%
SetTitleMatchMode 2

; #s::
    OutputDebug, DBGVIEWCLEAR
    
    google_search_wintitle = Google Search - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
    chrome_wintitle = ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
    
    search_term := select_and_copy_word()
    OutputDebug, % "search_term: " search_term
    If (search_term == "")
    {
        MsgBox, 48,, % "Nothing selected", 2
        Return
    }
    Run, MyScripts\Utils\Web\Activate Browser.ahk %False% %True%
    While Not WinActive(chrome_wintitle)
    {
        WinActivate, %chrome_wintitle%
        Sleep 100
    }
    Sleep 1000
    saved_clipboard := ClipboardAll
    ; Clipboard := "https://www.google.ca/search?q=" search_term
    Clipboard := search_term
    ClipWait, 1
    ; SendInput ^l
    ; Sleep 100
    ; SendInput ^a
    SendInput %search_term%
    SendInput {Enter}
    Clipboard := saved_clipboard
    exitapp 