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
If WinExist(bookmark_mgr_wintitle)
    WinActivate, %bookmark_mgr_wintitle%
Else
{
    Run, MyScripts\Utils\Web\Activate Browser.ahk 
    WinWaitActive, %any_chrome_wintitle%
    WinMaximize, %any_chrome_wintitle%
    Sleep 1000
    SendInput !d    ; set focus in omnibox
    Sleep 300
    SendInput ^achrome://bookmarks{Enter}   ; open bookmarks manager
}

Return

CANCEL_BOOKMARK_EDIT: 
^Delete::   ; Cancels current edit by reloading script
    cancel_edit := True
    ; Reload
    Return

!AppsKey::  ; Selects the bookmark and edits the name
!LButton::  ; Selects the bookmark and edits the name
    Hotkey, Escape, CANCEL_BOOKMARK_EDIT, ON
    Clipboard:=""
    If (A_ThisHotkey = "!LButton")
        MouseGetPos bookmark_x, bookmark_y
    Else
    {
        bookmark_x := A_CaretX
        bookmark_y := A_CaretY
    }
    ; ttip("`r`nbookmark_x, bookmark_y: " bookmark_x ", " bookmark_y " `r`n ",,500,500)
    Click, 2
    While (Clipboard == "") and (cancel_edit = False)
    {
        MouseGetPos, x, y
        Tooltip, % "`r`n`tWaiting for you to copy something to clipboard`t`r`n`r`n`t`tor !{Delete} to cancel.`r`n ", x+40, y+40
        Sleep 200
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

#If WinActive(bookmark_mgr_wintitle)
^+k:: list_hotkeys()