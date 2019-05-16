#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\strings.ahk

new_line := cut_current_line()
;       \.*?+[{|()^$
operator_delimeters = [.:+-=*<>!]*[=*/+\-!<>]+
bracket_delimeters = If|While|Until|And|Or|Return|%operator_delimeters%
found_pos := RegExMatch(new_line, "i)(" bracket_delimeters ")")
If (found_pos = 0)
    Goto EXIT_BRACKETS

start_pos := 1
While found_pos
{
		; .   "(?P<brackets>\s*""*\w+\s*""*" operator_delimeters "\s*""*\w*""*)"
	found_pos := RegExMatch(new_line, "iO)(" bracket_delimeters ")", match, start_pos)
	If found_pos
	{
		new_line := RegExReplace(new_line
		, "i)(?P<before>(^.*" bracket_delimeters ")(\s+))"
		.   "(?P<brackets>\s*""*\w+\s*""*" operator_delimeters ".*?)"
		.   "(?P<after>((\s+(And|Or|\?).*$)|$))"
		,   "${before}`(${brackets}`)${after}", replaced_count, -1, start_pos)
		start_pos := found_pos + match.len(1)
	}
}

EXIT_BRACKETS:
SetKeyDelay -1

OutputDebug, DBGVIEWCLEAR
; new_line := StrReplace(trim(new_line), "`r", "")
; new_line := StrReplace(trim(new_line), "`n", "")
x:=StrSplit(new_line)
For i, j In x
{
    OutputDebug, % j " - " asc(j)
}
SendRaw %new_line%
WinActivate, ahk_class Notepad++ ahk_exe notepad++.exe
WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe

ExitApp