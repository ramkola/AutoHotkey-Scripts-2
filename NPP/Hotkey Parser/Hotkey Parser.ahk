/* 
Need Support for AltGr and UP
else if (char == "<^>!")
    p_hotkey_rec["alt_gr"] := True
    up_mod
*/

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
Menu, Tray, Icon, ..\resources\32x32\icons8-under-construction-32.png

WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
OutputDebug, DBGVIEWCLEAR
WinActivate, ahk_class Notepad++ ahk_exe notepad++.exe

in_file := "MyScripts\MyHotkeys.ahk"
out_file := "zzzzzhotkey_rec.dat"
current_scope := "Global"
hotkey_file := []
FileRead in_file_var, %in_file%
Loop, Parse, in_file_var, `n, `r
{
    ; blank copy of def_hotkey_rec defined in lib\objects.ahk
    hotkey_rec := def_hotkey_rec.clone()
    hotkey_rec["scope"] := current_scope
    
    ; Skip comments
    If RegExMatch(A_LoopField,"\A\s*;")
        Continue
    
    If RegExMatch(A_LoopField, "i)\A#If")
    {
        current_scope := A_LoopField
        hotkey_rec["scope"] := A_LoopField
    }   
    If RegExMatch(A_LoopField, "\A.*(?=::)", match, 1)
    {
        hotkey_rec["hot_key"] := match      
        RegExMatch(A_LoopField, "(?<=;\s).*", match)
        hotkey_rec["comment"] := match
    }   
    If (hotkey_rec["hot_key"] != "")
    {
        set_hotkey_record(hotkey_rec)
        edit_scope(hotkey_rec)
        hotkey_file.push(hotkey_rec)
    }
}

; for i_index, hk_rec in hotkey_file
; {
    ; OutputDebug, % "----------------------------------------------------------------------------------------------------------"
    ; OutputDebug, % Format("{:03}) {:-15} | {:-15} |", i_index, hk_rec["hot_key"], hk_rec["translated"]) hk_rec["scope"]
    ; OutputDebug, % hk_rec["comment"]
; }

For i_index, hk_rec in hotkey_file
{
    OutputDebug, ------------------------------
    For key, value in hk_rec {
        OutputDebug, %key%: %value%
    }
}

FileDelete, %out_file%
For i_index, hk_rec in hotkey_file
{
    write_string := ""
    For key, value in hk_rec {
        write_string = %write_string%,%key%:%value%
    }
    write_string := SubStr(write_string,2) "`n"
    FileAppend, %write_string%, %out_file% 
}

MsgBox,,,DONE,1

ExitApp 

set_hotkey_record(p_hotkey_rec)
{
    ; modifiers: "#","!","^","+","<",">" | "*","~","$" | "&", "<^>!","UP"
    hk_string := p_hotkey_rec["hot_key"]
    
    ; check for custom combination type hotkey (ie LWin & WheelUp)
    If InStr(hk_string," & ")
    {
        ; copy everything before the & 
        RegExMatch(hk_string,"^.*(?=\s&\s)", match) 
        p_hotkey_rec["prefix_key"] := match
        ; copy everything after the &   (.* needed. \w will miss some allowable keys like ')  
        RegExMatch(hk_string,"(?<=\s&\s).*", match) 
        p_hotkey_rec["firing_key"] := match
        p_hotkey_rec["ampersand"] := True
        Goto RETURN_NOW
    }    
        
    hk_array := StrSplit(p_hotkey_rec["hot_key"])
    For i_index, char in hk_array
    {
        If (char == "#")
            p_hotkey_rec["win_key"] := True
        Else If (char == "!")
            p_hotkey_rec["alt_key"] := True
        Else If (char == "^")
            p_hotkey_rec["control_key"] := True
        Else If (char == "+")
            p_hotkey_rec["shift_key"] := True
        Else If (char == "~")
            p_hotkey_rec["tilde"] := True
        Else If (char == "*")
            p_hotkey_rec["wildcard"] := True
        Else If (char == "$")
            p_hotkey_rec["dollar_sign"] := True
        Else If (char == "<")
            p_hotkey_rec["left_arrow"] := True
        Else If (char == ">")
            p_hotkey_rec["right_arrow"] := True
        Else
        {
            ; end of modifiers reached starting firing_key definition
            p_hotkey_rec["firing_key"] := Trim(SubStr(hk_string, i_index))
            Break
        }   
    }
    
RETURN_NOW:
    ; converts ^!p to Ctrl+Alt+p 
    translate_modifiers(p_hotkey_rec)
    Return 
}

translate_modifiers(p_hotkey_rec)
{
    ; no translation needed for custom combinations or hotkeys without modifiers.
    no_modifiers := !p_hotkey_rec["win_key"] and !p_hotkey_rec["control_key"] and !p_hotkey_rec["alt_key"] and !p_hotkey_rec["shift_key"]
    If InStr(hk_string," & ") or no_modifiers
    {
        p_hotkey_rec["translated"] := p_hotkey_rec["hot_key"]
        Return 
    }
    ;
    ; translate modifiers
    mod_string := ""
    If p_hotkey_rec["win_key"]
        mod_string .= get_modifier_string("Win", p_hotkey_rec)
    If p_hotkey_rec["control_key"]
        mod_string .= get_modifier_string("Ctrl", p_hotkey_rec)
    If p_hotkey_rec["alt_key"]
        mod_string .= get_modifier_string("Alt", p_hotkey_rec)
    If p_hotkey_rec["shift_key"]
        mod_string .= get_modifier_string("Shift", p_hotkey_rec)
    ; remove leading plus sign and add the firing_key
    mod_string := SubStr(mod_string,2) "+" StringUpper(p_hotkey_rec["firing_key"])
    p_hotkey_rec["translated"] := mod_string
    Return
}

get_modifier_string(p_mod_key, p_hotkey_rec)
{
    If p_hotkey_rec["left_key"]       
        mod_string := "+L" . p_mod_key
    Else If p_hotkey_rec["right_key"]       
        mod_string := "+R" . p_mod_key
    Else
        mod_string := "+" . p_mod_key

    Return %mod_string%
}

edit_scope(p_hotkey_rec)
{
    scope := p_hotkey_rec["scope"]
    scope := RegExReplace(scope, ";.*", "")
    scope := RegExReplace(scope, "i)#ifwinactive|#ifwinexist|#if\s*", "")
    scope := StrReplace(scope, "winactive(""","")
    scope := StrReplace(scope, "winexist(""","")
    scope := StrReplace(scope, """)", "")
    scope := StrReplace(scope, "ahk_class ", "")
    scope := StrReplace(scope, "ahk_exe ", "")
    If (scope == "")
        scope := "Global"
    p_hotkey_rec["scope"] := scope
    Return
}




