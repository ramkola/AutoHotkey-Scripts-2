#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\objects.ahk
#Include lib\processes.ahk
#Include lib\strings.ahk
#Include lib\constants.ahk
#Include lib\utils.ahk
#NoEnv
; #NoTrayIcon
#SingleInstance Force
SendMode Input
SetWorkingDir %AHK_MY_ROOT_DIR%
StringCaseSense Off
Menu, Tray, Icon, ..\resources\32x32\icons8-under-construction-32.png

WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
OutputDebug, DBGVIEWCLEAR
WinActivate, ahk_class Notepad++ ahk_exe notepad++.exe

in_file := "C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts\Misc\Shortcut Mapper List - Unformatted.txt"
comma_mask := chr(182)  ; ¶ paragraph symbol chosen because it shows up well in debugger
hotkey_file := []
;---------------------------------------------------
; Find shortcut definition records in shortcuts.xml
;---------------------------------------------------
shortcut_definitions_lines := []
OUTER:
Loop, read, %in_file%
{
    ; blank copy of def_hotkey_rec defined in lib\objects.ahk
    hotkey_rec := def_hotkey_rec.clone()

    LineNumber = %A_Index%
    delimeter_checked_readline := remove_extra_commas(A_LoopReadLine, comma_mask)
    Loop, parse, delimeter_checked_readline, CSV
    {
        if (A_Index = 1)    ; name
            hotkey_rec["comment"] := A_LoopField
        else if (A_Index = 2)   ; shortcut
        {
            If (A_LoopField == "")
                continue OUTER   ; no hotkey to process skip to next record
            else
                hotkey_rec["translated"] := A_LoopField
        }
        else if (A_Index = 3)   ; category
        {
            if (A_LoopField != "")                   
                hotkey_rec["scope"] := A_LoopField
        }
        else if (A_Index = 4)   ; scope
        {
            ; xxxdebug := hotkey_rec["scope"]
            ; OutputDebug, % "hotkey_rec[scope]: |" xxxdebug "| " strlen(xxxdebug)
            if StrLen(hotkey_rec["scope"]) = 0
                hotkey_rec["scope"] := A_LoopField
            else
                hotkey_rec["scope"] := hotkey_rec["scope"] "/" A_LoopField
        }
        else
        {
            errmsg := "Unexpected Delimeter. Too many comma delimeters found on line# " line_number "`n" delimeter_checked_readline
            MsgBox % errmsg
            ExitApp
        }
    }
    
    untranslate(hotkey_rec)
    if (hotkey_rec["firing_key"] != "")
    {
        hotkey_rec["comment"] := StrReplace(hotkey_rec["comment"], comma_mask, ",")     ; puts back commas that weren't delimeters and were stripped when creating delimeter_checked_readline
        hotkey_file.push(hotkey_rec)                   
    }
}

for i_index, hk_rec in hotkey_file
{
    OutputDebug, --------------------------------------------------------------------------
    OutputDebug, % Format("{:03}) {:-7},", i_index, hk_rec["hot_key"]) hk_rec["translated"]
    OutputDebug, % "     " hk_rec["comment"] ", " hk_rec["scope"] 
}

ExitApp

; converts Ctrl+Alt+U to ^!u
untranslate(p_hotkey_rec)
{
    trans := p_hotkey_rec["translated"]
    if Instr(trans, "ctrl")
    {
        p_hotkey_rec["control_key"] := True
        p_hotkey_rec["hot_key"] .= "^"
    }
    if Instr(trans, "alt")
    {
        p_hotkey_rec["alt_key"] := True
        p_hotkey_rec["hot_key"] .= "!"
    }
    if Instr(trans, "shift")
    {
        p_hotkey_rec["shift_key"] := True
        p_hotkey_rec["hot_key"] .= "+"
    }
    pos := Instr(trans, "+",, -1, 1)
    p_hotkey_rec["firing_key"] := Substr(trans,pos + 1)
    p_hotkey_rec["hot_key"] .= p_hotkey_rec["firing_key"]
    
    Return
}

remove_extra_commas(p_line,p_mask)
{
    if instr(p_line, ",", false, 1, 4)
    {
        good_comma := instr(p_line, ",", false, -1, 3) - 1
        bad_commas := Substr(p_line, 1, good_comma)
        end_part := Substr(p_line, good_comma + 1)
        first_part := StrReplace(bad_commas, ",", p_mask)
        p_line := first_part . end_part
    }
    return p_line
}

