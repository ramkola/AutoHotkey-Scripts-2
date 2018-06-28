#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\objects.ahk
#Include lib\strings.ahk
#Include lib\constants.ahk
#NoEnv
#NoTrayIcon
#SingleInstance Force
SendMode Input
StringCaseSense Off
SetWorkingDir %AHK_MY_ROOT_DIR%

WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
OutputDebug, DBGVIEWCLEAR
WinActivate, ahk_class Notepad++ ahk_exe notepad++.exe

in_file := "C:\Users\Mark\Google Drive\Misc Backups\Notepad++\shortcuts.xml"
hotkey_file := []
;---------------------------------------------------
; Find shortcut definition records in shortcuts.xml
;---------------------------------------------------
shortcut_definitions_lines := []
FileRead, in_file_var, %in_file%
Loop, Parse, in_file_var, `n, `r
{
    ; find lines that a have hotkey definition in it
    ; Skip Key=0 records, they have no hotkey assigned.
    ; Skip Shortcut Id records, these are <InternalCommands> in shortcuts.xml. Notepad++ shortcuts are better retrieved with "NPP Shortcut Mapper - Get List.ahk"
    found := RegExMatch(A_LoopField, "i)[^shortcut id]name|ScintID=.*Ctrl.*Alt.*Shift.*[^Key=""0""]Key.*", match)
    if found
        shortcut_definitions_lines.push(trim(A_LoopField))
}
;-----------------------------------------------------------------------
; Parse shortcut definition records into the standard hotkey_rec format
;-----------------------------------------------------------------------
for i, shortcut_def in shortcut_definitions_lines
{
    ; blank copy of def_hotkey_rec defined in lib\objects.ahk
    hotkey_rec := def_hotkey_rec.clone()
    
    ;--------------------------------------------------------------
    re_search = i)(?<=name=").*?(?=")          ; get text from name="<text>" string
    RegExMatch(shortcut_def, re_search, match)
    if (match != "")
        hotkey_rec["comment"] := match
    ;
    re_search = i)(?<=ScintID=").*?(?=")          ; get text ScintID="<text>" string 
    RegExMatch(shortcut_def, re_search, match)
    If (match != "")
        hotkey_rec["comment"] := get_scintilla_function(match)
    ;
    re_search = i)(?<=Shortcut id=").*?(?=")          ; get text from Shortcut id="<text>" string
    RegExMatch(shortcut_def, re_search, match)
    If (match != "")
        hotkey_rec["comment"] := "Notepad++ Internal Commands"
    ;--------------------------------------------------------------
    re_search = i)(?<=Ctrl=").*?(?=")          ; get text from Ctrl="<text>" string 
    RegExMatch(shortcut_def, re_search, match)
    if (match = "yes")
    {
        hotkey_rec["control_key"] := True
        hotkey_rec["hot_key"] .= "^"
        hotkey_rec["translated"] .= "Ctrl+"
    }
    ;
    re_search = i)(?<=Alt=").*?(?=")           ; get text from Alt="<text>" string 
    RegExMatch(shortcut_def, re_search, match)
    if (match = "yes")
    {
        hotkey_rec["alt_key"] := True
        hotkey_rec["hot_key"] .= "!"
        hotkey_rec["translated"] .= "Alt+"
    }
    ;
    re_search = i)(?<=Shift=").*?(?=")         ; get text from Shift="<text>" string 
    RegExMatch(shortcut_def, re_search, match)
    if (match = "yes")
    {
        hotkey_rec["shift_key"] := True
        hotkey_rec["hot_key"] .= "+"
        hotkey_rec["translated"] .= "Shift+"
    }
    ;
    re_search = i)(?<=Key=").*?(?=")           ; get text from Key="<text>" string 
    RegExMatch(shortcut_def, re_search, match)
    if (match != "")
    {
        hotkey_rec["firing_key"] := chr(match)
        hotkey_rec["hot_key"] .= hotkey_rec["firing_key"]
        hotkey_rec["translated"] .= hotkey_rec["firing_key"]
    }
    ;
    hotkey_rec["scope"] := "Notepad++"
    if (hotkey_rec["firing_key"] != "")
        hotkey_file.push(hotkey_rec)
}

for i_index, hk_rec in hotkey_file
{
    OutputDebug, --------------------------------------------------------------------------
    OutputDebug, % Format("{:02}) {:-7},", i_index, hk_rec["hot_key"]) hk_rec["translated"]
    OutputDebug, % "    " hk_rec["comment"] ", " hk_rec["scope"] 
}

ExitApp
