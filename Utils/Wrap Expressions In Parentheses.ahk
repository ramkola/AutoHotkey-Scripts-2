saved_clipboard := ClipboardAll
Clipboard := ""
Sleep 10
SendInput !{Home}+{End}^x
ClipWait, 2
new_line := Clipboard

;       \.*?+[{|()^$
bracket_delimeters = If|While|Until|And|Or|Return|[.:+-=<>!]*=
found_pos := RegExMatch(new_line, "i)(" bracket_delimeters ")")
If (found_pos = 0)
    Goto EXIT_BRACKETS

start_pos := 1
While found_pos
{
	found_pos := RegExMatch(new_line, "iO)(" bracket_delimeters ")", match, start_pos)
	If found_pos
	{
		new_line := RegExReplace(new_line
		, "i)(?P<before>(^.*" bracket_delimeters ")(\s+))"
		.   "(?P<brackets>\w.*?)"
		.   "(?P<after>((\s+(And|Or).*$)|$))"
		,   "${before}`(${brackets}`)${after}", replaced_count, -1, start_pos)
		start_pos := found_pos + match.len(1)
	}
}

EXIT_BRACKETS:
SetKeyDelay -1
SendRaw %new_line%
Clipboard := saved_clipboard
ExitApp
/* 
    old code
*/
; saved_clipboard := ClipboardAll
; Clipboard := ""
; Sleep 10
; SendInput !{Home}+{End}^x
; ClipWait, 2
; new_line := Clipboard

; ;       \.*?+[{|()^$
; bracket_delimeters = If|While|Until|And|Or|Return
; found_pos := RegExMatch(new_line, "i)\b(" bracket_delimeters ")\b")
; If (found_pos = 0)
; {
    ; new_line := wrap_right_of_symbols(new_line)
    ; Goto EXIT_BRACKETS
; }

; start_pos := 1
; While found_pos
; {
	; found_pos := RegExMatch(new_line, "iO)\b(" bracket_delimeters ")\b", match, start_pos)
	; If found_pos
	; {
		; new_line := RegExReplace(new_line
		; , "i)(?P<before>(^.*\b" bracket_delimeters "\b)(\s+))"
		; .   "(?P<brackets>\w.*?)"
		; .   "(?P<after>((\s+(And|Or).*$)|$))"
		; ,   "${before}`(${brackets}`)${after}", replaced_count, -1, start_pos)
		; start_pos := found_pos + match.len(1)
	; }
; }

; EXIT_BRACKETS:
    ; SetKeyDelay -1
    ; SendRaw %new_line%
    ; Clipboard := saved_clipboard
    ; ExitApp

; wrap_right_of_symbols(new_line)
; {
    ; bracket_delimeters_symbols = [.:+-=<>!]*=           ; note: nothing in square brackets needs to be escaped
    ; found_pos := RegExMatch(new_line, "i)" bracket_delimeters_symbols)
    ; start_pos := 1
    ; While found_pos
    ; {
        ; found_pos := RegExMatch(new_line, "iO)" bracket_delimeters_symbols , match, start_pos)
        ; If found_pos
        ; {
            ; ; same as above without word boundary delimiters "\b"
            ; new_line := RegExReplace(new_line
            ; , "i)(?P<before>(^.*" bracket_delimeters_symbols ")(\s+))"
            ; .   "(?P<brackets>\w.*?)"
            ; .   "(?P<after>((\s+(And|Or).*$)|$))"
            ; ,   "${before}`(${brackets}`)${after}", replaced_count, -1, start_pos)
            ; start_pos := found_pos + match.len(1)
        ; }
    ; }
    ; Return new_line
; }