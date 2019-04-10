#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\constants.ahk
#Include lib\strings.ahk
#Include lib\utils.ahk
SendMode Input
SetTitleMatchMode 2
SetWorkingDir %AHK_ROOT_DIR%
g_TRAY_EXIT_ON_LEFTCLICK := True      ; set only 1 to true to enable, see lib\utils.ahk

cancel_edit := False
any_chrome_wintitle = ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
bookmark_mgr_wintitle = Bookmarks - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
#If WinActive(bookmark_mgr_wintitle)

If WinExist(bookmark_mgr_wintitle)
    WinActivate, %bookmark_mgr_wintitle%
Else
{
    Run, % default_browser()
    WinWaitActive, %any_chrome_wintitle%
    WinMaximize, %any_chrome_wintitle%
    Sleep 1000
    SendInput !d    ; set focus in omnibox
    Sleep 300
    SendInput ^achrome://bookmarks{Enter}   ; open bookmarks manager
}

Return

!LButton::  ; Selects the bookmark and edits the name
    Hotkey, Escape, CANCEL_BOOKMARK_EDIT, ON
    Clipboard:=""
    MouseGetPos bookmark_x, bookmark_y
    Click, 2
    While (Clipboard == "") and (cancel_edit = False)
    {
        If WinActive(bookmark_mgr_wintitle)
            cancel_edit := True
            
        MouseGetPos, x, y
        Tooltip, % "`r`n`tWaiting for you to copy something to clipboard`t`r`n`r`n`t`tor {Esc} or {Break} to cancel.`r`n ", x+40, y+40
        Sleep 300
    }
    Tooltip
    If Not cancel_edit
    {
        BlockInput On
        SendInput ^w
        Sleep 1000
        Click, %bookmark_x%, %bookmark_y%, Right
        Sleep 500
        Send {Down}{Enter}
        Sleep 100
        Send ^a^v{Enter}
        BlockInput Off
    }
    cancel_edit := False
    Return

^+k:: list_hotkeys()

#If WinActive(any_chrome_wintitle)
CANCEL_BOOKMARK_EDIT: 
Break::
    cancel_edit := True
    SendInput ^w
    Return
    