; known bug: proc calls with parameters that have literal commas are not handled properly (ie: myproc_call(param1, param2=",", param3=0) param2 will not split properly
; known bug: proc calls that parameter spread over multiple continuation lines are not found.
#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\npp.ahk
#Include lib\constants.ahk
#NoEnv
SetWorkingDir %AHK_ROOT_DIR%
Menu, Tray, Icon, ..\resources\32x32\library bookmarked.png
StringCaseSense Off
Global opt_contains, opt_begins, opt_exact, search_string, search_hwnd, scintilla_hwnd
Global proc_call_rec := []
Global active_control_hwnd          ; control that will be receiving the inserted code snippet (Scintilla in Notepad++)
ControlGetFocus, active_control_classnn, A
ControlGet, active_control_hwnd, Hwnd,,%active_control_classnn%, A

get_proc_call_info(AHK_ROOT_DIR "\lib\*.ahk")

Gui, Font, s12, Consolas
Gui, Add, Text, -Tabstop, &Search

; radio buttons
Gui, Add, Radio, vopt_contains goptions_update x222 yp    -Tabstop Checked, Co&ntains 
Gui, Add, Radio, vopt_begins   goptions_update x+0  yp hp -Tabstop, &Begins
Gui, Add, Radio, vopt_exact    goptions_update x+0  yp hp -Tabstop, &Exact
options_update()

; Regex Search Box
Gui, Add, Edit, vsearch_string gsearch_regex hwndsearch_hwnd xm w450

; Listview
lv_options = 
(Join`s LTrim 
    hwndlv_hwnd vlv_proc_call glv_update
    xm r10 w800 BackgroundFEFFCD AltSubmit Sort +READONLY
)
Gui, Add, ListView, %lv_options%, Procedure|Parameters|Library|FullPath
LV_ModifyCol(1, 400)
LV_ModifyCol(2, 400) 
LV_ModifyCol(3, 150) 
LV_ModifyCol(4, 600) 

; Buttons
Gui, Font, s12
Gui, Add, Button, hwndbtn_goto_hwnd vbtn_goto gbtn_goto       xm w70 h30   -Tabstop, &Goto
Gui, Add, Button, hwndbtn_copy_hwnd vbtn_copy gbtn_copy       x+5 yp wp hp -Tabstop, &Copy
Gui, Add, Button, hwndbtn_insert_hwnd vbtn_insert gbtn_insert x+5 yp wp hp -Tabstop, &Insert

; Enter selected string or word on current caret position into the Searc edit control.
assumed_search_string := nppexec_select_and_copy_word()
OutputDebug, % "assumed_search_string: " assumed_search_string 
GuiControl,,search_string, %assumed_search_string%
GuiControl, Focus, search_string
SendInput {End}

; Gui Window
Gui, +AlwaysOnTop 
Gui, Show,, Lib Procedures Finder
Return
;----------------------------------------
; Gui Event Handlers (formerly g-labels)
;----------------------------------------
lv_update(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="", p_proc_call_array := "" )
{
; OutputDebug, % "ctrl_hwnd: " ctrl_hwnd ", gui_event: " gui_event " - Line#" A_LineNumber " (" A_ScriptName " - " A_ThisFunc ")"

    Gui, +OwnDialogs
    If (gui_event = "User Update Event")
    {
        LV_Delete()
        For i, j In p_proc_call_array
        {
            SplitPath, % j[3], file_name
            LV_Add("", j[1], j[2], file_name, j[3])
        }
    }
    Else If (gui_event = "DoubleClick")
        btn_goto(ctrl_hwnd, gui_event, event_info, error_level)
    Else If (gui_event = "F")
    {
        row_num := 0
        row_num := LV_GetNext(row_num)
        row_num := (row_num = 0) ? 1 : row_num
        LV_Modify(row_num, "+Focus +Select")
    }
    ; If RegExMatch(gui_event,"i)(Normal|K|I)") 
    ; {
        ; ; row_num := 0
        ; ; row_num := LV_GetNext(row_num)
        ; ; LV_GetText(lv_proc_call, row_num, 2)
    ; }
    
    Return    
}

search_regex(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="")
{
    Gui, +OwnDialogs
    ControlGetText, search_string,,ahk_id %ctrl_hwnd%
    OutputDebug, % "search_string: " search_string " - gui_event: " gui_event ", ctrl_hwnd: " ctrl_hwnd " - Line#" A_LineNumber " (" A_ScriptName " - " A_ThisFunc ")"
    If opt_contains
        regex_string := "i)^.*" search_string ".*"
    Else If opt_begins    
        regex_string := "i)^\b" search_string ".*"
    Else If opt_exact
        regex_string := "i)^\b" search_string "\b$"
    Else
    {
        MsgBox, 48,, % "Unexpected Error: Unknown RegEx Search option"
        Return
    }
    filtered_proc_call_rec := []
    For i, j In proc_call_rec
    {
        If RegExMatch(j[1], regex_string)
            filtered_proc_call_rec.Push([j[1], j[2], j[3]])
    }
    lv_update(ctrl_hwnd, "User Update Event",,,filtered_proc_call_rec)
    Return
}

; lbl_search_focus(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="")
; {
    ; MsgBox, 48,, %  A_ThisFunc " (" A_ScriptName ")"
    ; ControlFocus, Edit1, Lib Procedures Finder
    ; Return
; }

options_update(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="")
{
    Gui, +OwnDialogs
    Gui, Submit, NoHide
    search_regex(search_hwnd)
    Return
}

btn_goto(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="")
{
    Gui, +OwnDialogs
    row_num := 0
    row_num := LV_GetNext(row_num)
    row_num := (row_num = 0) ? 1 : row_num
    LV_GetText(lv_proc_call, row_num, 1)
    LV_GetText(library_fullpath, row_num, 4)
    GuiControl,,search_string, %lv_proc_call%
    line_num := find_proc_call_line_num(lv_proc_call, library_fullpath)
    npp_open_file(library_fullpath)
    If line_num
        nppexec_goto_line(line_num)
    Return
}

btn_copy(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="")
{
    Gui, +OwnDialogs
    Clipboard := ""
    row_num := 0
    row_num := LV_GetNext(row_num)
    row_num := (row_num = 0) ? 1 : row_num
    LV_GetText(selected_proc_call, row_num, 1)
    LV_GetText(selected_parameters,row_num, 2)
    Clipboard := selected_proc_call "(" selected_parameters ")`r`n{`r`n`tReturn`r`n}"
    ClipWait, 1
    If (gui_event <> "User Copy Event") 
        MsgBox, 64,, % Clipboard " has been copied to the clipboard.", 1
    Return
}

