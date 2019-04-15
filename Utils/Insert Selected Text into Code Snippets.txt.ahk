#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\strings.ahk
#Include lib\npp.ahk
#Include lib\constants.ahk
SetWorkingDir %AHK_ROOT_DIR%
g_TRAY_EXIT_ON_LEFTCLICK := True      ; set only 1 to true to enable, see lib\utils.ahk

key_word := select_and_copy_word()
key_word := RegExReplace(key_word,"(\s|`r|`n)", "")
If (key_word == "")
{
    MsgBox, 48,, % "Error: Cursor not on word / nothing selected..."
    Return
}

msg = `r`n`r`n    Select code lines to be added with MOUSE then hit {Return} to accept. {Escape} to cancel.    `r`n`r`n.
Loop, 5
{
    ToolTip, %msg%, 800, 0
    Sleep 100
    ToolTip, %msg%, 800, 150
    Sleep 100
}
Input,ov, L1 ,{Escape}{Return}
If (ErrorLevel = "EndKey:Escape")
    Goto INSERT_CS_EXIT
ToolTip
SendInput ^c
ClipWait, 2
code_snippet := Clipboard 
;
one_tab := "    " ; 4 spaces
write_string := "`r`n`r`n" chr(59) " " key_word "`r`ncs =`r`n" one_tab "(Join``r``n LTrim `%`r`n"
Loop, Parse, code_snippet, `n, `r
    write_string .= one_tab one_tab A_LoopField "`r`n"
write_string .= one_tab ")`r`ncode_snippetz[" chr(34) key_word chr(34) "] := cs"

cs_file = %AHK_ROOT_DIR%\lib\Code Snippets.txt
FileAppend, %write_string%, %cs_file%
WinMenuSelectItem, A,, File, Open
Sleep 300
SendInput %cs_file%
Sleep 1000
SendInput {Enter}
;
saved_autotrim := A_AutoTrim
AutoTrim Off
Clipboard = %one_tab%Else If RegExMatch(p_word,`"i)\b%key_word%.*\b`")`r`n%one_tab%%one_tab%code_snippet := p_code_snippet_array[`"%key_word%`"]
ClipWait, 2 
AutoTrim := saved_autotrim
MsgBox, 33,, % "The required code is saved on the Clipboard.`r`n`r`nOk to edit Insert Snippet for Selected Word.ahk?"
IfMsgBox, Cancel
    Goto INSERT_CS_EXIT

; edit Insert Snippet for Selected Word.ahk
insert_file = C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts\MyScripts\Utils\Insert Snippet for Selected Word.ahk
WinMenuSelectItem, A,, File, Open
Sleep 300
SendInput %insert_file%
Sleep 1000
SendInput {Enter}
Sleep 300

line_num := 0
code_line = #### DO NOT REMOVE THIS COMMENT. IT IS USED TO FIND THIS LINE NUMBER IN THIS CODE BY OTHER PROGRAMS ###
FileRead, in_file_var, %insert_file% 
Loop, Parse, in_file_var, `n, `r 
{
    If (SubStr(Trim(A_LoopField), 3) == code_line)
    {
        line_num := A_Index
        Break
    }
}
line_found := goto_line(line_num-1, insert_file)  ; takes you to the insertion point for the line of code where Clipboard contents should be pasted.
If line_found
{
    SendInput {Enter}{Up}
    MouseGetPos, x, y
    Loop, 7
    {
        Tooltip, % "`r`n    Paste code on this line here....    `r`n ", x+5, y+5
        Sleep 500
        Tooltip
        Sleep 100
    }
    Tooltip  
    
}
INSERT_CS_EXIT:
SetTitleMatchMode %A_TitleMatchMode%
; WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
ExitApp
