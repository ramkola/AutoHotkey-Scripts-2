#SingleInstance Force
#Include lib\strings.ahk
#Include lib\utils.ahk

Global g_debug_switch := False
in_file := "C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts\MyScripts\MyHotkeys.ahk"
FileRead, in_file_var, %in_file%
in_file_array := StrSplit(in_file_var, "`n", "`r")
row_num := 1
Loop, % in_file_array.count()
{
    If (in_file_array[row_num] == "; ---------- Start of DBGp hotkeys marker ----------")
    {
        While (in_file_array[row_num] <> "; ---------- End of DBGp hotkeys marker ----------")
        {
            row_text := in_file_array[row_num]
            output_debug("row_text: " row_text, g_debug_switch)
            If InStr(row_text, "::")
                write_string .= "`r`n" row_text
            row_num++
        }
    }
    row_num++
}
write_string := SubStr(write_string, 3)
fname := "zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz.tmp"
FileAppend, %write_string%, %fname%
list_hotkeys(True, False, 30, 12,, fname)
FileDelete, %fname%
ExitApp


^+x::ExitApp
