;
; Formats the file created by "NPP Shortcut Mapper - Get List.ahk"
;
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\constants.ahk
#Include lib\utils.ahk
#Include lib\npp.ahk
#NoEnv
#SingleInstance Force
SetWorkingDir %AHK_ROOT_DIR%
Menu, Tray, NoIcon

infile := "Misc\Shortcut Mapper List - Unformatted.txt"
outfile := "Misc\Shortcut Mapper List - Formatted.txt"

unformatted_shortcut_list := array_from_text_file(infile)
max_len := find_max_column_lengths(unformatted_shortcut_list)
formatted_shortcut_list := format_fields(unformatted_shortcut_list, max_len)

FileDelete, %outfile%
FileAppend, %formatted_shortcut_list%, %outfile%
npp_open_file(AHK_ROOT_DIR "\" outfile)
Sleep 10
Run, MyScripts\NPP\Shortcut Mapper\Finder.ahk
ExitApp

array_from_text_file(p_fname)
{
    record_list := []
    Loop, Read, %p_fname%
    {
        ; get rid of commas not used as field delimeters. they will replaced later.
        cur_line := remove_extra_commas(A_LoopReadLine)
        ; convert line to separate fields
        fields := StrSplit(cur_line, ",")
        ; ignore header records and append data to the array
        if not isheader(fields[1], fields[2]) 
            record_list.push([fields[1], fields[2], fields[3], fields[4]])
    }
    Return record_list
}

find_max_column_lengths(p_list)
{
    ; Find the longest string of each field for formatting.
    max_len := []
    for x, row in p_list
    {
        for y, col in row
        {
            cur_len := StrLen(col)
            if (max_len[y] < cur_len)
                max_len[y] := cur_len 
        }
    }
    Return max_len
}

format_fields(p_list, p_field_len)
{
    for x, row in p_list
    {
        for y, col in row
        {
            p_list[x,y] := StrReplace(col, "Æ", ",")
        }
        formatted_shortcut_list .= Format("{1:-" p_field_len[1] "}|{2:-" p_field_len[2] "}|{3:-" p_field_len[3] "}|{4:-" p_field_len[4] "}", row*)
        formatted_shortcut_list .= "`n"
    }
    Return formatted_shortcut_list
}

remove_extra_commas(p_line)
{
    if (instr(p_line, ",", false, 1, 4) > 0)
    {
        good_comma := instr(p_line, ",", false, -1, 3) - 1
        bad_commas := Substr(p_line, 1, good_comma)
        end_part := Substr(p_line, good_comma + 1)
        first_part := StrReplace(bad_commas, ",", "Æ")
        p_line := first_part . end_part
    }
    return p_line
}

isheader(p_field1, p_field2)
{
    Return instr(p_field1, "Name", True) and instr(p_field2, "Shortcut", True) 
}
