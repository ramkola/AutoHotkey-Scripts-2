#NoEnv
#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\strings.ahk
#Include lib\utils.ahk
#Include lib\Class_SQLiteDB.ahk
;
#Include %A_ScriptDir%
#Include Lib.ahk
#Include Gui.ahk
SetWorkingDir %A_ScriptDir%
OnExit("exit_func")

OutputDebug, DBGVIEWCLEAR
WinActivate, ahk_class Notepad++ ahk_exe notepad++.exe
WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe

Global osqlite := new SQLiteDB
Global sql_query_results := ""  ; sql view for any query
Global changes_made := False    ; tracks whether Chrome History database should be overwritten 
Global save_lv_sites := {}      ; array that preserves unfiltered listview values
Gui, Color, EFF0F0
Gui, Show,, Chrome Browser History  
but_refresh_history()   ; initialize listview
; Set focus on first item in listview control
GuiControl, Focus, lv_sites
LV_Modify(1, "+Focus +Select")

Return
;-----------------------------------------------------------------------------
#If WinActive("Chrome Browser History")
!w::
    GuiControl, Focus, lv_sites
Return

Enter::
    ControlGetFocus, got_focus, A
    If (got_focus = "Edit1")
        select_by_regex_search()
    Else If (got_focus = "SysListView321")
        but_visit_site()
Return

;--------------------------------------------------------------
; rad_add_to_category must be here for program to load properly.
; It has to be a label and not a procedure in order for the 
; radio buttons to work. It really belongs to Gui - AddTo.ahk
;--------------------------------------------------------------
; rad_add_to_category()
rad_add_to_category:
{
    Gui, 2:Submit, NoHide
    saved_category_num := rad_selected_category
    saved_include_num := rad_include
    Return
}

;--------------------
; TEST TEST TEST
;--------------------
but_focused_website_links(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="")
{
    row_num := LV_GetNext(0, "Focused")
    If (row_num = 0)
        Return
    LV_GetText(url, row_num, 1)
    Gui, Show, Hide
    RunWait, Focused Website Links.ahk %url%
    Return
}

exit_func()
{
    GoSub GuiClose
}
GuiEscape:
GuiClose:
    restore_cursors()
    osqlite.Close()
    save_changes_to_chrome()
    FileDelete, %source%
    ExitApp
    