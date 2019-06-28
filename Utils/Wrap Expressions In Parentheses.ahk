#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\strings.ahk

; out of character class: \.*?+[{|()^$   |||   in character class: ^-]\
new_line := cut_current_line()
expression_delimeters = [*+-/]
operator_delimeters = [.:+-=*<>!]*[=*/+\-!<>]+
bracket_delimeters = If|While|Until|And|Or|Return|%expression_delimeters%
found_pos := RegExMatch(new_line, "i)(" bracket_delimeters ")")
If (found_pos = 0)
    Goto EXIT_BRACKETS

start_pos := 1
While found_pos
{
	; .   "(?P<brackets>\s*""*\w+\s*""*" operator_delimeters ".*?)"
	found_pos := RegExMatch(new_line, "iO)(" bracket_delimeters ")", match, start_pos)
	If found_pos
	{
		new_line := RegExReplace(new_line
		, "iC)(?P<before>(^.*" bracket_delimeters ")(\s+))"
		.   "(?P<brackets>\s*\x22*\w+\s*\x22*" operator_delimeters ".*?)"
		.   "(?P<after>((\s+(And|Or|\?).*$)|$))"
		,   "${before}`(${brackets}`)${after}", replaced_count, -1, start_pos)
		start_pos := found_pos + match.len(1)
	}
}

EXIT_BRACKETS:
SetKeyDelay -1
new_line := StrReplace(trim(new_line), "`r", "")
new_line := StrReplace(trim(new_line), "`n", "")
SendRaw %new_line%
SendInput {Enter}
ExitApp
