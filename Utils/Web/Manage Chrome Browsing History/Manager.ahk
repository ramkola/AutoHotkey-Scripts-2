#NoEnv
#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\strings.ahk
#Include lib\Class_SQLiteDB.ahk
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
Global save_lv_sites := []      ; array that preserves unfiltered listview values
Gui, Show,, Chrome Browser History
but_refresh_history()   ; initialize listview
; Set focus on first item in listview control
GuiControl, Focus, lv_sites
LV_Modify(1, "+Focus +Select")

Gui, Color, F0F0F0
Gui, Show,, Chrome Browser History
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



rad_filter(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="")
{
    GuiControl, -Redraw, lv_sites
    GuiControlGet, rad_filter_selected
    GuiControlGet, rad_filter_checked
    GuiControlGet, rad_filter_selected_checked
    GuiControlGet, rad_filter_none
    ; preserve unfiltered status of listview
    Loop, % LV_GetCount()
    {
        LV_GetText(website, A_Index, 1)
        selected := is_lvrow_selected(A_Index, False)
        checkmarked := is_lvrow_checked(A_Index, False)
        LV_Modify(A_Index,,website, selected, checkmarked)
        save_lv_sites.push([A_Index, website, selected, checkmarked])
    }   

    LV_Delete()
    For row_index, record in save_lv_sites
    {
        add_record := False
        website := record[2]
        selected := record[3]
        checkmarked := record[4]
        If rad_filter_none
            add_record := True
        Else If rad_filter_selected and selected
            add_record := True
        Else If rad_filter_checked and checkmarked
            add_record := True
        Else If rad_filter_selected_checked and selected and checkmarked
            add_record := True
        Else
            add_record := False
        If add_record
        {
            row_num := LV_Add("", website, selected, checkmarked)
            If selected
                LV_Modify(row_num, "Select")
            If checkmarked
                LV_Modify(row_num, "Check")
        }
    }
    GuiControl, +Redraw, lv_sites 
    Return
}

exit_func()
{
    GoSub GuiClose
}
GuiEscape:
GuiClose:
    osqlite.Close()
    source := A_WorkingDir "\History.db"
    dest = C:\Users\Mark\AppData\Local\Google\Chrome\User Data\Default\History
    If changes_made
    {
        Loop
        {
            FileCopy, %source%, %dest%, 1
            If ErrorLevel
                MsgBox, % "ErrorLevel: " ErrorLevel " - Line#" A_LineNumber " (" A_ScriptName " - " A_ThisFunc ")"
            Else
                Break
        }
    }
    FileDelete, %source%
    ; WinClose, Sqlite3 ahk_class ConsoleWindowClass ahk_exe cmd.exe   
    WinClose, ahk_class ConsoleWindowClass ahk_exe cmd.exe   
    ExitApp
    