#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\strings.ahk
#Include lib\constants.ahk
SetWorkingDir %AHK_ROOT_DIR%\MyScripts\NPP\Misc\

If (A_Args[1] = "^+[")
    brace_type := "NewLine"
Else If (A_Args[1] = "^[")
    brace_type := "CurrentLine"
Else
{
    MsgBox, 48, Unexpected Error, % A_ScriptName "`r`nBad Parameter:" A_Args[1]
    Goto BRACES_EXIT
}
; Turn off auto-indent (if it isn't off already)
RunWait, Toggle Preferences Setting.ahk GetState Auto-indent False True
saved_auto_indent := Clipboard
If (saved_auto_indent <> 0)
{
    RunWait, Toggle Preferences Setting.ahk Off Auto-indent False True
    If (Clipboard <> 0)
    {
        OutputDebug, % "Could not turn off Auto-indent"
        ; Goto BRACES_EXIT
    }
}

;
Clipboard := ""
indent_spaces := ""
code_text := ""
tab_spaces := "    "    ; 4 spaces
NEWLINE_ENTER:
If (brace_type = "NewLine")
{
    ; checks text at start of line for indent column
    SendInput !{Home}^{Right}
    indent_col := get_statusbar_info("curcol") - 1
    SendInput +{Home}^c
    Clipwait,2
    text_at_start_of_line := Clipboard
    non_whitespace_found := RegExMatch(text_at_start_of_line, "\S+")
    indent_col := non_whitespace_found ? 0 : indent_col
    SendInput, {End}{Enter}
}
Else If (brace_type = "CurrentLine")
{
    ; cut code on current line, move 1 line up to the end of line.
    ; assume that braces will be indented under this line based on this lines
    ; current position.
    SendInput, ^!x{Up}{End}
    Clipwait,2
    code_text := trim(clipboard)
    brace_type := "NewLine"
    Goto NEWLINE_ENTER    
}

Loop, %indent_col%
    indent_spaces .= " "
brace1 := indent_spaces "{`n"
If (code_text == "")
    brace2 := "`n" indent_spaces "}"
Else
    brace2 := indent_spaces "}"

; Cut entire current line in case any text is there. Assume it's code 
; that needs to be inserted between the braces with indentation.
Clipboard := ""
Clipboard := brace1 indent_spaces tab_spaces code_text brace2
Clipwait,2
SendInput, ^v{Up}{End}

BRACES_EXIT:
If (saved_auto_indent <> 0)
    Run, Toggle Preferences Setting.ahk %saved_auto_indent% Auto-indent False False
ExitApp