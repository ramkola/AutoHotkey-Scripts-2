/* 
    If caret is on a #Include statement this program 
    will open the include file on that line.
    
    If instead any text is selected a file open dialog will
    appear where you can manually open a file. Then a Find
    dialog will appear with the selected text. This is useful
    for example, if you select a procedure call and know
    its in utils.ahk, to find that procedure within the file.
    
    If no text is selected and caret is not on an #Include
    statement, a file open dialog will appear where you can
    manually open a file.
    
    Note:
        At the moment assumes all Include files are in AHK_ROOT_DIR\lib
*/
#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
#Include lib\npp.ahk
#Include lib\strings.ahk
#Include lib\constants.ahk
SetWorkingDir %AHK_ROOT_DIR%

default_include_lib = %AHK_ROOT_DIR%\lib
saved_clipboard := ClipboardAll
save_caretx := A_CaretX
save_caretY := A_CaretY
Clipboard := ""
the_line := check_selection_copy(0,1,0)
selected_text := InStr(the_line,"FAILED", True) ? False : True
If !selected_text
{
    SendInput !{Home}+{End}^c
    ClipWait,2
    the_line := Clipboard
    Click, %save_caretx%, %save_carety%     ; restore caret position
}
If Not InStr(the_line, "#include")
    handle_error("Line does not have #Include statement:`r`n" the_line, default_include_lib, selected_text, the_line)
;
; assumption AHK_ROOT_DIR
the_file := AHK_ROOT_DIR "\" Trim(StrReplace(the_line, "#include", ""))
If !FileExist(the_file)
    handle_error("File does not exist:`r`n" the_file, default_include_lib, selected_text, the_line)
npp_open_file(the_file)
If selected_text
    WinMenuSelectItem, A,,Search,Find
Clipboard := saved_clipboard
ExitApp

handle_error(p_msg, p_default_dir, p_selected_text, p_search_text := "")
{
    SetTimer, SELECT_FIRST_FILE, -300
    FileSelectFile, selected_file, 1, %p_default_dir%,, AutoHotkey(*.ahk)
    If !FileExist(selected_file)
    {
        MsgBox, 48,, % p_msg "`r`n`r`nNo File Selected"
        ExitApp
    }
    npp_open_file(selected_file)
    ControlFocus, SysListView321, A
    Sleep 10
    SendInput {Down}{Up}    ; highlight first line
    
    If (p_search_text <> "") and p_selected_text
    {
        WinMenuSelectItem, A,, Search, Find
        Sleep 100
        SendInput %p_search_text%
    }
    ExitApp

SELECT_FIRST_FILE:
    ControlFocus, DirectUIHWND2, A
    Sleep 10
    SendInput {Down}{Up}    ; highlight first line
    Return
}

