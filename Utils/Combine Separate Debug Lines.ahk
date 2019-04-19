/*
    Combines many debug statements into 1. Will combine any text that follows 
    OutputDebug, % "<< anything here will be added to the first statement>>
    Works for OutputDebug, % ....  and MsgBox, % .... type statements.

    Turns this:
        OutputDebug, % "hwnd: " hwnd
        OutputDebug, % "wParam: " wParam
        OutputDebug, % "lParam: " lParam
        OutputDebug, % "msg: " msg
    
    Into this:
        OutputDebug, % "hwnd: " hwnd ", wParam: " wParam ", lParam: " lParam ", msg: " msg
*/
#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\strings.ahk
#NoTrayIcon

saved_clipboard := ClipboardAll
Clipboard := check_selection_copy()
ClipWait,2
If ErrorLevel or (Clipboard == "")
{
    MsgBox, 48,, % "Invalid selection....`r`nYou need to select 2 or more OutputDebug, % statements to combine."
    Goto COMBINE_EXIT
}

clip_lines := Clipboard
Loop, Parse, clip_lines, `n, `r
{
    If (Trim(A_LoopField) == "")  ; skip blank lines
        Continue
        
    If (A_Index = 1)
    {
        test_for_valid_line := RegExReplace(A_LoopField, "i).*(OutputDebug|MsgBox), % (.*)","dummy test", replaced_count)
        If replaced_count
        {
            write_string := Trim(A_LoopField)
            continue
        }
    }
    
    ; If A_Index > 1
    added_text := RegExReplace(A_LoopField, "i).*(OutputDebug|MsgBox), % (.*)", """, "" $2",replaced_count)
    If replaced_count
        write_string := write_string " " added_text
    Else
    {
    OutputDebug, % "A_LoopField: " A_LoopField
        MsgBox, 48,, % "Invalid selection....`r`nYou need to select 2 or more OutputDebug, % statements to combine."
        Goto COMBINE_EXIT
    }
}   

; This puts in proper separation between those statements that had this format: "MyVar: " MyVar 
; so that they have this format: ", MyVar: " MyVar.
search_string  = ", " "            ;" this quote is just to fix color coding in Notepad++  
replace_string := chr(34) ", "     
write_string := StrReplace(write_string, search_string, replace_string)
SendInput, %write_string% {Enter}

COMBINE_EXIT:
Clipboard := saved_clipboard
ExitApp