btn_insert(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="")
{
    Gui, +OwnDialogs
    btn_copy(,"USER COPY EVENT")
    ControlFocus,,ahk_id %active_control_hwnd%
    Clipboard := "`r`n" Clipboard               ; bypasses auto-indent
    SendInput {End}^v
    Return
}
;--------------------
; G-Labels & Hotkeys
;-------------------
Escape::
GuiEscape:
GuiClose:
    ExitApp
    
GuiSize:
    Return

!s::
    ControlFocus, Edit1, Lib Procedures Finder
    Return
    
~Enter::
    ControlGetFocus, got_focus, A
    If (got_focus = "SysListView321")
        lv_update(lv_hwnd,"DoubleClick")
    Return
;------------------------------------------
;  Subroutines - Functions, Procedures
;------------------------------------------

tooltip_msg(p_hwnd, p_msg, p_display_time=1000, p_offset_x=20, p_offset_y=20)
{
    ControlGetPos, x, y,,,,ahk_id %p_hwnd%
    x := x + p_offset_x
    y := y + p_offset_y 
    
    ToolTip, `r`n    %p_msg%    `r`n %A_Space%, x, y
    Sleep p_display_time
    ToolTip
    Return
}

get_proc_call_info(p_lib_dir_pattern)
{
    Loop, Files, %p_lib_dir_pattern%, F
    {   
        FileRead, in_file_var, %A_LoopFileFullPath%
        file_array := StrSplit(in_file_var, "`n", "`r")
        found_pos := 1
        While (found_pos > 0)
        {
            ; extract procedure calls
            found_pos := RegExMatch(in_file_var, "mO)^\w+\(.*\).*$", match, found_pos)
            If (found_pos = 0)
                Continue        ; no procedures found go to next file
            found_pos := match.Pos + match.len  
            proc_call_original_line := Trim(match.value)
            procedure_call := Trim(RegExReplace(proc_call_original_line, "^(\w+)\(.*\).*$", "$1"))
            parameters := Trim(RegExReplace(proc_call_original_line, "m)^\w+\((.*)\).*$", "$1"))
            proc_call_rec.Push([procedure_call, parameters, A_LoopFileFullPath])
        }
    }
    Return
}

find_proc_call_line_num(p_proc_call, p_library)
{
    If !FileExist(p_library)
        Return 0
    line_num := 0
    FileRead, in_file_var, %p_library%
    Loop, Parse, in_file_var, `n, `r
    {
        If RegexMatch(A_LoopField, "i)^" p_proc_call "\(.*\)?.*$")          ;\s*\{*
        {
            line_num := A_Index
            Break
        }
    }
    Return line_num
}