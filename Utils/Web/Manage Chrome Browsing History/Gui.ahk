#Include Gui - AddTo.ahk
Global lv_sites_hwnd, but_mark_hwnd, but_unmark_hwnd
Menu, Tray, Icon, C:\Users\Mark\Desktop\Misc\Resources\32x32\History-01.png
;-------------------------------------- 
; GUI - Default Chrome Browser History
;-------------------------------------- 
; column 1 controls
Gui, Font, s8, MS Sans Serif
Gui, Add, GroupBox, vgb_filter x3 ym w300 r1, Filter Websites
Gui, Add, Radio, Checked0 grad_filter vrad_filter_selected x10 y20 Group, Selected
Gui, Add, Radio, Checked0 grad_filter vrad_filter_checked x+m, Checkmarked
Gui, Add, Radio, Checked0 grad_filter vrad_filter_both x+m, Both
Gui, Add, Radio, Checked1 grad_filter vrad_filter_none x+m, None 
Gui, Font, s16, Consolas
GuiControlGet, gb_filter, Pos
txt_x := gb_filterW + 20
txt_y := gb_filterY + 5
Gui, Add, Text, vtxt_num_selected cBlue x%txt_x% y%txt_y%,  Selected: XXXXX
Gui, Add, ListView, vlv_sites glv_sites hwndlv_sites_hwnd x3 w300 r20 Checked Sort AltSubMit Multi,Website|selected|checkmarked
Gui, Font, s8, MS Sans Serif
Gui, Add, Button, vbut_visit_site gbut_visit_site w80, &Visit Site 
Gui, Add, Button, vbut_add_to gbut_add_to x+m wp, &Add to...
Gui, Add, Button, vbut_refresh_history gbut_refresh_history x+m wp, &Refresh
GuiControlGet, lv_sites, Pos
; LV_ModifyCol(1,lv_sitesW)
lv_w := lv_sitesW -70
LV_ModifyCol(1,lv_w)
LV_ModifyCol(2,30)
LV_ModifyCol(3,30)
; column 2 controls
col2_x := lv_sitesX + lv_sitesW + 10
Gui, Font, s8 w400, MS Sans Serif
Gui, Add, GroupBox, vgb_select_by_category x%col2_x% y%lv_sitesY% r10, Select by Category
Gui, Add, Checkbox, gchk_select_by_category vchk_porn xp+10 yp+25, Porn Sites
Gui, Add, Checkbox, gchk_select_by_category vchk_streaming, TV/Movie Streaming
Gui, Add, Checkbox, gchk_select_by_category vchk_google_search, Google Search
Gui, Add, Checkbox, gchk_select_by_category vchk_news, News Sites
Gui, Add, Checkbox, gchk_select_by_category vchk_misc, Misc Sites
GuiControlGet, chk_misc, Pos
lbl_y := chk_miscY + chk_miscH + 40
Gui, Add, Text, vlbl_regex_search xp y%lbl_y%, % "&Select by Search (regex)"
Gui, Add, Edit, vedt_regex_search -Multi -Wrap  ; {Enter} hotkey executes the search 
;
GuiControlGet, gb_select_by_category, Pos
but_focused_y := gb_select_by_categoryY + gb_select_by_categoryH + 25
Gui, Add, Button, vbut_focused_website_links gbut_focused_website_links x%col2_x% y%but_focused_y% +Wrap, Manage &focused website's links
Gui, Add, Button, vbut_clear_all gbut_clear_all wp, % "&Clear All Select && Checked"
Gui, Add, Button, vbut_save_changes_to_chrome gbut_save_changes_to_chrome wp, % "Sa&ve Changes To Chrome"
Gui, Add, Button, vbut_delete_website gbut_delete_website r3 wp +Wrap, % "&Delete Website History"

;------------------------------------------------------------------------
; GUI - Default Event Procedures
;------------------------------------------------------------------------
lv_sites(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="")
{
    Critical
    Static capture_checkbox_click_sequence := False
    Static cccs_count := 0

; OutputDebug, DBGVIEWCLEAR
output_debug("ctrl_hwnd: " ctrl_hwnd ", gui_event: " gui_event )
           .   ", event_info: " event_info ", error_level: " error_level
/*
    If (gui_event == "K")
    {
        key := GetKeyName(Format("vk{:x}", A_EventInfo))
        output_debug("key: " key)
        If RegExMatch(key, "i)(Control|Shift|Alt)")
        {
            
        }
        Return
    }

    ;------------------------------------------------
    ; Clicking on listview checkbox "bug" workaround
    ;------------------------------------------------
    If (gui_event == "C")
    {
        output_debug("*** ENTERING capture_checkbox_click_sequence")
        capture_checkbox_click_sequence := True
        cccs_count := 1
        Return
    }
    If capture_checkbox_click_sequence
    {
        cccs_count++
        If (gui_event = "Normal") and (cccs_count = 2)
            Return
        If (gui_event == "I") and (cccs_count = 3)
        {
            If (error_level == "C")
                LV_Modify(event_info, "Check")
            Else if (error_level == "c")
                LV_Modify(event_info, "-Check")
            Return
        }
        If (gui_event == "f") and (cccs_count = 4)
        {
            output_debug("*** COMPLETED capture_checkbox_click_sequence")
            capture_checkbox_click_sequence := False
            Return
        }
        ; If any of the above conditions don't apply then let processing continue
        ; normally, we are in a checkbox click sequence any more.
        output_debug("*** CANCELLED capture_checkbox_click_sequence")
        capture_checkbox_click_sequence := False
    }
    ;-------------------------------------------------------
    ; End of clicking on listview checkbox "bug" workaround
    ;------------------------------------------------------
*/    
    If (gui_event = "DoubleClick")
        but_visit_site()
    Else If (gui_event == "I")
    {
        If InStr(error_level, "C", False)
            lv_toggle_checkboxes(error_level)
        Else If InStr(error_level, "S", False)
        {
            select_flag := InStr(error_level, "S", True)
            LV_Modify(event_info, "Col2", select_flag)
        }
    }           
    txt_num_selected := "Selected: " LV_GetCount("Selected")
    GuiControl,, txt_num_selected, %txt_num_selected%
    Return
}

