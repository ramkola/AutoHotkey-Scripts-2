in_file = C:\Users\Mark\Documents\AOE\Scout Map Perimeter.ahk
SplitPath, in_file, fname 
FileRead, in_file_var, %in_file% 
write_string := ""
Loop, Parse, in_file_var, `n, `r 
{
; \.*?+[{|()^$
; Click, 1014, 957, 0
    found_pos := RegExMatch(A_LoopField, "Click.*Up")
    If Not found_pos
        write_string .= A_LoopField "`r`n"
}

Clipboard := write_string
MsgBox % "Clipboard: " Clipboard 
