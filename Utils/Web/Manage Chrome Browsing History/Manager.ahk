#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\strings.ahk
#Include %A_ScriptDir%
#Include Lib.ahk
#Include Gui.ahk
OnExit("exit_func")
SetWorkingDir %A_ScriptDir%
Global websites := []
Global selected_websites := []
Global changes_made := False    ; tracks whether Chrome History database should be overwritten 

Gui, Show,, Chrome Browser History
but_refresh_history()   ; initialize listview
; Set focus on first item in listview control
GuiControl, Focus, lv_sites
LV_Modify(1, "+Focus +Select")

Gui, Show,, Chrome Browser History
Return

;--------------------
; Gui Event Handlers 
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

but_mark(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="")
{
    OutputDebug, % "ctrlhwnd: " ctrlhwnd " - gui_event: " gui_event " - event_info: " event_info " - error_level: " error_level
    GuiControlGet, chk_porn
    Return
}

but_unmark(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="")
{
    but_mark(ctrlhwnd, gui_event, event_info, error_level)
    Return
}

but_visit_site(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="")
{
    row_num := LV_GetNext(0, "Focused")
    If (row_num = 0)
        Return
    LV_GetText(url, row_num, 1)
    Run, ..\Activate Browser.ahk %False% %True% %url%    
}

but_add_to(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="")
{
    Gui,2:+AlwaysOnTop +ToolWindow
    Gui, 2:Show,, Add To 
    Return
}


chk_selected_only(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="")
{
    GuiControl, -Redraw, lv_sites
    GuiControlGet, chk_selected_status
    if chk_selected_status
        selected_websites := []

    ; get current checkmark status of listview
    row_num := 0
    Loop
    {
        row_num := LV_GetNext(row_num)
        If (row_num = 0)
            Break
        Else
        {
            LV_GetText(url, row_num, 1)
            LV_GetText(name, row_num, 2)
            selected_websites.push([row_num, is_lvrow_checked(row_num), url, name])
        }
    }           

    ; show selected only or all websites
    LV_Delete()
    If chk_selected_status
        For i, j In selected_websites
            LV_Add(j[2], j[3], j[4])
    Else
    {
        For i, j in websites
            LV_ADD("", j)
        ; restore selected and checked status for applicable rows
        For i, j in selected_websites
        {
            row_num := j[1]
            action := j[2]
            LV_Modify(row_num,"Select " action)  
        }
    }
    
    GuiControl, +Redraw, lv_sites 
    Return
}


2GuiEscape:
2GuiClose:
    GuiControl,, rad_porn,  0
    GuiControl,, rad_porn1, 0
    GuiControl,, rad_porn2, 0
    GuiControl,, rad_porn3, 0
    Gui, 2:Show, Hide
    Return

exit_func()
{
    GoSub GuiClose
}
GuiEscape:
GuiClose:
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
    
