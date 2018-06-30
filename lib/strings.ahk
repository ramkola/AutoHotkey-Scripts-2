;-------------------------------------------------------------------------
;   Functions.ahk (polyethene's)
;
;   This will be included automatically when strings.ahk is included.
;-------------------------------------------------------------------------
#Include lib\Wrapper for Functions with Output Vars.ahk 
;----------------------------------------------------------------------------------------------------------
;   check_selection_copy(p_max_chars:=0, p_max_lines:=0, p_max_words:=0)  
;
;   Checks if text is selected and returns the selection.
;   If no text is selected or the selection is done in column 
;   mode (alt+shift+arrowkey) then an empty string is returned.
;
;   Optional parameters let you limit the type of selection. 
;   For example if your program needs exactly 1 character selected
;   you can set p_max_chars to 1.
;   
;   p_max_chars - Maximum number of characters allowed to be selected.
;   (optional)    If 0 or not passed then all selected text is returned.
;
;   p_max_lines - Maximum number of lines the selection can have.
;   (optional)    If 0 or not passed then all selected text is returned. 
;
;   p_max_words - Maximum number of words allowed to be selected. 
;   (optional)    If 0 or not passed then all selected text is returned. 
;                 Pass p_max_chars = 0 if you want to only limit words and not characters.
;
;           NOTE: RegEx "(\b\w+\b)" definition of a word. Meaning a phrase like: trim(fields[A_Index])
;                 will count as 3 words because it has "(" and "[" word separators. A phrase like: p_max_chars:=0 
;                 counts as 2 words because ":" and "="  separates p_max_chars and 0. "0" is considered a valid word 
;                 therefore 2 words have been selected. Default defintion of a word is having 1 or more of the following 
;                 characters [A-Za-z0-9_].
;   Examples:
;     x := check_selection_copy()      ; check that text is selected and copy it - no limits.
;     x := check_selection_copy(1)     ; check that at most 1 character is selected.   
;     x := check_selection_copy(10,1)  ; check that at most 10 characters on 1 line are selected.
;     x := check_selection_copy(0,2,5) ; check that at most 5 words across at most 2 lines are selected.
;           
;   Notes: 
;       When limiting a selection across multiple lines the 2 characters that are the "CR" and "LF"
;       between each line are not included. For example: if only the numbers below are supposed to be
;       selected then you would pass (6,2) not (8,2) - the CRLF after "123" is ignored. If you want
;       to include the CRLF after "456" then you would pass (6,3) as the allowable selection limit. 
/*
123
456
*/
;       You can see the current selection in the status bar so set up an example of the selection
;       you want to allow and read the parameters from the status bar: Sel: <chars> | <lines>.
;
;--------------------------------------------------------------------------------------------------------
check_selection_copy(p_max_chars:=0, p_max_lines:=0, p_max_words:=0)
{
    sel_length := get_statusbar_info("selectionlength")
    sel_lines := get_statusbar_info("selectionlines")
    p_max_chars := (p_max_chars = 0) ? sel_length : p_max_chars
    p_max_lines := (p_max_lines = 0) ? sel_lines : p_max_lines
    if (sel_lines > 1)
        sel_length := sel_length - (2 * sel_lines)
    if (sel_length = 0)
        Return  ; nothing selected return empty string

    if (sel_length > p_max_chars) or (sel_lines > p_max_lines)
        Return  ; selection doesn't meet the max requirements - return empty string

    ; copy selected text    
    saved_clipboard := ClipboardAll
    Clipboard := ""
    SendInput ^c
    ClipWait,,1
    result := Clipboard
    Clipboard := saved_clipboard    

    ; check for max word limit
    if (p_max_words > 0)
    {
        result := RegExReplace(result,"(\b[A-Za-z0-9_]+\b)","$1",word_count)
        if (word_count > p_max_words)
            result := ""
    }
    Return %result%
}
;-------------------------------------------------------------------------
;   get_scintilla_function(p_id:="", p_function:="")
;
;   If p_id is given it will return function name.
;   If p_function is given it will return id.
;   Returns empty string if nothing found. 
;   
;-------------------------------------------------------------------------
get_scintilla_function(p_id:="", p_function:="")
{
    if (p_id == "") and (p_function == "")
        return 
        
    scintilla_function_file := "lib\scintilla_function_ids.txt"
    FileRead, in_file_var, %scintilla_function_file%
  
    Loop, Parse, in_file_var, `n, `r
    {
        scint_id := substr(A_LoopField,1,4)
        scint_function := substr(A_LoopField,6)
        if (scint_id == p_id)
            Return scint_function
        if (scint_function = p_function)
            Return scint_id
    }
    Return
}
;-------------------------------------------------------------------------
;   get_statusbar_info(p_info_type) 
;
;   Returns status bar text info
;   Acceptable parameters: lang, flen, numlines, caretx, carety, selectionlength, selectionlines, crlf, encode, ins
;-------------------------------------------------------------------------
get_statusbar_info(p_info_type) {
    StringLower, p_info_type, p_info_type
    if p_info_type not in lang,flen,numlines,caretx,carety,selectionlength,selectionlines,crlf,encode,ins
        return "Acceptable parameters: lang, flen, numlines, caretx, carety
               , selectionlength, selectionlines, crlf, encode
               , ins. You sent >" p_info_type "<"
    Loop, 6
        StatusBarGetText, statusbar_text%A_Index%, %A_Index%, ahk_exe notepad++.exe
    
    ; Status bar text from part #1
    language:= trim(statusbar_text1)
    
    ; Status bar text from part #2
    RegExMatch(statusbar_text2, "(?<=length\s:\s)[\d|,]+(?=\s+lines)", file_length_bytes)
    nocommas := StrReplace(file_length_bytes, ",", "")
    file_length_bytes := (nocommas == "") ? file_length_bytes : nocommas
    
    RegExMatch(statusbar_text2, "(?<=lines\s:\s)[\d|,]+", file_num_lines)
    nocommas := StrReplace(file_num_lines, ",", "")
    file_num_lines := (nocommas == "") ? file_num_lines : nocommas
    
    ; Status bar text from part #3
    RegExMatch(statusbar_text3, "(?<=Ln\s:\s)\d+", caret_line)
    RegExMatch(statusbar_text3, "(?<=Col\s:\s)\d+", caret_col)
    if Instr(statusbar_text3, "Sel : N/A")
    {
        selection_len := ""
        lines_selected := ""
    }    
    else
    {
        RegExMatch(statusbar_text3, "(?<=Sel\s:\s)\d+", selection_len)
        ; RegExMatch(statusbar_text3, "(?<=Sel\s:\s\d+\s\|\s)\d+", lines_selected) ; don't know why this doesn't work
        pos := InStr(statusbar_text3, " | ", pos) + 3
        lines_selected := SubStr(statusbar_text3, pos)
    }
    
    ; Status bar text from part #4
    crlf := trim(statusbar_text4)
    
    ; Status bar text from part #5
    encoding := trim(statusbar_text5)
    
    ; Status bar text from part #6
    ins_ovr := trim(statusbar_text6)
    
    if (p_info_type == "lang")
        return %language%
    else if (p_info_type == "flen")
        return %file_length_bytes%
    else if (p_info_type == "numlines")
        return %file_num_lines%
    else if (p_info_type == "caretx")
        return %caret_line%
    else if (p_info_type == "carety")
        return %caret_col%
    else if (p_info_type == "selectionlength")
        return %selection_len%
    else if (p_info_type == "selectionlines")
        return %lines_selected%
    else if (p_info_type == "crlf")
        return %crlf%
    else if (p_info_type == "encode")
        return %encoding%
    else if (p_info_type == "ins")
        return %ins_ovr%
    else
        return "Unexpected p_info_type"
}
;------------------------------------------------------------------------------
; Returns the fullpath of the current file being edited in Notepad++ 
; To get the filename only without the path, pass True for the parameter.
;------------------------------------------------------------------------------
get_current_npp_filename(p_fname_only := False) 
{
    WinGetTitle, current_file, A
    RegExMatch(current_file, ".*(?=\s-\sNotepad++)", fname)
    if (SubStr(fname,1,1) == "*")  
        fname := Substr(fname, 2)
    if p_fname_only
    {
        SplitPath, fname, out_filename
        fname := out_filename
    }
    Return %fname%
}
;-------------------------------------------------------------------------
;   select_and_copy_word()
;
;   Returns the selected word or empty string if no valid word selected.
;-------------------------------------------------------------------------
select_and_copy_word()
{
    save_x := A_CaretX
    save_y := A_CaretY
    MouseGetPos, save_x, save_y, save_hwnd, save_classnn, 3 
    save_clipboard := ClipboardAll

    ; check if user selected a word. If so return the selected word.
    sel_len := get_statusbar_info("selectionlength") 
    if (sel_len > 0)
    {
        Clipboard := ""
        SendInput ^c
        ClipWait,,1
        word := Clipboard
        Goto RETURNNOW
    }
    ;
    ; No word selected so retrieve word found at cursor position
    ;
    ;-----------------------
    ;  char_left_of_word
    ;-----------------------
    ; Check 1 character left of selected word looking for accepted character(s) 
    ; that aren't included in the keyboard selection (ie # in #Include)
    Clipboard := ""
    SendInput +{Left}
    SendInput ^c
    ClipWait,1
    char_left_of_word := Clipboard
    If (char_left_of_word == "")
        ; cursor was at the begining of the file at the beginning of the first word
        donothing := True
    Else
        SendInput {Right}   ; set cursor back to original position
    ;-----------------------
    ;  cursor_at_char1
    ;-----------------------
    ; Assume cursor was placed at the beginning of the word then
    ; Select and copy from cursor position to the end of the word.
    Clipboard := ""
    SendInput ^+{Right}
    SendInput ^c
    ClipWait,1
    cursor_at_char1 := Clipboard
    SendInput {Left}   ; set cursor back to original position
    ;-----------------------
    ;  cursor_after_char1
    ;-----------------------
    ; Assume cursor is anywhere after the first character of the word.
    ; Position cursor to leftmost word boundary then select and copy to the end of the word.
    Clipboard := ""
    if (cursor_at_char1 == "#")
        ; cursor was at word that began with a # sign (ie: #If, #Include)
        SendInput +{Right}^+{Right}
    else
        ; cursor was somewhere in the middle so go to beginning and select word right
        SendInput ^{Left}^+{Right}
    
    SendInput ^c
    ClipWait,1
    cursor_after_char1 := Clipboard
    SendInput {Left}{Right}     ; get rid of selection highlighting
    
        ; output_debug("char_left_of_word: " . "|" . char_left_of_word . "|")
        ; output_debug("cursor_at_char1: " . "|" . cursor_at_char1 . "|")
        ; output_debug("cursor_after_char1: " . "|" . cursor_after_char1 . "|")
    
    ;  A description of the regular expression:
    ;  
    ;  [1]: A numbered capture group. [#|[a-zA-Z]], exactly 1 repetitions
    ;      Select from 2 alternatives
    ;          #
    ;          Any character in this class: [a-zA-Z]
    ;  [2]: A numbered capture group. [[a-zA-Z]|_], any number of repetitions
    ;      Select from 2 alternatives
    ;          Any character in this class: [a-zA-Z]
    ;          _
    ;
    regex_word := "#?\b([a-zA-Z]|_)*\b"
    pos_at := RegExMatch(cursor_at_char1, regex_word, match)
    pos_after := RegExMatch(cursor_after_char1, regex_word, match)
        ; output_debug("pos_at: " . "|" . pos_at . "|")
        ; output_debug("pos_after: " . "|" . pos_after . "|")
        
    If (pos_at = 1 and pos_after = 1)
    {
        ; if cursor was at the beginning of a word preceded by a space and another word
        ; use the cursor_at word. (ie: WordA |WordB )  "|" shows cursor placement.    
    
        ; if cursor was somewhere in the middle of the word:
        ; cursor_at has part of the word, cursor_after has the WHOLE word so use that.
        ; (ie: W|ord ... Wo|rd ...Wor|d ... )  "|" shows cursor placement.        
        If (char_left_of_word == " ")
            word := cursor_at_char1
        Else
            word := cursor_after_char1
    }        
    Else If (pos_at = 1 and pos_after = 0)
        ; cursor was at the beginning of the first word on the line.
        ; cursor_at has the WHOLE word we want, cursor_after has CrLf
        word := cursor_at_char1
    Else If (pos_at = 0 and pos_after = 1)
        ; cursor was at end of the word
        ; cursor_at has part of the word, cursor_after has the whole word we want.
        word := cursor_after_char1
    Else If (pos_at = 0 and pos_after = 0)
        ; 
        ; cursor_at has part of the word, cursor_after has the whole word we want.
        word := cursor_after_char1
    Else If (pos_at > 1 and pos_after = 1)
    {
        ; cursor was at end of the word. (ie WordA| ... WordB ) "|" shows cursor placement    
        ; cursor_at has part of the next word preceded by a space, cursor_after has the whole word we want
        word := cursor_after_char1
        ; check again
        Clipboard := ""
        SendInput +{Left}
        SendInput ^c
        ClipWait,1
        char_left_of_word := Clipboard
        if char_left_of_word == "#"
            word := "#" . cursor_after_char1
        else
            word := cursor_after_char1
    }
    Else 
    {
        MsgBox, 48,, % "Unexpected word selected.`ncursor_at: " cursor_at "`n cursor_after_char1: " cursor_after_char1, 5
        word := ""
        Goto RETURNNOW
    }
RETURNNOW:
    Clipboard := save_clipboard
    Sleep 10
    MouseMove, %save_x%, %save_y%
    ; OutputDebug, % save_x ", " save_y ", " save_hwnd ", " save_classnn 
    Return %word%
}
;------------------------------------------------------------------------- 
; Returns a number formatted with the required commas.
;-------------------------------------------------------------------------
1000s_sep(p_number, p_separator=",")
{
   return RegExReplace(p_number, "\G\d+?(?=(\d{3})+(?:\D|$))", "$0" p_separator)
}
;-------------------------------------------------------------------------
;   inlist(p_haystack, p_matchlist, p_case=False)
;
; Note: Does not process empty string "" correctly.
; Returns true when comp string is an exact match to one of the
; values in find_list array. This is better than "if in" statement
; that returns the matched string instead of true or false.
; Example: 
;        mylist := ["oranges","pears","bananas","cigarettes"]
;        mystring = pears
;        if inlist(mystring, mylist) 
;            MsgBox Found 
;        else
;            MsgBox Not Found 
;-------------------------------------------------------------------------
inlist(p_haystack, p_matchlist, p_case=False)
{
    for index, needle in p_matchlist
    {
        if Instr(p_haystack, needle, p_case)
            Return True
    }
    Return False
}
;-------------------------------------------------------------------------
;   isempty_string(p_string, p_trim:=0, p_msgbox:=False)
;
; Returns True or False if string is empty
; Example:
;   if isempty_string(chr(13), 1, True)
;   x := isempty_string("My string!")
;-------------------------------------------------------------------------
isempty_string(p_string, p_trim:=0, p_msgbox:=False)
{
    ; if p_trim = 0 do nothing
    if p_trim = 1
        p_string := trim(p_string)
    if p_trim = 2
        p_string := Ltrim(p_string)
    if p_trim = 3
        p_string := Rtrim(p_string)

    if (p_string = "") and p_msgbox
        msgbox % "Empty"
    if (p_string != "") and p_msgbox
        msgbox % "Not Empty: |" p_string "|"
   
    Return (p_string = "")
}   
 