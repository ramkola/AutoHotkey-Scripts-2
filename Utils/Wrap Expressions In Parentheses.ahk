saved_clipboard := ClipboardAll
Clipboard := ""
Sleep 10
SendInput !{Home}+{End}^x
ClipWait, 2
new_line := Clipboard

;       \.*?+[{|()^$
bracket_delimeters = If|While|Until|And|Or|Return
found_pos := RegExMatch(new_line, "i)\b(" bracket_delimeters ")\b")
If (found_pos = 0)
{
    ; wrap whatever was selected in brackets excluding leading whitespace and comments
	new_line := RegExReplace(new_line,"(^(;|/\*|\s)*.*?)(\w.*$)", "$1`($3`)") 
	Goto EXIT_BRACKETS
}

start_pos := 1
While found_pos
{
	found_pos := RegExMatch(new_line, "iO)\b(" bracket_delimeters ")\b", match, start_pos)
	If found_pos
	{
		new_line := RegExReplace(new_line
		, "i)(?P<before>(^.*\b" bracket_delimeters "\b)(\s+))"
		.   "(?P<brackets>\w.*?)"
		.   "(?P<after>((\s+(And|Or).*$)|$))"
		,   "${before}`(${brackets}`)${after}", replaced_count,,start_pos)
		start_pos := found_pos + match.len(1)
	}
}

EXIT_BRACKETS:
    SetKeyDelay -1
    SendRaw %new_line%
    Clipboard := saved_clipboard
    ExitApp
