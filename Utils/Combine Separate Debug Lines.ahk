#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
#NoTrayIcon
Global g_debug_switch := False
output_debug("DBGVIEWCLEAR", g_debug_switch)
saved_clipboard := ClipboardAll
SendInput ^c
ClipWait, 1
statements := Clipboard
clip_lines := []
Loop, Parse, statements, `n, `r
{
    If (A_LoopField == "")
        Continue
    Else
        clip_lines.push(Trim(A_LoopField))
}
join_type := RegExReplace(clip_lines[1], "i).*(output_debug|OutputDebug|MsgBox).*","$1")
If (join_type = "output_debug")
    result := join_output_debug_statements(clip_lines)
Else If (join_type = "OutputDebug")
    result := join_outputdebug_statements(clip_lines)
Else If (join_type = "MsgBox")
    result := join_msgbox_statements(clip_lines)
SendInput, %result%{Enter}
OutputDebug, % "timeout: " timeout " - expression: " expression " - " line1 " - " line2 " - " line3
Clipboard := saved_clipboard
If g_debug_switch
{
    WinActivate, ahk_class Notepad++ ahk_exe notepad++.exe
    WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
}
ExitApp

;------------------------------------------------------------------

join_msgbox_statements(p_clip_lines)
{
    delim_string := Chr(32) Chr(34) Chr(32) "-" Chr(32) Chr(34) Chr(32) ; <var1> " - " <var2> 
    label_pattern = "\w+: " \w+     
    joined_statement := ""
    For i, statement In p_clip_lines
    {
        options := RegExReplace(statement, "i)^.*MsgBox,(.*?),.*?,.*$", "$1", replaced_count)
        title := RegExReplace(statement, "i)^.*MsgBox,.*?,(.*?),.*$", "$1", replaced_count)
        expression := RegExReplace(statement, "i)^.*MsgBox.*% (.*?)(, \d+$|$)", "$1", replaced_count)
        timeout := RegExReplace(statement, "i)^.*MsgBox.*%.*?(, \d+$)", "$1", replaced_count)
        ; insert correct delimeter between expressions.
        If (i > 1)
        {
            If RegExMatch(expression, label_pattern)
                expression := StrReplace(expression, Chr(34), Chr(32) Chr(34) " - ",,1)
            Else
                expression := delim_string expression 
        }
        joined_statement .= expression
    }
    joined_statement := "MsgBox, " options ", " title ", % " joined_statement timeout
    Return joined_statement
}

join_output_debug_statements(p_clip_lines)
{
    delim_string := Chr(32) Chr(34) Chr(32) "-" Chr(32) Chr(34) Chr(32) ; <var1> " - " <var2> 
    label_pattern = "\w+: " \w+     
    joined_statement := ""
    For i, statement In p_clip_lines
    {
        ; (.*?) = $1 ie: "line4: " line4    IN: output_debug("line4: " line4, switch4)
        expression := RegExReplace(statement, "i)^.*output_debug\((.*?)(, \w+\)$|\)$)", "$1")
        ; (\w+) = $3 ie: switch4   IN: output_debug("line4: " line4, switch4)
        override := RegExReplace(statement, "i)^.*output_debug\(.*?,\s*(\w+)\)$", "$1", replaced_count)
        If replaced_count
            save_override := override

        ; insert correct delimeter between expressions.
        If (i > 1)
        {
            If RegExMatch(expression, label_pattern)
                expression := StrReplace(expression, Chr(34), Chr(32) Chr(34) " - ",,1)
            Else
                expression := delim_string expression 
        }
        joined_statement .= expression
    }
    joined_statement := "output_debug(" joined_statement
    joined_statement .= (save_override == "") ? ")" : ", " save_override ")"
    Return joined_statement
}

join_outputdebug_statements(p_clip_lines)
{
    delim_string := Chr(32) Chr(34) Chr(32) "-" Chr(32) Chr(34) Chr(32) ; <var1> " - " <var2> 
    label_pattern = "\w+: " \w+     
    joined_statement := ""
    For i, statement In p_clip_lines
    {
        expression := RegExReplace(statement, "i)^.*OutputDebug.*%\s*(.*?)$", "$1", replaced_count)
        ; insert correct delimeter between expressions.
        If (i > 1)
        {
            If RegExMatch(expression, label_pattern)
                expression := StrReplace(expression, Chr(34), Chr(32) Chr(34) " - ",,1)
            Else
                expression := delim_string expression 
        }
        joined_statement .= expression
    }
    joined_statement := "OutputDebug, % " joined_statement
    Return joined_statement
}
