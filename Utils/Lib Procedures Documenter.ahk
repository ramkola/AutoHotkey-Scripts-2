#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\objects.ahk
#Include lib\processes.ahk
#Include lib\strings.ahk
#Include lib\constants.ahk
#Include lib\utils.ahk
#NoEnv
; #NoTrayIcon
#SingleInstance Force
SendMode Input
SetWorkingDir %AHK_MY_ROOT_DIR%
StringCaseSense Off
Menu, Tray, Icon, resources\32x32\icons8-under-construction-32.png

WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
OutputDebug, DBGVIEWCLEAR
WinActivate, ahk_class Notepad++ ahk_exe notepad++.exe
proc_file := []

; Loop, Files, %AHK_MY_ROOT_DIR%\lib\*.ahk, F
Loop, Files, %AHK_MY_ROOT_DIR%\lib\Wrapper for Functions with Output Vars.ahk, F
{   
    
    FileRead, in_file_var, %A_LoopFileFullPath%
    file_array := StrSplit(in_file_var, "`n", "`r")

    found_pos := 1
    While (found_pos > 0)
    {
        proc_call_rec := def_procedure_call.clone()
        proc_call_rec["file_path"] := A_LoopFileFullPath
        ; extract procedure calls
        found_pos := RegExMatch(in_file_var, "mO)^\w+\(.*\).*$", match, found_pos)
        if (match = "")
            continue        ; no procedures found go to next file
        found_pos := match.pos + match.len
        proc_call := match.value
        proc_call_rec["definition"] := proc_call
        pos := InStr(proc_call, "(")
        proc_call_rec["name"] := SubStr(proc_call, 1, pos - 1)
        
        ; break down parameters
        param_start_pos := Instr(proc_call, "(") + 1
        param_end_pos := Instr(proc_call, ")")
        proc_call_rec["param_string"] := SubStr(proc_call, param_start_pos, param_end_pos - param_start_pos)
        result_array := StrSplit(param_string, ",")
        for i, param in result_array
        {
            proc_call_rec["param_list"][i] := param 
            OutputDebug, % Format("{:02}) ", i) proc_call_rec["param_list"][i] 
        }
        proc_call_rec["comment"] := set_comments(file_array, proc_call, A_LoopFileFullPath)
        set_multiline_parameters_format(proc_call_rec)
        set_separate_parameters_format(proc_call_rec)
        proc_file.push(proc_call_rec)       
    }
}

for i_index, pc_rec in proc_file
{
    OutputDebug, +--------------+
    OutputDebug, +  Procedure   +
    OutputDebug, +--------------+
    For key, value in pc_rec 
    {
        if (key == "param_list")
        {
            for i, j in %value%
                OutputDebug, % Format("{:02}) ", i) j 
            Goto NEXT
        }
        if key in separate,multiline,comment ;and (StrLen(value) > 75)
        {
            OutputDebug, % key ": "
            OutputDebug, % value
            Goto Next
        }
        OutputDebug, % key ": " value
NEXT:
    }
}

WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe

        ; else if key in separate,multiline,comment 
            ; if (StrLen(value) > 75)
            ; {
                ; OutputDebug, % key ": "
                ; OutputDebug, % value
            ; }
            ; else    
                ; OutputDebug, % key ": " value
ExitApp

set_separate_parameters_format(proc_call_rec)
{
    proc_call := proc_call_rec["definition"]
    bracket_pos := Instr(proc_call, "(")
    proc_name_only := SubStr(proc_call, 1, bracket_pos)
    spaces_to_indent := bracket_pos - 2
    indent := ""
    Loop %spaces_to_indent%
        indent .= A_Space

    params := SubStr(proc_call, bracket_pos + 1)
    param_array := StrSplit(params, ",")    
    for i_index, param in param_array
        if (i_index > 1)
            result .= indent ", " trim(param) "`n"
        else
            result := proc_name_only param "`n"
            
    proc_call_rec["separate"] := result 
    Return 
}
        
set_multiline_parameters_format(proc_call_rec)
{
    wrap_column := 75
    part1 := "" 
    part2 := ""
    part3 := ""
    proc_call := proc_call_rec["definition"]
    proc_call := trim(StrReplace(proc_call,"{",""))
    wrap_pos := Instr(proc_call, ",", , wrap_column)
    if not wrap_pos
        proc_call_rec["multiline"] := proc_call_rec["definition"]
    else
    {
        spaces_to_indent := Instr(proc_call, "(") - 2
        indent := ""
        Loop %spaces_to_indent%
            indent .= A_Space
        part1 := SubStr(proc_call, 1, wrap_pos - 1) 
        part2 := SubStr(proc_call, wrap_pos)
        part2 := "`n" indent part2
        
        wrap_pos := Instr(part2, ",", , wrap_column)
        if wrap_pos
        {
            part3 := SubStr(part2, 1, wrap_pos - 1) 
            part4 := SubStr(part2, wrap_pos)
            part2 := part3    
            part3 := part4
            part3 := (trim(part3) == "") ? "" : "`n" indent part3
        }
        proc_call_rec["multiline"] := part1 part2 part3
    }
    Return
}

set_comments(p_file_array, p_proc_name, p_file_name)
{
    ; Unlike this comment here, this procedure assumes that
    ; procedure documentation starts before the procedure definition
    Static save_file_name := ""
    Static save_start_line := 0
    if (save_file_name != p_file_name)
    {
        save_file_name := p_file_name
        save_start_line := 0
    }
    ; find procedure's definition line num
    line_num := save_start_line 
    Loop
    {
        line_num++
        if (p_file_array[line_num] == p_proc_name)
        {
            save_start_line := line_num
            break
        }
    }  
    ; Read file backwards collecting all comment lines until 
    ; start of comments for this procedure
    comment := ""
    Loop
    {
        line_num := line_num - 1
                                                                
        ; note: This will also handle the case of block comments embedded in line comments
        if (SubStr(p_file_array[line_num], 1, 2) == "*/")
        {
            result := block_comments_handler(p_file_array, line_num, comment)
            result_delimeter_pos := Instr(result, ",")
            line_num := SubStr(result, 1, result_delimeter_pos - 1) - 1 ; point to next line to process in reverse.
            result_comments :=  SubStr(result, result_delimeter_pos + 1)
            comment := result_comments
        }
       
        found_pos := RegExMatch(p_file_array[line_num], "^\s*;")
        if found_pos
        {
            comment := p_file_array[line_num] "`n" comment 
        }
    } until found_pos = 0
    ; OutputDebug, % comment
    Return %comment%
}

block_comments_handler(p_file_array, p_line_num, p_comment)
{
    ; note: file is being read in reverse so start of block comment is */ and end is /*.
    line_num := p_line_num
    block_comment_in_progress := True
    comment := p_file_array[line_num] "`n" p_comment
    While block_comment_in_progress
    {
        line_num := line_num - 1
        xxxdebug := p_file_array[line_num]
        block_comment_in_progress := (SubStr(p_file_array[line_num], 1, 2) == "*/") or block_comment_in_progress
        block_comment_end_flag   := (SubStr(p_file_array[line_num], 1, 2) == "/*")
        if block_comment_end_flag
        {
            ; end of block comments, reset the flags, add the last comment end exit loop
            block_comment_in_progress := False
            block_comment_end_flag := False
            comment := p_file_array[line_num] "`n" comment
        }
        Else if block_comment_in_progress
            comment := p_file_array[line_num] "`n" comment
    }
    result := line_num "," comment      ; we are not in a block comment anymore
    Return %result%
}

^p::Pause
^x::ExitApp
