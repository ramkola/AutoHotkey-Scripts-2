select_and_copy_word()
{
    save_x := A_CaretX
    save_y := A_CaretY
    MouseGetPos, save_x, save_y, save_hwnd, save_classnn, 3 
    save_clipboard := ClipboardAll

    ; check if user selected a word. If so return the selected word.
    sel_len := get_statusbar_info("selectionlength") 
    If (sel_len > 0)
    {
        Clipboard := ""
        SendInput ^c
        ClipWait, 1
        word := Clipboard
        Goto RETURN_NOW99
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
    If (cursor_at_char1 == "#")
        ; cursor was at word that began with a # sign (ie: #If, #Include)
        SendInput +{Right}^+{Right}
    Else
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
        
    If (pos_at = 1 And pos_after = 1)
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
    Else If (pos_at = 1 And pos_after = 0)
        ; cursor was at the beginning of the first word on the line.
        ; cursor_at has the WHOLE word we want, cursor_after has CrLf
        word := cursor_at_char1
    Else If (pos_at = 0 And pos_after = 1)
        ; cursor was at end of the word
        ; cursor_at has part of the word, cursor_after has the whole word we want.
        word := cursor_after_char1
    Else If (pos_at = 0 And pos_after = 0)
        ; 
        ; cursor_at has part of the word, cursor_after has the whole word we want.
        word := cursor_after_char1
    Else If (pos_at > 1 And pos_after = 1)
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
        If char_left_of_word == "#"
            word := "#" . cursor_after_char1
        Else
            word := cursor_after_char1
    }
    Else 
    {
        MsgBox, 48,, % "Unexpected word selected.`ncursor_at: " cursor_at "`n cursor_after_char1: " cursor_after_char1, 5
        word := ""
        Goto RETURN_NOW99
    }
RETURN_NOW99:
    Clipboard := save_clipboard
    Sleep 10
    MouseMove, %save_x%, %save_y%
    Return %word%
}
;-------------------------------------------------------------------------
;   isempty_string(p_string, p_trim:=0, p_msgbox:=False)
;
; Returns True or False if string is empty
; Examples:
;   if isempty_string(chr(13), 1, True)
;   x := isempty_string("My string!")
;-------------------------------------------------------------------------
isempty_string(p_string, p_trim:=0, p_msgbox:=False)
{
    ; if p_trim = 0 do nothing
    If p_trim = 1
        p_string := Trim(p_string)
    Else If p_trim = 2
        p_string := LTrim(p_string)
    Else If p_trim = 3
        p_string := RTrim(p_string)

    If (p_string = "") And p_msgbox
        MsgBox % "Empty"
    Else
        If p_msgbox
            MsgBox % "Not Empty: |" p_string "|"
   
    Return (p_string = "")
}