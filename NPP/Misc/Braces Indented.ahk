#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\strings.ahk
; #Include lib\constants.ahk
; SetWorkingDir %AHK_ROOT_DIR%

SCI_LINEEND = 2314
SCI_LINECUT = 2337
SCI_LINEUP = 2302

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
    indent_col := get_indentation()
    sci_exec(SCI_LINEEND)
}
Else If (brace_type = "CurrentLine")
{
    ; cut code on current line and move 1 line up to assume that braces
    ; will be indented under this line based on this lines indentation.
    sci_exec(SCI_LINECUT)
    ClipWait, 1
    code_text := Trim(Clipboard)
    sci_exec(SCI_LINEUP)
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
Clipwait,1
SendInput, ^v{Up}{End}

BRACES_EXIT:
ExitApp