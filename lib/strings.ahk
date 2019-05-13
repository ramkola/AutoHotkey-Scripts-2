;----------------------------------------------------
; is_ahk_script: returns either 1 or 0 if the file
; has an .ahk extension. If no filename is passed 
; A_ScriptName is used.
;----------------------------------------------------
is_ahk_script(p_filename:= "")
{
    p_filename := (p_filename == "") ? A_ScriptName : p_filename
    file_type := SubStr(p_filename,-3)
    Return (file_type = ".ahk")
}
;---------------------------------------------------------------------------------------------
;   Returns the classNN for a given control handle in a given window handle
;---------------------------------------------------------------------------------------------
get_classnn(p_hwnd_window, p_hwnd_control)
{
    saved_detect_hidden_windows := A_DetectHiddenWindows
    DetectHiddenWindows, On
	WinGet, classnn_list, ControlList, ahk_id %p_hwnd_window%
	Loop, PARSE, classnn_list, `n
	{
		ControlGet, hwnd_list, hwnd,, %A_LoopField%, ahk_id %p_hwnd_window%
		If (hwnd_list = p_hwnd_control)
        {
			result := A_LoopField
            Break
        }
	}
    DetectHiddenWindows, %saved_detect_hidden_windows%
    Return result
}
;---------------------------------------------------------------------------------------------
;   displays the active window's wintitle in a tooltip message 
;---------------------------------------------------------------------------------------------
display_active_wintitle(p_sleep_interval=5000, p_x=0, p_y=0)
{
    WinGetActiveTitle, active_wintitle
    font_size = 12
    win_width := StrLen(active_wintitle) * (font_size * .65)
    Progress, w%win_width% x%p_x% y%p_y% b cwFFFFAA fm%font_size% zh0, %active_wintitle%, , , Arial
    Sleep, p_sleep_interval
    Progress, Off
    Return    
}
;---------------------------------------------------------------------------------------------
; Gets the filename from any active window title that has the following format:
;					<filepath> - <application name><other stuff> 
;      C:\Users...\strings.ahk - Notepad++
;
; It handles filenames that might have '*' indicating an unsaved file like:
;	*<filepath> - Notepad++ (is a Notepad++ unsaved file)
;	<filepath> * SciTE4AutoHotkey [3 of 4] (is a SciTE unsaved file)
;
;---------------------------------------------------------------------------------------------
get_filepath_from_wintitle(p_wintitle:="A", p_fname_only := False) 
{
	WinGetTitle, current_file, %p_wintitle%
	current_file := RegexReplace(current_file, "^\*?(.*)\s[-|\*]\s\w+.*$", "$1")  
	If p_fname_only
		SplitPath, current_file, current_file
	Return current_file 
}
;-------------------------------------------------------------------------
;   format_seconds(p_seconds)  
;
;   Convert the specified number of seconds to hh:mm:ss format.
;
;-------------------------------------------------------------------------
format_seconds(p_seconds)  
{
    time = 19990101  ; *Midnight* of an arbitrary date.
    time += %p_seconds%, seconds
    FormatTime, mmss, %time%, mm:ss
    Return p_seconds//3600 ":" mmss
}
;-------------------------------------------------------------------------
;   create_script_outfile(p_subdir, p_scriptname)
;
;-------------------------------------------------------------------------
create_script_outfile_name(p_scriptfullpath)
{
    SplitPath, p_scriptfullpath, out_filename, out_dir, out_extension, out_namenoext, out_drive
    out_file := out_dir "\zzz-" out_namenoext ".txt" 
    Return %out_file%
}
;-------------------------------------------------------------------------
;   remove_duplicate_entries(p_entries)
;   
;   Parameter:
;       p_entries - string delimited with linefeed `n OR 1 dimensional array
;       p_delimeter - 
;
;
;   Returns a 1 dimensional array (list) of unique elements
;-------------------------------------------------------------------------
remove_duplicate_entries(p_entries, p_delimeter:= "`n")
{
    
    If (p_entries.Count() == "")
        ; a delimited string was passed
        check_for_dups_array := StrSplit(p_entries, p_delimeter)
    Else If (p_entries.Count() >= 0)
        ; an array has been passed
        check_for_dups_array := p_entries
    Else    
        Return ""

    ; skip duplicate entries
    unique_keys_list := {}
    For i, entry in check_for_dups_array
    {

        ; if the last entry in the file doesn't have CrLf and there is a duplicate entry somewhere else in the file with a CrLf it would 
        ; treat them as 2 unique entries. That's why CrLf has to be removed. I don't know why it can't be done in 1 StrReplace command.
        entry := StrReplace(entry,"`r","")  
        entry := StrReplace(entry,"`n","")  
        If (unique_keys_list[entry] == entry)               ;.haskey(entry)) don't know why haskey doesn't work
            donothing := True ; skip continue
        Else
        {
            keyname := chr(34) entry chr(34)
            unique_keys_list[keyname] := entry
        }
    }
    ; create a 1 dimensional array (list) from 
    ; the above associative array of unique keys
    result := []
    For key, value in unique_keys_list
        result.Push(key)
    Return %result%
}
;-------------------------------------------------------------------------
;   string_reverse(p_string)
;
;
;-------------------------------------------------------------------------
string_reverse(p_string)
{
    Loop, Parse, p_string
        reversed_string := A_LoopField . reversed_string

    Return %reversed_string%
}
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
;                 characters [A-Za-z0-9_]. In Notepad++ Settings/Preferences/Delimiter I have added the 
;                 pound sign "#" to the default definition of a word to include compiler directives like
;                 #Include, #If, #SingleInstance etc... when selecting a word.
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
;--------------------------------------------------------------------------------------------------------
check_selection_copy(p_max_chars:=0, p_max_lines:=0, p_max_words:=0)
{
    sel_length := get_statusbar_info("selectionlength")
    sel_lines := get_statusbar_info("selectionlines")
    p_max_chars := (p_max_chars = 0) ? sel_length : p_max_chars
    p_max_lines := (p_max_lines = 0) ? sel_lines : p_max_lines
    If (sel_lines > 1)
        sel_length := sel_length - (2 * sel_lines)
    If (sel_length = 0)
        Return  ; nothing selected return empty string

    If (sel_length > p_max_chars) or (sel_lines > p_max_lines)
        Return  ; selection doesn't meet the max requirements - return empty string

    ; copy selected text    
    saved_clipboard := ClipboardAll
    Clipboard := ""
    SendInput ^c
    ClipWait, 1
    result := Clipboard
    Clipboard := saved_clipboard    

    ; check for max word limit
    If (p_max_words > 0)
    {
        result := RegExReplace(result,"(\b[A-Za-z0-9_]+\b)","$1",word_count)
        If (word_count > p_max_words)
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
    If (p_id == "") And (p_function == "")
        Return 
        
    scintilla_function_file := "lib\scintilla_function_ids.txt"
    FileRead, in_file_var, %scintilla_function_file%
  
    Loop, Parse, in_file_var, `n, `r
    {
        scint_id := SubStr(A_LoopField,1,4)
        scint_function := SubStr(A_LoopField,6)
        If (scint_id == p_id)
            Return scint_function
        If (scint_function = p_function)
            Return scint_id
    }
    Return
}
;-------------------------------------------------------------------------
;   get_statusbar_info(p_info_type) 
;
;   Returns status bar text info
;   Acceptable parameters: lang, flen, numlines, curline, curcol, selectionlength, selectionlines, crlf, encode, ins
;-------------------------------------------------------------------------
get_statusbar_info(p_info_type) 
{
    StringLower, p_info_type, p_info_type
    If p_info_type Not in lang,flen,numlines,curline,curcol,selectionlength,selectionlines,crlf,encode,Ins
        Return "Acceptable parameters: lang, flen, numlines, curline, curcol
               , selectionlength, selectionlines, crlf, encode
               , Ins. You sent >" p_info_type "<"
    If (A_TitleMatchMode = "RegEx")
        npp_wintitle := "ahk_exe notepad\+\+\.exe"
    Else
        npp_wintitle := "ahk_exe notepad++.exe"
    Loop, 6
        StatusBarGetText, statusbar_text%A_Index%, %A_Index%, %npp_wintitle%
    
    ; Status bar text from part #1
    language:= Trim(statusbar_text1)
    
    ; Status bar text from part #2
    RegExMatch(statusbar_text2, "(?<=length\s:\s)[\d|,]+(?=\s+lines)", file_length_bytes)
    nocommas := StrReplace(file_length_bytes, ",", "")
    file_length_bytes := (nocommas == "") ? file_length_bytes : nocommas
    
    RegExMatch(statusbar_text2, "(?<=lines\s:\s)[\d|,]+", file_num_lines)
    nocommas := StrReplace(file_num_lines, ",", "")
    file_num_lines := (nocommas == "") ? file_num_lines : nocommas
    
    ; Status bar text from part #3
    RegExMatch(statusbar_text3, "(?<=Ln\s:\s)[\d|,]+", caret_line)
    caret_line := StrReplace(caret_line, ",", "")
    RegExMatch(statusbar_text3, "(?<=Col\s:\s)[\d|,]+", caret_col)
    caret_col := StrReplace(caret_col, ",", "")
    If InStr(statusbar_text3, "Sel : N/A")
    {
        selection_len := ""
        lines_selected := ""
    }    
    Else
    {
        RegExMatch(statusbar_text3, "(?<=Sel\s:\s)\d+", selection_len)
        Pos := InStr(statusbar_text3, " | ", Pos) + 3
        lines_selected := SubStr(statusbar_text3, Pos)
    }
    
    ; Status bar text from part #4
    crlf := Trim(statusbar_text4)
    
    ; Status bar text from part #5
    encoding := Trim(statusbar_text5)
    
    ; Status bar text from part #6
    ins_ovr := Trim(statusbar_text6)
    
    If (p_info_type == "lang")
        Return %language%
    Else If (p_info_type == "flen")
        Return %file_length_bytes%
    Else If (p_info_type == "numlines")
        Return %file_num_lines%
    Else If (p_info_type == "curline")
        Return %caret_line%
    Else If (p_info_type == "curcol")
        Return %caret_col%
    Else If (p_info_type == "selectionlength")
        Return %selection_len%
    Else If (p_info_type == "selectionlines")
        Return %lines_selected%
    Else If (p_info_type == "crlf")
        Return %crlf%
    Else If (p_info_type == "encode")
        Return %encoding%
    Else If (p_info_type == "ins")
        Return %ins_ovr%
    Else
        Return "Unexpected p_info_type"
}
;------------------------------------------------------------------------------
;   send_msg() wrapper function for SendMessage command. Returns ErrorLevel
;------------------------------------------------------------------------------
;------------------------------------------------------------------------- 
; Returns a number formatted with the required commas.
;-------------------------------------------------------------------------
1000s_sep(p_number, p_separator=",")
{
   Return RegExReplace(p_number, "\G\d+?(?=(\d{3})+(?:\D|$))", "$0" p_separator)
}
;-------------------------------------------------------------------------
;   inlist(p_find_string, p_matchlist, p_case=False)
;
; Note: (this is a bit different from the native if...in... statement)
;   Returns true when comp string is an exact match to one of the
;   values in find_list array. 
;
; Example: 
;        mylist := ["oranges","pears","bananas","cigarettes"]
;        mystring = pears
;        if inlist(mystring, mylist) 
;            MsgBox Found 
;        else
;            MsgBox Not Found 
;-------------------------------------------------------------------------
inlist(p_find_string, p_matchlist, p_case=False)
{
    For index, element in p_matchlist
    {
        result := p_case ? (p_find_string == element) : (p_find_string = element)
        If result
            Return result
    }
    Return False
}
;-------------------------------------------------------------------------
;       display_text(p_text, p_title := "DUMMY TITLE", p_modal := True
;                  , p_font_size:= 12, p_font_name := "Lucida Console"
;                  , p_gui_width := 99999, p_max_row_num := 99999
;                  , p_win_x := 99999, p_win_y := 99999)
;       
;   Displays text in a custom window.
;   The only parameter that needs to sent is p_text
;-------------------------------------------------------------------------
display_text(p_text, p_title := "DUMMY TITLE", p_modal := True
           , p_font_size:= 12, p_font_name := "Lucida Console"
           , p_gui_width := 99999, p_max_row_num := 99999
           , p_win_x := 99999, p_win_y := 99999)
{
    If (p_title == "DUMMY TITLE")
        win_title := p_modal ? "Hit {Escape} to exit..." : "Message Text"
    Else
        win_title := p_title
    ;
    text_array := StrSplit(p_text, "`n", "`r") 
    for i, current_line in text_array
    {
        num_chars := StrLen(current_line)
        If (num_chars > max_chars)
            max_chars := num_chars
    }
    max_chars := (max_chars < StrLen(win_title)) ? StrLen(win_title) : max_chars
    row_count := (p_max_row_num = 99999) ? Round(text_array.Length()/3) : p_max_row_num
    row_count := (row_count < 10) ? 10 : row_count
    row_count := (row_count > 40) ? 50 : row_count
    gui_width := (p_gui_width = 99999) ?  A_ScreenWidth : p_gui_width
    edit_width := (p_gui_width = 99999) ? gui_width - 40 : p_gui_width - 40
    win_x := (p_win_x = 99999) ? "" : "x" p_win_x
    win_y := (p_win_y = 99999) ? "" : "y" p_win_y
    ;
    Gui, 99:Font, s%p_font_size%, %p_font_name%
    Gui, 99:Add, Edit, -Wrap ReadOnly VScroll HScroll r%row_count% w%edit_width%, %p_text%
    SetTimer, 99DESELECT_TEXT, -10
	If p_modal
		Gui, 99:+AlwaysOnTop
    Gui, 99:Show, %win_x% %win_y% w%gui_width%, %win_title%
    If p_modal
        Input,ov, B V ,{Escape}          ; make window modal
    Return

99DESELECT_TEXT:
    SendInput ^{Home}
    Return

99GuiEscape:
99GuiClose:
    If p_Modal
        SendInput {Escape}  ; necessary when user clicks on 'X' or taskbar 'Close Window' to exit and I don't want make Escape a hotkey)
    Gui, 99:Destroy
    
   Return
}
;------------------------------------------------------------------------------------------
;
;      list_hotkeys(p_doublespace := False, p_separate_long_hotkeys := False)
;
;
;
;
;------------------------------------------------------------------------------------------
list_hotkeys(p_doublespace := False, p_separate_long_hotkeys := True, p_display_rows := 99999)
{
    ; extract hotkeys and insert a sort field 
    FileRead, in_file_var, %A_ScriptFullPath%
    Loop, Parse, in_file_var, `n, `r 
    {
        
        align_length := Instr(A_LoopField, "::")
        If align_length       ; only finds hotkeys defined with 2 colons 
        {
            If (align_length > max_align_length)
                max_align_length := align_length
            ;
            ; sort on hotkeys ignoring any modifiers
            sort_field := RegExReplace(A_LoopField, "[\^|\+|!|#|~]*(.*)::.*", "$1")
            If !p_separate_long_hotkeys
                write_string1 .= Format("{:-20}| {}`r`n", sort_field, A_LoopField) 
            Else
            {
                If (StrLen(sort_field) < 5)
                    write_string1 .= Format("{:-20}| {}`r`n", sort_field, A_LoopField) 
                Else
                    write_string2 .= Format("{:-20}| {}`r`n", sort_field, A_LoopField) 
            }
        }
    }
    ; Sort hotkeys
    Sort, write_string1
    Sort, write_string2
    write_string3:= write_string1 write_string2
    ; create array of hotstring lines for easier formatting
    hotkey_array := []
    Loop, Parse, write_string3, `n, `r
    {
        If (A_LoopField == "")
           Continue
        ;
        end_sort_field_pos := Instr(A_LoopField, "| ") + 2       ; +2 = beginning of hotkey text pos
        double_colon_pos := Instr(A_LoopField, "::",, end_sort_field_pos)   
        ; hotkey defs only (ignore sort_field, double colons and rest_of_line_text)
        hotkey_text := Trim(SubStr(A_LoopField, end_sort_field_pos, double_colon_pos - end_sort_field_pos))
        rest_of_line_text := Trim(SubStr(A_LoopField, double_colon_pos + 2))
        hotkey_array.push([hotkey_text, rest_of_line_text])
        ;
        current_hotkey_text_length := StrLen(hotkey_text)
        If (current_hotkey_text_length > max_hotkey_text_length)
            max_hotkey_text_length := current_hotkey_text_length
    }
    ; Format output for final display
    write_string := ""
    format_string = {:%max_hotkey_text_length%}:: {}`r`n 
    If p_doublespace
        format_string := format_string "`r`n"
    For i_index, hotkey_line in hotkey_array
        write_string .= Format(format_string, hotkey_line[1], hotkey_line[2])
    display_text(write_string, A_ScriptName " - {Escape} to exit", True,,,,p_display_rows)  
    Return 
}
;-----------------------
; Format strings
;-----------------------
ucase(p_string) ; uppercase
{
    Return Format("{:U}", p_string)
}
lcase(p_string) ; lowercase
{
    Return Format("{:L}", p_string)
}
tcase(p_string) ; titlecase
{
    Return Format("{:T}", p_string)
}
hex(p_string)   ; converts decimal to hex
{
    Return Format("0x{:X}", p_string)
}
dec(p_string)   ; converts hex to decimal
{
    Return Format("{:d}", p_string)
}
;---------------------------------------------------------------------------
; Paste clipboard contents to new line (scintilla)
;---------------------------------------------------------------------------
paste_on_new_line(p_text)
{
    SCI_COPYTEXT = 2420
    SCI_LINEEND = 2314
    SCI_NEWLINE = 2329
    SCI_PASTE = 2179
    
    saved_clipboard := ClipboardAll
    Clipboard := ""
    Clipboard := p_text
    ClipWait, 1
    
    sci_commands := []
    ; sci_commands.push([SCI_COPYTEXT, StrLen(p_text), p_text])
    sci_commands.push([SCI_LINEEND])
    sci_commands.push([SCI_NEWLINE])
    sci_commands.push([SCI_PASTE])
    result := sci_exec(sci_commands)
    Clipboard := saved_clipboard
    Return result
}
;---------------------------------------------------------------------------
; Copies current line, regardless of selection, while preserving clipboard contents.  (scintilla)
;---------------------------------------------------------------------------
copy_current_line()
{
    SCI_LINECOPY = 2455
    line_text := sci_exec_clipboard(SCI_LINECOPY)
    Return line_text
}
;---------------------------------------------------------------------------
; Cuts current line, regardless of selection, while preserving clipboard contents.  (scintilla)
;---------------------------------------------------------------------------
cut_current_line()
{
    SCI_LINECUT = 2337
    line_text := sci_exec_clipboard(SCI_LINECUT)
    Return line_text
}
;---------------------------------------------------------------------------
; Copies selected_text and returns it while preserving clipboard contents.
; If nothing is already selected, will copy the entire line the caret is on.  (scintilla)
;---------------------------------------------------------------------------
select_and_copy_line()
{
    SCI_LINECOPY = 2455
    line_text := ""
    line_text := copy_selection()
    If (line_text == "")
        line_text := sci_exec_clipboard(SCI_LINECOPY)
    Return line_text
}
;---------------------------------------------------------------------------
; Copies selected_text and returns it while preserving clipboard contents.
; If nothing is selected, returns empty string, can optionally display an error message.  (scintilla)
;----------------------------------------------------------------------
copy_selection(p_error_msg := False)
{
    SCI_GETSELTEXT = 2161
    SCI_COPY = 2178
    sel_text := ""
    sel_len := sci_exec(SCI_GETSELTEXT)
    If (sel_len > 1)
        sel_text := sci_exec_clipboard(SCI_COPY)
    Else If p_error_msg
        MsgBox, 48,, % "Nothing selected...try again"
    Return sel_text
}
;-------------------------------------------------------------------------
;   select_and_copy_word()
;   Returns current selection (of whatever is selected)
;   Returns the selected word or empty string if no valid word selected.  (scintilla)
;-------------------------------------------------------------------------
select_and_copy_word()
{
    SCI_GETSELTEXT = 2161
    SCI_GETCURRENTPOS = 2008
    SCI_WORDSTARTPOSITION = 2266
    SCI_WORDENDPOSITION = 2267
    SCI_SETSEL = 2160
    SCI_COPY = 2178

    saved_clipboard := ClipboardAll
    Clipboard := ""
    ControlGetFocus, scintilla_classnn, A
    ControlGet, scintilla_hwnd, Hwnd, , %scintilla_classnn%, A

    sel_length := send_msg(scintilla_hwnd, SCI_GETSELTEXT, 0)
    If sel_length < 2
    {
        cur_pos := send_msg(scintilla_hwnd, SCI_GETCURRENTPOS, 0)
        word_start := send_msg(scintilla_hwnd, SCI_WORDSTARTPOSITION, cur_pos)
        word_end := send_msg(scintilla_hwnd, SCI_WORDENDPOSITION, word_start)
        send_msg(scintilla_hwnd, SCI_SETSEL, word_start, word_end)
    }
    send_msg(scintilla_hwnd, SCI_COPY, 0)
    
    ClipWait, 1
    selected_word := Clipboard
    Clipboard := saved_clipboard 
    Return selected_word 
}
;-------------------------------------------------------------------------
;   Wrapper for SendMessage command returns ErrorLevel 
;-------------------------------------------------------------------------
send_msg(p_hwnd := "", p_msg := "", p_wparam := "", p_lparam := "", p_control := "")
{
    SendMessage, %p_msg%, %p_wparam%, %p_lparam%, %p_control%, ahk_id %p_hwnd%
    Return ErrorLevel
}
;-------------------------------------------------------------------------
; Goes to the desired line number in the active document. Positions the
; line to make it more easily viewable.  (scintilla)
;-------------------------------------------------------------------------
goto_line(p_line_num)
{
    ; SCI_COPYTEXT = 2420
    SCI_GETCURRENTPOS = 2008
    SCI_GETSELTEXT = 2161
    SCI_GOTOLINE = 2024
    SCI_LINEFROMPOSITION = 2166
    SCI_SETFIRSTVISIBLELINE = 2613
    
    line_num := p_line_num - 1
    sci_commands := []
    sci_commands.push([SCI_GOTOLINE, line_num])
    sci_commands.push([SCI_SETFIRSTVISIBLELINE, line_num])
    sci_commands.push([SCI_GETCURRENTPOS,,,"USE_RESULT_AS_WPARAM"])
    sci_commands.push([SCI_LINEFROMPOSITION])
    result := sci_exec(sci_commands)
    Return result
}
;-------------------------------------------------------------------------
;  (scintilla)
;-------------------------------------------------------------------------
get_indentation(p_line_num := -999)
{
    SCI_GETCURRENTPOS = 2008
    SCI_LINEFROMPOSITION = 2166
    SCI_GETLINEINDENTATION = 2127
    ; SCI_COPYTEXT = 2420

    ControlGetFocus, scintilla_classnn, A
    ControlGet, scintilla_hwnd, Hwnd, , %scintilla_classnn%, A
    ;
    If (p_line_num = -999)
    {
        cur_pos := send_msg(scintilla_hwnd, SCI_GETCURRENTPOS, 0)
        line_num := send_msg(scintilla_hwnd, SCI_LINEFROMPOSITION, cur_pos)
    }
    Else
        line_num := p_line_num - 1       
    result := send_msg(scintilla_hwnd, SCI_GETLINEINDENTATION, line_num)
    Return result
}
;-------------------------------------------------------------------------
; Executes Scintilla messages 
;-------------------------------------------------------------------------
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\RemoteBuf.ahk
sci_exec(p_scintilla_msg_num, p_wparam := 0, p_lparam := 0)
{
    ControlGetFocus, scintilla_classnn, A
    ControlGet, scintilla_hwnd, Hwnd, , %scintilla_classnn%, A
    RemoteBuf_Open(hbuf1, scintilla_hwnd, 16)
    address := RemoteBuf_Get(hBuf1, "adr")
    If Not IsObject(p_scintilla_msg_num)
    {
        result := send_msg(scintilla_hwnd, p_scintilla_msg_num, p_wparam, p_lparam, address)
        Goto SCI_EXIT
    }
    ;
    For i, cmd In p_scintilla_msg_num
    {
        msgnum := cmd[1]
        wparam := cmd[2]
        lparam := cmd[3]
        zparam := cmd[4]
        result := send_msg(scintilla_hwnd, msgnum, wparam, lparam,  zparam)
        If (zparam == "USE_RESULT_AS_WPARAM")     ; see goto_line() for example
            p_scintilla_msg_num[i+1][2] := result
    }

SCI_EXIT:    
    RemoteBuf_Close(hBuf1)
    Return result
}
;------------------------------------------------------------------------- 
; SCI_*CUT/COPY commands can be passed through here to preserve clipboard
; contents. Returns Clipboard contents.  (scintilla)
;-------------------------------------------------------------------------
sci_exec_clipboard(p_commands)
{
    saved_clipboard := ClipboardAll
    Clipboard := ""
    sci_exec(p_commands)
    ClipWait, 0.5
    If (ErrorLevel) and (Clipboard == "")
        OutputDebug, % "ClipWait Timeout - Line#" A_LineNumber " (" A_ScriptName " - " A_ThisFunc ")"
    clip_board_contents := Clipboard
    Clipboard := saved_clipboard
    Return clip_board_contents
} 