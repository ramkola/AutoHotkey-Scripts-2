#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\strings.ahk
#Include lib\constants.ahk
SetWorkingDir %AHK_ROOT_DIR%
SetTitleMatchMode 3
google_wintitle = Google - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
search_term := select_and_copy_word()
If (search_term == "")
{
    MsgBox, 48,, % "Nothing selected", 2
    Return
}

RunWait, MyScripts\Utils\Web\activate Browser.ahk 
WinWaitActive, %google_wintitle%,,1
If ErrorLevel
{
    Run, https://www.google.ca/
    WinWaitActive, %google_wintitle%,,5
    If ErrorLevel
        ExitApp
}
Sleep 100
SendInput %search_term%{Enter}
ExitApp


