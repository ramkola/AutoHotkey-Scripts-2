#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\constants.ahk
#Include lib\strings.ahk
#Include lib\utils.ahk
#NoEnv
;#Warn
SendMode Input
SetWorkingDir %A_ScriptDir%
#SingleInstance Force
;#Persistent
SetTitleMatchMode 1		; necessary so that it doesn't get confused with "SciTE4AutoHotkey Help" file

; ****************************************************
;
; AutoHotkey.chm sidebar must be open for this to work.
;                         
; You can do this by opening the help file. If the sidebar is
; not open then click on the Menu Icon (4 horizontal bars). 
; Close the help file to save the setup.
;
; Help file sidebar is the panel on the left with "Content"
; "Index" "Search" headings with a search box and match list.
;
; **************************************************

helpfile_path := "C:\Program Files\AutoHotkey\AutoHotkey.chm"
helpfile_wintitle := "AutoHotkey Help ahk_class HH Parent ahk_exe hh.exe"
helpfile_url := "https://autohotkey.com/docs/AutoHotkey.htm"
WinGet, hWind_editor, ID, A
 
; Select and copy current word in editor.
saved_clipboard := ClipboardAll

Clipboard := select_and_copy_word()

openmode := open_helpfile(helpfile_path, helpfile_url, helpfile_wintitle, save_clipboard)

if openmode = 1
    activate_window(helpfile_wintitle, save_clipboard)
if openmode = 2
{
    browser_name := default_browser()
    If InStr(browser_name, "Firefox")
        activate_window("ahk_class MozillaWindowClass ahk_exe firefox.exe", save_clipboard)
    Else if InStr(browser_name, "Chrome")
        activate_window("ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe", save_clipboard)
    Else
    {
        msg := "Unexpected browser:`n`n" browser_name
        error_handler(msg, save_clipboard)       
    }
}

WinGetTitle, helpfile_wintitle, A 
; output_debug("helpfile_wintitle: " . "|" . helpfile_wintitle . "|")
if !WinActive(helpfile_wintitle)
{
    MsgBox, 48,, "Couldn't activate help file:`n`n" %helpfile_wintitle% 
    ExitApp
}
WinMaximize
;
; paste word in help file's 'Search Index' box and hit enter 
Sleep 100
SetKeyDelay 10
SendEvent {Alt Down}n{Alt Up}
SendEvent {Home}{Shift Down}{End}{Shift Up}^v
Sleep 100
Send {Enter}
;
; WinActivate, ahk_id %hWind_editor%
Clipboard := save_clipboard

ExitApp

open_helpfile(p_fname, p_url, p_wintitle, p_save_clipboard)
{
    Try 
    {
        If WinExist(p_wintitle)
            open_mode := 1  ; local helpfile       
        Else If FileExist(p_fname)
        {
            Run, %p_fname%
            open_mode := 1
        }
        Else If (p_url != "")
        {
            Run, %p_url%
            open_mode := 2
        }
        Else
            error_handler("Could not find the help file:`n`n" p_fname, p_save_clipboard)
    } 
    Catch e 
        error_handler("Unexpected error opening help file:`n" p_fname "`n`nError# " e, p_save_clipboard, ErrorLevel)

    Return %open_mode%
}


activate_window(p_window, p_save_clipboard)
{
    countx := 0
    While !WinActive(p_window) and (countx < 100)
    {
        WinActivate, %p_window%
        WinWaitActive, %p_window%,, 1
        countx++
    }
    If !WinActive(p_window)
        error_handler("Could not activate window:`n`n" p_window, p_save_clipboard)
}


error_handler(p_msg, p_clipboard, p_errorlevel:=99999)
{
    msg_title := A_ScriptName "     "
    MsgBox, 48, %msg_title%, %p_msg% `n`nErrorLevel: %p_errorlevel%
    Clipboard := p_clipboard
    ExitApp
}