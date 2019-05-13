; known bug: proc calls with parameters that have literal commas are not handled properly (ie: myproc_call(param1, param2=",", param3=0) param2 will not split properly
; known bug: proc calls that parameter spread over multiple continuation lines are not found.
#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\npp.ahk
#Include lib\strings.ahk
#Include lib\utils.ahk
#Include lib\constants.ahk
#Include lib\Center MsgBox To Active Window.ahk
#NoEnv
SetWorkingDir %AHK_ROOT_DIR%
Menu, Tray, Icon, ..\resources\32x32\library bookmarked.png
StringCaseSense Off
Global opt_contains, opt_begins, opt_exact, search_string, search_hwnd, scintilla_hwnd, lv_hwnd
Global ed_code, ed_code_hwnd, tx_matches
Global proc_call_rec := []
Global active_control_hwnd          ; control that will be receiving the inserted code snippet (Scintilla in Notepad++)
ControlGetFocus, active_control_classnn, A
ControlGet, active_control_hwnd, Hwnd,,%active_control_classnn%, A

; get_proc_call_info(AHK_ROOT_DIR "\MyScripts\*.ahk", "FR")
get_proc_call_info(AHK_ROOT_DIR "\lib\*.ahk", "F" )

Gui, Font, s12, Consolas
Gui, Add, Text, vtx_matches x100 y15 w200 r1 h+10 cBlue -Wrap -Tabstop, 0 matches found.
Gui, Add, Text, xm y50 -Tabstop, &Search   

; radio buttons
Gui, Add, Radio, vopt_contains goptions_update x100 yp    -Tabstop, Co&ntains 
Gui, Add, Radio, vopt_begins   goptions_update x+0  yp hp -Tabstop Checked, &Begins
Gui, Add, Radio, vopt_exact    goptions_update x+0  yp wp-15 hp -Tabstop, &Exact
options_update()    ; sets the opt_contains Checked

; Displays selected procedure's code
Gui, Add, Edit, ved_code hwnded_code_hwnd x350 y3 w465 r5 BackgroundFEFFCD -Tabstop -Wrap -WantTab -WantReturn -HScroll

; Regex Search Box
Gui, Add, Edit, vsearch_string gsearch_regex hwndsearch_hwnd xm y78 w330

; Listview
lv_options = 
(Join`s LTrim 
    hwndlv_hwnd vlv_proc_call glv_update
    xm r6 w800 BackgroundFEFFCD AltSubmit Sort +READONLY
)
Gui, Add, ListView, %lv_options%, Procedure|Parameters|Library|FullPath|Code
LV_ModifyCol(1, 400)
LV_ModifyCol(2, 200) 
LV_ModifyCol(3, 200) 
LV_ModifyCol(4, 150) 
LV_ModifyCol(5, 150) 

; Buttons
Gui, Font, s12
Gui, Add, Button, hwndbtn_goto_hwnd vbtn_goto gbtn_goto       xm w70 h30   -Tabstop, &Goto
Gui, Add, Button, hwndbtn_copy_hwnd vbtn_copy gbtn_copy       x+5 yp wp hp -Tabstop, &Copy
Gui, Add, Button, hwndbtn_filter_hwnd vbtn_filter gbtn_filter x+5 yp wp hp -Tabstop, &Filter
; Gui, Add, Button, hwndbtn_insert_hwnd vbtn_insert gbtn_insert x+5 yp wp hp -Tabstop +Default, &Insert
Gui, Add, Button, hwndbtn_insert_hwnd vbtn_insert gbtn_insert x+5 yp wp hp -Tabstop, &Insert

; Enter selected string or word on current caret position into the Searc edit control.
assumed_search_string := select_and_copy_word()
GuiControl,,search_string, %assumed_search_string%
GuiControl, Focus, search_string
SendInput {End}

OutputDebug, DBGVIEWCLEAR
WinActivate, ahk_class Notepad++ ahk_exe notepad++.exe
; WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe

; Gui Window
Gui, -AlwaysOnTop
Gui, Show, x445 y0, Lib Procedures Finder
Return

;----------------------------------------
; Gui Event Handlers (formerly g-labels)
;----------------------------------------
lv_update(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="")
{
; OutputDebug, % "ctrl_hwnd: " ctrl_hwnd ", gui_event: " gui_event " - Line#" A_LineNumber " (" A_ScriptName " - " A_ThisFunc ")"
; OutputDebug, % "gui_event: " gui_event " - " A_ThisFunc
    Gui, +OwnDialogs
    If (gui_event = "USER UPDATE EVENT")
    {
        LV_Delete()
        For i, j In event_info
        {
            procedure_call := j[1]
            parameters := j[2]
            file_name := j[3]
            library_fullpath := j[4]
            proc_code := j[5]
            LV_Add("", j[1], j[2], j[3], j[4], j[5])
        }
        matches_msg := event_info.count() " matches found."
        GuiControl,, tx_matches, %matches_msg% 
    }
    Else If (gui_event = "DoubleClick")     ; Else If RegExMatch(gui_event,"i)(Normal|DoubleClick)")
    {
        column_clicked := listview_get_column_clicked(lv_hwnd)
        If RegExMatch(column_clicked,"(1|2)")
            btn_insert(ctrl_hwnd, "INSERT PROC CALL EVENT")
        Else If (column_clicked = 3)
            btn_insert(ctrl_hwnd, "INSERT INCLUDE EVENT") 
        Else If (column_clicked = 4)
            btn_insert(ctrl_hwnd, "INSERT LIBRARY EVENT") 
        Else If (column_clicked = 5)
            btn_copy(ctrl_hwnd, "COPY CODE EVENT")
    }
    Else If RegExMatch(gui_event,"(Normal|F|K)")
    {
        ; highlights selected row in listview whether using mouse or 
        ; keyboard and updates ed_code with the code.
        row_num := 0
        row_num := LV_GetNext(row_num)
        row_num := (row_num = 0) ? 1 : row_num
        LV_Modify(row_num, "+Focus +Select")
        LV_GetText(procedure_code, row_num, 5)
        GuiControl,,ed_code, %procedure_code%
    }    
    Return    
}

search_regex(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="")
{
; OutputDebug, % "search_string: " search_string " - gui_event: " gui_event ", ctrl_hwnd: " ctrl_hwnd " - Line#" A_LineNumber " (" A_ScriptName " - " A_ThisFunc ")"
    Gui, +OwnDialogs
    ControlGetText, search_string,,ahk_id %ctrl_hwnd%
    If opt_contains
        regex_string := "i)^.*" search_string ".*"
    Else If opt_begins    
        regex_string := "i)^\b" search_string ".*"
    Else If opt_exact
        regex_string := "i)^\b" search_string ".*\b$"
    Else
    {
        MsgBox, 48,, % "Unexpected Error: Unknown RegEx Search option"
        Return
    }
    filtered_proc_call_rec := []
    For i, j In proc_call_rec
    {
        If RegExMatch(j[1], regex_string)
            filtered_proc_call_rec.Push([j[1], j[2], j[3], j[4], j[5]])
    }
    lv_update(ctrl_hwnd, "USER UPDATE EVENT", filtered_proc_call_rec)
    Return
}

options_update(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="")
{
    Gui, +OwnDialogs
    Gui, Submit, NoHide
    search_regex(search_hwnd)
    Return
}

btn_filter(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="")
{
    Gui, +OwnDialogs
    row_num := 0
    row_num := LV_GetNext(row_num)
    row_num := (row_num = 0) ? 1 : row_num
    LV_GetText(library_fullpath, row_num, 4)
    filtered_proc_call_rec := []
    For i, j In proc_call_rec
    {
        If (j[4] == library_fullpath)
            filtered_proc_call_rec.Push([j[1], j[2], j[3], j[4], j[5]])
    }
    lv_update(ctrl_hwnd, "USER UPDATE EVENT", filtered_proc_call_rec)
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
        goto_line(line_num)
    Return
}

btn_copy(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="")
{
    ; OutputDebug, % "ctrl_hwnd: " ctrl_hwnd ", gui_event: " gui_event " - Line#" A_LineNumber " (" A_ScriptName " - " A_ThisFunc ")"
    Gui, +OwnDialogs
    Clipboard := ""
    row_num := 0
    row_num := LV_GetNext(row_num)
    row_num := (row_num = 0) ? 1 : row_num
    LV_GetText(selected_proc_call,  row_num, 1)
    LV_GetText(selected_parameters, row_num, 2)
    LV_GetText(library_filname,     row_num, 3)
    LV_GetText(library_fullpath,    row_num, 4)
    LV_GetText(proc_code,           row_num, 5)
    If (gui_event = "INSERT PROC CALL EVENT")
        Clipboard := selected_proc_call "(" selected_parameters ")"
    Else If (gui_event = "INSERT INCLUDE EVENT")
        Clipboard := "#Include \lib\" library_filname 
    Else If (gui_event = "INSERT LIBRARY EVENT")
        Clipboard := "#Include " library_fullpath
    Else If (gui_event = "COPY CODE EVENT")
        Clipboard := proc_code
    Else
    {
        Clipboard := "#Include \lib\" library_filname 
        Clipboard := selected_proc_call "(" selected_parameters ")"
    }
    ClipWait, 1
    If RegExMatch(gui_event,"i)(Normal|COPY CODE EVENT)") 
        MsgBox, 64,, % Clipboard "`r`n`r`nhas been copied to the clipboard.", 5
    Return
}

btn_insert(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="")
{
    ; OutputDebug, % "ctrl_hwnd: " ctrl_hwnd ", gui_event: " gui_event " - Line#" A_LineNumber " (" A_ScriptName " - " A_ThisFunc ")"
    Gui, +OwnDialogs
    If (gui_event = "Normal")
        gui_event := "INSERT PROC CALL EVENT"
    btn_copy(ctrl_hwnd, gui_event)
    WinGet, control_process, ProcessName, ahk_id %active_control_hwnd%
    control_wintitle := "ahk_exe " control_process  ; retrieves the tab that is active in the editor and will receive the inserted text
    active_npp_tab := get_filepath_from_wintitle(control_wintitle, True)
    MsgBox,%  4+32,, % "Are you sure you want to insert:`r`n`r`n" Clipboard "`r`n`r`nInto:`r`n`r`n" active_npp_tab
    IfMsgBox, Yes
    {
        ControlFocus,,ahk_id %active_control_hwnd%
        SendInput ^v
    }
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

!s::    ; accelerator key to the search box
    GuiControl, Focus, search_string
    Return

^PgDn::     ; scroll code window down
^PgUp::     ; scroll code window up
    scroll_direction := (A_ThisHotkey = "^PgUp") ? "{PgUp}" : "{PgDn}"
    Controlsend,, %scroll_direction%, ahk_id %ed_code_hwnd%
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

get_proc_call_info(p_file_pattern, p_mode:="F")
{
    Loop, Files, %p_file_pattern%, %p_mode%
    {   
        FileRead, in_file_var, %A_LoopFileFullPath%
        library_fullpath := A_LoopFileFullPath
        startpos := 1
        found_pos := 9999
        While found_pos
        {   
            ; find procedures - chr(34) is a double quote
            ; Regex basicly looks for procedure patterns:
            ;   procedure_name(parameters 0 or more) { 
            ;       code between OTB or Separate lines format
            ; } 
            found_pos := RegExMatch(in_file_var
                , "isO)((?P<proc>\w+)\((?P<parm>(|[a-z\s]+[\w\s,-?=:" chr(34) "]*?))\)\s*\{\s*\n(?P<code>.*?).*?\n}\n?)"
                , match, startpos)
            If found_pos
            {
                exclude_list := "(FileExist|WinActive|WinExist|RegExMatch|RegExReplace|IsObject)"
                proc_call_entire_match := match.value(0)
                procedure_call := match.value("proc")
                parameters := match.value("parm")
                SplitPath, library_fullpath, file_name
                If Not RegExMatch(procedure_call, "i)" exclude_list)
                    proc_call_rec.Push([procedure_call, parameters, file_name, library_fullpath, proc_call_entire_match])
            }
            ; position for searching for the next procedure within the current file
            startpos := found_pos + match.len   
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

