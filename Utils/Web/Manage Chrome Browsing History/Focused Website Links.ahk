#SingleInstance Force
#Include %A_ScriptDir%
#Include Lib.ahk

p_url := A_Args[1]
If (p_url == "")
{
    MsgBox, 48,, % "No website has focus"
    Return
}

get_chrome_history("Select title, url, id from urls where url like ""%://" p_url "%"" order by id;")
links := []
get_links(links)

Gui, Add, ListView, vlv_links glv_links w300 r20 Checked Sort AltSubMit Multi,TITLE|URL|DB_ID
Gui, Add, Button, vbut_delete gbut_delete, % "&Delete"
Gui, Add, Button, vbut_exit gbut_exit x+m, % "E&xit"
Loop, % links.Count()
    LV_Add("", links[A_Index, 1], links[A_Index, 2], links[A_Index, 3])
GuiControlGet, lv_links, POS
LV_ModifyCol(1,lv_linksw)
LV_ModifyCol(2,100)
LV_ModifyCol(3,100)
Gui , +AlwaysOnTop
Gui, Show, , Manage Website Links
Return

lv_links(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="")
{
    Critical
    ; If (gui_event = "DoubleClick")
        ; but_visit_site()
    If (gui_event == "I" and Instr(ErrorLevel, "C", False))
    {
        action := InStr(ErrorLevel, "C", True) ? "Check" : "-Check"
        row_num := 0
        Loop
        {
            row_num := LV_GetNext(row_num)
            If (row_num = 0)
                Break
            Else
                LV_Modify(row_num, action)
        }           
    }
    Return
}

but_delete(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="")
{   
    row_num := 0
    delete_cmd := ""
    Loop
    {
        row_num := LV_GetNext(row_num, "Checked")
        If (row_num = 0)
            Break
        LV_GetText(db_id, row_num, 3)
        delete_cmd .= "DELETE FROM urls WHERE id = " db_id "`r`n" 
    }
    MsgBox, % "delete_cmd: " delete_cmd
    Return
}

but_exit(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="")
{
    GoSub GuiEscape
    Return
}

GuiEscape:
GuiClose:
    WinShow, Chrome Browser History
    ExitApp
    
get_links(links)
{
    Loop, Read, results.csv
    {
        line_num := A_Index
        Loop, parse, A_LoopReadLine, CSV
            links[line_num, A_Index] := A_LoopField
    }
    Return
}
