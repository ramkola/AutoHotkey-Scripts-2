#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\constants.ahk
#Include lib\utils.ahk
#SingleInstance Force
SetWorkingDir %AHK_ROOT_DIR%
SetTitleMatchMode 1
#NoTrayIcon

WinMenuSelectItem, A, , Settings, Shortcut Mapper
Sleep 500
WinGetTitle, sc_mapper_title, A
WinGetClass, sc_mapper_class, A
win_title := sc_mapper_title . " ahk_class " . sc_mapper_class

tabnames := ["Main Menu","Macros","Run commands","Plugin Commands","Scintilla commands"]

; This loop converts the shortcut_map string each related data on separate lines
; into a 4 field array for easier handling and formatting. 
cr = `n
shortcuts_all := []
For j_index, tab_name in tabnames
{   
    if j_index > 1
    {
        SendInput {Right} ; setfocus on next tab
        Sleep 500
    }
    shortcut_map := []
    ControlGet, shortcut_list, List,,ListBox1, A
    ; convert shortcut listing from a string to an array
    shortcut_map := StrSplit(shortcut_list, cr)

    i_index := 1
    sc_idnum := SubStr(shortcut_map[i_index], 1, 5)
    current_id := sc_idnum 
    While (i_index <= shortcut_map.Length())
    {
        field001 := ""
        field002 := ""
        field003 := ""
        field004 := tab_name
        sc_idnum := SubStr(shortcut_map[i_index], 1, 5)
        While (current_id == sc_idnum)
        {
            sc_index := Substr(shortcut_map[i_index], 7, 3)
            sc_value := Substr(shortcut_map[i_index], 14) 
            field%sc_index% := sc_value
            i_index++
            current_id := SubStr(shortcut_map[i_index], 1, 5)
        } 
        shortcuts_all.push([field001, field002, field003, field004])
    } 
}

if WinActive(win_title)
    WinClose, %win_title%

;Build a string of the 4 fields in 1 line and write it to a file
shortcuts_string := ""
for i, j in shortcuts_all
    shortcuts_string .= j[1]","j[2]","j[3]","j[4]"`n"

file_name := "Misc\Shortcut Mapper List - Unformatted.txt"
FileDelete, %file_name%
FileAppend, %shortcuts_string%, %file_name%
; Run, %file_name% 
Run, MyScripts\NPP\Shortcut Mapper\Format List.ahk
ExitApp 
