; known bug: parameters with literal commas are not handled properly (ie: myproc_call(param1, param2=",", param3=0) param2 will not split properly
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\objects.ahk
#Include lib\processes.ahk
#Include lib\strings.ahk
#Include lib\constants.ahk
#Include lib\utils.ahk
#NoEnv
#NoTrayIcon
#SingleInstance Force
SendMode Input
SetWorkingDir %AHK_MY_ROOT_DIR%
StringCaseSense Off

proc_file := []
Loop, Files, %AHK_MY_ROOT_DIR%\lib\*.ahk, F
{   
    
    FileRead, in_file_var, %A_LoopFileFullPath%
    file_array := StrSplit(in_file_var, "`n", "`r")

    found_pos := 1
    While (found_pos > 0)
    {
        ; blank copy of def_procedure_call defined in lib\objects.ahk
        proc_call_rec := def_procedure_call.clone()
        
        ; 
        proc_call_rec["library"] := A_LoopFileFullPath

        ; extract procedure calls
        found_pos := RegExMatch(in_file_var, "mO)^\w+\(.*\).*$", match, found_pos)
        If (found_pos = 0)
            Continue        ; no procedures found go to next file
        found_pos := match.pos + match.len
        proc_call_original_line := match.value              

        ; remove open brace and extra whitespace
        proc_call_rec["procedure_call"] := trim(StrReplace(proc_call_original_line, "{", ""))   
        
        ; set just the procedure name without brackets and parameters
        pos := InStr(proc_call_rec["procedure_call"], "(")
        proc_call_rec["name"] := SubStr(proc_call_rec["procedure_call"], 1, pos - 1)    
        
        ; set just the parameters without the procedure name and brackets
        param_start_pos := InStr(proc_call_rec["procedure_call"], "(") + 1
        param_end_pos := InStr(proc_call_rec["procedure_call"], ")")
        proc_call_rec["param_string"] := SubStr(proc_call_rec["procedure_call"], param_start_pos, param_end_pos - param_start_pos)
       
        ; create a list of parameters
        ; known bug: parameters with literal commas are not handled properly (ie: myproc_call(param1, param2=",", param3=0) param2 will not split properly
        result_array := StrSplit(proc_call_rec["param_string"], ",", A_Space)
        proc_call_rec["param_list"] := result_array      

        ; finds inline and block comments that were written before the current procedure call
        set_comments(proc_call_rec, proc_call_original_line, file_array)       

        ; wraps long parameter lines with the proper syntax and indentation
        set_multiline_parameters_format(proc_call_rec)
        
        ; sets 1 parameter per line with the proper syntax and indentation
        set_separate_parameters_format(proc_call_rec)
        
        ; save this procedure call record as an element in the procedure file array.
        proc_file.push(proc_call_rec)       
    }
}

write_string := ""
For i_index, pc_rec in proc_file
{
    write_string .= "`ncomment: `n" pc_rec["comment"] 
    write_string .= "library:      " pc_rec["library"] "`n"
    write_string .= "proc call:    " pc_rec["procedure_call"] "`n"
    write_string .= "param string: " pc_rec["param_string"] "`n"
    for i, param in pc_rec["param_list"] 
        write_string .= "param[" i "]:     " param "`n"
    write_string .= "name:         " pc_rec["name"] "`n"
    write_string .= "multiline:    " pc_rec["multiline"] "`n"
    write_string .= "separate:     " pc_rec["separate"]
    write_string .= "////////////////////////////////////////////////////////"
}

out_file := AHK_MY_ROOT_DIR "\Misc\" Substr(A_ScriptName, 1, -4) ".txt"
FileDelete, %out_file%
FileAppend, %write_string%, %out_file%
SendInput !fo
Sleep 300
SendInput %out_file%{Enter}
ExitApp

; known bug: parameters with literal commas are not handled properly (ie: myproc_call(param1, param2=",", param3=0) param2 will not split properly
set_separate_parameters_format(proc_call_rec)
{
    proc_call := proc_call_rec["procedure_call"]
    bracket_pos := InStr(proc_call, "(")
    proc_name_only := SubStr(proc_call, 1, bracket_pos)
    spaces_to_indent := bracket_pos - 2
    indent := ""
    Loop %spaces_to_indent%
        indent .= A_Space

    params := SubStr(proc_call, bracket_pos + 1)
    param_array := StrSplit(params, ",")    
    For i_index, param in param_array
        If (i_index > 1)
            result .= indent ", " Trim(param) "`n"
        Else
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
    proc_call := proc_call_rec["procedure_call"]
    proc_call := Trim(StrReplace(proc_call,"{",""))
    wrap_pos := InStr(proc_call, ",", , wrap_column)
    If Not wrap_pos
        proc_call_rec["multiline"] := proc_call_rec["procedure_call"]
    Else
    {
        spaces_to_indent := InStr(proc_call, "(") - 2
        indent := ""
        Loop %spaces_to_indent%
            indent .= A_Space
        part1 := SubStr(proc_call, 1, wrap_pos - 1) 
        part2 := SubStr(proc_call, wrap_pos)
        part2 := "`n" indent part2
        
        wrap_pos := InStr(part2, ",", , wrap_column)
        If wrap_pos
        {
            part3 := SubStr(part2, 1, wrap_pos - 1) 
            part4 := SubStr(part2, wrap_pos)
            part2 := part3    
            part3 := part4
            part3 := (Trim(part3) == "") ? "" : "`n" indent part3
        }
        proc_call_rec["multiline"] := part1 part2 part3
    }
    Return
}
 
set_comments(proc_call_rec, p_proc_call_original_line, p_file_array)
{
    ; Unlike this comment here, this procedure assumes that
    ; procedure documentation starts before the procedure procedure_call
    Static save_library := ""
    Static save_start_line := 0
    If (save_library != proc_call_rec["library"])
    {
        save_library := proc_call_rec["library"]
        save_start_line := 0
    }
    ; find procedure's procedure_call line num
    line_num := save_start_line 
    Loop
    {
        line_num++
        If (p_file_array[line_num] == p_proc_call_original_line)
        {
            save_start_line := line_num
            Break
        }
    }  
    ; Read file backwards collecting all comment lines until 
    ; start of comments for this procedure
    comment := ""
    Loop
    {
        line_num := line_num - 1
                                                                
        ; note: This will also handle the case of block comments embedded in line comments
        If (SubStr(p_file_array[line_num], 1, 2) == "*/")
        {
            result := block_comments_handler(p_file_array, line_num, comment)
            result_delimeter_pos := InStr(result, ",")
            line_num := SubStr(result, 1, result_delimeter_pos - 1) - 1 ; point to next line to process in reverse.
            result_comments :=  SubStr(result, result_delimeter_pos + 1)
            comment := result_comments
        }
       
        found_pos := RegExMatch(p_file_array[line_num], "^\s*;")
        If found_pos
            comment := p_file_array[line_num] "`n" comment 

    } Until found_pos = 0
    
    proc_call_rec["comment"] := comment
    Return 
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
        If block_comment_end_flag
        {
            ; end of block comments, reset the flags, add the last comment end exit loop
            block_comment_in_progress := False
            block_comment_end_flag := False
            comment := p_file_array[line_num] "`n" comment
        }
        Else If block_comment_in_progress
            comment := p_file_array[line_num] "`n" comment
    }
    result := line_num "," comment      ; we are not in a block comment anymore
    Return %result%
}

^x::ExitApp