lv_toggle_checkboxes(error_level)
{
    check_flag := InStr(error_level, "C", True)
    check_action := check_flag ? "Check":"-Check"
    selected_count := LV_GetCount("Selected")
    If (selected_count = 1)
    {
        row_num := LV_GetNext()
        LV_Modify(row_num,"Col3", check_flag)
        Return
    }
    ; Toggle checkbox for EVERY selected row 
    row_num := 0
    Loop
    {
        row_num := LV_GetNext(row_num)  
        If (row_num = 0)
            Break
        Else
        {
            LV_Modify(row_num, check_action)
            LV_Modify(row_num,"Col3", check_flag)
        }
    }
    Return
}           

chk_select_by_category(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="")
{
    If (gui_event = "Normal")
    {
        set_system_cursor("IDC_WAIT")
        row_num := LV_GetNext(0)
        LV_Modify(row_num, "-Focus -Select")
        Gui, +Disabled
        GuiControlGet, control_name, Name, %ctrl_hwnd%
        GuiControlGet, check_mark,, %ctrl_hwnd%
        select_by_category(control_name, check_mark)
    ; txt_num_selected := "Selected: " LV_GetCount("Selected")
    ; GuiControl,, txt_num_selected, %txt_num_selected%
        Gui, -Disabled
        restore_cursors()
    }
    Return
}

rad_filter(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="")
{
    GuiControl, -Redraw, lv_sites
    GuiControlGet, rad_filter_selected
    GuiControlGet, rad_filter_checked
    GuiControlGet, rad_filter_both
    GuiControlGet, rad_filter_none
    ; preserve unfiltered status of listview
    Loop, % LV_GetCount()
    {        LV_GetText(website, A_Index, 1)
        selected := is_lvrow_selected(A_Index, False)
        checkmarked := is_lvrow_checked(A_Index, False)
        LV_Modify(A_Index,, website, selected, checkmarked)
        save_lv_sites[website,1] := selected
        save_lv_sites[website,2] := checkmarked
    }   

    LV_Delete()
    For website, fields in save_lv_sites
    {
        add_record := False
        selected := fields[1]
        checkmarked := fields[2]
        If rad_filter_none
            add_record := True
        Else If rad_filter_selected and selected
            add_record := True
        Else If rad_filter_checked and checkmarked
            add_record := True
        Else If rad_filter_both and selected and checkmarked
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

but_delete_website(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="")
{
    sql_delete_cmds := ""
    row_num := 0
    countx := 0
    Loop
    {
        row_num := LV_GetNext(row_num, "Checked")
        If (row_num = 0)
            Break
        LV_GetText(website, row_num, 1)
        sql_delete_cmds .= "`r`nDELETE FROM urls WHERE url LIKE " chr(34) "%" website "%" chr(34) ";"
        countx++
    }
    sql_delete_cmds := SubStr(sql_delete_cmds, 3)   ; remove leading CRLF
    If (countx = 0)
        MsgBox, 64,, % "No websites are marked.`r`nNothing was done."
    Else
    {
        osqlite.Exec("BEGIN TRANSACTION;")
        If !osqlite.Exec(sql_delete_cmds)
        {           
            osqlite.Exec("ROLLBACK;")
            MsgBox, 16, Aborting - SQLite Error, % "Msg:`t" . osqlite.ErrorMsg . "`nCode:`t" . osqlite.ErrorCode
        }
        Else
        {
            osqlite.Exec("COMMIT TRANSACTION;")
            changes_made := True
            sql_query_results := ""     ; returned sql "view" object from the following query
            If !osqlite.GetTable("SELECT url FROM urls;", sql_query_results)
                MsgBox, 16, SQLite Error: GetTable, % "Msg:`t" . osqlite.ErrorMsg . "`nCode:`t" . osqlite.ErrorCode
            show_websites()
            MsgBox, 64, Success, % "Deleted " countx " websites.", 3
        }
    }   
    Return
}

but_save_changes_to_chrome()
{
    save_changes_to_chrome()
    Return
}

but_refresh_history(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="")
{
    If changes_made
    {
        MsgBox, 305, % "Warning", % "This will erase any unsaved changes.`r`n`r`nOk to continue?"
        IfMsgBox, Cancel
            Return
    }
    get_chrome_history()
    show_websites()
    Return
}

but_clear_all(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="")
{
    GuiControl, -Redraw, lv_sites
    GuiControl,,rad_filter_none, 1
    rad_filter()
    save_current_row_num := LV_GetNext(0, "Focused")
    save_current_row_num := (save_current_row_num = 0) ? 1 : save_current_row_num
    LV_Modify(0, "-Select -Check")
    GuiControl, Focus, lv_sites
    LV_Modify(save_current_row_num, "+Focus +Select")
    LV_Modify(save_current_row_num, "Vis")
    GuiControl, +Redraw, lv_sites
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
