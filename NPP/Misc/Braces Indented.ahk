#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
; #Include lib\strings.ahk
#Include lib\npp.ahk
#Include lib\constants.ahk
SetWorkingDir %AHK_ROOT_DIR%

OutputDebug, DBGVIEWCLEAR

If (A_Args[1] = "^+[")
    brace_type := "NewLine"
Else If (A_Args[1] = "^[")
    brace_type := "CurrentLine"
Else
{
    MsgBox, 48, Unexpected Error, % A_ScriptName "`r`nBad Parameter:" A_Args[1]
    Goto BRACES_EXIT
}
Clipboard := ""
indent_spaces := ""
code_text := ""
tab_spaces := "    "    ; 4 spaces
NEWLINE_ENTER:
If (brace_type = "NewLine")
{
    indent_col := nppexec_get_indentation(,"SCI_SENDMSG SCI_LINEEND")
}
Else If (brace_type = "CurrentLine")
{
    ; cut code on current line and move 1 line up to assume that braces
    ; will be indented under this line based on this lines indentation.
    code_text := Trim(nppexec_return_code("SCI_SENDMSG SCI_LINECUT`r`nSCI_SENDMSG SCI_LINEUP"))
    brace_type := "NewLine"
    Goto NEWLINE_ENTER    
}

Loop, %indent_col%
    indent_spaces .= " "
brace1 := "`n"indent_spaces "{`n"
If (code_text == "")
    brace2 := "`n" indent_spaces "}"
Else
    brace2 := indent_spaces "}"

Clipboard := brace1 indent_spaces tab_spaces code_text brace2
Clipwait,2
SendInput, ^v{Up}{End}

BRACES_EXIT:
ExitApp