OutputDebug, % "AOE List Hotkeys.ahk"
OnMessage(0x0021, "WM_MOUSEACTIVATE")
OnMessage(0x0006, "WM_ACTIVATE")

list_hotkeys()
{
    FileRead, in_file_var1, %A_ScriptDir%\AOE.ahk
    FileRead, in_file_var2, %A_ScriptDir%\AOE Explore Map.ahk
    FileRead, in_file_var3, %A_ScriptDir%\AOE List Hotkeys.ahk
    in_file_var := in_file_var1 "`n" in_file_var2 "`n" in_file_var3
    Loop, Parse, in_file_var, `n, `r 
    {
        If InStr(A_LoopField,chr(58)chr(58))    ; 2 colons 
        {
            If InStr(A_LoopField, "LWin") or (A_LoopField = "^!s::")
            or Instr(A_LoopField, "Escape")
                Continue

            sort_field := RegExReplace(A_LoopField, "[\^|\+|!|#|~]*(.*)::.*", "$1")
            If StrLen(sort_field) = 1
                write_string1 .= Format("{:-10}| {}`r`n", sort_field, A_LoopField) 
            Else
                write_string2 .= Format("{:-10}| {}`r`n", sort_field, A_LoopField) 
        }
    }
    Sort, write_string1
    Sort, write_string2
    write_string3 := write_string1 write_string2
    ; insert double spacing and remove the sort_field
    Loop, Parse, write_string3, `n, `r 
    {
            write_string .= SubStr(A_LoopField, 13) "`r`n`r`n"
    }
    write_string := SubStr(write_string, 1, StrLen(write_string)- 8)   ; truncate extra blank lines
    SendInput {F3}  ; Pause game
    ControlSetText, Edit1, %write_string%, List Hotkeys
    Sleep 500
    ControlClick, Edit1, List Hotkeys,,Left     ; deselects text
    SendInput {F3}  ; Resume game
    Return 
}
;======================================================================
WM_ACTIVATE(wParam, lParam)
{
    WinActivate, %aoe_wintitle%    
    OutputDebug, % "wParam: " wParam " - lParam: " lParam " - A_ThisFunc: " A_ThisFunc " - A_ScriptName: " A_ScriptName
    Return 4 ;MA_NOACTIVATEANDEAT
}

WM_MOUSEACTIVATE(wParam, lParam)
{
    WinActivate, %aoe_wintitle%    
    OutputDebug, % "wParam: " wParam " - lParam: " lParam " - A_ThisFunc: " A_ThisFunc " - A_ScriptName: " A_ScriptName
    Return 4 ;MA_NOACTIVATEANDEAT
}
