#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\strings.ahk
#Include lib\constants.ahk
#Include lib\utils.ahk
#NoEnv
#SingleInstance Force 
SetTitleMatchMode 2
StringCaseSense Off
SetWorkingDir %AHK_ROOT_DIR%
Menu, Tray, Icon, ..\resources\32x32\Search\search (2).png

OutputDebug, DBGVIEWCLEAR
#Include lib\utils.ahk 
OnExit("restore_cursors")
set_system_cursor("IDC_WAIT")

lib_procs_wintitle = Lib Procedures Documenter.txt - Notepad++ ahk_class Notepad++ ahk_exe notepad++.exe
; assume the selected text passed to here is a line containing a procedure call
assumed_proc_call_selection := Trim(A_Args[1])
assumed_proc_call_text := RegExReplace(assumed_proc_call_selection, ".*?(\w+)\(?.*\)?", "$1")
If (assumed_proc_call_text == "")
    find_regex_text := ""
Else
    find_regex_text = ^proc call:\s+%assumed_proc_call_text%.*?\b

regex_flag := (find_regex_text <> "")

RunWait, MyScripts\NPP\Misc\Find All In Current Document.ahk "%find_regex_text%" %regex_flag%
line_num := 0
If (find_regex_text <> "")
{
    ControlGetText, search_results, Scintilla1, %lib_procs_wintitle%   
    line_num := get_line_num_from_search_results(search_results, find_regex_text)
    If line_num
        If goto_line(line_num, lib_procs_wintitle)
            GoSub !+F7      ; open library and scroll to proc call
    Else
        MsgBox, 48,, % "Could not find proc call: " find_regex_text "`r`nYou have to search for it manually." 
}
; exit automatically if I'm not still looking at:  
; "Lib Procedures Documenter.txt" file or in the Search\Find dialog.
SetTimer, EXIT_LIB_PROCEDURES, 30000  
SetTimer, KILL_RELOAD_PROMPT, 100
restore_cursors()
Return

;=========================================================================================

!+F7::      ; search Lib Procedures Documenter.txt for library, open library and scroll to proc call.
    If !WinActive(lib_procs_wintitle)
    {
        MsgBox, 48,, % "Unexpected Error. Active window is not: " lib_procs_wintitle
        Goto EXIT_LIB_PROCEDURES
    }
    
    ; find library filename
    saved_clipboard := ClipboardAll
    Clipboard := ""
    SendInput !{Home}+{End}^c
    ClipWait, 1
    library_found := RegExMatch(Clipboard, "i)^library:.*$")
    countx := 0
    While Not library_found And countx < 20
    {
        If library_found
            Break                   
        SendInput {Up}!{Home}+{End}^c
        Sleep 100
        library_found := RegExMatch(Clipboard, "i)^library:.*$")
        countx++
    }   
    library := Trim(SubStr(Clipboard, StrLen("library:") + 1))
    If Not FileExist(library)
    {
        MsgBox, 48,, % "Library does not exist: `r`n" library, 10
        Goto EXIT_LIB_PROCEDURES
    }
    ; find proc call in library file
    SendInput {Down}!{Home}+{End}^c
    Sleep 100
    proc_pos:= RegExMatch(Clipboard, "iO)\w+\(.*\)", match)
    If proc_pos
    {
        proc_call := match.value   
        line_num := get_proc_line(proc_call, library)
    }
    Else
    {
        OutputDebug, % A_ThisHotkey " - " A_LineNumber " - " A_LineFile "`r`nCould not find procedure call: `r`n" proc_call
        Goto EXIT_LIB_PROCEDURES
    }
    ; scroll (Go To...) to procedure call in the library file
    WinMenuSelectItem, %lib_procs_wintitle%,, File, Open
    Sleep 500
    SendInput %library%{Enter}
    Sleep 500
    WinGetTitle, lib_wintitle, A
    If Not goto_line(line_num, lib_wintitle)
    {
        OutputDebug, % A_ThisHotkey " - " A_LineNumber " - " A_LineFile "`r`nCould not go to line number: `r`n" line_num " - Library: " lib_wintitle
        Goto EXIT_LIB_PROCEDURES
    }
    Return
    
KILL_RELOAD_PROMPT:
    ; File modified window if Lib Procedures Documenter.txt was already
    ; open when Lib Procedures Documenter.ahk was re-excuted. 
    ; Respond Yes to prompt...doesn't matter in any way...
    If WinExist("Reload ahk_class #32770 ahk_exe notepad++.exe")
    {
        WinActivate
        SendInput !y
    }
    RETURN
 
EXIT_LIB_PROCEDURES:
    active_wintitle := get_filepath_from_wintitle(True)
    If RegExMatch(active_wintitle, "i)(Lib Procedures Documenter.txt|Find|Reload|Lib Procedures Documenter - Open Library.ahk)")
        Return
    restore_cursors()
    Clipboard := saved_clipboard
    ExitApp

;=========================================================================================

goto_line(p_line_num,p_wintitle)
{        
    goto_wintitle = Go To... ahk_class #32770 ahk_exe notepad++.exe 
    WinMenuSelectItem, %p_wintitle%,, Search, Go to...
    Sleep 100
    ControlSetText, Edit1, %p_line_num%, %goto_wintitle%
    ; mark Line radio button
    ControlGet, is_checked, Checked,, Button1, %goto_wintitle%
    If Not is_checked
        Control, Check,, Button1, %goto_wintitle% 
    While WinActive(goto_wintitle)
    {
        ControlClick, Button3, %goto_wintitle%,,,, NA  ; Go  Button
        Sleep 100
    }
    cur_line_num := get_statusbar_info("curline") 
    Return (cur_line_num = p_line_num)
}

get_proc_line(p_proc_call, p_library)
{
    line_num := 0
    FileRead, in_file_var, %p_library%
    file_array := StrSplit(in_file_var, "`n", "`r")
    For line_num, line_text in file_array        
    {
        proc_pos:= InStr(line_text, p_proc_call)
        If proc_pos = 1
        {
            line_num := line_num
            found := True
            Break
        }
    }
    Return %line_num%
}

get_line_num_from_search_results(p_search_results, p_find_regex_text)
{
    search_results_regex_expression := StrReplace(p_find_regex_text, "^", "^\s+Line\s\d+:\s", replaced_count, 1)
    ; find first search result that matches the procedure we are looking for (ie: p_find_regex_text)
    Loop, Parse, p_search_results, `n, `r
    {
        found_pos := RegExMatch(A_LoopField, search_results_regex_expression)
        If found_pos
        {
            found_line := Trim(A_LoopField)
            Break
        }
    }
    line_num := RegExReplace(found_line, "Line\s(\d+):\s.*", "$1")
    Return (line_num > 0) ? line_num : 0
}
