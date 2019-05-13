#SingleInstance Force
SetTitleMatchMode RegEx

wintitle_regex = i).*(YouTube|WatchSeries|DailyMotion).*\s-\sGoogle Chrome
If Not WinExist(wintitle_regex)
{
    MsgBox, 48,, % "No Chrome page matches: " wintitle_regex, 2
    Goto SEARCH_EXIT
}
WinGetTitle, actual_wintitle, %wintitle_regex%

If Instr(actual_wintitle, "Watchseries - Google Chrome")
    history_search_term := RegExReplace(actual_wintitle, "i)^(Watch|Info)\s(.*)\s-\sSeason\s\d+\s.*$", "$2")
Else If Instr(actual_wintitle, "YouTube - Google Chrome")
    history_search_term := RegExReplace(actual_wintitle, "i)^(.*)YouTube - Google Chrome$", "$1")
Else
{
    MsgBox, 48,, % "Don't know how to process wintitle:`r`n" actual_wintitle, 2
    Goto SEARCH_EXIT
}
; remove any character that's not a space, letter or number
history_search_term := RegExReplace(history_search_term, "i)([^ a-z0-9])*", "") 

SetTitleMatchMode 3 ; Works better than RegEx when the title is known, avoids need to escape RegEx chars.
WinActivate, %actual_wintitle%
Sleep 1500
SendInput ^h
Sleep 1500
If WinActive("History - Google Chrome")
    SendInput, %history_search_term%{Enter}
Else
{
    MsgBox, 48,, % "Could not activate Google History search page.", 2
    Goto SEARCH_EXIT
}
SEARCH_EXIT:
; WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
ExitApp