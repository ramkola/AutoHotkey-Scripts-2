#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\ahk_word_lists.ahk
#Include lib\processes.ahk
#Include lib\strings.ahk
#Include lib\constants.ahk
#Include lib\utils.ahk
#NoEnv
; #NoTrayIcon
#SingleInstance Force
SendMode Input
SetWorkingDir %AHK_MY_ROOT_DIR%
SetTitleMatchMode %STM_EXACT%
Menu, Tray, Icon, resources\32x32\icons8-under-construction-32.png

WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
OutputDebug, DBGVIEWCLEAR
WinActivate, ahk_class Notepad++ ahk_exe notepad++.exe

start_time := "*** " . get_time() . ":" . A_MSec . " *** Start"

in_file := get_current_npp_filename()
out_file := "New 99.ahk"


; see lib\ahk_word_lists.ahk to add or modify word lists
cmd_list := get_word_lists()     

If Not FileExist(in_file)
{
    MsgBox % "No Infile"
    Return
}
FileRead in_file_var, %in_file%
in_file_var := StrReplace(in_file_var, "`n", "`n", total_lines)
total_lines := 1000s_sep(total_lines)
Progress, b,, Lines 0 / %total_lines%, Please wait...
total_replaced := 0

Loop, Parse, in_file_var, `n, `r
{
    replaced := False
    org_text := A_LoopField
    pct_done := Round((A_Index / total_lines) * 100)
    line_num := 1000s_sep(A_Index)
    if (total_lines < 1000)
        Progress, %pct_done%,,Line %line_num% / %total_lines%, Please wait..., Consolas
     Else if mod(pct_done, 100) = 0
        Progress, %pct_done%,,Line %line_num% / %total_lines%, Please wait..., Consolas
    ;------------------------------------------------------------------------------------------------------
    ; Skip block comments /*....*/
    ;------------------------------------------------------------------------------------------------------   

save_a_index := A_Index
If (save_a_index = 37)
    dbgp_breakpoint := True
    
    block_comment_in_progress := (SubStr(org_text, 1, 2) == "/*") or block_comment_in_progress
    block_comment_end_flag   := (SubStr(org_text, 1, 2) == "*/")
    If block_comment_end_flag
    {
        ; end of block comments, reset the flags
        block_comment_in_progress := False
        block_comment_end_flag := False
        out_file_var .= org_text . "`n"
        Continue    ; skip end of comments record, go to next record
    }
    Else If block_comment_in_progress
    {
        out_file_var .= org_text . "`n"
        Continue
    }
    Else    
        ; we are not in a block comment so don't skip to next record
        this_does_nothing := True
    ; 
    ; Skip line comments ';' if they are the first character on the line 
    If RegExMatch(org_text, "^\s*;")
    {
        out_file_var .= org_text . "`n"
        Continue        
    }
    ;------------------------------------------------------------------------------
    ; Lines that have inline comments have the comment portion temporarily removed 
    ;------------------------------------------------------------------------------
    stripped_comment_text := ""
    comment_pos := InStr(org_text, Chr(59))
    If comment_pos
    {
        stripped_comment_text := SubStr(org_text,comment_pos)
        org_text := SubStr(org_text, 1, comment_pos - 1)
    }
    ;---------------------------------------------------------------------------
    ; Process lines that have code and text within quotation marks. (comments with or without quotes have already been stripped above).
    ;
    ; Mask all text within quotes so that they DO NOT get changed like unquoted text.
    ; After all the unquoted text gets processed, the masked text will be replaced 
    ; back with the original quoted text. 
    ; Example:
    ;   org_text before mask: if !(regexmatch(files_excluded,"i)(^|\|)" file_title "($|\|)") or regexmatch(files_excluded,"i)(^|\|)" file_title "." file_ext "($|\|)"))
    ;   org_text after  mask: if !(regexmatch(files_excluded, file_title ) or regexmatch(files_excluded, file_title  file_ext ))
    ;   org_text after Beaut: If !(RegExMatch(files_excluded, file_title ) or RegExMatch(files_excluded, file_title  file_ext ))
    ;   org_text wrtten2file: If !(RegExMatch(files_excluded,"i)(^|\|)" file_title "($|\|)") or RegExMatch(files_excluded,"i)(^|\|)" file_title "." file_ext "($|\|)"))
    ;
    ; 23-Jun-2018 - Bug
    ;   Doesn't handle open quote on one line with the closed quote on another line. 
    ;   Maybe need to have another look at RegExReplace on the entire file.
    ;   Maybe look for continuation bracket on next line to know whether this is a single quote
    ;   or the open quote of a multiline quoted string. 
    ;   As is, the danger is, of modifying words within a double quoted string that should not be modified.
    ;---------------------------------------------------------------------------
    i_index := 1
    text_mask := Chr(7) . Chr(7) . Chr(7) . Chr(7)          ;   arbitrary string used to mask quoted text.
    quoted_strings := []
    close_quote_pos := 9999
    While close_quote_pos > 0
    {
        open_quote_pos  := InStr(org_text, Chr(34))
        close_quote_pos := InStr(org_text,Chr(34),,open_quote_pos + 1)
        If (close_quote_pos > open_quote_pos) 
        {
            quoted_strings.push(SubStr(org_text, open_quote_pos, close_quote_pos - open_quote_pos + 1))
            org_text := StrReplace(org_text, quoted_strings[i_index], text_mask,,1) ; important: replace pair of quotes found, one at a time. (not replace all)
            i_index++
        }
    }   
    ;----------------------------------------------------
    ; Beautify Code Lines - main purpose of this program
    ;----------------------------------------------------
    For i, cmd in cmd_list
    {                                               
 
If (cmd == "If") and (save_a_index = 37)
    dbgp_breakpoint := True
        regex_search = i)(?<=\b|\s|^)%cmd%\b    ; match whole word only - case insensitive. Basically this is a \bWORD\b search. All the extra stuff is to include words that begin with a #.
        replace_string = %cmd%
        re_result := RegExReplace(org_text, regex_search, replace_string, replaced_count)
        If (re_result == A_LoopField)
            x=x
        else
        {
            org_text := re_result   ; store the modified line back into org_text before going to the next iteration of changes of this line. 
            replaced := True
            total_replaced++
        }
    }
    
    ; reinsert stripped comments if any
    re_result .= stripped_comment_text
  
    ;reinsert quoted text strings if any
    For i, qstring in quoted_strings
        re_result := StrReplace(re_result, text_mask, qstring,,1)
 
    ; write the beautified record into out_file_var
    out_file_var .= re_result "`n"
    If replaced
    {
        line_num := Format("{:04})", A_Index)
        OutputDebug, Line# %line_num% %A_LoopField% 
        OutputDebug, result:     %re_result%       
        OutputDebug, ==============================
    }
}    

Progress, Off
FileDelete, %out_file%
FileAppend, %out_file_var%, %out_file% 
Run, Compare Files (diff).ahk "%in_file%" "%out_file%"
Run, "C:\Program Files (x86)\WinMerge\WinMergeU.exe" "%in_file%" "%out_file%"
WinActivate, WinMerge ahk_class WinMergeWindowClassW ahk_exe WinMergeU.exe
WinWaitActive, WinMerge ahk_class WinMergeWindowClassW ahk_exe WinMergeU.exe
WinMaximize, WinMerge ahk_class WinMergeWindowClassW ahk_exe WinMergeU.exe
OutputDebug, % start_time 
;output_debug("*** " . get_time() . ":" . A_MSec . " *** End")
OutputDebug, % "total_replaced: " total_replaced
OutputDebug, % in_file
Return

^Numpad0::
    SendInput !fo
    Sleep 1000
    SendInput New 99.ahk{Enter}
    ExitApp

^p::Pause
^x::ExitApp

get_word_lists()
{
    result := ""
    result .= get_command_list()
    result .= get_builtin_vars_list()
    result .= get_keyboard_list()
    result .= get_misc_list()
    
    result := StrSplit(result, Chr(10))
    Return %result%
}


